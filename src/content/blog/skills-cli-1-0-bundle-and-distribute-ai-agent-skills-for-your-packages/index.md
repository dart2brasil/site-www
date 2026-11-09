---
ia-translate: true
title: "Skills CLI 1.0: empacote e distribua skills de agentes de IA para seus pacotes"
description: >-
  Inclua skills oficiais de agentes de IA diretamente nos seus pacotes
  para melhorar a descoberta.
publishDate: 2026-09-08
author: jakemac53
image: images/dart-box-of-skills.webp
category: announcements
layout: blog
---

<DashImage src="images/dart-box-of-skills.webp" alt="Illustration representing package skills in Dart." />

Desde o final de 2025, as [Agent Skills](https://agentskills.io/) vêm mudando
a forma como os usuários dão mais contexto aos seus agentes de IA.
Elas são fáceis de criar
e usam tokens de forma eficiente por meio de divulgação progressiva.
Juntas, essas vantagens reduzem a lacuna do corte de conhecimento,
permitindo que os agentes trabalhem melhor em bases de código,
dependências e ferramentas desconhecidas ou atualizadas.

Hoje, as skills costumam ser compartilhadas por repositórios Git,
o que exige que o desenvolvedor clone e copie os arquivos manualmente
ou use ferramentas como `npx skills`.
Embora o `npx skills` funcione bem, para um fanático por Dart como eu,
exigir Node.js só para rodar uma única ferramenta de linha de comando parece deslocado.
O Dart sempre adotou uma abordagem "batteries-included",
com tudo o que você precisa já incluído no SDK.
Gerenciar skills de IA deveria parecer igualmente nativo.

Mesmo para desenvolvedores que já têm `Node.js` e `npx` instalados,
ainda há falta de descoberta e de suporte a versões de pacotes.
Como garantir que as skills que você usa
correspondam exatamente à versão do pacote no seu projeto?

## Conheça a CLI de skills {:#enter-the-skills-cli}

Para resolver esses dois problemas,
a equipe da [Serverpod](https://serverpod.dev/)
criou a CLI [`skills`](https://pub.dev/packages/skills).
Temos o prazer de anunciar a versão 1.0,
agora mantida e publicada diretamente pela equipe do Dart.

Essa ferramenta é muito mais do que um substituto para o `npx skills`.
A grande novidade é que ela permite que autores de pacotes distribuam skills
**diretamente com o seu pacote**.
Tudo o que eles precisam fazer é colocá-las em um diretório `skills/` de primeiro nível:

```text
my-project/
├── src/
├── skills/      <--- skills
├── pubspec.yaml
└── README.md
```

Recomendamos executar essa ferramenta com a nova sintaxe `dart run skills@`,
que sempre roda a versão mais recente da CLI como uma ferramenta global.
Como alternativa, você pode instalar a ferramenta com `dart install`
(só lembre de atualizá-la periodicamente!).

## Para consumidores de pacotes: instalando skills {:#for-package-consumers-installing-skills}

Para obter skills diretamente das dependências no seu `pubspec.yaml`,
execute o comando `get`:

```bash
# Scans immediate dependencies and discovers available skills.
dart run skills@ get
```

A CLI `skills` analisa as dependências do seu projeto
em busca de diretórios `skills/` empacotados.
Em seguida, ela lista as skills disponíveis
e deixa você escolher quais quer instalar.

As execuções seguintes são incrementais, mostrando apenas as skills novas, atualizadas, removidas
ou ignoradas anteriormente.
Você também pode passar a flag `--all` para instalar todas as skills das dependências de uma vez.

## Para autores de pacotes: distribuindo uma skill {:#for-package-authors-shipping-a-skill}

Autores de pacotes já podem distribuir skills junto com o código.
Para criar uma skill, adicione um diretório dentro de `skills/`
com o prefixo do nome do seu pacote (para evitar colisões),
e inclua um arquivo de instruções `SKILL.md`.
Isso segue o layout padrão do [Agent Skills](https://agentskills.io/).

Por exemplo, um pacote chamado `networking` pode impor o uso correto da API
com a seguinte estrutura:

````markdown
---
name: networking-error-handling
description: >-
  Use when the user is making network requests using the networking APIs
  to ensure safe patterns.
---

# Networking Error Handling

## Guidelines

- Operations must always be wrapped in a try/catch block.
- You must catch `NetworkException` specifically
  to handle retries and log diagnostics.
- Provide fallback UI state in the event of a timeout.

## Examples

```dart
try {
  final response = await NetworkingClient.fetchData();
} on NetworkException catch (e) {
  Logger.log(e.context);
  return FallbackData();
}
```
````

## Instalando a partir do git com o comando `add` {:#install-from-git-with-the-add-command}

Embora puxar skills diretamente das suas dependências seja prático,
já existe um ecossistema inteiro
de compartilhamento de skills por repositórios do GitHub.
Eles podem nem estar associados diretamente a pacotes Dart ou Flutter.
A CLI `skills` também oferece suporte à instalação explícita de skills de qualquer repositório Git
pelo comando `add`:

```bash
# Install universally applicable skills from a Git repository
dart run skills@ add https://github.com/my-org/custom-ai-skills.git
```

Você pode instalar qualquer skill encontrada em [skills.sh](https://skills.sh),
um agregador popular de skills,
simplesmente substituindo o comando `npx skills` por `dart run skills@`.

Isso permite que equipes componham suas instruções a partir de várias fontes,
incluindo dependências Dart e repositórios externos,
tudo gerenciado por uma única ferramenta.

## Experimente as skills hoje {:#try-skills-today}

Estamos animados para ver como a CLI `skills`
simplifica o desenvolvimento de Dart e Flutter com IA!

Aqui está um resumo rápido:

- **Autores de pacotes:**
  adicionem arquivos `skills/<package_name>-<skill-name>/SKILL.md`
  ao repositório do seu pacote.
- **Consumidores de pacotes:**
  rodem `dart run skills@ get` na raiz do projeto
  para descobrir e instalar as skills disponíveis nas suas dependências.

Um enorme obrigado à Serverpod pela implementação inicial,
e a todos os primeiros adotantes que estão moldando esses fluxos de trabalho agentic conosco!
Se você tiver feedback ou encontrar algum problema,
avise abrindo uma issue no repositório
[dart-lang/ai](https://github.com/dart-lang/ai/issues?q=is%3Aissue+is%3Aopen+label%3Apackage%3Askills).

Para saber mais e explorar skills em ação:

* **Documentação**:
  leia o [guia de skills de pacotes](/ai/package-skills)
  ou a
  [documentação de skills de pacotes do Flutter](https://docs.flutter.dev/ai/package-skills).
* **Autores de pacotes**:
  siga nosso guia sobre como
  [distribuir skills com pacotes](/tools/pub/package-skills).
* **Ferramenta de CLI**:
  veja o [package:skills no pub.dev](https://pub.dev/packages/skills).
* **Exemplos**: veja skills já distribuídas em pacotes como
  [Jaspr](https://github.com/schultek/jaspr/tree/main/packages/jaspr),
  [Serverpod](https://github.com/serverpod/serverpod/tree/main/packages/serverpod),
  [Flutter Scene](https://github.com/bdero/flutter_scene/tree/master/packages/flutter_scene/skills)
  e [GenUI](https://github.com/flutter/genui/tree/main/packages/genui).
