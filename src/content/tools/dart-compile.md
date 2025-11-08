---
ia-translate: true
title: dart compile
description: Ferramenta de linha de comando para compilar código-fonte Dart.
---

This guide describes how to use the `dart compile` command
to compile a Dart program to a target platform.

## Overview

:::note
If your package or any of its dependencies has [build hooks](/tools/hooks),
you must use the [`dart build`](/tools/dart-build) command.
The `dart compile exe` and `dart compile aot-snapshot` commands don't
run build hooks, and will fail if hooks are present.
:::

Use the `dart compile` command to compile
a Dart program to a [target platform](/overview#platform).
The output—which you specify using a subcommand—can 
either include a [Dart runtime][] or be a _module_
(also known as a _snapshot_).

{% render 'tools/dart-tool-note.md' %}

Aqui está um exemplo de como usar o subcomando `exe`
para produzir um arquivo executável autocontido (`myapp.exe`):

```console
$ dart compile exe bin/myapp.dart
Gerado: /Users/me/myapp/bin/myapp.exe
```

O próximo exemplo usa o subcomando `aot-snapshot` para
produzir um módulo compilado ahead-of-time (AOT) (`myapp.aot`).
Em seguida, ele usa o comando [`dartaotruntime` command](/tools/dartaotruntime)
(que fornece um [tempo de execução Dart][Dart runtime])
para executar o módulo AOT:

```console
$ dart compile aot-snapshot bin/myapp.dart
Gerado: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

Para especificar o caminho para o arquivo de saída,
use a opção `-o` ou `--output`:

```console
$ dart compile exe bin/myapp.dart -o bin/runme
```

Para mais opções e informações de uso,
execute `dart compile [<subcomando>] --help`:

```console
$ dart compile exe --help
```

:::note
Você não precisa compilar programas Dart antes de executá-los.
Em vez disso, você pode usar o comando [`dart run`][dart-run],
que usa o compilador JIT (just-in-time) da VM Dart—um
recurso que é especialmente útil durante o desenvolvimento.
Para mais informações sobre a compilação AOT e JIT,
veja a [discussão sobre plataformas](/overview#platform).
:::

Consulte o exemplo [native_app][native_app] para um exemplo simples de uso do `dart compile`
para compilar um aplicativo nativo,
seguido por exemplos de execução do aplicativo.

[native_app]: {{site.repo.dart.samples}}/tree/main/native_app
[dart-run]: /tools/dart-run

## Subcomandos {:#subcommands}

A tabela a seguir mostra os subcomandos de `dart compile`.

<table class="table table-striped nowrap">
  <tr>
    <th> Subcomando </th> <th> Saída </th> <th> Mais informações </th>
  </tr>
  <tr>
    <td> <code>exe</code> </td>
    <td> <span style="white-space: nowrap">Autocontido</span> executável </td>
    <td> Um arquivo executável independente e específico da arquitetura contendo o código-fonte
      compilado para código de máquina e um pequeno <a href="/overview#runtime">tempo de execução Dart</a>.
      <br><em><a href="#exe">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td style="white-space: nowrap"> <code>aot-snapshot</code> </td>
    <td style="white-space: nowrap"> Módulo AOT </td>
    <td> Um arquivo específico da arquitetura contendo o código-fonte
      compilado para código de máquina, mas <b>sem tempo de execução Dart</b>.
      <br><em><a href="#aot-snapshot">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>jit-snapshot</code> </td>
    <td> Módulo JIT </td>
    <td> Um arquivo específico da arquitetura com
      uma representação intermediária de todo o código-fonte,
      além de uma representação otimizada do código-fonte
      que foi executado durante uma execução de treinamento do programa.
      O código compilado por JIT pode ter um desempenho de pico mais rápido do que o código AOT
      se os dados de treinamento forem bons.
      <br><em><a href="#jit-snapshot">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>kernel</code> </td>
    <td> Módulo Kernel </td>
    <td> Um
    <a href="{{site.repo.dart.sdk}}/blob/main/pkg/kernel/binary.md">representação intermediária</a>
      portátil do código-fonte.
      <br><em><a href="#kernel">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>js</code> </td>
    <td> JavaScript </td>
    <td> Um arquivo JavaScript implantável,
      compilado a partir do código-fonte.
      <br><em><a href="#js">Saiba mais.</a></em>
    </td>
  </tr>
    <tr>
    <td> <code>wasm</code> </td>
    <td> WebAssembly </td>
    <td> Um formato de instrução binário portátil para uma máquina virtual baseada em pilha.
         Atualmente em desenvolvimento.
      <br><em><a href="/web/wasm">Saiba mais.</a></em>
    </td>
  </tr>
</table>


## Tipos de saída {:#types-of-output}

As seções a seguir têm detalhes sobre cada tipo de saída
que `dart compile` pode produzir.


### Executáveis autocontidos (exe) {:#exe}

O subcomando `exe` produz um executável independente para
Windows, macOS ou Linux.
Um **executável independente** é um código de máquina nativo que é compilado a partir
do arquivo Dart especificado e suas dependências,
mais um pequeno [tempo de execução Dart][Dart runtime] que lida com
verificação de tipo e coleta de lixo.

Você pode distribuir e executar o arquivo de saída como faria
com qualquer outro arquivo executável.

Compile seu aplicativo e defina o arquivo de saída:

```console
$ dart compile exe bin/myapp.dart -o /tmp/myapp
```

Quando bem-sucedido, este comando gera o seguinte:

```console
Gerado: /tmp/myapp
```

Execute seu aplicativo compilado a partir do diretório `/tmp`:

```console
$ ./tmp/myapp
```

<a id="cross-compilation" aria-hidden="true"></a>

#### Cross-compilation {: #cross-compilation-exe }

:::version-note
Support for Linux ARM64 and x64 cross-compilation was introduced in Dart 3.8.

Support for Linux ARM and RISCV64 was introduced in Dart 3.9.
:::

The following table shows which 64-bit host operating systems support
cross-compilation to which targets:

{% assign y = '<span class="material-symbols system-support" title="Supported" aria-label="Supported">done</span>' %}

| 64-bit host OS | Linux ARM | Linux ARM64 | Linux RISCV64 | Linux x64 |
|----------------|-----------|-------------|---------------|-----------|
| Linux          |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |
| macOS          |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |
| Windows        |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |

{:.table .table-striped .nowrap}

To use cross-compilation, include the following flags:

`--target-os=linux`
: The target operating system for the compiled executable.
  Only the Linux operating system is supported at this time.

`--target-arch=value`
: The target architecture for the compiled executable.
  The value for this flag can be:

  - `arm`: 32-bit ARM processor
  - `arm64`: 64-bit ARM processor
  - `riscv64`: 64-bit RISC-V (RV64GC) processor
  - `x64`: x86-64 processor

The following command demonstrates how to cross-compile a
standalone executable for a 64-bit Linux system:

```console
dart compile exe \
  --target-os=linux \
  --target-arch=x64 \
  hello.dart
```

Internally, this command downloads additional Dart SDK binaries and
caches them in the `~/.dart` directory.

Here's a sample output with the `--verbose` flag specified with
the command:

```console
Downloading https://storage.googleapis.com/dart-archive/channels/dev/signed/hash/...4864.../sdk/gen_snapshot_macos_arm64_linux_x64...
Downloading https://storage.googleapis.com/dart-archive/channels/dev/raw/hash/...64e44.../sdk/dartaotruntime_linux_x64...
Specializing Platform getters for target OS linux.
Generating AOT kernel dill.
Compiling /tmp/hello.dart to /tmp/hello.exe using format Kind.exe:
Generating AOT snapshot. path/to/dir/.dart/3.8.0-265.0.dev/gen_snapshot_macos_arm64_linux_x64 []
Generating executable.
Marking binary executable.
Generated: /tmp/hello.exe
```

#### Signing

Os executáveis criados com `dart compile exe`
suportam assinatura no macOS e Windows.

Para saber mais sobre a assinatura de código específica da plataforma,
consulte a documentação da plataforma para esses sistemas operacionais:

* Documentação do Windows [`SignTool.exe`][`SignTool.exe` documentation]
* [Guia de Assinatura de Código da Apple][Apple Code Signing guide]

[`SignTool.exe` documentation]: https://docs.microsoft.com/dotnet/framework/tools/signtool-exe
[Apple Code Signing guide]: {{site.apple-dev}}/support/code-signing/

#### Known limitations {: #known-limitations }

The `exe` subcommand has the following known limitations:

* No support for `dart:mirrors` and `dart:developer`.
  For a complete list of the core libraries you can use,
  reference the [Multi-platform][] and [Native platform][] library tables.

* Cross-compilation is supported, but the target OS is limited to Linux.
  To learn more, check out [Cross-compilation][].

[Multi-platform]: /libraries#multi-platform-libraries
[Native platform]: /libraries#native-platform-libraries
[Cross-compilation]: #cross-compilation-exe

### Módulos AOT (aot-snapshot) {:#aot-snapshot}

Use módulos AOT para reduzir os requisitos de espaço em disco ao distribuir
vários aplicativos de linha de comando. O subcomando `aot-snapshot` produz um
arquivo de saída específico para a arquitetura atual na qual você compila
seu aplicativo.

Por exemplo, se você usar o macOS para criar um arquivo `.aot`,
esse arquivo poderá ser executado somente no macOS.
O Dart oferece suporte a módulos AOT no Windows, macOS e Linux.

Compile your app and set the output file:

```console
$ dart compile aot-snapshot bin/myapp.dart
```

When successful, this command outputs the following:

```console
Generated: /Users/me/myapp/bin/myapp.aot
```

Run your compiled app from the `/bin` directory:

```console
$ dartaotruntime bin/myapp.aot
```

To learn more, see the
[`dartaotruntime` documentation](/tools/dartaotruntime).

{% comment %}
  TODO: Get info from https://github.com/dart-lang/sdk/wiki/Snapshots
{% endcomment %}

#### Cross-compilation {: #cross-compilation-aot }

Cross-compilation support for the `aot-snapshot` subcommand
is the same as what's available for the `exe` subcommand.
For more information, see
[Self-contained executables (exe)][cross-compile-exe].

[cross-compile-exe]: #cross-compilation-exe

#### Known limitations {: #known-limitations-aot }

The `aot-snapshot` subcommand has the same limitations
as the `exe` subcommand. For more information, see
[Self-contained executables (exe)][known-limitations-exe]

[known-limitations-exe]: #known-limitations

### Módulos JIT (jit-snapshot) {:#jit-snapshot}

Os módulos JIT incluem todas as classes analisadas e o código compilado que é
gerado durante uma execução de treinamento de um programa.

```console
$ dart compile jit-snapshot bin/myapp.dart
Compilando bin/myapp.dart para o arquivo jit-snapshot bin/myapp.jit.
Olá Mundo!
$ dart run bin/myapp.jit
Olá Mundo!
```

Ao executar a partir de um módulo de aplicativo,
a VM Dart não precisa analisar ou compilar classes e funções que
já foram usadas durante a execução de treinamento,
então a VM começa a executar o código do usuário mais cedo.

Esses módulos são específicos da arquitetura,
ao contrário dos módulos produzidos usando o
[`kernel` subcomando](#kernel).


### Módulos portáteis (kernel) {:#kernel}

Use o subcomando `kernel` para empacotar um aplicativo em um
único arquivo portátil que
pode ser executado em todos os sistemas operacionais e arquiteturas de CPU.
Um módulo kernel contém uma forma binária da árvore de sintaxe abstrata
([Kernel AST][Kernel AST]) para um programa Dart.

Aqui está um exemplo de criação e execução de um módulo kernel:

```console
$ dart compile kernel bin/myapp.dart
Compilando bin/myapp.dart para o arquivo kernel bin/myapp.dill.
$ dart run bin/myapp.dill
```

Embora os módulos kernel tenham tempo de inicialização reduzido em comparação com o código Dart,
eles podem ter uma inicialização muito mais lenta do que os formatos de saída AOT específicos da arquitetura.

[Kernel AST]: {{site.repo.dart.sdk}}/blob/main/pkg/kernel/README.md


### JavaScript (js) {:#js}

O subcomando `js` compila o código Dart para JavaScript implantável.

:::note
Use a ferramenta [`webdev`][webdev] em vez de executar o
compilador Dart para JavaScript.

* O comando [`webdev build`][`webdev build`], por padrão, produz JavaScript minificado e implantável.

* O comando [`webdev serve`][`webdev serve`], por padrão, produz módulos JavaScript
  para execução e depuração durante o desenvolvimento.
:::

{% render 'tools/dart-compile-js-options.md', site: site %}

#### Exemplo de compilação de aplicativo da web {:#compiling-web-app-example}

Por exemplo, para compilar um aplicativo Dart para JavaScript otimizado, execute
o seguinte comando:

```console
$ dart compile js -O2 -o out/main.js web/main.dart
```


#### Melhorando a compilação da web de produção {:#helping-generate-efficient-code}

Siga estas práticas para melhorar a inferência de tipo, reduzir o tamanho do arquivo e
melhorar o desempenho do JavaScript:

* Não use `Function.apply()`.
* Não sobrescreva `noSuchMethod()`.
* Evite definir variáveis como `null`.
* Seja consistente com os tipos de argumentos
  que você passa para cada função ou método.

:::tip
Don't worry about the size of your app's included libraries.
The production compiler performs tree shaking to omit
unused classes, functions, methods, and so on.
Import the libraries you think you'll need,
and let the compiler get rid of what it doesn't need.
:::

Para saber mais sobre como criar e implantar aplicativos JavaScript,
confira [Implantação na Web](/web/deployment).

[webdev]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve
[Dart runtime]: /overview#runtime
