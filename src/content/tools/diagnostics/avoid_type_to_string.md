---
ia-translate: true
title: avoid_type_to_string
description: "Detalhes sobre o diagnóstico avoid_type_to_string produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_type_to_string"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Usar 'toString' em um 'Type' não é seguro em código de produção._

## Description

O analisador produz este diagnóstico quando o método `toString` é
invocado em um valor cujo tipo estático é `Type`.

## Example

O código a seguir produz este diagnóstico porque o método `toString`
é invocado no `Type` retornado por `runtimeType`:

```dart
bool isC(Object o) => o.runtimeType.[!toString!]() == 'C';

class C {}
```

## Common fixes

Se é essencial que o tipo seja exatamente o mesmo, então use uma
comparação explícita:

```dart
bool isC(Object o) => o.runtimeType == C;

class C {}
```

Se não há problema para instâncias de subtipos do tipo retornarem `true`,
então use uma verificação de tipo:

```dart
bool isC(Object o) => o is C;

class C {}
```
