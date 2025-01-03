---
ia-translate: true
title: dart:io
description: Saiba mais sobre os principais recursos na biblioteca dart:io do Dart.
prevpage:
  url: /libraries/dart-convert
  title: dart:convert
nextpage:
  url: /libraries/dart-html
  title: dart:html
---

<?code-excerpt plaster="none"?>

A biblioteca [dart:io][] fornece APIs para lidar com
arquivos, diretórios, processos, sockets, WebSockets e HTTP
clientes e servidores.

:::important
Apenas aplicativos [Flutter]({{site.flutter}}) não web, scripts de linha de comando,
e servidores podem importar e usar `dart:io`, não aplicativos web.
:::

Em geral, a biblioteca dart:io implementa e promove uma API assíncrona.
Métodos síncronos podem facilmente bloquear um aplicativo, dificultando
o dimensionamento. Portanto, a maioria das operações retorna resultados por meio de objetos
Future ou Stream, um padrão comum em plataformas de servidor modernas como
Node.js.

Os poucos métodos síncronos na biblioteca dart:io são claramente marcados
com um sufixo Sync no nome do método. Métodos síncronos não são abordados aqui.

Para usar a biblioteca dart:io, você deve importá-la:

<?code-excerpt "misc/test/library_tour/io_test.dart (import)"?>
```dart
import 'dart:io';
```

## Arquivos e diretórios {:#files-and-directories}

