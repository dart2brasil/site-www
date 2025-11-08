---
ia-translate: true
title: const_constructor_with_non_final_field
description: >-
  Detalhes sobre o diagnóstico const_constructor_with_non_final_field
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Can't define a const constructor for a class with non-final fields._

## Descrição

O analisador produz este diagnóstico quando um constructor é marcado como
constructor const, mas o constructor é definido em uma classe que tem pelo
menos um field de instância não final (seja diretamente ou por herança).

## Exemplo

O código a seguir produz este diagnóstico porque o field `x` não é
final:

```dart
class C {
  int x;

  const [!C!](this.x);
}
```

## Correções comuns

Se é possível marcar todos os fields como final, então faça isso:

```dart
class C {
  final int x;

  const C(this.x);
}
```

Se não é possível marcar todos os fields como final, então remova a
keyword `const` do constructor:

```dart
class C {
  int x;

  C(this.x);
}
```
