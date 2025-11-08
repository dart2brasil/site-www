---
ia-translate: true
title: inference_failure_on_function_return_type
description: >-
  Detalhes sobre o diagnóstico inference_failure_on_function_return_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de retorno de '{0}' não pode ser inferido._

## Descrição

O analisador produz este diagnóstico quando:
- a opção de linguagem `strict-inference` está habilitada no arquivo de opções de análise,
- a declaração de um método ou função não possui tipo de retorno, e
- o tipo de retorno não pode ser inferido.

## Exemplo

Dado um arquivo de opções de análise contendo o seguinte:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque o método `m` não
possui um tipo de retorno:

```dart
class C {
  [!m!]() => 7;
}
```

## Correções comuns

Adicione um tipo de retorno ao método ou função:

```dart
class C {
  int m() => 7;
}
```
