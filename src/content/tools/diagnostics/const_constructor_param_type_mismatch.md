---
ia-translate: true
title: const_constructor_param_type_mismatch
description: "Detalhes sobre o diagnóstico const_constructor_param_type_mismatch produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A value of type '{0}' can't be assigned to a parameter of type '{1}' in a const constructor._

## Descrição

O analisador produz este diagnóstico quando o tipo em tempo de execução de um
valor constante não pode ser atribuído ao tipo estático de um parâmetro de
constructor constante.

## Exemplo

O código a seguir produz este diagnóstico porque o tipo em tempo de execução
de `i` é `int`, que não pode ser atribuído ao tipo estático de `s`:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C([!i!]);
}
```

## Correções comuns

Passe um valor do tipo correto para o constructor:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C('$i');
}
```
