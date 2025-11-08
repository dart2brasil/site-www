---
ia-translate: true
title: Ferramentas
description: As ferramentas que suportam a linguagem Dart.
---

Quando estiver pronto para criar uma aplicação, obtenha o SDK e as ferramentas para o seu tipo de aplicação. Se não tiver certeza de quais ferramentas precisa, **obtenha o Flutter SDK.**

| Tipo de aplicação         | Instruções de início                                         | Informações sobre ferramentas                              |
|---------------------------|--------------------------------------------------------------|------------------------------------------------------------|
| Flutter (mobile e mais)   | [Instalar Flutter]({{site.flutter-docs}}/get-started/install) | [Ferramentas Flutter]({{site.flutter-docs}}/using-ide)    |
| Aplicação web (não-Flutter) | [Instalar o Dart SDK](/tools/sdk)                          | [Ferramentas de uso geral][General-purpose tools] e [ferramentas web](#web) |
| Servidor ou linha de comando | [Instalar o Dart SDK](/tools/sdk)                        | [Ferramentas de uso geral][General-purpose tools] e [ferramentas especializadas](#server) |

{:.table .table-striped}

[General-purpose tools]: #general-purpose-tools

:::note
  O Flutter SDK inclui o Dart SDK completo.
:::

## Ferramentas de uso geral {:#general-purpose-tools}

As seguintes ferramentas suportam a linguagem Dart em todas as plataformas.

* [DartPad](#dartpad)
* [IDEs e editores](#editors)
* [Ferramentas de linha de comando](#cli)


### DartPad

<img src="/assets/img/dartpad-hello.png" alt="DartPad Hello World" width="200px" align="right" />

O [DartPad](/tools/dartpad) é
uma ótima maneira de aprender a sintaxe do Dart, sem necessidade de download,
e de experimentar os recursos da linguagem Dart.
Ele suporta as bibliotecas principais do Dart,
exceto bibliotecas de VM como `dart:io`.


<a id="ides-and-editors"></a>
### IDEs e editores {:#editors}

Existem plugins Dart para estas IDEs comumente usadas.

<ul class="cols2">
<li>
<img src="/assets/img/tools/android_studio.svg" class="list-image" alt="Android Studio logo">
<a href="/tools/jetbrains-plugin"><b>Android Studio</b></a>
</li>
<li>
<img src="/assets/img/tools/intellij-idea.svg" class="list-image" alt="IntelliJ logo">
<a href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(and other JetBrains IDEs)</b></a>
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
[editores compatíveis com LSP][LSP-capable editors] que não possuem extensões específicas do Dart.

[LSP]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/tool/lsp_spec/README.md
[LSP-capable editors]: https://microsoft.github.io/language-server-protocol/implementors/tools/

### Ferramentas de linha de comando {:#cli}

O Dart SDK inclui a seguinte ferramenta `dart` de uso geral:

[`dart`](/tools/dart-tool)
: Uma interface de linha de comando (CLI) para criar, formatar, analisar,
  testar, documentar, compilar e executar código Dart,
  além de trabalhar com o [gerenciador de pacotes pub](/tools/pub/packages).


### Depuração

[Dart DevTools](/tools/dart-devtools)
: Um conjunto de ferramentas de depuração e desempenho.


## Ferramenta para desenvolver aplicações web {:#web}

A seguinte ferramenta suporta o desenvolvimento de aplicações web:

[`webdev`](/tools/webdev)
: Uma CLI para construir e servir aplicações web Dart.

## Ferramentas para desenvolver aplicações de linha de comando e servidores {:#server}

As seguintes ferramentas suportam o desenvolvimento ou execução de
aplicações de linha de comando e servidores:

[`dart run`](/tools/dart-run)
: Use o comando `dart run` para executar aplicações Dart de linha de comando não compiladas
  e alguns tipos de snapshots.

[`dartaotruntime`](/tools/dartaotruntime)
: Use este runtime Dart para executar snapshots AOT.
