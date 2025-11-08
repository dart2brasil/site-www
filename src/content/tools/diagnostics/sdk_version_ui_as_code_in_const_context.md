---
ia-translate: true
title: sdk_version_ui_as_code_in_const_context
description: "Detalhes sobre o diagnóstico sdk_version_ui_as_code_in_const_context produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Os elementos if e spread não eram suportados em expressões constantes até a versão 2.5.0, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando um elemento if ou spread dentro de
um [contexto constante][] é encontrado em código que tem uma restrição de SDK cuja
limite inferior é menor que 2.5.0. O uso de um elemento if ou spread dentro de um
[contexto constante][] não era suportado em versões anteriores, então este código
não será capaz de rodar em versões anteriores do SDK.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.5.0:

```yaml
environment:
  sdk: '>=2.4.0 <2.6.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
const a = [1, 2];
const b = [[!...a!]];
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.5.0 <2.6.0'
```

Se você precisa suportar versões antigas do SDK, então reescreva o código para
não fazer uso daqueles elementos:

```dart
const a = [1, 2];
const b = [1, 2];
```

Se isso não for possível, altere o código para que o elemento não esteja em um
[contexto constante][]:

```dart
const a = [1, 2];
var b = [...a];
```

[constant context]: /resources/glossary#constant-context
