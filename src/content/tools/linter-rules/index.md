---
ia-translate: true
title: Regras do Linter
description: Detalhes sobre o linter Dart e suas regras de estilo que você pode escolher.
show_breadcrumbs: true
body_class: linter-rules
js: [{url: '/assets/js/linter-rules.js', defer: true}]
---

Use o linter Dart para identificar possíveis problemas no seu código Dart.
Você pode usar o linter através do seu IDE
ou com o comando [`dart analyze`](/tools/dart-analyze).
Para obter informações sobre como habilitar e desabilitar regras do linter individuais, veja
[seções de regras individuais][] da [documentação do analisador][].

[seções de regras individuais]: /tools/analysis#individual-rules
[documentação do analisador]: /tools/analysis

Esta página lista todas as regras do linter,
com detalhes como quando você pode querer usar cada regra,
quais padrões de código a acionam e
como você pode corrigir seu código.

:::tip
Regras do linter (às vezes chamadas de _lints_) podem ter falsos positivos,
e nem todas concordam entre si.
Por exemplo, algumas regras são mais apropriadas para pacotes Dart regulares,
e outras são projetadas para apps Flutter.
:::

<a id="predefined-rule-sets"></a>
## Conjuntos {:#sets}

Para evitar a necessidade de selecionar individualmente regras do linter compatíveis,
considere começar com um conjunto de regras do linter,
que os seguintes pacotes fornecem:

<a id="lints"></a>

