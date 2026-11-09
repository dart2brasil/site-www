---
ia-translate: true
title: Regras do linter
description: Detalhes sobre o linter do Dart e as regras de estilo que você pode escolher.
bodyClass: diagnostics
---

Use o linter do Dart para identificar possíveis problemas no seu código Dart.
Você pode usar o linter pela sua IDE
ou com o comando [`dart analyze`](/tools/dart-analyze).
Para informações sobre como habilitar e desabilitar regras individuais do linter, consulte as
[seções de regras individuais][individual rules sections] da [documentação do analyzer][analyzer documentation].

[individual rules sections]: /tools/analysis#individual-rules
[analyzer documentation]: /tools/analysis

Esta página lista todas as regras do linter,
com detalhes como quando você pode querer usar cada regra,
quais padrões de código a acionam e
como você pode corrigir seu código.

:::tip
Regras do linter (às vezes chamadas de _lints_) podem ter falsos positivos,
e nem todas concordam entre si.
Por exemplo, algumas regras são mais apropriadas para pacotes Dart comuns,
e outras são feitas para aplicativos Flutter.
:::

<a id="predefined-rule-sets"></a>
## Conjuntos

Para evitar a necessidade de selecionar individualmente regras compatíveis do linter,
considere começar com um conjunto de regras do linter,
que os seguintes pacotes fornecem:

<a id="lints"></a>

[lints][]
: Contém dois conjuntos de regras mantidos pela equipe do Dart.
  Recomendamos usar pelo menos o conjunto `core`,
  que é usado ao [pontuar]({{site.pub}}/help/scoring)
  pacotes publicados no [pub.dev]({{site.pub}}).
  Ou, melhor ainda, use o conjunto `recommended`,
  um superconjunto de `core` que identifica problemas adicionais
  e impõe estilo e formato.
  Se você estiver escrevendo código Flutter,
  use o conjunto de regras do pacote [`flutter_lints`](#flutter_lints),
  que se baseia em `lints`.

<a id="flutter_lints"></a>

[flutter_lints][]
: Contém o conjunto `flutter`,
  que a equipe do Flutter incentiva você a usar
  em aplicativos, pacotes e plugins Flutter.
  Este conjunto é um superconjunto do conjunto [`recommended`](#lints),
  que por sua vez é um superconjunto do conjunto [`core`](#lints), que
  determina parcialmente a [pontuação]({{site.pub}}/help/scoring) de
  pacotes publicados no [pub.dev]({{site.pub}}).

[lints]: {{site.pub-pkg}}/lints
[flutter_lints]: {{site.pub-pkg}}/flutter_lints

Para aprender como usar um conjunto de regras específico,
acesse a documentação sobre [habilitar e desabilitar regras do linter][enabling and disabling linter rules].

Para encontrar mais conjuntos de regras predefinidos,
confira o [tópico `#lints`]({{site.pub-pkg}}?q=topic:lints) no pub.dev.

[enabling and disabling linter rules]: /tools/analysis#enabling-linter-rules

<a id="maturity-levels"></a>
## Status

Cada regra tem um status ou nível de maturidade:

**Estável (Stable)**
: Estas regras são seguras de usar e são verificadas como funcionais
  com as versões mais recentes da linguagem Dart.
  Todas as regras são consideradas estáveis, a menos que
  sejam marcadas como experimentais, descontinuadas ou removidas.

**Experimental**
: Estas regras ainda estão em avaliação e podem nunca ser estabilizadas.
  Use-as com cautela e reporte quaisquer problemas que encontrar.

**Descontinuada (Deprecated)**
: Estas regras não são mais recomendadas para uso
  e podem ser removidas em uma futura versão do Dart.

**Removida (Removed)**
: Estas regras já foram removidas na
  versão estável mais recente do Dart.

## Correções rápidas {:#quick-fixes}

Algumas regras podem ser corrigidas automaticamente usando correções rápidas (quick fixes).
Uma correção rápida é uma edição automatizada
voltada a corrigir o problema
reportado pela regra do linter.

Se a regra tiver uma correção rápida,
ela pode ser aplicada usando [`dart fix`](/tools/dart-fix)
ou pelo seu [editor com suporte a Dart](/tools#editors).
Para saber mais, veja [Correções rápidas para problemas de análise][Quick fixes for analysis issues].

[Quick fixes for analysis issues]: /blog/quick-fixes-for-analysis-issues

## Regras {:#rules}

A seguir está um índice de todas as regras do linter e
uma breve descrição de sua funcionalidade.
Para saber mais sobre uma regra específica,
clique no botão **Learn more** no card dela.

Para uma lista gerada automaticamente com todas as regras do linter
no Dart `{{site.sdkVersion}}`,
confira [Todas as regras do linter](/tools/linter-rules/all).

---

<div><LintRuleIndex></LintRuleIndex></div>

[Dart style guide]: /effective-dart/style
