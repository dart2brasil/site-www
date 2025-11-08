---
ia-translate: true
title: unrelated_type_equality_checks
description: >-
  Detalhes sobre o diagnóstico unrelated_type_equality_checks
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unrelated_type_equality_checks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O tipo do operando ('{0}') não é um subtipo ou um supertipo do valor sendo comparado ('{1}')._

_O tipo do operando direito ('{0}') não é um subtipo ou um supertipo do operando esquerdo ('{1}')._

## Description

O analisador produz este diagnóstico quando dois objetos estão sendo comparados
e nenhum dos tipos estáticos dos dois objetos é um subtipo do
outro.

Tal comparação geralmente retornará `false` e pode não refletir a
intenção do programador.

Pode haver falsos positivos. Por exemplo, uma classe chamada `Point` pode
ter subclasses chamadas `CartesianPoint` e `PolarPoint`, nenhuma das quais
é um subtipo da outra, mas ainda pode ser apropriado testar a
igualdade das instâncias.

Como um caso concreto, as classes `Int64` e `Int32` de `package:fixnum`
permitem comparar instâncias a um `int` desde que o `int` esteja no
lado direito. Este caso é especificamente permitido pelo diagnóstico, mas
outros casos semelhantes não são.

## Example

O código a seguir produz este diagnóstico porque o string `s` está
sendo comparado ao inteiro `1`:

```dart
bool f(String s) {
  return s [!==!] 1;
}
```

## Common fixes

Substitua um dos operandos por algo compatível com o outro
operando:

```dart
bool f(String s) {
  return s.length == 1;
}
```
