---
ia-translate: true
title: invalid_pattern_variable_in_shared_case_scope
description: >-
  Detalhes sobre o diagnóstico invalid_pattern_variable_in_shared_case_scope
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável '{0}' não possui o mesmo tipo e/ou finality em todos os cases que compartilham este corpo._

_A variável '{0}' está disponível em alguns, mas não em todos os cases que compartilham este corpo._

_A variável '{0}' não está disponível porque existe um label ou case 'default'._

## Description

O analisador produz este diagnóstico quando múltiplas cláusulas case em uma
instrução switch compartilham um corpo, e pelo menos uma delas declara uma
variável que é referenciada nas instruções compartilhadas, mas a variável
não está declarada em todas as cláusulas case ou está declarada de
forma inconsistente.

Se a variável não está declarada em todas as cláusulas case, então ela não
terá um valor se uma das cláusulas que não declara a variável for
aquela que corresponde e executa o corpo. Isso inclui a situação
em que uma das cláusulas case é a cláusula `default`.

Se a variável é declarada de forma inconsistente, sendo `final` em
alguns cases e não `final` em outros, ou tendo um tipo diferente em
cases diferentes, então a semântica de qual deve ser o tipo ou finality da
variável não está definida.

## Examples

O código a seguir produz este diagnóstico porque a variável `a` está
declarada apenas em uma das cláusulas case, e não terá um valor se a
segunda cláusula for aquela que correspondeu a `x`:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    case 0:
      [!a!];
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` não está
declarada na cláusula `default`, e não terá um valor se o corpo for
executado porque nenhuma das outras cláusulas correspondeu a `x`:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    default:
      [!a!];
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` não
terá um valor se o corpo for executado porque um grupo diferente de cases
fez o controle continuar no label:

```dart
void f(Object? x) {
  switch (x) {
    someLabel:
    case int a when a > 0:
      [!a!];
    case int b when b < 0:
      continue someLabel;
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a`,
embora seja atribuída em todas as cláusulas case, não possui o mesmo
tipo associado a ela em todas as cláusulas:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a < 0:
    case num a when a > 0:
      [!a!];
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` é
`final` na primeira cláusula case e não é `final` na segunda cláusula
case:

```dart
void f(Object? x) {
  switch (x) {
    case final int a when a < 0:
    case int a when a > 0:
      [!a!];
  }
}
```

## Common fixes

Se a variável não está declarada em todos os cases, e você precisa
referenciá-la nas instruções, então declare-a nos outros cases:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    case int a when a == 0:
      a;
  }
}
```

Se a variável não está declarada em todos os cases, e você não precisa
referenciá-la nas instruções, então remova as referências a ela e
remova as declarações dos outros cases:

```dart
void f(int x) {
  switch (x) {
    case > 0:
    case 0:
  }
}
```

Se o tipo da variável é diferente, decida qual tipo a variável
deve ter e torne os cases consistentes:

```dart
void f(Object? x) {
  switch (x) {
    case num a when a < 0:
    case num a when a > 0:
      a;
  }
}
```

Se o finality da variável é diferente, decida se ela deve ser
`final` ou não `final` e torne os cases consistentes:

```dart
void f(Object? x) {
  switch (x) {
    case final int a when a < 0:
    case final int a when a > 0:
      a;
  }
}
```
