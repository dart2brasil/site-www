---
ia-translate: true
title: dart pub outdated
description: "Use dart pub outdated para ajudar você a atualizar as dependências do seu pacote."
---

_Outdated_ (Desatualizado) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub outdated [opções]
```

Use `dart pub outdated` para identificar [dependências de pacote][package dependencies]
desatualizadas e obter conselhos sobre como atualizá-las.
As [melhores práticas para gerenciamento de dependências][best practices]
incluem usar as versões de pacote estáveis mais recentes,
para que você possa obter as últimas correções de bugs e melhorias.

## Visão Geral {:#overview}

Veja como você pode usar `dart pub outdated` para ajudá-lo a
atualizar as dependências de um pacote que você possui
(seja um aplicativo ou um pacote regular):

1. Se o seu pacote não tiver um arquivo `pubspec.lock`
   no controle de versão,
   **execute `dart pub get`** no diretório raiz do pacote—o
   diretório que contém o arquivo
   [`pubspec.yaml`](/tools/pub/pubspec) do seu pacote.
2. **Execute `dart pub outdated`**
   para identificar quais dependências de pacote estão desatualizadas.
   Anote os pacotes afetados,
   para que mais tarde você possa testar o comportamento do código que os usa.
3. Siga as recomendações de `dart pub outdated` para atualizar os pacotes.
   Algumas atualizações podem exigir apenas a execução de `dart pub upgrade`.
   Outras podem exigir a atualização do `pubspec.yaml`
   antes de executar `dart pub upgrade`.
4. **Execute `dart pub outdated`** para confirmar que você está usando
   as versões de pacote compatíveis mais recentes.
5. **Teste** seu pacote para confirmar se ele ainda funciona como esperado.

Você ainda pode ter dependências desatualizadas devido a
[dependências transitivas][transitive dependencies].
Se você quiser determinar a causa,
tente executar [`dart pub deps`][`dart pub deps`] e procure na saída o
nome de cada pacote desatualizado.

## Exemplo {:#example}

Aqui está um exemplo de execução de `dart pub outdated` em
um exemplo que possui várias dependências desatualizadas.
Três das dependências (`args`, `http` e `path`) são diretas,
e uma é transitiva (`meta`).
Como o exemplo a seguir mostra,
`dart pub outdated` coloriza a saída por padrão
quando você o executa na linha de comando.

{% render 'tools/pub-outdated-output.html' %}

A coluna **Resolvable** mostra para quais versões você pode atualizar
para cada dependência desatualizada.
Você pode obter mais informações procurando a
**coluna mais à esquerda** com um **valor não vermelho**.
Por exemplo, `args` é _atualizável_ para 1.6.0,
e `http` é _resolvível_ para 0.12.1.
Os pacotes `path` e `meta` não são as versões mais recentes,
mas são as versões _resolvíveis_ mais atuais,
considerando todas as outras dependências.

:::tip
Para ver o que mudou na nova versão de um pacote
que foi publicado em [pub.dev,]({{site.pub}})
consulte o changelog (registro de alterações) na página do pacote.
Por exemplo, você pode consultar as abas **Changelog** nas páginas para os
pacotes [`args`][`args`] e [`http`][`http`].
:::

Para corrigir a primeira dependência (`args`),
que está listada como atualizável,
você só precisa executar `dart pub upgrade`:

```console
$ dart pub upgrade
Resolvendo dependências...
> args 1.6.0 (era 1.4.4)
  ...
Alterada 1 dependência!
```

Para corrigir a segunda dependência (`http`),
que está listada como resolvível,
você pode alterar a entrada `http` do pubspec para usar
a versão na coluna **Resolvable**
(ou uma versão superior compatível).
Na [sintaxe de acento circunflexo][caret syntax], isso é **`^0.12.1`**.
Aqui está o diff (diferença) para `pubspec.yaml`:

```diff
-  http: ^0.11.0
+  http: ^0.12.1
```

Depois de editar `pubspec.yaml`, você executa `dart pub upgrade` para
atualizar o arquivo `pubspec.lock`.
Em seguida, você pode executar `dart pub outdated` para confirmar que
você fez todas as alterações necessárias.
Neste exemplo, os pacotes `path` e `meta` ainda estão desatualizados,
devido a restrições determinadas por outras dependências:

```console
$ dart pub upgrade
...
$ dart pub outdated
Nome do Pacote  Atual  Atualizável  Resolvível  Mais Recente

dependências diretas:
path          1.6.2    1.6.2       1.6.2       1.7.0

dev_dependencies: todas atualizadas

dependências transitivas:
meta          1.1.6    1.1.6       1.1.6       1.1.8

