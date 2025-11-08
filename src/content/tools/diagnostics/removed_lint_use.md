---
ia-translate: true
title: removed_lint_use
description: >-
  Detalhes sobre o diagnóstico removed_lint_use
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' foi removido no Dart '{1}'_

## Description

O analisador produz este diagnóstico quando um lint que foi removido é
usado em um arquivo de opções de análise. Como o lint não existe mais,
referenciá-lo não terá efeito.

## Example

Supondo que o lint `removed_lint` foi removido, o seguinte
arquivo de opções produz este diagnóstico:

```yaml
linter:
  rules:
  - always_put_required_named_parameters_first
  - [!removed_lint!]
```

## Common fixes

Remova a referência ao código do lint:

```yaml
linter:
  rules:
  - always_put_required_named_parameters_first
```
