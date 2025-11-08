---
ia-translate: true
title: type_parameter_referenced_by_static
description: "Detalhes sobre o diagnóstico type_parameter_referenced_by_static produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Membros static não podem referenciar parâmetros de tipo da classe._

## Descrição

O analisador produz este diagnóstico quando um membro static referencia um
parâmetro de tipo que é declarado para a classe. Parâmetros de tipo só têm
significado para instâncias da classe.

## Exemplo

O código a seguir produz este diagnóstico porque o método static
`hasType` possui uma referência ao parâmetro de tipo `T`:

```dart
class C<T> {
  static bool hasType(Object o) => o is [!T!];
}
```

## Correções comuns

Se o membro puder ser um membro de instância, então remova a keyword `static`:

```dart
class C<T> {
  bool hasType(Object o) => o is T;
}
```

Se o membro deve ser um membro static, então torne o membro genérico:

```dart
class C<T> {
  static bool hasType<S>(Object o) => o is S;
}
```

Observe, no entanto, que não há uma relação entre `T` e `S`, então esta
segunda opção altera a semântica do que provavelmente foi o pretendido.
