---
ia-translate: true
title: "Como a null safety do Dart me ajudou a turbinar meus projetos"
description: "Migrei um app em produção e um pacote publicado para a null safety, e foi incrível!"
publishDate: 2021-06-23
author: wal33d
image: images/1HlInW7jXUifJIGBK1YEQEw.webp
category: other
layout: blog
---

> **Sobre o autor:** Waleed Arshad é um tecnólogo mobile de referência, um desenvolvedor cross-platform apaixonado e a primeira pessoa do Paquistão a se tornar Google Developer Expert em Flutter. Depois de se formar pela FAST Karachi, trabalha na indústria há mais de cinco anos e atualmente atua na equipe de Developer Experience do Flutter na Tendermint. Ele também lidera a comunidade Flutter do Paquistão.

<DashImage src="images/1HlInW7jXUifJIGBK1YEQEw.webp" alt="Close-up de um diff em um editor de código mostrando uma restrição de versão do Flutter SDK alterada para a null safety." />


Com o lançamento do Flutter 2, a null safety ficou disponível no canal stable do Flutter. Este post fala sobre minhas experiências pessoais ao migrar meus apps e pacotes para a null safety, além de criar apps com null safety do zero. Resumindo: os resultados foram incríveis!
> Se você não conhece o recurso de null safety do Flutter, confira o [anúncio da null safety](/blog/announcing-dart-null-safety-beta). Se quiser entender a null safety por completo, veja [a documentação do Dart sobre null safety](https://dart.dev/null-safety/understanding-null-safety).

Este artigo descreve duas das minhas experiências com a null safety:

* Migrar um app e um pacote

* Escrever código novo em um ambiente com null safety

### Migrando um app e um pacote {:#migrating-an-app-and-a-package}

Quando atualizei o Flutter para a versão 2.0 (a que suporta a null safety) e atualizei a versão do Dart SDK para 2.12 no arquivo `pubspec.yaml` do meu app Flutter, vi muitos erros. Inicialmente, eu quis tentar uma migração manual para a null safety (ou seja, migrar sem a ferramenta de migração), então comecei a resolver os erros de null safety na mão, adicionando pontos de interrogação e de exclamação por todo o meu código. Fiz tudo isso de propósito, só para entender o trabalho árduo que a equipe do Flutter teve com a [ferramenta de migração para null safety](https://dart.dev/null-safety/migration-guide#migration-tool), que automatiza o processo de alterar e atualizar o código! Depois de alguns experimentos, desfiz todas as mudanças manuais que tinha feito e usei a mágica da ferramenta para concluir a migração do meu app.

O aplicativo era um app experimental de estatísticas da COVID-19, e o código dele é totalmente open source. Você pode encontrá-lo [no GitHub](https://github.com/wal33d006/novel_covid_19).

Foi muito legal ver todas as mudanças de código que a ferramenta de migração fez no meu projeto, como adicionar pontos de interrogação em tipos nuláveis e adicionar pontos de exclamação onde a ferramenta detectou que o valor nunca seria nulo.

<DashImage src="images/14-Gy0ZFl5Sgn2Cw-LLn2lA.webp" alt="Diff da ferramenta de migração para null safety adicionando marcadores de nulável aos campos GlobalInfo, double e HomeCountry." />


A seguir, um exemplo de como a ferramenta de migração adiciona automaticamente pontos de interrogação e de exclamação. `_homeCountry` é uma propriedade nulável de uma classe chamada `HomeCountry` (que também é nulável). Por isso, para proteger o acesso a uma das propriedades de `_homeCountry`, a ferramenta adicionou o operador de interrogação.

<DashImage src="images/1Cg1Ol3w_bIs6IIh734CBug.webp" alt="Trecho de código mostrando a ferramenta de migração adicionando pontos de interrogação a propriedades nuláveis." />


Depois da migração, alguns problemas no código ficaram evidentes, **e essa é a melhor parte**.

<DashImage src="images/17nfnF2UAdK6zoIhX4wMG9w.webp" alt="Trecho de código revelando um problema exposto após a migração para a null safety." />


Um dos problemas era que algumas strings nuláveis estavam sendo passadas como lista para uma função interna do plugin [shared_preferences](https://pub.dev/packages/shared_preferences). Como esses valores eram nuláveis, a ferramenta transformou o tipo da lista inteira em `&lt;String?&gt;[]`*,* o que começou a gerar um erro, porque a função aceitava o tipo `&lt;String&gt;[]`*.*

<DashImage src="images/1ahhIw3H8kp5WGMjDmrSzLg.webp" alt="Erro do analyzer sobre passar strings nuláveis para uma função que espera strings não nuláveis." />


Uma solução simples para esse problema foi remover o ponto de interrogação e fazer o tipo da lista corresponder ao tipo do parâmetro da função. Quando fiz isso, o analyzer passou a dizer que um tipo nulável (`String?`) não pode ser atribuído a um tipo não nulável (`String`).

<DashImage src="images/1zHYqxaqdHWBdAILhoNMMrQ.webp" alt="Classe HomeCountry do Dart com campos String não nuláveis e parâmetros required no construtor." />


Para resolver o problema, tornei cada propriedade da classe `HomeCountry` não nulável e adicionei a palavra-chave `required` no construtor. Isso significava que agora era necessário passar os argumentos ao inicializar `HomeCountry`. Não precisei alterar a função `setHomeCountry`, porque as variáveis passadas para a lista agora eram não nuláveis.

Essa mudança me impediu de enviar por engano um valor nulo para o shared preferences no meu código, o que foi uma contribuição muito valiosa do recurso de null safety!

Outra coisa que a null safety encontrou foi um bug que poderia causar um crash em tempo de execução. Veja o trecho de código a seguir:

<DashImage src="images/1_uvcdlH2M7GvaW3tpgnTng.webp" alt="Aviso da IDE sobre o acesso a índice de lista, porque uma lista nulável pode ser nula antes da indexação." />


Como `list` era uma variável nulável, ler seus elementos por índice podia causar um crash. Depois de migrar para a null safety, não consegui compilar o app, porque não havia uma verificação de nulo antes de ler os valores dessa lista.

No fim, adicionei uma verificação de nulo para fazer o código compilar e evitar que o app travasse naquele ponto. É incrível como a migração me ajudou a encontrar um bug de verdade!

<DashImage src="images/1_a3XuVgmXlj9byIGPb-olg.webp" alt="Trecho de código mostrando uma verificação de nulo adicionada para tornar válido o código do setState." caption="O código do setState agora é válido porque `list` não é nula." />


Também migrei um pacote bem pequeno, que você pode encontrar no [pub.dev](https://pub.dev/), chamado [progress_indicators](https://pub.dev/packages/progress_indicators). Fiquei impressionado ao ver que a ferramenta de migração adicionou palavras-chave `late` em vez de pontos de interrogação, ao concluir que essas variáveis eram inicializadas antes de serem usadas.

<DashImage src="images/1Nfm_rVVsyCGnCLqWE1pvbQ.webp" alt="Trecho de código mostrando a ferramenta de migração usando a palavra-chave late em variáveis inicializadas." />


### Escrevendo código novo em um ambiente com null safety {:#writing-new-code-in-a-null-safe-environment}

Agora que o Flutter tem null safety, criar apps novos é uma experiência melhor para o desenvolvedor. Escrever código novo em um ambiente com null safety também oferece um entendimento melhor do fluxo do código, além de permitir escrever código à prova de crashes. Você não consegue mais criar código compilável com uma classe como esta:

```
class MyClass {
  String a;

  MyClass({this.a});
}
```


Esse código causa um erro de compilação que pede para marcar `a` como nulável, colocar a palavra-chave `required` no construtor ou adicionar um inicializador. O código está garantindo que `a` nunca seja nulo. Então, dependendo do seu caso de uso, você pode fazer isto:

```
class MyClass {
  String? a;

  MyClass({this.a});
}
```


Ou pode fazer isto:

```
class MyClass {
  String a;

  MyClass({required this.a});
}
```

> Repare que você não coloca um arroba (`@`) antes da palavra-chave `required`, a partir do Flutter 2 (e do Dart 2.12).

Ou pode manter `a` como opcional, mas adicionar um inicializador com um valor padrão caso nenhum seja passado:

```
class MyClass {
  String a;

  MyClass({this.a = ''});
}
```


Além disso, agora você pode criar variáveis nuláveis das suas próprias classes:

```
class MyClass {
  String? a;

  MyClass({this.a});
}

// somewhere in main code

MyClass? myClass;
```


Como `myClass` tem um tipo nulável, o compilador vai dar um erro se você escrever algo assim:

```
print(myClass.a);
```


Este é o erro:
> # The property ‘a’ can’t be unconditionally accessed because the receiver can be ‘null’.

Você pode corrigir esse erro adicionando um ponto de interrogação:

```
print(hello?.a);
```


A null safety do Dart garante que você escreva código menos vulnerável e mais seguro. Detectar erros relacionados a variáveis nulas em tempo de compilação é um acréscimo valioso à experiência de desenvolvimento. O exemplo anterior mostra como o compilador impede você de compilar o código sempre que detecta a possibilidade de uma exceção de ponteiro nulo causar um crash do app em tempo de execução. Isso mostra claramente que o compilador tenta escrever código null-safe o máximo possível (a menos que você use o operador `!` para forçar a remoção do nulável de tudo).

Em conclusão, a null safety sound do Dart é um impulso confiável para criar apps mais seguros, mais rápidos e mais confiáveis! A experiência de programação agora é muito mais organizada e estruturada. Recomendo que você migre seus apps antigos em Dart para a null safety, para entender como ela funciona. Talvez você tenha sorte de encontrar e corrigir alguns bugs no seu código antigo!

Boa programação! :)
