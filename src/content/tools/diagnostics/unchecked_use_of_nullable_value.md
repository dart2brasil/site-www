---
ia-translate: true
title: unchecked_use_of_nullable_value
description: "Detalhes sobre o diagnóstico unchecked_use_of_nullable_value produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma expressão nullable não pode ser usada como condição._

_Uma expressão nullable não pode ser usada como iterador em um loop for-in._

_Uma expressão nullable não pode ser usada em um spread._

_Uma expressão nullable não pode ser usada em uma declaração yield-each._

_A função não pode ser invocada incondicionalmente porque pode ser 'null'._

_O método '{0}' não pode ser invocado incondicionalmente porque o receptor pode ser 'null'._

_O operador '{0}' não pode ser invocado incondicionalmente porque o receptor pode ser 'null'._

_A propriedade '{0}' não pode ser acessada incondicionalmente porque o receptor pode ser 'null'._

## Descrição

O analisador produz este diagnóstico quando uma expressão cujo tipo é
[potentially non-nullable][] é desreferenciada sem primeiro verificar que
o valor não é `null`.

## Exemplo

O código a seguir produz este diagnóstico porque `s` pode ser `null` no
ponto onde é referenciado:

```dart
void f(String? s) {
  if (s.[!length!] > 3) {
    // ...
  }
}
```

## Correções comuns

Se o valor realmente pode ser `null`, então adicione um teste para garantir que membros
sejam acessados apenas quando o valor não for `null`:

```dart
void f(String? s) {
  if (s != null && s.length > 3) {
    // ...
  }
}
```

Se a expressão for uma variável e o valor nunca deve ser `null`, então
altere o tipo da variável para ser não-nullable:

```dart
void f(String s) {
  if (s.length > 3) {
    // ...
  }
}
```

Se você acredita que o valor da expressão nunca deve ser `null`, mas
não pode alterar o tipo da variável, e está disposto a arriscar
ter uma exceção lançada em tempo de execução se estiver errado, então você pode afirmar
que o valor não é null:

```dart
void f(String? s) {
  if (s!.length > 3) {
    // ...
  }
}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
