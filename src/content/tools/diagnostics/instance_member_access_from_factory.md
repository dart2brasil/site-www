---
ia-translate: true
title: instance_member_access_from_factory
description: "Detalhes sobre o diagnóstico instance_member_access_from_factory produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Membros de instância não podem ser acessados de um construtor factory._

## Descrição

O analisador produz este diagnóstico quando um construtor factory contém
uma referência não qualificada a um membro de instância. Em um
construtor generativo, a instância da classe é criada e inicializada antes
do corpo do construtor ser executado, então a instância pode ser vinculada a
`this` e acessada da mesma forma que seria em um método de instância. Mas, em um
construtor factory, a instância não é criada antes de executar o corpo,
então `this` não pode ser usado para referenciá-la.

## Exemplo

O código a seguir produz este diagnóstico porque `x` não está no escopo no
construtor factory:

```dart
class C {
  int x;
  factory C() {
    return C._([!x!]);
  }
  C._(this.x);
}
```

## Correções comuns

Reescreva o código para que ele não referencie o membro de instância:

```dart
class C {
  int x;
  factory C() {
    return C._(0);
  }
  C._(this.x);
}
```
