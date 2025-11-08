---
ia-translate: true
title: Buscar dados da internet
description: Buscar dados pela internet usando o pacote http.
prevpage:
  url: /tutorials/server/cmdline
  title: Escrever aplicativos de linha de comando
nextpage:
  url: /tutorials/server/httpserver
  title: Escrever servidores HTTP
---

<?code-excerpt path-base="fetch_data"?>

:::secondary O que você aprenderá
* O básico sobre o que são requisições HTTP e URIs e para que são usadas.
* Fazer requisições HTTP usando `package:http`.
* Decodificar strings JSON em objetos Dart com `dart:convert`.
* Converter objetos JSON em estruturas baseadas em classes.
:::

A maioria das aplicações requer alguma forma de comunicação ou
recuperação de dados da internet.
Muitos aplicativos fazem isso por meio de requisições HTTP,
que são enviadas de um cliente para um servidor
para realizar uma ação específica para um recurso
identificado através de um [URI][URI] (Identificador Uniforme de Recurso).

Os dados comunicados por HTTP podem tecnicamente estar em qualquer formato,
mas usar [JSON][JSON] (JavaScript Object Notation)
é uma escolha popular devido à sua legibilidade
e natureza independente de linguagem.
O SDK e o ecossistema Dart também têm amplo suporte para JSON
com várias opções para melhor atender aos requisitos do seu aplicativo.

Neste tutorial,
você aprenderá mais sobre requisições HTTP, URIs e JSON.
Então, você aprenderá como usar [`package:http`][http-pub]
bem como o suporte JSON do Dart na biblioteca [`dart:convert`][convert-docs]
para buscar, decodificar e usar dados formatados em JSON
recuperados de um servidor HTTP.

[JSON]: https://www.json.org/

## Conceitos básicos {:#background-concepts}

As seções a seguir fornecem alguns antecedentes e informações extras
sobre as tecnologias e conceitos usados no tutorial
para facilitar a busca de dados do servidor.
Para pular diretamente para o conteúdo do tutorial,
veja [Recuperar as dependências necessárias][Recuperar as dependências necessárias].

[Recuperar as dependências necessárias]: #retrieve-the-necessary-dependencies

### JSON {:#json}

JSON (JavaScript Object Notation) é um formato de intercâmbio de dados
que se tornou onipresente em
desenvolvimento de aplicativos e comunicação cliente-servidor.
É leve, mas também fácil para
humanos lerem e escreverem devido a ser baseado em texto.
Com JSON, vários tipos de dados e estruturas de dados simples
como listas e mapas podem ser serializados e representados por strings.

A maioria das linguagens tem muitas implementações e
os analisadores se tornaram extremamente rápidos,
então você não precisa se preocupar com interoperabilidade ou desempenho.
Para obter mais informações sobre o formato JSON, consulte [Apresentando JSON][Apresentando JSON].
Para aprender mais sobre como trabalhar com JSON em Dart,
consulte o guia [Usando JSON][Usando JSON].

:::secondary
Existem dois outros pacotes com implementações específicas de plataforma para celular.

* [cronet_http]({{site.pub-pkg}}/cronet_http)
  fornece acesso ao cliente HTTP [Cronet][Cronet] do Android.
* [cupertino_http]({{site.pub-pkg}}/cupertino_http)
  fornece acesso ao [Sistema de Carregamento de URL da Foundation][furl] da Apple.

Para saber mais sobre seus recursos,
consulte a documentação do pacote.
:::

[Cronet]: {{site.android-dev}}/develop/connectivity/cronet
[furl]: {{site.apple-dev}}/documentation/foundation/url_loading_system
[Apresentando JSON]: https://www.json.org/

### Requisições HTTP {:#http-requests}

HTTP (Hypertext Transfer Protocol ou Protocolo de Transferência de Hipertexto) é um protocolo sem estado
projetado para transmitir documentos,
originalmente entre clientes da web e servidores da web.
Você interagiu com o protocolo para carregar esta página,
já que seu navegador usa uma requisição HTTP `GET`
para recuperar o conteúdo de uma página de um servidor web.
Desde a sua introdução, o uso do protocolo HTTP e suas várias versões
se expandiram também para aplicações fora da web,
essencialmente onde quer que seja necessária a comunicação de um cliente para um servidor.

