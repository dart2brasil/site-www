---
title: Libraries & imports
shortTitle: Libraries
description: Guidance on importing and implementing libraries.
prevpage:
  url: /language/metadata
  title: Metadados
nextpage:
  url: /language/classes
  title: Classes
---

As diretivas `import` e `library` podem ajudar você a criar uma base
de código modular e compartilhável. Bibliotecas não apenas fornecem APIs, mas
são uma unidade de privacidade: identificadores que começam com um underscore (`_`)
são visíveis apenas dentro da biblioteca. *Todo arquivo Dart (mais suas partes) é uma
[biblioteca][library]* (library), mesmo que não use uma diretiva [`library`](#library-directive).

Bibliotecas podem ser distribuídas usando [packages](/tools/pub/packages).

Dart uses underscores instead of access modifier keywords
like `public`, `protected`, or `private`.
While access modifier keywords from other languages
provide more fine-grained control,
Dart's use of underscores and library-based privacy
provides a straightforward configuration mechanism,
helps enable an efficient implementation of [dynamic access][],
and improves tree shaking (dead code elimination).

[library]: /resources/glossary#library
[dynamic access]: /effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking

## Usando bibliotecas {:#using-libraries}

Use `import` para especificar como um namespace de uma biblioteca é usado no
escopo de outra biblioteca.

Por exemplo, aplicativos web Dart geralmente usam a biblioteca [`dart:js_interop`][],
que eles podem importar assim:

<?code-excerpt "misc/test/language_tour/browser_test.dart (dart-js-interop-import)"?>
```dart
import 'dart:js_interop';
```

O único argumento necessário para `import` é um URI especificando a
biblioteca.
Para bibliotecas embutidas, o URI tem o esquema especial `dart:`.
Para outras bibliotecas, você pode usar um caminho do sistema de arquivos ou o
esquema `package:`. O esquema `package:` especifica bibliotecas fornecidas por
um gerenciador de pacotes como a ferramenta pub. Por exemplo:

<?code-excerpt "misc/test/language_tour/browser_test.dart (package-import)"?>
```dart
import 'package:test/test.dart';
```

:::note
*URI* significa identificador uniforme de recurso (uniform resource identifier).
*URLs* (localizadores uniformes de recursos) são um tipo comum de URI.
:::

### Especificando um prefixo de biblioteca {:#specifying-a-library-prefix}

Se você importar duas bibliotecas que têm identificadores conflitantes, então você
pode especificar um prefixo para uma ou ambas as bibliotecas. Por exemplo, se a biblioteca1
e a biblioteca2 ambas têm uma classe Element, então você pode ter código como
este:

<?code-excerpt "misc/lib/language_tour/libraries/import_as.dart" replace="/(lib\d)\.dart/package:$1\/$&/g"?>
```dart
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

// Uses Element from lib1.
Element element1 = Element();

// Uses Element from lib2.
lib2.Element element2 = lib2.Element();
```

Prefixos de importação com o nome [curinga][] `_` não são vinculativos,
mas fornecerão acesso às extensões não privadas nessa biblioteca.

[curinga]: /language/variables#wildcard-variables

### Importando apenas parte de uma biblioteca {:#importing-only-part-of-a-library}

Se você quiser usar apenas parte de uma biblioteca, você pode importar seletivamente
a biblioteca. Por exemplo:

<?code-excerpt "misc/lib/language_tour/libraries/show_hide.dart (imports)" replace="/(lib\d)\.dart/package:$1\/$&/g"?>
```dart
// Import only foo.
import 'package:lib1/lib1.dart' show foo;

// Import all names EXCEPT foo.
import 'package:lib2/lib2.dart' hide foo;
```

#### Carregando uma biblioteca preguiçosamente {:#lazily-loading-a-library}

O *carregamento diferido* (também chamado de *carregamento lento*)
permite que um aplicativo web carregue uma biblioteca sob demanda,
se e quando a biblioteca for necessária.
Use o carregamento diferido quando você quiser atender a uma ou mais das seguintes necessidades.

* Reduzir o tempo inicial de inicialização de um aplicativo web.
* Realizar testes A/B — experimentar
  implementações alternativas de um algoritmo, por exemplo.
* Carregar funcionalidades raramente usadas, como telas e diálogos opcionais.

Isso não significa que o Dart carregue todos os componentes diferidos no tempo de inicialização.
O aplicativo web pode baixar componentes diferidos pela web quando necessário.

A ferramenta `dart` não suporta carregamento diferido para alvos diferentes da web.
Se você estiver construindo um aplicativo Flutter,
consulte sua implementação de carregamento diferido no guia do Flutter sobre
[componentes diferidos][flutter-deferred].

[flutter-deferred]: {{site.flutter-docs}}/perf/deferred-components

Para carregar uma biblioteca preguiçosamente, primeiro importe-a usando `deferred as`.

<?code-excerpt "misc/lib/language_tour/libraries/greeter.dart (import)" replace="/hello\.dart/package:greetings\/$&/g"?>
```dart
import 'package:greetings/hello.dart' deferred as hello;
```

Quando você precisar da biblioteca, invoque
`loadLibrary()` usando o identificador da biblioteca.

<?code-excerpt "misc/lib/language_tour/libraries/greeter.dart (load-library)"?>
```dart
Future<void> greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
```

In the preceding code,
the `await` keyword pauses execution until the library is loaded.
For more information about `async` and `await`,
check out [asynchronous programming](/language/async).

Você pode invocar `loadLibrary()` várias vezes em uma biblioteca sem problemas.
A biblioteca é carregada apenas uma vez.

Tenha em mente o seguinte quando usar o carregamento diferido:

* As constantes de uma biblioteca diferida não são constantes no arquivo de importação.
  Lembre-se, essas constantes não existem até que a biblioteca diferida seja carregada.
* Você não pode usar tipos de uma biblioteca diferida no arquivo de importação.
  Em vez disso, considere mover tipos de interface para uma biblioteca importada por
  tanto a biblioteca diferida quanto o arquivo de importação.
* O Dart insere implicitamente `loadLibrary()` no namespace que você define
  usando <code>deferred as <em>namespace</em></code>.
  A função `loadLibrary()` retorna
  um [`Future`](/libraries/dart-async#future).

### A diretiva `library` {:#library-directive}

Para especificar [doc comments][doc comments] (comentários de documentação) em nível de biblioteca ou [metadata annotations][metadata annotations] (anotações de metadados),
anexe-os a uma declaração `library` no início do arquivo.

<?code-excerpt "misc/lib/effective_dart/docs_good.dart (library-doc)"?>
```dart
/// A really great test library.
@TestOn('browser')
library;
```

## Implementando bibliotecas {:#implementing-libraries}

Veja
[Create Packages](/tools/pub/create-packages)
para obter conselhos sobre como implementar um package, incluindo:

* Como organizar o código-fonte da biblioteca.
* Como usar a diretiva `export`.
* Quando usar a diretiva `part`.
* Como usar importações e exportações condicionais para implementar
  uma biblioteca que suporte múltiplas plataformas.

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[doc comments]: /effective-dart/documentation#consider-writing-a-library-level-doc-comment
[metadata annotations]: /language/metadata
