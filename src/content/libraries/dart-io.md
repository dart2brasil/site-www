---
ia-translate: true
title: dart:io
description: Conheça os principais recursos da biblioteca dart:io do Dart.
prevpage:
  url: /libraries/dart-convert
  title: dart:convert
nextpage:
  url: /interop/js-interop/
  title: dart:js_interop
---

<?code-excerpt plaster="none"?>

A biblioteca [dart:io][] oferece APIs para lidar com
arquivos, diretórios, processos, sockets, WebSockets e clientes
e servidores HTTP.

:::important
Apenas [aplicações Flutter que não são web,]({{site.flutter}}) scripts de linha de comando
e servidores podem importar e usar `dart:io`, não aplicações web.
:::

Em geral, a biblioteca dart:io implementa e promove uma API assíncrona.
Métodos síncronos podem facilmente bloquear uma aplicação, dificultando
a escalabilidade. Por isso, a maioria das operações retorna resultados por meio de
objetos Future ou Stream, um padrão comum em plataformas de servidor modernas,
como o Node.js.

Os poucos métodos síncronos da biblioteca dart:io são claramente marcados
com o sufixo Sync no nome do método. Métodos síncronos não são abordados aqui.

Para usar a biblioteca dart:io, você precisa importá-la:

<?code-excerpt "misc/test/library_tour/io_test.dart (import)"?>
```dart
import 'dart:io';
```

## Arquivos e diretórios {:#files-and-directories}

