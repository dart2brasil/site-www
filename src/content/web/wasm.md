---
ia-translate: true
title: Compilação WebAssembly (Wasm)
description: Aprenda como compilar sua aplicação web Dart para WebAssembly.
---

A equipe Dart está animada em adicionar
[WebAssembly](https://webassembly.org/) como um target de compilação ao construir
aplicações Dart e [Flutter][] para a web.

O desenvolvimento do suporte a WebAssembly continua em andamento,
o que pode resultar em mudanças frequentes.
Revisite esta página para as últimas atualizações.

:::note
**O suporte a Wasm agora está em stable!**

O suporte a WebAssembly para web Dart está disponível no
[channel](/get-dart#release-channels) *stable* do Dart.
:::

## Suporte a WebAssembly

A versão atual da compilação Dart para WebAssembly tem várias
restrições:

1. Ela tem como target WebAssembly com Garbage Collection ([WasmGC][]),
   então nem todos os navegadores são atualmente suportados.
   A lista atual de navegadores está disponível na [documentação do Flutter][Flutter].

1. A saída Wasm compilada atualmente tem como target ambientes JavaScript
   (como navegadores), e portanto atualmente não suporta execução em run-times Wasm
   padrão como wasmtime e wasmer. Para detalhes, veja
   [issue #53884]({{site.repo.dart.sdk}}/issues/53884)

1. Apenas o
   [mecanismo de interoperabilidade JS de próxima geração do Dart](/interop/js-interop/)
   é suportado ao compilar para Wasm.

1. Atualmente não há suporte na ferramenta `webdev` para executar
   (`webdev serve`) ou construir (`webdev build`). Os passos abaixo
   contêm uma solução temporária. Para detalhes, veja
   [webdev issue 2206]({{site.repo.dart.org}}/webdev/issues/2296).

### Pacotes suportados

Para encontrar pacotes compatíveis com Wasm,
use o filtro [`wasm-ready`][] no [pub.dev][].

Um pacote é "wasm-ready" se ele não importa bibliotecas não compatíveis com Wasm
como `dart:html`, `dart:js`, etc. Você pode encontrar a lista completa de bibliotecas
não permitidas na [página de interoperabilidade JS](/interop/js-interop/#next-generation-js-interop).

[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}

## Compilando sua aplicação web para Wasm {:#compiling-to-wasm}

Nós implementamos suporte no CLI `dart` para invocar o
compilador Wasm no Dart e [Flutter][]:

```console
$ dart help compile wasm
Compile Dart to a WebAssembly/WasmGC module.

Usage: dart compile wasm [arguments] <dart entry point>
-h, --help                  Print this usage information.
-o, --output                Write the output to <file name>.
                            This can be an absolute or relative path.
-v, --verbose               Print debug output during compilation
    --enable-asserts        Enable assert statements.
-D, --define=<key=value>    Define an environment declaration. To specify multiple declarations, use multiple
                            options or use commas to separate key-value pairs.
                            For example: dart compile wasm -Da=1,b=2 main.dart
```

A compilação Wasm está disponível em stable, mas ainda em preview.
Enquanto continuamos otimizando as ferramentas para melhorar a experiência do desenvolvedor,
você pode experimentar compilar Dart para Wasm hoje
seguindo os passos temporários descritos aqui:

1. Comece com uma aplicação web: `dart create -t web mywebapp`

    O template cria uma pequena aplicação web usando [`package:web`][],
    que é necessário para executar Wasm.
    Certifique-se de que suas aplicações web foram [migradas][migrated] de `dart:html` para `package:web`.

1. Compile com Wasm para um novo diretório de saída `site`: `mywebapp$ dart compile wasm web/main.dart -o site/main.wasm`

1. Copie os arquivos web: `cp web/index.html web/styles.css site/`

1. Crie um arquivo bootstrap JS para carregar o código Wasm:

   Adicione um novo arquivo `site/main.dart.js` e preencha-o com o conteúdo deste
   [exemplo `main.dart.js`](https://gist.github.com/mit-mit/0fcb1247a9444b0cadf611aa5fc6f32e).

1. Sirva a saída: `dart pub global run dhttpd` ([docs][dhttpd])

Você também pode experimentar este pequeno exemplo [aqui](https://github.com/mit-mit/sandbox).

[WasmGC]: https://developer.chrome.com/blog/wasmgc/
[Flutter]: {{site.flutter}}/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop
[migrated]: /interop/js-interop/package-web/
[dhttpd]: {{site.pub-pkg}}/dhttpd
