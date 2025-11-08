---
ia-translate: true
title: use_string_buffers
description: >-
  Detalhes sobre o diagnóstico use_string_buffers
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_string_buffers"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use um string buffer em vez de '+' para compor strings._

## Descrição

O analisador produz este diagnóstico quando valores são concatenados a uma
string dentro de um loop sem usar um `StringBuffer` para fazer a
concatenação.

## Exemplo

O código a seguir produz este diagnóstico porque a string `result` é
computada por concatenação repetida dentro do loop `for`:

```dart
String f() {
  var result = '';
  for (int i = 0; i < 10; i++) {
    [!result += 'a'!];
  }
  return result;
}
```

## Correções comuns

Use um `StringBuffer` para computar o resultado:

```dart
String f() {
  var buffer = StringBuffer();
  for (int i = 0; i < 10; i++) {
    buffer.write('a');
  }
  return buffer.toString();
}
```
