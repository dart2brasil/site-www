---
ia-translate: true
title: "Anunciando o Dart 2.12"
description: "Sound null safety e Dart FFI chegam ao canal stable."
publishDate: 2021-03-03
author: mit-mit
image: images/0Inj4APQIAA4gVCxK.webp
category: releases
layout: blog
---


Hoje anunciamos o Dart 2.12, com versões stable do [sound null safety](https://dart.dev/null-safety) e do [Dart FFI](https://dart.dev/guides/libraries/c-interop). Null safety é a nossa mais recente funcionalidade de produtividade, criada para ajudar você a evitar erros de null, uma classe de bugs que costuma ser difícil de identificar, como explicado na [introdução em vídeo](https://www.youtube.com/watch?v=iYhOU9AuaFs&feature=emb_logo). FFI é um mecanismo de interoperabilidade que permite invocar código existente escrito na linguagem C, como chamar as [APIs Win32](https://pub.dev/packages/win32) do Windows. O Dart 2.12 já está disponível.

<DashImage src="images/0Inj4APQIAA4gVCxK.webp" alt="Dart 2.12 release banner highlighting sound null safety and Dart FFI." />


## As capacidades exclusivas da plataforma Dart {:#the-dart-platforms-unique-capabilities}

Antes de olharmos em detalhes para o sound null safety e para o FFI, vamos discutir como eles se encaixam nos nossos objetivos com a plataforma Dart. Linguagens de programação tendem a compartilhar muitas capacidades. Por exemplo, muitas linguagens suportam programação orientada a objetos ou execução na web. O que realmente diferencia as linguagens é a combinação única de capacidades que cada uma oferece.

<DashImage src="images/0msUXfhSNTNzP4wkf.webp" alt="A graphic showing three key pillars of the Dart platform: Portable, Productive, and Robust." />


As capacidades exclusivas do Dart se distribuem em três dimensões:

* **Portável**: compiladores eficientes geram código de máquina x86 e ARM para dispositivos, além de JavaScript otimizado para a web. Um [amplo conjunto de alvos](https://dart.dev/overview#platform) é suportado: dispositivos móveis, computadores desktop, backends de aplicações e mais. Um extenso conjunto de bibliotecas e pacotes oferece APIs consistentes que funcionam em todas as plataformas, reduzindo ainda mais o custo de criar aplicações multiplataforma de verdade.

* **Produtivo**: a plataforma Dart suporta hot reload, o que permite um desenvolvimento rápido e iterativo tanto para dispositivos nativos quanto para a web. E o Dart oferece construções ricas, como isolates e async/await, para lidar com padrões comuns de concorrência e de aplicações orientadas a eventos.

* **Robusto**: o sistema de tipos sólido e null-safe do Dart captura erros durante o desenvolvimento. E a plataforma como um todo é altamente escalável e confiável, com uso em produção por mais de uma década por uma grande variedade de aplicações, incluindo apps críticos para o negócio, como Google Ads e Google Assistant.

O sound null safety torna o sistema de tipos ainda mais robusto e permite um desempenho melhor. O Dart FFI permite usar bibliotecas C existentes para ganhar portabilidade, e dá a opção de usar código C altamente ajustado em tarefas críticas de desempenho.

## Sound null safety {:#sound-null-safety}

O sound null safety é a maior adição à linguagem Dart desde a introdução do sistema de tipos sólido no [Dart 2.0](/blog/announcing-dart-2-optimized-for-client-side-development). O null safety reforça ainda mais o sistema de tipos, permitindo que você capture erros de null, que são uma causa comum de travamentos em aplicações. Ao ativar o null safety, você consegue identificar erros de null durante o desenvolvimento, evitando travamentos em produção.

O sound null safety foi projetado em torno de [alguns princípios fundamentais](https://dart.dev/null-safety#null-safety-principles). Vamos revisitar como esses princípios impactam você como desenvolvedor.

## Não nulo por padrão: uma mudança fundamental no sistema de tipos {:#non-nullable-by-default-a-fundamental-change-to-the-type-system}

O grande desafio antes do null safety era que não dava para diferenciar o código que esperava receber null do código que não funcionava com nulls. Há alguns meses encontramos um bug no canal master do Flutter em que vários comandos da ferramenta do Flutter travavam, em certas configurações de máquina, com um erro de null: `The method '&gt;=' was called on null`. O problema estava em código como este:

```
final int major = version?.major;
final int minor = version?.minor;
if (globals.platform.isMacOS) {
  // plugin path of Android Studio changed after version 4.1.
  if (major >= 4 && minor >= 1) {
  ...
```


Consegue encontrar o erro? Como `version` pode ser null, `major` e `minor` também podem ser null. Esse bug pode parecer fácil de notar isoladamente, mas, na prática, código assim escapa o tempo todo, mesmo com um processo de revisão de código rigoroso como o usado no repositório do Flutter. Com o null safety, a análise estática identifica esse problema imediatamente. ([Experimente ao vivo no DartPad](https://dartpad.dev/0e9797be7488d8ec6c3fca92b7f2740f?null_safety=true).)

<DashImage src="images/0jl-o2KmcMjj777Iu.webp" alt="IDE analysis output for Dart null safety issues." caption="Screenshot of analysis output in an IDE" />


Esse foi um erro bem simples. Durante o nosso uso inicial do null safety em código interno no Google, vimos erros bem mais intrincados sendo capturados. Alguns deles eram bugs conhecidos havia anos, mas as equipes não tinham conseguido encontrar a causa sem as verificações estáticas adicionais do null safety. Veja alguns exemplos:

* Uma equipe interna descobriu que frequentemente verificava valores null de expressões que nunca poderiam ser null. Esse problema era visto com mais frequência em código que usa [protobuf](https://developers.google.com/protocol-buffers), em que campos opcionais retornam um valor padrão quando não são definidos, e nunca null. Como resultado, o código verificava incorretamente a condição padrão, confundindo valores padrão com valores null.

* A equipe do Google Pay encontrou bugs no código Flutter deles em que a aplicação falhava ao tentar acessar objetos `State` do Flutter fora do contexto de um `Widget`. Antes do null safety, esses objetos retornavam null e mascaravam o erro; com o null safety, a análise sólida determinou que essas propriedades nunca poderiam ser null e acusou um erro de análise.

* A equipe do Flutter encontrou um bug em que o engine do Flutter podia travar se `null` fosse passado ao parâmetro `scene` em `Window.render()`. Durante a migração para o null safety, eles adicionaram uma dica para [marcar Scene como não nulo](https://github.com/cbracken/engine/blob/bad869e229a8a02cad6e63d12e80807b33b5c12f/lib/ui/window.dart#L1069) e, então, conseguiram evitar facilmente possíveis travamentos de aplicações que o null teria causado.

## Trabalhando com o padrão não nulo {:#working-with-non-nullable-by-default}

Depois de [ativar o null safety](https://dart.dev/null-safety#enable-null-safety), o básico das declarações de variáveis muda, porque os tipos padrão são não nulos:

```
// In null-safe Dart, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```


Se você quiser criar uma variável que possa conter um valor ou null, precisa deixar isso explícito na declaração, adicionando o sufixo `?` ao tipo:

```
// aNullableInt can hold either an integer or null.
int? aNullableInt = null;
```


A implementação do null safety é robusta, com uma análise de fluxo estática rica que facilita o trabalho com tipos anuláveis. Por exemplo, depois de verificar se há null, o Dart promove o tipo de uma variável local de anulável para não nulo:

```
int definitelyInt(int? aNullableInt) {
  if (aNullableInt == null) {
    return 0;
  }
  // aNullableInt has now promoted to a non-null int.
  return aNullableInt; 
}
```


Também adicionamos uma nova keyword, `required`. Quando um parâmetro nomeado é marcado como `required` (o que acontece bastante nas APIs de widgets do Flutter) e quem chama esquece de passar o argumento, ocorre um erro de análise:

<DashImage src="images/0U_WEQJAarjskU1k2.webp" alt="DartPad analysis error for a missing required parameter." />


## Migração incremental para o null safety {:#incremental-migration-to-null-safety}

Como o null safety é uma mudança tão fundamental no nosso sistema de tipos, seria extremamente disruptivo exigir a adoção forçada. Para que *você* decida quando é o momento certo, o null safety é um recurso opt-in: você pode usar o Dart 2.12 sem ser obrigado a ativar o null safety. Você pode até depender de pacotes que já ativaram o null safety, independentemente de a sua aplicação ou pacote ter ativado ou não.

Para ajudar você a migrar o código existente para o null safety, oferecemos uma ferramenta de migração e um [guia de migração](https://dart.dev/null-safety/migration-guide). A ferramenta começa analisando todo o seu código existente. Depois, você pode revisar de forma interativa as propriedades de nulabilidade que a ferramenta inferiu. Se você discordar de alguma conclusão da ferramenta, pode adicionar dicas de nulabilidade para mudar a inferência. Algumas dicas de migração fazem uma enorme diferença na qualidade da migração.

<DashImage src="images/0srLwqVUDeF49J_B9.webp" alt="Interactive dart migrate tool showing proposed null safety changes." />


Por enquanto, pacotes e aplicações novos criados com [`dart create`](https://dart.dev/tools/dart-tool) e [`flutter create`](https://flutter.dev/docs/reference/flutter-cli) não ativam o sound null safety. Esperamos mudar isso em uma versão stable futura, quando virmos que a maior parte do ecossistema migrou. Você pode [ativar o null safety](https://dart.dev/null-safety#create) facilmente em um pacote ou aplicação recém-criados usando `dart migrate`.

## Status da migração do ecossistema Dart para o null safety {:#status-of-null-safety-migration-of-the-dart-ecosystem}

Ao longo do último ano, oferecemos várias versões preview e beta do sound null safety, com o objetivo de preparar o ecossistema com pacotes que suportam null safety. Essa preparação é importante, porque recomendamos [migrar para o sound null safety em ordem](https://dart.dev/null-safety/migration-guide#step1-wait): você não deve migrar um pacote ou aplicação antes que todas as suas dependências já tenham migrado.

Publicamos versões null-safe de centenas de pacotes oferecidos pelas equipes [Dart](https://pub.dev/packages?q=publisher%3Adart.dev&sort=popularity&null-safe=1), [Flutter](https://pub.dev/packages?q=publisher%3Aflutter.dev&sort=popularity&null-safe=1), [Firebase](https://pub.dev/packages?q=publisher%3Afirebase.google.com&sort=popularity&null-safe=1) e [Material](https://pub.dev/packages?q=publisher%3Amaterial.io&sort=popularity&null-safe=1). E vimos um ótimo apoio dos incríveis ecossistemas Dart e Flutter, de modo que o pub.dev agora tem mais de mil pacotes que suportam null safety. O mais importante é que os pacotes mais populares migraram primeiro: 98% dos 100 pacotes mais populares, 78% dos 250 primeiros e 57% dos 500 primeiros já suportam null safety a tempo do lançamento de hoje. Esperamos ver ainda mais pacotes com null safety no pub.dev nas próximas semanas. [Nossa análise](https://github.com/dart-lang/sdk/wiki/Null-safety-migration-status) mostra que a grande maioria dos pacotes do pub.dev já está desbloqueada e pode [começar a migração](https://dart.dev/null-safety/migration-guide).

## Os benefícios do sound null safety completo {:#the-benefits-of-fully-sound-null-safety}

Depois de migrar por completo, o null safety do Dart é sólido. Isso significa que o Dart tem 100% de certeza de que expressões com tipo não nulo não podem ser null. Quando o Dart analisa seu código e determina que uma variável é não nula, essa variável é *sempre* não nula. O Dart compartilha o sound null safety com o Swift, mas poucas outras linguagens de programação têm isso.

A solidez do null safety do Dart tem outra consequência bem-vinda: significa que seus programas podem ser menores e mais rápidos. Como o Dart tem certeza de que variáveis não nulas nunca são null, [o Dart consegue otimizar](/blog/dart-and-the-performance-benefits-of-sound-types). Por exemplo, o compilador AOT (ahead-of-time) do Dart pode produzir código nativo menor e mais rápido, porque não precisa adicionar verificações de null quando sabe que uma variável não é null.

## Dart FFI para integrar o Dart com bibliotecas C {:#dart-ffi-for-integrating-dart-with-c-libraries}

O Dart FFI permite aproveitar código existente em bibliotecas C, tanto para ganhar portabilidade quanto para integrar com código C altamente ajustado em tarefas críticas de desempenho. A partir do Dart 2.12, o [Dart FFI](https://dart.dev/guides/libraries/c-interop) saiu da fase *beta* e agora é considerado stable e pronto para uso em produção. Também adicionamos alguns novos recursos, incluindo structs aninhadas e passagem de structs por valor.

## Passando structs por valor {:#passing-structs-by-value}

Structs podem ser passadas tanto por referência quanto por valor no código C. O FFI suportava apenas a passagem por referência, mas a partir do Dart 2.12 você pode passar structs por valor. Aqui está um pequeno exemplo de duas funções C que passam structs por referência e por valor:

```
struct Link {
  double value;
  Link* next;
};

void MoveByReference(Link* link) {
  link->value = link->value + 10.0;
}

Coord MoveByValue(Link link) {
  link.value = link.value + 10.0;
  return link;
}
```


## Structs aninhadas {:#nested-structs}

APIs em C frequentemente usam structs aninhadas, ou seja, structs que contêm outras structs, como neste exemplo:

```
struct Wheel {
  int spokes;
};

struct Bike {
  struct Wheel front;
  struct Wheel rear;
  int buildYear;
};
```


A partir do Dart 2.12, structs aninhadas são suportadas no FFI.

## Mudanças na API {:#api-changes}

Como parte da declaração do FFI como stable, e para dar suporte aos recursos acima, fizemos algumas pequenas mudanças na API.

Criar structs vazias agora não é permitido (mudança incompatível [#44622](https://github.com/dart-lang/sdk/issues/44622)) e produz um aviso de depreciação. Você pode usar um novo tipo, `Opaque`, para representar structs vazias. As funções de `dart:ffi` `sizeOf`, `elementAt` e `ref` agora exigem argumentos de tipo em tempo de compilação (mudança incompatível [#44621](https://github.com/dart-lang/sdk/issues/44621)). Como novas funções de conveniência foram adicionadas ao `package:ffi`, não é necessário nenhum código repetitivo extra para alocar e liberar memória nos casos comuns:

```
// Allocate a pointer to an Utf8 array, fill it from a Dart string,
// pass it to a C function, convert the result, and free the arg.
//
// Before API change:
final pointer = allocate<Int8>(count: 10);
free(pointer);
final arg = Utf8.toUtf8('Michael');
var result = helloWorldInC(arg);
print(Utf8.fromUtf8(result);
free(arg);

// After API change:
final pointer = calloc<Int8>(10);
calloc.free(pointer);
final arg = 'Michael'.toNativeUtf8();
var result = helloWorldInC(arg);
print(result.toDartString);
calloc.free(arg);
```


## Gerando bindings de FFI automaticamente {:#automatically-generating-ffi-bindings}

Para APIs grandes, escrever os bindings em Dart que integram com o código C pode consumir muito tempo. Para reduzir esse trabalho, criamos um gerador de bindings que cria automaticamente wrappers de FFI a partir de arquivos de cabeçalho C. Convidamos você a experimentar: [`package:ffigen`](https://pub.dev/packages/ffigen).

## Roadmap do FFI {:#ffi-roadmap}

Com a plataforma principal do FFI concluída, estamos voltando o foco para ampliar o conjunto de recursos do FFI com funcionalidades que se apoiam na plataforma principal. Algumas das funcionalidades que estamos investigando incluem:

* Tipos de dados específicos de ABI, como int, long, size_t ([#36140](https://github.com/dart-lang/sdk/issues/36140))

* Arrays inline em structs ([#35763](https://github.com/dart-lang/sdk/issues/35763))

* Structs empacotadas ([#38158](https://github.com/dart-lang/sdk/issues/38158))

* Tipos union ([#38491](https://github.com/dart-lang/sdk/issues/38491))

* Expor finalizers para o Dart ([#35770](https://github.com/dart-lang/sdk/issues/35770); porém, observe que você já pode [usar finalizers a partir do C](https://github.com/dart-lang/sdk/issues/35770))

## Exemplos de uso do FFI {:#sample-uses-of-ffi}

Vimos muitos usos criativos do Dart FFI para integrar com uma variedade de APIs baseadas em C. Aqui estão alguns exemplos:

* [open_file](https://pub.dev/packages/open_file) é uma API única para abrir arquivos em várias plataformas. Ela usa FFI para invocar APIs nativas do sistema operacional no Windows, macOS e Linux.

* [win32](https://pub.dev/packages/win32) encapsula a maioria das APIs Win32 comuns, tornando possível chamar diretamente do Dart uma ampla gama de APIs do Windows.

* [objectbox](https://pub.dev/packages/objectbox) é um banco de dados rápido baseado em uma implementação em C.

* [tflite_flutter](https://pub.dev/packages/tflite_flutter) usa FFI para encapsular a API do TensorFlow Lite.

## O que vem a seguir para a linguagem Dart? {:#whats-next-for-the-dart-language}

O sound null safety é a maior mudança que fizemos na linguagem Dart em vários anos. A seguir, vamos buscar mudanças mais incrementais na linguagem e na plataforma, construindo sobre a nossa base sólida. Aqui está uma visão rápida de algumas coisas com que estamos experimentando no nosso [funil de design da linguagem](https://github.com/dart-lang/language/projects/1):

**Type aliases** ([#65](https://github.com/dart-lang/language/issues/65)): a capacidade de criar aliases de tipos para tipos que não são funções. Por exemplo, você poderia criar um typedef e usá-lo como tipo de variável:

```
typedef IntList = List<int>;
IntList il = [1,2,3];
```


**Operador de triplo deslocamento** ([#120](https://github.com/dart-lang/language/issues/120)): adicionar um novo operador `&gt;&gt;&gt;`, totalmente sobrescrevível, para fazer deslocamento de bits sem sinal em inteiros.

**Anotações de metadados genéricas** ([#1297](https://github.com/dart-lang/language/issues/1297)): estender as anotações de metadados para também suportar anotações que contenham argumentos de tipo.

**Meta-programação estática** ([#1482](https://github.com/dart-lang/language/issues/1482)): suporte a meta-programação estática, programas Dart que produzem novo código-fonte Dart durante a compilação, de forma semelhante às [macros](https://doc.rust-lang.org/book/ch19-06-macros.html) do Rust e aos [function builders](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md) do Swift. Este recurso ainda está em uma fase inicial de exploração, mas achamos que ele pode habilitar casos de uso que hoje dependem de geração de código.

## O Dart 2.12 já está disponível {:#dart-2-12-is-available-now}

O Dart 2.12, com sound null safety e FFI stable, já está disponível nos SDKs [Dart 2.12](https://dart.dev/get-dart) e [Flutter 2.0](https://flutter.dev/docs/get-started/). Reserve um momento para revisar os problemas conhecidos de null safety [do Dart](https://dart.dev/null-safety#known-issues) e [do Flutter](https://flutter.dev/docs/null-safety#known-issues). Se encontrar outros problemas, reporte-os no [issue tracker do Dart](https://github.com/dart-lang/sdk/issues).

Se você desenvolveu pacotes publicados no [pub.dev](https://pub.dev), revise hoje o [guia de migração](https://dart.dev/null-safety/migration-guide) e aprenda a migrar para o sound null safety. Migrar o seu pacote provavelmente ajudará a desbloquear outros pacotes e aplicações que dependem dele. Também gostaríamos de agradecer muito a quem já migrou!

Adoraríamos saber sobre a sua experiência com o sound null safety e com o FFI. Deixe um comentário abaixo ou nos mande um tweet para [@dart_lang](https://twitter.com/dart_lang).
