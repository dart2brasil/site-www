---
ia-translate: true
title: invalid_language_version_override
description: >-
  Detalhes sobre o diagnóstico invalid_language_version_override
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O comentário de override de versão da linguagem Dart não pode ser seguido por caracteres que não sejam espaços em branco._

_O comentário de override de versão da linguagem Dart deve ser especificado com um número de versão, como '2.0', após o caractere '='._

_O comentário de override de versão da linguagem Dart deve ser especificado com um caractere '='._

_O comentário de override de versão da linguagem Dart deve ser especificado com exatamente duas barras._

_O comentário de override de versão da linguagem Dart deve ser especificado com a palavra 'dart' toda em minúsculas._

_O número de override de versão da linguagem Dart não pode ter prefixo com uma letra._

_O número de override de versão da linguagem Dart deve começar com '@dart'._

_O override de versão da linguagem não pode especificar uma versão maior que a versão de linguagem mais recente conhecida: {0}.{1}._

_O override de versão da linguagem deve ser especificado antes de qualquer declaração ou diretiva._

## Description

O analisador produz este diagnóstico quando um comentário que parece ser uma
tentativa de especificar um override de versão da linguagem não está em
conformidade com os requisitos para tal comentário. Para mais informações,
veja [Per-library language version selection](https://dart.dev/resources/language/evolution#per-library-language-version-selection).

## Example

O código a seguir produz este diagnóstico porque a palavra `dart` deve estar
em minúsculas em tal comentário e porque não há sinal de igual entre a
palavra `dart` e o número da versão:

```dart
[!// @Dart 2.13!]
```

## Common fixes

Se o comentário pretende ser um override de versão da linguagem, altere o
comentário para seguir o formato correto:

```dart
// @dart = 2.13
```
