---
ia-translate: true
title: Documentação do Dart
description: Aprenda a usar a linguagem e as bibliotecas Dart.
toc: false
---

Bem-vindo à documentação do Dart!
Para uma lista de alterações neste site — novas páginas, novas diretrizes e mais — veja
a página [O que há de novo][What's new].

[What's new]: /resources/whats-new

Aqui estão algumas das páginas mais visitadas deste site:

{% comment %}
Para atualizar estes cards, edite src/_data/docs_cards.yml.
{% endcomment %}

<div class="card-grid">
{% for card in docs_cards -%}
  {% capture index0Modulo3 %}{{ forloop.index0 | modulo:3 }}{% endcapture %}
  {% capture indexModulo3 %}{{ forloop.index | modulo:3 }}{% endcapture %}
  <div class="card">
    <h2><a href="{{card.url}}">{{card.name}}</a></h2>
    <p>{{card.description}}</p>
  </div>
{% endfor -%}
</div>
