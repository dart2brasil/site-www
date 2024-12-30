---
ia-translate: true
title: Dart Eficaz
description: >-
  Melhores práticas para construir bibliotecas Dart consistentes,
  manuteníveis e eficientes.
nextpage:
  url: /effective-dart/style
  title: Estilo
---

Nos últimos anos, escrevemos muito código Dart e aprendemos bastante sobre o que
funciona bem e o que não funciona. Estamos compartilhando isso com você para que
você também possa escrever código consistente, robusto e rápido. Existem dois
temas abrangentes:

 1. **Seja consistente.** Quando se trata de coisas como formatação e uso de
    maiúsculas e minúsculas, argumentos sobre o que é melhor são subjetivos e
    impossíveis de resolver. O que sabemos é que ser *consistente* é
    objetivamente útil.

    Se duas partes do código parecem diferentes, deve ser porque elas *são*
    diferentes de alguma forma significativa. Quando um pedaço de código se
    destaca e chama sua atenção, ele deve fazer isso por um motivo útil.

 2. **Seja conciso.** Dart foi projetado para ser familiar, então ele herda
    muitas das mesmas declarações e expressões de C, Java, JavaScript e outras
    linguagens. Mas criamos o Dart porque há muito espaço para melhorar o que
    essas linguagens oferecem. Adicionamos vários recursos, desde interpolação
    de strings até inicializadores formais, para ajudar você a expressar sua
    intenção de forma mais simples e fácil.

    Se houver várias maneiras de dizer algo, você geralmente deve escolher a mais
    concisa. Isso não quer dizer que você deve fazer [code golf][code golf] para enfiar um
    programa inteiro em uma única linha. O objetivo é um código que seja
    *econômico*, não *denso*.

[code golf]: https://en.wikipedia.org/wiki/Code_golf

## Os guias

Dividimos as diretrizes em algumas páginas separadas para fácil assimilação:

  * **[Guia de Estilo][style guide]** &ndash; Isso define as regras para organizar e
    estruturar o código, ou pelo menos as partes que o
    [`dart format`][`dart format`] não lida para você. O guia de estilo também especifica
    como os identificadores são formatados: `camelCase`, `using_underscores`, etc.

  * **[Guia de Documentação][documentation guide]** &ndash; Isso informa tudo o que você precisa
    saber sobre o que vai dentro dos comentários. Tanto comentários de
    documentação quanto comentários de código comuns.

  * **[Guia de Uso][usage guide]** &ndash; Isso ensina como fazer o melhor uso dos recursos
    da linguagem para implementar o comportamento. Se estiver em uma declaração
    ou expressão, estará coberto aqui.

  * **[Guia de Design][design guide]** &ndash; Este é o guia mais flexível, mas o que tem o
    escopo mais amplo. Ele cobre o que aprendemos sobre como projetar APIs
    consistentes e utilizáveis para bibliotecas. Se estiver em uma assinatura
    de tipo ou declaração, isso o aborda.

Para links para todas as diretrizes, consulte o [resumo](#summary-of-all-rules).

[`dart format`]: /tools/dart-format
[style guide]: /effective-dart/style
[documentation guide]: /effective-dart/documentation
[usage guide]: /effective-dart/usage
[design guide]: /effective-dart/design

## Como ler os guias

Cada guia é dividido em algumas seções. As seções contêm uma lista de diretrizes.
Cada diretriz começa com uma destas palavras:

* **FAÇA** as diretrizes descrevem práticas que devem ser sempre seguidas.
  Quase nunca haverá uma razão válida para se desviar delas.

* **NÃO FAÇA** diretrizes são o inverso: coisas que quase nunca são uma boa ideia.
  Esperançosamente, não temos tantas quanto outras linguagens, porque temos
  menos bagagem histórica.

* **PREFIRA** diretrizes são práticas que você *deve* seguir. No entanto, pode
  haver circunstâncias em que faça sentido fazer o contrário. Apenas certifique-se
  de entender todas as implicações de ignorar a diretriz quando o fizer.

* **EVITE** diretrizes são o oposto de "prefira": coisas que você não deve fazer,
  mas onde pode haver boas razões para fazê-las em raras ocasiões.

* **CONSIDERE** diretrizes são práticas que você pode ou não querer seguir,
  dependendo das circunstâncias, precedentes e sua própria preferência.

Algumas diretrizes descrevem uma **exceção** onde a regra *não* se aplica. Quando
listadas, as exceções podem não ser exaustivas — você ainda pode precisar usar
seu julgamento em outros casos.

Isso soa como se a polícia fosse derrubar sua porta se você não tiver seus
cadarços amarrados corretamente. As coisas não são tão ruins. A maioria das
diretrizes aqui são de senso comum e somos todos pessoas razoáveis. O objetivo,
como sempre, é um código agradável, legível e de fácil manutenção.

O analisador Dart fornece um linter para ajudar você a escrever código bom e
consistente que segue estas e outras diretrizes. Se uma ou mais [regras do
linter][lints] existirem que possam ajudar você a seguir uma diretriz, então a
diretriz vincula a essas regras. Os links usam o seguinte formato:

{% render 'linter-rule-mention.md', rules:'unnecessary_getters_setters' %}

Para aprender como usar o linter, veja
[Habilitando regras do linter][Habilitando regras do linter] e a lista de [regras do linter][lints].

[Habilitando regras do linter]: /tools/analysis#enabling-linter-rules
[lints]: /tools/linter-rules

## Glossário

Para manter as diretrizes breves, usamos alguns termos abreviados para nos
referirmos a diferentes construções Dart.

* Um **membro de biblioteca** é um campo de nível superior, getter, setter ou
  função. Basicamente, qualquer coisa no nível superior que não seja um tipo.

* Um **membro de classe** é um construtor, campo, getter, setter, função ou
  operador declarado dentro de uma classe. Os membros da classe podem ser de
  instância ou estáticos, abstratos ou concretos.

* Um **membro** é um membro de biblioteca ou um membro de classe.

* Uma **variável**, quando usada geralmente, refere-se a variáveis de nível
  superior, parâmetros e variáveis locais. Não inclui campos estáticos ou de
  instância.

* Um **tipo** é qualquer declaração de tipo nomeada: uma classe, typedef ou enum.

* Uma **propriedade** é uma variável de nível superior, getter (dentro de uma
  classe ou no nível superior, instância ou estático), setter (o mesmo) ou campo
  (instância ou estático). Aproximadamente qualquer construção nomeada "semelhante a
  campo".

## Resumo de todas as regras

{% include './_toc.md' %}
