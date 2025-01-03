<!-- ia-translate: true -->
Regra{% if split_rules.size > 1 %}s{% endif %} do Linter:
{%- for rule in split_rules %}
  [{{rule}}](/tools/linter-rules/{{rule}}){%- unless forloop.last %}, {% endunless %}
{%- endfor %}
{:.linter-rule}
