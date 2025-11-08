---
ia-translate: true
title: label_in_outer_scope
description: >-
  Detalhes sobre o diagnóstico label_in_outer_scope
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não é possível referenciar o label '{0}' declarado em um método externo._

## Description

O analisador produz este diagnóstico quando um statement `break` ou `continue`
referencia um label que é declarado em um método ou função
contendo a função na qual o statement `break` ou `continue`
aparece. Os statements `break` e `continue` não podem ser usados para transferir
controle para fora da função que os contém.

## Example

O código a seguir produz este diagnóstico porque o label `loop` é
declarado fora da função local `g`:

```dart
void f() {
  loop:
  while (true) {
    void g() {
      break [!loop!];
    }

    g();
  }
}
```

## Common fixes

Tente reescrever o código para que não seja necessário transferir controle
para fora da função local, possivelmente fazendo inline da função local:

```dart
void f() {
  loop:
  while (true) {
    break loop;
  }
}
```

Se isso não for possível, então tente reescrever a função local para que um
valor retornado pela função possa ser usado para determinar se o controle é
transferido:

```dart
void f() {
  loop:
  while (true) {
    bool g() {
      return true;
    }

    if (g()) {
      break loop;
    }
  }
}
```