Requisições HTTP enviadas do cliente para se comunicar com o servidor
são compostas por vários componentes.
Bibliotecas HTTP, como `package:http`, permitem que você
especifique os seguintes tipos de comunicação:

* Um método HTTP definindo a ação desejada,
  como `GET` para recuperar dados ou `POST` para enviar novos dados.
* A localização do recurso por meio de um URI.
* A versão de HTTP que está sendo usada.
* Cabeçalhos que fornecem informações extras ao servidor.
* Um corpo opcional, para que a requisição possa enviar dados para o servidor,
  e não apenas recuperá-los.

Para aprender mais sobre o protocolo HTTP,
confira [Uma visão geral do HTTP][Uma visão geral do HTTP] nos documentos da web mdn.

[Uma visão geral do HTTP]: https://developer.mozilla.org/docs/Web/HTTP/Overview

### URIs e URLs {:#uris-and-urls}

Para fazer uma requisição HTTP,
você precisa fornecer um [URI][URI] (Identificador Uniforme de Recurso) para o recurso.
Um URI é uma string de caracteres que identifica exclusivamente um recurso.
Uma URL (Uniform Resource Locator ou Localizador Uniforme de Recursos) é um tipo específico de URI
que também fornece a localização do recurso.
URLs para recursos na web contêm três informações.
Para esta página atual, a URL é composta por:

* O esquema usado para determinar o protocolo usado: `https`
* A autoridade ou nome do host do servidor: `dartbrasil.dev`
* O caminho para o recurso: `/tutorials/server/fetch-data.html`

Existem também outros parâmetros opcionais
que não são usados pela página atual:

* Parâmetros para personalizar comportamento extra: `?key1=value1&key2=value2`
* Uma âncora, que não é enviada para o servidor,
  que aponta para um local específico no recurso: `#uris`

Para saber mais sobre URLs,
consulte [O que é uma URL?][O que é uma URL?] nos documentos da web mdn.

[O que é uma URL?]: https://developer.mozilla.org/docs/Learn/Common_questions/What_is_a_URL

## Recuperar as dependências necessárias {:#retrieve-the-necessary-dependencies}

A biblioteca `package:http` fornece uma solução multiplataforma
para fazer requisições HTTP que podem ser compostas,
com controle opcional e refinado.

:::note
Evite usar diretamente `dart:io` ou `dart:html` para fazer requisições HTTP.
Essas bibliotecas são dependentes de plataforma e vinculadas a uma única implementação.
:::

Para adicionar uma dependência em `package:http`,
execute o seguinte comando [`dart pub add`][`dart pub add`]
da parte superior do seu repositório:

```console
$ dart pub add http
```

Para usar `package:http` em seu código,
importe-o e opcionalmente [especifique um prefixo de biblioteca][especifique um prefixo de biblioteca]:

<?code-excerpt "lib/fetch_data.dart (http-import)"?>
```dart
import 'package:http/http.dart' as http;
```

Para saber mais detalhes sobre `package:http`,
consulte sua [página no site pub.dev][http-pub]
e sua [documentação da API][http-docs].

[`dart pub add`]: /tools/pub/cmd/pub-add
[especifique um prefixo de biblioteca]: /language/libraries#specifying-a-library-prefix

## Construir uma URL {:#build-a-url}

Como mencionado anteriormente,
para fazer uma requisição HTTP,
você primeiro precisa de uma URL que identifique
o recurso que está sendo solicitado
ou o endpoint que está sendo acessado.

Em Dart, URLs são representadas por meio de objetos [`Uri`][`Uri`].
Existem muitas maneiras de construir um `Uri`,
mas devido à sua flexibilidade,
analisar uma string com `Uri.parse` para
criar uma é uma solução comum.

O snippet a seguir mostra duas maneiras
de criar um objeto `Uri`
apontando para informações simuladas formatadas em JSON
sobre `package:http` hospedado neste site:

