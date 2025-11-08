---
ia-translate: true
title: Documentação Dart
description: Aprenda a usar a linguagem e bibliotecas Dart.
showToc: false
showBreadcrumbs: false
---

Bem-vindo à documentação do Dart!
Para uma lista de mudanças neste site—novas páginas, novas diretrizes e mais—veja
a página [Novidades][What's new].

[What's new]: /resources/whats-new

Aqui estão algumas das páginas mais visitadas deste site:

{% comment %}
To update these cards, edit src/_data/docs_cards.yml.
{% endcomment %}

<div class="card-grid">
{% for card in docs_cards -%}
  <Card title="{{card.name}}" link="{{card.url}}">

  {{card.description}}

  </Card>
{% endfor -%}
</div>
