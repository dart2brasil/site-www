---
ia-translate: true
title: dart compile
description: Ferramenta de linha de comando para compilar código-fonte Dart.
---

Este guia descreve como usar o comando `dart compile`
para compilar um programa Dart para uma plataforma de destino.

## Visão geral {:#overview}

:::note
Se o seu pacote ou qualquer uma de suas dependências tiver [build hooks](/tools/hooks),
você deve usar o comando [`dart build`](/tools/dart-build).
Os comandos `dart compile exe` e `dart compile aot-snapshot` não
executam build hooks e falharão se houver hooks presentes.
:::

Use o comando `dart compile` para compilar
um programa Dart para uma [plataforma de destino](/overview#platform).
A saída, que você especifica usando um subcomando, pode
incluir um [Dart runtime][] ou ser um _módulo_
(também conhecido como _snapshot_).

{% render 'tools/dart-tool-note.md' %}

Aqui está um exemplo de uso do subcomando `exe`
para produzir um arquivo executável autocontido (`myapp.exe`):

```console
$ dart compile exe bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.exe
```

O próximo exemplo usa o subcomando `aot-snapshot` para
produzir um módulo compilado ahead-of-time (AOT) (`myapp.aot`).
Em seguida, ele usa o [comando `dartaotruntime`](/tools/dartaotruntime)
(que fornece um [Dart runtime][])
para executar o módulo AOT:

```console
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

Para especificar o caminho do arquivo de saída,
use a opção `-o` ou `--output`:

```console
$ dart compile exe bin/myapp.dart -o bin/runme
```

Para mais opções e informações de uso,
execute `dart compile [<subcommand>] --help`:

```console
$ dart compile exe --help
```

:::note
Você não precisa compilar programas Dart antes de executá-los.
Em vez disso, você pode usar o [comando `dart run`][dart-run],
que usa o compilador JIT (just-in-time) da Dart VM, um
recurso especialmente útil durante o desenvolvimento.
Para mais informações sobre compilação AOT e JIT,
veja a [discussão sobre plataformas](/overview#platform).
:::

Consulte o exemplo [native_app][] para ver um exemplo simples de uso do `dart compile`
para compilar uma aplicação nativa,
seguido de exemplos de execução da aplicação.

[native_app]: {{site.repo.dart.samples}}/tree/main/native_app
[dart-run]: /tools/dart-run

## Subcomandos {:#subcommands}

A tabela a seguir mostra os subcomandos do `dart compile`.

<table class="table table-striped nowrap">
  <tr>
    <th> Subcomando </th> <th> Saída </th> <th> Mais informações </th>
  </tr>
  <tr>
    <td> <code>exe</code> </td>
    <td> Executável <span style="white-space: nowrap">autocontido</span> </td>
    <td> Um arquivo executável independente e específico da arquitetura, contendo o código-fonte
      compilado para código de máquina e um pequeno <a href="/overview#runtime">Dart runtime</a>.
      <br><em><a href="#exe">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td style="white-space: nowrap"> <code>aot-snapshot</code> </td>
    <td style="white-space: nowrap"> Módulo AOT </td>
    <td> Um arquivo específico da arquitetura contendo o código-fonte
      compilado para código de máquina, mas <b>sem Dart runtime</b>.
      <br><em><a href="#aot-snapshot">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>jit-snapshot</code> </td>
    <td> Módulo JIT </td>
    <td> Um arquivo específico da arquitetura com
      uma representação intermediária de todo o código-fonte,
      mais uma representação otimizada do código-fonte
      que foi executado durante uma execução de treinamento do programa.
      O código compilado com JIT pode ter desempenho de pico mais rápido que o código AOT
      se os dados de treinamento forem bons.
      <br><em><a href="#jit-snapshot">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>kernel</code> </td>
    <td> Módulo Kernel </td>
    <td> Uma <a href="{{site.repo.dart.sdk}}/blob/main/pkg/kernel/binary.md">representação intermediária</a>
      portável do código-fonte.
      <br><em><a href="#kernel">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>js</code> </td>
    <td> JavaScript </td>
    <td> Um arquivo JavaScript implantável (<code>.js</code>)
      e um source map (<code>.js.map</code>),
      compilados a partir do código-fonte.
      <br><em><a href="#js">Saiba mais.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>wasm</code> </td>
    <td> WebAssembly </td>
    <td> Um módulo WebAssembly (<code>.wasm</code>),
      um runtime JavaScript complementar (<code>.mjs</code>)
      e um source map (<code>.wasm.map</code>).
      <br><em><a href="#wasm">Saiba mais.</a></em>
    </td>
  </tr>
</table>


## Tipos de saída {:#types-of-output}

As seções a seguir detalham cada tipo de saída
que o `dart compile` pode produzir.


### Executáveis autocontidos (exe) {:#exe}

O subcomando `exe` produz um executável independente para
Windows, macOS ou Linux.
Um **executável independente** é código de máquina nativo compilado a partir
do arquivo Dart especificado e suas dependências,
mais um pequeno [Dart runtime][] que cuida da
verificação de tipos e da coleta de lixo.

Você pode distribuir e executar o arquivo de saída como faria
com qualquer outro arquivo executável.

Compile sua aplicação e defina o arquivo de saída:

```console
$ dart compile exe bin/myapp.dart -o /tmp/myapp
```

Quando bem-sucedido, este comando gera a seguinte saída:

```console
Generated: /tmp/myapp
```

Execute sua aplicação compilada a partir do diretório `/tmp`:

```console
$ ./tmp/myapp
```

<a id="cross-compilation" aria-hidden="true"></a>

#### Cross-compilation {: #cross-compilation-exe }

:::version-note
O suporte à cross-compilation para Linux ARM64 e x64 foi introduzido no Dart 3.8.

O suporte para Linux ARM e RISCV64 foi introduzido no Dart 3.9.
:::

A tabela a seguir mostra quais sistemas operacionais host de 64 bits suportam
cross-compilation para quais alvos:

{% assign y = '<span class="material-symbols system-support" title="Supported" aria-label="Supported">done</span>' %}

| SO host de 64 bits | Linux ARM | Linux ARM64 | Linux RISCV64 | Linux x64 |
|----------------|-----------|-------------|---------------|-----------|
| Linux          |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |
| macOS          |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |
| Windows        |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |

{:.table .table-striped .nowrap}

Para usar a cross-compilation, inclua as seguintes flags:

`--target-os=linux`
: O sistema operacional de destino para o executável compilado.
  Atualmente, apenas o sistema operacional Linux é suportado.

`--target-arch=value`
: A arquitetura de destino para o executável compilado.
  O valor dessa flag pode ser:

  - `arm`: processador ARM de 32 bits
  - `arm64`: processador ARM de 64 bits
  - `riscv64`: processador RISC-V de 64 bits (RV64GC)
  - `x64`: processador x86-64

O comando a seguir demonstra como fazer a cross-compilation de um
executável independente para um sistema Linux de 64 bits:

```console
dart compile exe \
  --target-os=linux \
  --target-arch=x64 \
  hello.dart
```

Internamente, este comando baixa binários adicionais do Dart SDK e
os armazena em cache no diretório `~/.dart`.

Aqui está um exemplo de saída com a flag `--verbose` especificada no
comando:

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

#### Assinatura {:#signing}

Executáveis criados com `dart compile exe`
oferecem suporte a assinatura no macOS e no Windows.

Para saber mais sobre assinatura de código específica de cada plataforma,
consulte a documentação dos sistemas operacionais:

* [Documentação do `SignTool.exe`][`SignTool.exe` documentation] (Windows)
* [Guia de Code Signing da Apple][Apple Code Signing guide]

[`SignTool.exe` documentation]: https://docs.microsoft.com/dotnet/framework/tools/signtool-exe
[Apple Code Signing guide]: {{site.apple-dev}}/support/code-signing/

#### Limitações conhecidas {: #known-limitations }

O subcomando `exe` tem as seguintes limitações conhecidas:

* Não há suporte para `dart:mirrors` e `dart:developer`.
  Para uma lista completa das bibliotecas principais que você pode usar,
  consulte as tabelas de bibliotecas [Multi-platform][] e [Native platform][].

* A cross-compilation é suportada, mas o SO de destino é limitado ao Linux.
  Para saber mais, confira [Cross-compilation][].

[Multi-platform]: /libraries#multi-platform-libraries
[Native platform]: /libraries#native-platform-libraries
[Cross-compilation]: #cross-compilation-exe

### Módulos AOT (aot-snapshot) {:#aot-snapshot}

Use módulos AOT para reduzir os requisitos de espaço em disco ao distribuir
várias aplicações de linha de comando. O subcomando `aot-snapshot` produz um
arquivo de saída específico para a arquitetura atual na qual você compila
sua aplicação.

Por exemplo, se você usar macOS para criar um arquivo `.aot`,
então esse arquivo só poderá ser executado no macOS.
O Dart oferece suporte a módulos AOT no Windows, macOS e Linux.

Compile sua aplicação e defina o arquivo de saída:

```console
$ dart compile aot-snapshot bin/myapp.dart
```

Quando bem-sucedido, este comando gera a seguinte saída:

```console
Generated: /Users/me/myapp/bin/myapp.aot
```

Execute sua aplicação compilada a partir do diretório `/bin`:

```console
$ dartaotruntime bin/myapp.aot
```

Para saber mais, consulte a
[documentação do `dartaotruntime`](/tools/dartaotruntime).

{% comment %}
  TODO: Get info from https://github.com/dart-lang/sdk/wiki/Snapshots
{% endcomment %}

#### Cross-compilation {: #cross-compilation-aot }

O suporte à cross-compilation do subcomando `aot-snapshot`
é o mesmo disponível para o subcomando `exe`.
Para mais informações, consulte
[Executáveis autocontidos (exe)][cross-compile-exe].

[cross-compile-exe]: #cross-compilation-exe

#### Limitações conhecidas {: #known-limitations-aot }

O subcomando `aot-snapshot` tem as mesmas limitações
do subcomando `exe`. Para mais informações, consulte
[Executáveis autocontidos (exe)][known-limitations-exe]

[known-limitations-exe]: #known-limitations

### Módulos JIT (jit-snapshot) {:#jit-snapshot}

Módulos JIT incluem todas as classes analisadas e o código compilado gerado
durante uma execução de treinamento de um programa.

```console
$ dart compile jit-snapshot bin/myapp.dart
Compiling bin/myapp.dart to jit-snapshot file bin/myapp.jit.
Hello world!
$ dart run bin/myapp.jit
Hello world!
```

Ao executar a partir de um módulo de aplicação,
a Dart VM não precisa analisar ou compilar classes e funções que
já foram usadas durante a execução de treinamento,
então a VM começa a executar o código do usuário mais cedo.

Esses módulos são específicos da arquitetura,
ao contrário dos módulos produzidos com o
[subcomando `kernel`](#kernel).


### Módulos portáveis (kernel) {:#kernel}

Use o subcomando `kernel` para empacotar uma aplicação em um
único arquivo portável que
pode ser executado em todos os sistemas operacionais e arquiteturas de CPU.
Um módulo kernel contém uma forma binária da árvore de sintaxe abstrata
([Kernel AST][]) de um programa Dart.

Aqui está um exemplo de criação e execução de um módulo kernel:

```console
$ dart compile kernel bin/myapp.dart
Compiling bin/myapp.dart to kernel file bin/myapp.dill.
$ dart run bin/myapp.dill
```

Embora os módulos kernel tenham um tempo de inicialização menor que o do código Dart,
eles podem ter uma inicialização bem mais lenta do que os formatos de saída AOT específicos da arquitetura.

[Kernel AST]: {{site.repo.dart.sdk}}/blob/main/pkg/kernel/README.md


### JavaScript (js) {:#js}

O subcomando `js` compila código Dart para JavaScript implantável.
Por padrão, o compilador gera tanto o arquivo JavaScript (`.js`)
quanto um arquivo de source map (`.js.map`).

:::note
Use a [ferramenta `webdev`][webdev] em vez de executar diretamente o
compilador de Dart para JavaScript.

* O comando [`webdev build`][] produz, por padrão, JavaScript minificado e implantável.

* O comando [`webdev serve`][] produz, por padrão, módulos JavaScript
  para execução e depuração durante o desenvolvimento.
:::

{% render 'tools/dart-compile-js-options.md', site: site %}

#### Exemplo de compilação de aplicação web {:#compiling-web-app-example}

Por exemplo, para compilar uma aplicação Dart para JavaScript otimizado, execute
o seguinte comando:

```console
$ dart compile js -O2 -o out/main.js web/main.dart
```


#### Melhorando a compilação web para produção {:#helping-generate-efficient-code}

Siga estas práticas para melhorar a inferência de tipos, reduzir o tamanho dos arquivos e
melhorar o desempenho do JavaScript:

* Não use `Function.apply()`.
* Não sobrescreva `noSuchMethod()`.
* Evite definir variáveis como `null`.
* Seja consistente com os tipos dos argumentos
  que você passa para cada função ou método.

:::tip
Não se preocupe com o tamanho das bibliotecas incluídas na sua aplicação.
O compilador de produção faz tree shaking para omitir
classes, funções, métodos e assim por diante que não são usados.
Importe as bibliotecas que você acha que vai precisar,
e deixe o compilador eliminar o que não for necessário.
:::

Para saber mais sobre como construir e implantar aplicações JavaScript,
confira [Web deployment](/web/deployment).


### WebAssembly (wasm) {:#wasm}

O subcomando `wasm` compila código Dart para um módulo WebAssembly/WasmGC.
Por padrão, o compilador gera o módulo `.wasm`,
um arquivo de runtime JavaScript complementar `.mjs`
e um arquivo de source map `.wasm.map`.

Por exemplo, para compilar uma aplicação web Dart para WebAssembly otimizado:

```console
$ dart compile wasm -O2 -o site/main.wasm web/main.dart
```

| Opção | Descrição |
| :--- | :--- |
| `-O<0\|1\|2\|3\|4>` | Controla as otimizações do compilador para tamanho de código e velocidade de compilação (`-O1` é o padrão; `-O2` adiciona minificação; `-O3` omite verificações de tipo implícitas; `-O4` ativa otimizações unsafe mais agressivas). |
| `--[no-]minify` | Minifica nomes de runtime (como nomes de classes). Tem precedência sobre a configuração `-O`. |
| `--[no-]strip-wasm` | Se deve remover a seção de símbolos estáticos `"name"` do binário `.wasm` de saída (ativado por padrão; passe `--no-strip-wasm` para stack traces legíveis em produção). |
| `--[no-]source-maps` | Gera um arquivo de source map `.wasm.map` junto com a saída `.wasm` (ativado por padrão). |
| `--[no-]enable-deferred-loading` | Divide os imports `deferred as` em módulos `.wasm` separados, carregados sob demanda. |
| `--standalone` | Emite um binário `.wasm` independente, sem dependências do runtime JS (não permite `dart:js_interop`). |
| `-D<key>=<value>` | Define declarações de ambiente em tempo de compilação para `String.fromEnvironment`, `bool.fromEnvironment` e `int.fromEnvironment`. |

{:.table .table-striped}

Para detalhes sobre compilar, servir e implantar aplicações Wasm,
consulte [Compilando para WebAssembly][wasm-compilation].
Para saber sobre considerações de segurança ao implantar source maps,
consulte [Web deployment][manage-source-maps].

[webdev]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve
[Dart runtime]: /overview#runtime
[wasm-compilation]: /web/wasm
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files
