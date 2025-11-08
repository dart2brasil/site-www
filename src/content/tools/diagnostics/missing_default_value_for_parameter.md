---
title: missing_default_value_for_parameter
description: "Detalhes sobre o diagnóstico missing_default_value_for_parameter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O parameter '{0}' não pode ter um valor 'null' por causa de seu tipo, mas o valor padrão implícito é 'null'._

_Com null safety, use a palavra-chave 'required', não a anotação '@required'._

## Description

O analisador produz este diagnóstico quando um parameter opcional, seja
positional ou named, tem um tipo [potencialmente não-anulável][potentially non-nullable] e não
especifica um valor padrão. Parameters opcionais que não têm valor padrão explícito
têm um valor padrão implícito de `null`. Se o tipo do
parameter não permite que o parameter tenha um valor `null`, então o
valor padrão implícito não é válido.

## Examples

O código a seguir produz este diagnóstico porque `x` não pode ser `null`,
e nenhum valor padrão não-`null` é especificado:

```dart
void f([int [!x!]]) {}
```

Assim como este:

```dart
void g({int [!x!]}) {}
```

## Common fixes

Se você quer usar `null` para indicar que nenhum valor foi fornecido, então você
precisa tornar o tipo anulável:

```dart
void f([int? x]) {}
void g({int? x}) {}
```

Se o parameter não pode ser null, então forneça um valor padrão:

```dart
void f([int x = 1]) {}
void g({int x = 2}) {}
```

ou torne o parameter um parameter required:

```dart
void f(int x) {}
void g({required int x}) {}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
