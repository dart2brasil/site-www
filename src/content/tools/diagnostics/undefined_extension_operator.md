---
ia-translate: true
title: undefined_extension_operator
description: "Detalhes sobre o diagnóstico undefined_extension_operator produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O operador '{0}' não está definido para a extension '{1}'._

## Descrição

O analisador produz este diagnóstico quando um operador é invocado em uma
extension específica quando essa extension não implementa o operador.

## Exemplo

O código a seguir produz este diagnóstico porque a extension `E`
não define o operador `*`:

```dart
var x = E('') [!*!] 4;

extension E on String {}
```

## Correções comuns

Se a extension deve implementar o operador, então adicione uma
implementação do operador à extension:

```dart
var x = E('') * 4;

extension E on String {
  int operator *(int multiplier) => length * multiplier;
}
```

Se o operador é definido por uma extension diferente, então altere o nome
da extension para o nome da que define o operador.

Se o operador é definido no argumento da sobrescrita da extension, então
remova a sobrescrita da extension:

```dart
var x = '' * 4;

extension E on String {}
```
