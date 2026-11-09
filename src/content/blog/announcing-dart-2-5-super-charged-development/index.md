---
ia-translate: true
title: "Anunciando o Dart 2.5: desenvolvimento turbinado"
description: "Hoje anunciamos o lançamento stable do SDK do Dart 2.5, que inclui previews técnicos de dois grandes novos recursos para desenvolvedores: ML…"
publishDate: 2019-09-10
author: mit-mit
image: images/0EzNuk5GmPG3-yjT4.webp
category: releases
layout: blog
---


Hoje anunciamos o lançamento stable do SDK do Dart 2.5, que inclui previews técnicos de dois grandes novos recursos para desenvolvedores: *ML Complete*, de completar código com machine learning (ML), e a interface de função estrangeira `dart:ffi`, para chamar código C diretamente a partir do Dart. O Dart 2.5 também traz suporte melhorado a [expressões constantes](https://dart.dev/guides/language/language-tour#final-and-const).

Esta versão é mais um passo rumo à nossa visão de ser a melhor linguagem otimizada para o cliente, para criar aplicações rápidas em qualquer plataforma. O ML Complete é uma adição poderosa ao nosso conjunto existente de ferramentas de produtividade, como o [hot reload](https://flutter.dev/docs/development/tools/hot-reload), a [análise estática personalizável](https://dart.dev/guides/language/analysis-options) e o [Dart DevTools](https://flutter.dev/docs/development/tools/devtools/overview). O segundo recurso em preview, o `dart:ffi`, permite aproveitar as APIs nativas existentes nos muitos sistemas operacionais em que o código Dart roda, além de bibliotecas nativas multiplataforma escritas em C.

Falando na nossa ambição de criar a melhor linguagem otimizada para o cliente, foi ótimo ver os novos rankings de 2019 da [IEEE Spectrum sobre linguagens de programação](https://spectrum.ieee.org/computing/software/the-top-programming-languages-2019) saírem na semana passada, com o Dart incluído. O Dart entra nos rankings de linguagens da IEEE Spectrum em #16. Também ficou em #10 em tendências e em #6 ao filtrar linguagens para mobile (atrás de Java, C, C++, C# e Swift).

<DashImage src="images/0EzNuk5GmPG3-yjT4.webp" alt="Dart ranks #16 in IEEE Spectrum's top programming languages for 2019." />


## Preview: ML Complete, sugestões de código ranqueadas por machine learning {:#preview-ml-complete-code-completions-ranked-by-machine-learning}

Uma das principais vantagens das linguagens tipadas é que as informações adicionais capturadas nos tipos permitem que o IDE/editor ajude o desenvolvedor oferecendo sugestões enquanto ele digita o código. Com as sugestões de código, os desenvolvedores conseguem tanto evitar erros de digitação quanto explorar APIs, digitando o início do símbolo esperado e escolhendo entre as sugestões oferecidas.

À medida que as APIs crescem, a exploração fica difícil, porque a lista de possíveis sugestões fica longa demais para navegar em ordem alfabética. Nos últimos anos, trabalhamos duro para aplicar machine learning a esse problema. Em termos simples, isso funciona treinando um modelo de ocorrências prováveis de membros com base em um contexto, analisando um [grande corpus de código Dart de código aberto no GitHub](https://console.cloud.google.com/marketplace/details/github/github-repos). Esse modelo, baseado no [TensorFlow Lite](https://www.tensorflow.org/lite), pode então ser usado para prever o próximo símbolo provável enquanto o desenvolvedor edita o código. Estamos chamando esse novo recurso de *ML Complete*. Aqui está um exemplo de desenvolvimento de um novo widget `MyHome` usando o framework [Flutter](https://flutter.dev):

<DashImage src="images/0a3q1D4T6uoftk8SJ.webp" alt="A developer creates a Flutter widget using ML Complete." caption="Sample developer experience creating a Flutter widget using ML Complete" />


Vamos olhar mais de perto como isso funciona. Imagine que você está escrevendo um pequeno programa para calcular o horário que fica um dia à frente do horário atual. Usando o ML Complete, você tem a experiência à esquerda, abaixo. Primeiro, observe como ele consegue oferecer uma sugestão de `DateTime.now()` com base na variável chamada now. Depois, observe que temos uma sugestão para o nome da variável tomorrow e, por fim, `add(…)` é a segunda sugestão oferecida para now. Na experiência sem o ML Complete, à direita, precisamos digitar `DateTime` manualmente, não recebemos nenhuma sugestão para o nome da variável `tomorrow`, e o método `add(…)` fica bem mais para baixo na lista.

<DashImage src="images/1rA4mVfedEzJCN_ayVymm1A.webp" alt="A developer calculates the time one day from the current time using ML Complete." />


<DashImage src="images/1cmHliNwHDwjNV-fdMScWMA.webp" alt="Code completion experience with ML Complete on the left and without on the right." caption="Code completion experience with ML Complete (left) and without (right)" />


## Como experimentar o ML Complete {:#how-to-try-out-ml-complete}

O ML Complete é lançado hoje em preview. Ele é incorporado diretamente ao analisador do Dart, então está disponível em todos os editores com suporte a Dart, incluindo Android Studio, IntelliJ e VS Code. Veja [esta página do wiki](https://github.com/dart-lang/sdk/wiki/Previewing-Dart-code-completions-powered-by-machine-learning) para detalhes sobre como aderir a este recurso em preview, e para saber como enviar feedback e relatar problemas.

Como o recurso ainda está em preview, a versão atual dos SDKs stable do Flutter e do Dart não inclui o trabalho de desempenho e acabamento que esperamos ter nas builds posteriores. Por isso, recomendamos que você use temporariamente o [canal dev](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) do Flutter ou um [canal dev](https://dart.dev/tools/sdk/archive#dev-channel) do Dart ao testar este recurso.

## Preview: interface de função estrangeira `dart:ffi` para interoperabilidade entre Dart e C {:#preview-dart-ffi-foreign-function-interface-for-dart-c-interop}

Muitos desenvolvedores nos pediram um suporte melhor para chamar código C a partir do Dart. Um sinal bem claro disso está no issue tracker do Flutter, onde a interoperabilidade com C é a [solicitação de recurso aberta mais bem avaliada](https://github.com/flutter/flutter/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc), com mais de 600 votos 👍. Há muitos casos de uso interessantes por trás desses pedidos, que vão desde chamar APIs de plataforma de baixo nível, como [stdlib.h](https://pubs.opengroup.org/onlinepubs/009695399/basedefs/stdlib.h.html) ou [Win32](https://en.wikipedia.org/wiki/Windows_API), até aproveitar bibliotecas e utilitários multiplataforma existentes escritos em C, como TensorFlow, Realm e SQLite.

Atualmente, o suporte a chamadas diretas de C a partir do Dart se limita a uma integração profunda com a VM do Dart, usando [extensões nativas](https://dart.dev/server/c-interop-native-extensions). Alternativamente, aplicações Flutter podem usar C indiretamente, chamando o host por meio de [platform channels](https://flutter.dev/docs/development/platform-integration/platform-channels) e, a partir daí, chamando o C; essa é uma dupla indireção indesejável. Nossa aspiração é oferecer um novo mecanismo que tenha ótimo desempenho, seja fácil de usar e funcione em todas as [plataformas e compiladores](https://dart.dev/platforms) do Dart suportados.

A interoperabilidade entre Dart e C habilita dois cenários principais:

* Chamar uma API de sistema baseada em C no sistema operacional (SO) hospedeiro

* Chamar uma biblioteca baseada em C, seja para um único SO ou multiplataforma

## Chamando APIs de sistema operacional baseadas em C {:#calling-c-based-operating-system-apis}

Vamos ver de forma concreta a primeira categoria. Vamos chamar o comando Linux [`system`](https://man.openbsd.org/system.3). Esse comando permite executar qualquer comando do sistema; o argumento que você passa a ele é basicamente repassado ao shell/terminal e executado ali. Aqui está o cabeçalho C desse comando:

```dart
// C header: int system(const char *command) in stdlib.h
```


O principal desafio de qualquer mecanismo de interoperabilidade é lidar com as diferenças de semântica entre duas linguagens. Para o `dart:ffi`, o código Dart precisa representar duas coisas:

1. A função C e os tipos de seus argumentos e de seu retorno

1. A função Dart correspondente e os seus tipos

Fazemos isso definindo dois typedefs:

```dart
// C header typedef:
typedef SystemC = ffi.Int32 Function(ffi.Pointer<Utf8> command);

// Dart header typedef:
typedef SystemDart = int Function(ffi.Pointer<Utf8> command);
```


Em seguida, precisamos carregar a biblioteca e procurar a função que vamos chamar. Como fazer isso depende do sistema operacional; neste exemplo, usamos o macOS. (Temos [exemplos completos](https://github.com/dart-lang/samples/tree/master/ffi/system-command) para macOS, Windows e Linux.)

```dart
// Load `stdlib`. On MacOS this is in libSystem.dylib.
final dylib = ffi.DynamicLibrary.open('/usr/lib/libSystem.dylib');

// Look up the system function.
final systemP = dylib.lookupFunction<SystemC, SystemDart>('system');
```


Depois, codificamos o argumento string usando a codificação relevante para o sistema operacional em questão, invocamos a função e liberamos novamente a memória do argumento:

```dart
// Allocate a pointer to a Utf8 array containing our command.
final cmdP = Utf8.toUtf8('open http://dart.dev');

// Invoke the command.
systemP(cmdP);

// Free the pointer.
cmdP.free();
```


Esse código executa o comando do sistema, fazendo com que o navegador padrão do sistema abra o dart.dev:

<DashImage src="images/0-S9fZutz89QcrwEw.webp" alt="A developer executes a system command via dart:ffi to open the default browser." caption="*Executing the system command via dart:ffi to open the default browser*" />


## Chamando frameworks e componentes baseados em C {:#calling-c-based-frameworks-and-components}

Um segundo uso central do `dart:ffi` é invocar frameworks e componentes baseados em C. A completação de código baseada em ML discutida no início deste post é um exemplo concreto disso! Ela usa o [TensorFlow Lite](https://www.tensorflow.org/lite), que é uma [API baseada em C](https://www.tensorflow.org/lite/api_docs/cc). Usar o `dart:ffi` nos permite rodar o TensorFlow em todos os sistemas operacionais onde precisamos oferecer sugestões de código, com o alto desempenho da implementação nativa do TensorFlow. Se você quiser dar uma olhada no código da integração do TensorFlow com Dart, veja [este repositório](https://github.com/dart-lang/tflite_native).

Também esperamos que a capacidade de chamar bibliotecas baseadas em C seja muito útil para aplicações Flutter. Você pode imaginar chamar bibliotecas nativas como [Realm](https://github.com/realm/realm-core) ou [SQLite](https://www.sqlite.org/c3ref/intro.html), e achamos que o `dart:ffi` será valioso para habilitar plugins para o [Flutter desktop](https://github.com/flutter/flutter/wiki/Desktop-shells).

## Encapsulando APIs e geração de código {:#wrapping-apis-and-code-generation}

Como você deve ter notado, há um pouco de trabalho de programação para descrever as funções e buscar seus símbolos. Grande parte desse código repetitivo poderia ser gerada a partir dos arquivos de cabeçalho C. Atualmente, estamos focados em fornecer as primitivas subjacentes, mas adoraríamos colaborar com quem tiver interesse em trabalhar em um gerador.

## Como experimentar o dart:ffi {:#how-to-try-dart-ffi}

A biblioteca `dart:ffi` é lançada hoje em preview. Como ela ainda está em preview, recomendamos que você use o [canal master](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) do Flutter ou um [canal dev](https://dart.dev/tools/sdk/archive#dev-channel) do Dart para ter acesso rápido às nossas mudanças e melhorias à medida que forem feitas. Observe que a API provavelmente terá mudanças incompatíveis até a sua conclusão, enquanto adicionamos acabamento e ampliamos o suporte a padrões comuns. Você pode ver em detalhes [o que já planejamos](https://github.com/dart-lang/sdk/projects/13) para a nossa primeira versão. Aqui estão algumas limitações que você deve conhecer:

* A biblioteca não suporta structs aninhadas, arrays inline, dados empacotados ou tipos primitivos dependentes da plataforma.

* O desempenho das operações com ponteiros é insuficiente (mas pode ser contornado usando [Pointer.asExternalTypedData](https://github.com/dart-lang/sdk/blob/master/sdk/lib/ffi/ffi.dart#L132)).

* A biblioteca não tem suporte a finalizers (callbacks invocados quando um objeto está prestes a ser coletado pelo garbage collector).

A [documentação de interoperabilidade com C](https://dart.dev/guides/libraries/c-interop) e a [referência da API `dart:ffi`](https://api.dart.dev/dev/) documentam os conceitos centrais e apontam para exemplos que você pode revisar. Se você tiver algum problema ou dúvida, convidamos você a postar no [grupo de discussão sobre Dart FFI](https://groups.google.com/forum/#!forum/dart-ffi) ou a [abrir uma issue](https://github.com/dart-lang/sdk/issues/new?labels=area-vm,library-ffi).

## Expressões constantes aprimoradas {:#improved-constant-expressions}

O Dart sempre suportou a criação de [variáveis e valores const](https://dart.dev/guides/language/language-tour#final-and-const); eles têm a garantia de serem constantes de tempo de compilação e, portanto, têm características de desempenho muito boas. Nas versões anteriores, as expressões constantes eram um pouco limitadas. A partir do Dart 2.5, suportamos muito mais formas de definir expressões constantes, incluindo a capacidade de usar casts e os novos recursos de controle de fluxo e de spread de coleções lançados no [Dart 2.3](/blog/announcing-dart-2-3-optimized-for-building-user-interfaces):

```dart
// Example: these are now valid compile-time constants.
const Object i = 3;
const list = [i as int];
const set = {if (list is List<int>) ...list};
const map = {if (i is int) i: "int"};
```


## Considerações finais {:#closing-thoughts}

Temos um próximo conjunto de trimestres empolgante pela frente, com trabalhos bem adiantados em [métodos de extensão](https://github.com/dart-lang/language/issues/41), na imposição de que referências sejam [não nulas](/blog/dart-nullability-syntax-decision-a-b-or-a-b), e algum planejamento inicial para [a linguagem além disso](https://github.com/dart-lang/language/projects/1). Também estamos investigando um suporte melhor à concorrência, por exemplo, a capacidade de aproveitar melhor os processadores multinúcleo dos celulares modernos.

Estamos especialmente entusiasmados com o não nulo por padrão. Definimos um [plano bastante ambicioso](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md) para esse recurso e temos [muito trabalho](https://github.com/dart-lang/language/issues?utf8=%E2%9C%93&q=is%3Aissue++label%3Annbd+) em andamento. Algumas linguagens mais recentes foram projetadas com suporte a não nulos desde o início, enquanto a maioria das linguagens existentes que adicionaram esse suporte em uma versão posterior se contentou com uma abordagem bastante limitada, restrita a análise estática adicional. Um dos principais diferenciais da nossa abordagem é que buscamos um suporte completo e [sólido a não nulos](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md#soundness). Em resumo, isso significa que a nossa compreensão de não nulidade vai se estender até o núcleo do sistema de tipos e, uma vez que o nosso sistema de tipos saiba que algo é não nulo, podemos confiar totalmente nessa informação, e o nosso compilador de back end fica livre para otimizar o código. Essa solidez traz grandes vantagens, tanto em oferecer uma experiência consistente de "sem exceções" quanto em tamanho de código e desempenho em tempo de execução.

Estamos sempre cientes do peso que mudanças na linguagem impõem ao nosso ecossistema. Por isso, também estamos [investindo bastante](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md#migration-path) em ferramentas de migração completas para o código existente. Esperamos que essas ferramentas compensem a maior parte do custo de migração. Também estamos adicionando alguns recursos dedicados de linguagem e de ferramentas que permitem a migração gradual, e vamos nos esforçar para migrar o nosso próprio código e o código compartilhado no [https://pub.dev](https://pub.dev).

Estamos ansiosos para compartilhar mais novidades ainda este ano!
