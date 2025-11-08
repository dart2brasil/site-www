---
ia-translate: true
title: extension_conflicting_static_and_instance
description: "Detalhes sobre o diagnóstico extension_conflicting_static_and_instance produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma extension não pode definir um membro static '{0}' e um membro de instância com o mesmo nome._

## Descrição

O analisador produz este diagnóstico quando uma declaração de extension
contém tanto um membro de instância quanto um membro static que têm o mesmo
nome. O membro de instância e o membro static não podem ter o mesmo nome
porque fica ambíguo qual membro está sendo referenciado por um uso não qualificado
do nome dentro do corpo da extension.

## Exemplo

O código a seguir produz este diagnóstico porque o nome `a` está sendo
usado para dois membros diferentes:

```dart
extension E on Object {
  int get a => 0;
  static int [!a!]() => 0;
}
```

## Correções comuns

Renomeie ou remova um dos membros:

```dart
extension E on Object {
  int get a => 0;
  static int b() => 0;
}
```
