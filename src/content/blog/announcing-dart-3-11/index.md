---
ia-translate: true
title: "Anunciando o Dart 3.11"
description: "Olá, desenvolvedores Dart! A versão estável mais recente, o Dart 3.11, chegou oficialmente!"
publishDate: 2026-02-11
author: conooi
image: images/129dKLBxAMepAi2od91c3TA.webp
category: releases
layout: blog
---


Esta versão se concentra fortemente em responsividade e melhorias de ferramentas que você vai sentir no seu fluxo de trabalho diário. De um servidor de análise mais inteligente a novas capacidades do cliente pub e suporte aprimorado a IA, o Dart 3.11 foi construído para mantê-lo no fluxo. Continue lendo para saber mais.

<DashImage src="images/129dKLBxAMepAi2od91c3TA.webp" alt="Dart 3.11 release banner with the Dart logo and a bullseye icon." caption="Announcing Dart 3.11" />


## Atualizações da linguagem {:#language-updates}

Nenhuma nova atualização de linguagem nesta versão do Dart.

## Atualizações de ferramentas {:#tools-updates}

### Suporte a MCP e IA no Dart: Package URI {:#dart-mcp-ai-support-package-uri}

Continuamos melhorando o [servidor MCP do Dart e do Flutter](https://docs.flutter.dev/ai/mcp-server) para oferecer melhor suporte a assistentes de codificação com IA.

Adicionamos uma nova ferramenta chamada `read_package_uris` ao servidor MCP. Essa ferramenta permite que agentes de IA (como Cursor, Gemini ou Copilot) leiam as package URIs dos seus projetos e as adicionem ao contexto deles. Isso garante que seu assistente de IA consiga ler, resolver e utilizar corretamente as dependências ao gerar código.

### Servidor de análise {:#analysis-server}

Esta versão inclui diversas melhorias de desempenho no servidor de análise do Dart. O servidor agora usa “dependências refinadas” (fine-grained dependencies), o que o torna mais inteligente ao decidir qual código precisa ser analisado novamente durante as sessões da IDE.

Também melhoramos o desempenho da análise em situações específicas, como a análise de código com ciclos na estrutura de diretórios causados por symlinks, ou árvores profundas com muitos objetos constantes.

O servidor agora armazena em cache os pontos de entrada compilados dos plugins do analyzer, resultando em um tempo de inicialização mais rápido nas sessões da IDE e nos comandos `dart analyze` e `flutter analyze`.

Por fim, aprimoramos o suporte a “dot shorthands” em muitos recursos do servidor de análise, especialmente completion de código, quick fixes e quick assists.

## Atualizações do pub {:#pub-updates}

### Suporte a glob em workspaces do pub {:#glob-support-in-pub-workspaces}

[Workspaces do pub](https://dart.dev/tools/pub/workspaces) agora permitem declarar pacotes usando globs. Isso possibilita incluir facilmente todos os pacotes de um diretório no workspace do pub, sem precisar enumerá-los um a um:

```yaml
# Before
name: workspace
environment:
 sdk: ^3.10.0
workspace:
 - pkg/a
 - pkg/b
 - pkg/c

# After
name: workspace
environment:
 sdk: ^3.11.0
workspace:
 - pkg/* # Adds all packages inside pkg.
```


Nota: para usar este recurso, seu `pubspec.yaml` precisa ter uma versão do Dart 3.11 ou superior.

### GC do cache do pub {:#pub-cache-gc}

O pub sempre armazenou pacotes em um único `PUB_CACHE` global, garantindo que você nunca baixe o mesmo pacote duas vezes. No entanto, como o pub não rastreava quais projetos usavam o cache, não havia como saber quais pacotes estavam desatualizados, e as versões de pacotes se acumulavam com o tempo. Até agora, a única solução era apagar o cache inteiro e começar do zero.

A partir do Dart 3.9, o `pub get` passou a armazenar, dentro do cache, o caminho do projeto resolvido. Agora, no Dart 3.11, apresentamos o comando `pub cache gc`, que percorre todos os projetos “vivos”, marca todas as versões de pacotes de que eles dependem e apaga o resto. Isso pode ajudar você a recuperar espaço valioso em disco.

```bash
> dart pub cache gc
Found 3 active projects:
* /home/yourusername/projects/pub
* /home/yourusername/projects/pub-dev
* /home/yourusername/projects/pana
All other projects will need to run `dart pub get` again to work correctly.
Will recover 2 GB.
Are you sure you want to continue? (y/N)? y
Deleting unused cache entries... (4.5s)
>
```


## Para encerrar {:#wrap-up}

Isso é tudo para o Dart 3.11! Esta versão é toda sobre os detalhes que fazem diferença no seu desenvolvimento do dia a dia.

Para a lista completa de mudanças, confira o [changelog do SDK do Dart](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md). Como sempre, adoraríamos ouvir seu feedback!
