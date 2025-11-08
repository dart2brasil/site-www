---
ia-translate: true
title: nullable_type_in_implements_clause
description: >-
  Detalhes sobre o diagnóstico nullable_type_in_implements_clause
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma classe, mixin ou tipo de extensão não pode implementar um tipo nulo._

## Descrição

O analisador produz este diagnóstico quando uma classe, mixin ou
declaração de tipo de extensão tem uma cláusula `implements`, e uma
interface é seguida por um `?`.

Não é válido especificar uma interface nula porque fazer isso não teria
nenhum significado; não alteraria a interface sendo herdada pela classe
contendo a cláusula `implements`.

Note, porém, que _é_ válido usar um tipo nulo como um argumento de tipo
para a interface, como `class A implements B<C?> {}`.


## Exemplo

O código a seguir produz este diagnóstico porque `A?` é um tipo nulo,
e tipos nulos não podem ser usados em uma cláusula `implements`:

```dart
class A {}
class B implements [!A?!] {}
```

## Correções comuns

Remova o ponto de interrogação do tipo:

```dart
class A {}
class B implements A {}
```
