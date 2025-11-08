---
title: dart pub outdated
description: Use dart pub outdated para ajudá-lo a atualizar suas dependências de pacotes.
ia-translate: true
---

_Outdated_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub outdated [options]
```

Use `dart pub outdated` para identificar [dependências de pacotes][package dependencies] desatualizadas
e obter conselhos sobre como atualizá-las.
[As melhores práticas de gerenciamento de dependências][best practices]
incluem o uso das versões mais recentes de pacotes estáveis,
para que você possa obter as correções de bugs mais recentes e melhorias.

## Visão geral

Aqui está como você pode usar `dart pub outdated` para ajudá-lo a
atualizar as dependências de um pacote que você possui
(seja um aplicativo ou pacote normal):

1. Se seu pacote não tiver um arquivo `pubspec.lock`
   verificado no controle de origem,
   **execute `dart pub get`** no diretório superior do pacote—o
   diretório que contém o arquivo
   [`pubspec.yaml`](/tools/pub/pubspec) do seu pacote.
2. **Execute `dart pub outdated`**
   para identificar quais dependências de pacotes estão desatualizadas.
   Anote os pacotes afetados,
   para que mais tarde você possa testar o comportamento do código que os usa.
3. Siga as recomendações de `dart pub outdated` para atualizar os pacotes.
   Algumas atualizações podem exigir apenas a execução de `dart pub upgrade`.
   Outras podem exigir a atualização de `pubspec.yaml`
   antes de executar `dart pub upgrade`.
4. **Execute `dart pub outdated`** para confirmar que você está usando
   as versões mais recentes de pacotes compatíveis.
5. **Teste** seu pacote para confirmar que ele ainda funciona conforme esperado.

Você ainda pode ter dependências desatualizadas devido a
[dependências transitivas][transitive dependencies].
Se quiser determinar a causa,
tente executar [`dart pub deps`][] e procure na saída
o nome de cada pacote desatualizado.


## Exemplo

Aqui está um exemplo de execução de `dart pub outdated` em
um exemplo que tem várias dependências desatualizadas.
Três das dependências (`args`, `http` e `path`) são diretas,
e uma é transitiva (`meta`).
Como mostra o exemplo a seguir,
`dart pub outdated` colore a saída por padrão
quando você a executa na linha de comando.

{% render 'tools/pub-outdated-output.html' %}

A coluna **Resolvable** mostra quais versões você pode atualizar para
cada dependência desatualizada.
Você pode obter mais informações procurando pela
**coluna mais à esquerda** com um **valor não vermelho**.
Por exemplo, `args` é _atualizável_ para 1.6.0,
e `http` é _resolvível_ para 0.12.1.
Os pacotes `path` e `meta` não são as versões mais recentes,
mas são as versões mais atuais _resolvíveis_,
considerando todas as outras dependências.

:::tip
Para ver o que mudou na nova versão de um pacote
que é publicado em [pub.dev,]({{site.pub}})
procure o changelog na página do pacote.
Por exemplo, você pode procurar as abas **Changelog** nas páginas dos
pacotes [`args`][] e [`http`][].
:::

Para corrigir a primeira dependência (`args`),
que está listada como atualizável,
você só precisa executar `dart pub upgrade`:

```console
$ dart pub upgrade
Resolving dependencies...
> args 1.6.0 (was 1.4.4)
  ...
Changed 1 dependency!
```

Para corrigir a segunda dependência (`http`),
que está listada como resolvível,
você pode alterar a entrada `http` do pubspec para usar
a versão na coluna **Resolvable**
(ou uma versão superior compatível).
Na [sintaxe de acento circunflexo][caret syntax], isso é **`^0.12.1`**.
Aqui está o diff para `pubspec.yaml`:

```diff
-  http: ^0.11.0
+  http: ^0.12.1
```

Depois de editar `pubspec.yaml`, você executa `dart pub upgrade` para
atualizar o arquivo `pubspec.lock`.
Você pode então executar `dart pub outdated` para confirmar que
você fez todas as alterações necessárias.
Neste exemplo, os pacotes `path` e `meta` ainda estão desatualizados,
devido a restrições determinadas por outras dependências:

```console
$ dart pub upgrade
...
$ dart pub outdated
Package Name  Current  Upgradable  Resolvable  Latest

