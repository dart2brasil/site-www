<!-- ia-translate: true -->
{% for lint in linter_rules %}

{% if lint.state != "internal" %}

{% assign badges = "" %}

{% if lint.sets != empty %}

{% for set in lint.sets %}

{% if set == "core" or set == "recommended" %}
{% assign set_link = "lints" %}
{% elsif set == "flutter" %}
{% assign set_link = "flutter_lints" %}
{% else %}
{% assign set_link = set %}
{% endif %}

{%- capture rule_set -%}
<a href="/tools/linter-rules#{{set_link}}">
    <img src="/assets/img/tools/linter/style-{{set}}.svg" alt="Conjunto de regras {{set}}">
</a>
{% endcapture %}

{%- assign badges = badges | append: rule_set -%}

{% endfor %}

{% endif %}

{% if lint.fixStatus == "hasFix" %}
{%- capture has_fix -%}
<a href="/tools/linter-rules#quick-fixes">
<img src="/assets/img/tools/linter/has-fix.svg" alt="Possui correção rápida">
</a>
{% endcapture %}

{%- assign badges = badges | append: has_fix -%}
{% endif %}

<a id="{{lint.name}}"></a>
{% if lint.sinceDartSdk contains "wip" %}
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}}) _(Não lançado)_
{% elsif lint.state != "stable" %}
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}}) _({{lint.state | capitalize}})_
{% else %}
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}})
{% endif -%}
{% if badges != empty %}<br>{{ badges }}{% endif -%}<br>{{lint.description}}

{% endif %}

{% endfor %}
