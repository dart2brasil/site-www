---
ia-translate: true
title: "Apresentando o Realm para Dart e Flutter"
description: "Um estudo de caso sobre como usar as primitivas da plataforma Dart para construir uma biblioteca multiplataforma robusta para apps em Dart e Flutter."
publishDate: 2023-02-09
author: mit-mit
image: images/1cAi4WO4IfN5Sp6WE6Ex8Ig.webp
category: announcements
layout: blog
---


Estamos animados em ver a MongoDB anunciar hoje a disponibilidade geral (GA) do Realm para Dart e Flutter! O Realm é um banco de dados reativo, orientado a objetos e multiplataforma, popular entre desenvolvedores de apps. Em outras palavras, perfeito para Dart e Flutter. Ao longo do último ano, colaboramos com a MongoDB para trazer o Realm para o Dart e o Flutter. Confira o [post no blog](https://www.mongodb.com/developer/products/realm/announcing-realm-flutter-sdk/) da MongoDB para detalhes sobre o que o Realm oferece, como ele evoluiu em relação às prévias anteriores e o que eles planejam para o futuro. Achamos que o Realm será uma ótima escolha para desenvolvedores de Dart e Flutter.

<DashImage src="images/1cAi4WO4IfN5Sp6WE6Ex8Ig.webp" alt="Trecho de código demonstrando como gravar livros em um armazenamento de dados Realm usando Dart." caption="Gravando livros em um armazenamento de dados Realm usando Dart" />


Neste post complementar, vamos espiar os bastidores para entender como o Realm para Dart e Flutter é construído, como um exemplo prático de como criar novos SDKs para desenvolvedores baseados em Dart.

## Exemplo com o Realm {:#realm-example}

Antes de mergulharmos na implementação do SDK do Realm, vamos começar com um tour rápido sobre como usar o SDK como desenvolvedor trabalhando em um [app de terminal](https://dart.dev/tutorials/server/cmdline) em Dart (*observação*: os passos para um app Flutter são um pouco diferentes; veja [a documentação](https://www.mongodb.com/docs/realm/sdk/flutter/install/) para detalhes).

Primeiro, você define um modelo de dados. Isso é feito usando classes Dart comuns com algumas anotações do Realm. Aqui está uma classe de dados de exemplo para um livro:


Com o modelo definido e o modelo de dados totalmente gerado (veja abaixo), você pode gravar alguns livros em um armazenamento de dados Realm:



## Como o Realm para Dart e Flutter foi construído {:#how-realm-for-dart-and-flutter-was-built}

Agora que cobrimos o básico, vamos ver como a equipe da MongoDB construiu o Realm para Dart e Flutter utilizando várias bibliotecas e ferramentas do Dart. Vamos analisar o que acontece quando o SDK do Realm é inicializado, como o SDK é construído sobre uma biblioteca nativa C++ compartilhada, como a ferramenta de terminal do Realm foi criada e como os modelos do Realm são gerados.

## Inicializando o SDK do Realm {:#initializing-the-realm-sdk}

Desenvolvedores de Dart e Flutter começam adicionando o Realm ao app existente e, em seguida, executando o instalador:

```shell
dart pub add realm_dart
dart run realm_dart install
```


O primeiro passo simplesmente adiciona o SDK do Realm ao `pubspec.yaml`, para [registrá-lo como dependência](https://dart.dev/tools/pub/dependencies) do app. O segundo passo executa a ferramenta de terminal do Realm, pedindo que ela instale o SDK. Se olharmos dentro do [código-fonte do comando install](https://github.com/realm/realm-dart/blob/main/lib/src/cli/install/install_command.dart), vemos que o `install` determina em qual sistema operacional estamos desenvolvendo e, em seguida, baixa os binários do SDK do Realm para esse sistema operacional.

Mas por que o comando install baixa um binário? O SDK do Realm é uma oferta bem abrangente, disponível em uma grande variedade de sistemas operacionais e frameworks de desenvolvimento. Para evitar construir um grande número de instanciações do SDK do Realm, a equipe do Realm decidiu implementar o SDK principal como uma biblioteca C++ compartilhada, a [realm-core](https://github.com/realm/realm-core). Então, o que o comando install realmente faz é baixar versões compiladas dessa biblioteca principal para todas as plataformas suportadas pelo app.

## Chamando o SDK realm-core {:#calling-into-the-realm-core-sdk}

Quem usa o SDK do Realm para escrever apps em Dart ou Flutter recebe APIs em Dart fortemente tipadas, como ilustrado no início deste post. Como essas APIs correspondem à biblioteca C++ [`realm-core`](https://github.com/realm/realm-core)?

Se dermos uma olhada dentro do diretório `lib` do SDK do Realm, encontramos [`realm_bindings.dart`](https://github.com/realm/realm-dart/blob/main/lib/src/native/realm_bindings.dart), que começa com:


Mistério resolvido: o SDK do Realm usa o suporte do Dart à interoperabilidade com APIs nativas, por meio da biblioteca `dart:ffi`, para chamar o realm-core. Para evitar escrever bindings FFI manualmente para o grande conjunto de APIs do Realm, os bindings são gerados automaticamente com a ferramenta [`ffigen`](https://pub.dev/packages/ffigen) do Dart. Esse é um padrão que estamos vendo crescer rapidamente em toda a equipe do Dart.

## A ferramenta de terminal do Realm {:#the-realm-terminal-tool}

Vamos falar da própria ferramenta de terminal do Realm. Acima, executamos o comando install, mas também podemos executar a ferramenta sem especificar um comando:

```shell
$ dart run realm_dart
Realm commands for working with Realm Flutter & Dart SDKs.

Usage: dart run realm|realm_dart <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  generate   Generate Realm objects from data model classes
  install    Download & install Realm native binaries into a Flutter or Dart project
  metrics    Report anonymized builder metrics to Realm

Run "dart run realm|realm_dart help <command>" for more information about a command.
```


Você pode notar que essa saída se parece muito com a saída das ferramentas principais do dart e do flutter. Não é coincidência: as três ferramentas são construídas com as mesmas bibliotecas-base do Dart para ferramentas de terminal, do [`package:args`](https://pub.dev/packages/args):

* A biblioteca [`args`](https://pub.dev/documentation/args/latest/args/args-library.html) tem suporte rico para analisar argumentos brutos da linha de comando em opções e flags

* A biblioteca [`command_runner`](https://pub.dev/documentation/args/latest/command_runner/command_runner-library.html) fornece uma estrutura para os comandos suportados pela ferramenta (por exemplo, install)

## Gerando o modelo do Realm {:#generating-the-realm-model}

O comando `generate` é especialmente interessante porque gera o modelo completo do Realm a partir das classes de modelo anotadas em Dart que definimos na seção “Exemplo com o Realm”:

```shell
dart run realm_dart generate
```


Como o comando generate funciona? Ele depende do [gerador](https://github.com/realm/realm-dart/blob/main/generator/README.md) do Realm, que é construído sobre o [`build_runner`](https://pub.dev/packages/build_runner) do Dart, um framework para geradores que recebe um conjunto de arquivos de entrada e, em seguida, cria novos arquivos de saída. Normalmente, como no caso do Realm, as entradas são arquivos de código-fonte Dart com anotações, e as saídas são código-fonte Dart adicional gerado.

## Considerações finais {:#closing-thoughts}

Esperamos que você tenha gostado desta espiada nos bastidores de como um grande framework para desenvolvedores pode ser construído a partir de um conjunto de bibliotecas Dart reutilizáveis. Se você é desenvolvedor de frameworks, esperamos que isso sirva de inspiração para o seu próximo framework baseado em Dart.

Para desenvolvedores de apps Dart e Flutter, o Realm é uma ótima novidade da equipe da MongoDB. Convidamos você a conferir a [documentação do SDK do Realm](https://www.mongodb.com/docs/realm/sdk/flutter/) e o [post de hoje no blog do Realm](https://www.mongodb.com/developer/products/realm/announcing-realm-flutter-sdk/).
