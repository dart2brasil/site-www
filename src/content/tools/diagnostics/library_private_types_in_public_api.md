---
title: library_private_types_in_public_api
description: "Detalhes sobre o diagnóstico library_private_types_in_public_api produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_private_types_in_public_api"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso inválido de um tipo privado em uma API pública._

## Descrição

O analisador produz este diagnóstico quando um tipo que não faz parte da
API pública de uma library é referenciado na API pública dessa library.

Usar um tipo privado em uma API pública pode tornar a API inutilizável fora da
library onde foi definida.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro `c` da
função pública `f` tem um tipo que é privado da library (`_C`):

```dart
void f([!_C!] c) {}

class _C {}
```

## Correções comuns

Se a API não precisa ser usada fora da library onde foi definida, então torne-a
privada:

```dart
void _f(_C c) {}

class _C {}
```

Se a API precisa fazer parte da API pública da library, então use
um tipo diferente que seja público, ou torne o tipo referenciado público:

```dart
void f(C c) {}

class C {}
```
