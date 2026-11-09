---
ia-translate: true
title: Skills de pacotes
description: >-
  Aprenda a descobrir, instalar e gerenciar skills de agentes de IA fornecidas
  por pacotes do Dart e do Flutter.
---

Agentes de codificação com IA, como Cursor, Gemini, Claude Code, Cline e Copilot,
ajudam você a escrever, testar e refatorar código Dart.
Para gerar código preciso e idiomático,
esses agentes dependem de contexto sobre as bibliotecas e pacotes
que o seu projeto usa.

**Skills de pacotes** permitem que os autores de pacotes distribuam instruções
padronizadas e ricas em contexto para agentes de IA, diretamente com seus pacotes do pub.
Usando a ferramenta de linha de comando [`package:skills`]({{site.pub-pkg}}/skills)
(invocada como `dart run skills@ <command>`),
você pode descobrir, instalar e atualizar skills para as dependências do seu projeto,
fazendo seus agentes de IA escreverem códigos melhores com menos alucinações.
Para aprender a criar e publicar skills para o seu próprio pacote,
consulte [Distribua skills com pacotes](/tools/pub/package-skills).

## O que são skills de agentes? {:#what-are-agent-skills}

Uma skill de agente é um conjunto estruturado de instruções, exemplos de código
e boas práticas empacotado junto com uma biblioteca.
As skills seguem a [especificação aberta de Agent Skills][agentskills],
que padroniza a forma como os agentes de codificação com IA descobrem e leem instruções.

Uma skill normalmente inclui:

* **Regras de contexto**: orientações sobre padrões de biblioteca, arquitetura
  e antipadrões a evitar.
* **Padrões de código**: exemplos concretos e prontos para copiar e colar de tarefas comuns.
* **Scripts de ferramentas e fluxo de trabalho**: scripts e comandos auxiliares opcionais
  que um agente pode executar para realizar tarefas ou validar código.

As skills ficam armazenadas no diretório de agentes do seu projeto
(como `.agents/skills/`),
onde as ferramentas e os agentes de codificação com IA as descobrem e usam automaticamente.

[agentskills]: https://agentskills.io

## Por que usar skills de pacotes? {:#why-use-package-skills}

Modelos de IA de uso geral são treinados com código público de várias linguagens,
o que significa que eles podem:

* Sugerir APIs obsoletas ou sintaxe desatualizada.
* Deixar de lado convenções arquiteturais específicas de um pacote.
* Inventar APIs que não existem na versão específica que você usa.

Quando você instala skills de pacotes,
seu agente de IA ganha conhecimento imediato e confiável,
escrito e mantido pelos próprios autores dos pacotes.

## Instalar skills das dependências {:#install-skills-for-dependencies}

Para instalar e atualizar as skills fornecidas pelas dependências do seu projeto,
use `dart run skills@ get`:

```console
$ dart run skills@ get
```

Ao ser executada em um diretório de projeto,
a ferramenta analisa suas dependências diretas no `pubspec.yaml`
em busca de pacotes que disponibilizam um diretório `skills/`,
e pede que você escolha quais skills instalar:

```console
Scanning dependencies for available skills...
? Select skills to install:
  [x] shelf: routing - Define and handle HTTP routes
  [ ] shelf: middleware - Add logging and CORS middleware
  [x] dio: error-handling - Configure retry interceptors
```

Use as setas do teclado e a barra de espaço para selecionar skills individualmente,
ou pressione <kbd>Ctrl</kbd>+<kbd>A</kbd> para selecionar ou desmarcar todas as skills,
e depois pressione <kbd>Enter</kbd>.

### Instalar skills de um pacote específico {:#install-skills-from-a-specific-package}

Para instalar ou atualizar skills de uma única dependência de pacote,
use a opção `-p` (ou `--package`):

```console
$ dart run skills@ get -p <package_name>
```

### Instalar uma skill específica {:#install-a-specific-skill}

Para instalar uma skill específica pelo nome,
use a opção `-s` (ou `--skill`):

```console
$ dart run skills@ get -p <package_name> -s <skill_name>
```

### Instalar todas as skills sem interação {:#install-all-skills-non-interactively}

Para instalar todas as skills disponíveis de todas as fontes de dependência
sem os prompts interativos, passe a flag `-a` (ou `--all`):

```console
$ dart run skills@ get --all
```

## Instalar skills de um repositório Git {:#install-skills-from-a-git-repository}

Você também pode instalar skills diretamente de qualquer repositório Git
usando `dart run skills@ add`:

```console
$ dart run skills@ add <git_repository_url>
```

Para instalar todas as skills do repositório Git sem perguntar,
adicione a flag `--all`:

```console
$ dart run skills@ add <git_repository_url> --all
```

Depois de adicionado como fonte,
você pode atualizar as skills dos seus repositórios Git configurados a qualquer momento
executando `dart run skills@ get`.

## Estrutura do diretório de skills {:#skill-directory-structure}

Quando você instala skills,
elas são copiadas para o diretório apropriado para o seu agente de codificação com IA
(como `.agents/skills/`):

```plaintext
my_project/
├── .agents/
│   └── skills/
│       ├── shelf-routing/
│       │   └── SKILL.md
│       └── dio-error-handling/
│           ├── SKILL.md
│           └── examples/
├── lib/
├── test/
└── pubspec.yaml
```

