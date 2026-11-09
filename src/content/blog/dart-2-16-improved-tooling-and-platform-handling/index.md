---
ia-translate: true
title: "Dart 2.16: ferramentas melhoradas e tratamento de plataformas"
description: "Suporte ao Flutter para Windows com marcação de plataformas em pacotes e uma nova experiência de busca para o pub.dev"
publishDate: 2022-02-03
author: mit-mit
image: images/0PJwhbfaIwRq3sSJi.webp
category: releases
layout: blog
---


Hoje está disponível o Dart SDK versão 2.16. Ele não traz novos recursos de linguagem, mas traz um monte de correções de bugs (incluindo a correção de uma vulnerabilidade de segurança), suporte melhorado para declarar as plataformas que os pacotes Dart suportam e uma experiência de busca totalmente nova para o [pub.dev](https://pub.dev/).

## Dart 2.16 {:#dart-2-16}

O SDK do Dart 2.16, que é lançado hoje junto com o [Flutter 2.10]({{site.flutter-blog}}/whats-new-in-flutter-2-10), continua a transição das antigas ferramentas de linha de comando do Dart (`dartfmt`, `dartdoc`, etc.) para a nova ferramenta de desenvolvedor combinada [`dart`](https://dart.dev/tools/dart-tool). As ferramentas recém-descontinuadas são `dartdoc` (use `dart doc`) e `dartanalyzer` (use `dart analyze`). No Dart 2.17, planejamos remover por completo os comandos `dartdoc`, `dartanalyzer` e `pub` (descontinuados no Dart 2.15; use `dart pub` ou `flutter pub`). Para detalhes, veja a [issue #46100](https://github.com/dart-lang/sdk/issues/46100).

A versão 2.16 também inclui a correção de uma vulnerabilidade de segurança e duas pequenas mudanças que quebram compatibilidade:

* A API [`HttpClient`](https://github.com/dart-lang/sdk/security/advisories/GHSA-c8mh-jj22-xg5h#:~:text=https%3A//api.dart.dev/dart%2Dio/HttpClient%2Dclass.html) em `dart:io` permite definir headers opcionais para `authorization`, `www-authenticate`, `cookie` e `cookie2`. A lógica de redirecionamento nos SDKs anteriores ao Dart 2.16 tinha uma vulnerabilidade: esses headers, que podem conter informações sensíveis, eram repassados quando ocorria um redirecionamento entre origens diferentes. No Dart 2.16, esses headers são descartados. Para detalhes, veja [CVE-2022–0451](https://github.com/dart-lang/sdk/security/advisories/GHSA-c8mh-jj22-xg5h).

* A API `Directory.rename` em `dart:io` mudou de comportamento no Windows: ela não remove mais um diretório existente com o nome de destino (issue [#47653](https://github.com/dart-lang/sdk/issues/47653)).

* As APIs `Platform.packageRoot` e `Isolate.packageRoot` — que sobraram do Dart 1.x e não funcionavam no Dart 2.x — foram removidas (issue [#47769](https://github.com/dart-lang/sdk/issues/47769)).

Para encontrar mais detalhes sobre as mudanças no Dart 2.16, veja o [changelog](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#2160).

## Novo suporte para declarar plataformas suportadas por pacotes do pub.dev {:#new-support-for-declaring-platform-support-for-pub-dev-packages}

O Dart foi projetado para portabilidade, e nos esforçamos para permitir código que roda na maior variedade possível de plataformas. No entanto, às vezes você pode criar e compartilhar pacotes no pub.dev que foram feitos para apenas uma ou algumas plataformas. Pode ser que seu pacote dependa de uma API disponível apenas em um sistema operacional específico, ou que use uma biblioteca como `dart:ffi`, que só tem suporte em plataformas nativas e não na web.

Com o Dart 2.16, agora você pode declarar manualmente o conjunto de plataformas suportadas no pubspec do pacote. Por exemplo, se o seu pacote suporta apenas Windows e macOS, o arquivo `pubspec.yaml` pode ficar assim:

```
name: mypackage
version: 1.0.0

platforms:
  windows:
  macos:

dependencies:
```


A nova tag `platforms` é destinada a casos em que você está desenvolvendo um pacote Dart e quer declarar suporte a um conjunto de plataformas diferente do que o pub.dev detecta automaticamente. Se você está desenvolvendo e compartilhando um plugin do Flutter que contém código específico de cada host (por exemplo, Kotlin ou Swift), a [tag de plugin do Flutter](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#plugin-platforms) normalmente especifica as plataformas suportadas.

## Nova interface de busca do pub.dev {:#new-pub-dev-search-ui}

Atendendo a pedidos dos desenvolvedores, criamos um suporte melhor para buscar pacotes no pub.dev. O principal objetivo das mudanças lançadas hoje é ajudar você a identificar e buscar o conjunto de plataformas suportadas. Veja como fica a nova experiência de busca:

<DashImage src="images/0PJwhbfaIwRq3sSJi.webp" alt="Interface de busca do pub.dev com filtros na barra lateral para plataformas, SDKs e busca avançada." caption="Interface de busca do pub.dev com uma barra lateral contendo os filtros Platforms, SDKs e Advanced search" />


A nova interface de busca tem uma barra lateral de filtros à esquerda, que você pode usar para restringir sua busca por pacotes:

* **Platforms**: selecione uma ou mais plataformas para restringir os resultados apenas a pacotes que suportam todas as plataformas selecionadas.

* **SDKs**: selecione Dart ou Flutter para limitar os resultados a pacotes que suportam o Dart SDK ou o Flutter SDK, respectivamente.

* **Advanced**: opções de busca adicionais, como filtrar apenas os pacotes Flutter Favorite.

## Atualização sobre null safety {:#null-safety-update}

Faz algumas versões que não falamos sobre null safety, a grande novidade da linguagem que foi lançada há um ano, no [Dart 2.12](/blog/announcing-dart-2-12). Ficamos impressionados com a velocidade com que o ecossistema do Dart migrou os pacotes para oferecer suporte a null safety: hoje, 100% dos 250 pacotes mais populares e 96% dos 1000 mais populares já suportam null safety! Obrigado a todos os autores de pacotes que contribuíram para essa conquista.

Também vimos um bom progresso dos aplicativos que estão migrando para sound null safety (o estado em que o código do aplicativo e todas as dependências de pacotes já foram migrados). Pelos nossos dados de análise, 71% de todas as sessões de execução na ferramenta do Flutter agora usam sound null safety por completo. Se você é um desenvolvedor de aplicativos e ainda não migrou, agora é um ótimo momento.

## Comentários finais {:#closing-comments}

Esperamos que você ache a nova interface de busca do pub.dev útil, e damos boas-vindas a [qualquer feedback](https://github.com/dart-lang/pub-dev/issues/) que você tiver. Fique de olho na próxima versão do Dart SDK, que está prevista para o segundo trimestre de 2022. Estamos trabalhando em vários [recursos de linguagem empolgantes](https://github.com/dart-lang/language/projects/1) que esperamos lançar ainda este ano.
