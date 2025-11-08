---
ia-translate: true
title: empty_catches
description: >-
  Detalhes sobre o diagnóstico empty_catches
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_catches"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Bloco catch empty._

## Description

O analisador produz este diagnóstico quando o bloco em uma cláusula `catch`
está empty.

## Example

O código a seguir produz este diagnóstico porque o bloco catch está
empty:

```dart
void f() {
  try {
    print('Hello');
  } catch (exception) [!{}!]
}
```

## Common fixes

Se a exceção não deve ser ignorada, então adicione código para tratar a
exceção:

```dart
void f() {
  try {
    print('We can print.');
  } catch (exception) {
    print("We can't print.");
  }
}
```

Se a exceção deve ser intencionalmente ignorada, então adicione um comentário explicando
o motivo:

```dart
void f() {
  try {
    print('We can print.');
  } catch (exception) {
    // Nothing to do.
  }
}
```

Se a exceção deve ser intencionalmente ignorada e não há uma boa
explicação do motivo, então renomeie o parâmetro da exceção:

```dart
void f() {
  try {
    print('We can print.');
  } catch (_) {}
}
```
