---
ia-translate: true
title: prefer_iterable_wheretype
description: "Detalhes sobre o diagnóstico prefer_iterable_wheretype produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_iterable_whereType"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'whereType' para selecionar elementos de um determinado tipo._

## Description

O analisador produz este diagnóstico quando o método `Iterable.where` está
sendo usado para filtrar elementos com base em seu tipo.

## Example

O código a seguir produz este diagnóstico porque o método `where` está
sendo usado para acessar apenas as strings dentro do iterável:

```dart
Iterable<Object> f(Iterable<Object> p) => p.[!where!]((e) => e is String);
```

## Common fixes

Reescreva o código para usar `whereType`:

```dart
Iterable<String> f(Iterable<Object> p) => p.whereType<String>();
```

Isso também pode permitir que você reforce os tipos em seu código ou remova
outras verificações de tipo.
