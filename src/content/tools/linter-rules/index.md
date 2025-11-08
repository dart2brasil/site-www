---
ia-translate: true
title: Regras do linter
description: Detalhes sobre o linter Dart e as regras de estilo que você pode escolher.
bodyClass: diagnostics
---

Use o linter Dart para identificar possíveis problemas no seu código Dart.
Você pode usar o linter através da sua IDE
ou com o comando [`dart analyze`](/tools/dart-analyze).
Para informações sobre como habilitar e desabilitar regras individuais do linter, consulte
as [seções de regras individuais][individual rules sections] da [documentação do analyzer][analyzer documentation].

[individual rules sections]: /tools/analysis#individual-rules
[analyzer documentation]: /tools/analysis

Esta página lista todas as regras do linter,
com detalhes como quando você pode querer usar cada regra,
quais padrões de código a acionam, e
como você pode corrigir seu código.

:::tip
Regras do linter (às vezes chamadas de _lints_) podem ter falsos positivos,
e elas não concordam todas entre si.
Por exemplo, algumas regras são mais apropriadas para pacotes Dart regulares,
e outras são projetadas para aplicações Flutter.
:::

<a id="predefined-rule-sets"></a>
## Conjuntos {:#sets}

Para evitar a necessidade de selecionar individualmente regras compatíveis do linter,
considere começar com um conjunto de regras do linter,
que os seguintes pacotes fornecem:

<a id="lints"></a>

[lints][]
: Contém dois conjuntos de regras organizados pela equipe Dart.
  Recomendamos usar pelo menos o conjunto de regras `core`,
  que é usado ao [pontuar]({{site.pub}}/help/scoring)
  pacotes enviados para [pub.dev]({{site.pub}}).
  Ou, melhor ainda, use o conjunto de regras `recommended`,
  um superconjunto de `core` que identifica problemas adicionais
  e impõe estilo e formato.
  Se você estiver escrevendo código Flutter,
  use o conjunto de regras no pacote [`flutter_lints`](#flutter_lints),
  que é baseado em `lints`.

<a id="flutter_lints"></a>

[flutter_lints][]
: Contém o conjunto de regras `flutter`,
  que a equipe Flutter encoraja você a usar
  em aplicações, pacotes e plugins Flutter.
  Este conjunto de regras é um superconjunto do conjunto [`recommended`](#lints),
  que é ele próprio um superconjunto do conjunto [`core`](#lints) que
  determina parcialmente a [pontuação]({{site.pub}}/help/scoring) de
  pacotes enviados para [pub.dev]({{site.pub}}).

[lints]: {{site.pub-pkg}}/lints
[flutter_lints]: {{site.pub-pkg}}/flutter_lints

Para aprender como usar um conjunto de regras específico,
visite a documentação para [habilitar e desabilitar regras do linter][enabling and disabling linter rules].

Para encontrar mais conjuntos de regras predefinidos,
confira o [tópico `#lints`]({{site.pub-pkg}}?q=topic:lints) no pub.dev.

[enabling and disabling linter rules]: /tools/analysis#enabling-linter-rules

<a id="maturity-levels"></a>
## Status {:#status}

Cada regra tem um status ou nível de maturidade:

**Estável (Stable)**
: Estas regras são seguras de usar e são verificadas como funcionais
  com as versões mais recentes da linguagem Dart.
  Todas as regras são consideradas estáveis a menos que
  sejam marcadas como experimentais, descontinuadas ou removidas.

**Experimental**
: Estas regras ainda estão sob avaliação e podem nunca ser estabilizadas.
  Use-as com cautela e reporte quaisquer problemas que encontrar.

**Descontinuada (Deprecated)**
: Estas regras não são mais sugeridas para uso
  e podem ser removidas em uma futura versão do Dart.

**Removida (Removed)**
: Estas regras já foram removidas na
  última versão estável do Dart.

## Correções rápidas {:#quick-fixes}

Algumas regras podem ser corrigidas automaticamente usando correções rápidas.
Uma correção rápida é uma edição automatizada
direcionada para corrigir o problema
reportado pela regra do linter.

Se a regra possui uma correção rápida,
ela pode ser aplicada usando [`dart fix`](/tools/dart-fix)
ou usando seu [editor com suporte a Dart](/tools#editors).
Para aprender mais, consulte [Correções rápidas para problemas de análise][Quick fixes for analysis issues].

[Quick fixes for analysis issues]: https://blog.dart.dev/quick-fixes-for-analysis-issues-c10df084971a

## Regras {:#rules}

O seguinte é um índice de todas as regras do linter e
uma breve descrição de sua funcionalidade.
Para aprender mais sobre uma regra específica,
clique no botão **Learn more** em seu card.

Para uma lista gerada automaticamente contendo todas as regras do linter
no Dart `{{site.sdkVersion}}`,
confira [Todas as regras do linter](/tools/linter-rules/all).

---

<div><LintRuleIndex></LintRuleIndex></div>

[Dart style guide]: /effective-dart/style
