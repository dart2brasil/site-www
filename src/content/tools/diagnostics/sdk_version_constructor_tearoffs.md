---
ia-translate: true
title: sdk_version_constructor_tearoffs
description: "Detalhes sobre o diagnóstico sdk_version_constructor_tearoffs produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Fazer um tear-off de um construtor requer o recurso de linguagem 'constructor-tearoffs'._

## Descrição

O analisador produz este diagnóstico quando um tear-off de construtor é encontrado
em código que tem uma restrição de SDK cuja limite inferior é menor que 2.15.
Tear-offs de construtores não eram suportados em versões anteriores, então este código
não será capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.15:

```yaml
environment:
  sdk: '>=2.9.0 <2.15.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
var setConstructor = [!Set.identity!];
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que o operador seja usado:

```yaml
environment:
  sdk: '>=2.15.0 <2.16.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não usar tear-offs de construtores:

```dart
var setConstructor = () => Set.identity();
```
