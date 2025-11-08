---
ia-translate: true
title: diagnostic_describe_all_properties
description: "Detalhes sobre o diagnóstico diagnostic_describe_all_properties produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/diagnostic_describe_all_properties"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_A propriedade pública não é descrita por 'debugFillProperties' ou 'debugDescribeChildren'._

## Description

O analisador produz este diagnóstico quando uma classe que implementa
`Diagnosticable` tem uma propriedade pública que não é adicionada como uma propriedade em
um método `debugFillProperties` ou `debugDescribeChildren`.

## Example

O código a seguir produz este diagnóstico porque a propriedade `p2`
não é adicionada no método `debugFillProperties`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class C extends Widget {
  bool get p1 => true;

  bool get [!p2!] => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('p1', p1));
  }
}
```

## Common fixes

Se não há um override de `debugFillProperties` ou
`debugDescribeChildren`, então adicione um.

Adicione uma descrição da propriedade no método `debugFillProperties` ou
`debugDescribeChildren`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class C extends Widget {
  bool get p1 => true;

  bool get p2 => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('p1', p1));
    properties.add(DiagnosticsProperty<bool>('p2', p2));
  }
}
```
