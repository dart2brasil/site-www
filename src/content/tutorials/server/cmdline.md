---
ia-translate: true
title: Escrever aplicações de linha de comando
description: Explore uma aplicação de linha de comando escrita em Dart.
nextpage:
  url: /tutorials/server/fetch-data
  title: Buscar dados da internet
prevpage:
  url: /tutorials/server/get-started
  title: "Primeiros passos: Aplicações de linha de comando e servidor"
---

{% assign argsAPI = site.pub-api | append: '/args/latest/args' -%}
{% assign ioAPI = site.dart-api | append: '/dart-io' -%}

<?code-excerpt replace="/ ?\/\/!tip.*//g"?>

:::secondary What's the point?
* Aplicações de linha de comando precisam fazer entrada e saída.
* A biblioteca `dart:io` fornece funcionalidade de I/O.
* O pacote args ajuda a definir e analisar argumentos de linha de comando.
* Um objeto `Future` representa um valor que estará
  disponível em algum momento no futuro.
* Streams fornecem uma série de eventos de dados assíncronos.
* A maioria das operações de entrada e saída requer o uso de streams.
:::

:::note
Este tutorial usa os recursos de linguagem `async` e `await`, que dependem das
classes [`Future`]({{site.dart-api}}/dart-async/Future-class.html) e
[`Stream`]({{site.dart-api}}/dart-async/Stream-class.html)
para suporte assíncrono.
Para aprender mais sobre esses recursos, veja o
[tutorial de programação assíncrona](/libraries/async/async-await) e o
[tutorial de streams](/libraries/async/using-streams).
:::

Este tutorial ensina como construir aplicações de linha de comando
e mostra algumas pequenas aplicações de linha de comando.
Esses programas usam recursos que a maioria das aplicações de linha de comando precisam,
incluindo os streams de saída padrão, erro e entrada,
argumentos de linha de comando, arquivos e diretórios, e mais.

## Executando uma aplicação com a Dart VM standalone

Para executar uma aplicação de linha de comando na Dart VM, use `dart run`.
Os comandos `dart` estão incluídos com o [Dart SDK](/tools/sdk).

:::important
A localização do diretório de instalação do SDK
(vamos chamá-lo de `<sdk-install-dir>`) depende da sua plataforma
e de como você instalou o SDK.
Você pode encontrar `dart` em `<sdk-install-dir>/bin`.
Colocando este diretório no seu PATH
você pode se referir ao comando `dart` pelo nome.
:::

Vamos executar um pequeno programa.

 1. Crie um arquivo chamado `hello_world.dart` que contém este código:

    <?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
    ```dart
    void main() {
      print('Hello, World!');
    }
    ```

 2. No diretório que contém o arquivo que você acabou de criar, execute o programa:

    ```console
    $ dart run hello_world.dart
    Hello, World!
    ```

A ferramenta Dart suporta muitos comandos e opções.
Use `dart --help` para ver comandos e opções comumente usados.
Use `dart --verbose` para ver todas as opções.

## Visão geral do código da aplicação dcat

Este tutorial cobre os detalhes de uma pequena aplicação de exemplo chamada `dcat`, que
exibe o conteúdo de quaisquer arquivos listados na linha de comando.
Esta aplicação usa várias classes, funções e propriedades
disponíveis para aplicações de linha de comando.
Continue no tutorial para aprender sobre cada parte da aplicação
e as várias APIs usadas.

<?code-excerpt "cli/bin/dcat.dart (dcat-app)"?>
```dart
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

void main(List<String> arguments) {
  exitCode = 0; // Presume success
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, showLineNumbers: argResults[lineNumber] as bool);
}

Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    await stdin.pipe(stdout);
  } else {
    for (final path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      try {
        await for (final line in lines) {
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
```

### Obtendo dependências

Você pode notar que dcat depende de um pacote chamado **args**.
Para obter o pacote args, use o
[gerenciador de pacotes pub](/tools/pub/packages).

Uma aplicação real tem testes, arquivos de licença, arquivos de dependências, exemplos, e assim por diante.
Para a primeira aplicação, porém, podemos facilmente criar apenas o que é necessário
com o comando [`dart create`](/tools/dart-create).

1. Dentro de um diretório, crie a aplicação dcat com a ferramenta dart.

   ```console
   $ dart create dcat
   ```

2. Mude para o diretório criado.

   ```console
   $ cd dcat
   ```

