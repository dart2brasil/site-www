---
ia-translate: true
title: "package:skills"
description: Ferramenta de linha de comando para gerenciar skills de agentes de IA em projetos Dart.
---

O pacote [`package:skills`]({{site.pub-pkg}}/skills) oferece
ferramentas de linha de comando para descobrir, instalar e gerenciar skills de agentes de IA
para projetos Dart e Flutter.

Uma skill de agente é um conjunto estruturado de instruções, exemplos de código
e boas práticas que segue a [especificação Agent Skills][agentskills].
Quando instalada no seu workspace,
agentes de codificação com IA, como Cursor, Gemini, Claude Code, Cline e Copilot,
usam essas skills para escrever código preciso
e idiomático, adaptado às suas dependências.

## Executando o package:skills {:#running-packageskills}

Você executa o `package:skills` com a sintaxe `dart run skills@ <command>`:

```console
$ # From the root of your Dart or Flutter project:
$ dart run skills@ get
```

Para ver todos os comandos e flags disponíveis, execute `dart run skills@ --help`.

## Comandos integrados {:#built-in-commands}

O pacote `package:skills` inclui os seguintes comandos:

get
: Descobre e instala as skills fornecidas pelas dependências listadas no `pubspec.yaml`.
  Em [workspaces](/tools/pub/workspaces) e monorepos,
  `dart run skills@ get` descobre e instala skills
  em todos os pacotes do workspace.
  Oferece seleção interativa (<kbd>Ctrl</kbd>+<kbd>A</kbd> para alternar todas),
  instalação de todas as skills sem perguntar (`--all`)
  ou a escolha de pacotes e skills específicos (`-p <package>`, `-s <skill>`):

  ```console
  $ dart run skills@ get
  ```

add
: Adiciona um repositório Git externo como fonte de skills e instala as skills dele:

  ```console
  $ dart run skills@ add <git_repository_url>
  ```

create
: Cria a estrutura e o template de uma nova skill para autores de pacotes:

  ```console
  $ dart run skills@ create -n <skill_name> -d "<skill_description>"
  ```

list
: Exibe todas as skills gerenciadas que estão instaladas no seu workspace:

  ```console
  $ dart run skills@ list
  ```

prune
: Remove automaticamente as skills de pacotes
  que não estão mais listados como dependências no `pubspec.yaml`:

  ```console
  $ dart run skills@ prune
  ```

remove
: Remove skills gerenciadas de forma interativa,
  ou escolhe pacotes e skills específicos (`-p <package>`, `-s <skill>`):

  ```console
  $ dart run skills@ remove
  ```

## Mais informações {:#more-information}

Para saber mais sobre os fluxos de trabalho com package skills, veja:

* [Guia do usuário de package skills](/ai/package-skills)
  (instalando e usando skills nos seus fluxos de desenvolvimento)
* [Distribua skills com pacotes](/tools/pub/package-skills)
  (criando e publicando skills com seus pacotes)
* [`package:skills` no pub.dev]({{site.pub-pkg}}/skills)
* [Especificação Agent Skills][agentskills]

[agentskills]: https://agentskills.io
