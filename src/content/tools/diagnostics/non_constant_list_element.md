---
ia-translate: true
title: non_constant_list_element
description: "Detalhes sobre o diagnóstico non_constant_list_element produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The values in a const list literal must be constants._

## Description

O analisador produz este diagnóstico quando um elemento em um literal de lista
constante não é um valor constante. O literal de lista pode ser constante
explicitamente (porque é prefixado pela keyword `const`) ou implicitamente
(porque aparece em um [constant context][]).

## Example

O código a seguir produz este diagnóstico porque `x` não é uma constante,
embora apareça em um literal de lista implicitamente constante:

```dart
var x = 2;
var y = const <int>[0, 1, [!x!]];
```

## Common fixes

Se a lista precisa ser uma lista constante, então converta o elemento para uma
constante. No exemplo acima, você pode adicionar a keyword `const` à
declaração de `x`:

```dart
const x = 2;
var y = const <int>[0, 1, x];
```

Se a expressão não pode se tornar uma constante, então a lista não pode ser uma
constante, então você deve mudar o código para que a lista não seja uma
constante. No exemplo acima isso significa remover a keyword `const`
antes do literal de lista:

```dart
var x = 2;
var y = <int>[0, 1, x];
```

[constant context]: /resources/glossary#constant-context
