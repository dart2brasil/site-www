---
ia-translate: true
title: ambiguous_set_or_map_literal_either
description: "Detalhes sobre o diagnóstico ambiguous_set_or_map_literal_either produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Este literal deve ser um map ou um set, mas os elementos não têm informação suficiente para a inferência de tipo funcionar._

## Descrição

Como os literais map e set usam os mesmos delimitadores (`{` e `}`), o
analisador olha para os argumentos de tipo e os elementos para determinar qual
tipo de literal você quis dizer. Quando não há argumentos de tipo e todos os
elementos são elementos spread (que são permitidos em ambos os tipos de literais)
então o analisador usa os tipos das expressões que estão sendo espalhadas.
Se todas as expressões têm o tipo `Iterable`, então é um literal set;
se todas têm o tipo `Map`, então é um literal map.

Este diagnóstico é produzido quando nenhuma das expressões sendo espalhadas tem
um tipo que permita ao analisador decidir se você estava escrevendo um literal
map ou um literal set.

## Exemplo

O código a seguir produz este diagnóstico:

```dart
union(a, b) => [!{...a, ...b}!];
```

O problema ocorre porque não há argumentos de tipo, e não há
informação sobre o tipo de `a` ou `b`.

## Correções comuns

Existem três formas comuns de corrigir este problema. A primeira é adicionar argumentos de
tipo ao literal. Por exemplo, se o literal pretende ser um
literal map, você pode escrever algo assim:

```dart
union(a, b) => <String, String>{...a, ...b};
```

A segunda correção é adicionar informação de tipo para que as expressões tenham
ou o tipo `Iterable` ou o tipo `Map`. Você pode adicionar um cast explícito
ou, neste caso, adicionar tipos às declarações dos dois parâmetros:

```dart
union(List<int> a, List<int> b) => {...a, ...b};
```

A terceira correção é adicionar informação de contexto. Neste caso, isso significa
adicionar um tipo de retorno à função:

```dart
Set<String> union(a, b) => {...a, ...b};
```

Em outros casos, você pode adicionar um tipo em outro lugar. Por exemplo, digamos que o
código original se pareça com isto:

```dart
union(a, b) {
  var x = [!{...a, ...b}!];
  return x;
}
```

Você pode adicionar uma anotação de tipo em `x`, assim:

```dart
union(a, b) {
  Map<String, String> x = {...a, ...b};
  return x;
}
```
