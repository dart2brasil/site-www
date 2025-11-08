---
ia-translate: true
title: nullable_type_in_with_clause
description: "Detalhes sobre o diagnóstico nullable_type_in_with_clause produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma classe ou mixin não pode misturar em um tipo nulo._

## Descrição

O analisador produz este diagnóstico quando uma declaração de classe ou mixin tem
uma cláusula `with`, e um mixin é seguido por um `?`.

Não é válido especificar um mixin nulo porque fazer isso não teria nenhum
significado; não alteraria nem a interface nem a implementação sendo
herdada pela classe contendo a cláusula `with`.

Note, porém, que _é_ válido usar um tipo nulo como um argumento de tipo
para o mixin, como `class A with B<C?> {}`.

## Exemplo

O código a seguir produz este diagnóstico porque `A?` é um tipo nulo,
e tipos nulos não podem ser usados em uma cláusula `with`:

```dart
mixin M {}
class C with [!M?!] {}
```

## Correções comuns

Remova o ponto de interrogação do tipo:

```dart
mixin M {}
class C with M {}
```
