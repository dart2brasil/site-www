---
ia-translate: true
title: redirect_to_invalid_return_type
description: "Detalhes sobre o diagnóstico redirect_to_invalid_return_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de retorno '{0}' do construtor redirecionado não é um subtipo de '{1}'._

## Descrição

O analisador produz este diagnóstico quando um factory constructor redireciona
para um construtor cujo tipo de retorno não é um subtipo do tipo que o
factory constructor é declarado para produzir.

## Exemplo

O código a seguir produz este diagnóstico porque `A` não é uma subclasse
de `C`, o que significa que o valor retornado pelo construtor `A()`
não pode ser retornado do construtor `C()`:

```dart
class A {}

class B implements C {}

class C {
  factory C() = [!A!];
}
```

## Correções comuns

Se o factory constructor está redirecionando para um construtor na classe errada,
atualize o factory constructor para redirecionar para o construtor
correto:

```dart
class A {}

class B implements C {}

class C {
  factory C() = B;
}
```

Se a classe que define o construtor sendo redirecionado é a classe que
deveria ser retornada, faça dela um subtipo do tipo de retorno da factory:

```dart
class A implements C {}

class B implements C {}

class C {
  factory C() = A;
}
```