3. Dentro do diretório `dcat`, use [`dart pub add`](/tools/pub/cmd/pub-add)
   para adicionar o pacote `args` como uma dependência.
   Isso adiciona `args` à lista de suas dependências
   encontradas no arquivo `pubspec.yaml`.

   ```console
   $ dart pub add args
   ```

4. Abra o arquivo `bin/dcat.dart` e copie o código anterior nele.

:::note
Para aprender mais sobre usar pacotes e organizar seu código, confira
[Como usar pacotes](/tools/pub/packages) e
[Convenções de layout de pacotes](/tools/pub/package-layout).
:::

### Executando dcat

Uma vez que você tenha as dependências da sua aplicação,
você pode executar a aplicação da linha de comando sobre qualquer arquivo de texto,
como `pubspec.yaml`:

```console
$ dart run bin/dcat.dart -n pubspec.yaml
1 name: dcat
2 description: A sample command-line application.
3 version: 1.0.0
4 # repository: https://github.com/my_org/my_repo
5
6 environment:
7   sdk: ^3.9.0
8
9 # Add regular dependencies here.
10 dependencies:
11   args: ^2.7.0
12   # path: ^1.8.0
13
14 dev_dependencies:
15   lints: ^6.0.0
16   test: ^1.25.0
```

Este comando exibe cada linha do arquivo especificado.
Porque você especificou a opção `-n`,
um número de linha é exibido antes de cada linha.

## Analisando argumentos de linha de comando

O [pacote args]({{site.pub-pkg}}/args) fornece
suporte ao parser para transformar argumentos de linha de comando
em um conjunto de opções, flags e valores adicionais.
Importe a
[biblioteca args]({{argsAPI}}/args-library.html) do pacote
da seguinte forma:

<?code-excerpt "cli/bin/dcat.dart" retain="package:args"?>
```dart
import 'package:args/args.dart';
```

A biblioteca `args` contém essas classes, entre outras:

| Classe                                          | Descrição                                                               |
|-------------------------------------------------|-------------------------------------------------------------------------|
| [ArgParser]({{argsAPI}}/ArgParser-class.html)   | Um parser de argumentos de linha de comando.                            |
| [ArgResults]({{argsAPI}}/ArgResults-class.html) | O resultado de analisar argumentos de linha de comando usando `ArgParser`. |

{: .table }

O código a seguir na aplicação `dcat` usa essas classes para
analisar e armazenar os argumentos de linha de comando especificados:

<?code-excerpt "cli/bin/dcat.dart (arg-processing)" plaster="none" replace="/(ArgR.*|List[^\)]*|\..*|parser.*|argResults\S[^);]+)/[!$&!]/g"?>
```dart
void main([!List<String> arguments!]) {
  exitCode = 0; // Presume success
  final [!parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');!]

  [!ArgResults argResults = parser.parse(arguments);!]
  final paths = [!argResults.rest!];

  dcat(paths, showLineNumbers: [!argResults[lineNumber] as bool!]);
}
```

O runtime Dart passa argumentos de linha de comando para
a função `main` da aplicação como uma lista de strings.
O `ArgParser` é configurado para analisar a opção `-n`.
Então, o resultado da análise dos argumentos de linha de comando é armazenado em `argResults`.

O diagrama a seguir mostra como a linha de comando `dcat` usada acima
é analisada em um objeto `ArgResults`.

![Run dcat from the command-line](/assets/img/tutorials/server/dcat-dart-run.svg){:width="350" .diagram-wrap}

Você pode acessar flags e opções pelo nome,
tratando um `ArgResults` como um `Map`.
Você pode acessar outros valores usando a propriedade `rest`.

A [referência da API]({{argsAPI}}/args-library.html)
para a biblioteca `args` fornece informações detalhadas para ajudá-lo a usar
as classes `ArgParser` e `ArgResults`.

## Lendo e escrevendo com stdin, stdout e stderr

Como outras linguagens,
Dart tem streams de saída padrão, erro padrão e entrada padrão.
Os streams de I/O padrão são definidos no nível superior da biblioteca `dart:io`:

| Stream                          | Descrição         |
|---------------------------------|-------------------|
| [stdout]({{ioAPI}}/stdout.html) | A saída padrão    |
| [stderr]({{ioAPI}}/stderr.html) | O erro padrão     |
| [stdin]({{ioAPI}}/stdin.html)   | A entrada padrão  |

{: .table }

Importe a biblioteca `dart:io` da seguinte forma:

<?code-excerpt "cli/bin/dcat.dart" retain="dart:io"?>
```dart
import 'dart:io';
```

