---
ia-translate: true
title: "Resultados do Google Summer of Code 2024"
description: "Resultados dos colaboradores do Dart no Google Summer of Code 2024."
publishDate: 2024-10-14
author: jonasfj
image: images/0vm7AfKyip_pXJGCd.webp
category: other
layout: blog
---


O programa [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) busca engajar novos desenvolvedores do mundo todo no desenvolvimento de software open source. O Google patrocina colaboradores para trabalhar, junto com uma organização open source que faz a mentoria, em um projeto de programação de 12 semanas durante o verão. Nos últimos 19 anos, mais de 20.000 colaboradores participaram do Google Summer of Code.

<DashImage src="images/0vm7AfKyip_pXJGCd.webp" alt="Os logos do Google Summer of Code e do Dart lado a lado." />


Em 2024, o Dart participou como organização mentora no Google Summer of Code pelo quinto ano consecutivo. Neste ano, recebemos 50 propostas de projeto de possíveis participantes de todo o mundo. Hoje, destacamos alguns dos projetos que orientamos neste verão. Os colaboradores descrevem seus projetos neste post.

## Cliente HTTP usando bindings JNI do OkHttp {:#http-client-using-jni-bindings-from-okhttp}

*Por Anikate De*

Os clientes HTTP existentes em Dart não conseguiam interagir com as APIs nativas do Android, o que limitava o suporte a KeyStore PrivateKeys, proxy do sistema e certificados instalados pelo usuário (todos recursos muito solicitados pelos usuários do Dart).

