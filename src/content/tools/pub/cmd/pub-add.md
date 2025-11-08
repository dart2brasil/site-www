---
title: dart pub add
description: Use dart pub add para adicionar uma dependência.
ia-translate: true
---

_Add_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub add [{dev|override}:]<package>[:descriptor] [[{dev|override}:]<package>[:descriptor] ...] [options]
```

Este comando adiciona os pacotes especificados ao `pubspec.yaml` como dependências,
e depois recupera as dependências para resolver o `pubspec.yaml`.

O seguinte comando de exemplo é equivalente a
editar `pubspec.yaml` para adicionar o pacote `http`,
e depois chamar `dart pub get`:

```console
$ dart pub add http
```

## Restrição de versão

Por padrão, `dart pub add` usa a
versão estável mais recente do pacote do [site pub.dev]({{site.pub}})
que é compatível com suas restrições de SDK e dependências.
Por exemplo, se `0.13.3` é a versão estável mais recente do pacote `http`,
então `dart pub add http` adiciona `http: ^0.13.3`
sob `dependencies` em seu `pubspec.yaml`.

Você também pode especificar uma restrição ou intervalo de restrição:

```console
$ dart pub add foo:2.0.0
$ dart pub add foo:'^2.0.0'
$ dart pub add foo:'>=2.0.0 <3.0.1'
```

Se o pacote especificado for uma dependência existente em seu `pubspec.yaml`,
`dart pub add` atualiza a restrição da dependência
para a especificada no comando.

## Dependência de desenvolvimento

O prefixo `dev:` adiciona o pacote como uma [dependência de desenvolvimento][],
em vez de como uma dependência normal.

[dependência de desenvolvimento]: /tools/pub/dependencies#dev-dependencies

```console
$ dart pub add dev:foo           # adds newest compatible stable version of foo
$ dart pub add dev:foo:^2.0.0    # adds specified constraint of foo
$ dart pub add foo dev:bar       # adds regular dependency foo and dev dependency bar simultaneously
```

_Anteriormente a opção `-d, --dev`_:

```console
$ dart pub add --dev foo
```

## Sobreposição de dependência

Para especificar uma [sobreposição de dependência][], adicione o prefixo `override:` e
inclua uma [restrição de versão](#restrição-de-versão) ou
[descritor de fonte](#descritor-de-fonte).

[sobreposição de dependência]: /tools/pub/dependencies#dependency-overrides

**Por exemplo:** Para sobrepor todas as referências a `package:foo`
para usar a versão `1.0.0` do pacote,
execute o seguinte comando:

```console
$ dart pub add override:foo:1.0.0
```

Isto adiciona a sobreposição ao seu arquivo `pubspec.yaml`:

```yaml
dependency_overrides:
  foo: 1.0.0
```

## Descritor de fonte {:#source-descriptor}

:::version-note
A sintaxe do descritor formatado em YAML foi adicionada no Dart 2.19.
O descritor substitui argumentos como
`--path`, `--sdk`, `--git-<option>`, etc.
Pub ainda oferece suporte a esses argumentos, mas
o método recomendado agora é o descritor YAML.
O descritor e os argumentos substituídos não podem ser usados ​​juntos.
:::

A sintaxe do descritor YAML permite adicionar
múltiplos pacotes de diferentes fontes e
aplicar diferentes opções e restrições a cada um.

```plaintext
$ dart pub add [options] [{dev|override}:]<package>[:descriptor] [[{dev|override}:]<package>[:descriptor] ...]
```

A sintaxe reflete como as dependências são escritas em `pubspec.yaml`.
Siga o mesmo formato incluindo espaços.

```plaintext
"<package>:{<source>: <descriptor>[, <source>: <descriptor>], version: <constraint>}"
```

### `git`

Adiciona uma [dependência git](/tools/pub/dependencies#git-packages).

```console
$ dart pub add "foo:{git: https://github.com/foo/foo}"
```

Você pode especificar o repositório e o branch ou commit, ou a localização exata,
dentro desse repositório:

```console
$ dart pub add "foo:{git:{url: ../foo.git, ref: branch, path: subdir}}"
```

#### `url`

Depende do pacote no repositório Git especificado.

_Anteriormente a opção `--git-url=<git_repo_url>`_:

```console
$ dart pub add http --git-url=https://github.com/my/http.git
```

#### `ref`

Com `url`, depende do branch ou commit especificado de um repositório Git.

_Anteriormente a opção `--git-ref=<branch_or_commit>`_:

```console
$ dart pub add http --git-url=https://github.com/my/http.git --git-ref=tmpfixes
```

#### `path`

Com `url`, especifica a localização de um pacote dentro de um repositório Git.

_Anteriormente a opção `--git-path=<directory_path>`_.

### `hosted`

Adiciona uma [dependência hospedada][] que depende
do servidor de pacotes na URL especificada.

```console
$ dart pub add "foo:{hosted: my-pub.dev}"
```

_Anteriormente a opção `--hosted-url=<package_server_url>`_.

[dependência hospedada]: /tools/pub/dependencies#hosted-packages

### `path`

Adiciona uma [dependência de caminho][] em um pacote armazenado localmente.

```console
$ dart pub add "foo:{path: ../foo}"
```

_Anteriormente a opção `--path=<directory_path>`_.

[dependência de caminho]: /tools/pub/dependencies#path-packages

### `sdk`

Adiciona um pacote da fonte de SDK especificada.

```console
$ dart pub add "foo:{sdk: flutter}"
```

_Anteriormente a opção `--sdk=<sdk_name>`_:

```console
$ dart pub add foo --sdk=flutter
```

## Opções

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

:::note
A sintaxe anterior de `pub add` para opções
(sem descritores YAML) aplica as
opções especificadas a todos os pacotes
incluídos em uma invocação do comando.
Por exemplo, `dart pub add test http --dev`
adicionará tanto o pacote `test` quanto o pacote `http`
como dependências de desenvolvimento.
:::

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run`

Relata quais dependências mudariam,
mas não altera nenhuma.

### `--[no-]precompile`

Por padrão, pub pré-compila executáveis
em dependências imediatas (`--precompile`).
Para evitar pré-compilação, use `--no-precompile`.

## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces), `dart pub add` adicionará
dependências apenas ao pacote no diretório atual.

{% render 'pub-problems.md' %}
