---
ia-translate: true
title: inconsistent_pattern_variable_logical_or
description: "Detalhes sobre o diagnóstico inconsistent_pattern_variable_logical_or produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável '{0}' tem um tipo e/ou finalidade diferente neste ramo do padrão logical-or._

## Descrição

O analisador produz este diagnóstico quando uma variável de padrão que é
declarada em todos os ramos de um padrão logical-or não tem o mesmo
tipo em cada ramo. Ele também é produzido quando a variável tem uma
finalidade diferente em ramos diferentes. Uma variável de padrão declarada em
múltiplos ramos de um padrão logical-or deve ter o mesmo
tipo e finalidade em cada ramo, para que o tipo e a finalidade da
variável possam ser conhecidos no código que é protegido pelo padrão logical-or.

## Exemplos

O código a seguir produz este diagnóstico porque a variável `a` é
definida como `int` em um ramo e `double` no outro:

```dart
void f(Object? x) {
  if (x case (int a) || (double [!a!])) {
    print(a);
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` é
`final` no primeiro ramo e não é `final` no segundo ramo:

```dart
void f(Object? x) {
  if (x case (final int a) || (int [!a!])) {
    print(a);
  }
}
```

## Correções comuns

Se a finalidade da variável for diferente, decida se ela deve ser
`final` ou não `final` e torne os casos consistentes:

```dart
void f(Object? x) {
  if (x case (int a) || (int a)) {
    print(a);
  }
}
```

Se o tipo da variável for diferente e o tipo não for crítico para
a condição sendo correspondida, então garanta que a variável tenha o mesmo
tipo em ambos os ramos:

```dart
void f(Object? x) {
  if (x case (num a) || (num a)) {
    print(a);
  }
}
```

Se o tipo da variável for diferente e o tipo for crítico para a
condição sendo correspondida, então considere quebrar a condição em
múltiplas instruções `if` ou cláusulas `case`:

```dart
void f(Object? x) {
  if (x case int a) {
    print(a);
  } else if (x case double a) {
    print(a);
  }
}
```