[lints][]
: Contém dois conjuntos de regras selecionados pela equipe Dart.
  Recomendamos usar pelo menos o conjunto de regras `core` (núcleo),
  que é usado ao [pontuar]({{site.pub}}/help/scoring)
  pacotes enviados para [pub.dev]({{site.pub}}).
  Ou, melhor ainda, use o conjunto de regras `recommended` (recomendado),
  um superconjunto de `core` que identifica problemas adicionais
  e impõe estilo e formatação.
  Se você estiver escrevendo código Flutter,
  use o conjunto de regras no pacote [`flutter_lints`](#flutter_lints),
  que se baseia em `lints`.

<a id="flutter_lints"></a>

[flutter_lints][]
: Contém o conjunto de regras `flutter`,
  que a equipe Flutter encoraja você a usar
  em apps, pacotes e plugins Flutter.
  Este conjunto de regras é um superconjunto do conjunto [`recommended`](#lints),
  que por sua vez é um superconjunto do conjunto [`core`](#lints) que
  determina parcialmente a [pontuação]({{site.pub}}/help/scoring) de
  pacotes enviados para [pub.dev]({{site.pub}}).

[lints]: {{site.pub-pkg}}/lints
[flutter_lints]: {{site.pub-pkg}}/flutter_lints

Para aprender como usar um conjunto de regras específico,
visite a documentação para [habilitar e desabilitar regras do linter][].

Para encontrar mais conjuntos de regras predefinidos,
confira o tópico [`#lints`]({{site.pub-pkg}}?q=topic:lints) no pub.dev.

[habilitar e desabilitar regras do linter]: /tools/analysis#enabling-linter-rules

<a id="maturity-levels"></a>
## Status {:#status}

Cada regra tem um status ou nível de maturidade:

**Estável**
: Essas regras são seguras para usar e são verificadas como funcionais
  com as versões mais recentes da linguagem Dart.
  Todas as regras são consideradas estáveis, a menos que
  estejam marcadas como experimentais, descontinuadas ou removidas.

**Experimental**
: Essas regras ainda estão sob avaliação e podem nunca ser estabilizadas.
  Use-as com cautela e relate quaisquer problemas que encontrar.

**Descontinuada**
: Essas regras não são mais sugeridas para uso
  e podem ser removidas em uma versão futura do Dart.

**Removida**
: Essas regras já foram removidas na
  versão estável mais recente do Dart.

## Correções rápidas {:#quick-fixes}

Algumas regras podem ser corrigidas automaticamente usando correções rápidas.
Uma correção rápida é uma edição automatizada
direcionada para corrigir o problema
relatado pela regra do linter.

Se a regra tiver uma correção rápida,
ela pode ser aplicada usando [`dart fix`](/tools/dart-fix)
ou usando seu [editor com suporte a Dart](/tools#editors).
Para saber mais, veja [Correções rápidas para problemas de análise][].

[Correções rápidas para problemas de análise]: https://medium.com/dartlang/quick-fixes-for-analysis-issues-c10df084971a

## Regras {:#rules}

A seguir, um índice de todas as regras do linter e
uma breve descrição de sua funcionalidade.
Para aprender mais sobre uma regra específica,
clique no botão **Saiba mais** no respectivo card.

Para uma lista gerada automaticamente contendo todas as regras do linter
no Dart `{{site.sdkVersion}}`,
confira [Todas as regras do linter](/tools/linter-rules/all).

---

{% comment -%}
TODO(parlough): Generate this HTML with some sort of component mechanism.
{% endcomment -%}

<section id="filter-and-search" class="hidden">
  <div class="search-row">
    <div class="search-wrapper">
      <span class="material-symbols leading-icon" aria-hidden="true">search</span>
      <input type="search" placeholder="Search rules..." aria-label="Search linter rules by names">
    </div>
    {%- comment %}<button class="empty-button icon-button" id="sort">
      <span class="material-symbols">sort</span>
    </button>{% endcomment -%}
  </div>

  <div class="chip-set">
    {%- comment %}<div class="button-menu-wrapper">
      <button class="chip select-chip" data-menu="category-menu" data-title="Category" aria-controls="category-menu" aria-expanded="false">
        <span class="label">Category</span>
        <svg class="chip-icon trailing-icon" width="24" height="24" viewBox="0 0 24 24" aria-hidden="true">
          <path d="M7 10l5 5 5-5H7z"></path>
        </svg>
      </button>
      <div id="category-menu" class="select-menu">
        <ul role="listbox">
          <li><button role="option" aria-selected="false"><span class="label">Effective Dart</span></button></li>
        </ul>
      </div>
    </div>{% endcomment -%}
    <div class="button-menu-wrapper">
      <button class="chip select-chip" data-menu="rule-set-menu" data-title="Rule set" aria-controls="rule-set-menu" aria-expanded="false">
        <span class="label">Rule set</span>
        <svg class="chip-icon trailing-icon" width="24" height="24" viewBox="0 0 24 24" aria-hidden="true">
          <path d="M7 10l5 5 5-5H7z"></path>
        </svg>
      </button>
      <div id="rule-set-menu" class="select-menu">
      <ul role="listbox">
      <li><button data-filter="inFlutter" role="option" aria-selected="false">
        <span class="material-symbols" aria-hidden="true">flutter</span>
        <span class="label">Flutter</span>
      </button></li>
      <li><button data-filter="inRecommended" role="option" aria-selected="false">
        <span class="material-symbols" aria-hidden="true">thumb_up</span>
        <span class="label">Recommended</span>
      </button></li>
      <li><button data-filter="inCore" role="option" aria-selected="false">
        <span class="material-symbols" aria-hidden="true">circles</span>
        <span class="label">Core</span>
      </button></li>
      </ul>
      </div>
    </div>
    <button class="chip filter-chip" data-filter="hasFix" role="checkbox" aria-checked="false" aria-label="Show only lints with a fix available">
      <svg class="chip-icon leading-icon" viewBox="0 0 18 18" aria-hidden="true">
        <path d="M6.75012 12.1274L3.62262 8.99988L2.55762 10.0574L6.75012 14.2499L15.7501 5.24988L14.6926 4.19238L6.75012 12.1274Z"></path>
      </svg>
      <span class="label">Fix available</span>
    </button>
    <button class="chip filter-chip" data-filter="stable" role="checkbox" aria-checked="false" aria-label="Show only released, stable rules">
      <svg class="chip-icon leading-icon" viewBox="0 0 18 18" aria-hidden="true">
        <path d="M6.75012 12.1274L3.62262 8.99988L2.55762 10.0574L6.75012 14.2499L15.7501 5.24988L14.6926 4.19238L6.75012 12.1274Z"></path>
      </svg>
      <span class="label">Stable only</span>
    </button>
    <button class="text-button" id="reset-filters">Clear filters</button>
  </div>
</section>

<section class="content-search-results">
  <div class="card-grid" id="lint-cards">
    {% render 'linter-rule-cards.md', linter_rules:linter_rules %}
  </div>
</section>

[Guia de estilo Dart]: /effective-dart/style