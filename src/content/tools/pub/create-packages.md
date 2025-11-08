---
title: Creating packages
description: Learn how to create packages in Dart.
ia-translate: true
---

O ecossistema Dart usa [packages](/tools/pub/packages)
para compartilhar software como bibliotecas e ferramentas.
Esta página ensina como criar um
[package](/resources/glossary#package) compartilhado padrão.

## Creating a new package

Para criar o diretório e estrutura inicial para um pacote,
use o comando [`dart create`][]
e o template `package`:

```console
$ dart create -t package <PACKAGE_NAME>
```

Para saber mais sobre os templates disponíveis e como usar a flag `-t`,
veja a [`dart create` documentation][].

[`dart create`]: /tools/dart-create
[`dart create` documentation]: /tools/dart-create#available-templates

## What makes a package

O diagrama a seguir mostra o layout mais simples de um pacote:

<img
  src="/assets/img/libraries/simple-lib2.png"
  class="diagram-wrap"
  alt="root directory contains pubspec.yaml and lib/file.dart">

Os requisitos mínimos para uma biblioteca são:

pubspec file
: O arquivo `pubspec.yaml` para uma biblioteca é o mesmo
  que para um [application package][]—não há designação especial
  para indicar que o pacote é uma biblioteca.

lib directory
: Como você pode esperar, o código da biblioteca fica sob o diretório _lib_
  e é público para outros pacotes.
  Você pode criar qualquer hierarquia sob lib, conforme necessário.
  Por convenção, código de implementação é colocado sob _lib/src_.
  Código sob lib/src é considerado privado;
  outros pacotes nunca devem precisar importar `src/...`.
  Para tornar APIs sob lib/src públicas, você pode exportar arquivos lib/src
  de um arquivo que está diretamente sob lib.

[application package]: /resources/glossary#application-package

## Organizing a package

Pacotes são mais fáceis de manter, estender e testar
quando você cria bibliotecas pequenas e individuais, referidas como
_mini libraries_.
Na maioria dos casos, cada classe deve estar em sua própria mini library, a menos que
você tenha uma situação onde duas classes estão fortemente acopladas.

:::note
Você pode conhecer a diretiva `part`.
Esta diretiva permite dividir uma biblioteca em múltiplos arquivos Dart.
Embora arquivos part possam incorporar código gerado em uma biblioteca,
o time Dart não recomenda usá-los.
Em vez disso, crie bibliotecas pequenas.
:::

Crie um arquivo de biblioteca "main" diretamente sob lib,
lib/_&lt;package-name&gt;_.dart, que
exporta todas as APIs públicas.
Isso permite que o usuário obtenha toda a funcionalidade de uma biblioteca
importando um único arquivo.

O diretório lib também pode incluir outras bibliotecas importáveis, não-src.
Por exemplo, talvez sua biblioteca principal funcione em todas as plataformas, mas
você cria bibliotecas separadas que dependem de `dart:io` ou `dart:js_interop`.
Alguns pacotes têm bibliotecas separadas que devem ser importadas
com um prefixo, quando a biblioteca principal não é.

Vamos ver a organização de um pacote do mundo real: shelf. O
pacote [shelf]({{site.repo.dart.org}}/shelf)
fornece uma maneira fácil de criar servidores web usando Dart,
e é organizado em uma estrutura que é comumente usada para pacotes Dart:

<img
  src="/assets/img/libraries/shelf.png"
  class="diagram-wrap"
  alt="shelf root directory contains example, lib, test, and tool subdirectories">

Diretamente sob lib, o arquivo de biblioteca principal,
`shelf.dart`, exporta API de vários arquivos em `lib/src`.
Para evitar expor mais API do que o pretendido—e
para dar aos desenvolvedores uma visão geral de toda a
API pública do pacote—`shelf.dart`
usa `show` para especificar exatamente quais símbolos exportar:

```dart title="lib/shelf.dart"
export 'src/cascade.dart' show Cascade;
export 'src/handler.dart' show Handler;
export 'src/hijack_exception.dart' show HijackException;
export 'src/middleware.dart' show Middleware, createMiddleware;
export 'src/middleware/add_chunked_encoding.dart' show addChunkedEncoding;
export 'src/middleware/logger.dart' show logRequests;
export 'src/middleware_extensions.dart' show MiddlewareExtensions;
export 'src/pipeline.dart' show Pipeline;
export 'src/request.dart' show Request;
export 'src/response.dart' show Response;
export 'src/server.dart' show Server;
export 'src/server_handler.dart' show ServerHandler;
```

O pacote shelf também contém uma mini library: shelf_io.
Este adaptador manipula objetos HttpRequest de `dart:io`.

:::tip
Para o melhor desempenho ao desenvolver com o
compilador JavaScript de desenvolvimento através de [`webdev serve`][],
coloque [implementation files](/tools/pub/package-layout#implementation-files)
sob `/lib/src`, em vez de em outro lugar sob `/lib`.
Além disso, evite imports de <code>package:<em>package_name</em>/src/...</code>.
:::

[`webdev serve`]: /tools/webdev#serve

## Importing library files

Ao importar um arquivo de biblioteca de outro pacote, use
a diretiva `package:` para especificar a URI daquele arquivo.

```dart
import 'package:utilities/utilities.dart';
```

Ao importar um arquivo de biblioteca do seu próprio pacote,
use um caminho relativo quando ambos os arquivos estiverem dentro de lib,
ou quando ambos os arquivos estiverem fora de lib.
Use `package:` quando o arquivo importado estiver em lib e o importador estiver fora.

O gráfico a seguir mostra como
importar `lib/foo/a.dart` tanto de lib quanto de web.

<img
  src="/assets/img/libraries/import-lib-rules.png"
  class="diagram-wrap"
  alt="lib/bar/b.dart uses a relative import; web/main.dart uses a package import">


## Conditionally importing and exporting library files

Se sua biblioteca suporta múltiplas plataformas,
então você pode precisar importar ou exportar arquivos de biblioteca condicionalmente.
Um caso de uso comum é uma biblioteca que suporta plataformas web e nativas.

Para importar ou exportar condicionalmente,
você precisa verificar a presença de bibliotecas `dart:*`.
Aqui está um exemplo de código de exportação condicional que
verifica a presença de `dart:io` e `dart:js_interop`:

<?code-excerpt "create_libraries/lib/hw_mp.dart (export)"?>
```dart title="lib/hw_mp.dart"
export 'src/hw_none.dart' // Stub implementation
    if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
    if (dart.library.js_interop) 'src/hw_web.dart'; // package:web implementation
```

Aqui está o que esse código faz:

* Em um app que pode usar `dart:io`
  (por exemplo, um app de linha de comando),
  exporta `src/hw_io.dart`.
* Em um app que pode usar `dart:js_interop`
  (um app web),
  exporta `src/hw_web.dart`.
* Caso contrário, exporta `src/hw_none.dart`.

Para importar um arquivo condicionalmente, use o mesmo código acima,
mas mude `export` para `import`.

:::note
Imports ou exports condicionais só funcionam com chaves no ambiente de
compilação. Qualquer sequência de identificadores separados por ponto é sintaxe válida.
Atualmente, apenas chaves da forma `dart.library.name` são fornecidas.
`dart.library.name` é definido como `"true"` no ambiente de
compilação se a biblioteca `dart:name` está _disponível para uso_ na
plataforma atual, não se está realmente importada ou usada.
:::

Todas as bibliotecas exportadas condicionalmente devem implementar a mesma API.
Por exemplo, aqui está a implementação `dart:io`:

<?code-excerpt "create_libraries/lib/src/hw_io.dart"?>
```dart title="lib/src/hw_io.dart"
import 'dart:io';

void alarm([String? text]) {
  stderr.writeln(text ?? message);
}

String get message => 'Hello World from the VM!';
```

E aqui está a implementação padrão,
que usa stubs que lançam `UnsupportedError`:

<?code-excerpt "create_libraries/lib/src/hw_none.dart"?>
```dart title="lib/src/hw_none.dart"
void alarm([String? text]) => throw UnsupportedError('hw_none alarm');

String get message => throw UnsupportedError('hw_none message');
```

Em qualquer plataforma,
você pode importar a biblioteca que tem o código de exportação condicional:

<?code-excerpt "create_libraries/example/hw_example.dart" replace="/create_libraries/hw_mp/g"?>
```dart
import 'package:hw_mp/hw_mp.dart';

void main() {
  print(message);
}
```

## Providing additional files

Um pacote bem projetado é fácil de testar.
Recomendamos que você escreva testes usando o
pacote [test]({{site.repo.dart.org}}/test),
colocando o código de teste no diretório `test` no
topo do pacote.

Se você criar quaisquer ferramentas de linha de comando destinadas ao consumo público,
coloque-as no diretório `bin`, que é público.
Habilite executar uma ferramenta da linha de comando, usando
[`dart pub global activate`](/tools/pub/cmd/pub-global#activating-a-package).
Listar a ferramenta na
seção [`executables`](/tools/pub/pubspec#executables)
do pubspec permite que um usuário a execute diretamente sem chamar
[`dart pub global run`](/tools/pub/cmd/pub-global#running-a-script-using-dart-pub-global-run).

É útil se você incluir um exemplo de como usar sua biblioteca.
Isso vai no diretório `example` no topo do pacote.

Quaisquer ferramentas ou executáveis que você criar durante o desenvolvimento que não são para
uso público vão no diretório `tool`.

Outros arquivos que são necessários se você publicar sua biblioteca no
site [pub.dev]({{site.pub}}), como `README.md` e `CHANGELOG.md`, são
descritos em [Publishing a package](/tools/pub/publishing).
Para mais informações sobre como organizar um diretório de pacote,
veja as [pub package layout conventions](/tools/pub/package-layout).

## Documenting a library

Você pode gerar documentação API para sua biblioteca usando
a ferramenta [`dart doc`][].
`dart doc` analisa o código-fonte procurando por
[documentation comments](/effective-dart/documentation#doc-comments),
que usam a sintaxe `///`:

```dart
/// The event handler responsible for updating the badge in the UI.
void updateBadge() {
  ...
}
```

Para um exemplo de documentação gerada, veja a
[documentação shelf.]({{site.pub-api}}/shelf/latest)

Para incluir qualquer documentação *em nível de biblioteca* na documentação gerada,
adicione uma diretiva `library` e anexe o comentário diretamente acima dela.
Para o como e porquê de documentar bibliotecas, veja
[Effective Dart: Documentation](/effective-dart/documentation#consider-writing-a-library-level-doc-comment).


## Distributing an open source library {:#distributing-a-library}

Se sua biblioteca é open source,
recomendamos compartilhá-la no [site pub.dev.]({{site.pub}})
Para publicar ou atualizar a biblioteca,
use [pub publish](/tools/pub/cmd/pub-lish),
que faz upload do seu pacote e cria ou atualiza sua página.
Por exemplo, veja a página do [pacote shelf.]({{site.pub-pkg}}/shelf)
Veja [Publishing a package](/tools/pub/publishing)
para detalhes sobre como preparar seu pacote para publicação.

O site pub.dev não apenas hospeda seu pacote,
mas também gera e hospeda a documentação de referência da API do seu pacote.
Um link para a documentação gerada mais recente está na caixa **About** do pacote;
por exemplo, veja a
[documentação API]({{site.pub-api}}/shelf) do pacote shelf.
Links para documentação de versões anteriores estão na
aba **Versions** da página do pacote.

Para garantir que a documentação API do seu pacote pareça boa no site pub.dev,
siga estas etapas:

* Antes de publicar seu pacote, execute a ferramenta [`dart doc`][]
  para ter certeza de que sua documentação gera com sucesso e parece como esperado.
* Após publicar seu pacote, verifique a aba **Versions**
  para ter certeza de que a documentação foi gerada com sucesso.
* Se a documentação não foi gerada,
  clique em **failed** na aba **Versions** para ver a saída do `dart doc`.

## Resources

Use os seguintes recursos para aprender mais sobre pacotes:

* [Libraries and imports](/language/libraries) cobre
  o uso de arquivos de biblioteca.
* A documentação de [package](/tools/pub/packages) é útil, particularmente as
  [package layout conventions](/tools/pub/package-layout).
* [What not to commit](/tools/pub/private-files)
  cobre o que não deve ser feito commit em um repositório de código-fonte.
* Os pacotes mais novos sob a
  organização [dart-lang]({{site.repo.dart.org}}) tendem
  a mostrar melhores práticas. Considere estudar estes exemplos:
  [dart_style,]({{site.repo.dart.org}}/dart_style)
  [path,]({{site.repo.dart.org}}/core/tree/main/pkgs/path)
  [shelf,]({{site.repo.dart.org}}/shelf)
  [source_gen,]({{site.repo.dart.org}}/source_gen) e
  [test.]({{site.repo.dart.org}}/test)

[`dart doc`]: /tools/dart-doc
