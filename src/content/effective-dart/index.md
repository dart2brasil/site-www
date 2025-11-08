---
ia-translate: true
title: Dart Eficaz
description: "Melhores práticas para construir bibliotecas Dart consistentes, mantíveis e eficientes."
nextpage:
  url: /effective-dart/style
  title: Estilo
---

Nos últimos anos, escrevemos muito código Dart e aprendemos muito sobre o que funciona bem e o que não funciona. Estamos compartilhando isso com você para que você também possa escrever código consistente, robusto e rápido. Há dois temas principais:

 1. **Seja consistente.** Quando se trata de coisas como formatação e uso de maiúsculas e minúsculas, discussões sobre qual é melhor são subjetivas e impossíveis de resolver. O que sabemos é que ser *consistente* é objetivamente útil.

    Se duas partes de código parecem diferentes, deve ser porque elas *são* diferentes de alguma forma significativa. Quando um pouco de código se destaca e chama sua atenção, deve fazê-lo por um motivo útil.

 2. **Seja breve.** Dart foi projetado para ser familiar, então herda muitas das mesmas instruções e expressões que C, Java, JavaScript e outras linguagens. Mas criamos o Dart porque há muito espaço para melhorar o que essas linguagens oferecem. Adicionamos várias funcionalidades, desde interpolação de strings até a inicialização de parâmetros formais, para ajudá-lo a expressar sua intenção de forma mais simples e fácil.

    Se houver várias maneiras de dizer algo, você geralmente deve escolher a mais concisa. Isso não significa que você deva fazer [code golf][] a ponto de espremer um programa inteiro em uma única linha. O objetivo é um código *econômico*, não *denso*.

[code golf]: https://en.wikipedia.org/wiki/Code_golf

## Os guias {:#os-guias}

Dividimos as diretrizes em algumas páginas separadas para facilitar a compreensão:

  * **[Guia de Estilo][]** &ndash; Este define as regras para a disposição e organização do código, ou pelo menos as partes que o [`dart format`][] não trata para você. O guia de estilo também especifica como os identificadores são formatados: `camelCase`, `using_underscores`, etc.

  * **[Guia de Documentação][]** &ndash; Este guia lhe diz tudo o que você precisa saber sobre o que vai dentro dos comentários. Tanto comentários de documentação quanto comentários de código comuns.

  * **[Guia de Uso][]** &ndash; Este guia ensina você a fazer o melhor uso dos recursos da linguagem para implementar comportamentos. Se estiver em uma instrução ou expressão, está coberto aqui.

  * **[Guia de Design][]** &ndash; Este é o guia mais flexível, mas com o escopo mais amplo. Ele abrange o que aprendemos sobre o design de APIs consistentes e utilizáveis para bibliotecas. Se estiver em uma assinatura de tipo ou declaração, isso é abordado aqui.

Para links para todos os guias, veja o
[resumo](#resumo-de-todas-as-regras).

[`dart format`]: /tools/dart-format
[guia de estilo]: /effective-dart/style
[guia de documentação]: /effective-dart/documentation
[guia de uso]: /effective-dart/usage
[guia de design]: /effective-dart/design

## Como ler os guias {:#como-ler-os-guias}

Cada guia é dividido em algumas seções. As seções contêm uma lista de diretrizes. Cada diretriz começa com uma dessas palavras:

* As diretrizes **FAÇA** descrevem práticas que devem ser sempre seguidas. Quase nunca haverá um motivo válido para desviá-las.

* As diretrizes **NÃO FAÇA** são o contrário: coisas que quase nunca são uma boa ideia. Esperançosamente, não temos tantas dessas quanto outras linguagens, porque temos menos "bagagem" histórica.

* As diretrizes **PREFIRA** são práticas que você *deve* seguir. No entanto, pode haver circunstâncias em que faça sentido fazer o contrário. Apenas certifique-se de entender todas as implicações de ignorar a diretriz quando o fizer.

* As diretrizes **EVITE** são o oposto de "prefira": coisas que você não deve fazer, mas onde pode haver boas razões em raras ocasiões.

* As diretrizes **CONSIDERE** são práticas que você pode ou não querer seguir, dependendo das circunstâncias, precedentes e sua própria preferência.

Algumas diretrizes descrevem uma **exceção** em que a regra *não* se aplica. Quando listadas, as exceções podem não ser exaustivas; você ainda pode precisar usar seu julgamento em outros casos.

Isso soa como se a polícia fosse arrombar sua porta se você não tiver seus cadarços amarrados corretamente. As coisas não são tão ruins. A maioria das diretrizes aqui são de bom senso e todos nós somos pessoas razoáveis. O objetivo, como sempre, é um código bom, legível e mantível.

O analisador Dart fornece um linter para ajudá-lo a escrever código bom e consistente que siga essas e outras diretrizes. Se uma ou mais [regras do linter][lints] existirem que possam ajudá-lo a seguir uma diretriz, a diretriz vinculará essas regras. Os links usam o seguinte formato:

{% render 'linter-rule-mention.md', rules:'unnecessary_getters_setters' %}

Para aprender como usar o linter, consulte [Habilitando regras do linter][] e a lista de [regras do linter][lints].

[Habilitando regras do linter]: /tools/analysis#enabling-linter-rules
[lints]: /tools/linter-rules

## Glossário {:#glossario}

Para manter as diretrizes concisas, usamos alguns termos abreviados para nos referir a diferentes construções Dart.

* Um **membro da biblioteca** é um campo, getter, setter ou função de nível superior. Basicamente, qualquer coisa no nível superior que não seja um tipo.

* Um **membro da classe** é um construtor, campo, getter, setter, função ou operador declarado dentro de uma classe. Os membros da classe podem ser de instância ou estáticos, abstratos ou concretos.

* Um **membro** é um membro da biblioteca ou um membro da classe.

* Uma **variável**, quando usada geralmente, refere-se a variáveis de nível superior, parâmetros e variáveis locais. Não inclui campos estáticos ou de instância.

* Um **tipo** é qualquer declaração de tipo nomeada: uma classe, typedef ou enum.

* Uma **propriedade** é uma variável de nível superior, getter (dentro de uma classe ou no nível superior, instância ou estático), setter (mesmo), ou campo (instância ou estático). Aproximadamente qualquer construção nomeada "semelhante a um campo".

## Resumo de todas as regras {:#resumo-de-todas-as-regras}

{% render 'effective-dart-toc.md' %}
