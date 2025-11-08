---
ia-translate: true
title: pattern_variable_assignment_inside_guard
description: "Detalhes sobre o diagnóstico pattern_variable_assignment_inside_guard produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Variáveis de padrão não podem ser atribuídas dentro do guard do padrão guardado envolvente._

## Description

O analisador produz este diagnóstico quando uma variável de padrão recebe
um valor dentro de uma cláusula guard (`when`).

## Example

O código a seguir produz este diagnóstico porque a variável `a` recebe
um valor dentro da cláusula guard:

```dart
void f(int x) {
  if (x case var a when ([!a!] = 1) > 0) {
    print(a);
  }
}
```

## Common fixes

Se há um valor que você precisa capturar, então atribua-o a uma
variável diferente:

```dart
void f(int x) {
  var b;
  if (x case var a when (b = 1) > 0) {
    print(a + b);
  }
}
```

Se não há um valor que você precisa capturar, então remova a atribuição:

```dart
void f(int x) {
  if (x case var a when 1 > 0) {
    print(a);
  }
}
```
