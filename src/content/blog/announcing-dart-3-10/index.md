---
ia-translate: true
title: "Anunciando o Dart 3.10"
description: "Hoje estamos animados em anunciar o lançamento do Dart 3.10!"
publishDate: 2025-11-12
author: antfitch
image: images/1AyAyohCAvBT-ta-nJPrkEg.webp
category: releases
layout: blog
---


<DashImage src="images/1AyAyohCAvBT-ta-nJPrkEg.webp" alt="Dart 3.10 release banner with the Dart logo and a bullseye icon." caption="Announcing Dart 3.10" />


Esta versão continua nosso foco em melhorar a experiência central do desenvolvedor. O novo recurso **dot shorthands** (**`.`**) vai ajudar você a escrever um código mais legível e menos verboso. Também estamos introduzindo um poderoso novo **sistema de plugins do analyzer**, que permite criar regras de análise estática personalizadas que se integram diretamente à sua IDE. E estamos felizes em anunciar que os **build hooks** agora estão estáveis!

Esta versão também traz várias melhorias para o pub.dev e para o gerenciamento de pacotes. Você vai encontrar novos recursos de busca na **aba “Likes”** do seu perfil, e os autores de pacotes agora podem **desativar a publicação manual** para mais segurança. Por fim, adicionamos um conjunto novo e mais específico de **anotações de deprecação** para dar controle mais refinado sobre a evolução da sua API.

Continue lendo para saber mais sobre estas e as outras melhorias do Dart 3.10.

## Atualizações da linguagem {:#language-updates}

### Dot shorthands 🆕 {:#dot-shorthands}

