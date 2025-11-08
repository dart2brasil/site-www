---
title: body_might_complete_normally
description: "Detalhes sobre o diagnóstico body_might_complete_normally produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O body pode completar normalmente, fazendo com que 'null' seja retornado, mas o tipo de retorno, '{0}', é um tipo potencialmente não-anulável._

## Description

O analisador produz este diagnóstico quando um método ou função tem um
tipo de retorno que é [potencialmente não-anulável][potentially non-nullable] mas retornaria implicitamente
`null` se o controle atingisse o final da função.

## Examples

O código a seguir produz este diagnóstico porque o método `m` tem um
retorno implícito de `null` inserido no final do método, mas o método
está declarado para não retornar `null`:

```dart
class C {
  int [!m!](int t) {
    print(t);
  }
}
```

O código a seguir produz este diagnóstico porque o método `m` tem um
retorno implícito de `null` inserido no final do método, mas como
a classe `C` pode ser instanciada com um argumento de tipo não-anulável, o
método está efetivamente declarado para não retornar `null`:

```dart
class C<T> {
  T [!m!](T t) {
    print(t);
  }
}
```

## Common fixes

Se houver um valor razoável que possa ser retornado, então adicione uma instrução `return`
no final do método:

```dart
class C<T> {
  T m(T t) {
    print(t);
    return t;
  }
}
```

Se o método não alcançará o retorno implícito, então adicione um `throw` no
final do método:

```dart
class C<T> {
  T m(T t) {
    print(t);
    throw '';
  }
}
```

Se o método intencionalmente retorna `null` no final, então adicione um
retorno explícito de `null` no final do método e altere o
tipo de retorno para que seja válido retornar `null`:

```dart
class C<T> {
  T? m(T t) {
    print(t);
    return null;
  }
}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
