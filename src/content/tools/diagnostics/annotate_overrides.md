---
ia-translate: true
title: annotate_overrides
description: "Detalhes sobre o diagnóstico annotate_overrides produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/annotate_overrides"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O membro '{0}' sobrescreve um membro herdado mas não está anotado com '@override'._

## Descrição

O analisador produz este diagnóstico quando um membro sobrescreve um membro
herdado, mas não está anotado com `@override`.

## Exemplo

O código a seguir produz este diagnóstico porque o método `m` na
classe `B` sobrescreve o método com o mesmo nome na classe `A`, mas não está
marcado como um override intencional:

```dart
class A {
  void m() {}
}

class B extends A {
  void [!m!]() {}
}
```

## Correções comuns

Se o membro na subclasse pretende sobrescrever o membro na
superclasse, então adicione uma anotação `@override`:

```dart
class A {
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```

Se o membro na subclasse não pretende sobrescrever o membro na
superclasse, então renomeie um dos membros:

```dart
class A {
  void m() {}
}

class B extends A {
  void m2() {}
}
```
