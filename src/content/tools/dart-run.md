---
ia-translate: true
title: dart run
description: Ferramenta de linha de comando para executar um programa Dart.
---

O comando `dart run` permite executar, a partir da linha de comando,
um programa Dart localizado em um arquivo, no pacote atual
ou em uma das dependências do pacote atual.
Este comando oferece funcionalidades que antes estavam no `pub run`
e na ferramenta da Dart VM.

```plaintext
dart run [options] [<DART_FILE> | <PACKAGE_TARGET>] [args]
```

Aqui está um exemplo de criação de um novo aplicativo e sua execução:

```console
$ dart create myapp
$ cd myapp
$ dart run
```

## Execute um executável de um pacote remoto {:#run-an-executable-from-a-remote-package}

:::version-note
O suporte à execução de executáveis de pacotes remotos foi introduzido no Dart 3.12.
:::

Para executar um executável de um pacote remoto sem adicioná-lo como dependência
ou instalá-lo, especifique o nome do pacote seguido do símbolo `@`.

Por exemplo:

```console
$ dart run dhttpd@
```

O Dart resolve o pacote no pub.dev, baixa-o se necessário,
e compila e executa o executável padrão dele.

Use esta forma para ferramentas pontuais e utilitários temporários.

A sintaxe completa é:

```plaintext
dart run <PACKAGE>[:<EXECUTABLE>]@[<DESCRIPTOR>] [args]
```

A parte `:<EXECUTABLE>` especifica o executável a ser executado.
A parte `@[<DESCRIPTOR>]` especifica a versão do pacote ou a restrição de versão.
As duas partes são opcionais.

{% render 'tools/dart-tool-note.md' %}

## Executando um arquivo Dart {:#running-a-dart-file}

Você pode executar um arquivo Dart passando o caminho relativo dele:

```console
$ dart run tool/debug.dart
```

## Executando um programa que está em um pacote {:#running-a-program-thats-in-a-package}

As instruções desta seção supõem que
você está executando o comando `dart run`
a partir do diretório que fica no topo de um pacote Dart
(o _pacote atual_).
Para informações sobre a estrutura de diretórios dos pacotes Dart, consulte
[convenções de layout de pacote](/tools/pub/create-packages).

### Em um pacote do qual você depende {:#in-a-depended-on-package}

Você pode executar programas distribuídos no diretório `bin` de qualquer pacote
do qual o pacote atual depende.
Para executar esse tipo de programa,
especifique o nome do pacote do qual você depende e o nome do programa.
Você pode omitir o nome do programa se ele for igual ao nome do pacote.

Por exemplo, suponha que você esteja no diretório superior de um pacote
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
Todos os outros diretórios do pacote do qual você depende são privados.

### No pacote atual {:#in-the-current-package}

Quando o diretório atual corresponde ao nome do pacote
(ou seja, você está no diretório que corresponde
à propriedade `name` no pubspec),
você pode omitir o nome do pacote.
Se o nome do programa corresponder ao nome do pacote
(ou seja, se for o programa principal),
você também pode omitir o nome do programa.

Aqui está a forma mais curta de `dart run`,
que executa o programa principal do pacote atual.
Por exemplo, se você estiver no diretório superior do pacote `foo`,
este comando executa `bin/foo.dart`:

```console
$ dart run
```

Se o nome do programa não corresponder ao nome do pacote,
adicione dois-pontos e o nome do programa.
Por exemplo, este comando executa `bin/baz.dart` no pacote atual:

```console
$ dart run :baz
```

Para executar um programa que está no pacote atual, mas não no diretório `bin`,
passe um caminho relativo (como mostrado antes):

```console
$ dart run tool/debug.dart
```

## Passando argumentos para main() {:#supplying-arguments-to-main}

Para passar [argumentos para a função `main()`][args],
coloque-os no final do comando:

```console
$ dart run tool/debug.dart arg1 arg2
```

Quando você executa o programa principal do pacote atual,
adicione o nome do pacote.
Aqui está um exemplo de execução de `bin/foo.dart` com argumentos
enquanto você está no diretório superior do pacote `foo`:

```console
$ dart run foo arg1 arg2
```

[args]: /language/functions#the-main-function

## Depuração {:#debugging}

Para habilitar a depuração,
adicione uma ou mais destas opções comuns de depuração
ao seu comando `dart run`:

- Para habilitar as [instruções `assert`][assert],
  adicione a flag `--enable-asserts`:

  ```console
  $ dart run --enable-asserts tool/debug.dart
  ```

- Para habilitar a depuração e a análise de desempenho
  pelo [Dart DevTools](/tools/dart-devtools),
  adicione a flag `--observe`:

  ```console
  $ dart run --observe tool/debug.dart
  ```

  Para saber mais sobre depuração com o Dart DevTools,
  consulte [Usando o DevTools com uma aplicação de linha de comando][Using DevTools with a command-line app].

Para saber mais sobre outras opções de depuração, execute `dart run --help`.

[assert]: /language/error-handling#assert
[Using DevTools with a command-line app]: /tools/dart-devtools#command-line-apps

## Habilitando recursos experimentais {:#enabling-experimental-features}

Para habilitar novos recursos e melhorias que estão em desenvolvimento,
use as [experiment flags](/tools/experiment-flags).
