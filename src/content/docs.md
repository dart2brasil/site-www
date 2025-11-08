---
ia-translate: true
title: Documentação Dart
description: Aprenda a usar a linguagem e as bibliotecas Dart.
showToc: false
showBreadcrumbs: false
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
  <Card title="{{card.name}}" link="{{card.url}}">

  {{card.description}}

  </Card>
{% endfor -%}
</div>
