---
ia-translate: true
pagination:
  data: linter_rules
  size: 1
  alias: lint
  addAllPagesToCollections: true
show_breadcrumbs: true
underscore_breaker_titles: true
eleventyComputed:
  permalink: "/tools/linter-rules/{{lint.name}}.html"
  title: "{{ lint.name }}"
  description: "Saiba mais sobre a regra de linter {{ lint.name }}."
skipFreshness: true
---

{{lint.description}}

{% if lint.sinceDartSdk == "Unreleased" or lint.sinceDartSdk contains "-wip" -%}
_Esta regra é atualmente **experimental**
e ainda não está disponível em um SDK estável._
{% elsif lint.state == "removed" -%}
_Esta regra foi removida a partir dos lançamentos mais recentes do Dart._
{% elsif lint.state != "stable" -%}
_Esta regra é atualmente **{{lint.state}}**
e está disponível a partir do Dart {{lint.sinceDartSdk}}._
{% else -%}
_Esta regra está disponível a partir do Dart {{lint.sinceDartSdk}}._
{% endif -%}

{% if lint.sets != empty -%}

{% assign rule_sets = "" -%}

{% for set in lint.sets -%}

{% if set == "core" or set == "recommended" -%}
{% assign set_link = "lints" %}
{% elsif set == "flutter" -%}
{% assign set_link = "flutter_lints" %}
{% else -%}
{% assign set_link = set %}
{% endif -%}

{%- capture rule_set -%}
[{{set}}](/tools/linter-rules#{{set_link}}){% if forloop.last == false %},{% endif %}
{% endcapture -%}

{%- assign rule_sets = rule_sets | append: rule_set -%}
{% endfor -%}

<em>Conjuntos de regras: {{ rule_sets }}</em>
{% endif -%}

{% if lint.fixStatus == "hasFix" %}
_Esta regra tem uma [correção rápida](/tools/linter-rules#quick-fixes) disponível._
{% endif %}

{% if lint.incompatible != empty -%}
{% assign incompatible_rules = "" -%}

{% for incompatible in lint.incompatible -%}

{%- capture incompatible_rule -%}
[{{incompatible}}](/tools/linter-rules/{{incompatible}}){% if forloop.last == false %},{% endif %}
{% endcapture -%}

{% assign incompatible_rules = incompatible_rules | append: incompatible_rule -%}
{% endfor -%}

<em>Regras incompatíveis: {{ incompatible_rules }}</em>
{% endif -%}

## Detalhes {:#details}

{{lint.details}}

## Uso {:#usage}

Para habilitar a regra `{{lint.name}}`,
adicione `{{lint.name}}` em **linter > rules** no seu
arquivo [`analysis_options.yaml`](/tools/analysis):

```yaml title="analysis_options.yaml"
linter:
  rules:
    - {{lint.name}}
```