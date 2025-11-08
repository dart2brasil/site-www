---
ia-translate: true
title: sdk_version_set_literal
description: >-
  Detalhes sobre o diagnóstico sdk_version_set_literal
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Literais de conjunto não eram suportados até a versão 2.2, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando um literal de conjunto é encontrado em código
que tem uma restrição de SDK cuja limite inferior é menor que 2.2.0. Literais
de conjunto não eram suportados em versões anteriores, então este código não será capaz
de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.2.0:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
var s = [!<int>{}!];
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.2.0 <2.4.0'
```

Se você realmente precisa suportar versões antigas do SDK, então substitua o literal
de conjunto por código que cria o conjunto sem o uso de um literal:

```dart
var s = new Set<int>();
```