direct dependencies:
path          1.6.2    1.6.2       1.6.2       1.7.0

dev_dependencies: all up-to-date

transitive dependencies:
meta          1.1.6    1.1.6       1.1.6       1.1.8

transitive dev_dependencies: all up-to-date

Dependencies are all on the latest resolvable versions.
Newer versions, while available, are not mutually compatible.
```

Para ver por que esses pacotes estão desatualizados, você pode executar `dart pub deps`
e procurar dependências nesses pacotes:

```console
$ dart pub deps -s list
...
dependencies:
...
- terminal_tools 0.1.0
  - path 1.6.2
  - meta 1.1.6
...
```

Como mostra a saída anterior,
este pacote depende do pacote `terminal_tools`,
que depende de versões antigas de `path` e `meta`.
Depois que o pacote `terminal_tools` for atualizado,
deve ser possível atualizar este pacote.

:::important
Teste seu código para verificar se ele ainda funciona conforme esperado
depois de atualizar os pacotes.
:::


## Colunas de saída

A saída de `dart pub outdated` tem quatro colunas de informações de versão
para cada dependência desatualizada.
Aqui está a parte da saída do [exemplo](#exemplo)
que mostra as quatro colunas de versão:
Atual, Atualizável, Resolvível e Mais recente.

{% render 'tools/pub-outdated-output-columns.html' %}

Atual
: A versão usada em seu pacote, conforme registrada em `pubspec.lock`.
  Se o pacote não estiver em `pubspec.lock`,
  o valor é `-`.

Atualizável
: A versão mais recente permitida pelo seu arquivo `pubspec.yaml`.
  Esta é a versão que `dart pub upgrade` resolve.
  O valor é `-` se o valor na coluna **Atual** é `-`.

Resolvível
: A versão mais recente que pode ser resolvida,
  quando combinada com todas as outras dependências.
  Esta versão corresponde ao que `dart pub upgrade` oferece a você
  se todas as restrições de versão em `pubspec.yaml` forem ilimitadas.
  Um valor de `-` significa que o pacote não será necessário.

Mais recente
: A versão mais recente do pacote disponível,
  excluindo pré-lançamentos, a menos que você use a opção `--prereleases`.

Por exemplo, digamos que seu aplicativo depende dos pacotes `foo` e `bar`,
mas a versão mais recente de `bar` permite apenas versões principais mais antigas de `foo`.
O resultado é que a versão _resolvível_ mais recente de `foo`
é diferente da versão _mais recente_ de `foo`.

Ao editar o arquivo `pubspec.yaml`,
você geralmente atualiza as seções **dependencies** e **dev_dependencies**
para que cada pacote use as versões na coluna **Resolvível**.

## Opções

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]dependency-overrides`

Por padrão, considera [`dependency_overrides`][]
ao resolver restrições de pacotes (`--dependency-overrides`).
Para não considerar substituições, use `--no-dependency-overrides`.

### `--[no-]dev-dependencies`

Por padrão, considera [dependências de desenvolvimento][dev dependency]
ao resolver restrições de pacotes (`--dev-dependencies`).
Para não considerar dependências de desenvolvimento, use `--no-dev-dependencies`.

### `--json`

Gera saída em formato JSON.

### `--[no-]prereleases`

Por padrão, inclui pré-lançamentos
ao determinar as últimas versões de pacotes (`--prereleases`).
Para não considerar pré-lançamentos, use `--no-prereleases`.

### `--[no-]transitive`

Por padrão, não inclui [dependências transitivas][transitive dependencies]
como parte da saída (`--no-transitive`).
Para incluir dependências transitivas, use `--transitive`.

### `--[no-]up-to-date`

Por padrão, não inclui dependências que
estão na versão mais recente (`--no-up-to-date`).
Para incluir dependências atualizadas, use `--up-to-date`.


## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces), `dart pub outdated` lista
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
