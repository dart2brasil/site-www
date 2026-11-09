---
ia-translate: true
title: Compilação WebAssembly (Wasm)
description: Aprenda a compilar sua aplicação web Dart para WebAssembly.
---

Você pode compilar aplicações web do Dart e do [Flutter][] para
[WebAssembly][wasm-org] (`dart2wasm`) como alternativa ao JavaScript
em builds de produção.

## Suporte a WebAssembly {:#webassembly-support}

Ao compilar Dart para WebAssembly, tenha em mente os seguintes requisitos
e comportamentos da plataforma:

1. O `dart2wasm` tem como alvo três propostas padronizadas de WebAssembly:
   **WasmGC** (coleta de lixo),
   **JS String Builtins** (`wasm:js-string`) e
   **Exception Handling da Fase 4** (`try_table` e `exnref`).
   Para executar os módulos compilados em um navegador, é necessário pelo menos:

   * **Chrome ou Edge 137+**
   * **Safari 26.2+** (macOS e iOS)
   * **Firefox 134+** (ou **147+** para Flutter web)

   Para mais detalhes de compatibilidade entre navegadores, veja a
   [documentação do Flutter Wasm][Flutter].

1. Por padrão, a saída Wasm compilada tem como alvo ambientes JavaScript
   (como navegadores) e gera um arquivo de runtime complementar `<name>.mjs`.
   Para compilar um módulo WebAssembly independente para runtimes que não são web,
   como o Wasmtime 39+ (usando `-W gc,exceptions,function-references=y`),
   passe `--standalone` para o `dart compile wasm`.
   Quando `--standalone` está definido, o [`dart:js_interop`][] não é permitido.

1. Apenas o
   [mecanismo de interoperabilidade JS de próxima geração do Dart][js-interop]
   é suportado ao compilar para Wasm.

