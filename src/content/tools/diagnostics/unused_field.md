---
ia-translate: true
title: unused_field
description: >-
  Detalhes sobre o diagnóstico unused_field
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor do campo '{0}' não é usado._

## Descrição

O analisador produz este diagnóstico quando um campo privado é declarado mas
nunca lido, mesmo que seja escrito em um ou mais lugares.

## Exemplo

O código a seguir produz este diagnóstico porque o campo
`_originalValue` não é lido em nenhum lugar da biblioteca:

```dart
class C {
  final String [!_originalValue!];
  final String _currentValue;

  C(this._originalValue) : _currentValue = _originalValue;

  String get value => _currentValue;
}
```

Pode parecer que o campo `_originalValue` está sendo lido no
inicializador (`_currentValue = _originalValue`), mas isso é na verdade uma
referência ao parâmetro de mesmo nome, não uma referência ao campo.

## Correções comuns

Se o campo não é necessário, então remova-o.

Se o campo era para ser usado, então adicione o código faltante.
