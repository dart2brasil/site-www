---
ia-translate: true
title: static_access_to_instance_member
description: "Detalhes sobre o diagnóstico static_access_to_instance_member produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro de instância '{0}' não pode ser acessado usando acesso static._

## Descrição

O analisador produz este diagnóstico quando um nome de classe é usado para acessar
um campo de instância. Campos de instância não existem em uma classe; eles existem apenas
em uma instância da classe.

## Exemplo

O código a seguir produz este diagnóstico porque `x` é um campo de
instância:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f() => C.[!b!];
```

## Correções comuns

Se você pretende acessar um campo static, então altere o nome do campo
para um campo static existente:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f() => C.a;
```

Se você pretende acessar o campo de instância, então use uma instância da
classe para acessar o campo:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f(C c) => c.b;
```
