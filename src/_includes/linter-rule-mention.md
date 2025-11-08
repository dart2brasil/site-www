---
ia-translate: true
---
{%- assign split_rules = rules | split: ', ' -%}
Regra{% if split_rules.size > 1 %}s{% endif %} do linter:
{%- for rule in split_rules %}
  [{{rule}}](/tools/linter-rules/{{rule}}){%- unless forloop.last %}, {% endunless %}
{%- endfor %}
{:.linter-rule}
