---
ia-translate: true
title: "Novidades sobre macros e serialização de dados em Dart"
description: "Investimos bastante tempo e recursos prototipando macros nos últimos dois anos. Infelizmente, cada vez que resolvíamos um grande…"
publishDate: 2025-01-29
author: vijaysmenon
category: other
layout: blog
---


Investimos bastante tempo e recursos prototipando [macros](https://dart.dev/language/macros) nos últimos dois anos. Infelizmente, cada vez que resolvíamos um grande obstáculo técnico, surgiam outros novos. Neste ponto, não vemos as macros convergindo tão cedo para um recurso que nos deixe confortáveis em lançar, com a qualidade e a performance em tempo de desenvolvimento que queremos.

Depois de considerar o custo de oportunidade (em especial, os recursos que poderíamos estar entregando à comunidade no lugar delas), tomamos a difícil decisão de interromper nosso trabalho com macros.

## Contexto {:#background}

Acreditamos que o Dart oferece uma combinação única de pontos fortes: (1) a compilação ahead-of-time e a performance típicas de linguagens estáticas e (2) o ciclo de desenvolvimento rápido (por exemplo, stateful hot reload) típico de linguagens dinâmicas. À medida que evoluímos o Dart, temos tido o cuidado de avaliar mudanças na linguagem segundo esses dois critérios.

Metaprogramação poderosa, construída sobre introspecção rica, sempre foi um desafio nesse contexto. Introspecção em tempo de execução (por exemplo, reflection) dificulta as otimizações de tree shaking que nos permitem gerar binários menores. Introspecção estática (por exemplo, macros) pode assumir algumas formas. A maioria das linguagens adota uma abordagem sintática, com reflexão estática limitada sobre a sintaxe dos programas. Não acreditávamos que isso fosse suficiente para atingir nossos objetivos. Em vez disso, nosso objetivo era construir um sistema de macros com suporte a introspecção semântica profunda do programa em tempo de compilação. Infelizmente, a introspecção semântica acabou introduzindo custos altos em tempo de compilação, o que tornou difícil manter o stateful hot reload *hot*.

Concluímos que estamos simplesmente longe demais de lançar macros com a performance em tempo de desenvolvimento de que precisamos. Nossa implementação atual piora tanto a edição (por exemplo, análise estática e autocompletar) quanto a compilação incremental (o primeiro passo de um hot reload). Não estamos confiantes de que conseguiremos resolver esses problemas de forma adequada em um prazo razoável.

## Próximos passos {:#moving-forward}

Decidimos focar em outros recursos que temos mais confiança em lançar.

Uma área em que vamos investir é um suporte melhor a dados em Dart. Esta é a [issue mais pedida](https://github.com/dart-lang/language/issues/314) em todos os issue trackers do Dart e do Flutter. Aliás, nossa principal motivação para as macros era oferecer um tratamento melhor de dados, serialização e desserialização. Vamos continuar buscando um suporte melhor a dados, mas pretendemos fazer isso com recursos de linguagem mais específicos.

Outra área em que vamos investir é a melhoria dos tempos de build e da experiência geral de geração de código. Já identificamos [melhorias para o build_runner](https://github.com/dart-lang/build/issues/3800). Também planejamos lançar as [augmentations](https://github.com/dart-lang/language/blob/main/working/augmentation-libraries/feature-specification.md), um recurso que prototipamos como parte das macros. Acreditamos que esse recurso da linguagem se sustenta sozinho e vai melhorar a geração de código existente. Ainda pretendemos [lançar esse recurso](https://github.com/dart-lang/language/issues/4154) de forma independente.

Entendemos que esta notícia vai decepcionar muitos de vocês. Continuamos interessados em [explorar metaprogramação de forma geral](https://github.com/dart-lang/language/issues/1482) no longo prazo, já que ela tem vários casos de uso possíveis além de dados. Ainda assim, também queremos deixar claro para a nossa comunidade que não vamos lançar macros no futuro próximo.

Queremos agradecer a todos que testaram as macros, enviaram feedback e contribuíram diretamente com PRs. Essas contribuições e essa energia vão alimentar o trabalho que faremos a seguir. Estamos animados com as melhorias que poderemos oferecer este ano.
