---
ia-translate: true
title: Distribua skills com pacotes
description: >-
  Aprenda a criar, estruturar, testar e publicar skills para agentes de IA
  com os seus pacotes Dart e Flutter.
---

Quando desenvolvedores usam o seu pacote Dart ou Flutter,
os agentes de IA de programação deles,
como Cursor, Gemini, Claude Code, Cline e Copilot,
dependem de contexto para escrever código correto e idiomático.

Ao distribuir **skills para agentes** diretamente com o seu pacote,
você fornece aos agentes de IA instruções autoritativas,
exemplos de código
e boas práticas feitos sob medida para as APIs da sua biblioteca.
Para saber como os desenvolvedores instalam e usam skills nos seus projetos,
veja [Skills de pacotes](/ai/package-skills).

## Por que distribuir skills com o seu pacote? {:#why-ship-skills-with-your-package}

Sem skills,
os agentes de IA de programação costumam adivinhar APIs,
sugerir métodos descontinuados
ou deixar passar padrões de arquitetura específicos da sua biblioteca.
Quando você publica skills junto com o seu pacote:

* **Menos erros dos desenvolvedores**: os agentes geram código funcional
  e idiomático já na primeira tentativa.
* **Menos carga de suporte**: armadilhas comuns de configuração e antipadrões
  são evitados de antemão.
* **Instalação simples**: os consumidores do seu pacote podem instalar as suas skills
  com um único comando: `dart run skills@ get`.

## Planeje as skills do seu pacote {:#plan-your-package-skills}

Uma skill de pacote é um conjunto de diretrizes e exemplos
que ensina um agente de IA a usar uma parte específica da sua biblioteca.
Ao planejar skills para o seu pacote:

* **Foque nos fluxos de trabalho comuns**: crie skills para tarefas principais,
  como configuração inicial, roteamento, autenticação, tratamento de erros
  ou otimização de performance.
* **Mantenha as skills modulares**: crie skills separadas e focadas
  para áreas de funcionalidade distintas
  (por exemplo, `my_package-routing` e `my_package-auth`)
  em vez de agrupar tudo em uma única skill grande.
* **Escreva instruções prescritivas**: use regras diretas e sem ambiguidade
  (como "Sempre inicialize X antes de chamar Y")
  em vez de explicações abertas.

## Configure a estrutura de diretórios {:#set-up-the-directory-structure}

Para fornecer skills no seu pacote,
crie um diretório `skills/` de nível superior na raiz do seu pacote,
ao lado de `lib/` e `pubspec.yaml`:

```plaintext
my_package/
├── lib/
├── skills/
│   ├── my_package-routing/
│   │   ├── SKILL.md
│   │   ├── scripts/       # Optional helper scripts
│   │   ├── references/    # Optional reference docs
│   │   └── assets/        # Optional static resources
│   └── my_package-testing/
│       └── SKILL.md
└── pubspec.yaml
```

Cada subdiretório em `skills/` representa uma única skill
e deve conter um arquivo `SKILL.md` que siga a
[especificação aberta de Agent Skills][agentskills].

[agentskills]: https://agentskills.io

### Convenções de nomenclatura de skills {:#skill-naming-conventions}

Para evitar colisões de nomes
quando os consumidores instalam skills de várias dependências,
o nome de cada diretório de skill deve começar com o nome do seu pacote
(ou com o nome do pacote com os underscores trocados por hífens),
seguido de um hífen:

| Nome do pacote | Nome do diretório | Válido? |
| :--- | :--- | :--- |
| `shelf` | `shelf-routing` | Sim |
| `my_package` | `my_package-routing` | Sim |
| `my_package` | `my-package-routing` | Sim |
| `my_package` | `routing` | Não (falta o prefixo do pacote) |
| `my_package` | `other_pkg-routing` | Não (prefixo de pacote errado) |

:::note
A ferramenta de instalação `package:skills` valida esse prefixo
e ignora quaisquer skills que não correspondam ao nome do pacote.
:::

## Crie uma skill {:#author-a-skill}

Cada skill é definida em um arquivo `SKILL.md` com frontmatter YAML
e instruções em Markdown.

O template a seguir ilustra a estrutura de um arquivo `SKILL.md`
que você pode personalizar para o seu pacote:

