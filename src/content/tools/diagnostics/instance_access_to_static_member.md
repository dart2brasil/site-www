---
ia-translate: true
title: instance_access_to_static_member
description: >-
  Detalhes sobre o diagnóstico instance_access_to_static_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O {0} static '{1}' não pode ser acessado através de uma instância._

## Descrição

O analisador produz este diagnóstico quando um operador de acesso é usado para
acessar um membro static através de uma instância da classe.

## Exemplo

O código a seguir produz este diagnóstico porque `zero` é um
campo static, mas está sendo acessado como se fosse um campo de instância:

```dart
void f(C c) {
  c.[!zero!];
}

class C {
  static int zero = 0;
}
```

## Correções comuns

Use a classe para acessar o membro static:

```dart
void f(C c) {
  C.zero;
}

class C {
  static int zero = 0;
}
```
