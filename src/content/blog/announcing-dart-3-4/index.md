---
ia-translate: true
title: "Anunciando o Dart 3.4"
description: "O Dart 3.4 saiu hoje! Esta versão mostra o trabalho conjunto do Dart e do Flutter no post Flutter 3.22 / Dart 3.4 / IO24, então…"
publishDate: 2024-05-14
author: mit-mit
image: images/0hAcsCFLU0Ze7pej6.webp
category: releases
layout: blog
---


O Dart 3.4 saiu hoje! Esta versão mostra o trabalho conjunto do Dart e do Flutter no post [Flutter 3.22 / Dart 3.4 / IO24]({{site.flutter-blog}}/landing-flutter-3-22-and-dart-3-4-at-google-i-o-2024), então não deixe de conferir a história completa por lá. Este post apresenta nosso suporte a WebAssembly e depois detalha um dos principais itens do roadmap da linguagem Dart para este ano: as *macros.*

<DashImage src="images/0hAcsCFLU0Ze7pej6.webp" alt="Dart 3.4 release banner with the Dart logo and a bullseye icon." />


## Atualizações do WebAssembly {:#webassembly-updates}

Hoje, temos o prazer de anunciar que o suporte completo a WebAssembly (Wasm) está disponível para [apps web com Flutter](https://docs.flutter.dev/platform-integration/web/wasm) com a versão estável mais recente do Flutter 3.22!

Este é um investimento de vários anos entre Dart e Flutter. Se você acompanhou os desenvolvimentos, viu nossos avanços incrementais:

* Padronizar a proposta [WasmGC](https://developer.chrome.com/blog/wasmgc/),

* Adicionar um backend de compilador Dart totalmente novo para gerar código WasmGC, e

* [Revisar](https://dart.dev/interop/js-interop) nossas ofertas de interop com web e JavaScript para oferecer o melhor suporte ao Wasm.

Continuaremos investindo em WebAssembly. Nosso próximo esforço vai habilitar o suporte completo a Wasm em apps Dart puros, e concluir alguns recursos que ainda faltam (por exemplo, o carregamento adiado). As ferramentas de ponta a ponta para compilação Wasm em Dart ainda estão em desenvolvimento, mas você pode [experimentar a prévia](http://dart.dev/web/wasm) na versão estável agora, com alguns passos temporários. Mais adiante, também esperamos oferecer suporte a Wasm no Dart [fora de ambientes JS](https://github.com/dart-lang/sdk/issues/53884), como runtimes Wasm padrão como wasmtime e wasmer.

## Macros do Dart: elevando o nível de abstração do desenvolvimento {:#dart-macros-raising-the-development-abstraction-level}

Investimos muitos anos no design do sistema de macros do Dart. Para melhorar a experiência de desenvolvimento em Dart, as macros oferecem uma solução de metaprogramação, parecida com a geração de código. Essa solução é embutida na linguagem Dart para dar aos desenvolvedores o máximo em desempenho, eficiência e produtividade. Agora, estamos prontos para oferecer uma prévia dessa experiência!

Um ponto de dor antigo para desenvolvedores Dart tem sido o padrão trivial, mas tedioso, de serializar e desserializar dados JSON. Criar uma solução reutilizável e suficientemente poderosa é um desafio em Dart, já que a linguagem não oferece reflexão em tempo de execução, por motivos de desempenho. Como alternativa, temos contado com soluções de geração de código, como o [`JsonSerializable`](https://docs.flutter.dev/data-and-backend/serialization/json#serializing-json-using-code-generation-libraries). Elas dependem de ferramentas externas que rodam antes do próprio código, o que complica a experiência do desenvolvedor.

Hoje, estamos anunciando uma prévia de uma abordagem radicalmente nova para serialização e desserialização de JSON: a macro [`JsonCodable`](https://dart.dev/go/json-codable).

Uma macro é um tipo de código que gera *mais* código, ao introspeccionar *outro* código em tempo de compilação. Por exemplo, aqui está uma classe Dart `Vehicle` com a nova macro JsonCodable aplicada:

```dart
@JsonCodable()
class Vehicle {
  final String description;
  final int wheels;
  Vehicle(this.description, this.wheels);
}
void main() {
  final jsonString = Vehicle('bicycle', 2).toJson();
  print('Vehicle serialized: $jsonString');
}
```


Então, como funciona? De onde veio o método `toJson()` (e o construtor `fromJson()` que o acompanha)? Esta é uma implementação experimental do nosso novo sistema de macros, pensada para simplificar a experiência do desenvolvedor. Quando o compilador Dart encontra a anotação `@JsonCodable()`, ele imediatamente localiza a definição da macro JsonCodable em tempo real e começa a executá-la. Isso faz a macro:

1. Criar uma nova “[classe de augmentation](https://github.com/dart-lang/language/blob/main/working/augmentation-libraries/feature-specification.md)”, uma nova construção da linguagem que permite adicionar novas declarações a classes existentes.

1. Ler a definição da classe `Vehicle` feita pelo desenvolvedor, para determinar que ela tem dois campos, `description` e `wheels`.

1. Adicionar uma nova assinatura de método `toJson` à classe de augmentation.

1. Preencher o corpo do método `toJson` para tratar a serialização dos campos description e wheels.

Tudo isso acontece sem demora. A experiência integrada oferece suporte aos nossos fluxos de trabalho existentes, como o hot reload, como mostra este screencast:

<DashImage src="images/0aOAKYwKdjXURuZN9.webp" alt="Using the JsonCodable macro in Dart to auto-generate code completion for a toJson method." caption="Screencast showing the experience of using a macro: Initially no toJson code completion exists, but after adding [@JsonCodable](http://twitter.com/JsonCodable) to the class, the toJson code completion shows up immediately." />


## Metas de longo prazo para macros {:#long-term-macro-goals}

A meta final é permitir que a comunidade crie as próprias macros. Isso eleva o nível de abstração da programação em Dart. Pense em classes de dados, por exemplo: é o recurso de linguagem Dart com mais votos ([o mais votado](https://github.com/dart-lang/language/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc)). Consideramos adicionar suporte nativo a classes de dados no Dart, mas percebemos que as opiniões variavam muito sobre o que essa construção deveria suportar para que nós mesmos definíssemos um padrão. Os campos devem ser `immutable`? Deve suportar equals? E `hashCode`? Talvez `toString` também? Concluímos que suportar um sistema de macros seria a melhor abordagem. A comunidade pode criar os próprios tipos de abstração, permitindo experimentação e variedade mais escaláveis.

Projetar e implementar um sistema de macros tão poderoso é uma empreitada substancial. Estamos determinados a fazer isso de um jeito que não tenha impacto negativo no desempenho dos casos de uso centrais do Dart, como assistência de código e completions, análise de código e hot reload. Com isso em mente, estamos adotando uma abordagem em etapas:

* Nesta versão, estamos oferecendo uma prévia de uma única macro, `JsonCodable`, para que os usuários comecem a se familiarizar com a experiência de desenvolvimento usando uma macro.

* Se a implantação dessa macro correr bem, esperamos tornar a macro de JSON estável em uma versão futura.

* Simultaneamente, estamos trabalhando para concluir o design e a implementação do sistema de macros subjacente. Quando tivermos confiança em seu desempenho e estabilidade, o objetivo final será permitir que a comunidade de desenvolvedores Dart defina as próprias macros.

Muito trabalho ainda resta para concluir essas etapas. Enquanto isso, você pode ler a documentação para saber mais sobre [o sistema de macros do Dart](https://dart.dev/go/macros) e experimentar hoje uma prévia da [macro JsonCodable](https://dart.dev/go/json-codable).

## Outras melhorias {:#other-improvements}

Como sempre, esta versão contém todos os desenvolvimentos contínuos que tornam o Dart a melhor versão possível. Nesta versão, fizemos as seguintes melhorias:

* Resolvemos mais de 50% dos bugs de completion do analyzer. (Continuem reportando [issues](https://github.com/dart-lang/sdk/labels/analyzer-completion-correctness)!)

* Melhoramos o alinhamento da análise de tipos de expressões condicionais, expressões if-null e expressões switch com a especificação da linguagem ([changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#language-1)).

* Removemos ferramentas incompletas e inconsistentes da biblioteca dart:cli para reduzir a dívida técnica na VM do Dart.

* Resolvemos algumas inadequações para melhorar a nova biblioteca *`*dart:js_interop`.

Confira o [Changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#340) para a história completa! E não deixe de ler o post conjunto do [Dart e do Flutter]({{site.flutter-blog}}/landing-flutter-3-22-and-dart-3-4-at-google-i-o-2024) sobre esta versão, para conhecer a história completa do nosso trabalho conjunto!
