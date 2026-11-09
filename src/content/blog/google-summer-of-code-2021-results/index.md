---
ia-translate: true
title: "Resultados do Google Summer of Code 2021"
description: "A equipe do Dart recebeu 92 propostas de projeto do GSoC de estudantes de todo o mundo. Veja os resultados dos 3 projetos que aceitamos."
publishDate: 2021-10-14
author: jonasfj
image: images/1QswESHAF6CO9UNYCcRVKXA.webp
category: other
layout: blog
---


[Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) é um programa global focado em trazer estudantes desenvolvedores para o desenvolvimento de software open source. Os estudantes são patrocinados pelo Google para trabalhar, junto com uma organização open source que faz a mentoria, em um projeto de programação de 10 semanas durante o verão. Nos últimos 16 anos, mais de 16.000 estudantes participaram do Google Summer of Code.

2021 foi a segunda vez que a organização Dart participou do Google Summer of Code como organização mentora. Após nossa [chamada para propostas de estudantes em março](/blog/dart-in-google-summer-of-code-2021), recebemos 92 propostas de projeto de estudantes de todo o mundo, das quais ficamos muito felizes em aceitar 3 projetos. Hoje estamos animados para compartilhar os resultados, conforme descritos pelos estudantes que trabalharam nesses projetos.

## Cliente HTTP baseado em Cronet para Dart {:#cronet-based-http-client-for-dart}

*Por Soumyadip Mondal*

