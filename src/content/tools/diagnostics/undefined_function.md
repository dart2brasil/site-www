---
ia-translate: true
title: undefined_function
description: >-
  Detalhes sobre o diagnóstico undefined_function
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A função '{0}' não está definida._

## Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de uma função, mas não está definido ou não está
visível no escopo em que está sendo referenciado.

## Exemplo

O código a seguir produz este diagnóstico porque o nome `emty` não está
definido:

```dart
List<int> empty() => [];

void main() {
  print([!emty!]());
}
```

## Correções comuns

Se o identificador não está definido, então defina-o ou substitua-o pelo
nome de uma função que está definida. O exemplo acima pode ser corrigido
corrigindo a ortografia da função:

```dart
List<int> empty() => [];

void main() {
  print(empty());
}
```

Se a função está definida mas não está visível, então você provavelmente precisa adicionar
um import ou reorganizar seu código para tornar a função visível.
