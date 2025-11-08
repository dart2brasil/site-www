---
ia-translate: true
title: dart:io
description: Aprenda sobre as principais funcionalidades da biblioteca dart:io do Dart.
prevpage:
  url: /libraries/dart-convert
  title: dart:convert
nextpage:
  url: /interop/js-interop/
  title: dart:js_interop
---

<?code-excerpt plaster="none"?>

A biblioteca [dart:io][] fornece APIs para lidar com
arquivos, diretórios, processos, sockets, WebSockets, e clientes
e servidores HTTP.

:::important
Apenas [aplicativos Flutter,]({{site.flutter}}) scripts de linha de comando,
e servidores não-web podem importar e usar `dart:io`, não aplicações web.
:::

Em geral, a biblioteca dart:io implementa e promove uma API
assíncrona. Métodos síncronos podem facilmente bloquear uma aplicação, tornando-a
difícil de escalar. Portanto, a maioria das operações retornam resultados via objetos Future
ou Stream, um padrão comum com plataformas de servidor modernas como
Node.js.

Os poucos métodos síncronos na biblioteca dart:io são claramente marcados
com um sufixo Sync no nome do método. Métodos síncronos não são cobertos aqui.

Para usar a biblioteca dart:io você deve importá-la:

<?code-excerpt "misc/test/library_tour/io_test.dart (import)"?>
```dart
import 'dart:io';
```

## Arquivos e diretórios

A biblioteca I/O permite que aplicações de linha de comando leiam e escrevam arquivos e
naveguem em diretórios. Você tem duas opções para ler o conteúdo de um
arquivo: tudo de uma vez, ou streaming. Ler um arquivo todo de uma vez requer
memória suficiente para armazenar todo o conteúdo do arquivo. Se o arquivo é muito
grande ou você quer processá-lo enquanto o lê, você deve usar um
Stream, como descrito em
[Streaming file contents](#streaming-file-contents).

### Lendo um arquivo como texto

Ao ler um arquivo de texto codificado usando UTF-8, você pode ler todo o
conteúdo do arquivo com `readAsString()`. Quando as linhas individuais são
importantes, você pode usar `readAsLines()`. Em ambos os casos, um objeto Future
é retornado que fornece o conteúdo do arquivo como uma ou mais
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


### Lendo um arquivo como binário

O código a seguir lê um arquivo inteiro como bytes em uma lista de ints.
A chamada para `readAsBytes()` retorna um Future, que fornece o resultado
quando estiver disponível.

<?code-excerpt "misc/test/library_tour/io_test.dart (read-as-bytes)" replace="/\btest_data\///g"?>
```dart
void main() async {
  var config = File('config.txt');

  var contents = await config.readAsBytes();
  print('The file is ${contents.length} bytes long.');
}
```

### Tratando erros

Para capturar erros de forma que eles não resultem em exceções não capturadas, você pode
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

### Streaming file contents

Use um Stream para ler um arquivo, um pouco de cada vez.
Você pode usar tanto a [API Stream](/libraries/dart-async#stream)
quanto `await for`, parte do suporte a
[assincronia do Dart.](/language/async)

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

### Escrevendo conteúdo de arquivo

Você pode usar um [IOSink][] para
escrever dados em um arquivo. Use o método `openWrite()` de File para obter um IOSink
no qual você pode escrever. O modo padrão, `FileMode.write`, completamente
sobrescreve dados existentes no arquivo.

<?code-excerpt "misc/test/library_tour/io_test.dart (write-file)" replace="/\btest_data\///g"?>
```dart
var logFile = File('log.txt');
var sink = logFile.openWrite();
sink.write('FILE ACCESSED ${DateTime.now()}\n');
await sink.flush();
await sink.close();
```

Para adicionar ao final do arquivo, use o parâmetro `mode` opcional para
especificar `FileMode.append`:

<?code-excerpt "misc/test/library_tour/io_test.dart (append)" replace="/_?test_\w*\/?//g"?>
```dart
var sink = logFile.openWrite(mode: FileMode.append);
```

Para escrever dados binários, use `add(List<int> data)`.


### Listando arquivos em um diretório

Encontrar todos os arquivos e subdiretórios de um diretório é uma operação
assíncrona. O método `list()` retorna um Stream que emite um objeto
quando um arquivo ou diretório é encontrado.

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


### Outras funcionalidades comuns

As classes File e Directory contêm outras funcionalidades, incluindo
mas não limitado a:

- Criar um arquivo ou diretório: `create()` em File e Directory
- Excluir um arquivo ou diretório: `delete()` em File e Directory
- Obter o comprimento de um arquivo: `length()` em File
- Obter acesso aleatório a um arquivo: `open()` em File

Consulte a documentação da API para [File][] e [Directory][] para uma lista
completa de métodos.


## Clientes e servidores HTTP

A biblioteca dart:io fornece classes que aplicações de linha de comando podem usar para
acessar recursos HTTP, bem como executar servidores HTTP.

### Servidor HTTP

A classe [HttpServer][]
fornece a funcionalidade de baixo nível para construir servidores web. Você pode
associar handlers de requisição, definir cabeçalhos, fazer stream de dados, e mais.

O exemplo de servidor web a seguir retorna informações de texto simples.
Este servidor escuta na porta 8888 e endereço 127.0.0.1 (localhost),
respondendo a requisições para o caminho `/dart`. Para qualquer outro caminho,
a resposta é código de status 404 (página não encontrada).

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

### Cliente HTTP

Você deve evitar usar `dart:io` diretamente para fazer requisições HTTP.
A classe [HttpClient][] em `dart:io` é dependente de plataforma
e vinculada a uma única implementação.
Em vez disso, use uma biblioteca de nível superior como
[`package:http`]({{site.pub-pkg}}/http).

O tutorial [Fetch data from the internet][]
explica como fazer requisições HTTP
usando `package:http`.

## Mais informações

Esta página mostrou como usar as principais funcionalidades da biblioteca [dart:io][].
Além das APIs discutidas nesta seção, a biblioteca dart:io também
fornece APIs para [processos,][Process] [sockets,][Socket] e
[web sockets.][WebSocket]
Para mais informações sobre desenvolvimento de aplicações de linha de comando e server-side, veja a
[visão geral do Dart server-side.](/server)


[dart:io]: {{site.dart-api}}/dart-io/dart-io-library.html
[Directory]: {{site.dart-api}}/dart-io/Directory-class.html
[Fetch data from the internet]: /tutorials/server/fetch-data
[File]: {{site.dart-api}}/dart-io/File-class.html
[HttpClient]: {{site.dart-api}}/dart-io/HttpClient-class.html
[HttpRequest]: {{site.dart-api}}/dart-html/HttpRequest-class.html
[HttpServer]: {{site.dart-api}}/dart-io/HttpServer-class.html
[IOSink]: {{site.dart-api}}/dart-io/IOSink-class.html
[Process]: {{site.dart-api}}/dart-io/Process-class.html
[Socket]: {{site.dart-api}}/dart-io/Socket-class.html
[WebSocket]: {{site.dart-api}}/dart-io/WebSocket-class.html
