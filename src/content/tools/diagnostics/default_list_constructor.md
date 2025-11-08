---
ia-translate: true
title: default_list_constructor
description: "Detalhes sobre o diagnóstico default_list_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor default 'List' não está disponível quando null safety está habilitado._

## Description

O analisador produz este diagnóstico quando encontra um uso do construtor
default para a classe `List` em código que optou por null safety.

## Example

Assumindo que o código a seguir optou por null safety, ele produz este
diagnóstico porque usa o construtor default `List`:

```dart
var l = [!List<int>!]();
```

## Common fixes

Se nenhum tamanho inicial é fornecido, então converta o código para usar um
literal de lista:

```dart
var l = <int>[];
```

Se um tamanho inicial precisa ser fornecido e há um único valor inicial
razoável para os elementos, então use `List.filled`:

```dart
var l = List.filled(3, 0);
```

Se um tamanho inicial precisa ser fornecido mas cada elemento precisa ser
computado, então use `List.generate`:

```dart
var l = List.generate(3, (i) => i);
```
