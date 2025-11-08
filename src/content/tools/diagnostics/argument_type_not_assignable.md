---
ia-translate: true
title: argument_type_not_assignable
description: >-
  Detalhes sobre o diagnóstico argument_type_not_assignable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The argument type '{0}' can't be assigned to the parameter type '{1}'. {2}_

## Description

O analisador produz este diagnóstico quando o type estático de um argument
não pode ser atribuído ao type estático do parameter correspondente.

## Example

O código a seguir produz este diagnóstico porque um `num` não pode ser
atribuído a um `String`:

```dart
String f(String x) => x;
String g(num y) => f([!y!]);
```

## Common fixes

Se possível, reescreva o código para que o type estático seja assignable. No
exemplo acima você pode conseguir alterar o type do parameter `y`:

```dart
String f(String x) => x;
String g(String y) => f(y);
```

Se essa correção não for possível, então adicione código para lidar com o caso onde o
valor do argument não é o type esperado. Uma abordagem é coagir outros
types para o type esperado:

```dart
String f(String x) => x;
String g(num y) => f(y.toString());
```

Outra abordagem é adicionar verificações de type explícitas e código alternativo:

```dart
String f(String x) => x;
String g(Object y) => f(y is String ? y : '');
```

Se você acredita que o type em tempo de execução do argument será sempre o
mesmo que o type estático do parameter, e está disposto a arriscar ter
uma exceção lançada em tempo de execução se estiver errado, então adicione um cast explícito:

```dart
String f(String x) => x;
String g(num y) => f(y as String);
```