Depois de instaladas, as skills ficam imediatamente disponíveis
para o seu agente durante a geração de código, a refatoração e o chat.

### Controle de versão e .gitignore {:#version-control-and-gitignore}

Se você commitar as skills instaladas depende do fluxo de trabalho do seu time:

* **Se você commitar o diretório de skills** (como `.agents/skills/`),
  commite também o diretório `.config/dart_skills/`, para que todos os membros
  do time compartilhem as mesmas definições de skills e o mesmo controle de atualizações.
* **Se você ignorar o diretório de skills**,
  adicione também `.config/dart_skills/` ao `.gitignore`.
  Assim, cada desenvolvedor pode executar `dart run skills@ get` no seu workspace local.

## Atualizar skills instaladas {:#update-installed-skills}

Conforme os pacotes evoluem, os autores atualizam suas skills
com novas boas práticas e mudanças de API.
Para atualizar todas as skills instaladas para as versões mais recentes
das suas dependências, execute:

```console
$ dart run skills@ get
```

### Lidar com modificações locais {:#handle-local-modifications}

Uma grande vantagem das skills de agentes é que você pode editá-las localmente
para personalizar as instruções de acordo com a arquitetura ou o estilo do seu time.

Quando você executa `dart run skills@ get`,
o `package:skills` acompanha as skills instaladas anteriormente e detecta alterações
nos seus arquivos locais antes de atualizar.

Se uma modificação local for detectada:
* O `package:skills` avisa que a skill foi modificada localmente.
* Você é solicitado a escolher entre **sobrescrever** suas alterações locais
  com a versão do autor original ou **manter** suas personalizações.

:::tip
Se você personalizar skills localmente ou criar skills específicas do projeto em
`.agents/skills/`, pode usar o
[`package:skills_lint`]({{site.pub-pkg}}/skills_lint) para verificar se o
frontmatter YAML do seu `SKILL.md`, a estrutura de diretórios e os caminhos relativos
de arquivos continuam válidos. Para configurar e executar o linter, consulte
[Validar e analisar skills](/tools/pub/package-skills#validate-and-lint-skills).
:::

## Gerenciar e remover skills {:#manage-and-remove-skills}

### Listar skills instaladas {:#list-installed-skills}

Para ver todas as skills gerenciadas atualmente instaladas no seu workspace,
execute `dart run skills@ list`:

```console
$ dart run skills@ list
```

### Remover skills de dependências removidas {:#prune-skills-from-removed-dependencies}

Se você remover uma dependência do seu `pubspec.yaml`,
as skills dela podem continuar no diretório de skills do seu agente.
Para remover automaticamente as skills de pacotes que não são mais dependências,
execute `dart run skills@ prune`:

```console
$ dart run skills@ prune
```

### Remover skills específicas {:#remove-specific-skills}

Para remover explicitamente skills gerenciadas do seu workspace,
use `dart run skills@ remove`:

```console
$ dart run skills@ remove -p <package_name>
```

## Pesquisar documentação oficial com o servidor MCP Developer Knowledge {:#search-official-docs-with-the-developer-knowledge-mcp-server}

As skills de pacotes dão ao seu agente contexto confiável
sobre os pacotes de que o projeto depende.
Para dar ao seu agente o mesmo tipo de contexto confiável
sobre a linguagem Dart, as bibliotecas principais e as ferramentas,
conecte-o ao [servidor MCP Developer Knowledge][dk-mcp].
Esse servidor remoto MCP permite que o agente pesquise e recupere
documentação oficial de desenvolvedores do Google, incluindo [dart.dev](/) e
[docs.flutter.dev]({{site.flutter-docs}}), por meio das suas
ferramentas `search_documents`, `get_documents` e `answer_query`.
Ele complementa o [servidor MCP do Dart e Flutter][dart-mcp],
que se concentra no seu projeto local, no SDK e no app em execução.

Para adicioná-lo ao seu agente de codificação, siga as instruções em
[Configure seu IDE ou agente de codificação][dk-mcp-configure]
e selecione o seu cliente.
Para ajudar o agente a decidir quando pesquisar na documentação
e qual ferramenta usar, instale também a skill de agente
[`retrieving-developer-knowledge`][dk-skill].

Com as skills de pacotes e o servidor MCP Developer Knowledge disponíveis,
seu agente pode combinar orientações específicas do pacote
com consultas à documentação oficial em uma única tarefa:

```plaintext
Look up the current dart.dev guidance on null safety and records,
then refactor this `dio` error handler to return a record
instead of throwing.
```

[dk-mcp]: https://developers.google.com/knowledge/mcp
[dk-mcp-configure]: https://developers.google.com/knowledge/mcp#configure-ide
[dk-skill]: https://developers.google.com/knowledge/mcp#agent-skill
[dart-mcp]: {{site.flutter-docs}}/ai/mcp-server

## Links relacionados {:#related-links}

* [Distribua skills com pacotes](/tools/pub/package-skills)
* [`package:skills` no pub.dev]({{site.pub-pkg}}/skills)
* [`package:skills_lint` no pub.dev]({{site.pub-pkg}}/skills_lint)
* [Especificação de Agent Skills][agentskills]
* [Servidor MCP do Dart e Flutter]({{site.flutter-docs}}/ai/mcp-server)
* [Servidor MCP Developer Knowledge][dk-mcp]
