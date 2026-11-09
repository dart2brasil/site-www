---
ia-translate: true
title: "Resultados do Google Summer of Code 2022"
description: "O programa Google Summer of Code (GSoC) busca engajar novos desenvolvedores do mundo todo no desenvolvimento de software open source. O Google…"
publishDate: 2022-11-03
author: jonasfj
image: images/1tzmsHv4_tAl7Nil6XZaANw.webp
category: other
layout: blog
---


O [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) busca engajar novos desenvolvedores do mundo todo no desenvolvimento de software open source. O Google patrocina estudantes para trabalhar, junto com uma organização open source que faz a mentoria, em um projeto de programação de 12 semanas durante o verão. Nos últimos 17 anos, mais de 18.000 colaboradores participaram do Google Summer of Code.

<DashImage src="images/1tzmsHv4_tAl7Nil6XZaANw.webp" alt="Os logos do Google Summer of Code e do Dart lado a lado." />


Em 2022, o Dart participou como organização mentora no Google Summer of Code pelo terceiro ano consecutivo. Após nossa [chamada de propostas em março](/blog/contributors-for-google-summer-of-code-2022), recebemos 50 propostas de projeto de possíveis participantes de todo o mundo. Hoje, destacamos alguns dos projetos que orientamos neste verão. Os colaboradores descrevem seus projetos neste post.

## Interop JNI para Dart {:#jni-interop-for-dart}

*Por Mahesh Hegde*

A plataforma Android usa Java como linguagem oficial. Acessar o seu rico ecossistema agregaria muito valor ao Dart, então desenvolvi uma interop com Java Native Interface (JNI) para Dart como meu projeto do GSoC.

O [*`package:jnigen`*](https://pub.dev/packages/jnigen) gera bindings que permitem usar classes e métodos Java a partir do Dart. O `jnigen` gera bindings em C que encapsulam bibliotecas Java, e bindings em Dart que chamam esses bindings em C. A biblioteca de suporte [`package:jni`](https://pub.dev/packages/jni) fornece as funções comuns para inicializar e acessar o JNI*.*

Considerando a complexidade tanto do Java quanto do JNI, a interop JNI para Dart continua experimental. A interop consegue encapsular recursos básicos da linguagem Java, como construtores, métodos estáticos e de instância e getters de campos. Exceções em Java são “relançadas” no Dart junto com os stack traces originais. A interop não consegue criar uma subclasse de uma classe Java a partir do Dart nem passar callbacks. Depois do GSoC, planejamos melhorar o pipeline de geração de bindings e implementar mais recursos da linguagem Java.

A complexidade técnica do projeto se mostrou desafiadora. Sabíamos que nunca tinha havido uma tentativa de interop com Java para uma linguagem de alto nível compilada nativamente usando JNI. Frequentemente precisávamos encontrar contornos quando algo não funcionava como esperado, como o carregamento dinâmico de bibliotecas e as exceções do JNI. Acabei escrevendo várias ferramentas para ajudar no projeto. Entre elas, uma para obter fontes Java do maven e outra para compilar bibliotecas compartilhadas. Aprendi muito sobre gestão de tempo, priorização, testes e a escrever código limpo, legível e compreensível.

## Dashboard administrativo da comunidade Flutter {:#flutter-community-admin-dashboard}

*Por Abdelrahman Amer*

Para o GSoC’22, projetei e construí um [dashboard administrativo para os repositórios da Flutter Community no GitHub](https://github.com/fluttercommunity/admin_dashboard). O dashboard ajuda os administradores da Flutter Community ao agregar as atividades mais recentes dos repositórios, mantenedores, níveis de acesso e muito mais. Ele inclui um gatilho para compilar e publicar no [pub.dev](https://pub.dev/). Implementei o projeto usando Flutter para o frontend e Firebase para o backend.

Durante o projeto, desenvolvi componentes reutilizáveis interessantes, incluindo:

1. Uma camada de abstração para o Firebase

1. Um widget MVC e classes de estrutura de dados associadas para exibir qualquer informação tabular ordenável por qualquer campo

1. Um widget MVC e classes de estrutura de dados para exibir dados gráficos 2D

O dashboard administrativo ainda não tem alguns recursos, mas as funcionalidades principais já foram implementadas. Espero continuar trabalhando em mais recursos depois do período do GSoC.

A experiência no GSoC me ensinou habilidades valiosas de desenvolvimento, especialmente em Flutter. Sou muito grato pela oportunidade, pelo ótimo ambiente de trabalho, pela experiência adquirida e pela mentoria que recebi de [Majid](https://github.com/mhadaily).

## Detectando restrições de versão incorretas {:#detecting-incorrect-version-constraints}

*Por Arseny Uskov*

Um mantenedor de pacote precisa atribuir uma versão apropriada a cada release de um pacote Dart. Ele precisa decidir se introduziu mudanças incompatíveis que afetam os usuários que dependem do seu pacote. Pacotes dependentes também assumem qual deve ser a faixa de versão apropriada para cada uma de *suas* dependências.

Bugs podem surgir a partir de suposições incorretas nessas áreas. Meu projeto buscou identificar e investigar um subconjunto desses bugs.

<DashImage src="images/187NMdHXboVklByFDhR9d2Q.webp" alt="Diagrama mostrando uma restrição de dependência incorreta causada pelo versionamento inadequado do package:foo." caption="Uma restrição de dependência incorreta causada pelo versionamento inadequado de `package:foo`" />


O projeto fornece ferramentas que resumem uma parte da API pública de uma determinada versão de um determinado pacote. Esse resumo identifica quaisquer outros pacotes que dependem do pacote dado e que podem ter uma restrição de versão incorreta. Nosso caso de uso cobria o cenário em que um pacote usa um símbolo definido em uma de suas dependências, mas o mesmo símbolo não inclui a versão mínima permitida daquela dependência.

O modelo de resumo da API pública permite uma série de outras aplicações interessantes de análise estática. Não tivemos tempo de explorá-las durante o GSoC. Para saber mais, consulte o [post do blog sobre a API Analysis](https://arseny.uk/posts/gsoc2022/) a respeito do projeto, dos desafios que enfrentamos, dos resultados obtidos ao rodar a análise no ecossistema do pub.dev, dos bugs que encontramos em pacotes reais e de um ponto de partida para você mexer no projeto por conta própria.

*Muito obrigado a todos que se inscreveram no Google Summer of Code 2022 com o Dart, aos colaboradores que concluíram os projetos neste ano e aos mentores que ajudaram a tornar este um verão de programação incrível. Se você tem interesse em saber mais sobre o Dart no Google Summer of Code, confira [nosso post de 2021](/blog/google-summer-of-code-2021-results).*
