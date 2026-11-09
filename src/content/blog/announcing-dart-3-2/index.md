---
ia-translate: true
title: "Anunciando o Dart 3.2"
description: "Melhorias na linguagem e na experiência do desenvolvedor, e uma atualização sobre apps web e Wasm"
publishDate: 2023-11-15
author: mit-mit
image: images/1u5YRn1uMmXf94b2aPbcLRQ.webp
category: releases
layout: blog
---


Por: [Kevin Moore](https://twitter.com/kevmoo) & [Michael Thomsen](https://medium.com/@mit.mit)

Hoje anunciamos o Dart 3.2, com um novo recurso de linguagem para promoção não nula de campos privados final, melhorias na experiência do desenvolvedor com novas capacidades de interop, suporte a extensões no DevTools e uma atualização do nosso roadmap para a web, incluindo o suporte a Wasm (também conhecido como WebAssembly).

<DashImage src="images/1u5YRn1uMmXf94b2aPbcLRQ.webp" alt="Dart 3.2 release banner highlighting language updates, developer experience, and the web roadmap." />


## Promoção não nula para campos final privados {:#non-null-promotion-for-private-final-fields}

Faz alguns anos que introduzimos o [null safety sólido](/blog/announcing-dart-2-12) no Dart 2.12. Com o null safety, você pode declarar quais tipos são anuláveis (podem conter um valor ou `null`) e quais são não anuláveis (sempre contêm um valor). O null safety combinado com a [análise de fluxo](https://dart.dev/null-safety/understanding-null-safety#flow-analysis) detecta quando variáveis anuláveis podem ser “promovidas” aos seus tipos não nulos, mais seguros:

```dart
int definitelyInt(int? aNullableInt) {
  if (aNullableInt == null) {
    return 0;
  }
  // If flow analysis reaches this point, 
  // aNullableInt can safely promote to a non-null int.
  return aNullableInt; 
}
```


A promoção de tipos é parte central do null safety desde o Dart 2.12, mas era limitada a variáveis locais. Campos ou variáveis de nível superior não podiam ser promovidos, como neste caso:

```dart
class Container {
  final int? _fillLevel;
  Container(this._fillLevel);
  check() {
    if (_fillLevel != null) {
      int i = _fillLevel; // Prior to Dart 3.2, causes an error.
    }
  }
}
```


Essa limitação se devia a vários casos complexos em que a análise de fluxo não conseguia determinar com segurança quando ou como um campo poderia mudar. No caso da promoção de campos em uma classe, por exemplo, poderia haver um problema se uma subclasse sobrescrevesse um campo com um getter, que às vezes retorna null.

No Dart 3.2, melhoramos nosso mecanismo de análise de fluxo e agora conseguimos promover **campos privados final**. Assim, o trecho de código acima passa sem erros. Isso se baseia na compreensão de que, para um campo privado e final, o valor nunca muda após a atribuição inicial, então verificá-lo uma única vez é considerado seguro. A promoção de campos privados final está disponível a partir do Dart 3.2 e será aplicada a projetos cujo [limite inferior](https://dart.dev/language/versioning) do SDK do Dart seja 3.2 ou superior.

## Novas opções de análise de código no package:lints 3.0 {:#new-code-analysis-options-in-package-lints-3-0}

Já que falamos de análise de código, também fizemos várias melhorias nas nossas regras padrão de análise de código no [package:lints](https://pub.dev/packages/lints). Esse pacote contém o conjunto padrão e recomendado de regras de análise estática que vem com todo projeto novo criado com `dart create` ou `flutter create` (via [package:flutter_lints](https://pub.dev/packages/flutter_lints), uma extensão do package:lints).

Uma nova versão major desse conjunto de lints, a 3.0, já está disponível. Essa revisão adicionou seis lints ao conjunto core e dois ao conjunto recomendado. Ela traz lints para validar URLs de pubspec, para verificar se métodos de coleção são invocados com os argumentos corretos, e mais. Para a lista completa de mudanças, confira o [changelog](https://github.com/dart-lang/lints/blob/main/CHANGELOG.md#300). A versão 3.0 será o padrão para novos projetos na próxima versão. Para projetos existentes, você pode [atualizar agora](https://github.com/dart-lang/lints#upgrading-to-the-latest-lints).

## Atualização de interoperabilidade do Dart {:#dart-interoperability-update}

O suporte a múltiplas plataformas em uma [ampla gama de plataformas](https://dart.dev/overview#platform) sempre foi um princípio central do Dart. Mas, mesmo que uma linha de código Dart possa rodar sem alterações em todas essas plataformas, apps grandes ainda costumam precisar interoperar com código existente. Isso pode significar código de projetos antigos, ou APIs disponíveis em outras bibliotecas ou APIs do sistema. Fizemos vários investimentos nessa área, começando pelo FFI para [interop com APIs C nativas](https://dart.dev/guides/libraries/c-interop). Atualmente, estamos trabalhando para expandir isso e oferecer suporte à interop com [Java e Kotlin](https://dart.dev/guides/libraries/java-interop) e com [Objective C e Swift](https://dart.dev/guides/libraries/objective-c-interop). Para novidades empolgantes sobre a interop com JS, confira a seção de web do Dart mais adiante.

A partir do Dart 3.2, fizemos várias melhorias na interop nativa:

* Introduzimos o construtor [`NativeCallable.isolateLocal`](https://api.dart.dev/stable/dart-ffi/NativeCallable/NativeCallable.isolateLocal.html) para C FFI, que cria um ponteiro de função C a partir de uma função Dart arbitrária. Isso estende a funcionalidade oferecida pelo [`Pointer.fromFunction`](https://api.dart.dev/stable/dart-ffi/Pointer/fromFunction.html), que só consegue criar ponteiros de função a partir de funções de nível superior.

* Atualizamos o gerador de bindings Objective-C para usar o [`NativeCallable.listener`](https://api.dart.dev/stable/dart-ffi/NativeCallable/NativeCallable.listener.html), que adicionamos no Dart 3.1. O gerador agora consegue lidar automaticamente com APIs que contêm callbacks assíncronos, como o [Core Motion](https://developer.apple.com/documentation/coremotion), por exemplo. Essas APIs antes exigiam escrever parte do código de binding manualmente.

* Continuamos melhorando o [package:jnigen](https://dart.dev/guides/libraries/java-interop) para interop com Java e Kotlin. Isso nos permitiu migrar o [package:cronet_http](https://pub.dev/packages/cronet_http), um wrapper para o cliente HTTP Cronet do Android, de bindings escritos à mão para um wrapper [gerado](https://github.com/dart-lang/http/blob/master/pkgs/cronet_http/jnigen.yaml) automaticamente.

* Fizemos progressos significativos na funcionalidade [Native Assets](https://github.com/dart-lang/sdk/issues/50565), que visa resolver uma série de problemas associados à distribuição de pacotes Dart que dependem de código nativo. Ela faz isso oferecendo hooks uniformes para integrar com os vários sistemas de build envolvidos na construção de apps Flutter e de aplicações Dart independentes. Para uma prévia, confira a [documentação](http://dart.dev/guides/libraries/c-interop#native-assets).

## Extensões do DevTools para pacotes Dart {:#devtools-extensions-for-dart-packages}

O [DevTools](https://dart.dev/tools/dart-devtools) do Dart é um conjunto de ferramentas de depuração e desempenho que dá suporte a apps Dart puros e a apps Flutter. No Dart 3.2 e no Flutter 3.16, [anunciamos](https://medium.com/p/c8bc1aaf8e5f/) um novo [framework de extensões](https://pub.dev/packages/devtools_extensions) que permite aos autores de pacotes criar ferramentas personalizadas para o seu pacote, exibidas diretamente no DevTools. Isso permite que pacotes do pub.dev que contêm frameworks ofereçam ferramentas personalizadas para os seus casos de uso específicos. Por exemplo, os autores do [Serverpod](https://pub.dev/packages/serverpod) têm trabalhado duro para criar ferramentas de desenvolvimento para o seu pacote e estão animados em lançar uma extensão do DevTools em sua próxima [versão 1.2](https://github.com/orgs/serverpod/projects/4).

<DashImage src="images/0N6ZSt1McXO_opQU7.webp" alt="A DevTools extension planned for the upcoming ServerPod 1.2 release." caption="*Uma extensão do DevTools planejada para a próxima versão 1.2 do ServerPod*" />


## Atualização do Dart na web e Wasm {:#dart-web-and-wasm-update}

Wasm (também conhecido como [WebAssembly](https://webassembly.org/)) é um novo e empolgante formato de instruções para navegadores web, que oferece um formato de código binário portátil e neutro em relação à plataforma para execução em navegadores modernos. Linguagens gerenciadas de alto nível, como o Dart, usam coleta de lixo, que está sendo adicionada ao padrão Wasm. A partir do Chrome 119, o [suporte a coleta de lixo para Wasm](https://developer.chrome.com/blog/wasmgc/) (conhecido como Wasm-GC) vem habilitado por padrão. O suporte a Wasm-GC também está chegando ao Firefox 120, na próxima versão estável deles. Então, qual é a situação do Dart, do Flutter e do Wasm-GC?

O compilador de Dart para Wasm está quase completo em termos de recursos. A equipe está muito satisfeita com o desempenho e a compatibilidade. Nosso foco agora está nos casos de borda, para garantir que a saída seja rápida em uma ampla gama de cenários.

Para o Flutter na web, concluímos um novo motor de renderização “Skwasm”. Para maximizar o desempenho, o Skwasm conecta o código da aplicação compilada diretamente a um [módulo CanvasKit Wasm](https://skia.org/docs/user/modules/canvaskit/) personalizado, com um binding wasm-para-wasm. Também é a primeira iteração de suporte à renderização multithread para o Flutter na web, o que melhora ainda mais os tempos de frame.

Ainda faltam algumas coisas antes que o Flutter web com Wasm esteja pronto para sair do status experimental atual:

* **Dual compile**: Gerar saídas tanto em Wasm quanto em JavaScript e habilitar a detecção de recursos em tempo de execução, para dar suporte a navegadores com e sem suporte a Wasm-GC.

* **Interoperabilidade moderna com JavaScript**: Um novo mecanismo de interop com JS baseado em [extension types](https://github.com/dart-lang/language/issues/2727) para permitir chamadas concisas e com segurança de tipos entre código Dart, APIs de navegador e bibliotecas JS, quando o alvo é JavaScript e Wasm.

* **APIs de navegador com suporte a Wasm**: Um novo package:web, que substitui o dart:html (e bibliotecas relacionadas), baseado no mecanismo moderno de interop com JS. Ele vai oferecer acesso fácil às APIs do navegador, com suporte tanto para o alvo JS quanto para o alvo Wasm.

Estamos começando a migrar vários projetos internos para o package:web e para o novo mecanismo de interop com JS, e esperamos ter mais novidades na próxima versão estável. Enquanto isso, você pode acompanhar os detalhes mais recentes na nossa página [Support for WebAssembly](https://flutter.dev/wasm).

## Encerramento {:#closing}

Isso é tudo por hoje. O Dart 3.2 já está disponível em [dart.dev](https://dart.dev/get-dart), ou como parte do lançamento de hoje do [Flutter 3.16]({{site.flutter-blog}}/whats-new-in-flutter-3-16). Até a próxima, divirta-se com o Dart!
