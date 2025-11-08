---
ia-translate: true
title: "Compilação WebAssembly (Wasm)"
description: Aprenda como compilar seu aplicativo web Dart para WebAssembly.
---

A equipe do Dart está animada para adicionar
[WebAssembly](https://webassembly.org/) como um destino (target) de compilação ao construir
aplicativos Dart e [Flutter][] para a web.

O desenvolvimento do suporte ao WebAssembly continua em andamento,
o que potencialmente resultará em mudanças frequentes.
Revisite esta página para obter as atualizações mais recentes.

:::note
**O suporte para Wasm agora está na versão estável!**

O suporte a WebAssembly para Dart web está disponível no
[canal](/get-dart#release-channels) *estável* do Dart.
:::

## Suporte ao WebAssembly {:#webassembly-support}

A versão atual da compilação Dart para WebAssembly tem uma série de
restrições:

1. Ele tem como destino o WebAssembly com *Garbage Collection* ([WasmGC][]),
    portanto, nem todos os navegadores são suportados atualmente.
    A lista atual de navegadores está disponível na [documentação do Flutter][Flutter].

1. A saída Wasm compilada atualmente tem como destino ambientes JavaScript
    (como navegadores) e, portanto, atualmente não suporta execução em
    *run-times* (tempos de execução) Wasm padrão como wasmtime e wasmer. Para detalhes, veja
    [problema nº 53884]({{site.repo.dart.sdk}}/issues/53884).

1. Apenas o
    [mecanismo de interoperabilidade JS de próxima geração](/interop/js-interop/) do Dart
    é suportado ao compilar para Wasm.

1. Atualmente, não há suporte na ferramenta `webdev` para executar
    (`webdev serve`) ou construir (`webdev build`). As etapas abaixo
    contêm uma solução alternativa temporária. Para detalhes, veja
    [problema 2206 do webdev]({{site.repo.dart.org}}/webdev/issues/2296).

### Pacotes suportados {:#supported-packages}

Para encontrar pacotes compatíveis com Wasm,
use o filtro [`wasm-ready`][] em [pub.dev][].

Um pacote é "wasm-ready" se não importar bibliotecas não compatíveis com Wasm
como `dart:html`, `dart:js`, etc. Você pode encontrar a lista completa de bibliotecas não permitidas
na [página de interoperabilidade JS](/interop/js-interop/#next-generation-js-interop).

[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}

## Compilando seu aplicativo web para Wasm {:#compiling-to-wasm}

Nós implementamos suporte no `dart` CLI para invocar o
compilador Wasm em Dart e [Flutter][]:

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

A compilação Wasm está disponível na versão estável, mas ainda em pré-visualização.
Enquanto continuamos otimizando as ferramentas para melhorar a experiência do desenvolvedor,
você pode tentar compilar o Dart para Wasm hoje
seguindo as etapas temporárias descritas aqui:

1. Comece com um aplicativo web: `dart create -t web mywebapp`

    O modelo cria um pequeno aplicativo web usando [`package:web`][],
    que é necessário para executar o Wasm.
    Certifique-se de que seus aplicativos web foram [migrados][] de `dart:html` para `package:web`.

1. Compile com Wasm para um novo diretório de saída `site`: `mywebapp$ dart compile wasm web/main.dart -o site/main.wasm`

1. Copie os arquivos web: `cp web/index.html web/styles.css site/`

1. Crie um arquivo de *bootstrap* (inicialização) JS para carregar o código Wasm:

    Adicione um novo arquivo `site/main.dart.js` e preencha-o com o conteúdo
    deste [exemplo `main.dart.js`](https://gist.github.com/mit-mit/0fcb1247a9444b0cadf611aa5fc6f32e).

1. Sirva a saída: `dart pub global run dhttpd` ([docs][dhttpd])

Você também pode experimentar este pequeno exemplo [aqui](https://github.com/mit-mit/sandbox).

[WasmGC]: https://developer.chrome.com/blog/wasmgc/
[Flutter]: {{site.flutter}}/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop
[migrados]: /interop/js-interop/package-web/
[dhttpd]: {{site.pub-pkg}}/dhttpd