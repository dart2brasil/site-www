---
ia-translate: true
title: inference_failure_on_uninitialized_variable
description: "Detalhes sobre o diagnóstico inference_failure_on_uninitialized_variable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de {0} não pode ser inferido sem um tipo ou inicializador._

## Descrição

O analisador produz este diagnóstico quando:
- a opção de linguagem `strict-inference` está habilitada no arquivo de opções de análise,
- a declaração de uma variável não possui tipo, e
- o tipo da variável não pode ser inferido.

## Exemplo

Dado um arquivo de opções de análise contendo o seguinte:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque a variável `s`
não possui um tipo explícito e o tipo não pode ser inferido porque
não há um inicializador:

```dart
var [!s!];
```

## Correções comuns

Adicione um tipo explícito:

```dart
String? s;
```
