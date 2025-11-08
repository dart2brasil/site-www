---
ia-translate: true
title: assignment_to_const
description: >-
  Detalhes sobre o diagnóstico assignment_to_const
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Variáveis constantes não podem receber um valor após a inicialização._

## Description

O analisador produz este diagnóstico quando encontra uma atribuição a uma
variável de nível superior, um campo estático ou uma variável local que possui o
modificador `const`. O valor de uma constante em tempo de compilação não pode ser alterado em
tempo de execução.

## Example

O código a seguir produz este diagnóstico porque `c` está recebendo um
valor mesmo tendo o modificador `const`:

```dart
const c = 0;

void f() {
  [!c!] = 1;
  print(c);
}
```

## Common fixes

Se a variável deve ser atribuível, então remova o modificador `const`:

```dart
var c = 0;

void f() {
  c = 1;
  print(c);
}
```

Se a constante não deve ser alterada, então remova a atribuição ou
use uma variável local no lugar das referências à constante:

```dart
const c = 0;

void f() {
  var v = 1;
  print(v);
}
```
