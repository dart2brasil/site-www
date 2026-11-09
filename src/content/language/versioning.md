---
ia-translate: true
title: Versionamento da linguagem
description: >-
  Saiba como o versionamento da linguagem Dart permite a evolução da linguagem
  e como configurar as versões da linguagem do seu projeto e de suas bibliotecas.
---

## Visão geral {:#overview}

Um único Dart SDK pode suportar simultaneamente
múltiplas versões da linguagem Dart.
O compilador determina para qual versão o código foi escrito,
e o interpreta de acordo com essa versão.

O versionamento da linguagem se torna importante nas raras ocasiões em que o Dart
introduz uma funcionalidade incompatível, como [null safety][].
Quando o Dart introduz uma mudança que quebra compatibilidade, código que
compilava antes pode deixar de compilar.
O versionamento da linguagem permite definir a versão da linguagem de cada biblioteca
para manter a compatibilidade.

No caso do null safety, os SDKs do Dart 2.12 até 2.19 permitiam
que você _escolhesse_ atualizar seu código para usar null safety.
O Dart usa o versionamento da linguagem para permitir que código non-null-safe rode
junto com código null-safe.
Essa decisão possibilitou a migração de código non-null-safe para null-safe.
Para ver um exemplo de como um app ou pacote pode migrar para uma nova
versão da linguagem com uma funcionalidade incompatível, confira este artigo sobre
[Migração gradual para null safety em grandes projetos Dart][Gradual null safety migration for large Dart projects].

Cada pacote tem uma versão padrão da linguagem igual ao **limite inferior**
da [restrição de SDK][SDK constraint] no arquivo `pubspec.yaml`.

**Por exemplo:** a seguinte entrada em um arquivo `pubspec.yaml`
indica que este pacote usa por padrão a versão 2.18 da linguagem Dart.

```yaml
environment:
  sdk: '>=2.18.0 <3.0.0'
```

Para saber como e por que a equipe do Dart desenvolveu esse método de versionamento,
confira a [especificação de versionamento da linguagem][language versioning specification].

[null safety]: /null-safety
[Gradual null safety migration for large Dart projects]: /blog/gradual-null-safety-migration-for-large-dart-projects
[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[language versioning specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/feature-specification.md#dart-language-versioning

## Números de versão da linguagem {:#language-version-numbers}

O Dart formata suas versões da linguagem como dois números separados por um ponto.
Eles representam um número de versão maior e um número de versão menor.
Números de versão menores podem introduzir mudanças que quebram compatibilidade.

Releases do Dart podem acrescentar um número de patch a uma versão da linguagem.
Patches não devem alterar a linguagem, exceto por correções de bugs.
Por exemplo: o Dart 2.18.3 é a release mais recente da
versão 2.18 da linguagem do SDK do Dart.

Cada release do Dart SDK suporta a sua própria versão da linguagem e
todas as versões anteriores dentro do mesmo número de versão maior.
Ou seja, o Dart SDK 2.18.3 suporta as versões da linguagem
2.0 até 2.18 inclusive, mas não o Dart 1.x.

Derivar a versão da linguagem a partir da versão do SDK implica o seguinte:

* Sempre que uma versão menor do SDK é lançada, surge uma nova versão da linguagem.
  Na prática, muitas dessas versões da linguagem funcionam de maneira muito
  parecida com as anteriores e são totalmente compatíveis entre si.
  Por exemplo: a linguagem Dart 2.9 funciona de forma muito parecida com a 2.8.

* Quando um patch do SDK é lançado,
  ele não pode introduzir novas funcionalidades da linguagem.
  Por exemplo: a release 2.18.3 _continua_ sendo a versão 2.18 da linguagem.
  Ela precisa continuar compatível com 2.18.2, 2.18.1 e 2.18.0.

## Seleção de versão da linguagem por biblioteca {: #library-override}

Por padrão, todo arquivo Dart em um pacote usa a mesma versão da linguagem.
O Dart identifica a versão padrão da linguagem como o
limite inferior da restrição de SDK especificada no arquivo `pubspec.yaml`.
Às vezes, um arquivo Dart pode precisar usar uma versão mais antiga da linguagem.
Por exemplo, você pode não conseguir migrar todos os arquivos de um pacote
para null safety ao mesmo tempo.

O Dart suporta a seleção de versão da linguagem por biblioteca.
Para usar uma versão da linguagem diferente do restante de um pacote, uma [biblioteca Dart][Dart library] deve
incluir um comentário no seguinte formato:

```dart
// @dart = <major>.<minor>
```

Por exemplo:

```dart
// Description of what's in this file.
// @dart = 2.17
import 'dart:math';

// ...
```

A string `@dart` precisa estar em um comentário `//` (não `///` nem `/*`),
e deve aparecer antes de qualquer código Dart no arquivo.
Espaços em branco (tabs e espaços) não importam,
exceto dentro das strings `@dart` e da versão.
Como mostra o exemplo anterior,
outros comentários podem aparecer antes do comentário `@dart`.

[Dart library]: /tools/pub/create-packages#organizing-a-package

## Mudanças versionadas da linguagem {:#language-versioned-changes}

O versionamento da linguagem ajuda o Dart e suas ferramentas a evoluírem com o tempo.
Além de possíveis mudanças de sintaxe e semântica que quebram compatibilidade,
novas funcionalidades e mudanças nas ferramentas também podem ser condicionadas a uma versão da linguagem.
Por exemplo, o `dart format` pode formatar código Dart de forma diferente
dependendo da versão da linguagem da biblioteca que está formatando.

Para descobrir quais mudanças cada versão da linguagem introduziu,
você pode consultar o [changelog do Dart][Dart changelog], que possui filtros.
Para conhecer detalhes específicos de cada versão da linguagem e suas funcionalidades,
confira a [documentação da linguagem][language documentation] e a [especificação da linguagem][language specification].

:::tip
Para conhecer novas funcionalidades e mudanças do Dart que estão sendo
discutidas, projetadas e implementadas,
confira o projeto [Dart language funnel][] no GitHub.
:::

[Dart changelog]: /changelog
[language documentation]: /language
[language specification]: /resources/language/spec
[Dart language funnel]: https://github.com/orgs/dart-lang/projects/90
