---
ia-translate: true
title: "Anunciando o beta do null safety do Dart"
description: "Começando a jornada para migrar pacotes para um estado sólido e mais seguro"
publishDate: 2020-11-19
author: mit-mit
image: images/1kr-aQjGvnhY0JDCx1CGzRg.webp
category: announcements
layout: blog
---


*Publicado também aqui e no [blog do Flutter]({{site.flutter-blog}}).*

Hoje anunciamos que **o null safety sólido está disponível em beta** para o Dart e o Flutter. O null safety é o nosso mais recente grande recurso de produtividade, criado para [ajudar você a evitar erros de null](https://dart.dev/null-safety), uma classe de bugs que costuma ser difícil de identificar. Se você está procurando um resumo rápido de por que estamos empolgados com o null safety, confira este novo vídeo:

<YoutubeEmbed id="iYhOU9AuaFs" title="Null safety in Dart - Introduction" fullwidth="true"/>


Com o null safety chegando à fase beta, **é hora de começar a migração pela comunidade** dos milhares de pacotes disponíveis no [pub.dev](https://pub.dev/). Migramos as bibliotecas core do Dart, o framework Flutter e [mais de 40](https://pub.dev/packages?q=&prerelease-null-safe=1) pacotes do Dart e do Flutter. Com isso, esperamos ver a comunidade abraçar o null safety migrando os seus pacotes.

<DashImage src="images/1kr-aQjGvnhY0JDCx1CGzRg.webp" alt="Linha do tempo do null safety sólido do Dart, mostrando as prévias técnicas de junho e outubro de 2020, o beta em novembro de 2020 e a versão estável prevista para o início de 2021." />


Com o beta, também estamos entrando na reta final antes de lançar uma versão estável do recurso de null safety. Esperamos que você use o recurso e nos conte se partes dele podem ser aprimoradas, se as mensagens da interface podem ficar mais fáceis de entender ou se a documentação pode ficar mais clara. Estamos **muito ansiosos pelo [seu feedback](https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here)**.

## Optando pelo null safety {:#opting-in-to-null-safety}

Antes de discutirmos a migração para o null safety, é importante reforçar que (como afirmado em nossos [princípios de null safety](https://dart.dev/null-safety#null-safety-principles)) você controla quando começar a adotar o null safety. Apps e pacotes só vão rodar com null safety se a [restrição mínima de SDK do Dart](https://dart.dev/null-safety#enable-null-safety) for, no mínimo, uma pré-versão do Dart 2.12:

```
environment:
  sdk: "**>=2.12.0-0** <3.0.0"
```


Para testar isso, tente criar um pequeno app de exemplo com null safety (por exemplo, usando `dart create`) contendo um código como o mostrado abaixo. Você pode então tentar executar o app antes e depois de alterar a restrição de SDK e executar `dart pub get`, e observar como o comportamento do programa muda. (Certifique-se de usar um SDK que informe 2.12 em `dart --version`.)

```
***bin/hello.dart:***
...
void main() {
  var hello = 'Hello Dart developers';
  if (someCondition) {
    hello = null;
  }
  print(hello);
}

Before changing the SDK constraint:
$ dart run

null

After changing the SDK constraint (and running dart pub get):
$ dart run

bin/hello.dart:6:13: Error: Null can't be assigned to a variable of type 'String' because 'String' is not nullable.

    hello = null;
            ^
```


## Migrando para o null safety {:#migrating-to-null-safety}

Para migrar um pacote (ou um app simples) para o null safety, siga estes cinco passos, todos documentados no [guia de migração](https://dart.dev/null-safety/migration-guide) em dart.dev.

### Passo 1: verifique se suas dependências estão prontas {:#step-1-check-if-your-dependencies-are-ready}

Recomendamos fortemente migrar o código em ordem, começando pelas folhas do grafo de dependências. Por exemplo, se C depende de B, que depende de A, migre A para o null safety primeiro, depois B e então C. Essa ordem vale quer A, B e C sejam bibliotecas, pacotes ou apps.

<DashImage src="images/0fM8TG0L56zVeJVlG.webp" alt="Um grafo de dependências mostrando a ordem de migração de pacotes para o null safety, de baixo para cima." />


Por que a ordem é importante? Embora você consiga avançar na migração do código antes que suas dependências migrem, corre o risco de precisar de uma segunda passada de migração se elas mudarem suas APIs durante a migração. Se algumas das suas dependências ainda não tiverem null safety, considere entrar em contato com os publicadores dos pacotes usando os dados de contato listados para cada pacote no pub.dev.

### *Verificando se as dependências estão prontas* {:#verifying-that-dependencies-are-ready}

Para verificar se o seu app ou pacote está pronto para começar a migração, você pode usar `dart pub outdated` no modo null-safety. O exemplo abaixo mostra que este app está pronto para migrar se atualizar suas dependências para as pré-versões de `path`, `process` e `pedantic`, listadas na coluna **Resolvable**.

<DashImage src="images/0zrUdYSzsjWZGr7Or.webp" alt="Saída do terminal do comando dart pub outdated mostrando o status da migração para o null safety." />


Se o suporte ao null safety estiver disponível em novas versões menores, você verá essas versões na coluna **Upgradable**. Muitas vezes, o suporte ao null safety estará disponível em novas versões principais; nesse caso, você verá as versões listadas em **Resolvable** na saída do outdated. Para atualizar para essas versões, edite o seu arquivo `pubspec.yaml` para permitir essas versões principais. Por exemplo, você pode trocar
`process: ^3.0.13` por `process: ^4.0.0-nullsafety`.

Você também pode encontrar pacotes com suporte ao null safety no pub.dev usando as novas tags **Null safety** nas páginas dos pacotes (por exemplo, [collection 1.15](https://pub.dev/packages/collection/versions/1.15.0-nullsafety.5)) e a nova opção de pesquisa **avançada** de [null safety](https://pub.dev/packages?q=&prerelease-null-safe=1).

<DashImage src="images/1P2ufPitLRaJRAD__KUfbvg.webp" alt="Interface de pesquisa do pub.dev com o filtro de null safety marcado nas opções de pesquisa avançada." />


### Passo 2: migre usando a ferramenta de migração {:#step-2-migrate-using-the-migration-tool}

Se suas dependências estiverem prontas, você pode prosseguir com a migração do seu app ou pacote usando a ferramenta de migração, `dart migrate`.

A ferramenta de migração é interativa, então você pode revisar as propriedades de nulabilidade que ela inferiu. Se você discordar de alguma das conclusões da ferramenta, pode adicionar dicas de nulabilidade para alterar a inferência. Adicionar algumas dicas de migração pode ter um grande impacto na qualidade da migração.

<DashImage src="images/0dPlSded52Mt6P5tY.webp" alt="A interface interativa da ferramenta dart migrate mostrando as mudanças de código propostas." />


Alguns poucos autores de pacotes Dart testaram a migração usando versões de prévia iniciais do null safety, e o feedback deles foi encorajador. O guia de migração traz dicas adicionais sobre como usar a ferramenta de migração.

### Passo 3: faça a análise estática do código migrado {:#step-3-statically-analyze-your-migrated-code}

Atualize seus pacotes usando `pub get` na sua IDE ou na linha de comando. Em seguida, use sua IDE ou a linha de comando para fazer a análise estática do seu código Dart:

```
$ dart pub get
$ dart analyze
```


Ou, no seu código Flutter:

```
$ flutter pub get
$ flutter analyze
```


### Passo 4: garanta que os testes passem {:#step-4-ensure-tests-pass}

Execute os seus testes e garanta que eles passem. Talvez seja necessário atualizar testes que esperam valores nulos, caso você tenha alterado o código do pacote para não permitir mais nulos.

### Passo 5: publique o seu pacote com null safety {:#step-5-publish-your-null-safe-package}

Quando a migração estiver concluída e os testes estiverem passando, você pode publicar o seu pacote como uma pré-versão. Aqui está um breve resumo das boas práticas:

* Incremente o número da versão para a próxima versão principal (por exemplo, de `2.3.x` para `3.0.0`). Essa boa prática garante que os usuários do seu pacote não façam a atualização antes de estarem prontos para usar o null safety, e dá a você liberdade para refatorar suas APIs para aproveitar ao máximo o null safety.

* Versione e publique o seu pacote como uma [versão de prévia no pub.dev](https://dart.dev/tools/pub/publishing#publishing-prereleases). (Por exemplo, use `3.0.0-nullsafety.0`, e não `3.0.0`.)

Para todos os detalhes sobre migração e versionamento, veja o [guia de migração](https://dart.dev/null-safety/migration-guide).

## Os benefícios do null safety sólido {:#the-benefits-of-sound-null-safety}

Nossos posts anteriores sobre as prévias técnicas do null safety [no Dart](/blog/announcing-sound-null-safety) e [no Flutter]({{site.flutter-blog}}/dart-sound-null-safety-technical-preview-2) discutiram os benefícios do null safety por meio de vários exemplos. Agora que o null safety está perto de ser concluído, estamos vendo vários exemplos reais desse benefício.

### Código mais seguro {:#safer-code}

Recentemente, [descobrimos um bug](https://github.com/flutter/flutter/issues/69863) no canal master do Flutter em que vários comandos da ferramenta `flutter` travavam em certas configurações de máquina com um erro de null: `The method '&gt;=' was called on null`. O problema subjacente foi um pull request recente para adicionar suporte à detecção do Android Studio 4.1. Esse PR adicionou um código como este:

```
final int major = version?.major;
final int minor = version?.minor;
if (globals.platform.isMacOS) {
  /// plugin path of Android Studio changed after version 4.1.
  if (major >= 4 && minor >= 1) {
    ...
```


Consegue identificar o erro? Como a versão pode ser null, tanto `major` quanto `minor` também podem ser null. Esse bug pode parecer fácil de notar isoladamente, mas, na prática, código como este escapa o tempo todo, mesmo com um processo de revisão de código rigoroso como o usado no repositório do Flutter. Com o null safety, a análise estática [detecta esse problema imediatamente](https://dartpad.dev/0e9797be7488d8ec6c3fca92b7f2740f):

<DashImage src="images/0AwqXx58arqVt6PhL.webp" alt="Uma interface de editor mostrando um erro de compilação porque uma variável anulável é usada sem uma verificação de null." />


Esse foi um erro bem simples. Durante nosso uso inicial do null safety em código interno no Google, vimos erros muito mais intrincados serem detectados e depois resolvidos com o null safety. Aqui estão alguns exemplos:

* Uma equipe interna descobriu que frequentemente verificava valores null em código que o null safety sabia que nunca poderia ser null. Esse problema era mais comum em código que usa [protobuf](https://developers.google.com/protocol-buffers), em que campos opcionais retornam um valor padrão quando não definidos, e nunca null. Isso fazia com que o código verificasse incorretamente a condição padrão, confundindo valores padrão com valores null.

* A equipe do Google Pay encontrou bugs no código Flutter deles em que a aplicação falhava ao tentar acessar objetos `State` do Flutter fora do contexto de um `Widget`. Antes do null safety, esses acessos retornavam null e mascaravam o erro; com o null safety, a análise sólida determinou que essas propriedades nunca poderiam ser null e gerou um erro de análise.

* A equipe do Flutter encontrou um bug em que o engine do Flutter poderia travar se null fosse passado para o parâmetro `scene` em `Window.render()`. Durante a migração para o null safety, eles adicionaram uma dica para [marcar Scene como não anulável](https://github.com/cbracken/engine/blob/bad869e229a8a02cad6e63d12e80807b33b5c12f/lib/ui/window.dart#L1069) e, então, conseguiram prevenir facilmente possíveis travamentos de app que null teria provocado se fosse passado.

### Aproveitando o null safety sólido durante a compilação {:#leveraging-sound-null-safety-during-compilation}

A solidez do null safety do Dart tem outra implicação bem-vinda: significa que os compiladores do Dart podem aproveitar as informações de nulabilidade. Isso pode potencialmente tornar seus programas menores e mais rápidos. Ainda não temos muitos apps reais totalmente migrados para o null safety sólido (já que estamos apenas começando a migração, pelo ecossistema, dos pacotes que esses apps usam para obter a solidez), mas estamos vendo resultados muito animadores no framework core.

Recentemente, fizemos uma recompilação de teste do exemplo [hello_world](https://github.com/flutter/flutter/blob/master/examples/hello_world/lib/main.dart) para medir o impacto do null safety no tamanho do app. Este é um exemplo mínimo que simplesmente exibe "hello world". Ao [comparar](https://gist.github.com/mit-mit/64e160f9dc3bf6c69c7ef2f81384594a) o tamanho total do código compilado, o tamanho do código não comprimido (instalado no dispositivo) diminuiu 3,5% sem fazer nada além de recompilar com o null safety sólido. Isso foi possível, apesar de este app ter apenas 10 linhas de código, porque o tamanho do código de todas as bibliotecas incluídas diminuiu; por exemplo, o próprio framework Flutter (`package:flutter`) diminuiu 3,9%.

Quanto à velocidade do código, ter que impor um sistema de tipos sólido potencialmente adiciona overhead. No entanto, ter menos verificações de null também pode tornar o código mais rápido. Nossa análise inicial dos benchmarks mostra que o desempenho está em pé de igualdade com as versões anteriores, e que as novas informações adicionais de tipo criam a possibilidade de fazermos novos tipos de melhorias de desempenho no futuro. Planejamos escrever mais sobre nosso trabalho de desempenho em posts futuros.

Em alguns casos, já vimos o null safety gerar ganhos de desempenho, normalmente quando a migração para o null safety revelou uma falha na lógica do código. Por exemplo, encontramos um problema no cache de layout de texto da web do Flutter. Esse cache usava uma chave que podia ser nula e, depois, uma lógica para usar `TextAlign.start` quando o valor era null. Essa lógica causava uma falha no cache, em que os elementos pareciam ter mudado mesmo ainda tendo um valor padrão. Como resultado, havia muitas falhas de cache. Adicionar um getter `textAlign` não anulável ajudou a corrigir a falha de cache, resultando em um **aumento de 14x** no desempenho da renderização de texto nos casos em que o texto está em cache.

## Comece hoje! {:#get-started-today}

As versões beta do Dart e do Flutter que contêm null safety já estão prontas. Se você desenvolve com Flutter, pode mudar para o beta com `flutter channel beta` seguido de `flutter upgrade`. Caso contrário, você pode obter o SDK do Dart independente no [arquivo de SDKs do Dart](https://dart.dev/tools/sdk/archive#beta-channel).

Se você desenvolve pacotes, incentivamos a ler nosso [guia de migração](https://dart.dev/null-safety/migration-guide) e planejar a sua migração. Por favor, [nos conte](https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here) sobre quaisquer problemas ou sugestões que você tiver.

Se você é desenvolvedor de apps, pode preferir adiar a migração até que o recurso esteja nos nossos canais estáveis. Planejamos tratar rapidamente o feedback do beta, corrigindo quaisquer problemas restantes. É difícil definir um cronograma concreto para quando o null safety estará em uma versão estável, mas estamos pensando no início do próximo ano.

Obrigado pelo seu apoio e feedback enquanto trabalhamos para tornar o Dart uma linguagem mais robusta e o Flutter um framework mais forte!