:::note
Aplicações que rodam na [plataforma web](/overview#platform)
não podem usar a biblioteca `dart:io`.
:::

### stdout

O código a seguir da aplicação `dcat`
escreve os números de linha para `stdout` (se a opção `-n` for especificada)
seguido pelo conteúdo da linha do arquivo.

<?code-excerpt "cli/bin/dcat.dart (show-line-numbers)" replace="/stdout\..*/[!$&!]/g"?>
```dart
if (showLineNumbers) {
  [!stdout.write('${lineNumber++} ');!]
}
[!stdout.writeln(line);!]
```

Os métodos `write()` e `writeln()` recebem um objeto de qualquer tipo,
convertem para uma string e imprimem.
O método `writeln()` também imprime um caractere de nova linha.
A aplicação `dcat` usa o método `write()` para imprimir o número da linha para que
o número da linha e o texto apareçam na mesma linha.

Você também pode usar o método `writeAll()` para imprimir uma lista de objetos,
ou usar `addStream()` para imprimir assincronamente todos os elementos de um stream.

`stdout` fornece mais funcionalidade do que a função `print()`.
Por exemplo, você pode exibir o conteúdo de um stream com `stdout`.
No entanto, você deve usar `print()` em vez de `stdout`
para aplicações que rodam na web.

### stderr

Use `stderr` para escrever mensagens de erro no console.
O stream de erro padrão tem os mesmos métodos que `stdout`,
e você o usa da mesma maneira.
Embora tanto `stdout` quanto `stderr` imprimam no console,
sua saída é separada e
pode ser redirecionada ou canalizada na linha de comando
ou programaticamente para destinos diferentes.

O código a seguir da aplicação `dcat` imprime uma mensagem de erro se
o usuário tentar exibir as linhas de um diretório em vez de um arquivo.

<?code-excerpt "cli/bin/dcat.dart (await-entity)" replace="/stderr\..*/[!$&!]/g"?>
```dart
if (await FileSystemEntity.isDirectory(path)) {
  [!stderr.writeln('error: $path is a directory');!]
} else {
  exitCode = 2;
}
```

### stdin

O stream de entrada padrão tipicamente
lê dados sincronamente do teclado,
embora possa ler assincronamente
e obter entrada canalizada da saída padrão de outro programa.

Aqui está um pequeno programa que lê uma única linha de `stdin`:

<?code-excerpt "cli/bin/dcat_stdin.dart"?>
```dart
import 'dart:io';

void main() {
  stdout.writeln('Type something');
  final input = stdin.readLineSync();
  stdout.writeln('You typed: $input');
}
```

O método `readLineSync()` lê texto do stream de entrada padrão,
bloqueando até que o usuário digite texto e pressione return.
Este pequeno programa imprime o texto digitado.

Na aplicação `dcat`,
se o usuário não fornecer um nome de arquivo na linha de comando,
o programa em vez disso lê de stdin usando o método `pipe()`.
Porque `pipe()` é assíncrono
(retornando um `Future`, embora este código não use esse valor de retorno),
o código que o chama usa `await`.

<?code-excerpt "cli/bin/dcat.dart (pipe)" replace="/pipe/[!$&!]/g"?>
```dart
await stdin.[!pipe!](stdout);
```

Neste caso, o usuário digita linhas de texto,
e a aplicação as copia para stdout.
O usuário sinaliza o fim da entrada pressionando <kbd>Control</kbd>+<kbd>D</kbd>
(ou <kbd>Control</kbd>+<kbd>Z</kbd> no Windows).

```console
$ dart run bin/dcat.dart
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
```

## Obtendo informações sobre um arquivo

A classe [`FileSystemEntity`]({{ioAPI}}/FileSystemEntity-class.html)
na biblioteca `dart:io` fornece propriedades e métodos estáticos
que ajudam você a inspecionar e manipular o sistema de arquivos.

Por exemplo, se você tem um caminho, pode
determinar se o caminho é um arquivo, um diretório, um link ou não encontrado usando
o método `type()` da classe `FileSystemEntity`.
Como o método `type()` acessa o sistema de arquivos,
ele realiza a verificação assincronamente.

O código a seguir da aplicação `dcat` usa `FileSystemEntity`
para determinar se o caminho fornecido na linha de comando é um diretório.
O `Future` retornado completa com um booleano que
indica se o caminho é um diretório ou não.
Como a verificação é assíncrona, o
código chama `isDirectory()` usando `await`.

<?code-excerpt "cli/bin/dcat.dart (await-entity)" replace="/await.*path\)/[!$&!]/g"?>
```dart
if ([!await FileSystemEntity.isDirectory(path)!]) {
  stderr.writeln('error: $path is a directory');
} else {
  exitCode = 2;
}
```

Outros métodos interessantes na classe `FileSystemEntity`
incluem `isFile()`, `exists()`, `stat()`, `delete()` e `rename()`,
todos os quais também usam um `Future` para retornar um valor.

`FileSystemEntity` é a superclasse para as
classes `File`, `Directory` e `Link`.

## Lendo um arquivo

A aplicação `dcat` abre cada arquivo listado na linha de comando
com o método `openRead()`, que retorna um `Stream`.
O bloco `await for` espera o arquivo ser lido e decodificado assincronamente.
Quando os dados se tornam disponíveis no stream,
a aplicação os imprime para stdout.

<?code-excerpt "cli/bin/dcat.dart (for-path)" remove="/^\s*\/\/!tip.*/" replace="/(    )((await for| *stdout| *if| *}).*)/$1[!$2!]/g"?>
```dart
for (final path in paths) {
  var lineNumber = 1;
  final lines = utf8.decoder
      .bind(File(path).openRead())
      .transform(const LineSplitter());
  try {
    [!await for (final line in lines) {!]
    [!  if (showLineNumbers) {!]
    [!    stdout.write('${lineNumber++} ');!]
    [!  }!]
    [!  stdout.writeln(line);!]
    [!}!]
  } catch (_) {
    await _handleError(path);
  }
}
```

O seguinte destaca o resto do código, que usa dois decoders que
transformam os dados antes de disponibilizá-los no bloco `await for`.
O decoder UTF8 converte os dados em strings Dart.
`LineSplitter` divide os dados em novas linhas.

<?code-excerpt "cli/bin/dcat.dart (for-path)" remove="/^\s*\/\/!tip.*/" replace="/utf8.decoder|LineSplitter()/[!$&!]/g"?>
```dart
for (final path in paths) {
  var lineNumber = 1;
  final lines = [!utf8.decoder!]
      .bind(File(path).openRead())
      .transform(const [!LineSplitter!]());
  try {
    await for (final line in lines) {
      if (showLineNumbers) {
        stdout.write('${lineNumber++} ');
      }
      stdout.writeln(line);
    }
  } catch (_) {
    await _handleError(path);
  }
}
```

A biblioteca `dart:convert` fornece esses e outros conversores de dados,
incluindo um para JSON.
Para usar esses conversores você precisa importar a biblioteca `dart:convert`:

<?code-excerpt "cli/bin/dcat.dart" retain="dart:convert"?>
```dart
import 'dart:convert';
```

## Escrevendo em um arquivo

A maneira mais fácil de escrever texto em um arquivo é criar um
objeto [`File`]({{ioAPI}}/File-class.html)
e usar o método `writeAsString()`:

<?code-excerpt "cli/lib/cmdline.dart (write-quote)"?>
```dart
final quotes = File('quotes.txt');
const stronger = 'That which does not kill us makes us stronger. -Nietzsche';

await quotes.writeAsString(stronger, mode: FileMode.append);
```

O método `writeAsString()` escreve os dados assincronamente.
Ele abre o arquivo antes de escrever e fecha o arquivo quando termina.
Para anexar dados a um arquivo existente, você pode usar o
parâmetro nomeado opcional `mode` e definir seu valor como `FileMode.append`.
Caso contrário, o mode padrão é `FileMode.write` e
o conteúdo anterior do arquivo, se houver, é sobrescrito.

Se você quiser escrever mais dados, pode abrir o arquivo para escrita.
O método `openWrite()` retorna um `IOSink`,
que tem o mesmo tipo que stdin e stderr.
Ao usar o `IOSink` retornado de `openWrite()`,
você pode continuar a escrever no arquivo até terminar,
momento em que deve fechar manualmente o arquivo.
O método `close()` é assíncrono e retorna um `Future`.

<?code-excerpt "cli/lib/cmdline.dart (write-quotes)"?>
```dart
final quotes = File('quotes.txt').openWrite(mode: FileMode.append);

quotes.write("Don't cry because it's over, ");
quotes.writeln('smile because it happened. -Dr. Seuss');
await quotes.close();
```

## Obtendo informações do ambiente

{% assign PlatformAPI = ioAPI | append: '/Platform' -%}

Use a classe [`Platform`]({{PlatformAPI}}-class.html)
para obter informações sobre a máquina e sistema operacional
em que sua aplicação está rodando.

A propriedade estática [`Platform.environment`]({{PlatformAPI}}/environment.html)
fornece uma cópia das variáveis de ambiente em um map imutável.
Se você precisar de um map mutável (cópia modificável) você
pode usar `Map.of(Platform.environment)`.

<?code-excerpt "cli/lib/cmdline.dart (env)"?>
```dart
final envVarMap = Platform.environment;

print('PWD = ${envVarMap['PWD']}');
print('LOGNAME = ${envVarMap['LOGNAME']}');
print('PATH = ${envVarMap['PATH']}');
```

`Platform` fornece outras propriedades úteis que dão
informações sobre a máquina, SO e aplicação
atualmente em execução. Por exemplo:

- [`Platform.isMacOS()`]({{PlatformAPI}}/isMacOS.html)
- [`Platform.numberOfProcessors`]({{PlatformAPI}}/numberOfProcessors.html)
- [`Platform.script`]({{PlatformAPI}}/script.html)

## Definindo códigos de saída

A biblioteca `dart:io` define uma propriedade de nível superior,
`exitCode`, que você pode alterar para definir o código de saída para
a invocação atual da Dart VM.
Um código de saída é um número passado de
uma aplicação Dart para o processo pai
para indicar o sucesso, falha ou outro estado da
execução da aplicação.

A aplicação `dcat` define o código de saída
na função `_handleError()` para indicar que um erro
ocorreu durante a execução.

<?code-excerpt "cli/bin/dcat.dart (handle-error)" remove="/^\s*\/\/!tip.*/" replace="/exit.*;/[!$&!]/g"?>
```dart
Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    [!exitCode = 2;!]
  }
}
```

Um código de saída de `2` indica que a aplicação encontrou um erro.

Uma alternativa ao uso de `exitCode` é usar a função de nível superior `exit()`,
que define o código de saída e sai da aplicação imediatamente.
Por exemplo, a função `_handleError()` poderia chamar `exit(2)`
em vez de definir `exitCode` para 2,
mas `exit()` iria encerrar o programa e
ele pode não processar todos os arquivos especificados pelo comando em execução.

:::note
De modo geral, é melhor usar a propriedade `exitCode`,
que define o código de saída mas permite que o programa continue até sua
conclusão natural.
:::

Embora você possa usar qualquer número para um código de saída,
por convenção, os códigos na tabela abaixo têm os seguintes significados:

| Código | Significado |
|--------|-------------|
| 0      | Sucesso     |
| 1      | Avisos      |
| 2      | Erros       |


{: .table }

## Resumo

Este tutorial descreveu algumas APIs básicas
encontradas nas seguintes classes da biblioteca `dart:io`:

| API | Descrição |
|---|---|
| [`IOSink`]({{ioAPI}}/IOSink-class.html) | Classe auxiliar para objetos que consomem dados de streams |
| [`File`]({{ioAPI}}/File-class.html) | Representa um arquivo no sistema de arquivos nativo |
| [`Directory`]({{ioAPI}}/Directory-class.html) | Representa um diretório no sistema de arquivos nativo |
| [`FileSystemEntity`]({{ioAPI}}/FileSystemEntity-class.html) | Superclasse para File e Directory |
| [`Platform`]({{ioAPI}}/Platform-class.html) | Fornece informações sobre a máquina e sistema operacional |
| [`stdout`]({{ioAPI}}/stdout.html) | O stream de saída padrão |
| [`stderr`]({{ioAPI}}/stderr.html) | O stream de erro padrão |
| [`stdin`]({{ioAPI}}/stdin.html) | O stream de entrada padrão |
| [`exitCode`]({{ioAPI}}/exitCode.html) | Acessa e define o código de saída |
| [`exit()`]({{ioAPI}}/exit.html) | Define o código de saída e encerra |

{: .table }

Além disso, este tutorial cobriu duas classes de `package:args`
que ajudam com análise e uso de argumentos de linha de comando:
[`ArgParser`]({{argsAPI}}/ArgParser-class.html) e
[`ArgResults`]({{argsAPI}}/ArgResults-class.html).

Para mais classes, funções e propriedades,
consulte a documentação da API para
[`dart:io`]({{ioAPI}}/dart-io-library.html),
[`dart:convert`]({{site.dart-api}}/dart-convert/dart-convert-library.html),
e [`package:args`]({{argsAPI}}/args-library.html).

Para outro exemplo de uma aplicação de linha de comando,
confira o exemplo [`command_line`][].

[`command_line`]: {{site.repo.dart.samples}}/tree/main/command_line

## E agora?

Se você está interessado em programação server-side,
confira o [próximo tutorial](/tutorials/server/httpserver).
