---
ia-translate: true
title: prefix_shadowed_by_local_declaration
description: >-
  Detalhes sobre o diagnóstico prefix_shadowed_by_local_declaration
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O prefixo '{0}' não pode ser usado aqui porque está sombreado por uma declaração local._

## Descrição

O analisador produz este diagnóstico quando um prefixo de import é usado em um
contexto onde não está visível porque foi sombreado por uma
declaração local.

## Exemplo

O código a seguir produz este diagnóstico porque o prefixo `a` está
sendo usado para acessar a classe `Future`, mas não está visível porque está
sombreado pelo parâmetro `a`:

```dart
import 'dart:async' as a;

a.Future? f(int a) {
  [!a!].Future? x;
  return x;
}
```

## Correções comuns

Renomeie o prefixo:

```dart
import 'dart:async' as p;

p.Future? f(int a) {
  p.Future? x;
  return x;
}
```

Ou renomeie a variável local:

```dart
import 'dart:async' as a;

a.Future? f(int p) {
  a.Future? x;
  return x;
}
```
