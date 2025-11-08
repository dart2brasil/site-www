---
ia-translate: true
title: nullable_type_in_on_clause
description: "Detalhes sobre o diagnóstico nullable_type_in_on_clause produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um mixin não pode ter um tipo nulo como uma restrição de superclasse._

## Descrição

O analisador produz este diagnóstico quando uma declaração de mixin usa uma cláusula `on`
para especificar uma restrição de superclasse, e a classe que é especificada
é seguida por um `?`.

Não é válido especificar uma restrição de superclasse nula porque fazer isso
não teria nenhum significado; não alteraria a interface sendo dependida
pelo mixin contendo a cláusula `on`.

Note, porém, que _é_ válido usar um tipo nulo como um argumento de tipo
para a restrição de superclasse, como `mixin A on B<C?> {}`.


## Exemplo

O código a seguir produz este diagnóstico porque `A?` é um tipo nulo
e tipos nulos não podem ser usados em uma cláusula `on`:

```dart
class C {}
mixin M on [!C?!] {}
```

## Correções comuns

Remova o ponto de interrogação do tipo:

```dart
class C {}
mixin M on C {}
```
