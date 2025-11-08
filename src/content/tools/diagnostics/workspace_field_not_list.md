---
ia-translate: true
title: workspace_field_not_list
description: "Detalhes sobre o diagnóstico workspace_field_not_list produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor do campo 'workspace' é obrigatório para ser uma lista de caminhos de arquivos relativos._

## Descrição

O analisador produz este diagnóstico quando o valor da chave `workspace`
não é uma lista.

## Exemplo

O código a seguir produz este diagnóstico porque o valor da
chave `workspace` é uma string quando uma lista é esperada:

```yaml
name: example
workspace: [!notPaths!]
```

## Correções comuns

Altere o valor do campo workspace para que seja uma lista:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
