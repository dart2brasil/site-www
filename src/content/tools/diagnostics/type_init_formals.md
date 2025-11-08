---
ia-translate: true
title: type_init_formals
description: >-
  Detalhes sobre o diagnóstico type_init_formals
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/type_init_formals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não anote desnecessariamente os tipos de parâmetros formais de inicialização._

## Descrição

O analisador produz este diagnóstico quando um parâmetro formal
de inicialização (`this.x`) ou um parâmetro super (`super.x`) possui uma anotação de tipo
explícita que é a mesma do campo ou parâmetro sobrescrito.

Se um parâmetro de construtor está usando `this.x` para inicializar um campo, então
o tipo do parâmetro é implicitamente o mesmo tipo do campo. Se um
parâmetro de construtor está usando `super.x` para encaminhar para um construtor
super, então o tipo do parâmetro é implicitamente o mesmo do
parâmetro do construtor super.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro `this.c`
possui um tipo explícito que é o mesmo do campo `c`:

```dart
class C {
  int c;

  C([!int!] this.c);
}
```

O código a seguir produz este diagnóstico porque o parâmetro
`super.a` possui um tipo explícito que é o mesmo do parâmetro `a` da
superclasse:

```dart
class A {
  A(int a);
}

class B extends A {
  B([!int!] super.a);
}
```

## Correções comuns

Remova a anotação de tipo do parâmetro:

```dart
class C {
  int c;

  C(this.c);
}
```
