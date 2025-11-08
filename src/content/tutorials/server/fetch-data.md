---
ia-translate: true
title: Buscar dados da internet
description: Busque dados pela internet usando o pacote http.
prevpage:
  url: /tutorials/server/cmdline
  title: Escrever aplicações de linha de comando
nextpage:
  url: /tutorials/server/httpserver
  title: Escrever servidores HTTP
---

<?code-excerpt path-base="fetch_data"?>

:::secondary What you'll learn
* O básico sobre o que são requisições HTTP e URIs e para que são usados.
* Fazendo requisições HTTP usando `package:http`.
* Decodificando strings JSON em objetos Dart com `dart:convert`.
* Convertendo objetos JSON em estruturas baseadas em classes.
:::

A maioria das aplicações requer alguma forma de comunicação ou
recuperação de dados da internet.
Muitas aplicações fazem isso através de requisições HTTP,
que são enviadas de um cliente para um servidor
para realizar uma ação específica para um recurso
identificado através de uma [URI][] (Uniform Resource Identifier).

Dados comunicados via HTTP podem tecnicamente estar em qualquer formato,
mas usar [JSON][] (JavaScript Object Notation)
é uma escolha popular devido à sua legibilidade humana
e natureza independente de linguagem.
O Dart SDK e ecossistema também têm suporte extensivo para JSON
com múltiplas opções para melhor atender aos requisitos da sua aplicação.

Neste tutorial,
você vai aprender mais sobre requisições HTTP, URIs e JSON.
Então você vai aprender como usar [`package:http`][http-pub]
bem como o suporte JSON do Dart na biblioteca [`dart:convert`][convert-docs]
para buscar, decodificar e então usar dados formatados em JSON
recuperados de um servidor HTTP.

[JSON]: https://www.json.org/

## Conceitos de fundo

As seções a seguir fornecem algum fundo extra e informações
sobre as tecnologias e conceitos usados no tutorial
para facilitar a busca de dados do servidor.
Para pular diretamente para o conteúdo do tutorial,
veja [Recuperar as dependências necessárias][Retrieve the necessary dependencies].

[Retrieve the necessary dependencies]: #recuperar-as-dependências-necessárias

### JSON

JSON (JavaScript Object Notation) é um formato de intercâmbio de dados
que se tornou onipresente em
desenvolvimento de aplicações e comunicação cliente-servidor.
É leve mas também fácil para
humanos lerem e escreverem devido a ser baseado em texto.
Com JSON, vários tipos de dados e estruturas de dados simples
como listas e maps podem ser serializados e representados por strings.

A maioria das linguagens tem muitas implementações e
parsers tornaram-se extremamente rápidos,
então você não precisa se preocupar com interoperabilidade ou performance.
Para mais informações sobre o formato JSON, veja [Introducing JSON][].
Para aprender mais sobre trabalhar com JSON em Dart,
veja o guia [Using JSON][].

:::secondary
Dois outros pacotes existem com implementações específicas de plataforma para mobile.

* [cronet_http]({{site.pub-pkg}}/cronet_http)
  fornece acesso ao cliente HTTP [Cronet][] do Android.
* [cupertino_http]({{site.pub-pkg}}/cupertino_http)
  fornece acesso ao [Foundation URL Loading System][furl] da Apple.

Para aprender mais sobre suas capacidades,
consulte a documentação do pacote.
:::

[Cronet]: {{site.android-dev}}/develop/connectivity/cronet
[furl]: {{site.apple-dev}}/documentation/foundation/url_loading_system
[Introducing JSON]: https://www.json.org/

### Requisições HTTP

HTTP (Hypertext Transfer Protocol) é um protocolo stateless
projetado para transmitir documentos,
originalmente entre clientes web e servidores web.
Você interagiu com o protocolo para carregar esta página,
já que seu navegador usa uma requisição HTTP `GET`
para recuperar o conteúdo de uma página de um servidor web.
Desde sua introdução, o uso do protocolo HTTP e suas várias versões
se expandiu para aplicações fora da web também,
essencialmente onde quer que comunicação de um cliente para um servidor seja necessária.

Requisições HTTP enviadas do cliente para se comunicar com o servidor
são compostas de múltiplos componentes.
Bibliotecas HTTP, como `package:http`, permitem que você
especifique os seguintes tipos de comunicação:

* Um método HTTP definindo a ação desejada,
  como `GET` para recuperar dados ou `POST` para submeter novos dados.
* A localização do recurso através de uma URI.
* A versão do HTTP sendo usada.
* Headers que fornecem informações extras ao servidor.
* Um body opcional, para que a requisição possa enviar dados ao servidor,
  não apenas recuperá-los.

Para aprender mais sobre o protocolo HTTP,
confira [An overview of HTTP][] no mdn web docs.

[An overview of HTTP]: https://developer.mozilla.org/docs/Web/HTTP/Overview

### URIs e URLs

