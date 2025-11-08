---
ia-translate: true
title: extension_as_expression
description: >-
  Detalhes sobre o diagnóstico extension_as_expression
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extension '{0}' não pode ser usada como uma expressão._

## Descrição

O analisador produz este diagnóstico quando o nome de uma extension é usado
em uma expressão diferente de um override de extension ou para qualificar um
acesso a um membro static da extension. Como classes definem um tipo,
o nome de uma classe pode ser usado para referenciar a instância de `Type`
representando o tipo da classe. Extensions, por outro lado, não
definem um tipo e não podem ser usadas como um literal de tipo.

## Exemplo

O código a seguir produz este diagnóstico porque `E` é uma extension:

```dart
extension E on int {
  static String m() => '';
}

var x = [!E!];
```

## Correções comuns

Substitua o nome da extension por um nome que possa ser referenciado, como
um membro static definido na extension:

```dart
extension E on int {
  static String m() => '';
}

var x = E.m();
```
