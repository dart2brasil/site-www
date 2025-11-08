---
ia-translate: true
title: ambiguous_set_or_map_literal_both
description: "Detalhes sobre o diagnóstico ambiguous_set_or_map_literal_both produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O literal não pode ser nem um map nem um set porque contém pelo menos uma entrada de map literal ou um operador spread espalhando um 'Map', e pelo menos um elemento que não é nenhum desses._

## Descrição

Como os literais map e set usam os mesmos delimitadores (`{` e `}`), o
analisador olha para os argumentos de tipo e os elementos para determinar qual
tipo de literal você quis dizer. Quando não há argumentos de tipo, então o
analisador usa os tipos dos elementos. Se todos os elementos são entradas de
map literal e todos os operadores spread estão espalhando um `Map` então é
um `Map`. Se nenhum dos elementos é uma entrada de map literal e todos os
operadores spread estão espalhando um `Iterable`, então é um `Set`. Se nenhum
desses é verdadeiro então é ambíguo.

O analisador produz este diagnóstico quando pelo menos um elemento é uma
entrada de map literal ou um operador spread espalhando um `Map`, e pelo menos um
elemento não é nenhum desses, tornando impossível para o analisador
determinar se você está escrevendo um literal map ou um literal set.

## Exemplo

O código a seguir produz este diagnóstico:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    [!{...a, ...b, ...c}!];
```

A lista `b` só pode ser espalhada em um set, e os maps `a` e `c` só podem
ser espalhados em um map, e o literal não pode ser ambos.

## Correções comuns

Existem duas formas comuns de corrigir este problema. A primeira é remover todos
os elementos spread de um tipo ou outro, para que os elementos sejam
consistentes. Neste caso, isso provavelmente significa remover a lista e decidir
o que fazer sobre o parâmetro agora não utilizado:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    {...a, ...c};
```

A segunda correção é mudar os elementos de um tipo em elementos que são
consistentes com os outros elementos. Por exemplo, você pode adicionar os elementos
da lista como chaves que mapeiam para si mesmos:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    {...a, for (String s in b) s: s, ...c};
```
