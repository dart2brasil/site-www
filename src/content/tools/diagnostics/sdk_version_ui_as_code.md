---
ia-translate: true
title: sdk_version_ui_as_code
description: "Detalhes sobre o diagnóstico sdk_version_ui_as_code produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Os elementos for, if e spread não eram suportados até a versão 2.3.0, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando um elemento for, if ou spread é
encontrado em código que tem uma restrição de SDK cuja limite inferior é menor que
2.3.0. O uso de um elemento for, if ou spread não era suportado em versões anteriores,
então este código não será capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.3.0:

```yaml
environment:
  sdk: '>=2.2.0 <2.4.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
var digits = [[!for (int i = 0; i < 10; i++) i!]];
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.3.0 <2.4.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não fazer uso daqueles elementos:

```dart
var digits = _initializeDigits();

List<int> _initializeDigits() {
  var digits = <int>[];
  for (int i = 0; i < 10; i++) {
    digits.add(i);
  }
  return digits;
}
```
