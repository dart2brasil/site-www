---
ia-translate: true
title: Buscar dados da internet
shortTitle: Buscar dados
description: Busque dados pela internet usando o pacote http.
---

<?code-excerpt path-base="fetch_data"?>

:::secondary O que você vai aprender
* O básico sobre o que são requisições HTTP e URIs e para que são usados.
* Fazer requisições HTTP usando `package:http`.
* Decodificar strings JSON em objetos Dart com `dart:convert`.
* Converter objetos JSON em estruturas baseadas em classes.
:::

A maioria das aplicações requer alguma forma de comunicação ou
recuperação de dados da internet.
Muitas aplicações fazem isso por meio de requisições HTTP,
que são enviadas de um cliente para um servidor
para realizar uma ação específica sobre um recurso
identificado por uma [URI][] (Uniform Resource Identifier).

Os dados comunicados via HTTP podem, tecnicamente, estar em qualquer formato,
mas usar [JSON][] (JavaScript Object Notation)
é uma escolha popular, por causa da sua legibilidade para humanos
e da independência de linguagem.
O Dart SDK e o ecossistema também têm amplo suporte a JSON,
com múltiplas opções para atender melhor aos requisitos da sua aplicação.

Neste tutorial,
você vai aprender mais sobre requisições HTTP, URIs e JSON.
Depois, vai aprender como usar o [`package:http`][http-pub]
e o suporte a JSON do Dart na biblioteca [`dart:convert`][convert-docs]
para buscar, decodificar e então usar dados em formato JSON
recuperados de um servidor HTTP.

[JSON]: https://www.json.org/

## Conceitos de base {:#background-concepts}

As seções a seguir trazem algum contexto extra e informações
sobre as tecnologias e os conceitos usados no tutorial,
para facilitar a busca de dados no servidor.
Para ir direto ao conteúdo do tutorial,
veja [Recuperar as dependências necessárias][Retrieve the necessary dependencies].

[Retrieve the necessary dependencies]: #retrieve-the-necessary-dependencies

### JSON {:#json}

JSON (JavaScript Object Notation) é um formato de intercâmbio de dados
que se tornou onipresente no desenvolvimento de aplicações
e na comunicação cliente-servidor.
Ele é leve, mas também fácil para
humanos lerem e escreverem, por ser baseado em texto.
Com JSON, vários tipos de dados e estruturas simples,
como listas e maps, podem ser serializados e representados por strings.

A maioria das linguagens tem muitas implementações, e os
parsers ficaram extremamente rápidos,
então você não precisa se preocupar com interoperabilidade ou desempenho.
Para mais informações sobre o formato JSON, veja [Introducing JSON][].
Para aprender mais sobre como trabalhar com JSON em Dart,
veja o guia [Using JSON][].

:::secondary
Existem outros dois pacotes com implementações específicas de plataforma para mobile.

* [cronet_http]({{site.pub-pkg}}/cronet_http)
  fornece acesso ao cliente HTTP [Cronet][] do Android.
* [cupertino_http]({{site.pub-pkg}}/cupertino_http)
  fornece acesso ao [Foundation URL Loading System][furl] da Apple.

Para aprender mais sobre as capacidades deles,
consulte a documentação do pacote.
:::

[Cronet]: {{site.android-dev}}/develop/connectivity/cronet
[furl]: {{site.apple-dev}}/documentation/foundation/url_loading_system
[Introducing JSON]: https://www.json.org/

### Requisições HTTP {:#http-requests}

HTTP (Hypertext Transfer Protocol) é um protocolo stateless
projetado para transmitir documentos,
originalmente entre clientes web e servidores web.
Você interagiu com o protocolo para carregar esta página,
já que o seu navegador usa uma requisição HTTP `GET`
para recuperar o conteúdo de uma página de um servidor web.
Desde a sua criação, o uso do protocolo HTTP e de suas várias versões
se expandiu para aplicações fora da web também,
basicamente em qualquer lugar onde seja necessária a comunicação de um cliente com um servidor.

As requisições HTTP enviadas do cliente para se comunicar com o servidor
são compostas de vários componentes.
Bibliotecas HTTP, como o `package:http`, permitem que você
especifique os seguintes tipos de informação:

* Um método HTTP que define a ação desejada,
  como `GET` para recuperar dados ou `POST` para enviar novos dados.
* A localização do recurso por meio de uma URI.
* A versão do HTTP em uso.
* Headers que fornecem informações extras ao servidor.
* Um body opcional, para que a requisição possa enviar dados ao servidor,
  e não apenas recuperá-los.

Para aprender mais sobre o protocolo HTTP,
confira [An overview of HTTP][] no MDN Web Docs.

