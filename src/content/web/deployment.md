---
ia-translate: true
title: Deploy na web
description: Aprenda como compilar seu aplicativo web Dart para deploy em produção.
---

O deploy de um aplicativo web Dart funciona como o deploy de qualquer outro aplicativo web.
Esta página descreve como compilar seu aplicativo, dicas para torná-lo menor
e mais rápido, e aponta recursos para servir o aplicativo.

## Compilando seu aplicativo {:#compiling-to-javascript}

Use a ferramenta `webdev` para compilar seu aplicativo. Ela compila Dart para JavaScript
e gera todos os recursos necessários para o deploy.
Quando você compila usando o modo de produção do compilador,
você obtém um arquivo JavaScript razoavelmente pequeno,
graças ao suporte do compilador para tree shaking.

Com um pouco de trabalho extra, você pode tornar seu aplicativo implantável
[menor, mais rápido e mais confiável](#make-your-app-smaller-faster-and-more-reliable).

### Compile usando webdev

[Use o comando `webdev build`][build] para criar uma versão implantável
do seu aplicativo. Este comando converte seu código para JavaScript e salva
o resultado como `build/web/main.dart.js`. Você pode usar [qualquer opção
disponível para `dart compile js`](/tools/dart-compile#prod-compile-options)
com `webdev build`.

### Torne seu aplicativo menor, mais rápido e mais confiável {:#make-your-app-smaller-faster-and-more-reliable}

Os passos a seguir são opcionais. Eles podem ajudar a tornar seu aplicativo mais
confiável e responsivo.

* [Use deferred loading para reduzir o tamanho inicial do seu aplicativo](#use-deferred-loading-to-reduce-your-apps-initial-size)
* [Siga as melhores práticas para aplicativos web](#follow-best-practices-for-web-apps)
* [Remova arquivos de build desnecessários](#remove-unneeded-build-files)

#### Use deferred loading para reduzir o tamanho inicial do seu aplicativo {:#use-deferred-loading-to-reduce-your-apps-initial-size}

Você pode usar o suporte do Dart para deferred loading para
reduzir o tamanho inicial de download do seu aplicativo.
Para detalhes, veja a cobertura do tour da linguagem sobre
[deferred loading](/language/libraries#lazily-loading-a-library).

#### Siga as melhores práticas para aplicativos web {:#follow-best-practices-for-web-apps}

Os conselhos usuais para aplicativos web se aplicam a aplicativos web Dart.
Aqui estão alguns recursos:

* [Fast load times](https://web.dev/fast/)
* [Web Fundamentals](https://developers.google.com/web/fundamentals/)
  (especialmente [Optimizing Content Efficiency](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/))
* [Progressive Web Apps](https://web.dev/progressive-web-apps/)
* [Lighthouse](https://developers.google.com/web/tools/lighthouse/)

#### Remova arquivos de build desnecessários {:#remove-unneeded-build-files}

Compiladores web podem produzir arquivos que são úteis durante o desenvolvimento,
como arquivos de mapa Dart-para-JavaScript, mas desnecessários em produção.

Para remover esses arquivos, você pode executar um comando como o seguinte:

{% comment %}
Revise the following once https://github.com/dart-lang/angular/issues/1123 is resolved:
{% endcomment %}

```console
# From the root directory of your app:
$ find build -type f -name "*.js.map" -exec rm {} +
```

## Servindo seu aplicativo

Você pode servir seu aplicativo web Dart assim como você serviria qualquer outro aplicativo web.
Esta seção aponta dicas para servir aplicativos web Dart,
bem como recursos específicos do Dart para ajudá-lo a usar GitHub Pages ou Firebase
para servir seu aplicativo.

### GitHub Pages

Se seu aplicativo não usa roteamento ou requer suporte do lado do servidor,
você pode servir o aplicativo usando [GitHub Pages](https://pages.github.com/).
O pacote [peanut][] é
uma maneira fácil de produzir automaticamente uma branch gh-pages para qualquer aplicativo web Dart.

O [exemplo startup_namer](https://filiph.github.io/startup_namer/)
é hospedado usando GitHub Pages.
Seus arquivos estão na branch **gh-pages** do
[repositório filiph/startup_namer](https://github.com/filiph/startup_namer)
e foram construídos usando [peanut.][peanut]

### Firebase
{% comment %}
TODO: Give an example of how to deploy with Firebase, which originally was shown on https://dart.academy/build-a-real-time-chat-web-app-with-dart-angular-2-and-firebase-3/
{% endcomment %}

Para saber mais sobre deploy com Firebase, veja os seguintes recursos:

* A [documentação do Firebase Hosting](https://firebase.google.com/docs/hosting/)
  descreve como fazer deploy de aplicativos web com Firebase.
* Na documentação do Firebase Hosting,
  [Configure Hosting Behavior](https://firebase.google.com/docs/hosting/full-config)
  cobre redirecionamentos, reescritas e mais.

[build]: /tools/webdev#build
[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[config]: /tools/build_runner#config
[peanut]: {{site.pub-pkg}}/peanut
[webdev]: /tools/webdev
