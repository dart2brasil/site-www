---
ia-translate: true
title: ambiguous_export
description: "Detalhes sobre o diagnóstico ambiguous_export produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' está definido nas bibliotecas '{1}' e '{2}'._

## Descrição

O analisador produz este diagnóstico quando duas ou mais diretivas export
fazem com que o mesmo nome seja exportado de múltiplas bibliotecas.

## Exemplo

Dado um arquivo `a.dart` contendo

```dart
class C {}
```

E um arquivo `b.dart` contendo

```dart
class C {}
```

O código a seguir produz este diagnóstico porque o nome `C` está sendo
exportado tanto de `a.dart` quanto de `b.dart`:

```dart
export 'a.dart';
export [!'b.dart'!];
```

## Correções comuns

Se nenhum dos nomes em uma das bibliotecas precisa ser exportado, então
remova as diretivas export desnecessárias:

```dart
export 'a.dart';
```

Se todas as diretivas export são necessárias, então oculte o nome em todas
exceto uma das diretivas:

```dart
export 'a.dart';
export 'b.dart' hide C;
```
