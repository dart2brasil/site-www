---
ia-translate: true
title: "Anunciando o Dart 2.8"
description: "Ferramentas de pacotes mais rápidas, nova ferramenta para garantir que as dependências nunca fiquem desatualizadas"
publishDate: 2020-05-06
author: mit-mit
image: images/1JrrSSD8LCLMkAUIV8RJlkw.webp
category: releases
layout: blog
---


Hoje anunciamos uma nova versão do SDK do Dart, a 2.8. Continuamos vendo um crescimento incrível na comunidade Dart; hoje já temos [milhões de desenvolvedores Flutter]({{site.flutter-blog}}/flutter-spring-2020-update) usando o Dart como linguagem otimizada para o client-side, para criar apps rápidos em qualquer plataforma. Embora ainda estejamos trabalhando duro para concluir o nosso [próximo recurso de null safety](/blog/announcing-dart-2-7-a-safer-more-expressive-dart), que tornará o Dart uma linguagem ainda mais otimizada para criar interfaces de usuário rápidas e estáveis, temos alguns novos recursos empolgantes focados em tornar os desenvolvedores ainda mais produtivos ao gerenciar dependências.

A plataforma Dart vem com suporte nativo a gerenciamento de pacotes, por meio da ferramenta de linha de comando [pub](https://dart.dev/tools/pub/cmd) e do repositório de pacotes [pub.dev](https://pub.dev/), que cresceu 200% no último ano e hoje abriga quase 10.000 pacotes. Como parte do nosso trabalho contínuo para melhorar o ecossistema Dart, o SDK do Dart 2.8 traz duas melhorias para a ferramenta pub: um desempenho muito melhor no `pub get` e uma nova ferramenta para garantir que as dependências dos seus pacotes continuem atualizadas.

O Dart 2.8 também traz um conjunto de pequenas mudanças incompatíveis na linguagem e nas bibliotecas do Dart. Essas mudanças preparam o terreno para a nossa primeira versão do recurso de null safety.

<DashImage src="images/1JrrSSD8LCLMkAUIV8RJlkw.webp" alt="Dart 2.8 release banner highlighting the pub outdated tool and pub tool performance." caption="Announcing Dart 2.8: Faster package tools, new tool for ensuring dependencies never go stale" />


## Mudanças incompatíveis que abrem caminho para o null safety {:#breaking-changes-paving-the-way-for-null-safety}

Uma fonte comum de travamentos de apps é o código que tenta usar uma variável que, por acaso, é `null`. Sir Tony Hoare, que introduziu as referências nulas na linguagem ALGOL em 1965, as chamou famosamente de seu *"erro de um bilhão de dólares"*, em uma [palestra na QCon em 2009](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/). Em alguns casos, valores nulos são úteis; o desafio é separá-los dos casos em que não são. Nos últimos anos, estivemos ocupados construindo suporte a [null safety sólido](https://github.com/dart-lang/language/issues/110) no Dart. Esse suporte vai estender o sistema de tipos para expressar variáveis que são sempre não anuláveis, e, além disso, o sistema de tipos será totalmente sólido: os compiladores e runtimes do Dart poderão confiar nesses tipos e gerar código otimizado quando o sistema de tipos garantir que uma variável não é nula.

Como você pode imaginar, é uma grande empreitada, com muitas partes móveis. Para garantir que possamos construir o null safety com uma semântica limpa, decidimos fazer algumas pequenas mudanças incompatíveis na linguagem e nas bibliotecas do Dart. Essas mudanças incompatíveis fazem pequenos ajustes em casos de borda do sistema de tipos do Dart e em algumas bibliotecas core, para garantir ótima usabilidade e desempenho relacionados à nulidade. Esperamos que o impacto real dessas mudanças — que foram [anunciadas previamente](https://groups.google.com/a/dartlang.org/g/announce/c/JwPWiC0jTiU) na lista de anúncios do Dart — seja mínimo para o código comum de apps. Se você tiver algum problema com o Dart 2.8, recomendamos que revise [as mudanças incompatíveis](https://github.com/dart-lang/sdk/issues/40686) e suas descrições e passos de mitigação. Se isso não resolver o problema, abra uma issue no [nosso issue tracker](https://github.com/dart-lang/sdk/issues). Para uma prévia da experiência de null safety, experimente o [playground de null safety](https://nullsafety.dartpad.dev/53257b6da4cb128dc1e069df64748ed1).

## Um ecossistema de pacotes com mais qualidade {:#a-higher-quality-package-ecosystem}

O gerenciador de pacotes pub e o site [pub.dev](https://pub.dev) alimentam um ecossistema em constante crescimento para o Dart e o Flutter. Quase 10.000 pacotes estão disponíveis no pub.dev, e continuamos impressionados com os muitos pacotes interessantes compartilhados. É parte central da nossa missão ajudar autores de pacotes a criar pacotes de alta qualidade e ajudar desenvolvedores de apps a encontrar esses pacotes — por exemplo, adicionamos a [descoberta aprimorada no pub.dev](/blog/improved-discovery-on-the-dart-package-site), os [publicadores verificados](/blog/announcing-verified-publishers-on-pub-dev) e os [Flutter Favorites](https://flutter.dev/docs/development/packages-and-plugins/favorites).

Hoje anunciamos um desempenho muito mais rápido ao buscar pacotes no repositório [pub.dev](https://pub.dev), e uma nova ferramenta para ajudar você a manter todas as dependências dos seus pacotes atualizadas. Com a complexidade dos apps modernos, seu app provavelmente depende de dezenas de pacotes. Mas como você mantém todos eles na versão mais recente, para garantir que está usando as dependências mais recentes, com todas as correções de bugs e melhorias de desempenho disponíveis? A partir do Dart 2.8, você pode usar `pub outdated`, uma nova ferramenta que determina automaticamente quais dependências precisam ser atualizadas para as versões mais recentes e melhores.

## Melhorias de desempenho da ferramenta pub no Dart 2.8 {:#dart-2-8-pub-tool-performance-improvements}

Otimizamos o desempenho da ferramenta pub adicionando suporte a busca paralela de pacotes ao rodar `pub get`, e adiando a pré-compilação do `pub run`.

Em um benchmark informal de rodar `flutter pub get` em um projeto novo criado com `flutter create`, o tempo total de execução caiu de cerca de 6,5 segundos no Flutter 1.12 (que usa o Dart 2.7) para apenas 2,5 segundos com o Flutter 1.17 (Dart 2.8). Em um app maior, como a [galeria do Flutter](https://github.com/flutter/gallery), o tempo cai de cerca de 15 segundos para cerca de 3 segundos!

## Gerenciando dependências com `pub outdated` {:#managing-dependencies-with-pub-outdated}

<DashImage src="images/1av2bRfpUdU2Fk4s8xRPnhA.webp" alt="A terminal animation recording showing the output of the pub outdated command." />


As dependências no código Dart são declaradas no arquivo [pubspec](https://kw-staging-dartlang-2.firebaseapp.com/tools/pub/pubspec). Quando você baixa pacotes do [pub.dev](https://pub.dev/) executando o comando `pub get`, o solucionador de versões do pub (que usa o algoritmo [PubGrub](https://medium.com/@nex3/pubgrub-2fb6470504f)) executa um processo para determinar o conjunto mais recente possível de versões de todas as suas dependências que satisfaça as restrições listadas no seu pubspec. Observe que o pub usa um esquema de versão única, em que cada pacote aparece em uma única versão no seu app; essa é uma otimização importante para que o tamanho do app seja o menor possível.

É [uma boa prática](http://dart.dev/tools/pub/dependencies#best-practices) sempre usar as versões estáveis mais recentes dos pacotes, mas isso pode dar trabalho. O Dart tem suporte para atualizar para as versões mais recentes que são [semanticamente compatíveis](https://dart.dev/tools/pub/dependencies#version-constraints) usando o [`pub upgrade`](https://dart.dev/tools/pub/cmd/pub-upgrade), mas você não pode incluir novas versões major de pacotes sem alterar o pubspec. O comando `pub outdated` ajuda a entender quando versões minor e major estão disponíveis, comparando as versões em uso com as versões mais recentes disponíveis no pub.dev.

Vamos considerar um exemplo concreto. Imagine que você está construindo um app, e o `pubspec.yaml` dele contém o seguinte:

```
dependencies:
  foo: ^1.3.0
  bar: ^2.0.0
```


Você executa `pub get`, e a ferramenta cria um arquivo `pubspec.lock` com as seguintes versões:

```
packages:
  foo:
    version: "1.3.0"
  bar:
    version: "2.0.1"
```


Alguns meses se passam, e o pub.dev agora tem novas versões de `foo` (1.3.1) e `bar` (2.1.0 e 3.0.3). Como você descobre que essas novas versões estão disponíveis? Para as atualizações de versão minor (`foo` 1.4.0 e `bar` 2.1.0), você poderia executar pub upgrade, mas isso não daria `bar` 3.0.0. Para descobrir essa nova versão, você teria que visitar cada pacote no pub.dev e olhar a versão mais recente. Alternativamente, você poderia usar uma solução da comunidade, como o [version checker](https://plugins.jetbrains.com/plugin/12400-flutter-pub-version-checker) de Paulina Szklarska ou o [pubspec assist](https://marketplace.visualstudio.com/items?itemName=jeroen-meijer.pubspec-assist) de Jeroen Meijer.

Com o `pub outdated`, o SDK do Dart agora oferece suporte à descoberta de versões. Se você estiver usando uma IDE com suporte a Dart ou Flutter, use a ação **Pub outdated** que aparece quando o arquivo `pubspec.yaml` está aberto. Ou você pode executar `pub outdated` (ou `flutter pub outdated`) no terminal:

```
**$** pub outdated

Dependencies            Current  Upgradable  Resolvable  Latest
foo                     1.3.0    1.3.1       1.3.1       1.3.1
bar                     2.0.1    2.1.0       3.0.3       3.0.3

1 upgradable dependency is locked (in pubspec.lock) to an older version.

To update it, use `pub upgrade`.

1 dependency is constrained to a version that is older than a resolvable version.
```


Essa saída nos diz que podemos atualizar automaticamente para `foo` 1.3.1 com `pub upgrade`, o que nos colocará na versão mais recente disponível de `foo`. Mas ela também nos diz que, embora possamos atualizar automaticamente para `bar` 2.1.0, a versão 3.0.3 está disponível. Como a atualização para `bar` 3.0.3 é uma atualização de versão major, precisamos optar por ela editando nosso arquivo `pubspec.yaml`:

```
dependencies:
  foo: ^1.3.0
  bar: ^3.0.3
```


Depois de fazer essa edição e executar `pub upgrade`, o `pub outdated` agora informa que todas as dependências estão atualizadas:

```
**$** pub outdated

Dependencies            Current   Upgradable  Resolvable  Latest

all up-to-date
```


Sucesso, estamos atualizados! Como acabamos de pegar novas versões, incluindo uma nova versão major, devemos revisar possíveis mudanças incompatíveis nessas versões e executar todos os testes para garantir que nosso app continua funcionando como esperado.

## Próximos passos {:#next-steps}

As melhorias de desempenho, as [mudanças incompatíveis](https://github.com/dart-lang/sdk/issues/40686) e o novo comando `pub outdated` estão disponíveis hoje no [SDK estável do Dart 2.8](https://dart.dev/get-dart) e no [SDK estável do Flutter 1.17](https://flutter.dev/docs/get-started/install). Recomendamos que você [execute `pub outdated` hoje](https://dart.dev/tools/pub/cmd/pub-outdated) para ver a saúde das suas dependências!

Se encontrar algum problema, reporte-o no [issue tracker do pub](https://github.com/dart-lang/pub/issues) ou, para problemas gerais, no [issue tracker do SDK](https://github.com/dart-lang/sdk/issues). Adoraríamos saber sobre sua experiência com o `pub outdated`. Deixe um comentário abaixo ou mande um tweet para [@dart_lang](https://twitter.com/dart_lang).
