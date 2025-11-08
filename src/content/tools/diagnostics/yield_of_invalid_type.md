---
ia-translate: true
title: yield_of_invalid_type
description: "Detalhes sobre o diagnóstico yield_of_invalid_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um valor produzido de tipo '{0}' deve ser atribuível a '{1}'._

_O tipo '{0}' implícito pela expressão 'yield*' deve ser atribuível a '{1}'._

## Descrição

O analisador produz este diagnóstico quando o tipo do objeto produzido por
uma expressão `yield` ou `yield*` não corresponde ao tipo de objetos que
devem ser retornados dos tipos `Iterable` ou `Stream` que são retornados
de um gerador (uma função ou método marcado com `sync*` ou
`async*`).

## Exemplo

O código a seguir produz este diagnóstico porque o getter `zero` é
declarado para retornar um `Iterable` que retorna inteiros, mas o `yield` está
retornando uma string do iterable:

```dart
Iterable<int> get zero sync* {
  yield [!'0'!];
}
```

## Correções comuns

Se o tipo de retorno da função está correto, então corrija a expressão
seguindo a keyword `yield` para retornar o tipo correto:

```dart
Iterable<int> get zero sync* {
  yield 0;
}
```

Se a expressão seguindo o `yield` está correta, então mude o tipo de
retorno da função para permitir isso:

```dart
Iterable<String> get zero sync* {
  yield '0';
}
```