dev_dependencies transitivas: todas atualizadas

As dependências estão todas nas versões resolvíveis mais recentes.
Versões mais recentes, embora disponíveis, não são mutuamente compatíveis.
```

Para ver por que esses pacotes estão desatualizados, você pode executar `dart pub deps`
e procurar por dependências nesses pacotes:

```console
$ dart pub deps -s list
...
dependências:
...
- terminal_tools 0.1.0
  - path 1.6.2
  - meta 1.1.6
...
```

Como a saída anterior mostra,
este pacote depende do pacote `terminal_tools`,
que depende de versões antigas de `path` e `meta`.
Uma vez que o pacote `terminal_tools` seja atualizado,
deve ser possível atualizar este pacote.

:::important
Teste seu código para verificar se ele ainda funciona como esperado
após atualizar os pacotes.
:::


## Colunas de Saída {:#output-columns}

A saída de `dart pub outdated` tem quatro colunas de informações de versão
para cada dependência desatualizada.
Aqui está a parte da saída do [exemplo](#example)
que mostra as quatro colunas de versão:
Atual, Atualizável, Resolvível e Mais Recente.

{% render 'tools/pub-outdated-output-columns.html' %}

Atual
: A versão usada no seu pacote, conforme registrado em `pubspec.lock`.
  Se o pacote não estiver em `pubspec.lock`,
  o valor é `-`.

Atualizável
: A versão mais recente permitida pelo seu arquivo `pubspec.yaml`.
  Esta é a versão para a qual `dart pub upgrade` resolve.
  O valor é `-` se o valor na coluna **Atual** for `-`.

Resolvível
: A versão mais recente que pode ser resolvida,
  quando combinada com todas as outras dependências.
  Esta versão corresponde ao que `dart pub upgrade` fornece
  se todas as restrições de versão em `pubspec.yaml` não estiverem limitadas.
  Um valor de `-` significa que o pacote não será necessário.

Mais Recente
: A versão mais recente do pacote disponível,
  excluindo as versões de pré-lançamento, a menos que você use a opção `--prereleases`.

Por exemplo, digamos que seu aplicativo dependa dos pacotes `foo` e `bar`,
mas a versão mais recente de `bar` permite apenas versões principais mais antigas de `foo`.
O resultado é que a versão _resolvível_ mais recente de `foo`
é diferente da versão _mais recente_ de `foo`.

Quando você edita o arquivo `pubspec.yaml`,
geralmente atualiza as seções **dependencies** e **dev_dependencies**
para que cada pacote use as versões na coluna **Resolvable**.

## Opções {:#options}

Para as opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]dependency-overrides` {:#no-dependency-overrides}

By default, accounts for [`dependency_overrides`][]
when resolving package constraints (`--dependency-overrides`).
To not consider overrides, use `--no-dependency-overrides`.

### `--[no-]dev-dependencies` {:#no-dev-dependencies}

Por padrão, leva em consideração as [dev dependencies] (dependências de desenvolvimento) [dev dependency]
ao resolver restrições de pacote (`--dev-dependencies`).
Para não considerar as dev dependencies, use `--no-dev-dependencies`.

### `--json` {:#json}

Gera a saída no formato JSON.

### `--[no-]prereleases` {:#no-prereleases}

Por padrão, inclui pré-lançamentos
ao determinar as últimas versões do pacote (`--prereleases`).
Para não considerar pré-lançamentos, use `--no-prereleases`.

### `--[no-]transitive` {:#no-transitive}

Por padrão, não inclui [dependências transitivas][transitive dependencies]
como parte da saída (`--no-transitive`).
Para incluir dependências transitivas, use `--transitive`.

### `--[no-]up-to-date` {:#no-up-to-date}

Por padrão, não inclui dependências que
estão na versão mais recente (`--no-up-to-date`).
Para incluir dependências atualizadas, use `--up-to-date`.


## Em um workspace {:#in-a-workspace}

Em um [workspace Pub](/tools/pub/workspaces) `dart pub outdated` lista
todas as dependências

{% render 'pub-problems.md' %}

[`args`]: {{site.pub-pkg}}/args
[best practices]: /tools/pub/dependencies#best-practices
[caret syntax]: /tools/pub/dependencies#version-constraints
[dev dependency]: /tools/pub/dependencies#dev-dependencies
[`dependency_overrides`]: /tools/pub/dependencies#dependency-overrides
[package dependencies]: /tools/pub/dependencies
[`http`]: {{site.pub-pkg}}/http
[`dart pub deps`]: /tools/pub/cmd/pub-deps
[transitive dependencies]: /resources/glossary#transitive-dependency
