---
ia-translate: true
title: obsolete_colon_for_default_value
description: >-
  Detalhes sobre o diagnóstico obsolete_colon_for_default_value
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Usar dois-pontos como separador antes de um valor padrão não é mais suportado._

## Description

O analisador produz este diagnóstico quando dois-pontos (`:`) são usados como
separador antes do valor padrão de um parâmetro nomeado opcional.
Embora essa sintaxe costumava ser permitida, ela foi removida em favor de
usar um sinal de igual (`=`).

## Example

O código a seguir produz este diagnóstico porque dois-pontos estão sendo usados
antes do valor padrão do parâmetro opcional `i`:

```dart
void f({int i [!:!] 0}) {}
```

## Common fixes

Substitua os dois-pontos por um sinal de igual:

```dart
void f({int i = 0}) {}
```
