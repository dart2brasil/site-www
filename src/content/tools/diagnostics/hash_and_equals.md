---
ia-translate: true
title: hash_and_equals
description: >-
  Detalhes sobre o diagnóstico hash_and_equals
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/hash_and_equals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Falta um override correspondente de '{0}'._

## Description

O analisador produz este diagnóstico quando uma classe ou mixin
faz override da definição de `==` mas não faz override da definição de
`hashCode`, ou, inversamente, faz override da definição de `hashCode` mas
não faz override da definição de `==`.

Tanto o operador `==` quanto a propriedade `hashCode` dos objetos devem ser
consistentes para que uma implementação comum de hash map funcione corretamente. Como
resultado, ao fazer override de um dos métodos, ambos devem ter override.

## Example

O código a seguir produz este diagnóstico porque a classe `C`
faz override do operador `==` mas não faz override do getter `hashCode`:

```dart
class C {
  final int value;

  C(this.value);

  @override
  bool operator [!==!](Object other) =>
      other is C &&
      other.runtimeType == runtimeType &&
      other.value == value;
}
```

## Common fixes

Se você precisa fazer override de um dos membros, então adicione um override do
outro:

```dart
class C {
  final int value;

  C(this.value);

  @override
  bool operator ==(Object other) =>
      other is C &&
      other.runtimeType == runtimeType &&
      other.value == value;

  @override
  int get hashCode => value.hashCode;
}
```

Se você não precisa fazer override de nenhum dos membros, então remova o
override desnecessário:

```dart
class C {
  final int value;

  C(this.value);
}
```