````markdown
---
name: <package_name>-<skill_name>
description: >-
  Use when the user is working with <package_name> APIs to ensure correct
  patterns and error handling.
---

# <Skill Title>

## Guidelines

* Always call `initialize()` before invoking other methods.
* Prefer using `<SpecificException>` over generic `Exception` types.
* Dispose of controllers and streams when they are no longer needed.

## Examples

### Basic setup example

```dart
import 'package:<package_name>/<package_name>.dart';

void main() {
  // Provide clear, idiomatic Dart code snippets for the agent to follow.
}
```
````

### Partes principais de um arquivo de skill {:#key-parts-of-a-skill-file}

Um arquivo `SKILL.md` normalmente tem três partes:

* **Frontmatter YAML (`name`, `description`)**:
  identifica a skill e informa ao agente de IA de programação
  quando ativá-la, com base no prompt do usuário.
* **Diretrizes (Guidelines)**:
  uma lista de regras diretas e prescritivas que descrevem convenções da biblioteca,
  padrões recomendados e antipadrões comuns a evitar.
* **Exemplos (Examples)**:
  trechos de código Dart prontos para copiar e colar, mostrando como implementar tarefas comuns
  com as APIs da sua biblioteca.

## Crie a estrutura de skills pela CLI {:#scaffold-skills-using-the-cli}

Você pode usar a CLI do `package:skills` para criar rapidamente uma nova skill
no seu pacote atual:

```console
$ dart run skills@ create -n <skill_name> -d "<skill_description>"
```

Esse comando gera automaticamente o diretório com o prefixo
e um template inicial de `SKILL.md`.

## Skills de desenvolvimento e skills publicadas {:#development-and-published-skills}

Ao desenvolver o seu pacote,
diferencie as skills usadas internamente no desenvolvimento do pacote
das skills publicadas para os consumidores do seu pacote:

| Diretório | Público | Descrição |
| :--- | :--- | :--- |
| `skills/` | Consumidores do pacote | Skills públicas incluídas no seu pacote e instaladas com `dart run skills@ get`. |
| `.agents/skills/` | Mantenedores do pacote | Skills internas usadas durante o desenvolvimento do repositório. Não são distribuídas aos consumidores. |

## Valide e analise as skills com lint {:#validate-and-lint-skills}

Antes de publicar o seu pacote,
use o [`package:skills_lint`]({{site.pub-pkg}}/skills_lint) para validar as suas
skills contra a [especificação de Agent Skills][agentskills].
O linter verifica o frontmatter YAML do `SKILL.md`, a estrutura de diretórios,
as convenções de nomenclatura de pacotes e os caminhos relativos de arquivos, para manter as
definições das suas skills válidas e prontas para uso pelos assistentes de IA.

Adicione o `skills_lint` às `dev_dependencies` do seu pacote:

```console
$ dart pub add dev:skills_lint
```

### Configure com um agente {:#set-up-with-an-agent}

Depois de adicionar o `skills_lint` como dependência de desenvolvimento, instale as skills
que ele traz com `dart run skills@ get`. Em seguida, forneça ao seu agente de IA de programação o
prompt a seguir:

```text
Use the skills-lint-setup skill to set up skills_lint in this package
so that `dart test` fails when a skill in skills/ is invalid. Then use
the skills-lint-validation skill to run the linter and fix any failures.
```

Para configurar e executar o `skills_lint` manualmente, você pode passar flags
de linha de comando ou criar um arquivo `skills_lint.yaml`.

### Execute com flags de linha de comando {:#run-with-command-line-flags}

Para validar as skills de um diretório, execute o comando a seguir:

```console
$ dart run skills_lint --skills-directory <skills_directory>
```

Substitua `<skills_directory>` pelo caminho do seu diretório de skills,
como `skills/`.

Você pode passar flags adicionais para personalizar a validação. Para todas as flags
disponíveis e as opções de correção automática, execute `dart run skills_lint --help` ou consulte a
[documentação do `package:skills_lint`]({{site.pub-pkg}}/skills_lint).

Por exemplo, para validar o diretório `skills/` do seu pacote com as verificações
de nomenclatura de pacote e de caminhos relativos habilitadas, execute o comando a seguir:

```console
$ dart run skills_lint --skills-directory skills/ --published-skill-name --check-relative-paths
```

### Configure com um arquivo YAML {:#configure-with-a-yaml-file}

