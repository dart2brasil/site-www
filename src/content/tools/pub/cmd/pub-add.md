---
ia-translate: true
title: dart pub add
description: Use dart pub add para adicionar uma dependência.
---

_Add_ (Adicionar) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub add [{dev|override}:]<package>[:descriptor] [[{dev|override}:]<package>[:descriptor] ...] [options]
```

Este comando adiciona os pacotes especificados ao `pubspec.yaml` como dependências,
e então recupera as dependências para resolver `pubspec.yaml`.

O exemplo de comando a seguir é equivalente a
editar `pubspec.yaml` para adicionar o pacote `http`,
e então chamar `dart pub get`:

```console
$ dart pub add http
```

## Restrição de versão {:#version-constraint}

Por padrão, `dart pub add` usa a
versão estável mais recente do pacote do site [pub.dev]({{site.pub}})
que é compatível com suas restrições de SDK e dependências.
Por exemplo, se `0.13.3` for a versão estável mais recente do pacote `http`,
então `dart pub add http` adiciona `http: ^0.13.3`
em `dependencies` no seu `pubspec.yaml`.

Você também pode especificar uma restrição ou um intervalo de restrição:

```console
$ dart pub add foo:2.0.0
$ dart pub add foo:'^2.0.0'
$ dart pub add foo:'>=2.0.0 <3.0.1'
```

Se o pacote especificado for uma dependência existente no seu `pubspec.yaml`,
`dart pub add` atualiza a restrição da dependência
para a especificada no comando.

## Dependência de desenvolvimento {:#dev-dependency}

O prefixo `dev:` adiciona o pacote como uma [dependência de desenvolvimento][dev dependency],
em vez de como uma dependência regular.

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```console
$ dart pub add dev:foo           # adiciona a versão estável compatível mais recente de foo
$ dart pub add dev:foo:^2.0.0    # adiciona a restrição especificada de foo
$ dart pub add foo dev:bar       # adiciona a dependência regular foo e a dependência de desenvolvimento bar simultaneamente
```

_Anteriormente, a opção `-d, --dev`_:

```console
$ dart pub add --dev foo
```

## Substituição de dependência {:#dependency-override}

Para especificar uma [substituição de dependência][dependency override], adicione o prefixo `override:` e
inclua uma [restrição de versão](#version-constraint) ou
[descritor de fonte](#source-descriptor).

[dependency override]: /tools/pub/dependencies#dependency-overrides

**Por exemplo:** Para substituir todas as referências a `package:foo`
para usar a versão `1.0.0` do pacote,
execute o seguinte comando:

```console
$ dart pub add override:foo:1.0.0
```

Isso adiciona a substituição ao seu arquivo `pubspec.yaml`:

```yaml
dependency_overrides:
  foo: 1.0.0
```

## Descritor de fonte {:#source-descriptor}

:::version-note
A sintaxe de descritor formatada em YAML foi adicionada no Dart 2.19.
O descritor substitui argumentos como
`--path`, `--sdk`, `--git-<option>`, etc.
O Pub ainda suporta esses argumentos, mas
o método recomendado agora é o descritor YAML.
O descritor e os argumentos substituídos não podem ser usados juntos.
:::

A sintaxe do descritor YAML permite adicionar
vários pacotes de diferentes fontes e
aplicar diferentes opções e restrições a cada um.

```plaintext
$ dart pub add [options] [{dev|override}:]<package>[:descriptor] [[{dev|override}:]<package>[:descriptor] ...]
```

The syntax reflects how dependencies are written in `pubspec.yaml`.
Follow the same format including spaces.

```plaintext
"<package>:{<source>: <descriptor>[, <source>: <descriptor>], version: <constraint>}"
```

### `git` {:#git}

Adiciona uma [dependência git](/tools/pub/dependencies#git-packages).

```console
$ dart pub add "foo:{git: https://github.com/foo/foo}"
```

Você pode especificar o repositório e o branch ou commit, ou localização exata,
dentro desse repositório:

```console
$ dart pub add "foo:{git:{url: ../foo.git, ref: branch, path: subdir}}"
```

#### `url` {:#url}

Depende do pacote no repositório Git especificado.

_Anteriormente, a opção `--git-url=<git_repo_url>`_:

```console
$ dart pub add http --git-url=https://github.com/my/http.git
```

#### `ref` {:#ref}

Com `url`, depende do branch ou commit especificado de um repositório Git.

_Anteriormente, a opção `--git-ref=<branch_or_commit>`_:

```console
$ dart pub add http --git-url=https://github.com/my/http.git --git-ref=tmpfixes
```

#### `path`

Com `url`, especifica a localização de um pacote dentro de um repositório Git.

_Anteriormente, a opção `--git-path=<directory_path>`_.

### `hosted` {:#hosted}

Adiciona uma [dependência hospedada][hosted dependency] que depende
do servidor de pacotes na URL especificada.

```console
$ dart pub add "foo:{hosted: my-pub.dev}"
```

_Anteriormente, a opção `--hosted-url=<package_server_url>`_.

[hosted dependency]: /tools/pub/dependencies#hosted-packages

### `path`

Adiciona uma [dependência de caminho][path dependency] em um pacote armazenado localmente.

```console
$ dart pub add "foo:{path: ../foo}"
```

_Anteriormente, a opção `--path=<directory_path>`_.

[path dependency]: /tools/pub/dependencies#path-packages

### `sdk` {:#sdk}

Adiciona um pacote da fonte SDK especificada.

```console
$ dart pub add "foo:{sdk: flutter}"
```

_Anteriormente, a opção `--sdk=<sdk_name>`_:

```console
$ dart pub add foo --sdk=flutter
```

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

:::note
A sintaxe anterior `pub add` para opções
(sem descritores YAML) aplica as
opções especificadas a todos os pacotes
incluídos em uma invocação do comando.
Por exemplo, `dart pub add test http --dev`
adicionará os pacotes `test` e `http`
como dependências de desenvolvimento.
:::

### `--[no-]offline` {:#no-offline}

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run` {:#n-dry-run}

Relata quais dependências seriam alteradas,
mas não altera nenhuma.

### `--[no-]precompile` {:#no-precompile}

Por padrão, o pub pré-compila executáveis
em dependências imediatas (`--precompile`).
Para evitar a pré-compilação, use `--no-precompile`.

## Em um workspace {:#in-a-workspace}

Em um [Pub workspace](/tools/pub/workspaces) `dart pub add` adicionará
dependências apenas ao pacote no diretório atual.

{% render 'pub-problems.md' %}