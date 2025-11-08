---
ia-translate: true
title: null_check_on_nullable_type_parameter
description: >-
  Detalhes sobre o diagnóstico null_check_on_nullable_type_parameter
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/null_check_on_nullable_type_parameter"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The null check operator shouldn't be used on a variable whose type is a potentially nullable type parameter._

## Description

O analisador produz este diagnóstico quando um operador de verificação null é usado
em uma variável cujo tipo é `T?`, onde `T` é um parâmetro de tipo que
permite que o argumento de tipo seja nullable (não possui bound ou possui um
bound que é nullable).

Dado um parâmetro de tipo genérico `T` que possui um bound nullable, é muito
fácil introduzir verificações null errôneas ao trabalhar com uma variável do
tipo `T?`. Especificamente, não é incomum ter `T? x;` e querer
afirmar que `x` foi definido com um valor válido do tipo `T`. Um erro
comum é fazer isso usando `x!`. Isso está quase sempre incorreto, porque
se `T` é um tipo nullable, `x` pode validamente conter `null` como um valor do tipo
`T`.

## Example

O código a seguir produz este diagnóstico porque `t` possui o tipo `T?`
e `T` permite que o argumento de tipo seja nullable (porque não possui
cláusula `extends`):

```dart
T f<T>(T? t) => t[!!!];
```

## Common fixes

Use o parâmetro de tipo para fazer cast da variável:

```dart
T f<T>(T? t) => t as T;
```