[An overview of HTTP]: https://developer.mozilla.org/docs/Web/HTTP/Overview

### URIs e URLs {:#uris-and-urls}

Para fazer uma requisição HTTP,
você precisa fornecer uma [URI][] (Uniform Resource Identifier) do recurso.
Uma URI é uma string de caracteres que identifica um recurso de forma única.
Uma URL (Uniform Resource Locator) é um tipo específico de URI
que também informa a localização do recurso.
As URLs de recursos na web contêm três informações.
Para esta página, a URL é composta por:

* O scheme, que determina o protocolo usado: `https`
* A autoridade, ou hostname do servidor: `dart.dev`
* O path do recurso: `/server/fetch-data.html`

Existem também outros parâmetros opcionais,
que não são usados nesta página:

* Parâmetros para personalizar comportamentos extras: `?key1=value1&key2=value2`
* Uma âncora, que não é enviada ao servidor
  e aponta para um local específico dentro do recurso: `#uris`

Para aprender mais sobre URLs,
veja [What is a URL?][] no MDN Web Docs.

[What is a URL?]: https://developer.mozilla.org/docs/Learn/Common_questions/What_is_a_URL

## Recuperar as dependências necessárias {:#retrieve-the-necessary-dependencies}

A biblioteca `package:http` fornece uma solução multiplataforma
para fazer requisições HTTP componíveis,
com controle detalhado opcional.

:::note
Evite usar diretamente `dart:io` ou `dart:html` para fazer requisições HTTP.
Essas bibliotecas dependem de plataforma e estão vinculadas a uma única implementação.
:::

Para adicionar uma dependência ao `package:http`,
execute o seguinte comando [`dart pub add`][]
a partir da raiz do seu repositório:

```console
$ dart pub add http
```

Para usar o `package:http` no seu código,
importe-o e, opcionalmente, [especifique um prefixo de biblioteca][specify a library prefix]:

<?code-excerpt "lib/fetch_data.dart (http-import)"?>
```dart
import 'package:http/http.dart' as http;
```

Para aprender mais detalhes sobre o `package:http`,
veja a [página dele no site pub.dev][http-pub]
e a sua [documentação da API][http-docs].

[`dart pub add`]: /tools/pub/cmd/pub-add
[specify a library prefix]: /language/libraries#specifying-a-library-prefix

## Construir uma URL {:#build-a-url}

Como mencionado anteriormente,
para fazer uma requisição HTTP,
primeiro você precisa de uma URL que identifique
o recurso solicitado
ou o endpoint acessado.

Em Dart, as URLs são representadas por objetos [`Uri`][].
Existem muitas formas de construir um `Uri`,
mas, por causa da sua flexibilidade,
analisar uma string com `Uri.parse` para
criar um é uma solução comum.

O snippet a seguir mostra duas formas
de criar um objeto `Uri`
apontando para informações mock, em formato JSON,
sobre o `package:http` hospedadas neste site:

<?code-excerpt "lib/fetch_data.dart (build-uris)"?>
```dart
// Parse the entire URI, including the scheme
Uri.parse('https://dart.dev/f/packages/http.json');

// Specifically create a URI with the https scheme
Uri.https('dart.dev', '/f/packages/http.json');
```

Para aprender outras formas de construir e manipular URIs,
veja a [documentação de `URI`][`URI` documentation].

[`Uri`]: {{site.dart-api}}/dart-core/Uri-class.html
[`URI` documentation]: /libraries/dart-core#uris

## Fazer uma requisição de rede {:#make-a-network-request}

Se você só precisa buscar rapidamente uma representação em string
de um recurso solicitado,
pode usar a função de nível superior [`read`][http-read]
encontrada no `package:http`,
que retorna um `Future<String>` ou lança
uma [`ClientException`][http-client-exc] se a requisição não tiver sido bem-sucedida.
O exemplo a seguir usa `read` para
recuperar as informações mock, em formato JSON,
sobre o `package:http` como uma string,
e então as imprime:

:::note
Muitas funções do `package:http`, incluindo `read`,
acessam a rede e realizam operações potencialmente demoradas,
por isso fazem isso de forma assíncrona e retornam um [`Future`][].
Se você ainda não viu futures,
pode aprender sobre eles—assim como sobre as palavras-chave `async` e `await`—no
[tutorial de programação assíncrona](/libraries/async/async-await).
:::

<?code-excerpt "lib/fetch_data.dart (http-read)" replace="/readMain/main/g; /(http\.read)/[!$1!]/g"?>
```dart
void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageInfo = await [!http.read!](httpPackageUrl);
  print(httpPackageInfo);
}
```