Para fazer uma requisição HTTP,
você precisa fornecer uma [URI][] (Uniform Resource Identifier) para o recurso.
Uma URI é uma string de caracteres que identifica unicamente um recurso.
Uma URL (Uniform Resource Locator) é um tipo específico de URI
que também fornece a localização do recurso.
URLs para recursos na web contêm três peças de informação.
Para esta página atual, a URL é composta de:

* O scheme usado para determinar o protocolo usado: `https`
* A autoridade ou hostname do servidor: `dart.dev`
* O path para o recurso: `/tutorials/server/fetch-data.html`

Existem outros parâmetros opcionais também
que não são usados pela página atual:

* Parâmetros para personalizar comportamento extra: `?key1=value1&key2=value2`
* Uma âncora, que não é enviada ao servidor,
  que aponta para uma localização específica no recurso: `#uris`

Para aprender mais sobre URLs,
veja [What is a URL?][] no mdn web docs.

[What is a URL?]: https://developer.mozilla.org/docs/Learn/Common_questions/What_is_a_URL

## Recuperar as dependências necessárias

A biblioteca `package:http` fornece uma solução multiplataforma
para fazer requisições HTTP componíveis,
com controle fino-granulado opcional.

:::note
Evite usar diretamente `dart:io` ou `dart:html` para fazer requisições HTTP.
Essas bibliotecas são dependentes de plataforma e vinculadas a uma única implementação.
:::

Para adicionar uma dependência em `package:http`,
execute o seguinte comando [`dart pub add`][]
do topo do seu repositório:

```console
$ dart pub add http
```

Para usar `package:http` no seu código,
importe-o e opcionalmente [especifique um prefixo de biblioteca][specify a library prefix]:

<?code-excerpt "lib/fetch_data.dart (http-import)"?>
```dart
import 'package:http/http.dart' as http;
```

Para aprender mais especificidades sobre `package:http`,
veja sua [página no site pub.dev][http-pub]
e sua [documentação da API][http-docs].

[`dart pub add`]: /tools/pub/cmd/pub-add
[specify a library prefix]: /language/libraries#specifying-a-library-prefix

## Construir uma URL

Como mencionado anteriormente,
para fazer uma requisição HTTP,
você primeiro precisa de uma URL que identifique
o recurso sendo solicitado
ou endpoint sendo acessado.

Em Dart, URLs são representadas através de objetos [`Uri`][].
Existem muitas maneiras de construir um `Uri`,
mas devido à sua flexibilidade,
analisar uma string com `Uri.parse` para
criar uma é uma solução comum.

O snippet a seguir mostra duas maneiras
de criar um objeto `Uri`
apontando para informações mock formatadas em JSON
sobre `package:http` hospedado neste site:

<?code-excerpt "lib/fetch_data.dart (build-uris)"?>
```dart
// Parse the entire URI, including the scheme
Uri.parse('https://dart.dev/f/packages/http.json');

// Specifically create a URI with the https scheme
Uri.https('dart.dev', '/f/packages/http.json');
```

Para aprender sobre outras maneiras de construir e interagir com URIs,
veja a [documentação do `URI`][`URI` documentation].

[`Uri`]: {{site.dart-api}}/dart-core/Uri-class.html
[`URI` documentation]: /libraries/dart-core#uris

## Fazer uma requisição de rede

Se você apenas precisa rapidamente buscar uma representação string
de um recurso solicitado,
você pode usar a função de nível superior [`read`][http-read]
encontrada em `package:http`
que retorna um `Future<String>` ou lança
uma [`ClientException`][http-client-exc] se a requisição não foi bem-sucedida.
O exemplo a seguir usa `read` para
recuperar as informações mock formatadas em JSON
sobre `package:http` como uma string,
então as imprime:

:::note
Muitas funções em `package:http`, incluindo `read`,
acessam a rede e realizam operações potencialmente demoradas,
portanto fazem isso assincronamente e retornam um [`Future`][].
Se você ainda não encontrou futures,
você pode aprender sobre eles—bem como as keywords `async` e `await`—no
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

Isso resulta na seguinte saída formatada em JSON,
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

Note a estrutura dos dados
(neste caso um map),
já que você vai precisar dela ao decodificar o JSON mais tarde.

Se você precisar de outras informações da resposta,
como o [código de status][status code] ou os [headers][],
você pode em vez disso usar a função de nível superior [`get`][http-get]
que retorna um `Future` com um [`Response`][http-response].

O snippet a seguir usa `get` para obter a resposta completa
para sair mais cedo se a requisição não foi bem-sucedida,
o que é indicado com um código de status de **200**:

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

Existem muitos outros códigos de status além de **200**
e sua aplicação pode querer lidar com eles de forma diferente.
Para aprender mais sobre o que diferentes códigos de status significam,
veja [HTTP response status codes][] no mdn web docs.

Algumas requisições ao servidor requerem mais informações,
como autenticação ou informações de user-agent;
neste caso você pode precisar incluir [HTTP headers][headers].
Você pode especificar headers passando um `Map<String, String>`
dos pares chave-valor como o parâmetro nomeado opcional `headers`:

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

### Fazer múltiplas requisições

