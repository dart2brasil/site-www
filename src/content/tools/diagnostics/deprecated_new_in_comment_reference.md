---
ia-translate: true
title: deprecated_new_in_comment_reference
description: >-
  Detalhes sobre o diagnóstico deprecated_new_in_comment_reference
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Usar a keyword 'new' em uma referência de comentário está deprecated._

## Description

O analisador produz este diagnóstico quando uma referência de comentário (o nome
de uma declaração entre colchetes em um comentário de documentação)
usa a keyword `new` para referenciar um construtor. Esta forma está deprecated.

## Examples

O código a seguir produz este diagnóstico porque o construtor sem nome
está sendo referenciado usando `new C`:

```dart
/// See [[!new!] C].
class C {
  C();
}
```

O código a seguir produz este diagnóstico porque o construtor nomeado
`c` está sendo referenciado usando `new C.c`:

```dart
/// See [[!new!] C.c].
class C {
  C.c();
}
```

## Common fixes

Se você está referenciando um construtor nomeado, então remova a keyword `new`:

```dart
/// See [C.c].
class C {
  C.c();
}
```

Se você está referenciando o construtor sem nome, então remova a keyword
`new` e adicione `.new` após o nome da classe:

```dart
/// See [C.new].
class C {
  C.c();
}
```