Isso resulta na seguinte saída em formato JSON,
que também pode ser vista no seu navegador em
[`/f/packages/http.json`][mock-http-json].

```json
{
  "name": "http",
  "latestVersion": "1.1.2",
  "description": "A composable, multi-platform, Future-based API for HTTP requests.",
  "publisher": "dart.dev",
  "repository": "https://github.com/dart-lang/http"
}
```

Observe a estrutura dos dados
(neste caso, um map),
já que você vai precisar dela ao decodificar o JSON mais adiante.

Se você precisar de outras informações da resposta,
como o [código de status][status code] ou os [headers][],
pode usar a função de nível superior [`get`][http-get],
que retorna um `Future` com uma [`Response`][http-response].

O snippet a seguir usa `get` para obter a resposta completa,
para sair mais cedo se a requisição não tiver sido bem-sucedida,
o que é indicado por um código de status **200**:

<?code-excerpt "lib/fetch_data.dart (http-get)" replace="/getMain/main/g"?>
```dart
void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageResponse = await http.get(httpPackageUrl);
  if (httpPackageResponse.statusCode != 200) {
    print('Failed to retrieve the http package!');
    return;
  }
  print(httpPackageResponse.body);
}
```

Existem muitos outros códigos de status além de **200**,
e a sua aplicação pode querer tratá-los de forma diferente.
Para aprender o que cada código de status significa,
veja [HTTP response status codes][] no MDN Web Docs.

Algumas requisições ao servidor exigem mais informações,
como autenticação ou informações de user-agent;
nesse caso, você pode precisar incluir [headers HTTP][headers].
Você pode especificar headers passando um `Map<String, String>`
com os pares chave-valor no parâmetro nomeado opcional `headers`:

<?code-excerpt "lib/fetch_data.dart (http-headers)"?>
```dart
await http.get(
  Uri.https('dart.dev', '/f/packages/http.json'),
  headers: {'User-Agent': '<product name>/<product-version>'},
);
```

[http-read]: {{site.pub-api}}/http/latest/http/read.html
[http-client-exc]: {{site.pub-api}}/http/latest/http/ClientException-class.html
[mock-http-json]: /f/packages/http.json
[`Future`]: {{site.dart-api}}/dart-async/Future-class.html
[status code]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
[headers]: https://developer.mozilla.org/docs/Web/HTTP/Headers
[http-get]: {{site.pub-api}}/http/latest/http/get.html
[http-response]: {{site.pub-api}}/http/latest/http/Response-class.html
[HTTP response status codes]: https://developer.mozilla.org/docs/Web/HTTP/Status

### Fazer múltiplas requisições {:#make-multiple-requests}

Se você está fazendo várias requisições ao mesmo servidor,
pode manter uma conexão persistente
por meio de um [`Client`][http-client],
que tem métodos semelhantes aos de nível superior.
Só certifique-se de encerrar com
o método [`close`][http-close] quando terminar:

<?code-excerpt "lib/fetch_data.dart (http-client)" replace="/clientMain/main/g; /(http\.Cl.*?\))/[!$1!]/g; /(client\.c.*?\))/[!$1!]/g"?>
```dart
void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final client = [!http.Client()!];
  try {
    final httpPackageInfo = await client.read(httpPackageUrl);
    print(httpPackageInfo);
  } finally {
    [!client.close()!];
  }
}
```

Para que o cliente possa tentar novamente requisições que falharam,
importe `package:http/retry.dart` e
envolva o `Client` criado em um [`RetryClient`][http-retry-client]:

<?code-excerpt "lib/fetch_data.dart (http-retry)" plaster="none" replace="/retryMain/main/g; /(i.*?retry.*)/[!$1!]/g; /(Retry.*?\)\))/[!$1!]/g"?>
```dart
import 'package:http/http.dart' as http;
[!import 'package:http/retry.dart';!]

void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final client = [!RetryClient(http.Client())!];
  try {
    final httpPackageInfo = await client.read(httpPackageUrl);
    print(httpPackageInfo);
  } finally {
    client.close();
  }
}
```

O `RetryClient` tem um comportamento padrão para definir quantas
vezes tentar novamente e quanto tempo esperar entre cada requisição,
mas esse comportamento pode ser alterado por parâmetros
dos construtores [`RetryClient()`][http-retry-client-cons]
ou [`RetryClient.withDelays()`][http-retry-client-delay].

O `package:http` tem muito mais funcionalidades e opções de customização,
então confira a [página dele no site pub.dev][http-pub]
e a sua [documentação da API][http-docs].

