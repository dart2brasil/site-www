---
ia-translate: true
title: "Implantação na Web"
description: "Aprenda como construir seu aplicativo web Dart para implantação em produção."
---

A implantação de um aplicativo web Dart funciona como a implantação de qualquer outro aplicativo web.
Esta página descreve como compilar seu aplicativo, dicas para torná-lo menor
e mais rápido, e aponta para recursos para servir o aplicativo.

## Construindo seu aplicativo {:#compiling-to-javascript}

Use a ferramenta `webdev` para construir seu aplicativo. Ele compila Dart para JavaScript
e gera todos os assets (recursos) que você precisa para a implantação.
Quando você constrói usando o modo de produção do compilador,
você obtém um arquivo JavaScript que é razoavelmente pequeno,
graças ao suporte do compilador para *tree shaking* (eliminação de código morto).

Com um pouco de trabalho extra, você pode tornar seu aplicativo implantável
[menor, mais rápido e mais confiável](#make-your-app-smaller-faster-and-more-reliable).

### Compilar usando webdev {:#compile-using-webdev}

[Use o comando `webdev build`][build] para criar uma versão implantável
do seu aplicativo. Este comando converte seu código para JavaScript e salva
o resultado como `build/web/main.dart.js`. Você pode usar [qualquer opção
disponível para `dart compile js`](/tools/dart-compile#prod-compile-options)
com `webdev build`.

### Deixe seu aplicativo menor, mais rápido e mais confiável {:#make-your-app-smaller-faster-and-more-reliable}

Os seguintes passos são opcionais. Eles podem ajudar a tornar seu aplicativo mais
confiável e responsivo.

* [Use *deferred loading* (carregamento adiado) para reduzir o tamanho inicial do seu aplicativo](#use-deferred-loading-to-reduce-your-apps-initial-size)
* [Siga as melhores práticas para aplicativos web](#follow-best-practices-for-web-apps)
* [Remova arquivos de *build* desnecessários](#remove-unneeded-build-files)

#### Use *deferred loading* (carregamento adiado) para reduzir o tamanho inicial do seu aplicativo {:#use-deferred-loading-to-reduce-your-apps-initial-size}

Você pode usar o suporte do Dart para *deferred loading* para
reduzir o tamanho inicial de download do seu aplicativo.
Para mais detalhes, veja a cobertura do tour da linguagem sobre
[*deferred loading*](/language/libraries#lazily-loading-a-library).

#### Siga as melhores práticas para aplicativos web {:#follow-best-practices-for-web-apps}

Os conselhos usuais para aplicativos web se aplicam aos aplicativos web Dart.
Aqui estão alguns recursos:

* [Tempos de carregamento rápidos](https://web.dev/fast/)
* [Fundamentos da Web](https://developers.google.com/web/fundamentals/)
  (especialmente [Otimizando a Eficiência do Conteúdo](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/))
* [Aplicativos Web Progressivos](https://web.dev/progressive-web-apps/)
* [Lighthouse](https://developers.google.com/web/tools/lighthouse/)

#### Remova arquivos de *build* desnecessários {:#remove-unneeded-build-files}

Os compiladores da web podem produzir arquivos que são úteis durante o desenvolvimento,
como arquivos de mapeamento de Dart para JavaScript, mas desnecessários em produção.

Para remover esses arquivos, você pode executar um comando como o seguinte:

{% comment %}
Revise o seguinte assim que https://github.com/dart-lang/angular/issues/1123 for resolvido:
{% endcomment %}

```console
# Do diretório raiz do seu aplicativo: {:#from-the-root-directory-of-your-app}
$ find build -type f -name "*.js.map" -exec rm {} +
```

## Servindo seu aplicativo {:#serving-your-app}

Você pode servir seu aplicativo web Dart da mesma forma que você serviria qualquer outro aplicativo web.
Esta seção aponta para dicas para servir aplicativos web Dart,
bem como recursos específicos do Dart para ajudá-lo a usar o GitHub Pages ou o Firebase
para servir seu aplicativo.

### GitHub Pages {:#github-pages}

Se seu aplicativo não usa roteamento ou requer suporte do lado do servidor,
você pode servir o aplicativo usando [GitHub Pages](https://pages.github.com/).
O pacote [peanut][] é
uma maneira fácil de produzir automaticamente um branch gh-pages para qualquer aplicativo web Dart.

O [exemplo startup_namer](https://filiph.github.io/startup_namer/)
é hospedado usando o GitHub Pages.
Seus arquivos estão no branch **gh-pages** do
[repositório filiph/startup_namer](https://github.com/filiph/startup_namer)
e foram construídos usando [peanut.][peanut]

### Firebase {:#firebase}
{% comment %}
TODO: Dê um exemplo de como implantar com o Firebase, que originalmente foi mostrado em https://dart.academy/build-a-real-time-chat-web-app-with-dart-angular-2-and-firebase-3/
{% endcomment %}

Para saber mais sobre a implantação com o Firebase, consulte os seguintes recursos:

* A [documentação do Firebase Hosting](https://firebase.google.com/docs/hosting/)
  descreve como implantar aplicativos web com o Firebase.
* Na documentação do Firebase Hosting,
  [Configure o Comportamento de Hospedagem](https://firebase.google.com/docs/hosting/full-config)
  cobre redirecionamentos, reescritas e muito mais.

[build]: /tools/webdev#build
[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[config]: /tools/build_runner#config
[peanut]: {{site.pub-pkg}}/peanut
[webdev]: /tools/webdev