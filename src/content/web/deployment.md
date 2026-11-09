---
ia-translate: true
title: Deploy na web
description: Aprenda a compilar sua aplicação web Dart para deploy em produção.
---

O deploy de uma aplicação web Dart funciona como o deploy de qualquer outra aplicação web.
Esta página descreve como compilar sua aplicação, dicas para deixá-la menor
e mais rápida, e aponta recursos para servir a aplicação.

## Compilando sua aplicação {:#compiling-to-javascript}

Use a ferramenta `webdev` para compilar sua aplicação. Ela compila Dart para JavaScript
e gera todos os recursos de que você precisa para o deploy.
Quando você compila usando o modo de produção do compilador,
obtém um arquivo JavaScript razoavelmente pequeno,
graças ao suporte do compilador a tree shaking.

Com um pouco de trabalho extra, você pode tornar sua aplicação implantável
[menor, mais rápida e mais confiável](#make-your-app-smaller-faster-and-more-reliable).

### Compile usando o webdev {:#compile-using-webdev}

[Use o comando `webdev build`][build] para criar uma versão implantável
da sua aplicação. Esse comando converte seu código para JavaScript e salva
o resultado em `build/web/main.dart.js`. Você pode usar [qualquer opção
disponível para `dart compile js`](/tools/dart-compile#prod-compile-options)
com o `webdev build`.

### Torne sua aplicação menor, mais rápida e mais confiável {:#make-your-app-smaller-faster-and-more-reliable}

Os passos a seguir são opcionais. Eles podem ajudar a tornar sua aplicação mais
confiável e responsiva.

* [Use deferred loading para reduzir o tamanho inicial da sua aplicação](#use-deferred-loading-to-reduce-your-apps-initial-size)
* [Siga as melhores práticas para aplicações web](#follow-best-practices-for-web-apps)
* [Gerencie source maps e arquivos de build desnecessários](#manage-source-maps-and-unneeded-build-files)

#### Use deferred loading para reduzir o tamanho inicial da sua aplicação {:#use-deferred-loading-to-reduce-your-apps-initial-size}

Você pode usar o suporte do Dart a deferred loading para
reduzir o tamanho inicial do download da sua aplicação.
Para mais detalhes, veja a parte do tour da linguagem sobre
[deferred loading](/language/libraries#lazily-loading-a-library).

#### Siga as melhores práticas para aplicações web {:#follow-best-practices-for-web-apps}

Os conselhos habituais para aplicações web valem para aplicações web Dart.
Aqui estão alguns recursos:

* [Fast load times](https://web.dev/fast/)
* [Web Fundamentals](https://developers.google.com/web/fundamentals/)
  (especialmente [Optimizing Content Efficiency](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/))
* [Progressive Web Apps](https://web.dev/progressive-web-apps/)
* [Lighthouse](https://developers.google.com/web/tools/lighthouse/)

#### Gerencie source maps e arquivos de build desnecessários {:#manage-source-maps-and-unneeded-build-files}

Por padrão, os compiladores web do Dart (`dart compile js` e `dart compile wasm`)
geram arquivos de source map (`.js.map` e `.wasm.map`)
junto com a saída compilada.
Embora os source maps sejam úteis para depuração,
servi-los em servidores web públicos pode expor informações sensíveis:

* **Símbolos e estrutura não minificados**:
  os source maps permitem que o DevTools do navegador reconstrua nomes originais de classes,
  nomes de funções e a lógica do código-fonte.
* **Caminhos de arquivos do desenvolvedor**:
  os source maps costumam incluir URIs absolutas do sistema de arquivos
  (como `file:///Users/...`) da máquina de build.

:::warning
Para manter privados os nomes dos seus símbolos, a estrutura do código e os caminhos locais de build,
não faça deploy de arquivos de source map em hosts web públicos.
:::

Dependendo da sua estratégia de deploy,
você pode tratar os source maps de duas formas:

* **Desabilite os source maps no momento do build**:
  se você não precisa de source maps para depuração em produção ou para relatório de erros,
  passe a flag `--no-source-maps` para o compilador:

  ```console
  $ dart compile js --no-source-maps -O2 -o build/main.js web/main.dart
  $ dart compile wasm --no-source-maps -o build/main.wasm web/main.dart
  ```

* **Exclua ou remova os arquivos de map da hospedagem pública**:
  se você usa source maps em serviços privados de monitoramento de erros
  (como Sentry ou Bugsnag),
  mantenha os arquivos `.map` durante a compilação
  e envie-os diretamente para o seu serviço de monitoramento.
  Depois, exclua-os ou remova-os do seu servidor web público ou do diretório do CDN:

  ```console
  # From the root directory of your app:
  $ find build -type f \( -name "*.js.map" -o -name "*.wasm.map" \) -exec rm {} +
  ```

## Servindo sua aplicação {:#serving-your-app}

Você pode servir sua aplicação web Dart da mesma forma que serviria qualquer outra aplicação web.
Esta seção reúne dicas para servir aplicações web Dart,
além de recursos específicos do Dart para ajudar você a usar o GitHub Pages ou o Firebase
para servir sua aplicação.

### GitHub Pages {:#github-pages}

Se sua aplicação não usa roteamento nem precisa de suporte do lado do servidor,
você pode servi-la usando o [GitHub Pages](https://pages.github.com/).
O pacote [peanut][] é
uma forma fácil de gerar automaticamente uma branch gh-pages para qualquer aplicação web Dart.

O [exemplo startup_namer](https://filiph.github.io/startup_namer/)
é hospedado com GitHub Pages.
Seus arquivos estão na branch **gh-pages** do
[repositório filiph/startup_namer](https://github.com/filiph/startup_namer)
e foram gerados com o [peanut.][peanut]

### Firebase {:#firebase}
{% comment %}
TODO: Give an example of how to deploy with Firebase, which originally was shown on https://dart.academy/build-a-real-time-chat-web-app-with-dart-angular-2-and-firebase-3/
{% endcomment %}

Para saber mais sobre deploy com Firebase, veja os seguintes recursos:

* A [documentação do Firebase Hosting](https://firebase.google.com/docs/hosting/)
  descreve como fazer deploy de aplicações web com Firebase.
* Na documentação do Firebase Hosting,
  [Configure Hosting Behavior](https://firebase.google.com/docs/hosting/full-config)
  aborda redirecionamentos, reescritas e mais.

[build]: /tools/webdev#build
[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[config]: /tools/build_runner#config
[peanut]: {{site.pub-pkg}}/peanut
[webdev]: /tools/webdev