[http-client]: {{site.pub-api}}/http/latest/http/Client-class.html
[http-close]: {{site.pub-api}}/http/latest/http/Client/close.html
[http-retry-client]: {{site.pub-api}}/http/latest/retry/RetryClient-class.html
[http-retry-client-cons]: {{site.pub-api}}/http/latest/retry/RetryClient/RetryClient.html
[http-retry-client-delay]: {{site.pub-api}}/http/latest/retry/RetryClient/RetryClient.withDelays.html

## Decodificar os dados recuperados {:#decode-the-retrieved-data}

Agora que você fez uma requisição de rede
e recuperou os dados retornados como string,
acessar porções específicas de informação
dentro de uma string pode ser um desafio.

Como os dados já estão em formato JSON,
você pode usar a função nativa [`json.decode`][decode-docs] do Dart
da biblioteca `dart:convert`
para converter a string bruta em
uma representação JSON usando objetos Dart.
Neste caso, os dados JSON são representados em uma estrutura map
e, em JSON, as chaves de um map são sempre strings,
então você pode fazer o cast do resultado de `json.decode` para `Map<String, dynamic>`:

<?code-excerpt "lib/fetch_data.dart (json-decode)" plaster="none" replace="/decodeMain/main/g; /(import 'd.*?;)/[!$1!]/g; /(json\.de.*?)\;/[!$1!];/g"?>
```dart
[!import 'dart:convert';!]

import 'package:http/http.dart' as http;

void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageInfo = await http.read(httpPackageUrl);
  final httpPackageJson = [!json.decode(httpPackageInfo) as Map<String, dynamic>!];
  print(httpPackageJson);
}
```

[decode-docs]: {{site.dart-api}}/dart-convert/JsonCodec/decode.html

### Criar uma classe estruturada para armazenar os dados {:#create-a-structured-class-to-store-the-data}

Para dar mais estrutura ao JSON decodificado,
facilitando o trabalho com ele,
crie uma classe que possa armazenar os
dados recuperados usando tipos específicos, de acordo com
o schema dos seus dados.

O snippet a seguir mostra uma representação baseada em classe
que pode armazenar as informações do pacote retornadas
pelo arquivo JSON mock solicitado.
Essa estrutura assume que todos os campos, exceto o `repository`,
são obrigatórios e sempre fornecidos.

<?code-excerpt "bin/fetch_http_package.dart (package-info)" plaster="none"?>
```dart
class PackageInfo {
  final String name;
  final String latestVersion;
  final String description;
  final String publisher;
  final Uri? repository;

  PackageInfo({
    required this.name,
    required this.latestVersion,
    required this.description,
    required this.publisher,
    this.repository,
  });
}
```

### Codificar os dados na sua classe {:#encode-the-data-into-your-class}

Agora que você tem uma classe para armazenar os dados,
precisa adicionar um mecanismo para converter
o JSON decodificado em um objeto `PackageInfo`.

Converta o JSON decodificado
escrevendo manualmente um método `fromJson`
que corresponda ao formato JSON anterior,
fazendo o cast dos tipos quando necessário
e tratando o campo opcional `repository`:

<?code-excerpt "bin/fetch_http_package.dart (from-json)"?>
```dart
class PackageInfo {
  // ···

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    final repository = json['repository'] as String?;

    return PackageInfo(
      name: json['name'] as String,
      latestVersion: json['latestVersion'] as String,
      description: json['description'] as String,
      publisher: json['publisher'] as String,
      repository: repository != null ? Uri.tryParse(repository) : null,
    );
  }
}
```

Um método escrito à mão, como no exemplo anterior,
costuma ser suficiente para estruturas JSON relativamente simples,
mas também existem opções mais flexíveis.
Para aprender mais sobre serialização e desserialização de JSON,
incluindo a geração automática da lógica de conversão,
veja o guia [Using JSON][].

### Converter a resposta para um objeto da sua classe estruturada {:#convert-the-response-to-an-object-of-your-structured-class}

Agora você tem uma classe para armazenar os dados
e uma forma de converter o objeto JSON decodificado
em um objeto desse tipo.
Em seguida, você pode escrever uma função que
junta tudo:

1. Criar a sua `URI` a partir de um nome de pacote recebido.
2. Usar `http.get` para recuperar os dados desse pacote.
3. Se a requisição não tiver sido bem-sucedida, lançar uma `Exception`
   ou, de preferência, uma subclasse de `Exception` personalizada.
4. Se a requisição tiver sido bem-sucedida, usar `json.decode` para
   decodificar o body da resposta em uma string JSON.
5. Converter a string JSON decodificada em um objeto `PackageInfo`
   usando o construtor factory `PackageInfo.fromJson` que você criou.

