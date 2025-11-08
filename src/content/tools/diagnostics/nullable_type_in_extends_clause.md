---
ia-translate: true
title: nullable_type_in_extends_clause
description: "Detalhes sobre o diagnóstico nullable_type_in_extends_clause produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma classe não pode estender um tipo nulo._

## Descrição

O analisador produz este diagnóstico quando uma declaração de classe usa uma
cláusula `extends` para especificar uma superclasse, e a superclasse é seguida por
um `?`.

Não é válido especificar uma superclasse nula porque fazer isso não teria
nenhum significado; não alteraria nem a interface nem a implementação sendo
herdada pela classe contendo a cláusula `extends`.

Note, porém, que _é_ válido usar um tipo nulo como um argumento de tipo
para a superclasse, como `class A extends B<C?> {}`.

## Exemplo

O código a seguir produz este diagnóstico porque `A?` é um tipo nulo,
e tipos nulos não podem ser usados em uma cláusula `extends`:

```dart
class A {}
class B extends [!A?!] {}
```

## Correções comuns

Remova o ponto de interrogação do tipo:

```dart
class A {}
class B extends A {}
```
