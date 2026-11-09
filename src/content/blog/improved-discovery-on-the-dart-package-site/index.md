---
ia-translate: true
title: "Descoberta melhorada no site de pacotes do Dart"
description: "Em julho, falamos sobre as nossas mudanças no site de pacotes do Dart (http://pub.dartlang.org), que incluíram melhor suporte para analisar…"
publishDate: 2018-09-24
author: mit-mit
image: images/1wh9C-VJUKEYz4l2zpUkg4A.webp
category: announcements
layout: blog
---


Em julho, falamos sobre [nossas mudanças](/blog/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site) no site de pacotes do Dart ([http://pub.dartlang.org](http://pub.dartlang.org)), que incluíram melhor suporte para analisar pacotes em busca de possíveis problemas. Desde então, nos concentramos em melhorias adicionais na descoberta de conteúdo no site de pacotes.

## Incompatibilidade com Dart 2 {:#dart-2-incompatibility}

A grande maioria dos pacotes recentes e populares foi [migrada para suportar o Dart 2](https://www.dartlang.org/dart-2#migration), então eles estão prontos para apps [Flutter](https://flutter.io/) e [AngularDart](https://webdev.dartlang.org/angular) 5. No entanto, alguns pacotes (principalmente os mais antigos, que não estão mais em manutenção) ainda não oferecem suporte ao Dart 2. Para que você consiga identificá-los facilmente, agora adicionamos marcações de incompatibilidade com o Dart 2 nas páginas de visão geral e de detalhes dos pacotes.

<DashImage src="images/1wh9C-VJUKEYz4l2zpUkg4A.webp" alt="Pacotes incompatíveis com o Dart 2 são claramente marcados como 'Dart 2 incompatible'." caption="Pacotes incompatíveis com o Dart 2 são claramente marcados como ‘Dart 2 incompatible’" />


Também prevemos arquivar ou descontinuar esses pacotes incompatíveis em uma versão futura do site de pacotes. Então, se você é autor de um pacote marcado como 'Dart 2 incompatible', considere migrá-lo em breve!

## Suporte para bibliotecas principais {:#support-for-core-libraries}

O Dart vem com um conjunto rico de bibliotecas principais (padrão). Os desenvolvedores nos disseram que pode ser difícil lembrar se determinada função utilitária está em uma biblioteca principal ou em um pacote. Para ajudar você a encontrar a API de que precisa, as buscas no pub.dartlang.org agora incluem não só os pacotes publicados, mas também as bibliotecas principais. Os resultados de bibliotecas principais têm **sdk** no círculo de pontuação e a anotação **Dart core library**. Se você clicar na entrada, vai direto para a documentação da API da biblioteca.

<DashImage src="images/1Q9oEytibPnPy23qiSliyyQ.webp" alt="Resultados de busca no pub por json, com dart:convert aparecendo acima dos pacotes e marcado com um selo de pontuação sdk." caption="Resultados encontrados nas bibliotecas principais do SDK são incluídos entre os resultados" />


## Feed de atualizações de pacotes {:#package-update-feed}

O pub oferece um feed Atom há algum tempo. Para torná-lo mais fácil de encontrar, adicionamos um link direto no rodapé do site.

<DashImage src="images/01rSptJGr3iaTKqvb.webp" alt="O rodapé do site pub.dev mostrando links para 'Dart language', 'Terms', 'Privacy', 'Help' e um ícone de RSS." />


## Mudanças na pontuação {:#scoring-changes}

Fizemos várias simplificações e ajustes no modelo de pontuação de saúde e manutenção. Para uma visão geral do modelo atual, consulte o [README do pana](https://github.com/dart-lang/pana/blob/master/README.md) (pana é a ferramenta que fornece a pontuação).

No futuro, planejamos melhorar a transparência, mostrando na própria página de análise do pacote o quanto cada problema relatado reduziu a pontuação geral.

## Feedback bem-vindo {:#feedback-welcome}

Encontrou um problema? Tem uma ideia legal ou uma sugestão? Conte para nós [abrindo uma issue](https://github.com/dart-lang/pub-dartlang-dart/issues/new?body=URL%3A+https%3A%2F%2Fpub.dartlang.org%2F%0A%0A%3CDescribe+your+issue+or+suggestion+here%3E&title=%3CSummarize+your+issues+here%3E&labels=Area%3A+site+feedback) no nosso tracker. Também vale notar que o próprio site de pacotes é de código aberto, no repositório [pub-dartlang-dart](https://github.com/dart-lang/pub-dartlang-dart), e contribuições e ideias são muito bem-vindas!
