---
ia-translate: true
title: on_repeated
description: "Detalhes sobre o diagnóstico on_repeated produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' pode ser incluído nas restrições de superclasse apenas uma vez._

## Description

O analisador produz este diagnóstico quando o mesmo tipo é listado nas
restrições de superclasse de um mixin múltiplas vezes.

## Example

O código a seguir produz este diagnóstico porque `A` é incluído duas vezes
nas restrições de superclasse para `M`:

```dart
mixin M on A, [!A!] {
}

class A {}
class B {}
```

## Common fixes

Se um tipo diferente deve ser incluído nas restrições de superclasse, então
substitua uma das ocorrências pelo outro tipo:

```dart
mixin M on A, B {
}

class A {}
class B {}
```

Se nenhum outro tipo foi pretendido, então remova o nome de tipo repetido:

```dart
mixin M on A {
}

class A {}
class B {}
```
