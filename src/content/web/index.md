---
ia-translate: true
title: Plataforma web
shortTitle: Web
description: Recursos para desenvolver aplicações web em Dart.
showToc: false
---

O Dart oferece suporte à web como uma de suas [plataformas][platforms] principais.
Há compiladores de Dart para JavaScript disponíveis tanto para desenvolvimento
(com um ciclo rápido de editar e atualizar)
quanto para produção
(com foco no tamanho e na velocidade do código).
Para builds de produção, você também pode compilar Dart para
[WebAssembly][wasm] (`dart compile wasm`).

Além dos compiladores,
a plataforma web do Dart oferece [bibliotecas principais][core libraries],
acesso ao [DOM (Document Object Model)][DOM]
e [interoperabilidade para chamar JavaScript][interop] a partir do Dart.

Você tem a opção de usar o Dart para web com um framework de nível mais alto.
Muitas aplicações que funcionam na web e também em mobile ou desktop são construídas
com o [Flutter][] e o suporte ao [Flutter web][].
Você também pode usar o [Jaspr][] para criar sites HTML rápidos e dinâmicos.
O suporte ao Flutter web, o Jaspr
e outros frameworks web para Dart são baseados na plataforma web do Dart.

<div class="side-by-side">
<div class="centered-rows">
<p class="">
  <a href="/web/get-started" class="filled-button large-button">Crie uma aplicação web com Dart</a>
</p>
</div>
<div class="centered-rows">
<figure>
  <img 
    src="/assets/img/flutter-gallery.jpg"
    alt="captura de tela do Flutter Gallery">
  <figcaption>Flutter Gallery, executando em um navegador web</figcaption>
</figure>
</div>
</div>

[platforms]: /overview#platform
[wasm]: /web/wasm
[core libraries]: /libraries#web-platform-libraries
[DOM]: /web/get-started
[Flutter]: {{site.flutter}}
[Flutter web]: {{site.flutter}}/web
[Jaspr]: https://jaspr.site
[interop]: /interop/js-interop
