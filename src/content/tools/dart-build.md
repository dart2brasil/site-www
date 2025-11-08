---
ia-translate: true
title: dart build
description: Ferramenta de linha de comando para compilar aplicações Dart.
---

:::version-note
O suporte para `dart build` foi introduzido no Dart 3.10.
:::

Use o comando `dart build` para compilar uma aplicação Dart.
Este comando executa automaticamente [build hooks](/tools/hooks)
do seu projeto e suas dependências para compilar ou baixar
code assets e empacotá-los com sua aplicação.


## Compilar uma aplicação CLI

O comando `dart build cli`
compila uma aplicação Dart com uma interface de linha de comando (CLI)
incluindo quaisquer code assets.

O bundle da aplicação resultante é estruturado da seguinte forma:

```plaintext
bundle/
  bin/
    <executable>
  lib/
    <dynamic libraries>
```

## Opções para `dart build cli`

As seguintes opções podem ser usadas para o comando `dart build cli`.

### `-h`, `--help`

Use a opção `-h` ou `--help` para obter ajuda para o subcomando `cli`.

```console
$ dart build cli --help
```

```console
$ dart build cli -h
```


### `-o`, `--output`

Use `-o` ou `--output` para especificar onde `dart build` salva
os arquivos gerados. A saída é colocada em um diretório `bundle/`
dentro do caminho fornecido, que pode ser absoluto ou relativo.
Se omitido, o caminho padrão é `build/cli/_/`.

```console
$ dart build cli --output=<path>
```

```console
$ dart build cli -o=<path>
```

Por exemplo, para definir o diretório de saída como `./my_custom_output`:

```console
$ dart build cli --output=./my_custom_output
```


### `-t`, `--target`

Use a opção `-t` ou `--target` para especificar o arquivo de ponto de entrada
principal da aplicação de linha de comando.

Este deve ser um arquivo Dart no diretório `bin/`.
Se a opção for omitida e houver um único
arquivo Dart em `bin/`, então esse será usado.

```console
$ dart build cli --target=<path>
```

```console
$ dart build cli -t=<path>
```

Por exemplo, para definir o ponto de entrada como o arquivo `bin/my_command.dart`:

```console
$ dart build cli --target=bin/my_command.dart
```

### `--verbosity`

Use a opção `--verbosity` para definir o nível de verbosidade da compilação.
O nível pode ser `error`, `warning`, `info` ou `all`.

```console
$ dart build cli --verbosity=<level>
```

Por exemplo, para mostrar apenas mensagens de erro:

```console
$ dart build cli --verbosity=error
```


[Global options]: /tools/pub/cmd#global-options
