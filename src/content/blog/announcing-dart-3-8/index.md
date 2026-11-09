---
ia-translate: true
title: "Anunciando o Dart 3.8"
description: "Esta versão traz atualizações do formatador, elementos null-aware para coleções, novas capacidades de desenvolvimento multiplataforma, uma forma melhor de encontrar pacotes em alta no pub.dev, disponibilidade do hot reload na web e mais…"
publishDate: 2025-05-20
author: antfitch
image: images/1cTcqAst5m1Vn6k71VWgTrQ.webp
category: releases
layout: blog
---


Esta versão traz atualizações do formatador, elementos null-aware para coleções, novas capacidades de desenvolvimento multiplataforma, uma forma melhor de encontrar pacotes em alta no pub.dev, disponibilidade do hot reload na web e mais! Também esperamos que alguns desenvolvedores se interessem em participar do nosso programa de acesso antecipado do FFigen e do JNIgen.

<DashImage src="images/1cTcqAst5m1Vn6k71VWgTrQ.webp" alt="Banner de lançamento do Dart 3.8 com o logo do Dart e um ícone de alvo." caption="Anunciando o Dart 3.8" />


## Atualizações do formatador {:#formatter-updates}

Na versão anterior, o Dart incluía um formatador amplamente reescrito, com suporte a um novo estilo ["alto"](https://github.com/dart-lang/dart_style/issues/1253). A versão 3.8 do Dart incorpora feedback adicional, corrige relatos de bugs e traz outras melhorias.

Note que, se você atualizar para o SDK do Dart 3.8, sua formatação não vai mudar até que você altere o pubspec do seu pacote para optar pela [versão da linguagem](https://dart.dev/language/versioning) mais recente.

### **Vírgulas finais e código mais alto** {:#trailing-commas-and-taller-code}

Nas versões anteriores, uma vírgula final forçava a construção ao redor a quebrar em várias linhas. O novo formatador agora decide se uma construção deve quebrar e então adiciona ou remove a vírgula final conforme necessário.

```dart
// Before formatter
TabBar(tabs: [Tab(text: 'A'), Tab(text: 'B')], labelColor: Colors.white70);

// After formatter
TabBar(
  tabs: [
    Tab(text: 'A'),
    Tab(text: 'B'),
  ],
  labelColor: Colors.white70,
);
```


Se você preferir o comportamento antigo, pode reativá-lo com uma flag de [configuração](https://github.com/dart-lang/dart_style/wiki/Configuration).

### **Mudanças de estilo** {:#style-changes}

Foram adicionadas várias mudanças de estilo que deixam a saída mais justa e melhor. Aqui estão alguns exemplos:

```dart
// Previously released formatter (functions)
function(
  name:
      (param) => another(
        argument1,
        argument2,
      ),
);

// Dart 3.8 formatter (functions)
function(
  name: (param) => another(
    argument1,
    argument2,
  ),
);

// Previously released formatter (variables)
variable =
    target.property
        .method()
        .another();

// Dart 3.8 formatter (variables)
variable = target.property
    .method()
    .another();
```


## Compilação cruzada {:#cross-compilation}

Há um novo suporte para [compilar](https://dart.dev/tools/dart-compile#cross-compilation-exe) para binários nativos do Linux a partir de máquinas de desenvolvimento com Windows, macOS e Linux. Você pode fazer isso com o comando `dart compile exe` ou `dart compile aot-snapshot` e as flags `--target-os` e `--target-arch`.

```shell
// cross compilation example for an exe
$ dart compile exe --target-os=linux --target-arch=arm64

// cross compilation example for an aot-snapshot
$ dart compile aot-snapshot --target-os=linux --target-arch=arm64
```


Exemplos de casos de uso:

* Compilações mais rápidas para dispositivos embarcados (por exemplo, um Raspberry Pi) em um notebook de desenvolvedor rápido, em vez de no dispositivo embarcado, que é menos potente.

* Compilações mais rápidas para um backend baseado em Linux em uma máquina de desenvolvimento que não é Linux.

## **Elementos null-aware** {:#null-aware-elements}

Os novos [elementos null-aware](https://dart.dev/language/collections#null-aware-element) permitem adicionar elementos a uma coleção, como uma lista, um conjunto ou um mapa, caso os elementos não sejam nulos. Para transformar um elemento em um elemento null-aware em um literal de coleção, coloque `?` antes do elemento.

Uma lista sem elementos null-aware que remove os valores nulos:

```dart
// Code without null-aware elements
var listWithoutNullAwareElements = [
  if (promotableNullableValue != null)
    promotableNullableValue,
  if (nullable.value != null)
    nullable.value!,
  if (nullable.value case var value?)
    value,
];
```


Uma lista com elementos null-aware que remove os valores nulos:

```dart
// Code with null-aware elements
var listWithNullAwareElements = [
  ?promotableNullableValue,
  ?nullable.value,
  ?nullable.value,
];
```


## Imports de documentação {:#doc-imports}

Agora há suporte a imports de documentação, uma nova sintaxe baseada em comentários que permite referenciar elementos externos em comentários de documentação sem de fato importá-los. Essa tag pode ser especificada em um comentário de documentação acima de uma diretiva `library`.

No exemplo a seguir, `[Future]` e `[Future.value]` são importados da biblioteca `dart:async`, mas apenas para os comentários de documentação:

```dart
/// @docImport 'dart:async';
library;

/// Doc comments can now reference elements like
/// [Future] and [Future.value] from `dart:async`,
/// even if the library is not imported with an
/// actual import.
class Foo {}
```


Os imports de documentação oferecem suporte aos mesmos estilos de URI dos imports Dart comuns, incluindo o esquema `dart:`, o esquema `package:` e caminhos relativos. No entanto, eles não podem ser deferidos nem configurados com `as`, `show` ou `hide`.

## Pacotes em alta no pub.dev {:#trending-packages-on-pub-dev}

A [página inicial do pub.dev](https://pub.dev/) substitui a seção "Pacotes mais populares" pela seção "Pacotes em alta". Essa nova seção destaca pacotes que recentemente demonstraram crescimento notável em adoção e interesse da comunidade.

<DashImage src="images/1hwpiNbr2JrUE8cROV3KagQ.webp" alt="Página inicial do pub.dev com a nova seção de pacotes em alta." caption="Seção de pacotes em alta no pub.dev" />


## Hot reload na web (experimental) {:#hot-reload-on-the-web-experimental}

O hot reload com estado agora está disponível na web quando você usa o Dart Development Compiler (DDC). Uma reformulação da representação em JS do código Dart permite trocar código em uma aplicação em execução.

O trabalho ainda está evoluindo nesse recurso, mas a versão 3.8 do Dart oferece a primeira oportunidade de experimentá-lo, começando pelos apps Flutter. Veja o [post do blog do Flutter]({{site.flutter-blog}}/whats-new-in-flutter-3-32) para instruções sobre como ativar o hot reload.

<DashImage src="images/0NB_4jaD3XtdHpCQm.webp" alt="Animação mostrando o hot reload com estado do Dart ativado para um app web no DartPad." caption="Hot reload com estado do Dart para web" />


Este foi um esforço de vários anos, que incluiu mudar a representação dos tipos em tempo de execução, redesenhar hierarquias de classes e atualizar a forma como o código é carregado na página. O objetivo é alcançar paridade total com a implementação existente de hot reload da VM. Na quase totalidade dos casos, o recurso já deve ser indistinguível do que você está acostumado com a VM. Você pode encontrar todos os problemas conhecidos no [gerenciador de issues](https://github.com/orgs/dart-lang/projects/107/views/1?filterQuery=-status%3ADone).

O foco torna esse recurso acessível primeiro nos apps Flutter, mas o plano é integrar o hot reload ao `build_web_compilers` para uso em apps web que não são Flutter, mais adiante.

## Interoperabilidade nativa direta {:#direct-native-interoperability}

Estamos animados em lançar um programa de acesso antecipado para o FFigen e o JNIgen, as soluções de geração de código criadas para simplificar a integração com APIs de plataformas nativas. Estamos procurando autores de plugins Flutter que queiram desenvolver ou refatorar plugins com essas soluções.

Para saber mais, leia o post do blog intitulado [Flutter's Path Towards Seamless Interop](https://medium.com/@mariam.hasnany/4bf7d4579d9a). Ele aborda nossas aspirações para a interoperabilidade nativa direta, o roteiro para alcançá-las e o programa de acesso antecipado.

## Encerramento {:#wrap-up}

O Dart 3.8 é a prova do nosso compromisso contínuo em refinar a experiência de desenvolvimento. Convidamos você a explorar esses novos recursos, desde o formatador inteligente e o suporte a compilação cruzada até os elementos null-aware, o hot reload na web e o acesso antecipado à interoperabilidade nativa. Seus insights e contribuições são vitais para o crescimento contínuo do Dart e do Flutter, e mal podemos esperar para ver os apps que você vai dar vida.

Atualize para o Dart 3.8 hoje e bom código!