O Dart 3.10 introduz os [**dot shorthands**](https://dart.dev/language/dot-shorthands) (`.`). Este novo recurso permite omitir nomes redundantes de classes ou enums quando o compilador consegue inferir o tipo pelo contexto.

Vejamos um cenário comum: logging. Antes, você poderia ter escrito:

```dart
enum LogLevel { info, warning, error, debug }

void logMessage(String message, {LogLevel level = LogLevel.info}) {
  // ... implementation
}

// Somewhere else in your app
logMessage('Failed to connect to database', level: LogLevel.error);
```


Como o parâmetro `level` já espera um `LogLevel`, repetir o nome do enum é desnecessário. Com dot shorthands, agora você pode escrever:

```dart
enum LogLevel { info, warning, error, debug }

void logMessage(String message, {LogLevel level = .info}) {
  // ... implementation
}

// Somewhere else in your app
logMessage('Failed to connect to database', level: .error);
```


O código agora foca no *valor* (`.error`) em vez do *tipo* (`LogLevel`).

Dot shorthands não servem apenas para enums. Você também pode usá-los com construtores, métodos estáticos e campos estáticos. Para saber mais, leia nosso guia de [Dot shorthands](https://dart.dev/language/dot-shorthands).

## Atualizações de ferramentas {:#tools-updates}

### Plugins do analyzer 🆕 {:#analyzer-plugins}

Você já revisou código e pensou: “O analyzer não deveria conseguir pegar isso?”. Agora ele consegue.

O Dart 3.10 introduz um poderoso novo sistema de plugins para o analyzer do Dart. Ele permite escrever e usar suas próprias regras de análise estática, que se integram diretamente às IDEs e às ferramentas de linha de comando como `dart analyze` e `flutter analyze`. Você pode usar os [plugins do analyzer](https://dart.dev/tools/analyzer-plugins) para:

* Fazer valer regras específicas do projeto, como lints e avisos personalizados para manter as convenções da base de código da sua equipe.

* Evitar armadilhas comuns e boas práticas específicas do seu domínio.

* Automatizar mudanças no código fornecendo quick fixes e assists para corrigir problemas automaticamente ou migrar para novas APIs.

Esse novo sistema é resultado de um esforço arquitetural significativo para permitir um ecossistema rico de ferramentas impulsionadas pela comunidade, e gostaríamos de agradecer especialmente ao contribuidor da comunidade [Felipe Morschel](https://github.com/FMorschel) pelas correções e melhorias valiosas que fez no analyzer em geral.

Para usar um plugin do analyzer, basta adicioná-lo ao seu arquivo [analysis_options.yaml](https://dart.dev/tools/analysis#the-analysis-options-file):

```yaml
analyzer:
  plugins:
    - some_plugin
    - another_plugin
```


Para saber mais sobre como criar suas próprias regras personalizadas, veja a documentação sobre [como escrever um plugin do analyzer](https://dart.dev/tools/analyzer-plugins).

### Build hooks 🚀 {:#build-hooks}

Integrar código nativo (como C++, Rust ou Swift) em um pacote Dart costumava exigir o gerenciamento de arquivos de build complexos e específicos de cada plataforma, como CMake ou Gradle. Com o Dart 3.10, esse processo agora está muito mais simples.

Estamos felizes em anunciar que os **build hooks** (antes conhecidos como native assets) agora estão estáveis. Você pode usar esses hooks para compilar código nativo ou baixar assets nativos (como bibliotecas dinâmicas) e empacotá-los diretamente com o seu pacote Dart. Esse recurso poderoso permite reutilizar código ou bibliotecas nativas existentes dentro do seu pacote e elimina a necessidade de escrever arquivos de build separados, como SPM, Gradle ou CMake, para diferentes sistemas operacionais.

Para saber mais, veja a documentação sobre [como escrever um build hook](https://dart.dev/tools/hooks), ou assista ao [episódio do Flutter Build sobre build hooks](https://www.youtube.com/watch?v=AxNF5dj8HWQ).

### Lint de remoção de deprecations 🆕 {:#remove-deprecations-lint}

Quando você lança uma nova versão major de um pacote (como 1.0.0 ou 0.2.0), é uma boa prática remover quaisquer APIs que você tenha marcado como deprecated anteriormente. Isso mantém seu pacote limpo e evita que desenvolvedores usem código desatualizado. No entanto, é fácil esquecer esse passo durante o processo de release.

Para ajudar, introduzimos um novo lint: [**`remove_deprecations_in_breaking_versions`**](https://dart.dev/tools/linter-rules/remove_deprecations_in_breaking_versions/). Esse lint detecta elementos deprecated que sobraram quando a versão de um pacote é atualizada para uma nova versão major incompatível. Ao sinalizar esses casos, o lint ajuda a garantir que a API do seu pacote continue moderna e fácil de entender para seus usuários.

<DashImage src="images/1keU2TVVnlbe0e0UFtj3mwA.webp" alt="Example for the remove deprecations in breaking versions lint." caption="**`remove_deprecations_in_breaking_versions lint example`**" />


### Anotação @Deprecated ⬆️ {:#deprecated-annotation}

A anotação **@Deprecated** já existente é um instrumento grosseiro. Ela informa aos desenvolvedores que uma API não é mais recomendada, mas não permite nuances. Por exemplo, como sinalizar que uma classe não deve mais ser estendida, mas ainda pode ser instanciada?

Para dar aos autores de pacotes um controle mais preciso sobre a evolução da API, o Dart 3.10 introduz um conjunto de novas anotações de deprecação, mais específicas.

Agora você pode marcar como deprecated casos de uso específicos para classes e mixins:

* [@Deprecated.extend()](https://api.dart.dev/dev/latest/dart-core/Deprecated/Deprecated.extend.html): A possibilidade de estender uma classe está deprecated.

* [@Deprecated.implement()](https://api.dart.dev/dev/latest/dart-core/Deprecated/Deprecated.implement.html): A possibilidade de implementar uma classe ou mixin está deprecated.

* [@Deprecated.subclass()](https://api.dart.dev/dev/latest/dart-core/Deprecated/Deprecated.subclass.html): A possibilidade de criar subclasses (estender ou implementar) uma classe ou mixin está deprecated.

* [@Deprecated.mixin()](https://api.dart.dev/dev/latest/dart-core/Deprecated/Deprecated.mixin.html): A possibilidade de fazer mixin de uma classe está deprecated.

* [@Deprecated.instantiate()](https://api.dart.dev/dev/latest/dart-core/Deprecated/Deprecated.instantiate.html): A possibilidade de instanciar uma classe está deprecated.

Além disso, agora você pode sinalizar que um parâmetro opcional vai se tornar obrigatório em uma versão futura, usando [@Deprecated.optional()](https://api.dart.dev/dev/latest/dart-core/Deprecated/Deprecated.optional.html).

## Atualizações do pub {:#pub-updates}

### Busca, ordenação e opção de descurtir seus pacotes favoritos 🆕 {:#search-sort-and-unlike-support-for-your-favorite-packages}

Gerenciar seus pacotes favoritos no pub.dev acaba de ganhar uma grande melhoria. Você pode fazer isso pela funcionalidade de busca ou pela [aba Likes](https://pub.dev/my-liked-packages) do seu perfil, onde agora pode buscar, ordenar e filtrar os pacotes que curtiu com os mesmos controles familiares que usa nas buscas comuns. Isso inclui ordenar por curtidas, pub points e popularidade. Também melhoramos a interface para descurtir pacotes, facilitando manter sua lista de pacotes curtidos organizada e atualizada.

<DashImage src="images/1cOONo9VV-HsJPA0WMv1COQ.webp" alt="Pub.dev Likes tab with search, sort, and unlike support." caption="Search, sort, and unlike support for your favorite packages in your Likes tab" />


Se você preferir buscar seus pacotes curtidos pela funcionalidade de busca, basta adicionar `is:liked-by-me` à sua consulta.

<DashImage src="images/1cO5K265sp2QbF-vNgcpFzQ.webp" alt="Pub.dev search page filtered to packages you liked." caption="Search, but only include packages you like" />


### Ativar ou desativar a publicação manual 🆕 {:#enable-or-disable-manual-publishing}

Para aumentar a segurança e evitar publicações acidentais, agora você pode desativar a publicação manual (`pub publish`) dos seus pacotes. Isso é ideal para pacotes que têm um fluxo de publicação automatizado ou que não estão mais sendo publicados ativamente.

Ao desativar a publicação manual, você impede atualizações de pacotes feitas com credenciais pessoais, reduzindo o risco de uma publicação não autorizada ou acidental.

Você pode controlar esse recurso na aba **Admin** do seu pacote, usando a caixa de seleção “Enable manual publishing”.

<DashImage src="images/1qBE5Jhe138ktNrcBIy5L1w.webp" alt="Enable or disable manual publishing in the Admin tab." caption="Enable or disable manual publishing in the Admin tab" />


## Para encerrar {:#wrap-up}

A versão Dart 3.10 traz uma série de melhorias focadas em produtividade do desenvolvedor, ferramentas e na saúde geral do ecossistema de pacotes. De recursos da linguagem, como dot shorthands, que tornam seu código mais conciso, a novas capacidades de ferramentas, como plugins do analyzer e build hooks estáveis, esperamos que esta versão ajude você a construir apps ainda melhores.

Somos muito gratos às muitas engenheiras e equipes que contribuíram para esta versão, incluindo um agradecimento especial aos nossos contribuidores da comunidade, que ajudam a tornar o Dart melhor para todos.

Estamos animados para ver o que você vai construir com o Dart 3.10. Para começar, você pode obter o SDK do Dart 3.10 hoje mesmo. Para uma lista completa de todos os recursos novos e atualizados, confira o [changelog do SDK do Dart](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md).
