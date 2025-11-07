---
ia-translate: true
title: Criando pacotes
description: Aprenda como criar pacotes em Dart.
---

The Dart ecosystem uses [packages](/tools/pub/packages)
to share software such as libraries and tools.
This page tells you how to create a standard shared 
[package](/resources/glossary#package).

## Criando um novo pacote {:#creating-a-new-package}

To create the initial directory and structure for a package,
use the [`dart create`][] command
and the `package` template:

```console
$ dart create -t package <NOME_DO_PACOTE>
```

To learn more about available templates and how to use the `-t` flag, 
see the [`dart create` documentation][].

[`dart create`]: /tools/dart-create
[`dart create` documentation]: /tools/dart-create#available-templates

## What makes a package

O diagrama a seguir mostra o layout mais simples de um pacote:

<img
  src="/assets/img/libraries/simple-lib2.png"
  class="diagram-wrap"
  alt="root directory contains pubspec.yaml and lib/file.dart">

Os requisitos mínimos para uma biblioteca são:

Arquivo pubspec
: O arquivo `pubspec.yaml` para uma biblioteca é o mesmo
  que para um [pacote de aplicação][]—não há nenhuma
  designação especial para indicar que o pacote é uma biblioteca.

Diretório lib
: Como você deve imaginar, o código da biblioteca fica no diretório _lib_
  e é público para outros pacotes.
  Você pode criar qualquer hierarquia em lib, conforme necessário.
  Por convenção, o código de implementação é colocado em _lib/src_.
  O código em lib/src é considerado privado;
  outros pacotes nunca devem precisar importar `src/...`.
  Para tornar as APIs em lib/src públicas, você pode exportar arquivos de lib/src
  de um arquivo que esteja diretamente em lib.

[application package]: /resources/glossary#application-package

## Organizando um pacote {:#organizing-a-package}

Pacotes são mais fáceis de manter, estender e testar
quando você cria bibliotecas pequenas e individuais, referidas como
_mini bibliotecas_.
Na maioria dos casos, cada classe deve estar em sua própria mini biblioteca, a menos
que você tenha uma situação em que duas classes estejam fortemente acopladas.

:::note
Você pode conhecer a diretiva `part` (parte).
Essa diretiva permite dividir uma biblioteca em vários arquivos Dart.
Embora os arquivos part possam incorporar código gerado em uma biblioteca,
a equipe do Dart não recomenda usá-los.
Em vez disso, crie pequenas bibliotecas.
:::

Crie um arquivo de biblioteca "principal" diretamente em lib,
lib/_&lt;nome-do-pacote&gt;_.dart, que
exporta todas as APIs públicas.
Isso permite que o usuário obtenha toda a funcionalidade de uma biblioteca
importando um único arquivo.

O diretório lib também pode incluir outras bibliotecas importáveis, não-src.
Por exemplo, talvez sua biblioteca principal funcione em várias plataformas, mas
você crie bibliotecas separadas que dependem de `dart:io` ou `dart:js_interop`.
Alguns pacotes têm bibliotecas separadas que devem ser importadas
com um prefixo, quando a biblioteca principal não é.

Vamos analisar a organização de um pacote do mundo real: shelf (prateleira). O
[shelf]({{site.repo.dart.org}}/shelf)
pacote fornece uma maneira fácil de criar servidores web usando Dart,
e é organizado em uma estrutura que é comumente usada para pacotes Dart:

<img
  src="/assets/img/libraries/shelf.png"
  class="diagram-wrap"
  alt="shelf root directory contains example, lib, test, and tool subdirectories">

Diretamente em lib, o arquivo da biblioteca principal,
`shelf.dart`, exporta APIs de vários arquivos em `lib/src`.
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

O pacote shelf também contém uma mini biblioteca: shelf_io.
Este adaptador lida com objetos HttpRequest de `dart:io`.

:::tip
Para o melhor desempenho ao desenvolver com o
compilador JavaScript de desenvolvimento através de [`webdev serve`][],
coloque os [arquivos de implementação](/tools/pub/package-layout#implementation-files)
em `/lib/src`, em vez de em outro lugar em `/lib`.
Além disso, evite importações de <code>package:<em>nome_do_pacote</em>/src/...</code>.
:::

[`webdev serve`]: /tools/webdev#serve

## Importando arquivos de biblioteca {:#importing-library-files}

Ao importar um arquivo de biblioteca de outro pacote, use
a diretiva `package:` para especificar o URI desse arquivo.

```dart
import 'package:utilities/utilities.dart';
```

Ao importar um arquivo de biblioteca do seu próprio pacote,
use um caminho relativo quando ambos os arquivos estiverem dentro de lib,
ou quando ambos os arquivos estiverem fora de lib.
Use `package:` quando o arquivo importado estiver em lib e o importador estiver fora.

O gráfico a seguir mostra como
importar `lib/foo/a.dart` de lib e web.

<img
  src="/assets/img/libraries/import-lib-rules.png"
  class="diagram-wrap"
  alt="lib/bar/b.dart uses a relative import; web/main.dart uses a package import">


## Importando e exportando arquivos de biblioteca condicionalmente {:#conditionally-importing-and-exporting-library-files}

Se sua biblioteca suporta várias plataformas,
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

* Em um aplicativo que pode usar `dart:io`
  (por exemplo, um aplicativo de linha de comando),
  exporte `src/hw_io.dart`.
* Em um aplicativo que pode usar `dart:js_interop`
  (um aplicativo web),
  exporte `src/hw_web.dart`.
* Caso contrário, exporte `src/hw_none.dart`.

Para importar um arquivo condicionalmente, use o mesmo código acima,
mas altere `export` para `import`.

:::note
Importações ou exportações condicionais funcionam apenas com chaves no ambiente de compilação.
Qualquer sequência de identificadores separados por pontos é uma sintaxe válida.
Atualmente, apenas chaves da forma `dart.library.name` são fornecidas.
`dart.library.name` é definido como `"true"` no ambiente de compilação
se a biblioteca `dart:name` estiver _disponível para uso_ na
plataforma atual, não se ela está realmente importada ou usada.
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

## Fornecendo arquivos adicionais {:#providing-additional-files}

Um pacote bem projetado é fácil de testar.
Recomendamos que você escreva testes usando o
pacote [test]({{site.repo.dart.org}}/test),
colocando o código de teste no diretório `test` no
topo do pacote.

Se você criar quaisquer ferramentas de linha de comando destinadas ao consumo público,
coloque-as no diretório `bin`, que é público.
Permita executar uma ferramenta a partir da linha de comando, usando
[`dart pub global activate`](/tools/pub/cmd/pub-global#activating-a-package).
Listar a ferramenta na
seção [`executables`](/tools/pub/pubspec#executables)
do pubspec permite que um usuário execute-a diretamente sem chamar
[`dart pub global run`](/tools/pub/cmd/pub-global#running-a-script-using-dart-pub-global-run).

É útil se você incluir um exemplo de como usar sua biblioteca.
Isso vai para o diretório `example` no topo do pacote.

Quaisquer ferramentas ou executáveis que você criar durante o desenvolvimento que não sejam para
uso público vão para o diretório `tool` (ferramenta).

Outros arquivos que são necessários se você publicar sua biblioteca no
site [pub.dev]({{site.pub}}), como `README.md` e `CHANGELOG.md`, são
descritos em [Publicando um pacote](/tools/pub/publishing).
Para mais informações sobre como organizar um diretório de pacote,
veja as [convenções de layout de pacotes do pub](/tools/pub/package-layout).

## Documentando uma biblioteca {:#documenting-a-library}

Você pode gerar documentação de API para sua biblioteca usando
a ferramenta [`dart doc`][].
`dart doc` analisa a fonte procurando por
[comentários de documentação](/effective-dart/documentation#doc-comments),
que usam a sintaxe `///`:

```dart
/// O manipulador de eventos responsável por atualizar o badge na UI.
void updateBadge() {
  ...
}
```

Para um exemplo de documentação gerada, veja a
[documentação do shelf.]({{site.pub-api}}/shelf/latest)

Para incluir qualquer documentação de *nível de biblioteca* na documentação gerada,
adicione uma diretiva `library` e anexe o comentário diretamente acima dela.
Para o como e o porquê de documentar bibliotecas, veja
[Effective Dart: Documentação](/effective-dart/documentation#consider-writing-a-library-level-doc-comment).


## Distribuindo uma biblioteca de código aberto {:#distributing-a-library}

Se sua biblioteca é de código aberto,
recomendamos compartilhá-la no [site pub.dev.]({{site.pub}})
Para publicar ou atualizar a biblioteca,
use [pub publish](/tools/pub/cmd/pub-lish),
que envia seu pacote e cria ou atualiza sua página.
Por exemplo, veja a página do [pacote shelf.]({{site.pub-pkg}}/shelf)
Veja [Publicando um pacote](/tools/pub/publishing)
para detalhes sobre como preparar seu pacote para publicação.

O site pub.dev não apenas hospeda seu pacote,
mas também gera e hospeda a documentação de referência da API do seu pacote.
Um link para a documentação gerada mais recente está na caixa **Sobre** do pacote;
por exemplo, veja a
[documentação da API.]({{site.pub-api}}/shelf) do pacote shelf.
Links para a documentação de versões anteriores estão na
aba **Versões** da página do pacote.

Para garantir que a documentação da API do seu pacote fique boa no site pub.dev,
siga estas etapas:

* Antes de publicar seu pacote, execute a ferramenta [`dart doc`][]
  para garantir que sua documentação seja gerada com sucesso e pareça como esperado.
* Depois de publicar seu pacote, verifique a aba **Versões**
  para garantir que a documentação foi gerada com sucesso.
* Se a documentação não foi gerada,
  clique em **falhou** na aba **Versões** para ver a saída do `dart doc`.

## Recursos {:#resources}

Use os seguintes recursos para saber mais sobre pacotes:

* [Bibliotecas e importações](/language/libraries) cobre
  o uso de arquivos de biblioteca.
* A documentação do [pacote](/tools/pub/packages) é útil, particularmente as
  [convenções de layout de pacotes](/tools/pub/package-layout).
* [O que não commitar](/tools/pub/private-files)
  cobre o que não deve ser incluído em um repositório de código fonte.
* Os pacotes mais novos sob a
  organização [dart-lang]({{site.repo.dart.org}}) tendem
  a mostrar as melhores práticas. Considere estudar estes exemplos:
  [dart_style,]({{site.repo.dart.org}}/dart_style)
  [path,]({{site.repo.dart.org}}/core/tree/main/pkgs/path)
  [shelf,]({{site.repo.dart.org}}/shelf)
  [source_gen,]({{site.repo.dart.org}}/source_gen) e
  [test.]({{site.repo.dart.org}}/test)

[`dart doc`]: /tools/dart-doc
