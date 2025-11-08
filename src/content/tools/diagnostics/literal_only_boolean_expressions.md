---
title: literal_only_boolean_expressions
description: "Detalhes sobre o diagnóstico literal_only_boolean_expressions produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/literal_only_boolean_expressions"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_A expressão booleana tem um valor constante._

## Descrição

O analisador produz este diagnóstico quando o valor da condição em
uma instrução `if` ou loop é conhecido por ser sempre `true` ou sempre
`false`. Uma exceção é feita para um loop `while` cuja condição é o
literal booleano `true`.

## Exemplos

O código a seguir produz este diagnóstico porque a condição sempre
será avaliada como `true`:

```dart
void f() {
  [!if (true) {!]
    [!print('true');!]
  [!}!]
}
```

O lint avaliará um subconjunto de expressões que são compostas de
constantes, então o código a seguir também produzirá este diagnóstico porque
a condição sempre será avaliada como `false`:

```dart
void g(int i) {
  [!if (1 == 0 || 3 > 4) {!]
    [!print('false');!]
  [!}!]
}
```

## Correções comuns

Se a condição está errada, então corrija a condição para que seu valor
não possa ser conhecido em tempo de compilação:

```dart
void g(int i) {
  if (i == 0 || i > 4) {
    print('false');
  }
}
```

Se a condição está correta, então simplifique o código para não avaliar a
condição:

```dart
void f() {
  print('true');
}
```
