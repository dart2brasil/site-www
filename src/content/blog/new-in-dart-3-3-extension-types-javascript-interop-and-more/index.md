---
ia-translate: true
title: "Novidades no Dart 3.3: Extension Types, interop com JavaScript e mais"
description: "O Dart 3.3 chegou, e é uma virada de jogo para performance e desenvolvimento multiplataforma! Prepare-se para turbinar seus apps com…"
publishDate: 2024-02-15
author: kevmoo
image: images/1p4TBp0I66rJTq0LvnSuE7g.webp
category: releases
layout: blog
---


<DashImage src="images/1p4TBp0I66rJTq0LvnSuE7g.webp" alt="Dart 3.3 release banner with the Dart logo and a bullseye icon." />


**O Dart 3.3 chegou, e é uma virada de jogo para performance e desenvolvimento multiplataforma!** Prepare-se para turbinar seus apps com **Extension Types**, que revolucionam a otimização de performance e a forma como você interage com código nativo. Além disso, nosso modelo de **interop com JavaScript** reformulado traz segurança de tipos robusta e uma forma amigável para o desenvolvedor acessar o poder da plataforma web. Tudo isso abre caminho para o suporte ao **WebAssembly**. Ah, e o **Google AI nos seus apps Dart**? Claro que sim! Está tudo aqui no Dart 3.3. Vamos mergulhar!

## Apresentando os Extension Types {:#introducing-extension-types}

Extension types introduzem wrappers de custo zero para tipos. Use-os para otimizar código sensível à performance, especialmente ao interoperar com plataformas hospedeiras. Extension types oferecem a conveniência de tipos customizados com membros específicos, eliminando o custo típico de alocação de wrappers.

```dart
extension type Wrapper(int i) {
  void showValue() {
    print('my value is $i');
  }
}

void main() {
  final wrapper = Wrapper(42);
  wrapper.showValue(); // Prints 'my value is 42'
}
```


O exemplo anterior define **`Wrapper`** como um extension type, mas o usa como um tipo Dart trivial. Você pode instanciá-lo e invocar funções. A diferença fundamental é que o Dart o compila como um **`int`** Dart normal. Extension types permitem a conveniência de criar um tipo com membros próprios sem o custo de indireção de alocar um tipo wrapper típico. Assim, embora o recurso de [extension members](https://dart.dev/language/extension-methods) (disponível no Dart desde a 2.7) permita adicionar funções e propriedades a um tipo existente, o recurso de extension type faz o mesmo *e também* permite definir uma nova API que oculta a representação subjacente.

Isso é especialmente útil para interoperabilidade com plataformas hospedeiras. Tipos nativos podem ser usados diretamente, sem o custo de criar wrappers e a indireção associada, mantendo ainda uma API Dart limpa e pronta para produção. Saiba mais na [nova documentação sobre extension types](http://dart.dev/language/extension-types).

## Evoluindo o interop com JavaScript {:#evolving-javascript-interop}

O Dart 3.3 introduz um novo modelo para interoperar com bibliotecas JavaScript e com a web. Ele começa com um novo conjunto de APIs para interagir com JavaScript: a biblioteca [dart:js_interop](https://api.dart.dev/dart-js_interop/dart-js_interop-library.html). Agora, desenvolvedores Dart têm acesso a uma API tipada para interagir com JavaScript. Essa API define claramente a fronteira entre as duas linguagens, com enforcement estático. Isso elimina toda uma classe de problemas *antes* da compilação. Além das novas APIs para acessar código JavaScript, o Dart agora inclui um novo modelo para representar tipos JavaScript em Dart usando extension types.

```dart
import 'dart:js_interop';

/// Represents the `console` browser API.
extension type MyConsole(JSObject _) implements JSObject {
  external void log(JSAny? value);
  external void debug(JSAny? value);
  external void info(JSAny? value);
  external void warn(JSAny? value);
}
```


A sintaxe, baseada em extension types, permite mais expressividade e solidez do que os extension members. Isso simplifica o uso de APIs JavaScript a partir do Dart. Saiba mais na [nova documentação sobre JS interop](https://dart.dev/interop/js-interop).

## Melhorando as bibliotecas de browser {:#improving-browser-libraries}

Desde a versão 1.0, o SDK do Dart inclui um conjunto abrangente de bibliotecas para browser. Elas incluem a biblioteca principal [dart:html](https://api.dart.dev/dart-html/dart-html-library.html), junto com bibliotecas para SVG, WebGL e outras.

O modelo de interop com JavaScript aprimorado nos deu a chance de repensar essas bibliotecas. Daqui para frente, nosso suporte a bibliotecas de browser vai se concentrar no [package:web](https://pub.dev/packages/web). Isso simplifica o versionamento, acelera as atualizações e se alinha aos recursos do [MDN](https://developer.mozilla.org/).

Essa cadeia de melhorias leva à próxima grande novidade: compilar Dart para [WebAssembly](https://webassembly.org/).

## Comece hoje a preparar o futuro com WebAssembly {:#start-today-to-enable-a-webassembly-future}

Com o Dart 3.3, autores de pacotes e aplicativos podem preparar o terreno para aplicações web compiladas para [WebAssembly](https://webassembly.org/). Embora o suporte a WebAssembly no Flutter Web ainda seja experimental, a equipe está trabalhando duro para estabilizar a implementação. Para rodar aplicativos Flutter na web usando WebAssembly, você precisa migrar todo o código — do aplicativo e de todas as dependências — para usar o novo mecanismo de JavaScript Interop e o [package:web](https://pub.dev/packages/web). As bibliotecas legadas de JavaScript e de browser continuam inalteradas e suportadas para compilar para código JavaScript. No entanto, compilar para WebAssembly exige uma migração.

Criamos um [guia de migração](https://dart.dev/go/package-web) para ajudar os autores a começar a incluir Wasm. Esperamos que os pacotes mais populares já ofereçam suporte a Wasm até o momento em que o incluirmos em uma versão estável.

## Mais uma coisa: apresentando o Google AI Dart SDK {:#one-more-thing-introducing-the-google-ai-dart-sdk}

O Google lançou o Google AI Dart SDK em beta. Você pode criar recursos de IA generativa no seu app Dart ou Flutter. Esses apps usam o Gemini, a mais recente família de modelos de IA do Google. Dê uma olhada no [package:google_generative_ai](https://pub.dev/packages/google_generative_ai). Aprenda a criar com o Google AI Dart SDK [neste post do blog]({{site.flutter-blog}}/harness-the-gemini-api-in-your-dart-and-flutter-apps) ou vá direto para o [quickstart](https://ai.google.dev/tutorials/dart_quickstart).

<DashImage src="images/00DiCLVhk_ipZIHKd.webp" alt="Build with Gemini wordmark on a black background." />