A biblioteca I/O permite que aplicativos de linha de comando leiam e gravem arquivos e
naveguem por diretórios. Você tem duas opções para ler o conteúdo de um
arquivo: tudo de uma vez ou por streaming (transmissão). Ler um arquivo tudo de uma vez requer
memória suficiente para armazenar todo o conteúdo do arquivo. Se o arquivo for muito
grande ou você quiser processá-lo durante a leitura, você deve usar um
Stream, conforme descrito em
[Streaming de conteúdo de arquivo](#streaming-file-contents).

### Lendo um arquivo como texto {:#reading-a-file-as-text}

Ao ler um arquivo de texto codificado usando UTF-8, você pode ler todo o
conteúdo do arquivo com `readAsString()`. Quando as linhas individuais são
importantes, você pode usar `readAsLines()`. Em ambos os casos, um objeto Future
é retornado que fornece o conteúdo do arquivo como uma ou mais
strings (cadeias de caracteres).

<?code-excerpt "misc/test/library_tour/io_test.dart (read-as-string)" replace="/\btest_data\///g"?>
```dart
void main() async {
  var config = File('config.txt');

  // Coloca todo o arquivo em uma única string.
  var stringContents = await config.readAsString();
  print('O arquivo tem ${stringContents.length} caracteres.');

  // Coloca cada linha do arquivo em sua própria string.
  var lines = await config.readAsLines();
  print('O arquivo tem ${lines.length} linhas.');
}
```


### Lendo um arquivo como binário {:#reading-a-file-as-binary}

O código a seguir lê um arquivo inteiro como bytes em uma lista de ints.
A chamada para `readAsBytes()` retorna um Future, que fornece o resultado
quando ele estiver disponível.

<?code-excerpt "misc/test/library_tour/io_test.dart (read-as-bytes)" replace="/\btest_data\///g"?>
```dart
void main() async {
  var config = File('config.txt');

  var contents = await config.readAsBytes();
  print('O arquivo tem ${contents.length} bytes.');
}
```

### Lidando com erros {:#handling-errors}

Para capturar erros para que eles não resultem em exceções não tratadas, você pode
registrar um manipulador `catchError` no Future,
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

### Streaming de conteúdo de arquivo {:#streaming-file-contents}

Use um Stream para ler um arquivo, um pouco de cada vez.
Você pode usar a [API Stream](/libraries/dart-async#stream)
ou `await for`, parte do
[suporte de assincronia do Dart.](/language/async)

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
      print('Obtido ${line.length} caracteres do stream');
    }
    print('arquivo agora está fechado');
  } catch (e) {
    print(e);
  }
}
```

### Gravando conteúdo de arquivo {:#writing-file-contents}

Você pode usar um [IOSink][] para
gravar dados em um arquivo. Use o método `openWrite()` de File para obter um IOSink
no qual você pode gravar. O modo padrão, `FileMode.write`,
sobrescreve completamente os dados existentes no arquivo.

<?code-excerpt "misc/test/library_tour/io_test.dart (write-file)" replace="/\btest_data\///g"?>
```dart
var logFile = File('log.txt');
var sink = logFile.openWrite();
sink.write('ARQUIVO ACESSADO ${DateTime.now()}\n');
await sink.flush();
await sink.close();
```

Para adicionar ao final do arquivo, use o parâmetro opcional `mode` para
especificar `FileMode.append`:

<?code-excerpt "misc/test/library_tour/io_test.dart (append)" replace="/_?test_\w*\/?//g"?>
```dart
var sink = logFile.openWrite(mode: FileMode.append);
```

Para gravar dados binários, use `add(List<int> data)`.


### Listando arquivos em um diretório {:#listing-files-in-a-directory}

Encontrar todos os arquivos e subdiretórios de um diretório é uma
operação assíncrona. O método `list()` retorna um Stream que emite um
objeto quando um arquivo ou diretório é encontrado.

<?code-excerpt "misc/test/library_tour/io_test.dart (list-dir)" replace="/\btest_data\b/tmp/g"?>
```dart
void main() async {
  var dir = Directory('tmp');

  try {
    var dirList = dir.list();
    await for (final FileSystemEntity f in dirList) {
      if (f is File) {
        print('Arquivo encontrado ${f.path}');
      } else if (f is Directory) {
        print('Diretório encontrado ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
```


### Outra funcionalidade comum {:#other-common-functionality}

As classes File e Directory contêm outras funcionalidades, incluindo,
mas não se limitando a:

- Criando um arquivo ou diretório: `create()` em File e Directory
- Excluindo um arquivo ou diretório: `delete()` em File e Directory
- Obtendo o tamanho de um arquivo: `length()` em File
- Obtendo acesso aleatório a um arquivo: `open()` em File

Consulte a documentação da API para [File][] e [Directory][] para uma lista
completa de métodos.


## Clientes e servidores HTTP {:#http-clients-and-servers}

A biblioteca dart:io fornece classes que aplicativos de linha de comando podem usar para
acessar recursos HTTP, bem como executar servidores HTTP.

### Servidor HTTP {:#http-server}

A classe [HttpServer][]
fornece a funcionalidade de baixo nível para construir servidores web. Você pode
corresponder manipuladores de requisição, definir cabeçalhos, transmitir dados e muito mais.

O exemplo de servidor web a seguir retorna informações de texto simples.
Este servidor escuta na porta 8888 e no endereço 127.0.0.1 (localhost),
respondendo a requisições para o caminho `/dart`. Para qualquer outro caminho,
a resposta é o código de status 404 (página não encontrada).

<?code-excerpt "misc/lib/library_tour/io/http_server.dart (process-requests)" replace="/Future<\w+\W/void/g; /\b_//g"?>
```dart
void main() async {
  final requests = await HttpServer.bind('localhost', 8888);
  await for (final request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Recebida requisição para ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType(
        'text',
        'plain',
      )
      ..write('Olá do servidor');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}
```

### Cliente HTTP {:#http-client}

Você deve evitar usar diretamente `dart:io` para fazer requisições HTTP.
A classe [HttpClient][] em `dart:io` é dependente da plataforma
e vinculada a uma única implementação.
Em vez disso, use uma biblioteca de nível superior como
[`package:http`]({{site.pub-pkg}}/http).

O tutorial [Buscar dados da internet][]
explica como fazer requisições HTTP
usando `package:http`.

## Mais informações {:#more-information}

Esta página mostrou como usar os principais recursos da biblioteca [dart:io][].
Além das APIs discutidas nesta seção, a biblioteca dart:io também
fornece APIs para [processos,][Process] [sockets,][Socket] e
[web sockets.][WebSocket] Para obter mais informações sobre o desenvolvimento
de aplicativos do lado do servidor e de linha de comando,
consulte a [visão geral do Dart do lado do servidor.](/server)


[dart:io]: {{site.dart-api}}/dart-io/dart-io-library.html
[Directory]: {{site.dart-api}}/dart-io/Directory-class.html
[Buscar dados da internet]: /tutorials/server/fetch-data
[File]: {{site.dart-api}}/dart-io/File-class.html
[HttpClient]: {{site.dart-api}}/dart-io/HttpClient-class.html
[HttpRequest]: {{site.dart-api}}/dart-html/HttpRequest-class.html
[HttpServer]: {{site.dart-api}}/dart-io/HttpServer-class.html
[IOSink]: {{site.dart-api}}/dart-io/IOSink-class.html
[Process]: {{site.dart-api}}/dart-io/Process-class.html
[Socket]: {{site.dart-api}}/dart-io/Socket-class.html
[WebSocket]: {{site.dart-api}}/dart-io/WebSocket-class.html