<?code-excerpt "lib/fetch_data.dart (build-uris)"?>
```dart
// Parse the entire URI, including the scheme
Uri.parse('https://dart.dev/f/packages/http.json');

// Specifically create a URI with the https scheme
Uri.https('dart.dev', '/f/packages/http.json');
```

Para aprender sobre outras maneiras de construir e interagir com URIs,
consulte a [documentação `URI`][`URI` documentação].

[`Uri`]: {{site.dart-api}}/dart-core/Uri-class.html
[`URI` documentação]: /libraries/dart-core#uris

## Fazer uma requisição de rede {:#make-a-network-request}

Se você precisar apenas buscar rapidamente uma representação de string
de um recurso solicitado,
você pode usar a função de nível superior [`read`][http-read]
encontrada em `package:http`
que retorna um `Future<String>` ou lança
uma [`ClientException`][http-client-exc] se a requisição não foi bem-sucedida.
O exemplo a seguir usa `read` para
recuperar as informações simuladas formatadas em JSON
sobre `package:http` como uma string,
e então imprime:

:::note
Muitas funções em `package:http`, incluindo `read`,
acessam a rede e realizam operações potencialmente demoradas,
portanto, elas fazem isso de forma assíncrona e retornam um [`Future`][`Future`].
Se você ainda não encontrou Futures,
você pode aprender sobre eles—assim como as palavras-chave `async` e `await`—no
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
  "publisher": "dartbrasil.dev",
  "repository": "https://github.com/dart-lang/http"
}
```

Observe a estrutura dos dados
(neste caso, um mapa),
pois você precisará dele ao decodificar o JSON mais tarde.

Se você precisar de outras informações da resposta,
como o [código de status][código de status] ou os [cabeçalhos][cabeçalhos],
você pode usar a função de nível superior [`get`][http-get]
que retorna um `Future` com uma [`Response`][http-response].

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
e seu aplicativo pode querer tratá-los de forma diferente.
Para saber mais sobre o que significam diferentes códigos de status,
consulte [Códigos de status de resposta HTTP][Códigos de status de resposta HTTP] nos documentos da web mdn.

Algumas requisições de servidor exigem mais informações,
como autenticação ou informações do user-agent;
nesse caso, você pode precisar incluir [cabeçalhos HTTP][cabeçalhos].
Você pode especificar cabeçalhos passando um `Map<String, String>`
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
[código de status]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
[cabeçalhos]: https://developer.mozilla.org/docs/Web/HTTP/Headers
[http-get]: {{site.pub-api}}/http/latest/http/get.html
[http-response]: {{site.pub-api}}/http/latest/http/Response-class.html
[Códigos de status de resposta HTTP]: https://developer.mozilla.org/docs/Web/HTTP/Status

### Fazer múltiplas requisições {:#make-multiple-requests}

Se você estiver fazendo múltiplas requisições para o mesmo servidor,
você pode manter uma conexão persistente
através de um [`Client`][http-client],
que tem métodos semelhantes aos de nível superior.
Certifique-se de limpar com o
método [`close`][http-close] quando terminar:

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

Para habilitar o cliente a tentar novamente requisições com falha,
importe `package:http/retry.dart` e
inclua seu `Client` criado em um [`RetryClient`][http-retry-client]:

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
vezes tentar novamente e quanto tempo esperar entre cada requisição,
mas seu comportamento pode ser modificado através de parâmetros
para os construtores [`RetryClient()`][http-retry-client-cons]
ou [`RetryClient.withDelays()`][http-retry-client-delay].

`package:http` tem muito mais funcionalidade e personalização,
então certifique-se de verificar sua [página no site pub.dev][http-pub]
e sua [documentação de API][http-docs].

[http-client]: {{site.pub-api}}/http/latest/http/Client-class.html
[http-close]: {{site.pub-api}}/http/latest/http/Client/close.html
[http-retry-client]: {{site.pub-api}}/http/latest/retry/RetryClient-class.html
[http-retry-client-cons]: {{site.pub-api}}/http/latest/retry/RetryClient/RetryClient.html
[http-retry-client-delay]: {{site.pub-api}}/http/latest/retry/RetryClient/RetryClient.withDelays.html

## Decodificar os dados recuperados {:#decode-the-retrieved-data}

Embora você agora tenha feito uma requisição de rede
e recuperado os dados retornados como string,
acessar porções específicas de informação
de uma string pode ser um desafio.

Como os dados já estão em formato JSON,
você pode usar a função [`json.decode`][decode-docs] integrada do Dart
na biblioteca `dart:convert`
para converter a string bruta em
uma representação JSON usando objetos Dart.
Nesse caso, os dados JSON são representados em uma estrutura de mapa
e, em JSON, as chaves de mapa são sempre strings,
então você pode converter o resultado de `json.decode` em um `Map<String, dynamic>`:

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

Para fornecer ao JSON decodificado mais estrutura,
tornando mais fácil de trabalhar,
crie uma classe que possa armazenar os
dados recuperados usando tipos específicos, dependendo
do esquema dos seus dados.

O snippet a seguir mostra uma representação baseada em classe
que pode armazenar as informações do pacote retornadas
do arquivo JSON simulado que você solicitou.
Essa estrutura pressupõe que todos os campos, exceto o `repository`
são obrigatórios e fornecidos sempre.

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

### Codificar os dados em sua classe {:#encode-the-data-into-your-class}

Agora que você tem uma classe para armazenar seus dados,
você precisa adicionar um mecanismo para converter
o JSON decodificado em um objeto `PackageInfo`.

Converta o JSON decodificado
escrevendo manualmente um método `fromJson`
correspondente ao formato JSON anterior,
convertendo tipos conforme necessário
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

Um método manuscrito, como no exemplo anterior,
é muitas vezes suficiente para estruturas JSON relativamente simples,
mas também existem opções mais flexíveis.
Para saber mais sobre serialização e desserialização JSON,
incluindo a geração automática da lógica de conversão,
consulte o guia [Usando JSON][Usando JSON].

### Converter a resposta em um objeto de sua classe estruturada {:#convert-the-response-to-an-object-of-your-structured-class}

Agora você tem uma classe para armazenar seus dados
e uma maneira de converter o objeto JSON decodificado
em um objeto desse tipo.
Em seguida, você pode escrever uma função que
junta tudo:

1. Crie seu `URI` com base em um nome de pacote passado.
2. Use `http.get` para recuperar os dados para esse pacote.
3. Se a requisição não for bem-sucedida, lance uma `Exception`
   ou, preferencialmente, sua própria subclasse `Exception` personalizada.
4. Se a requisição for bem-sucedida, use `json.decode` para
   decodificar o corpo da resposta em uma string JSON.
5. Converta a string JSON decodificada em um objeto `PackageInfo`
   usando o construtor de fábrica `PackageInfo.fromJson` que você criou.

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
os converteu em um formato mais facilmente acessível,
você pode usá-los como quiser.
Algumas possibilidades incluem
exibir informações em um CLI, ou
exibi-lo em um aplicativo [web][web] ou [Flutter][Flutter].

Aqui está um exemplo completo e executável
que solicita, decodifica e exibe
as informações simuladas sobre os pacotes `http` e `path`:

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
Para outro exemplo que aborda a busca e exibição de dados no Flutter,
consulte a receita do Flutter [Buscando dados da internet][Buscando dados da internet].
:::

[web]: /web
[Flutter]: {{site.flutter}}
[Buscando dados da internet]: {{site.flutter-docs}}/cookbook/networking/fetch-data

## O que vem a seguir? {:#what-next}

Agora que você recuperou, analisou e usou
dados da internet,
considere aprender mais sobre [Concorrência em Dart][Concorrência em Dart].
Se seus dados forem grandes e complexos,
você pode mover a recuperação e decodificação
para outro [isolado][isolado] como um worker em segundo plano
para evitar que sua interface fique sem resposta.

[Concorrência em Dart]: /language/concurrency
[isolado]: /language/concurrency#isolates

[URI]: https://wikipedia.org/wiki/Uniform_Resource_Identifier
[Usando JSON]: /libraries/serialization/json
[convert-docs]: {{site.dart-api}}/dart-convert/dart-convert-library.html
[http-pub]: {{site.pub-pkg}}/http
[http-docs]: {{site.pub-api}}/http