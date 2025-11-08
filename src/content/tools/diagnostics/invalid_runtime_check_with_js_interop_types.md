---
ia-translate: true
title: invalid_runtime_check_with_js_interop_types
description: "Detalhes sobre o diagnóstico invalid_runtime_check_with_js_interop_types produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/invalid_runtime_check_with_js_interop_types"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Cast de '{0}' para '{1}' converte um valor Dart para um tipo JS interop, o que pode não ser consistente entre plataformas._

_Cast de '{0}' para '{1}' converte um valor JS interop para um tipo Dart, o que pode não ser consistente entre plataformas._

_Cast de '{0}' para '{1}' converte um valor JS interop para um tipo JS interop incompatível, o que pode não ser consistente entre plataformas._

_Verificação em tempo de execução entre '{0}' e '{1}' verifica se um valor Dart é um tipo JS interop, o que pode não ser consistente entre plataformas._

_Verificação em tempo de execução entre '{0}' e '{1}' verifica se um valor JS interop é um tipo Dart, o que pode não ser consistente entre plataformas._

_Verificação em tempo de execução entre '{0}' e '{1}' envolve uma verificação em tempo de execução não trivial entre dois tipos JS interop que pode não ser consistente entre plataformas._

_Verificação em tempo de execução entre '{0}' e '{1}' envolve uma verificação em tempo de execução entre um valor JS interop e um tipo JS interop não relacionado que sempre será true e não verificará o tipo subjacente._

## Description

O analisador produz este diagnóstico quando um teste `is` possui:
- um tipo JS interop no lado direito, seja diretamente ou como um argumento
  de tipo para outro tipo, ou
- um valor JS interop no lado esquerdo.

## Examples

O código a seguir produz este diagnóstico porque o tipo JS interop
`JSBoolean` está no lado direito de um teste `is`:

```dart
import 'dart:js_interop';

bool f(Object b) => [!b is JSBoolean!];
```

O código a seguir produz este diagnóstico porque o tipo JS interop
`JSString` é usado como um argumento de tipo no lado direito de um teste
`is`:

```dart
import 'dart:js_interop';

bool f(List<Object> l) => [!l is List<JSString>!];
```

O código a seguir produz este diagnóstico porque o valor JS interop
`a` está no lado esquerdo de um teste `is`:

```dart
import 'dart:js_interop';

bool f(JSAny a) => [!a is String!];
```

## Common fixes

Use um helper JS interop, como `isA`, para verificar o tipo subjacente de
valores JS interop:

```dart
import 'dart:js_interop';

void f(Object b) => b.jsify()?.isA<JSBoolean>();
```
