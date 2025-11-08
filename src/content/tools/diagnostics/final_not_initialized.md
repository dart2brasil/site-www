---
ia-translate: true
title: final_not_initialized
description: >-
  Detalhes sobre o diagnóstico final_not_initialized
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável final '{0}' deve ser inicializada._

## Descrição

O analisador produz este diagnóstico quando um campo ou variável final não é
inicializado.

## Exemplo

O código a seguir produz este diagnóstico porque `x` não tem um
inicializador:

```dart
final [!x!];
```

## Correções comuns

Para variáveis e campos static, você pode adicionar um inicializador:

```dart
final x = 0;
```

Para campos de instância, você pode adicionar um inicializador como mostrado no
exemplo anterior, ou pode inicializar o campo em todo construtor. Você pode
inicializar o campo usando um parâmetro formal inicializador:

```dart
class C {
  final int x;
  C(this.x);
}
```

Você também pode inicializar o campo usando um inicializador no
construtor:

```dart
class C {
  final int x;
  C(int y) : x = y * 2;
}
```
