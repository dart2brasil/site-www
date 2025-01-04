---
ia-translate: true
title: dart run
description: Ferramenta de linha de comando para executar um programa Dart.
---

O comando `dart run` oferece suporte à
execuçãode um programa Dart — localizado em um arquivo,
no pacote atual ou em uma das dependências do pacote atual — a partir da linha de comando.
Este comando fornece funcionalidade que estava anteriormente em `pub run`
e na ferramenta Dart VM.
Para executar um programa
de um local arbitrário, use o comando [pub global](/tools/pub/cmd/pub-global).

```plaintext
dart run [opções] [<ARQUIVO_DART> | <ALVO_PACOTE>] [args]
```

Aqui está um exemplo de criação de um novo aplicativo e sua execução:

```console
$ dart create myapp
$ cd myapp
$ dart run
```

{% render 'tools/dart-tool-note.md' %}

## Executando um arquivo Dart {:#running-a-dart-file}

Você pode executar um arquivo Dart passando seu caminho relativo:

```console
$ dart run tool/debug.dart
```

## Executando um programa que está em um pacote {:#running-a-program-that-s-in-a-package}

As instruções nesta seção pressupõem que você
está executando o comando
`dart run` a partir do diretório que está no topo de um pacote
Dart (o _pacote atual_).
Para obter informações sobre a estrutura de diretórios dos pacotes
Dart, consulte[convenções de layout de pacotes](/tools/pub/create-packages).

### Em um pacote dependente {:#in-a-depended-on-package}

Você pode executar programas que são
distribuídos no diretório `bin` de
qualquer pacote do qual o pacote atual depende.
Para executar tal programa,
especifique o nome do pacote dependente e o nome do programa. Você pode omitir o
nome do programa se ele for o mesmo que o nome do pacote.

Por exemplo, digamos que você esteja no diretório superior de um pacote que
depende do pacote `bar`.
Para executar o programa principal que está no pacote
`bar` (`bin/bar.dart`), você pode usar este comando:

```console
$ dart run bar
```

Se o nome do programa não corresponder ao nome do pacote, use o formato
`<nome do pacote>:<nome do programa>`. Por exemplo, para executar o programa
`bin/baz.dart` que está no pacote `bar`,
use este comando:

```console
$ dart run bar:baz
```

O diretório `bin` é o único lugar com programas visíveis. Todos os outros
diretórios no pacote dependente são privados.

### No pacote atual {:#in-the-current-package}

Quando o diretório atual corresponde ao nome do pacote
(ou seja, você está no
diretório que corresponde à propriedade `name` no pubspec),
você pode omitir o nome do pacote.
Se o nome do programa corresponder ao nome do pacote
(ou seja, é o programa principal),
você também pode omitir o nome do programa.

Aqui está a forma mais curta de `dart run`,
que executa o programa principal do pacote atual.
Por exemplo, se você estiver no diretório superior do pacote
`foo`, este comando executa `bin/foo.dart`:

```console
$ dart run
```

Se o nome do programa não corresponder ao nome do pacote, adicione dois pontos e
o nome do programa. Por exemplo, este comando executa `bin/baz.dart` no pacote
atual:

```console
$ dart run :baz
```

Para executar um programa que está no pacote atual, mas não no diretório `bin`,
passe um caminho relativo (como mostrado antes):

```console
$ dart run tool/debug.dart
```

## Fornecendo argumentos para main() {:#supplying-arguments-to-main}

Para fornecer [argumentos para a função `main()`][args], coloque-os no final
do comando:

```console
$ dart run tool/debug.dart arg1 arg2
```

Quando você estiver executando o programa principal do pacote atual, adicione o
nome do pacote.
Aqui está um exemplo de execução de `bin/foo.dart` com
argumentos enquanto você está no diretório superior do pacote `foo`:

```console
$ dart run foo arg1 arg2
```

[args]: /language/functions#the-main-function

## Depurando {:#debugging}

Para ativar a depuração,
adicione uma ou mais dessas opções de depuração
comuns ao seu comando `dart run`:

- Para ativar as instruções [`assert`][assert], adicione o sinalizador
  `--enable-asserts`:

  ```console
  $ dart run --enable-asserts tool/debug.dart
  ```

- Para ativar a depuração e a análise de desempenho por meio do
  [Dart DevTools](/tools/dart-devtools),
  adicione o sinalizador `--observe`:

  ```console
  $ dart run --observe tool/debug.dart
  ```

  Para saber mais sobre a depuração com o Dart DevTools, consulte
  [Usando o DevTools com um aplicativo de linha de comando][].

Para saber mais sobre outras opções de depuração, execute `dart run --help`.

[assert]: /language/error-handling#assert
[Usando o DevTools com um aplicativo de linha de comando]: /tools/dart-devtools#using-devtools-with-a-command-line-app

## Ativando recursos experimentais {:#enabling-experimental-features}

Para ativar novos recursos e melhorias que estão atualmente em
desenvolvimento, use [sinalizadores de experimento](/tools/experiment-flags).