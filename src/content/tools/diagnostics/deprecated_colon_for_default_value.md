---
ia-translate: true
title: deprecated_colon_for_default_value
description: "Detalhes sobre o diagnóstico deprecated_colon_for_default_value produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Usar dois-pontos como separador antes de um valor default está deprecated e não será suportado na versão da linguagem 3.0 e posteriores._

## Description

O analisador produz este diagnóstico quando dois-pontos (`:`) é usado como
separador antes do valor default de um parâmetro nomeado opcional.
Embora esta sintaxe seja permitida, ela está deprecated em favor de
usar um sinal de igual (`=`).

## Example

O código a seguir produz este diagnóstico porque dois-pontos está sendo usado
antes do valor default do parâmetro opcional `i`:

```dart
void f({int i [!:!] 0}) {}
```

## Common fixes

Substitua os dois-pontos por um sinal de igual.

```dart
void f({int i = 0}) {}
```
