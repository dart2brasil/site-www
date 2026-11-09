---
ia-translate: true
title: "Anunciando o Dart 3.6"
description: "Bem-vindo ao Dart 3.6! Hoje é nosso último lançamento do ano, junto com o Flutter 3.27. Estamos animados para compartilhar um novo recurso da linguagem…"
publishDate: 2024-12-11
author: mbelanger
image: images/0pojZOcfCeFztkEzK.webp
category: releases
layout: blog
---


Bem-vindo ao Dart 3.6! Hoje é nosso último lançamento do ano, junto com o [Flutter 3.27]({{site.flutter-blog}}/whats-new-in-flutter-3-27). Estamos animados para compartilhar um novo recurso da linguagem, os *separadores de dígitos*. Também temos várias novidades no ecossistema do pub: *contagens de download do pub* e os tão aguardados *workspaces do pub*!

<DashImage src="images/0pojZOcfCeFztkEzK.webp" alt="Banner de lançamento do Dart 3.6 com o logo do Dart, um ícone de alvo e barras verticais azuis." caption="Dart 3.6" />


## Workspaces do pub {:#pub-workspaces}

O pub agora oferece resolução compartilhada entre pacotes em um monorepo, ou workspace. Um workspace é um grupo de pacotes fortemente relacionados que são desenvolvidos, resolvidos e lançados juntos.

O recurso de workspaces do pub garante que os pacotes de um monorepo compartilhem um conjunto consistente de dependências. Isso obriga você a resolver conflitos de dependência entre os pacotes agrupados *assim que eles surgem*, em vez de enfrentar confusão quando começar a usar os pacotes..

O analisador do Flutter processa todos os pacotes de um workspace do pub em um único contexto de análise, diferente do comportamento anterior, em que cada pacote tinha um contexto separado. Em repositórios grandes, isso pode reduzir significativamente a quantidade de memória que o servidor de linguagem do Dart consome, melhorando o desempenho da IDE.

Para definir um workspace do pub, adicione o campo `workspace` no arquivo `pubspec.yaml` da raiz e liste os pacotes relacionados, como mostrado no exemplo a seguir:

```yaml
name: _
publish_to: none
environment:
  sdk: ^3.6.0
workspace:
  - packages/helper
  - packages/client_package
  - packages/server_package
```


Depois, execute `pub get` em qualquer lugar do repositório para concluir o mapeamento e o restante do gerenciamento de arquivos.

Para usar workspaces do pub, todos os pacotes do workspace (mas não as dependências) precisam ter uma restrição de versão do SDK igual ou superior a `^3.6.0`.

Para mais informações, incluindo instruções totalmente detalhadas e a cobertura de casos especiais, confira a página [Workspaces do pub (suporte a monorepo)](https://dart.dev/go/pub-workspaces).

## Contagens de download do pub {:#pub-download-counts}

Ouvimos [os seus pedidos](https://github.com/dart-lang/pub-dev/issues/2714) por métricas mais precisas no pub.dev, e agora as contagens de download chegaram! A contagem de downloads substitui a antiga "pontuação de popularidade" nas páginas de cada pacote. Junto com a nova métrica, você também encontrará um gráfico sparkline em cada página, mostrando os downloads semanais ao longo do tempo.

<DashImage src="images/0KJoC5ioNl7lXms0P.webp" alt="A nova contagem de downloads e o gráfico sparkline exibidos no pub.dev." caption="Uma captura de tela destacando a nova contagem de downloads e o gráfico sparkline no pub.dev" />


Você pode saber mais sobre as contagens de download na [documentação de pontuação do pub.dev](https://pub.dev/help/scoring).

## Separadores de dígitos {:#digit-separators}

A linguagem Dart agora permite o uso de sublinhados (_) como separadores de dígitos, que ajudam a tornar literais numéricos longos mais legíveis. Vários sublinhados consecutivos indicam um agrupamento de nível mais alto. Aqui estão alguns exemplos válidos de uso de separadores de dígitos em Dart:

```
1__000_000__000_000__000_000
0x4000_0000_0000_0000
0.000_000_000_01
0x00_14_22_01_23_45
```


Lembre-se de que os separadores de dígitos são válidos apenas *entre* dígitos, então literais como `100_`, `0._000_1` ou `1.2e_3` não são permitidos. Também é importante usar separadores de dígitos de forma consistente, então certifique-se de que os grupos de dígitos tenham o mesmo tamanho em todos os níveis de agrupamento.

Para usar separadores de dígitos, você precisará elevar o SDK mínimo do seu pacote para `3.6.0` ou superior.

## Encerramento {:#closing}

É isso por hoje. Para a história completa do que a equipe do Dart esteve fazendo neste trimestre, confira o [Changelog da 3.6.0](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#360). E não deixe de visitar o post do [blog de lançamento do Flutter 3.27]({{site.flutter-blog}}/whats-new-in-flutter-3-27) para ainda mais novidades. Até o ano que vem!
