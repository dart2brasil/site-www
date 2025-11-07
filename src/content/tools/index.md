---
ia-translate: true
title: Ferramentas
description: As ferramentas que dão suporte à linguagem Dart.
---

Quando estiver pronto para criar um aplicativo, obtenha o SDK e as
ferramentas para o seu tipo de aplicativo. Se você não tiver certeza
de quais ferramentas precisa, **obtenha o Flutter SDK.**

| Tipo de aplicativo          | Instruções de início                                    | Informações da ferramenta                                    |
|---------------------------|---------------------------------------------------------|-------------------------------------------------------------|
| Flutter (mobile e mais)    | [Instalar o Flutter]({{site.flutter-docs}}/get-started/install) | [Ferramentas Flutter]({{site.flutter-docs}}/using-ide)            |
| Aplicativo Web (não-Flutter) | [Instalar o Dart SDK](/tools/sdk)                         | [Ferramentas de uso geral][] e [ferramentas web](#web)             |
| Servidor ou linha de comando| [Instalar o Dart SDK](/tools/sdk)                         | [Ferramentas de uso geral][] e [ferramentas especializadas](#server) |

{:.table .table-striped}

[Ferramentas de uso geral]: #general-purpose-tools

:::note
  O Flutter SDK inclui o Dart SDK completo.
:::

## Ferramentas de uso geral {:#general-purpose-tools}

As ferramentas a seguir dão suporte à linguagem Dart em todas as plataformas.

* [DartPad](#dartpad)
* [IDEs e editores](#editors)
* [Ferramentas de linha de comando](#cli)


### DartPad {:#dartpad}

<img src="/assets/img/dartpad-hello.png" alt="DartPad Hello World" width="200px" align="right" />

[DartPad](/tools/dartpad) é
uma ótima maneira, sem necessidade de download, para aprender a sintaxe
Dart e para experimentar os recursos da linguagem Dart.
Ele suporta as bibliotecas principais do Dart,
exceto para bibliotecas VM como `dart:io`.

<a id="ides-and-editors"></a>
### IDEs e editores {:#editors}

Existem plugins Dart para essas IDEs comumente usadas.

<ul class="cols2">
<li>
<img src="/assets/img/tools/android_studio.svg" class="list-image" alt="Logo do Android Studio">
<a href="/tools/jetbrains-plugin"><b>Android Studio</b></a>
</li>
<li>
<img src="/assets/img/tools/intellij-idea.svg" class="list-image" alt="Logo do IntelliJ">
<a href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(e outras IDEs JetBrains)</b></a>
</li>
<li>
<img src="/assets/img/tools/vscode.svg" class="list-image" alt="Logo do Visual Studio Code">
<a href="/tools/vs-code"><b>Visual Studio Code</b></a>
</li>
</ul>

Os seguintes plugins Dart também estão disponíveis,
graças à comunidade Dart.

<ul class="cols2">
<li>
<img src="/assets/img/tools/emacs.png" alt="Logo do Emacs" class="list-image">
<a href="https://github.com/nex3/dart-mode"><b>Emacs</b></a>
</li>
<li>
<img src="/assets/img/tools/vim.png" alt="Logo do Vim" class="list-image">
<a href="{{site.repo.dart.org}}/dart-vim-plugin"><b>Vim</b></a>
</li>
<li>
<img src="/assets/img/tools/eclipse-logo.png" alt="Eclipse logo" class="list-image">
<a href="https://github.com/dart4e/dart4e"><b>Eclipse</b></a>
</li>
</ul>

Uma [implementação do Language Server Protocol][LSP] (Protocolo de Servidor de Linguagem) também está disponível para
[editores compatíveis com LSP][] que não possuem extensões Dart específicas.

[LSP]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/tool/lsp_spec/README.md
[editores compatíveis com LSP]: https://microsoft.github.io/language-server-protocol/implementors/tools/

### Ferramentas de linha de comando {:#cli}

O Dart SDK inclui a seguinte ferramenta `dart` de uso geral:

[`dart`](/tools/dart-tool)
: Uma interface de linha de comando (CLI) para criar, formatar, analisar,
  testar, documentar, compilar e executar código Dart,
  assim como trabalhar com o [gerenciador de pacotes pub](/tools/pub/packages).


### Depuração {:#debugging}

[Dart DevTools](/tools/dart-devtools)
: Um conjunto de ferramentas de depuração e desempenho.


## Ferramenta para desenvolver aplicativos web {:#web}

A seguinte ferramenta oferece suporte ao desenvolvimento de aplicativos web:

[`webdev`](/tools/webdev)
: Uma CLI para construir e servir aplicativos web Dart.

## Ferramentas para desenvolver aplicativos de linha de comando e servidores {:#server}

As seguintes ferramentas oferecem suporte ao desenvolvimento ou execução
de aplicativos de linha de comando e servidores:

[`dart run`](/tools/dart-run)
: Use o comando `dart run` para executar aplicativos de linha de comando Dart não compilados
  e alguns tipos de snapshots (instantâneos).

[`dartaotruntime`](/tools/dartaotruntime)
: Use este runtime Dart para executar snapshots AOT.
