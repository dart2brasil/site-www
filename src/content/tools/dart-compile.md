---
ia-translate: true
title: dart compile
description: "Ferramenta de linha de comando para compilar código-fonte Dart."
---

Este guia descreve como usar o comando `dart compile`
para compilar um programa Dart para uma plataforma de destino.

## Overview

:::note
Se o seu pacote ou qualquer uma de suas dependências tiver [build hooks](/tools/hooks),
você deve usar o comando [`dart build`](/tools/dart-build).
Os comandos `dart compile exe` e `dart compile aot-snapshot` não
executam build hooks e falharão se hooks estiverem presentes.
:::

Use o comando `dart compile` para compilar
um programa Dart para uma [plataforma de destino](/overview#platform).
A saída—que você especifica usando um subcomando—pode
incluir um [Dart runtime][] ou ser um _módulo_
(também conhecido como _snapshot_).

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
O suporte para cross-compilation Linux ARM64 e x64 foi introduzido no Dart 3.8.

O suporte para Linux ARM e RISCV64 foi introduzido no Dart 3.9.
:::

A tabela a seguir mostra quais sistemas operacionais host de 64 bits suportam
cross-compilation para quais destinos:

{% assign y = '<span class="material-symbols system-support" title="Supported" aria-label="Supported">done</span>' %}

| 64-bit host OS | Linux ARM | Linux ARM64 | Linux RISCV64 | Linux x64 |
|----------------|-----------|-------------|---------------|-----------|
| Linux          |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |
| macOS          |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |
| Windows        |   {{y}}   |    {{y}}    |    {{y}}      |    {{y}}  |

{:.table .table-striped .nowrap}

Para usar cross-compilation, inclua as seguintes flags:

`--target-os=linux`
: O sistema operacional de destino para o executável compilado.
  Apenas o sistema operacional Linux é suportado no momento.

`--target-arch=value`
: A arquitetura de destino para o executável compilado.
  O valor para esta flag pode ser:

  - `arm`: processador ARM de 32 bits
  - `arm64`: processador ARM de 64 bits
  - `riscv64`: processador RISC-V de 64 bits (RV64GC)
  - `x64`: processador x86-64

O comando a seguir demonstra como fazer cross-compile de um
executável independente para um sistema Linux de 64 bits:

```console
dart compile exe \
  --target-os=linux \
  --target-arch=x64 \
  hello.dart
```

Internamente, este comando baixa binários adicionais do Dart SDK e
os armazena em cache no diretório `~/.dart`.

Aqui está uma saída de exemplo com a flag `--verbose` especificada
no comando:

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

#### Limitações conhecidas {: #known-limitations }

O subcomando `exe` tem as seguintes limitações conhecidas:

* Sem suporte para `dart:mirrors` e `dart:developer`.
  Para uma lista completa das bibliotecas principais que você pode usar,
  consulte as tabelas de bibliotecas [Multi-platform][] e [Native platform][].

* Cross-compilation é suportada, mas o sistema operacional de destino é limitado ao Linux.
  Para saber mais, confira [Cross-compilation][].

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

Compile seu aplicativo e defina o arquivo de saída:

```console
$ dart compile aot-snapshot bin/myapp.dart
```

Quando bem-sucedido, este comando gera o seguinte:

```console
Generated: /Users/me/myapp/bin/myapp.aot
```

Execute seu aplicativo compilado a partir do diretório `/bin`:

```console
$ dartaotruntime bin/myapp.aot
```

Para saber mais, veja a
[documentação do `dartaotruntime`](/tools/dartaotruntime).

{% comment %}
  TODO: Get info from https://github.com/dart-lang/sdk/wiki/Snapshots
{% endcomment %}

#### Cross-compilation {: #cross-compilation-aot }

O suporte de cross-compilation para o subcomando `aot-snapshot`
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
Não se preocupe com o tamanho das bibliotecas incluídas no seu aplicativo.
O compilador de produção realiza tree shaking para omitir
classes, funções, métodos não utilizados, e assim por diante.
Importe as bibliotecas que você acha que precisará,
e deixe o compilador se livrar do que não for necessário.
:::

Para saber mais sobre como criar e implantar aplicativos JavaScript,
confira [Implantação na Web](/web/deployment).

[webdev]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve
[Dart runtime]: /overview#runtime
