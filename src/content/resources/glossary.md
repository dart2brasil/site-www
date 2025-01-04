---
ia-translate: true
title: Glossário
description: Um glossário de referência para a terminologia usada em dartbrasil.dev.
body_class: glossary-page
---

{% comment %}
  Escreva as entradas do glossário no arquivo src/_data/glossary.yml.
{% endcomment -%}

A seguir estão as definições de termos usados na documentação Dart.

{% assign sorted_terms = glossary | sort: "term" %}

{% for term in sorted_terms -%}

<div class="term-separator" aria-hidden="true"></div>

## {{term.term}}{% if term.id %} {:#{{term.id}}}{% endif %}

{{term.long_description | default: term.short_description }}

{% if term.related_links != empty -%}
**Documentos e recursos relacionados:**

{% for link in term.related_links -%}
- [{{link.text}}]({{link.link}})
{% endfor -%}
{% endif -%}
{% endfor -%}