A biblioteca de I/O permite que aplicações de linha de comando leiam e escrevam arquivos e
percorram diretórios. Você tem duas opções para ler o conteúdo de um
arquivo: de uma vez só ou em streaming. Ler um arquivo de uma vez exige
memória suficiente para armazenar todo o conteúdo do arquivo. Se o arquivo for muito
grande ou se você quiser processá-lo enquanto lê, deve usar um
Stream, conforme descrito em
[Transmitindo o conteúdo de arquivos](#streaming-file-contents).

### Lendo um arquivo como texto {:#reading-a-file-as-text}

Ao ler um arquivo de texto codificado em UTF-8, você pode ler todo o
conteúdo do arquivo com `readAsString()`. Quando as linhas individuais
forem importantes, você pode usar `readAsLines()`. Nos dois casos, é
retornado um objeto Future que fornece o conteúdo do arquivo como uma ou mais
strings.

<?code-excerpt "misc/test/library_tour/io_test.dart (read-as-string)" replace="/\btest_data\///g"?>
```dart
void main() async {
  var config = File('config.txt');

  // Put the whole file in a single string.
  var stringContents = await config.readAsString();
  print('The file is ${stringContents.length} characters long.');

  // Put each line of the file into its own string.
  var lines = await config.readAsLines();
  print('The file is ${lines.length} lines long.');
}
```


### Lendo um arquivo como binário {:#reading-a-file-as-binary}

O código a seguir lê um arquivo inteiro como bytes em uma lista de ints.
A chamada a `readAsBytes()` retorna um Future, que fornece o resultado
quando estiver disponível.

<?code-excerpt "misc/test/library_tour/io_test.dart (read-as-bytes)" replace="/\btest_data\///g"?>
```dart
void main() async {
  var config = File('config.txt');

  var contents = await config.readAsBytes();
  print('The file is ${contents.length} bytes long.');
}
```

### Tratando erros {:#handling-errors}

Para capturar erros e evitar que eles resultem em exceções não tratadas, você pode
registrar um handler `catchError` no Future,
ou (em uma função `async`) usar try-catch:

<?code-excerpt "misc/test/library_tour/io_test.dart (try-catch)" replace="/does-not-exist/config/g"?>
```dart
void main() async {
  var config = File('config.txt');
  try {
    var contents = await config.readAsString();
    print(contents);
  } catch (e) {
    print(e);
  }
}
```

### Transmitindo o conteúdo de arquivos {:#streaming-file-contents}

Use um Stream para ler um arquivo aos poucos.
Você pode usar a [API de Stream](/libraries/dart-async#stream)
ou `await for`, parte do
[suporte a assincronia do Dart.](/language/async)

<?code-excerpt "misc/test/library_tour/io_test.dart (read-from-stream)" replace="/_?test_\w*\/?//g"?>
```dart
import 'dart:io';
import 'dart:convert';

void main() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = utf8.decoder.bind(inputStream).transform(const LineSplitter());
  try {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}
```

### Escrevendo o conteúdo de arquivos {:#writing-file-contents}

Você pode usar um [IOSink][] para
escrever dados em um arquivo. Use o método `openWrite()` do File para obter um IOSink
no qual você pode escrever. O modo padrão, `FileMode.write`, sobrescreve
completamente os dados existentes no arquivo.

<?code-excerpt "misc/test/library_tour/io_test.dart (write-file)" replace="/\btest_data\///g"?>
```dart
var logFile = File('log.txt');
var sink = logFile.openWrite();
sink.write('FILE ACCESSED ${DateTime.now()}\n');
await sink.flush();
await sink.close();
```

Para adicionar ao final do arquivo, use o parâmetro opcional `mode` para
especificar `FileMode.append`:

<?code-excerpt "misc/test/library_tour/io_test.dart (append)" replace="/_?test_\w*\/?//g"?>
```dart
var sink = logFile.openWrite(mode: FileMode.append);
```

Para escrever dados binários, use `add(List<int> data)`.


### Listando arquivos em um diretório {:#listing-files-in-a-directory}

Encontrar todos os arquivos e subdiretórios de um diretório é uma
operação assíncrona. O método `list()` retorna um Stream que emite um objeto
sempre que um arquivo ou diretório é encontrado.

<?code-excerpt "misc/test/library_tour/io_test.dart (list-dir)" replace="/\btest_data\b/tmp/g"?>
```dart
void main() async {
  var dir = Directory('tmp');

  try {
    var dirList = dir.list();
    await for (final FileSystemEntity f in dirList) {
      if (f is File) {
        print('Found file ${f.path}');
      } else if (f is Directory) {
        print('Found dir ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
```


### Outras funcionalidades comuns {:#other-common-functionality}

As classes File e Directory contêm outras funcionalidades, incluindo,
mas não se limitando a:

- Criar um arquivo ou diretório: `create()` em File e Directory
- Excluir um arquivo ou diretório: `delete()` em File e Directory
- Obter o tamanho de um arquivo: `length()` em File
- Obter acesso aleatório a um arquivo: `open()` em File

Consulte a documentação da API de [File][] e [Directory][] para uma lista
completa de métodos.


## Clientes e servidores HTTP {:#http-clients-and-servers}

A biblioteca dart:io oferece classes que aplicações de linha de comando podem usar para
acessar recursos HTTP, além de executar servidores HTTP.

### Servidor HTTP {:#http-server}

A classe [HttpServer][] oferece a funcionalidade de baixo nível para construir
servidores web. Você pode associar handlers de requisição, definir headers, transmitir dados e muito mais.

O exemplo a seguir de servidor web retorna informações de texto simples.
Esse servidor escuta na porta 8888 e no endereço 127.0.0.1 (localhost),
respondendo a requisições para o caminho `/dart`. Para qualquer outro caminho,
a resposta tem o código de status 404 (página não encontrada).

<?code-excerpt "misc/lib/library_tour/io/http_server.dart (process-requests)" replace="/Future<\w+\W/void/g; /\b_//g"?>
```dart
void main() async {
  final requests = await HttpServer.bind('localhost', 8888);
  await for (final request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType('text', 'plain')
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}
```

### Cliente HTTP {:#http-client}

Evite usar `dart:io` diretamente para fazer requisições HTTP.
A classe [HttpClient][] em `dart:io` depende da plataforma
e está presa a uma única implementação.
Em vez disso, use uma biblioteca de nível mais alto, como
[`package:http`]({{site.pub-pkg}}/http).

O tutorial [Buscar dados da internet][Fetch data from the internet]
explica como fazer requisições HTTP
usando `package:http`.

## Mais informações {:#more-information}

Esta página mostrou como usar os principais recursos da biblioteca [dart:io][].
Além das APIs discutidas nesta seção, a biblioteca dart:io também
oferece APIs para [processos,][Process] [sockets,][Socket] e
[web sockets.][WebSocket]
Para mais informações sobre o desenvolvimento de aplicações do lado do servidor e de linha de comando, veja a
[visão geral do Dart no servidor.](/server)


[dart:io]: {{site.dart-api}}/dart-io/dart-io-library.html
[Directory]: {{site.dart-api}}/dart-io/Directory-class.html
[Fetch data from the internet]: /server/fetch-data
[File]: {{site.dart-api}}/dart-io/File-class.html
[HttpClient]: {{site.dart-api}}/dart-io/HttpClient-class.html
[HttpRequest]: {{site.dart-api}}/dart-html/HttpRequest-class.html
[HttpServer]: {{site.dart-api}}/dart-io/HttpServer-class.html
[IOSink]: {{site.dart-api}}/dart-io/IOSink-class.html
[Process]: {{site.dart-api}}/dart-io/Process-class.html
[Socket]: {{site.dart-api}}/dart-io/Socket-class.html
[WebSocket]: {{site.dart-api}}/dart-io/WebSocket-class.html
