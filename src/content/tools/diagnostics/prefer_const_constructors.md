---
ia-translate: true
title: prefer_const_constructors
description: >-
  Detalhes sobre o diagnóstico prefer_const_constructors
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_const_constructors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'const' com o construtor para melhorar o desempenho._

## Description

O analisador produz este diagnóstico quando uma invocação de um construtor const
não é precedida por `const` nem está em um [constant context][].

## Example

O código a seguir produz este diagnóstico porque a invocação do
construtor `const` não está prefixada por `const` nem em um
[constant context][]:

```dart
class C {
  const C();
}

C c = [!C()!];
```

## Common fixes

Se o contexto pode ser tornado um [constant context][], faça isso:

```dart
class C {
  const C();
}

const C c = C();
```

Se o contexto não pode ser tornado um [constant context][], adicione `const`
antes da invocação do construtor:

```dart
class C {
  const C();
}

C c = const C();
```

[constant context]: /resources/glossary#constant-context
