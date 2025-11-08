---
ia-translate: true
title: dart run
description: Ferramenta de linha de comando para executar um programa Dart.
---

O comando `dart run` suporta executar
um programa Dart—localizado em um arquivo, no pacote atual,
ou em uma das dependências do pacote atual—a partir da linha de comando.
Este comando fornece funcionalidade que estava anteriormente em `pub run`
e na ferramenta Dart VM.
Para executar um programa de um local arbitrário,
use o comando [pub global](/tools/pub/cmd/pub-global).

```plaintext
dart run [options] [<DART_FILE> | <PACKAGE_TARGET>] [args]
```

Aqui está um exemplo de criar um novo aplicativo e executá-lo:

```console
$ dart create myapp
$ cd myapp
$ dart run
```

{% render 'tools/dart-tool-note.md' %}

## Executando um arquivo Dart

Você pode executar um arquivo Dart passando seu caminho relativo:

```console
$ dart run tool/debug.dart
```

## Executando um programa que está em um pacote

As instruções nesta seção assumem que
você está executando o comando `dart run`
do diretório que está no topo de um pacote Dart
(o _pacote atual_).
Para informações sobre a estrutura de diretórios de pacotes Dart, consulte
[convenções de layout de pacote](/tools/pub/create-packages).

### Em um pacote dependente

Você pode executar programas que são
distribuídos no diretório `bin` de qualquer pacote
do qual o pacote atual depende.
Para executar tal programa,
especifique o nome do pacote dependente e o nome do programa.
Você pode omitir o nome do programa se ele for o mesmo que o nome do pacote.

Por exemplo, digamos que você está no diretório superior de um pacote
que depende do pacote `bar`.
Para executar o programa principal que está no pacote `bar` (`bin/bar.dart`),
você pode usar este comando:

```console
$ dart run bar
```

Se o nome do programa não corresponder ao nome do pacote,
use a forma `<package name>:<program name>`. Por exemplo,
para executar o programa `bin/baz.dart` que está no pacote `bar`,
use este comando:

```console
$ dart run bar:baz
```

O diretório `bin` é o único lugar com programas visíveis.
Todos os outros diretórios no pacote dependente são privados.

### No pacote atual

Quando o diretório atual corresponde ao nome do pacote
(ou seja, você está no diretório que corresponde
à propriedade `name` no pubspec),
então você pode omitir o nome do pacote.
Se o nome do programa corresponder ao nome do pacote
(ou seja, é o programa principal),
então você também pode omitir o nome do programa.

Aqui está a forma mais curta de `dart run`,
que executa o programa principal para o pacote atual.
Por exemplo, se você está no diretório superior do pacote `foo`,
este comando executa `bin/foo.dart`:

```console
$ dart run
```

Se o nome do programa não corresponder ao nome do pacote,
então adicione dois pontos e o nome do programa.
Por exemplo, este comando executa `bin/baz.dart` no pacote atual:

```console
$ dart run :baz
```

Para executar um programa que está no pacote atual mas não no diretório `bin`,
passe um caminho relativo (como mostrado antes):

```console
$ dart run tool/debug.dart
```

## Fornecendo argumentos para main()

Para fornecer [argumentos para a função `main()`][args],
coloque-os no final do comando:

```console
$ dart run tool/debug.dart arg1 arg2
```

Quando você está executando o programa principal para o pacote atual,
adicione o nome do pacote.
Aqui está um exemplo de executar `bin/foo.dart` com argumentos
enquanto você está no diretório superior do pacote `foo`:

```console
$ dart run foo arg1 arg2
```

[args]: /language/functions#the-main-function

## Depuração

Para habilitar a depuração,
adicione uma ou mais destas opções comuns de depuração
ao seu comando `dart run`:

- Para habilitar [instruções `assert`][assert],
  adicione a flag `--enable-asserts`:

  ```console
  $ dart run --enable-asserts tool/debug.dart
  ```

- Para habilitar depuração e análise de desempenho
  através do [Dart DevTools](/tools/dart-devtools),
  adicione a flag `--observe`:

  ```console
  $ dart run --observe tool/debug.dart
  ```

  Para saber mais sobre depuração com Dart DevTools,
  consulte [Usando DevTools com um aplicativo de linha de comando][].

Para saber mais sobre outras opções de depuração, execute `dart run --help`.

[assert]: /language/error-handling#assert
[Using DevTools with a command-line app]: /tools/dart-devtools#using-devtools-with-a-command-line-app

## Habilitando recursos experimentais

Para habilitar novos recursos e melhorias que estão atualmente em desenvolvimento,
use [flags de experimento](/tools/experiment-flags).
