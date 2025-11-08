---
ia-translate: true
title: super_in_enum_constructor
description: "Detalhes sobre o diagnóstico super_in_enum_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor do enum não pode ter um inicializador 'super'._

## Descrição

O analisador produz este diagnóstico quando a lista de inicializadores em um
construtor em um enum contém uma invocação de um construtor super.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor no
enum `E` possui uma invocação de construtor super na lista de inicializadores:

```dart
enum E {
  e;

  const E() : [!super!]();
}
```

## Correções comuns

Remova a invocação do construtor super:

```dart
enum E {
  e;

  const E();
}
```