1. A ferramenta `webdev` não oferece suporte atualmente à compilação Wasm
   (`webdev serve` ou `webdev build`).
   Em vez disso, siga os passos em
   [Compilando sua aplicação web para Wasm](#compiling-to-wasm).

### Deferred loading {:#deferred-loading}

Por padrão, as aplicações compiladas não usam [deferred loading][].
O deferred loading em Wasm é experimental.
Para habilitá-lo, passe a flag `--enable-deferred-loading`:

```console
$ dart compile wasm --enable-deferred-loading ...
```

Para habilitar o deferred loading, o carregador da sua aplicação precisa fornecer um callback
que carregue os bytes dos módulos deferidos:

```js
import { compileStreaming } from './main.mjs';

const app = await compileStreaming(fetch('main.wasm')); // or compile(...)
const instantiatedApp = await app.instantiate({}, {
  loadDeferredModules: (modules, handleModuleByteSource) => {
    return Promise.all(
      modules.map((m) => fetch(m).then((r) => handleModuleByteSource(m, r)))
    );
  },
});
instantiatedApp.invokeMain();
```

### Imports condicionais e suporte a SIMD {:#conditional-imports-and-simd-support}

* **Imports condicionais (`dart.library.isolate`)**:
  Ao compilar com `dart2wasm`, `dart.library.isolate` é avaliado como `false`
  nos imports condicionais (`if (dart.library.isolate)`),
  igual ao comportamento do `dart2js` e do `ddc`.
* **SIMD de 128 bits em Wasm (`v128`)**:
  No `dart2wasm`, os tipos SIMD de `dart:typed_data`
  (`Int32x4`, `Float32x4`, `Float64x2`, `Int32x4List`,
  `Float32x4List` e `Float64x2List`)
  são implementados com as instruções SIMD nativas de 128 bits `v128` do WebAssembly.

### Pacotes suportados {:#supported-packages}

Para encontrar pacotes compatíveis com Wasm,
use o filtro [`wasm-ready`][] no [pub.dev][].

Um pacote é "wasm-ready" se não importa bibliotecas não compatíveis com Wasm,
como `dart:html` ou `dart:js`. Você encontra a lista completa de bibliotecas
não permitidas na [página de interoperabilidade JS][past-js-interop].

[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}

## Compilando sua aplicação web para Wasm {:#compiling-to-wasm}

Use o comando `dart compile wasm` na CLI `dart` para invocar o
compilador Wasm do Dart e do [Flutter][]:

```console
$ dart help compile wasm -v
Compile Dart to a WebAssembly/WasmGC module.

Usage: dart compile wasm [arguments] <dart entry point>
-h, --help                              Print this usage information.
-o, --output                            Write the output to <file name>.
                                        This can be an absolute or relative path.
-v, --verbose                           Print debug output during compilation
    --enable-asserts                    Enable assert statements.
-O, --optimization-level=<level>        Controls optimizations that can help reduce
                                        code-size and improve performance of the
                                        generated code.
                                        [0, 1 (default), 2, 3, 4]
    --[no-]minify                       Minify names that are needed at runtime (such
                                        as class names). Affects e.g.
                                        `<obj>.runtimeType.toString()`). If passed,
                                        this takes precedence over the
                                        optimization-level option.
    --[no-]strip-wasm                   Whether to strip the resulting wasm file of
                                        static symbol names.
                                        (defaults to on)
    --[no-]source-maps                  Generate a source map file.
                                        (defaults to on)
    --[no-]enable-deferred-loading      Emit multiple modules based on the Dart
                                        program's deferred import graph.
    --standalone                        Compile to a WebAssembly module without
                                        JavaScript interop. Dart-specific host
                                        imports are necessary to load these modules.
-D, --define=<key=value>                Define an environment declaration. To specify
                                        multiple declarations, use multiple options
                                        or use commas to separate key-value pairs.
                                        For example: dart compile wasm -Da=1,b=2
                                        main.dart
```

Para compilar e executar uma aplicação web Dart com Wasm, siga estes passos:

1.  Crie uma aplicação web e entre no diretório dela:

    ```console
    $ dart create -t web mywebapp
    $ cd mywebapp
    ```

    O template cria uma pequena aplicação web usando o [`package:web`][],
    que é necessário para executar Wasm.
    Certifique-se de que suas aplicações web foram [migradas][migrated] de `dart:html` para `package:web`.

1.  Compile a aplicação para Wasm em um diretório de saída `site`:

    ```console
    $ dart compile wasm -O2 web/main.dart -o site/main.wasm
    ```

    Isso gera `site/main.wasm`, o runtime JavaScript complementar
    `site/main.mjs` e `site/main.wasm.map`.

    :::note
    Por padrão, o `dart compile wasm` gera um arquivo de source map `.wasm.map`
    junto com a saída `.wasm`.
    Para desabilitar a geração de source maps em builds de produção,
    passe `--no-source-maps`.
    Para conhecer as considerações de segurança ao fazer deploy de source maps,
    veja [Deploy na web][manage-source-maps].
    :::

1.  Copie os arquivos web estáticos:

    ```console
    $ cp web/index.html web/styles.css site/
    ```

1.  Como o `index.html` carrega o `main.dart.js`, crie o `site/main.dart.js`
    para importar o runtime `site/main.mjs` gerado e instanciar
    o `site/main.wasm`:

    ```js title="site/main.dart.js"
    (async function () {
      const { compileStreaming } = await import('./main.mjs');
      const app = await compileStreaming(fetch('main.wasm'));
      const instantiatedApp = await app.instantiate({});
      instantiatedApp.invokeMain();
    })();
    ```

1.  Sirva o diretório `site` usando o [`dhttpd`][]:

    ```console
    $ dart run dhttpd@ --path site
    ```

Você também pode testar este pequeno [exemplo de sandbox][sandbox].

[wasm-org]: https://webassembly.org/
[Flutter]: {{site.flutter}}/wasm
[js-interop]: /interop/js-interop/
[past-js-interop]: /interop/js-interop/past-js-interop#next-generation-js-interop
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[migrated]: /interop/js-interop/package-web/
[`dhttpd`]: {{site.pub-pkg}}/dhttpd
[deferred loading]: /language/libraries#lazily-loading-a-library
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files
[sandbox]: https://github.com/mit-mit/sandbox
