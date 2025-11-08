---
ia-translate: true
title: implementation_imports
description: "Detalhes sobre o diagnóstico implementation_imports produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/implementation_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Import de uma biblioteca no diretório 'lib/src' de outro pacote._

## Description

O analisador produz este diagnóstico quando um import referencia uma biblioteca
que está dentro do diretório `lib/src` de um pacote diferente, o que
viola [a convenção para pacotes pub](https://dart.dev/tools/pub/package-layout#implementation-files).

## Example

O código a seguir, assumindo que não faz parte do pacote `ffi`,
produz este diagnóstico porque a biblioteca sendo importada está dentro do
diretório `src` de nível superior:

```dart
import [!'package:ffi/src/allocation.dart'!];
```

## Common fixes

Se a biblioteca sendo importada contém código que faz parte da API pública,
então importe a biblioteca pública que exporta a API pública:

```dart
import 'package:ffi/ffi.dart';
```

Se a biblioteca sendo importada não faz parte da API pública do pacote,
então encontre uma maneira diferente de atingir seu objetivo, assumindo que
é possível, ou abra uma issue pedindo aos autores do pacote para torná-la parte
da API pública.
