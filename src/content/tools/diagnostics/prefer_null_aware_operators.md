---
ia-translate: true
title: prefer_null_aware_operators
description: "Detalhes sobre o diagnóstico prefer_null_aware_operators produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_null_aware_operators"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use o operador null-aware '?.' em vez de uma comparação explícita com 'null'._

## Description

O analisador produz este diagnóstico quando uma comparação com `null` é
usada para proteger uma referência de membro, e `null` é usado como resultado quando o
alvo protegido é `null`.

## Example

O código a seguir produz este diagnóstico porque a invocação de
`length` é protegida por uma comparação com `null` mesmo que o valor padrão
seja `null`:

```dart
int? f(List<int>? p) {
  return [!p == null ? null : p.length!];
}
```

## Common fixes

Use um operador de acesso null-aware em vez disso:

```dart
int? f(List<int>? p) {
  return p?.length;
}
```
