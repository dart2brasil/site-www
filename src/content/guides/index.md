---
ia-translate: true
title: Documentação Dart
description: Aprenda a usar a linguagem e as bibliotecas Dart.
toc: false
---

Bem-vindo à documentação Dart!
Para uma lista de alterações neste site — novas páginas, novos guias e muito mais —, consulte a página [Novidades][] (What's new).

[Novidades]: /resources/whats-new

Aqui estão algumas das páginas mais visitadas deste site:

{% comment %}
Para atualizar esses cards, edite src/_data/docs_cards.yml.
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
