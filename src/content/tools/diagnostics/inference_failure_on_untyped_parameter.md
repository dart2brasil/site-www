---
ia-translate: true
title: inference_failure_on_untyped_parameter
description: "Detalhes sobre o diagnóstico inference_failure_on_untyped_parameter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de {0} não pode ser inferido; um tipo deve ser fornecido explicitamente._

## Descrição

O analisador produz este diagnóstico quando:
- a opção de linguagem `strict-inference` está habilitada no arquivo de opções de análise,
- a declaração de um parâmetro formal não possui tipo, e
- o tipo do parâmetro não pode ser inferido.

O tipo de um parâmetro de método pode ser inferido se ele sobrescreve um
método herdado.

## Exemplo

Dado um arquivo de opções de análise contendo o seguinte:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque o parâmetro formal
`p` não possui um tipo explícito e o tipo não pode ser inferido:

```dart
void f([!p!]) => print(p);
```

## Correções comuns

Adicione um tipo explícito:

```dart
void f(int p) => print(p);
```
