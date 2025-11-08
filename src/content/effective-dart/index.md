---
ia-translate: true
title: Dart Efetivo
description: >-
  Melhores práticas para construir bibliotecas Dart consistentes,
  fáceis de manter e eficientes.
nextpage:
  url: /effective-dart/style
  title: Style
---

Ao longo dos últimos anos, escrevemos uma tonelada de código Dart e aprendemos muito
sobre o que funciona bem e o que não funciona. Estamos compartilhando isso com você para que você possa
escrever código consistente, robusto e rápido também. Existem dois temas abrangentes:

 1. **Seja consistente.** Quando se trata de coisas como formatação e casing,
    argumentos sobre qual é melhor são subjetivos e impossíveis de resolver.
    O que sabemos é que ser *consistente* é objetivamente útil.

    Se dois pedaços de código parecem diferentes, deveria ser porque eles *são*
    diferentes de alguma forma significativa. Quando um pedaço de código se destaca e chama
    sua atenção, deveria fazê-lo por uma razão útil.

 2. **Seja breve.** Dart foi projetado para ser familiar, então herda muitas das
    mesmas instruções e expressões de C, Java, JavaScript e outras linguagens.
    Mas criamos Dart porque há muito espaço para melhorar o que essas
    linguagens oferecem. Adicionamos um monte de recursos, desde interpolação de strings até
    initializing formals, para ajudá-lo a expressar sua intenção de forma mais simples e
    fácil.

    Se houver várias maneiras de dizer algo, você geralmente deve escolher a
    mais concisa. Isso não quer dizer que você deva fazer [code golf][] e
    espremer um programa inteiro em uma única linha. O objetivo é um código que seja
    *econômico*, não *denso*.

[code golf]: https://en.wikipedia.org/wiki/Code_golf

## Os guias

Dividimos as diretrizes em algumas páginas separadas para facilitar a digestão:

  * **[Style Guide][]** &ndash; Define as regras para dispor e
    organizar código, ou pelo menos as partes
    que o [`dart format`][] não trata para você.
    O guia de estilo também especifica como os identificadores são formatados:
    `camelCase`, `using_underscores`, etc.

  * **[Documentation Guide][]** &ndash; Diz tudo o que você precisa
    saber sobre o que vai dentro dos comentários. Tanto comentários de documentação quanto comentários
    de código normais e comuns.

  * **[Usage Guide][]** &ndash; Ensina como fazer o melhor uso dos
    recursos da linguagem para implementar comportamento. Se está em uma instrução ou
    expressão, é coberto aqui.

  * **[Design Guide][]** &ndash; Este é o guia mais suave, mas aquele
    com o escopo mais amplo. Abrange o que aprendemos sobre projetar
    APIs consistentes e utilizáveis para bibliotecas. Se está em uma assinatura de tipo ou
    declaração, este guia cobre isso.

Para links para todas as diretrizes, consulte o
[resumo](#summary-of-all-rules).

[`dart format`]: /tools/dart-format
[style guide]: /effective-dart/style
[documentation guide]: /effective-dart/documentation
[usage guide]: /effective-dart/usage
[design guide]: /effective-dart/design

## Como ler os guias

Cada guia é dividido em algumas seções. As seções contêm uma lista de diretrizes.
Cada diretriz começa com uma destas palavras:

* As diretrizes **DO** descrevem práticas que devem sempre ser seguidas. Quase
  nunca haverá uma razão válida para se desviar delas.

* As diretrizes **DON'T** são o inverso: coisas que quase nunca são uma boa
  ideia. Felizmente, não temos tantas dessas quanto outras linguagens têm porque
  temos menos bagagem histórica.

* As diretrizes **PREFER** são práticas que você *deve* seguir. No entanto, pode
  haver circunstâncias em que faz sentido fazer o contrário. Apenas certifique-se de
  entender completamente as implicações de ignorar a diretriz quando o fizer.

* As diretrizes **AVOID** são o dual de "prefer": coisas que você não deveria fazer, mas
  onde pode haver boas razões para fazê-lo em raras ocasiões.

* As diretrizes **CONSIDER** são práticas que você pode ou não querer
  seguir, dependendo das circunstâncias, precedentes e sua própria preferência.

Algumas diretrizes descrevem uma **exception** onde a regra *não* se aplica. Quando
listadas, as exceções podem não ser exaustivas—você ainda pode precisar usar
seu julgamento em outros casos.

Isso soa como se a polícia fosse derrubar sua porta se você não tiver
os cadarços amarrados corretamente. As coisas não são tão ruins. A maioria das diretrizes aqui
são de senso comum e todos somos pessoas razoáveis. O objetivo, como sempre, é ter um código
agradável, legível e de fácil manutenção.

O analisador Dart fornece um linter
para ajudá-lo a escrever código bom e consistente
que segue essas e outras diretrizes.
Se uma ou mais [regras do linter][lints] existem
que podem ajudá-lo a seguir uma diretriz,
então a diretriz vincula a essas regras.
Os links usam o seguinte formato:

{% render 'linter-rule-mention.md', rules:'unnecessary_getters_setters' %}

Para aprender como usar o linter,
consulte [Habilitando regras do linter][Enabling linter rules]
e a lista de [regras do linter][lints].

[Enabling linter rules]: /tools/analysis#enabling-linter-rules
[lints]: /tools/linter-rules

## Glossário

Para manter as diretrizes breves, usamos alguns termos abreviados para nos referir a diferentes
construções Dart.

* Um **library member** é um field, getter, setter ou function de nível superior.
  Basicamente, qualquer coisa no nível superior que não seja um tipo.

* Um **class member** é um constructor, field, getter, setter, function ou
  operator declarado dentro de uma classe. Os membros de classe podem ser instance ou static,
  abstract ou concrete.

* Um **member** é um library member ou um class member.

* Uma **variable**, quando usada de forma geral, refere-se a variáveis de nível superior,
  parâmetros e variáveis locais. Não inclui fields static ou instance.

* Um **type** é qualquer declaração de tipo nomeada: uma class, typedef ou enum.

* Uma **property** é uma variável de nível superior, getter (dentro de uma classe ou no nível
  superior, instance ou static), setter (o mesmo) ou field (instance ou static).
  Basicamente qualquer construção nomeada semelhante a um "field".

## Resumo de todas as regras

{% render 'effective-dart-toc.md' %}
