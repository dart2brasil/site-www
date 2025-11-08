---
title: Linter rules
description: Details about the Dart linter and its style rules you can choose.
bodyClass: diagnostics
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

[Quick fixes for analysis issues]: https://blog.dart.dev/quick-fixes-for-analysis-issues-c10df084971a

## Regras {:#rules}

A seguir, um índice de todas as regras do linter e
uma breve descrição de sua funcionalidade.
Para aprender mais sobre uma regra específica,
clique no botão **Saiba mais** no respectivo card.

Para uma lista gerada automaticamente contendo todas as regras do linter
no Dart `{{site.sdkVersion}}`,
confira [Todas as regras do linter](/tools/linter-rules/all).

---

<div><LintRuleIndex></LintRuleIndex></div>

[Guia de estilo Dart]: /effective-dart/style