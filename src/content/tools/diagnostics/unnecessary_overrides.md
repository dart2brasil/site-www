---
ia-translate: true
title: unnecessary_overrides
description: >-
  Detalhes sobre o diagnóstico unnecessary_overrides
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_overrides"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Override desnecessário._

## Description

O analisador produz este diagnóstico quando um membro de instância sobrescreve um
membro herdado mas apenas invoca o membro sobrescrito com exatamente os
mesmos argumentos.

## Example

O código a seguir produz este diagnóstico porque o método `D.m`
não faz nada além de invocar o método sobrescrito:

```dart
class C {
  int m(int x) => x;
}

class D extends C {
  @override
  int [!m!](int x) => super.m(x);
}
```

## Common fixes

Se o método deve fazer algo mais do que o método sobrescrito
faz, então implemente a funcionalidade ausente:

```dart
class C {
  int m(int x) => x;
}

class D extends C {
  @override
  int m(int x) => super.m(x) + 1;
}
```

Se o método sobrescrito deve ser modificado alterando o tipo de retorno ou
um ou mais dos tipos de parâmetro, tornando um dos parâmetros
`covariant`, tendo um comentário de documentação, ou tendo anotações
adicionais, então atualize o código:

```dart
import 'package:meta/meta.dart';

class C {
  int m(int x) => x;
}

class D extends C {
  @mustCallSuper
  @override
  int m(int x) => super.m(x);
}
```

Se o método que sobrescreve não altera ou aprimora a semântica do
código, então remova-o:

```dart
class C {
  int m(int x) => x;
}

class D extends C {}
```
