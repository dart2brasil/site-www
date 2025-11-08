---
ia-translate: true
title: undefined_annotation
description: >-
  Detalhes sobre o diagnóstico undefined_annotation
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nome indefinido '{0}' usado como anotação._

## Descrição

O analisador produz este diagnóstico quando um nome que não está definido é
usado como anotação.

## Exemplo

O código a seguir produz este diagnóstico porque o nome `undefined`
não está definido:

```dart
[!@undefined!]
void f() {}
```

## Correções comuns

Se o nome está correto, mas ainda não foi declarado, então declare o nome como
um valor constante:

```dart
const undefined = 'undefined';

@undefined
void f() {}
```

Se o nome está errado, substitua o nome pelo nome de uma constante válida:

```dart
@deprecated
void f() {}
```

Caso contrário, remova a anotação.
