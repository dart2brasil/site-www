---
ia-translate: true
title: Todas as regras do linter
description: Configuração gerada automaticamente que habilita todas as regras do linter.
toc: false
show_breadcrumbs: true
---

A seguir está uma lista gerada automaticamente de todas as regras do linter
disponíveis no SDK Dart a partir da versão `{{site.sdkVersion}}`.
Adicione-as ao seu
arquivo [`analysis_options.yaml`](/tools/analysis)
e ajuste conforme achar melhor.

{% assign sorted_lints = linter_rules | sort: "name" %}

```yaml title="analysis_options.yaml"
linter:
  rules:
    {% for lint in sorted_lints %}
    {%- if lint.sinceDartSdk != "Unreleased" and lint.sinceDartSdk not contains "-wip" and lint.state != "removed" and lint.state != "internal" -%}
    - {{lint.name}}
    {% endif -%}
    {%- endfor %}
```