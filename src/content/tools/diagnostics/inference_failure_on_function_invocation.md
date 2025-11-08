---
ia-translate: true
title: inference_failure_on_function_invocation
description: >-
  Detalhes sobre o diagnóstico inference_failure_on_function_invocation
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Os argumentos de tipo da função '{0}' não podem ser inferidos._

## Descrição

O analisador produz este diagnóstico quando:
- a opção de linguagem `strict-inference` está habilitada no arquivo de opções de análise,
- a invocação de um método ou função não possui argumentos de tipo, e
- os valores dos argumentos de tipo não podem ser inferidos.

## Exemplo

Dado um arquivo de opções de análise contendo o seguinte:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque a invocação de `m`
não possui argumentos de tipo explícitos e os argumentos não podem ser inferidos:

```dart
abstract class C {
  void m<T>();
}

void f(C c) {
  c.[!m!]();
}
```

## Correções comuns

Forneça argumentos de tipo explícitos para a invocação:

```dart
abstract class C {
  void m<T>();
}

void f(C c) {
  c.m<int>();
}
```
