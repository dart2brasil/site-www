---
ia-translate: true
title: undefined_named_parameter
description: "Detalhes sobre o diagnóstico undefined_named_parameter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O parâmetro nomeado '{0}' não está definido._

## Descrição

O analisador produz este diagnóstico quando uma invocação de método ou função
tem um argumento nomeado, mas o método ou função sendo invocado não
define um parâmetro com o mesmo nome.

## Exemplo

O código a seguir produz este diagnóstico porque `m` não declara um
parâmetro nomeado chamado `a`:

```dart
class C {
  m({int? b}) {}
}

void f(C c) {
  c.m([!a!]: 1);
}
```

## Correções comuns

Se o nome do argumento está digitado incorretamente, então substitua-o pelo
nome correto. O exemplo acima pode ser corrigido mudando `a` para `b`:

```dart
class C {
  m({int? b}) {}
}

void f(C c) {
  c.m(b: 1);
}
```

Se uma subclasse adiciona um parâmetro com o nome em questão, então lance
o receptor para a subclasse:

```dart
class C {
  m({int? b}) {}
}

class D extends C {
  m({int? a, int? b}) {}
}

void f(C c) {
  (c as D).m(a: 1);
}
```

Se o parâmetro deveria ser adicionado à função, então adicione-o:

```dart
class C {
  m({int? a, int? b}) {}
}

void f(C c) {
  c.m(a: 1);
}
```