Para impor regras consistentes nas execuções locais e na integração contínua (CI)
sem passar flags toda vez, crie um arquivo `skills_lint.yaml` na raiz
do seu pacote.
Comece pela configuração recomendada a seguir e ajuste os caminhos
para o seu pacote:

```yaml
# skills_lint.yaml
skills_lint:
  rules:
    check-relative-paths: error
    check-absolute-paths: error
  directories:
    - path: "skills/"
      rules:
        pub-archive-includes-skill: error
        published-skill-name: error
        check-relative-paths:
          severity: error
          within-skill: true
    # Remove if your package has no .agents/skills/ directory.
    - path: ".agents/skills/"
  individual_skills:
    - path: "my_custom_standalone_skill"
      rules:
        check-trailing-whitespace: warning
```

Depois de adicionar o arquivo `skills_lint.yaml`, execute o linter sem argumentos:

```console
$ dart run skills_lint
```

Consulte a [documentação do `package:skills_lint`]({{site.pub-pkg}}/skills_lint)
para detalhes sobre a [precedência de regras]({{site.pub-pkg}}/skills_lint#rule-precedence),
as [regras integradas]({{site.pub-pkg}}/skills_lint#built-in-rules)
e a [criação de regras personalizadas]({{site.pub-pkg}}/skills_lint#3-custom-rules).

### Automatize a análise com `dart test` {:#automate-linting-with-dart-test}

Para detectar skills inválidas automaticamente durante as execuções de testes locais e no seu
fluxo de CI com `dart test` já existente, adicione um teste em `test/` que execute
o `skills_lint` com a sua configuração `skills_lint.yaml` e falhe
quando o linter reportar erros.
Verifique também se a lista `parsingErrors` da configuração carregada está vazia,
porque `validateSkills` retorna `true`
mesmo quando o `skills_lint.yaml` contém erros.

Para fluxos de CI independentes ou hooks de pre-commit do Git, consulte
[Receitas]({{site.pub-pkg}}/skills_lint#recipes)
na documentação do `package:skills_lint`.

## Teste as skills localmente antes de publicar {:#test-skills-locally-before-publishing}

Antes de publicar o seu pacote no pub.dev,
verifique se as suas skills podem ser encontradas e instaladas corretamente:

1. Crie um projeto Dart ou Flutter de exemplo para funcionar como consumidor.
2. No `pubspec.yaml` do projeto de exemplo, adicione uma [dependência de caminho][path dependency]
   apontando para o seu pacote local:

   ```yaml
   dependencies:
     my_package:
       path: ../path/to/my_package
   ```

3. Execute `dart run skills@ get` no projeto de exemplo.
4. Verifique se as suas skills aparecem no prompt de seleção interativo
   e se são instaladas corretamente no diretório `.agents/skills/` do projeto de exemplo.

[path dependency]: /tools/pub/dependencies#path-packages

## Publique no pub.dev {:#publish-on-pub-dev}

Quando você publica o seu pacote com `dart pub publish`,
o diretório `skills/` é incluído automaticamente no arquivo do pacote.
Depois de publicado, os consumidores que dependem do seu pacote podem instalar as suas skills
executando `dart run skills@ get`.

## Boas práticas {:#best-practices}

* **Mantenha as skills focadas**: crie uma skill por área de funcionalidade principal,
  em vez de uma única skill superdimensionada.
* **Escreva para o agente de IA**: use instruções claras e prescritivas.
  Regras diretas (como "Sempre use X antes de chamar Y") são mais eficazes
  do que textos narrativos abertos.
* **Inclua exemplos de código concretos**: mostre trechos de código completos e funcionais
  ilustrando o uso idiomático da API Dart.
* **Mantenha o `SKILL.md` conciso**: mantenha o `SKILL.md` com menos de 500 linhas.
  Coloque materiais de referência extensos, schemas ou tabelas grandes de documentação
  em subdiretórios como `references/` ou `assets/`.
* **Versione as skills junto com o pacote**: ao atualizar as APIs do seu pacote
  em novas versões, atualize as skills para refletir as recomendações mais recentes.

## Links relacionados {:#related-links}

* [`package:skills` no pub.dev]({{site.pub-pkg}}/skills)
* [`package:skills_lint` no pub.dev]({{site.pub-pkg}}/skills_lint)
* [Especificação de Agent Skills][agentskills]