<?code-excerpt "bin/fetch_http_package.dart (get-package)" plaster="none"?>
```dart
Future<PackageInfo> getPackage(String packageName) async {
  final packageUrl = Uri.https('dart.dev', '/f/packages/$packageName.json');
  final packageResponse = await http.get(packageUrl);

  // If the request didn't succeed, throw an exception
  if (packageResponse.statusCode != 200) {
    throw PackageRetrievalException(
      packageName: packageName,
      statusCode: packageResponse.statusCode,
    );
  }

  final packageJson = json.decode(packageResponse.body) as Map<String, dynamic>;

  return PackageInfo.fromJson(packageJson);
}

class PackageRetrievalException implements Exception {
  final String packageName;
  final int? statusCode;

  PackageRetrievalException({required this.packageName, this.statusCode});
}
```

## Utilizar os dados convertidos {:#utilize-the-converted-data}

Agora que você recuperou os dados e
os converteu para um formato mais fácil de acessar,
pode usá-los como quiser.
Algumas possibilidades incluem
exibir informações em um CLI ou
mostrá-las em uma aplicação [web][] ou [Flutter][].

Aqui está um exemplo completo e executável
que solicita, decodifica e então exibe
as informações mock sobre os pacotes `http` e `path`:

<?code-excerpt "bin/fetch_http_package.dart"?>
```dartpad
import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  await printPackageInformation('http');
  print('');
  await printPackageInformation('path');
}

Future<void> printPackageInformation(String packageName) async {
  final PackageInfo packageInfo;

  try {
    packageInfo = await getPackage(packageName);
  } on PackageRetrievalException catch (e) {
    print(e);
    return;
  }

  print('Information about the $packageName package:');
  print('Latest version: ${packageInfo.latestVersion}');
  print('Description: ${packageInfo.description}');
  print('Publisher: ${packageInfo.publisher}');

  final repository = packageInfo.repository;
  if (repository != null) {
    print('Repository: $repository');
  }
}

Future<PackageInfo> getPackage(String packageName) async {
  final packageUrl = Uri.https('dart.dev', '/f/packages/$packageName.json');
  final packageResponse = await http.get(packageUrl);

  // If the request didn't succeed, throw an exception
  if (packageResponse.statusCode != 200) {
    throw PackageRetrievalException(
      packageName: packageName,
      statusCode: packageResponse.statusCode,
    );
  }

  final packageJson = json.decode(packageResponse.body) as Map<String, dynamic>;

  return PackageInfo.fromJson(packageJson);
}

class PackageInfo {
  final String name;
  final String latestVersion;
  final String description;
  final String publisher;
  final Uri? repository;

  PackageInfo({
    required this.name,
    required this.latestVersion,
    required this.description,
    required this.publisher,
    this.repository,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    final repository = json['repository'] as String?;

    return PackageInfo(
      name: json['name'] as String,
      latestVersion: json['latestVersion'] as String,
      description: json['description'] as String,
      publisher: json['publisher'] as String,
      repository: repository != null ? Uri.tryParse(repository) : null,
    );
  }
}

class PackageRetrievalException implements Exception {
  final String packageName;
  final int? statusCode;

  PackageRetrievalException({required this.packageName, this.statusCode});

  @override
  String toString() {
    final buf = StringBuffer();
    buf.write('Failed to retrieve package:$packageName information');

    if (statusCode != null) {
      buf.write(' with a status code of $statusCode');
    }

    buf.write('!');
    return buf.toString();
  }

}
```

:::flutter-note
Para outro exemplo que cobre buscar e depois exibir dados no Flutter,
veja a receita Flutter [Fetching data from the internet][].
:::

[web]: /web
[Flutter]: {{site.flutter}}
[Fetching data from the internet]: {{site.flutter-docs}}/cookbook/networking/fetch-data

## E agora? {:#what-next}

Agora que você recuperou, analisou e usou
dados da internet,
considere aprender mais sobre [Concorrência em Dart][Concurrency in Dart].
Se os seus dados forem grandes e complexos,
você pode mover a recuperação e a decodificação
para outro [isolate][] como um worker em segundo plano,
evitando que a sua interface fique sem resposta.

[Concurrency in Dart]: /language/concurrency
[isolate]: /language/concurrency#isolates

[URI]: https://wikipedia.org/wiki/Uniform_Resource_Identifier
[Using JSON]: /libraries/serialization/json
[convert-docs]: {{site.dart-api}}/dart-convert/dart-convert-library.html
[http-pub]: {{site.pub-pkg}}/http
[http-docs]: {{site.pub-api}}/http
