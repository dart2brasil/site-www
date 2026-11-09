---
ia-translate: true
title: "Anunciando o Dart 3.7"
description: "É um novo ano, e hora de uma nova versão estável do Dart. Bem-vindo ao Dart 3.7!"
publishDate: 2025-02-12
author: mbelanger
image: images/1tdCaUfGrIk42FIuu2qs9Yw.webp
category: releases
layout: blog
---


O tema desta versão é *produtividade do desenvolvedor*. Tornamos a linguagem Dart mais consistente ao ajustar a forma como ela trata variáveis curinga. Também há um estilo totalmente novo no formatador do Dart, novos quick fixes e lints no analisador e vários recursos legais novos no pub.dev. Vamos aos detalhes!

<DashImage src="images/1tdCaUfGrIk42FIuu2qs9Yw.webp" alt="Banner de lançamento do Dart 3.7 com o logo do Dart e um ícone de alvo animado." caption="Anunciando o Dart 3.7" />


## Atualização sobre macros {:#macros-update}

Recentemente publicamos atualizações no [gerenciador de issues](https://github.com/dart-lang/language/issues/1482#issuecomment-2622895490), bem como um [post no blog](/blog/an-update-on-dart-macros-data-serialization), informando que estamos interrompendo o trabalho no nosso recurso experimental de macros. Agradecemos à comunidade por ser tão compreensiva diante desse desfecho infeliz.

Com essa mudança, porém, a equipe recupera parte da capacidade para investir em outros desenvolvimentos valiosos. Já estamos analisando [melhorias no desempenho do build_runner](https://github.com/dart-lang/build/issues/3800), ainda esperamos lançar o [recurso de linguagem de augmentations](https://github.com/dart-lang/language/blob/main/working/augmentation-libraries/feature-specification.md) (talvez em uma forma um pouco diferente) e esperamos encontrar formas novas e mais diretas de dar suporte à modelagem de dados e ao [serialização e desserialização](https://github.com/dart-lang/language/issues/4232) (de e para JSON, por exemplo).

## Recurso de linguagem: variáveis curinga {:#wildcard-variables-language-feature}

Variáveis locais e parâmetros chamados `_` agora são o que as linguagens funcionais chamam de "curingas" (*wildcards*). Isso significa que o nome é um marcador de posição e não declara nenhuma variável de fato.

Atualmente, em Dart, é comum usar `_` como nome de um parâmetro de callback quando o corpo do callback não precisa usar o argumento, assim:

```dart
void announceCompletion(Future<void> future) {
  future.then((_) { // <--
    print('Complete!');
  });
}
```


Mas, se um callback tem vários parâmetros que você não precisa usar, acaba nomeando-os `_`, `__`, `___` etc., porque do contrário os nomes colidem. Agora, no Dart 3.7, parâmetros e variáveis locais chamados `_` não criam uma variável de fato, então não há possibilidade de colisão de nomes. Você pode usar `_` em vários parâmetros, como em:

```dart
void announceFailure(Future<void> future) {
  future.onError((_, _) { // <--
    print('Error!');
  });
}
```


Se você tem código que declara um parâmetro ou variável chamado `_` *e o usa*, esse código não vai mais funcionar no Dart 3.7. Por exemplo:

```dart
var [1, 2, 3].map((_) {
  return _.toString();
  //     ^ Error! Reference to unknown variable.
});
```


Nessa situação, você terá que renomear o parâmetro ou a variável local. Essa mudança de linguagem se aplica apenas a parâmetros e variáveis locais (não a variáveis de nível superior ou membros), então você pode fazer essa renomeação sem quebrar a API pública da sua biblioteca.

As variáveis curinga são um recurso pequeno que torna a linguagem mais consistente. Variáveis chamadas `_` em [padrões](https://dart.dev/language/patterns) sempre se comportaram dessa forma:

```dart
var [_, _, third, _, _] = [1, 2, 3, 4, 5];
print(third); // Prints "3".
```


Agora parâmetros e variáveis locais se comportam da mesma forma.

## Novo estilo de formatação no formatador do Dart {:#new-formatting-style-in-the-dart-formatter}

O Dart 3.7 inclui um formatador do Dart (`dart format`) reescrito, com um [novo estilo de formatação](https://github.com/dart-lang/dart_style/issues/1253). O novo estilo se parece com o que você obtém ao adicionar vírgulas finais nas listas de argumentos, só que agora o formatador adiciona e remove essas vírgulas para você. Por exemplo:

```dart
// Old style:
void writeArgumentList(
    Token leftBracket, List<AstNode> elements, Token rightBracket) {
  writeList(
      leftBracket: leftBracket,
      elements,
      rightBracket: rightBracket,
      allowBlockArgument: true);
}

// New style:
void writeArgumentList(
  Token leftBracket,
  List<AstNode> elements,
  Token rightBracket,
) {
  writeList(
    leftBracket: leftBracket,
    elements,
    rightBracket: rightBracket,
    allowBlockArgument: true,
  );
}
```


Esta é uma grande mudança tanto na ferramenta, quanto na saída que ela produz e na forma como se comporta. Para tornar a transição o mais suave possível, o estilo de formatação que você obtém depende da [versão da linguagem](https://dart.dev/language/versioning) do código que você está formatando. Se a versão da linguagem for 3.6 ou anterior, o código é formatado com o estilo antigo. Se for 3.7 ou posterior, ele recebe o novo estilo.

Quando você atualizar seu pacote para usar o Dart 3.7 alterando a restrição de SDK no pubspec do pacote (e executando `dart pub get`!), você estará optando pelo novo estilo de formatação.

Para determinar a versão da linguagem de cada arquivo que formata, o `dart format` procura um `package_config.json`. Isso significa que **você precisa executar `dart pub get` antes de formatar o código do seu pacote**. Se você tem verificações de formatação no seu servidor de integração contínua, certifique-se de que ele também execute `dart pub get`.

Não pretendemos oferecer suporte aos dois estilos indefinidamente. Em algum momento no futuro, quando a maior parte do ecossistema estiver na 3.7 ou posterior, o suporte ao estilo antigo será removido.

O novo estilo inclui alguns recursos pedidos há muito tempo:

* **Configuração de largura de página em todo o projeto.** Agora você pode configurar a largura de página de formatação preferida para todo o projeto no seu arquivo `analysis_options.yaml`, assim:

```yaml
    formatter:
      page_width: 123
```


* **Excluir uma região de código da formatação.** Você pode usar um par de comentários marcadores especiais para excluir uma região de código da formatação automática:

```dart
    main() {
      // dart format off
      no   +   formatting     +     here;
      // dart format on
    }
```


Há também uma **mudança incompatível**. O formatador não oferece mais suporte a `dart format --fix`. Em vez disso, use `dart fix` para aplicar todas as correções que o `dart format` fazia e mais algumas.

Você pode encontrar mais detalhes no [CHANGELOG](https://github.com/dart-lang/dart_style/blob/cea5a1a3e974c5065e6f4cc19b2838cd62448f0a/CHANGELOG.md#300) e na [FAQ](https://github.com/dart-lang/dart_style/wiki/FAQ).

## Quick fixes atualizados e novos lints no analisador do Dart {:#updated-quick-fixes-and-new-lints-in-the-dart-analyzer}

Estamos sempre melhorando ativamente o Dart para aumentar a produtividade do desenvolvedor, e isso significa melhorar o analisador com novos lints, quick fixes e assists no Dart 3.7. Uma adição notável é o lint `unnecessary_underscores`, que dá suporte ao novo recurso de variáveis curinga.

Entre a ampla gama de novos quick fixes e assists que o Dart 3.7 inclui estão correções para problemas comuns, como palavras-chave `await` ausentes, prefixos de import incorretos e violações de regras de lint como `cascade_invocations`. Há também assists práticos para refatorar código, como converter blocos `else` em `else if` e envolver widgets do Flutter com `Expanded` ou `Flexible`.

Você pode encontrar mais detalhes sobre tudo isso, e muito mais, na lista completa de [mudanças do analisador](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#analyzer-1).

## Avançando na plataforma web do Dart {:#moving-forward-on-the-dart-web-platform}

Há um ano, introduzimos [novas bibliotecas e pacotes](/blog/new-in-dart-3-3-extension-types-javascript-interop-and-more) para interoperar com JavaScript e as APIs do navegador a partir do Dart. Daqui em diante, a principal biblioteca de JavaScript é a [`dart:js_interop`](https://api.dart.dev/dart-js_interop/dart-js_interop-library.html). Para as APIs do navegador, use o [`package:web`](https://pub.dev/packages/web).

Como parte do nosso esforço contínuo para levar os ecossistemas do Dart e do Flutter a APIs compatíveis com WebAssembly, estamos descontinuando as APIs legadas associadas no SDK do Dart. Sete bibliotecas do SDK do Dart estão descontinuadas na versão 3.7:

* `dart:html`

* `dart:indexed_db`

* `dart:js`

* `dart:js_util`

* `dart:web_audio`

* `dart:web_gl`

Planejamos remover essas bibliotecas no final de 2025. Você pode conhecer os substitutos delas na [página de interoperabilidade com JavaScript](https://dart.dev/interop/js-interop).

## Novos recursos de produtividade no site de pacotes do pub.dev {:#new-productivity-features-on-the-pub-dev-package-site}

Em dezembro lançamos as [contagens de download de pacotes](/blog/announcing-dart-3-6) no pub.dev. Elas mostram os downloads mensais junto com um pequeno gráfico com os downloads semanais ao longo do tempo.

Hoje, estendemos isso com suporte para visualizar as contagens de download por versão do pacote. Agora é possível ter uma indicação de quantos consumidores de um pacote já migraram para a versão mais recente (ou apenas para a versão principal mais recente). Esses dados foram pensados para ajudar os autores de pacotes a avaliar o valor de portar correções para versões principais mais antigas de um pacote.

<DashImage src="images/067af_RLHqiWxsXXL.webp" alt="Gráfico mostrando os downloads semanais de uma versão específica de um pacote." caption="Gráfico de downloads semanais, com as versões separadas" />


<DashImage src="images/0Cctb0O4F1D-0YYHY.webp" alt="Outro gráfico mostrando os downloads semanais, mas empilhado por versão." caption="Gráfico de downloads semanais, com as versões empilhadas" />


**Modo escuro para o pub.dev**

O modo escuro para o pub.dev é há muito tempo um [pedido popular](https://github.com/dart-lang/pub-dev/issues/4416), e a partir de hoje já é possível alternar o pub.dev para o modo escuro. Essa opção afeta tanto as páginas dos pacotes quanto a documentação da API dos pacotes hospedada no pub.dev.

<DashImage src="images/0j4Vh_XoLle5-RMQ2.webp" alt="Captura de tela mostrando a opção de modo escuro e a interface no pub.dev." caption="Modo escuro para o pub.dev" />


**Tópicos para o pub.dev**

No ano passado, lançamos o suporte a [tópicos](https://pub.dev/topics) no pub.dev. Você pode [adicionar tópicos](https://dart.dev/tools/pub/pubspec#topics) ao seu `pubspec.yaml` e, se encontrar tópicos relacionados que deveriam ser unificados, pode propor a [canonicalização](https://github.com/dart-lang/pub-dev/blob/master/doc/topics.yaml) com um pull request.

Quem navega pelo pub.dev pode clicar nos tópicos para explorar pacotes relacionados. Antes, já tínhamos introduzido a possibilidade de pesquisar tópicos no pub.dev usando [palavras-chave de pesquisa](https://pub.dev/help/search) (como "topic:widget"), mas nem sempre era fácil descobrir essas palavras-chave. Então, lançamos um autocompletar, no estilo de IDE, para as palavras-chave de pesquisa do pub.dev. Você pode acioná-lo pressionando ctrl+espaço ou ele é disparado automaticamente quando você digita um prefixo correspondente, como "topic:" ou "license:".

<DashImage src="images/0kd0l2oZq_mg9g8YO.webp" alt="Captura de tela mostrando o autocompletar, no estilo de IDE, para as palavras-chave de pesquisa no pub.dev." caption="Palavras-chave de pesquisa de tópicos" />


## Encerramento {:#wrap-up}

É isso por hoje para o Dart 3.7. Como sempre, conte para a gente o que você achou! E não deixe de conferir o post do blog sobre o [lançamento do Flutter 3.29]({{site.flutter-blog}}/whats-new-in-flutter-3-29) de hoje também. Até a próxima!
