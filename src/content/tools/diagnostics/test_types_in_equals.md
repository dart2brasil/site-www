---
ia-translate: true
title: test_types_in_equals
description: "Detalhes sobre o diagnóstico test_types_in_equals produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/test_types_in_equals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Teste de tipo ausente para '{0}' em '=='._

## Description

O analisador produz este diagnóstico quando uma sobrescrita do operador `==`
não inclui um teste de tipo no valor do parâmetro.

## Example

O código a seguir produz este diagnóstico porque `other` não é
testado quanto ao tipo:

```dart
class C {
  final int f;

  C(this.f);

  @override
  bool operator ==(Object other) {
    return ([!other as C!]).f == f;
  }
}
```

## Common fixes

Execute um teste `is` como parte do cálculo do valor de retorno:

```dart
class C {
  final int f;

  C(this.f);

  @override
  bool operator ==(Object other) {
    return other is C && other.f == f;
  }
}
```
