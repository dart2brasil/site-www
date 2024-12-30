<!-- ia-translate: true -->
Regra(s) do Linter{% if split_rules.size > 1 %}s{% endif %}:
{%- for rule in split_rules %}
  [{{rule}}](/tools/linter-rules/{{rule}}){%- unless forloop.last %}, {% endunless %}
{%- endfor %}
{:.linter-rule}