Se você está fazendo múltiplas requisições ao mesmo servidor,
você pode em vez disso manter uma conexão persistente
através de um [`Client`][http-client],
que tem métodos similares aos de nível superior.
Apenas certifique-se de limpar com
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

Para habilitar o cliente a retentar requisições falhadas,
importe `package:http/retry.dart` e
envolva seu `Client` criado em um [`RetryClient`][http-retry-client]:

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

O `RetryClient` tem um comportamento padrão para quantas
vezes retentar e quanto tempo esperar entre cada requisição,
mas seu comportamento pode ser modificado através de parâmetros
para os construtores [`RetryClient()`][http-retry-client-cons]
ou [`RetryClient.withDelays()`][http-retry-client-delay].

`package:http` tem muito mais funcionalidade e customização,
então certifique-se de conferir sua [página no site pub.dev][http-pub]
e sua [documentação da API][http-docs].

[http-client]: {{site.pub-api}}/http/latest/http/Client-class.html
[http-close]: {{site.pub-api}}/http/latest/http/Client/close.html
[http-retry-client]: {{site.pub-api}}/http/latest/retry/RetryClient-class.html
[http-retry-client-cons]: {{site.pub-api}}/http/latest/retry/RetryClient/RetryClient.html
[http-retry-client-delay]: {{site.pub-api}}/http/latest/retry/RetryClient/RetryClient.withDelays.html

## Decodificar os dados recuperados

Enquanto você agora fez uma requisição de rede
e recuperou os dados retornados como string,
acessar porções específicas de informação
de uma string pode ser um desafio.

Já que os dados já estão em um formato JSON,
você pode usar a função built-in [`json.decode`][decode-docs] do Dart
na biblioteca `dart:convert`
para converter a string bruta em
uma representação JSON usando objetos Dart.
Neste caso, os dados JSON são representados em uma estrutura map
e, em JSON, chaves de map são sempre strings,
então você pode fazer cast do resultado de `json.decode` para um `Map<String, dynamic>`:

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

### Criar uma classe estruturada para armazenar os dados

Para fornecer ao JSON decodificado mais estrutura,
tornando mais fácil trabalhar com ele,
crie uma classe que possa armazenar os
dados recuperados usando tipos específicos dependendo
do schema dos seus dados.

O snippet a seguir mostra uma representação baseada em classe
que pode armazenar as informações do pacote retornadas
do arquivo JSON mock que você solicitou.
Esta estrutura assume que todos os campos exceto o `repository`
são obrigatórios e fornecidos toda vez.

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

### Codificar os dados na sua classe

Agora que você tem uma classe para armazenar seus dados,
você precisa adicionar um mecanismo para converter
o JSON decodificado em um objeto `PackageInfo`.

Converta o JSON decodificado
escrevendo manualmente um método `fromJson`
correspondendo ao formato JSON anterior,
fazendo cast de tipos conforme necessário
e lidando com o campo opcional `repository`:

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
é frequentemente suficiente para estruturas JSON relativamente simples,
mas existem opções mais flexíveis também.
Para aprender mais sobre serialização e desserialização JSON,
incluindo geração automática da lógica de conversão,
veja o guia [Using JSON][].

### Converter a resposta para um objeto da sua classe estruturada

Agora você tem uma classe para armazenar seus dados
e uma maneira de converter o objeto JSON decodificado
em um objeto desse tipo.
Em seguida, você pode escrever uma função que
junta tudo:

1. Criar seu `URI` baseado em um nome de pacote passado.
2. Usar `http.get` para recuperar os dados para esse pacote.
3. Se a requisição não teve sucesso, lançar uma `Exception`
   ou preferencialmente sua própria subclasse de `Exception` personalizada.
4. Se a requisição teve sucesso, usar `json.decode` para
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

## Utilizar os dados convertidos

Agora que você recuperou dados e
os converteu para um formato mais facilmente acessível,
você pode usá-los como quiser.
Algumas possibilidades incluem
exibir informações para um CLI, ou
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
Para outro exemplo que cobre buscar e então exibir dados no Flutter,
veja a receita Flutter [Fetching data from the internet][].
:::

[web]: /web
[Flutter]: {{site.flutter}}
[Fetching data from the internet]: {{site.flutter-docs}}/cookbook/networking/fetch-data

## E agora?

Agora que você recuperou, analisou e usou
dados da internet,
considere aprender mais sobre [Concorrência em Dart][Concurrency in Dart].
Se seus dados são grandes e complexos,
você pode mover a recuperação e decodificação
para outro [isolate][] como um trabalhador em segundo plano
para evitar que sua interface fique sem resposta.

[Concurrency in Dart]: /language/concurrency
[isolate]: /language/concurrency#isolates

[URI]: https://wikipedia.org/wiki/Uniform_Resource_Identifier
[Using JSON]: /libraries/serialization/json
[convert-docs]: {{site.dart-api}}/dart-convert/dart-convert-library.html
[http-pub]: {{site.pub-pkg}}/http
[http-docs]: {{site.pub-api}}/http
