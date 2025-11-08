---
ia-translate: true
title: overridden_fields
description: >-
  Detalhes sobre o diagnóstico overridden_fields
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/overridden_fields"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Campo sobrescreve um campo herdado de '{0}'._

## Description

O analisador produz este diagnóstico quando uma classe define um campo que
sobrescreve um campo de uma superclasse.

Sobrescrever um campo com outro campo faz com que o objeto tenha dois
campos distintos, mas como os campos têm o mesmo nome apenas um dos
campos pode ser referenciado em um determinado escopo. Isso pode levar a confusão
onde uma referência a um dos campos pode ser confundida com uma referência ao
outro.

## Example

O código a seguir produz este diagnóstico porque o campo `f` em `B`
oculta o campo `f` em `A`:

```dart
class A {
  int f = 1;
}

class B extends A {
  @override
  int [!f!] = 2;
}
```

## Common fixes

Se os dois campos estão representando a mesma propriedade, então remova o
campo da subclasse:

```dart
class A {
  int f = 1;
}

class B extends A {}
```

Se os dois campos devem ser distintos, então renomeie um dos campos:

```dart
class A {
  int f = 1;
}

class B extends A {
  int g = 2;
}
```

Se os dois campos estão relacionados de alguma forma, mas não podem ser os mesmos, então
encontre uma maneira diferente de implementar a semântica que você precisa.
