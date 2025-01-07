<!-- ia-translate: true -->
{% for lint in linter_rules %}

{% if lint.state != "internal" %}

<div
  class="lint-card"
  id="{{lint.name}}"
  {%- if lint.state == "stable" and not lint.sinceDartSdk contains "wip" %} data-stable="true"{% endif -%}
  {%- if lint.fixStatus == "hasFix" %} data-has-fix="true"{% endif -%}
  {%- if lint.sets contains "core" %} data-in-core="true"{% endif -%}
  {%- if lint.sets contains "recommended" %} data-in-recommended="true"{% endif -%}
  {%- if lint.sets contains "flutter" %} data-in-flutter="true"{% endif -%}>
<h3 class="card-title">{{lint.name | underscoreBreaker}}</h3>

{{lint.description}}

<div class="card-actions">
<div class="leading">
{% if lint.state == "removed" -%}
<span class="material-symbols removed-lints" title="Lint foi removido" aria-label="Lint foi removido">error</span>
{% elsif lint.state == "deprecated" -%}
<span class="material-symbols deprecated-lints" title="Lint está obsoleto" aria-label="Lint está obsoleto">warning</span>
{% elsif lint.state == "experimental" -%}
<span class="material-symbols experimental-lints" title="Lint é experimental" aria-label="Lint é experimental">science</span>
{% elsif lint.sinceDartSdk contains "wip" -%}
<span class="material-symbols wip-lints" title="Lint não foi lançado" aria-label="Lint não foi lançado">pending</span>
{% endif -%}
{% if lint.fixStatus == "hasFix" -%}
<span class="material-symbols has-fix" title="Possui correção rápida" aria-label="Possui correção rápida">build</span>
{% endif -%}
{% if lint.sets contains "core" -%}
<span class="material-symbols" title="Incluído no conjunto de lint core" aria-label="Incluído no conjunto de lint core">circles</span>
{% endif -%}
{% if lint.sets contains "recommended" -%}
<span class="material-symbols" title="Incluído no conjunto de lint recomendado" aria-label="Incluído no conjunto de lint recomendado">thumb_up</span>
{% endif -%}
{% if lint.sets contains "flutter" -%}
<span class="material-symbols" title="Incluído no conjunto de lint do Flutter" aria-label="Incluído no conjunto de lint do Flutter">flutter</span>
{% endif -%}
</div>

<div class="trailing">
<a href="/tools/linter-rules/{{lint.name}}" title="Saiba mais sobre este lint e quando habilitá-lo.">Saiba mais</a>
<button class="copy-button hidden" title="Copiar {{lint.name}} para a sua área de transferência.">Copiar</button>
</div>

</div>
</div>

{% endif %}

{% endfor %}
