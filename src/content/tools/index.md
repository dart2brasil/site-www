---
ia-translate: true
title: Ferramentas
description: As ferramentas que suportam a linguagem Dart.
---

Quando você estiver pronto para criar um aplicativo, obtenha o SDK e ferramentas para seu tipo
de aplicativo. Se você não tem certeza de quais ferramentas você precisa, **obtenha o Flutter SDK.**

| Tipo de aplicativo            | Instruções de início                                         | Informações sobre ferramentas                              |
|---------------------------|--------------------------------------------------------------|-----------------------------------------------------------|
| Flutter (mobile e mais) | [Instalar Flutter]({{site.flutter-docs}}/get-started/install) | [Ferramentas Flutter]({{site.flutter-docs}}/using-ide)           |
| Aplicativo web (não-Flutter)     | [Instalar o Dart SDK](/tools/sdk)                           | [Ferramentas de propósito geral][] e [ferramentas web](#web)            |
| Servidor ou linha de comando    | [Instalar o Dart SDK](/tools/sdk)                           | [Ferramentas de propósito geral][] e [ferramentas especializadas](#server) |

{:.table .table-striped}

[General-purpose tools]: #general-purpose-tools
[Ferramentas de propósito geral]: #general-purpose-tools

:::note
  O Flutter SDK inclui o Dart SDK completo.
:::

## Ferramentas de propósito geral

As seguintes ferramentas suportam a linguagem Dart em todas as plataformas.

* [DartPad](#dartpad)
* [IDEs e editores](#editors)
* [Ferramentas de linha de comando](#cli)


### DartPad

<img src="/assets/img/dartpad-hello.png" alt="DartPad Hello World" width="200px" align="right" />

[DartPad](/tools/dartpad) é
uma ótima maneira, sem necessidade de download, de aprender a sintaxe Dart
e experimentar recursos da linguagem Dart.
Ele suporta as bibliotecas principais do Dart,
exceto bibliotecas de VM como `dart:io`.


<a id="ides-and-editors"></a>
### IDEs e editores {:#editors}

Plugins Dart existem para essas IDEs comumente usadas.

<ul class="cols2">
<li>
<img src="/assets/img/tools/android_studio.svg" class="list-image" alt="Android Studio logo">
<a href="/tools/jetbrains-plugin"><b>Android Studio</b></a>
</li>
<li>
<img src="/assets/img/tools/intellij-idea.svg" class="list-image" alt="IntelliJ logo">
<a href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(e outras IDEs JetBrains)</b></a>
</li>
<li>
<img src="/assets/img/tools/vscode.svg" class="list-image" alt="Visual Studio Code logo">
<a href="/tools/vs-code"><b>Visual Studio Code</b></a>
</li>
</ul>

Os seguintes plugins Dart também estão disponíveis,
graças à comunidade Dart.

<ul class="cols2">
<li>
<img src="/assets/img/tools/emacs.png" alt="Emacs logo" class="list-image">
<a href="https://github.com/nex3/dart-mode"><b>Emacs</b></a>
</li>
<li>
<img src="/assets/img/tools/vim.png" alt="Vim logo" class="list-image">
<a href="{{site.repo.dart.org}}/dart-vim-plugin"><b>Vim</b></a>
</li>
<li>
<img src="/assets/img/tools/eclipse-logo.png" alt="Eclipse logo" class="list-image">
<a href="https://github.com/dart4e/dart4e"><b>Eclipse</b></a>
</li>
</ul>

Uma [implementação do Language Server Protocol][LSP] também está disponível para
[editores compatíveis com LSP][LSP-capable editors] que não têm extensões específicas do Dart.

[LSP]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/tool/lsp_spec/README.md
[LSP-capable editors]: https://microsoft.github.io/language-server-protocol/implementors/tools/

### Ferramentas de linha de comando {:#cli}

O Dart SDK inclui a seguinte ferramenta `dart` de propósito geral:

[`dart`](/tools/dart-tool)
: Uma interface de linha de comando (CLI) para criar, formatar, analisar,
  testar, documentar, compilar e executar código Dart,
  bem como trabalhar com o [gerenciador de pacotes pub](/tools/pub/packages).


### Depuração

[Dart DevTools](/tools/dart-devtools)
: Um conjunto de ferramentas de depuração e desempenho.


## Ferramenta para desenvolver aplicativos web {:#web}

A seguinte ferramenta suporta o desenvolvimento de aplicativos web:

[`webdev`](/tools/webdev)
: Uma CLI para construir e servir aplicativos web Dart.

## Ferramentas para desenvolver aplicativos de linha de comando e servidores {:#server}

As seguintes ferramentas suportam o desenvolvimento ou execução de
aplicativos de linha de comando e servidores:

[`dart run`](/tools/dart-run)
: Use o comando `dart run` para executar aplicativos Dart de linha de comando não compilados
  e alguns tipos de snapshots.

[`dartaotruntime`](/tools/dartaotruntime)
: Use este runtime Dart para executar snapshots AOT.
