---
ia-translate: true
title: dart install
description: Instale ferramentas CLI do Dart para uso global.
---

:::version-note
O suporte para `dart install` foi introduzido no Dart 3.10.
:::

O comando `dart install` instala ferramentas CLI do Dart para uso global.
É uma alternativa mais recente ao `dart pub global activate`.

## Instalar um pacote

Existem algumas maneiras de instalar um pacote. Para saber mais,
consulte as seções a seguir.

### Instalar um pacote geral

O comando a seguir instala todos os executables especificados na
seção [executables][] do `pubspec.yaml` de um pacote no
PATH.

```console
$ dart install [arguments] <package> [version-constraint]
```

Por exemplo:

```console
$ dart install markdown
```

### Instalar um pacote do pub.dev

O comando a seguir especifica um pacote no site pub.dev
para instalar.

```console
$ dart install <pub.dev package>
```

Por exemplo:

```console
$ dart install markdown
```

### Instalar um pacote Git

Os comandos a seguir podem ser usados para instalar um pacote
em um repositório Git.

```console
$ dart install <Git URL>
```

O exemplo a seguir instala o pacote `async_await` do
[GitHub][]:

```console
$ dart install https://github.com/dart-lang/async_await.git
```

Pub espera encontrar o pacote na raiz do repositório Git.
Para especificar um local diferente, use a opção `--git-path` com
um caminho relativo à raiz do repositório:

```console
$ dart install \
  https://github.com/dart-lang/http.git \
  --git-path pkgs/http/
```

Pub usa a branch padrão do repositório Git. Para especificar uma
branch ou commit diferente, use a opção `--git-ref`:

```console
$ dart install \
  https://github.com/dart-lang/http.git \
  --git-ref 36f98e900347335af2338a0e087538009b7de2f9
```

## Referência de comandos

Os comandos a seguir são úteis para instalar,
desinstalar e verificar o estado de instalação de uma
ferramenta CLI do Dart.

### dart install

Instala um pacote para o Dart.

```console
$ dart install [arguments] <package> [version-constraint]
```

| Arguments              | Description                                                                                                           |
| :--------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| **`--git-path`**       | Caminho do pacote git dentro do repositório. Isso se aplica apenas ao usar uma URL git para `<package>`.             |
| **`--git-ref`**        | A branch ou commit git específico a ser recuperado. Isso se aplica apenas ao usar uma URL git para `<package>`.      |
| **`--overwrite`**      | Permite sobrescrever executables de outros pacotes que tenham o mesmo nome.                                           |
| **`-u, --hosted-url`** | Uma URL de servidor pub personalizada para o pacote. Isso se aplica apenas ao usar um nome de pacote para `<package>`.|

No exemplo a seguir, o pacote markdown é instalado
sem argumentos ou restrições de versão:

```console
$ dart install markdown
```

### dart uninstall

Desinstala um pacote para o Dart.

```console
$ dart uninstall <package>
```

Por exemplo:

```console
$ dart uninstall markdown
```

### dart installed

Verifica quais pacotes estão instalados

```console
$ dart installed
```

## Opções para o comando dart install

Essas opções podem ser usadas para o comando `dart install`.
Para opções que se aplicam a todos os comandos pub, consulte
[Global options][].

### -h, --help

Use a opção `-h` ou `--help` para obter ajuda para um comando específico.
Por exemplo, os comandos a seguir produzem uma visão geral e lista
de argumentos disponíveis para `dart install`:

```console
$ dart install --help
```

```console
$ dart install -h
```

### --git-path

Use a opção `--git-path` para especificar o caminho do
pacote no repositório Git.

```console
$ dart install --git-path <path>
```

Por exemplo:

```console
$ dart install --git-path https://github.com/dart-lang/async_await.git
```

### --git-ref

Use a opção `--git-ref` para especificar a branch ou commit Git
a ser recuperado.

```console
$ dart install --git-ref <ref>
```

Por exemplo:

```console
$ dart install --git-ref tmpfixes
```

### --overwrite

Use a opção `--overwrite` para sobrescrever quaisquer
executables globais previamente instalados com o mesmo nome. Se você não especificar
esta flag, o executable pré-existente não será substituído.

```console
$ dart install <package> --overwrite
```

Por exemplo:

```console
$ dart install markdown --overwrite
```

### --hosted-url

Use a opção `--hosted-url` para especificar uma URL de servidor pub
personalizada para o pacote. Isso se aplica apenas ao usar um nome de pacote
para `<package>`.

```console
$ dart install --hosted-url <url>
```

Por exemplo:

```console
$ dart install --hosted-url https://dart-packages.example.com/
```

### [version-constraint]

Use a opção `version-constraint` para especificar uma versão específica
do pacote.

```console
$ dart install <package> [version-constraint]
```

Por exemplo, o comando a seguir
obtém a versão 0.6.0 do pacote `markdown`:

```console
$ dart install markdown 0.6.0
```

Se você especificar um intervalo, pub escolhe a melhor versão que atende a essa
restrição. Por exemplo:

```console
$ dart install foo <3.0.0
```

[pub tool]: /tools/pub/cmd
[executables]: https://dart.dev/tools/pub/pubspec#executables
[GitHub]: https://github.com/
[Global options]: /tools/pub/cmd#global-options
