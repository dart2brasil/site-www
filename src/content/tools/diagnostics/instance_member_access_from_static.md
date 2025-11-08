---
ia-translate: true
title: instance_member_access_from_static
description: >-
  Detalhes sobre o diagnóstico instance_member_access_from_static
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Membros de instância não podem ser acessados de um método static._

## Descrição

O analisador produz este diagnóstico quando um método static contém uma
referência não qualificada a um membro de instância.

## Exemplo

O código a seguir produz este diagnóstico porque o campo de instância `x`
está sendo referenciado em um método static:

```dart
class C {
  int x = 0;

  static int m() {
    return [!x!];
  }
}
```

## Correções comuns

Se o método deve referenciar o membro de instância, então ele não pode ser static,
então remova a keyword:

```dart
class C {
  int x = 0;

  int m() {
    return x;
  }
}
```

Se o método não puder ser tornado um método de instância, então adicione um parâmetro para
que uma instância da classe possa ser passada:

```dart
class C {
  int x = 0;

  static int m(C c) {
    return c.x;
  }
}
```
