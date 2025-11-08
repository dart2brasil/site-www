---
ia-translate: true
title: supertype_expands_to_type_parameter
description: "Detalhes sobre o diagnóstico supertype_expands_to_type_parameter produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um type alias que se expande para um type parameter não pode ser implementado._

_Um type alias que se expande para um type parameter não pode ser usado com mixin._

_Um type alias que se expande para um type parameter não pode ser usado como uma restrição de superclasse._

_Um type alias que se expande para um type parameter não pode ser usado como uma superclasse._

## Description

O analisador produz este diagnóstico quando um type alias que se expande para um
type parameter é usado em uma cláusula `extends`, `implements`, `with` ou `on`.

## Example

O código a seguir produz este diagnóstico porque o type alias `T`,
que se expande para o type parameter `S`, é usado na cláusula `extends` da
classe `C`:

```dart
typedef T<S> = S;

class C extends [!T!]<Object> {}
```

## Common fixes

Use o valor do type argument diretamente:

```dart
typedef T<S> = S;

class C extends Object {}
```
