---
ia-translate: true
title: sdk_version_async_exported_from_core
description: "Detalhes sobre o diagnóstico sdk_version_async_exported_from_core produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não era exportada de 'dart:core' até a versão 2.1, mas este código é obrigado a ser capaz de rodar em versões anteriores._

## Descrição

O analisador produz este diagnóstico quando a classe `Future` ou
`Stream` é referenciada em uma biblioteca que não importa `dart:async` em
código que tem uma restrição de SDK cuja limite inferior é menor que 2.1.0. Em
versões anteriores, estas classes não eram definidas em `dart:core`, então a
importação era necessária.

## Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um
limite inferior menor que 2.1.0:

```yaml
environment:
  sdk: '>=2.0.0 <2.4.0'
```

No pacote que tem esse pubspec, código como o seguinte produz este diagnóstico:

```dart
void f([!Future!] f) {}
```

## Correções comuns

Se você não precisa suportar versões antigas do SDK, então você pode aumentar
a restrição de SDK para permitir que as classes sejam referenciadas:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

Se você precisa suportar versões antigas do SDK, então importe a
biblioteca `dart:async`.

```dart
import 'dart:async';

void f(Future f) {}
```
