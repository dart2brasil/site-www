---
ia-translate: true
title: avoid_init_to_null
description: "Detalhes sobre o diagnóstico avoid_init_to_null produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_init_to_null"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Inicialização redundante para 'null'._

## Description

O analisador produz este diagnóstico quando uma variável nullable é
explicitamente inicializada para `null`. A variável pode ser uma variável local,
campo ou variável de nível superior.

Uma variável ou campo que não é explicitamente inicializado automaticamente é
inicializado para `null`. Não há conceito de "memória não inicializada" em
Dart.

## Example

O código a seguir produz este diagnóstico porque a variável `f` é
explicitamente inicializada para `null`:

```dart
class C {
  int? [!f = null!];

  void m() {
    if (f != null) {
      print(f);
    }
  }
}
```

## Common fixes

Remova a inicialização desnecessária:

```dart
class C {
  int? f;

  void m() {
    if (f != null) {
      print(f);
    }
  }
}
```
