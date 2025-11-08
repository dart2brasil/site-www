---
ia-translate: true
title: inference_failure_on_collection_literal
description: >-
  Detalhes sobre o diagnóstico inference_failure_on_collection_literal
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Os argumentos de tipo de '{0}' não podem ser inferidos._

## Descrição

O analisador produz este diagnóstico quando:
- a opção de linguagem `strict-inference` está habilitada no arquivo de opções de análise,
- um literal de lista, mapa ou conjunto não possui argumentos de tipo, e
- os valores dos argumentos de tipo não podem ser inferidos dos elementos.

## Exemplo

Dado um arquivo de opções de análise contendo o seguinte:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque o tipo dos elementos
do literal de lista não pode ser inferido:

```dart
void f() {
  var list = [![]!];
  print(list);
}
```

## Correções comuns

Forneça argumentos de tipo explícitos para o literal:

```dart
void f() {
  var list = <int>[];
  print(list);
}
```
