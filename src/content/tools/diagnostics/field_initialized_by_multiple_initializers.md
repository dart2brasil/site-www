---
ia-translate: true
title: field_initialized_by_multiple_initializers
description: >-
  Detalhes sobre o diagnóstico field_initialized_by_multiple_initializers
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O campo '{0}' não pode ser inicializado duas vezes no mesmo construtor._

## Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor inicializa um campo mais de uma vez. Não há valor que permita
ambos os inicializadores porque apenas o último valor é preservado.

## Exemplo

O código a seguir produz este diagnóstico porque o campo `f` está sendo
inicializado duas vezes:

```dart
class C {
  int f;

  C() : f = 0, [!f!] = 1;
}
```

## Correções comuns

Remova um dos inicializadores:

```dart
class C {
  int f;

  C() : f = 0;
}
```
