---
ia-translate: true
title: sdk_version_never
description: "Detalhes sobre o diagnóstico sdk_version_never produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo 'Never' não era suportado até a versão 2.12.0, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando uma referência à classe `Never`
é encontrada em código que tem uma restrição de SDK cuja limite inferior é menor que
2.12.0. Esta classe não era definida em versões anteriores, então este código não será
capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.12.0:

```yaml
environment:
  sdk: '>=2.5.0 <2.6.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
[!Never!] n;
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que o tipo seja usado:

```yaml
environment:
  sdk: '>=2.12.0 <2.13.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não referenciar esta classe:

```dart
dynamic x;
```
