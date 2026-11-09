---
ia-translate: true
title: "Apresentando um novo pub.dev"
description: "Redesenhado para pacotes multiplataforma de alta qualidade"
publishDate: 2020-07-15
author: mit-mit
image: images/0efALL34OP6a4tcxh.webp
category: announcements
layout: blog
---


Hoje lançamos um novo site do [pub.dev](https://pub.dev). Ele traz novas métricas de pontuação para dar a você uma visão melhor de pacotes potencialmente úteis e para oferecer aos publicadores de pacotes um feedback mais acionável sobre como melhorar a qualidade. Para ajudar você a encontrar pacotes que suportam todas as plataformas de seu interesse, adicionamos a identificação e a busca de pacotes multiplataforma. E, no geral, redesenhamos a interface, buscando uma experiência agradável e elegante, consistente com os nossos sites [dart.dev](https://dart.dev) e [dartpad.dev](https://dartpad.dev).

<DashImage src="images/0efALL34OP6a4tcxh.webp" alt="Página inicial do pub.dev recém-redesenhada." caption="O novo site do pub.dev" />


## Encontrando os melhores pacotes para as suas necessidades {:#finding-the-best-packages-for-your-needs}

Com **quase 7.000 novos pacotes publicados no último ano, você não tem falta de opções** quando procura pacotes para estender as funcionalidades dos seus apps. Mas, com tantos pacotes para escolher, naturalmente você quer que os mais curtidos, de maior qualidade e mais populares apareçam em destaque. Para melhorar os resultados de busca de pacotes, redesenhamos o sistema de pontuação do pub.dev em torno de três dimensões:

<DashImage src="images/0OmvIh_FRHtJDrSIk.webp" alt="Três dimensões de pontuação de um pacote do pub: curtidas, pub points e popularidade." caption="*As três dimensões de pontuação de um pacote do pub*" />


1. **Curtidas**: uma medida de quantos desenvolvedores curtiram um pacote. Isso fornece uma medida bruta do sentimento geral em relação a um pacote.

1. **Pub points**: uma nova medida de qualidade. Ela inclui várias dimensões de qualidade, como estilo de código, suporte a plataformas e manutenibilidade. Mais sobre isso abaixo.

1. **Popularidade**: uma medida de quantos desenvolvedores usam um pacote. Ela reflete o número de apps que dependem do pacote nos últimos sessenta dias. A escala normalizada vai de 100% (o pacote mais usado) a 0% (o pacote menos usado), mas estamos investigando se conseguiremos fornecer contagens absolutas de uso em uma versão futura.

Esperamos que essas novas dimensões ajudem tanto os consumidores de pacotes que buscam dependências quanto os publicadores que trabalham para lançar pacotes de alta qualidade.

## Medindo a qualidade com pub points {:#measuring-quality-with-pub-points}

Como curtidas e popularidade fornecem medidas subjetivas, vindas da comunidade, o objetivo dos pub points é oferecer uma aproximação próxima de uma qualidade objetiva e mensurável. Isso não é fácil: os desenvolvedores percebem a qualidade de várias maneiras, mas ainda acreditamos que a maioria deles busca características essenciais que podemos medir. O modelo de pontuação anterior do pub.dev se baseava em subtrair pontos por problemas. O novo modelo inverte essa abordagem, concedendo pontos com base em características de cinco categorias:

<DashImage src="images/0RWVQoe0INHUfS_Ax.webp" alt="Visão geral do sistema de pub points mostrando categorias, verificações e pontos concedidos." caption="*Visão geral dos pub points, com categorias e verificações, além dos pontos concedidos*" />


1. *Seguir as convenções de arquivos Dart*: seguir as boas práticas em relação aos arquivos pubspec, readme e changelog

1. *Fornecer documentação*: fornecer documentação da API e um exemplo ilustrativo

1. *Suportar várias plataformas*: suportar o máximo possível de plataformas Dart e Flutter

1. *Passar na análise estática*: fornecer código livre de erros, avisos e lints

1. *Suportar dependências atualizadas*: ter restrições de dependência que suportem os SDKs mais recentes do Dart e do Flutter, e as dependências de pacotes mais recentes

Esperamos adicionar mais verificações e categorias aos pub points com o tempo, elevando o teto de pontos que um pacote pode ter. Por exemplo, planejamos adicionar uma pontuação para o suporte à [null safety](/blog/announcing-sound-null-safety) quando esse recurso for lançado. E estamos investigando como medir a manutenibilidade (capacidade de resposta a issues e pull requests), a testabilidade (cobertura automatizada de testes) e a amigabilidade com a comunidade (número de contribuidores, mantenedores etc.). Se você tiver uma ideia de medida excelente, adoraríamos [ouvir você](https://github.com/dart-lang/pub-dev/issues)!

## Suporte a apps multiplataforma {:#supporting-multiplatform-apps}

Tanto o Dart quanto o Flutter se destacam na criação de apps para várias plataformas. No pub.dev, fornecemos tags claras de plataforma para mobile (iOS e Android) e web, além de filtros de busca para essas plataformas:

<DashImage src="images/0aTIl5H_AbGmOJBKO.webp" alt="Captura de tela mostrando filtros de plataforma como Android, iOS e web disponíveis na busca do pub.dev." caption="Filtros de plataforma na busca" />


Para garantir que o seu pacote seja marcado com o suporte correto de plataforma, siga as orientações da [página de ajuda sobre pontuação](https://pub.dev/help/scoring) do pub.dev.

Vamos adicionar suporte semelhante para plataformas desktop (macOS, Windows e Linux) quando isso chegar a um estado mais definitivo. Por enquanto, você pode encontrar filtros para essas plataformas nas opções de busca **Avançada**:

<DashImage src="images/0LpResE7zZv_5x3xB.webp" alt="Opções avançadas de busca do pub.dev mostrando filtros para plataformas desktop." caption="*Plataformas desktop nos filtros avançados*" />


## Um design elegante e agradável {:#an-elegant-and-delightful-design}

A equipe do pub.dev do Dart colaborou com o Google Developer Studio, nossa equipe criativa interna, tendo Jeremy Sie como designer principal. Junto com as atualizações funcionais, a equipe analisou com cuidado o design visual, compartilhando suas ideias sobre o projeto. Com o objetivo de oferecer uma experiência coerente, acessível e centrada no usuário, fizemos uma série de refinamentos baseados no [sistema Material Design](https://material.io/design/) do Google. Nossa meta era criar uma interface leve e enxuta, permitindo fluxos claros e concisos tanto para publicadores quanto para consumidores de pacotes.

O design atualizado traz [componentes Material](https://material.io/components), como cards e chips, que exibem com clareza os detalhes dos pacotes e permitem maior transparência sobre como cada pacote funciona. Atualizamos o sistema tipográfico e melhoramos a [escala tipográfica](https://material.io/design/typography/the-type-system.html#type-scale) em todo o site, trazendo mais clareza aos resultados de busca e melhorando a forma como as informações dos pacotes são exibidas. Componentes como as pontuações dos pacotes foram redesenhados para ficarem mais claros e estruturados, de modo que o processo de pontuação fique mais transparente e fácil de entender.

<DashImage src="images/06UWz21c0wZuisozR.webp" alt="Resultados de busca no pub.dev por gps filtrados para Flutter, Android e iOS, mostrando as pontuações de curtidas, pub points e popularidade." caption="*Busca mostrando as três pontuações do pub.dev*" />


Também fizemos mudanças na página inicial. Sabíamos que a possibilidade de buscar pacotes rapidamente era parte central do site, mas queríamos melhorar a experiência destacando as ferramentas e bibliotecas mais úteis. Adicionamos seções como **Favoritos do Flutter** e **Pacotes mais populares** logo no início, para ajudar você a explorar rapidamente alguns dos melhores pacotes disponíveis. Também analisamos com atenção a paleta de cores e a direção de arte, incorporando ilustrações e tornando componentes como os exemplos de código visualmente consistentes com [dart.dev](https://dart.dev/) e [dartpad.dev](https://dartpad.dev/).

## Experimente o pub.dev hoje {:#try-pub-dev-today}

Convidamos você a experimentar hoje a nova experiência de navegação e busca do [pub.dev](http://pub.dev), e a usar as novas dimensões de pontuação e o relatório de pub points.

Se você é desenvolvedor de pacotes, incentivamos a ver os pub points dos seus pacotes, procurando oportunidades para melhorá-los. Para mais detalhes sobre como o sistema de pontuação funciona, veja a [ajuda sobre pontuação do pub.dev](https://pub.dev/help/scoring).

Como sempre, adoramos feedback. Deixe seus comentários abaixo ou abra issues no [tracker de issues do pub.dev](https://github.com/dart-lang/pub-dev/issues).

*Por: Michael Thomsen (Gerente de Produto, Dart) & 
Jeremy Sie (Designer Visual, Google Developer Studio)*