O pacote [cronet](https://pub.dev/packages/cronet) é um pacote HTTP para as plataformas nativas do Dart, baseado no [motor de rede do Chromium](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/components/cronet).

Você pode perguntar “por que adicionar um pacote HTTP?”, já que o Dart já tem suporte a HTTP em `dart:io`. Um dos motivos é que o `package:cronet` pode usar o protocolo QUIC/HTTP3, que é [um recurso muito solicitado](https://github.com/dart-lang/sdk/issues/38595) pela comunidade. Além disso, o `package:cronet` é [mais rápido que o `d](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md#performance-comparison)art:io` em muitos cenários.

Um binding em Dart para o Cronet nos dá acesso fácil aos seus [recursos](https://www.chromium.org/developers/design-documents/network-stack#TOC-Connection-Management), como: reutilização de sockets, algoritmos poderosos de cache e compressão, priorização de requisições e conexões de rede [mais confiáveis](https://www.youtube.com/watch?v=YWiRef3wOYY). Vários produtos do Google, incluindo YouTube, Chrome, Google Maps, Google Fotos e o app do Google, já dependem da biblioteca Cronet para suas necessidades de rede. Com o `package:cronet`, você acessa a biblioteca Cronet por meio de uma API [semelhante](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md#api-comparison) à do `dart:io`, com pouca ou nenhuma mudança no seu app Dart/Flutter existente.

Confira [github.com/google/cronet.dart](https://github.com/google/cronet.dart) para ver [benchmarks](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md#performance-comparison), [exemplos](https://github.com/google/cronet.dart/tree/main/example) e [comparações com `d](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md)art:io`. Veja também [este post do blog](https://unsuitable001.medium.com/package-cronet-an-http-dart-flutter-package-with-dart-ffi-84f9b69c8a24) sobre o `package:cronet`, com uma visão técnica geral e a discussão dos desafios que enfrentamos.

## Ferramenta desktop para Flutter {:#flutter-desktop-tool}

*Por Abdullah Deshmukh*

Depois do lançamento beta do suporte a desktop no Flutter 2, precisávamos de um app de exemplo para demonstrar como escrever um app Flutter que roda no Windows, macOS e Linux. Eu trabalhei nesse exemplo, na forma de uma [ferramenta de linting para Flutter que ](https://github.com/flutter/samples/tree/master/experimental/linting_tool)ajuda você a gerenciar as regras de lint dos seus projetos Flutter. O código-fonte do app mostra como você pode implementar técnicas básicas de apps desktop, como ler e escrever arquivos, implementar um layout responsivo, usar armazenamento persistente e até como trabalhar com arquivos YAML. Além disso, o exemplo também pode ser usado para testar a distribuição de apps Flutter nas várias lojas de apps desktop.

Para mais detalhes, acesse [GSoC ’21: criando um exemplo de desktop para Flutter]({{site.flutter-blog}}/gsoc-21-creating-a-desktop-sample-for-flutter).

<DashImage src="images/1QswESHAF6CO9UNYCcRVKXA.webp" alt="A ferramenta de linting para Flutter mostra várias regras de lint e suas descrições." caption="Ferramenta de linting para Flutter" />


## Detecção de licenças para o pub.dev {:#license-detection-for-pubdev}

*Por Bharat Biradar*

Um pacote publicado no [pub.dev](https://pub.dev/) é avaliado com base em várias métricas, se segue as convenções de arquivos do Dart, se tem um arquivo CHANGELOG etc. Essa análise é feita pelo [pana](https://github.com/dart-lang/pana) (Package ANAlysis for Dart). O pana também é responsável por detectar o identificador da licença sob a qual o pacote é publicado.

Até então, os nomes de licença exibidos no pub.dev eram determinados por heurísticas simples de expressões regulares, que só suportavam a detecção de algumas licenças e com baixa precisão. A tarefa deste projeto foi criar um detector de licenças para o pana que detecte [licenças SPDX](https://spdx.org/licenses), em linha com as [diretrizes de correspondência SPDX](https://spdx.dev/license-list/matching-guidelines/).

O detector de licenças criado para o pana usa a mesma abordagem do [v2_licenseclassifier](https://github.com/google/licenseclassifier), com modificações feitas para atender melhor às nossas necessidades.

Dado o arquivo LICENSE de um pacote, o pana usa três etapas para detectar os identificadores de licença SPDX:

1. **Eliminar incompatibilidades óbvias com o corpus SPDX:** Dividir o texto em tokens (basicamente palavras), verificar se o arquivo LICENSE tem um número suficiente de tokens (pelo menos 50%) em comparação com uma licença conhecida, e eliminar todas as licenças conhecidas que não atendem ao critério. Essa etapa permite que o pana descarte rapidamente muitas licenças, possibilitando cálculos mais caros na etapa 2.

1. **Encontrar substrings correspondentes no texto desconhecido e nas licenças SPDX restantes:** Para as licenças conhecidas restantes, encontrar os substrings do texto desconhecido que correspondem ao texto de uma licença conhecida. Procuramos substrings porque o texto desconhecido pode conter várias licenças. Ao identificar substrings correspondentes, ignoramos sequências com menos tokens do que `threshold * número_de_tokens_na_licença_conhecida`, porque essas sequências não têm densidade de tokens suficiente para constituir uma correspondência. Se nenhum substring com densidade de tokens suficiente for encontrado para uma determinada licença conhecida, sabemos que ela não é uma correspondência.

1. **Determinar as pontuações de confiança:** Esta etapa **estima uma pontuação de confiança** (entre [0,1]) para os substrings encontrados. Primeiro, o substring é comparado, usando [diff de palavras de Levenshtein](https://github.com/google/diff-match-patch/wiki/Line-or-Word-Diffs#word-mode), com a licença do corpus SPDX em que foi detectado. Depois, a licença é considerada uma correspondência se a confiança calculada da seguinte forma estiver acima do limite definido:

<DashImage src="images/1wB7F9CgvSn7yt2Rgoj75pw.webp" alt="Uma fórmula para calcular a pontuação de confiança de uma correspondência de licença." />


Esperamos que isso dê uma ideia do processo de detecção de licenças. Se você quiser experimentar o detector de licenças, ele está no [repositório do pana](https://github.com/dart-lang/pana/tree/master/bin).

*Muito obrigado a todos que se inscreveram no Google Summer of Code 2021 com o Dart, aos estudantes que concluíram os projetos neste ano e aos mentores que ajudaram a tornar este um verão de programação incrível. Se você tem interesse em saber mais sobre o Dart no Google Summer of Code, confira [nosso post de 2020](/blog/google-summer-of-code-2020-results).*
