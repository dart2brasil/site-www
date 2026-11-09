---
ia-translate: true
title: "Anunciando o Dart 2.6 com dart2native: compile Dart para executáveis nativos autocontidos"
description: "Anunciando o Dart 2.6, com o dart2native para compilar aplicações Dart em executáveis nativos autocontidos para Windows, macOS e Linux"
publishDate: 2019-11-05
author: mit-mit
image: images/0lY0iF-neazyL0aE-.webp
category: releases
layout: blog
---


O Dart já oferece [um amplo conjunto de compiladores](https://dart.dev/platforms) para construir código otimizado para produção em dispositivos móveis e na web. Esses compiladores flexíveis permitem que nossos parceiros de framework alcancem uma ampla gama de formatos: aplicações Flutter em [Android e iOS](https://flutter.dev/docs), aplicações Flutter na [web](https://flutter.dev/web) e no [desktop](https://flutter.dev/desktop), aplicações AngularDart na [web](https://angulardart.dev/) e o Google Assistant em [dispositivos embarcados](https://developers.googleblog.com/2019/05/Flutter-io19.html).

Hoje anunciamos o **`dart2native`**, uma extensão do nosso conjunto atual de compiladores, com a capacidade de compilar programas Dart para executáveis autocontidos que contêm código de máquina compilado ahead-of-time. Com o dart2native, você pode criar ferramentas de linha de comando para **macOS, Windows ou Linux** usando Dart. A imagem de anúncio deste recurso [foi implementada](https://gist.github.com/mit-mit/faec2bfc1d1cef7cd09df917e531c5c0) usando o próprio recurso :-)

<DashImage src="images/0lY0iF-neazyL0aE-.webp" alt="An animation of a bash terminal showing the command line interface." />


## Dart Native e o compilador dart2native {:#dart-native-and-the-dart2native-compiler}

O Dart já oferece suporte à compilação AOT (ahead-of-time) para código de máquina nativo há vários anos, e o [Dart Native](https://dart.dev/platforms) é, portanto, uma tecnologia bastante madura. No entanto, até agora expúnhamos essa capacidade apenas em dispositivos móveis iOS e Android, por meio do [Flutter](http://flutter.dev).

Com o `dart2native`, estamos estendendo o suporte à compilação nativa para sistemas operacionais de desktop tradicionais, como macOS, Windows e Linux. Como os executáveis criados com o `dart2native` são autocontidos, eles podem rodar em máquinas que não têm o SDK do Dart instalado. E, por serem compilados com o compilador AOT do Dart, os executáveis começam a rodar em apenas alguns milissegundos. Assim como nos outros compiladores e runtimes do Dart, o mesmo conjunto rico e consistente de [bibliotecas core](https://dart.dev/guides/libraries) está disponível no Dart quando ele é compilado para código nativo.

Ouvimos muitos clientes pedirem compilação AOT para sistemas operacionais de desktop (a [sexta issue mais bem avaliada](https://github.com/dart-lang/sdk/issues/36915) no nosso issue tracker), então estamos muito felizes em disponibilizar este recurso.
> Se você já usava o dart2aot, a partir da 2.6 você vai usar o dart2native. Ele oferece um superconjunto das funcionalidades do dart2aot.

## Construindo apps de linha de comando com o dart2native {:#building-command-line-apps-with-dart2native}

O compilador `dart2native` é uma ótima escolha para construir e distribuir [aplicações Dart para linha de comando](https://dart.dev/tutorials/server/cmdline). Essas aplicações costumam usar bibliotecas como [`dart:io`](https://api.dart.dev/stable/dart-io/dart-io-library.html) (I/O básico), `package:[http](https://pub.dev/packages/http)` (rede) e `package:[args](https://pub.dev/packages/args)` (parsing de argumentos). Vamos revisar o básico de compilar uma aplicação "hello, world" para um executável:

O código-fonte `hello.dart`:

```
main() {
  print(‘Hello Dart developers’);
}
```


Compile `hello.dart` para um executável `hello`:

```
$ dart2native src/hello.dart -o hello
Generated: /Users/mit/hello
```


Execute `hello` medindo o tempo de execução:

```
$ time ./hello
Hello Dart developers

real 0m0.049s
user 0m0.018s
sys 0m0.020s
```


Repare como o comando inicia, imprime na saída padrão e termina em um tempo combinado de apenas 49 milissegundos!

Já vimos alguns desenvolvedores Dart experimentando o `dart2native` para ferramentas de linha de comando:

* Natalie, da equipe do [SASS](https://sass-lang.com/) (uma ferramenta popular de extensão de CSS), [relata](https://github.com/dart-lang/sdk/issues/32894#issuecomment-513975562) que, depois de mudar a implementação do SASS em Dart para compilar com o dart2native, ela passou a ser competitiva em desempenho com o LibSass, uma implementação em C++.

* Filip, da equipe de DevRel do Dart, recompilou a ferramenta [linkchecker](https://github.com/filiph/linkcheck/) com o dart2native e viu uma [aceleração de 27x](https://github.com/filiph/linkcheck/issues/7#issuecomment-496308288) ao verificar sites pequenos.

## Interoperabilidade com código C via dart:ffi {:#interoperability-with-c-code-via-dartffi}

Aplicações nativas frequentemente precisam acessar funcionalidades nativas do sistema operacional ao redor. Essas APIs de sistema normalmente são expostas em bibliotecas nativas baseadas em C, e o Dart oferece suporte à interoperabilidade com essas bibliotecas por meio do `dart:ffi`, nosso novo mecanismo para [interoperabilidade com C](https://dart.dev/guides/libraries/c-interop), que lançamos em preview no [Dart 2.5](/blog/announcing-dart-2-5-super-charged-development). O compilador `dart2native` é compatível com o `dart:ffi`, então você pode criar e compilar aplicações Dart nativas que o utilizam.

Um membro da nossa equipe usou recentemente o `dart:ffi` para criar a biblioteca [`dart_console`](https://pub.dev/packages/dart_console) para desenvolvimento de aplicações de console, que tem funcionalidades como obter as dimensões da janela, ler e definir a posição do cursor, gerenciar cores e ler teclas e sequências de controle. A capacidade de usar o `dart:ffi` torna o Dart uma linguagem muito poderosa para aplicações de console.

## kilo: um editor de código de 7 MB escrito em menos de 500 linhas de código Dart {:#kilo-a-7mb-code-editor-written-in-less-than-500-lines-of-dart-code}

Usando as bibliotecas core do Dart, o `dart:ffi` e a biblioteca dart_console, podemos criar aplicações de console bem interessantes. O pacote dart_console inclui uma demonstração completa do *kilo*, um editor de texto de console escrito em apenas ~[500 linhas de código Dart](https://github.com/timsneath/dart_console/blob/master/example/kilo.dart). O nome kilo vem da sua origem, o [`kilo.c`](https://github.com/antirez/kilo/blob/master/kilo.c), que era uma implementação em C com cerca de 1000 linhas de código.

Com o novo compilador `dart2native`, podemos empacotar isso facilmente, e chegamos a um editor de código autocontido de 7 MB. Aqui está uma demonstração da compilação do editor e, em seguida, do uso do editor compilado para editar o próprio código-fonte e corrigir um bug:

<DashImage src="images/0f5pvUnbesO4mGZmW.webp" alt="The kilo editor written in Dart and compiled to an executable with dart2native editing its own source code." caption="The kilo editor written in Dart and compiled to an executable with dart2native editing it’s own source code" />


## Construindo serviços com o dart2native {:#building-services-with-dart2native}

Outro uso potencial do compilador dart2native é para serviços pequenos, por exemplo, um backend que dá suporte a um app frontend escrito em Flutter. Nos últimos anos, uma tendência crescente tem sido o uso de serviços rodando em [computação serverless](https://en.wikipedia.org/wiki/Serverless_computing). São serviços totalmente gerenciados que escalam automaticamente, inclusive escalando de zero (sem execução) para cima e de volta para zero, o que pode reduzir muito os custos, já que são cobrados apenas quando estão de fato rodando. O Google Cloud disponibiliza a computação serverless por meio do [Cloud Run](https://cloud.google.com/run/).

Para backends serverless, é fundamental que o serviço inicie rapidamente. Tradicionalmente, serviços baseados em Dart rodavam com o nosso compilador JIT (just-in-time), mas a execução baseada em JIT tem alta latência na inicialização, já que o código precisa ser compilado e aquecido antes de começar a executar. Ao compilar o código do seu serviço ahead-of-time para código nativo, você evita essa latência e começa a rodar imediatamente. Além disso, com código nativo você pode criar serviços em Dart com uma pegada pequena em disco e autocontidos, reduzindo bastante o tamanho do contêiner em que o serviço roda. O desenvolvedor Dart Paul Mundt [documentou recentemente suas experiências](https://itnext.io/experiments-with-dart-microservices-fa117aa408c7) com o compilador dart2native; ele conseguiu reduzir o tamanho da sua imagem Docker em 91%, de 220 MB com código compilado em JIT para apenas 20 MB usando código nativo! Veja a nossa documentação para mais detalhes sobre [aplicações server-side](https://dart.dev/tutorials/server/httpserver) e [pacotes](https://dart.dev/server/libraries#server-packages).

## Disponibilidade {:#availability}

O compilador `dart2native` está disponível no SDK do Dart a partir da versão 2.6, que está disponível a partir de hoje em [dart.dev/get-dart](https://dart.dev/get-dart). Depois de instalar o SDK, você deve ver o novo compilador dentro do diretório bin/ e no seu `PATH`. O dart.dev tem [mais documentação](https://dart.dev/tools/dart2native).

Se você obtiver o SDK do Dart pelo Flutter, observe que as builds atuais do Flutter têm suporte incompleto ao dart2native. Recomendamos que você instale o SDK do Dart 2.6 em [dart.dev/get-dart](https://dart.dev/get-dart).

## Limitações conhecidas {:#known-limitations}

Esta versão inicial do compilador `dart2native` tem algumas limitações conhecidas, listadas abaixo. Você pode nos dizer quais problemas são importantes para você dando um "joinha" na issue em nosso issue tracker do GitHub.

* Sem suporte a cross-compilation ([issue 28617](https://github.com/dart-lang/sdk/issues/28617)): o compilador dart2native só cria código de máquina para o sistema operacional em que está rodando. Assim, você vai precisar executar o compilador três vezes, no macOS, no Windows e no Linux, se quiser criar executáveis para os três. Uma forma de fazer isso é usar um provedor de CI (Integração Contínua) que dê suporte aos três sistemas operacionais.

* Sem suporte a assinatura ([issue 39106](https://github.com/dart-lang/sdk/issues/39106)): os executáveis produzidos usam um formato que não é compatível com ferramentas padrão de assinatura, como `codesign` e `signtool`.

* Sem suporte a `dart:mirrors` e `dart:developer` (veja as [bibliotecas core do Dart](https://dart.dev/guides/libraries)).

## Outras mudanças no Dart 2.6 {:#other-changes-in-dart-2-6}

A versão 2.6 do SDK do Dart também traz algumas outras mudanças.

Lançamos um preview do `dart:ffi`, nosso novo mecanismo para [interoperabilidade com C](https://dart.dev/guides/libraries/c-interop), no [Dart 2.5](/blog/announcing-dart-2-5-super-charged-development). O Dart 2.6 tem uma nova versão do `dart:ffi`. Essa nova versão traz várias mudanças incompatíveis na API, para torná-la mais fácil de usar, oferecer mais segurança de tipos e dar acesso conveniente à memória. Para mais detalhes, veja o [changelog do Dart 2.6](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#foreign-function-interface-dartffi). Com essas mudanças, o `dart:ffi` avança para o beta, e esperamos que as mudanças na API sejam bem menos frequentes daqui para frente, com alta estabilidade geral. Continue nos enviando feedback pelo [issue tracker](https://github.com/dart-lang/sdk/issues).

O Dart 2.6 também contém um preview de um novo recurso de linguagem empolgante, os [métodos de extensão](https://github.com/dart-lang/language/issues/41). Ainda temos um pouco de acabamento e trabalho em ferramentas para concluir esse recurso, mas esperamos lançá-lo formalmente na nossa próxima versão do SDK do Dart. Vamos falar muito mais sobre os métodos de extensão nessa ocasião; por enquanto, você pode ler sobre as [considerações de design por trás do recurso](/blog/dart-extension-method-fundamentals).

## Próximos passos {:#next-steps}

Baixe o SDK do Dart 2.6 ([dart.dev/get-dart](https://dart.dev/get-dart)), crie algo legal com o dart2native e depois nos conte sobre isso. Se você estiver disposto a compartilhar os detalhes, deixe uma resposta no final deste artigo. Estamos animados para ver o que você vai criar!