O projeto open source [`OkHttp`](https://square.github.io/okhttp/), uma escolha popular para aplicações com muita rede no Android, tem APIs que podem implementar de forma transparente as funcionalidades acima. Por isso, o `OkHttp` foi escolhido como ponto de partida para este projeto. Usando o projeto do GSoC 2022, [`package:jnigen`](https://pub.dev/packages/jnigen), foram gerados bindings JNI para Dart de várias APIs do `OkHttp`. O `OkHttpClient` é totalmente compatível com os clientes HTTP existentes, permitindo uma transição sem complicações para usar o `OkHttpClient` a partir de qualquer alternativa.

Além de requisições HTTP assíncronas, o [`package:ok_http`](https://pub.dev/packages/ok_http) também oferece suporte a WebSockets, o que exige passar em todos os testes do `package:web_socket_conformance_test`. Isso permite uma transição tranquila a partir de qualquer alternativa de WebSocket. Apps Flutter que usam o `package:ok_http` têm, segundo o benchmark, o menor tamanho de APK entre todos os outros clientes HTTP que o Dart oferece.

Aproveitar os benefícios do `OkHttpClient` nos seus projetos Flutter é tão simples quanto importá-lo e editar o seu objeto `Client` atual!

Leia mais sobre os detalhes do projeto no [relatório do colaborador do GSoC.](https://github.com/Anikate-De/gsoc-2024-project-report)

## Swift2ObjC: gerador de wrappers ObjC {:#swift2objc-objc-wrappers-generator}

*Por Mohammad Eid*

O Dart consegue se comunicar (indiretamente) com código Swift. Isso é feito “por meio” do ObjC, já que o Dart pode se comunicar com linguagens baseadas em C (como ObjC) usando o pacote [`ffi`](https://dart.dev/interop/c-interop). APIs Swift podem ser anotadas com `@objc` para pedir que o compilador gere headers ObjC para elas. A geração dos bindings `ffi` para Dart é feita automaticamente com o [ffigen](https://pub.dev/packages/ffigen). Já no Swift, você precisa anotar manualmente as APIs com as quais quer se comunicar..

Anotar APIs Swift pode ser mais trabalhoso do que adicionar uma anotação `@objc`. E se você não for dono do módulo? Se não puder editá-lo, precisa criar um wrapper customizado que espelhe as APIs, para poder anotar os métodos. Além disso, como Swift é uma linguagem moderna e ObjC não é, você provavelmente vai encontrar APIs que não são representáveis em ObjC de imediato, então também precisa contornar esses casos.

O Swift2ObjC cuida disso para você: ele gera wrappers para módulos Swift e os anota com `@objc`, garantindo que todas as APIs sejam representáveis em ObjC — caso contrário, o módulo Swift não compila. Explico os detalhes de implementação neste [artigo](https://medium.com/@mohammad.mossad.eid/swift2objc-more-convenient-swift-dart-interoperability-b152dd5bed13) no Medium (que você pode consultar se estiver pensando em contribuir com a ferramenta, já que ela ainda está em desenvolvimento ativo). Você também pode mergulhar no código-fonte no repositório [swift2obj](https://github.com/dart-lang/native/tree/cf13658c3bc92e62893ec15659dc1370a7d07e8a/pkgs/swift2objc) no GitHub.

## Testando comentários de documentação com `dartdoc_test` {:#testing-documentation-comments-with-dartdoc_test}

*Por Takuma Ichikawa*

O Dart permite que exemplos de código sejam incorporados em comentários de documentação. Essa é uma prática benéfica, porque também é publicada como documentação da API e mostra como usar o pacote de um jeito fácil de entender, tanto para os usuários do pacote quanto para os desenvolvedores. No entanto, os exemplos de código em comentários de documentação não são analisados nem testados, o que dificulta encontrar erros e os torna menos fáceis de manter. À medida que os projetos e a documentação crescem, esse problema se torna mais significativo.

Por isso, no GSoC, desenvolvi o pacote [`dartdoc_test`](https://pub.dev/packages/dartdoc_test) para resolver esses problemas. A ferramenta `dartdoc_test` consegue extrair e analisar exemplos de código em comentários de documentação para encontrar possíveis erros. Ao adicionar o pacote ao seu projeto e executá-lo pela linha de comando, você consegue encontrar erros em todos os exemplos de código. Você também pode fazer análise estática dos exemplos de código ao executar o comando `dart test`, adicionando o arquivo de teste do `dartdoc_test`.

É fácil experimentar o `dartdoc_test` no seu projeto Dart executando os dois comandos a seguir.

```shell
dart pub add dev:dartdoc_test
dart run dartdoc_test
```


Para saber mais, confira o [`dartdoc_test`](https://pub.dev/packages/dartdoc_test) no pub.dev.

## Gerando bindings dart:ffi na web usando WASM com o FFIgenPad {:#generate-dartffi-bindings-on-the-web-using-wasm-with-ffigenpad}

*Por TheComputerM*

O Dart, como uma linguagem que pode ser compilada para vários alvos, inclui recursos que facilitam a comunicação com binários nativos. Você pode usar pacotes como o [`dart:ffi`](https://dart.dev/interop/c-interop) para interagir com APIs C e o [`package:jni`](https://pub.dev/packages/jni) para interagir com código Java. Basta escrever um código de cola para especificar a assinatura de tipos da função nativa que você está chamando.

O problema surge quando você usa uma biblioteca com muitas exportações, muitas para escrever à mão. Esse problema é resolvido com o [`ffigen`](https://pub.dev/packages/ffigen) (um projeto anterior do GSoC), uma ferramenta que gera os bindings usando apenas os arquivos de header da biblioteca. Para isso, você teria que instalar o `ffigen`, configurar todas as dependências e requisitos e, provavelmente, iterar várias vezes. Isso não é exatamente a definição de algo fluido e fácil. Por isso surgiu o FFIgenPad.

<DashImage src="images/0sB2hJW3ZkMCeF9Mp.webp" alt="A interface web do FFIgenPad mostrando código C traduzido em bindings FFI de Dart." />


Outro objetivo do projeto era testar o compilador `dart2wasm` (você pode ver meus experimentos [neste post do blog](https://thecomputerm.hashnode.dev/dirty-deeds-done-dart-cheap-experiments-with-dart2wasm)). Claro, poderíamos ter executado o `ffigen` em um servidor e colocado uma interface por cima. Em vez disso, fiz questão de que o FFIgenPad rodasse inteiramente no navegador, compilando tanto o `libclang` quanto o `ffigen` para WebAssembly (por que usar um servidor para a computação se você pode usar o sistema do cliente?).

Confira a demo em [`https://ffigenpad.surge.sh/`](https://ffigenpad.surge.sh/) e o código-fonte no [meu fork](https://github.com/TheComputerM/dart-native/tree/ffigenpad) no GitHub. Gostaria de agradecer aos meus mentores [Prerak Mann](https://github.com/mannprerak2), [Daco Harkes](https://github.com/dcharkes) e [Jackson Gardner](https://github.com/eyebrowsoffire) por participarem sempre que eu pedia ajuda.
