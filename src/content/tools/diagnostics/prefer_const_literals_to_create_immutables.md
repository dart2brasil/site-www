---
ia-translate: true
title: prefer_const_literals_to_create_immutables
description: "Detalhes sobre o diagnóstico prefer_const_literals_to_create_immutables produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_const_literals_to_create_immutables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use literais 'const' como argumentos para construtores de classes '@immutable'._

## Description

O analisador produz este diagnóstico quando um literal de lista, mapa ou conjunto não-const
é passado como argumento para um construtor declarado em uma classe
anotada com `@immutable`.

## Example

O código a seguir produz este diagnóstico porque o literal de lista
(`[1]`) está sendo passado para um construtor em uma classe imutável mas não é
uma lista constante:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = C([![1]!]);
```

## Common fixes

Se o contexto pode ser tornado um [constant context][], faça isso:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

const C c = C([1]);
```

Se o contexto não pode ser tornado um [constant context][] mas o construtor
pode ser invocado usando `const`, adicione `const` antes da invocação
do construtor:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = const C([1]);
```

Se o contexto não pode ser tornado um [constant context][] e o construtor
não pode ser invocado usando `const`, adicione a keyword `const` antes do
literal de coleção:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = C(const [1]);
```

[constant context]: /resources/glossary#constant-context
