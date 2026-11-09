---
ia-translate: true
title: dart pub add
description: Use dart pub add para adicionar uma dependência.
---

_Add_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub add [{dev|override}:]<package>[:<descriptor>] [[{dev|override}:]<package>[:<descriptor>] ...] [options]
```

Este comando adiciona os pacotes especificados ao `pubspec.yaml` como dependências
e depois recupera as dependências para resolver o `pubspec.yaml`.

O comando de exemplo a seguir é equivalente a
editar o `pubspec.yaml` para adicionar o pacote `http`
e depois chamar `dart pub get`:

```console
$ dart pub add http
```

## Restrição de versão {:#version-constraint}

Por padrão, `dart pub add` usa a
versão estável mais recente do pacote no site [pub.dev]({{site.pub}})
que é compatível com as restrições do seu SDK e com as suas dependências.
Por exemplo, se `0.13.3` é a versão estável mais recente do pacote `http`,
então `dart pub add http` adiciona `http: ^0.13.3`
em `dependencies` no seu `pubspec.yaml`.

Você também pode especificar uma restrição ou um intervalo de restrições:

```console
$ dart pub add foo:2.0.0
$ dart pub add foo:'^2.0.0'
$ dart pub add foo:'>=2.0.0 <3.0.1'
```

Se o pacote especificado já for uma dependência no seu `pubspec.yaml`,
`dart pub add` atualiza a restrição da dependência
para a que foi especificada no comando.

## Dependência de desenvolvimento {:#dev-dependency}

O prefixo `dev:` adiciona o pacote como uma [dependência de desenvolvimento][dev dependency],
em vez de como uma dependência regular.

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```console
$ dart pub add dev:foo           # adds newest compatible stable version of foo
$ dart pub add dev:foo:^2.0.0    # adds specified constraint of foo
$ dart pub add foo dev:bar       # adds regular dependency foo and dev dependency bar simultaneously
```

_Anteriormente, a opção `-d, --dev`_:

```console
$ dart pub add --dev foo
```

## Sobreposição de dependência {:#dependency-override}

Para especificar uma [sobreposição de dependência][dependency override], adicione o prefixo `override:` e
inclua uma [restrição de versão](#version-constraint) ou outro
[descritor de pacote](/tools/pub/dependencies#package-descriptors).

[dependency override]: /tools/pub/dependencies#dependency-overrides

**Por exemplo:** para sobrepor todas as referências a `package:foo`
e usar a versão `1.0.0` do pacote,
execute o seguinte comando:

```console
$ dart pub add override:foo:1.0.0
```

Isso adiciona a sobreposição ao seu arquivo `pubspec.yaml`:

```yaml
dependency_overrides:
  foo: 1.0.0
```

<a id="source-descriptor" aria-hidden="true"></a>

## Descritor de pacote {:#package-descriptor}

Para especificar a versão ou a [fonte da dependência][dependency source] ao adicionar uma dependência,
use a sintaxe de [descritor de pacote][package descriptor] depois do nome do pacote e de dois-pontos.
Por exemplo, o comando a seguir adiciona `package:foo` como uma dependência de desenvolvimento
usando um repositório git como fonte da dependência:

```console
$ dart pub add dev:foo:"{git: https://github.com/foo/foo}"
```

A sintaxe de descritor permite que você
adicione vários pacotes de diferentes fontes como dependências e
aplique opções e restrições diferentes a cada um.

[dependency source]: /tools/pub/dependencies#dependency-sources
[package descriptor]: /tools/pub/dependencies#package-descriptors

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run`

Informa quais dependências mudariam,
mas não altera nenhuma delas.

### `--[no-]precompile`

Por padrão, o pub pré-compila os executáveis
das dependências imediatas (`--precompile`).
Para evitar a pré-compilação, use `--no-precompile`.

### `--[no-]example`

Por padrão, depois de adicionar as dependências especificadas,
o pub também recupera as dependências do
[diretório `example/`][example-dir] do pacote (`--example`).
Para pular a recuperação das dependências de exemplo, use `--no-example`.

[example-dir]: /tools/pub/package-layout#examples

## Em um workspace {:#in-a-workspace}

Em um [workspace do pub](/tools/pub/workspaces), `dart pub add` adiciona
dependências somente ao pacote no diretório atual.

{% render 'pub-problems.md' %}
