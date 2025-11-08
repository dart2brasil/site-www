---
title: Libraries & imports
shortTitle: Libraries
description: Orientação sobre importar e implementar bibliotecas.
ia-translate: true
prevpage:
  url: /language/metadata
  title: Metadata
nextpage:
  url: /language/classes
  title: Classes
---

As diretivas `import` e `library` podem ajudá-lo a criar uma
base de código modular e compartilhável. Bibliotecas não apenas fornecem APIs, mas
são uma unidade de privacidade: identificadores que começam com um underscore (`_`)
são visíveis apenas dentro da biblioteca. *Cada arquivo Dart (mais suas partes) é uma
[biblioteca][]*, mesmo que não use uma diretiva [`library`](#library-directive).

Bibliotecas podem ser distribuídas usando [pacotes](/tools/pub/packages).

Dart usa underscores em vez de palavras-chave de modificador de acesso
como `public`, `protected` ou `private`.
Enquanto palavras-chave de modificador de acesso de outras linguagens
fornecem controle mais refinado,
o uso de underscores por Dart e privacidade baseada em biblioteca
fornece um mecanismo de configuração direto,
ajuda a habilitar uma implementação eficiente de [acesso dinâmico][],
e melhora tree shaking (eliminação de código morto).

[biblioteca]: /resources/glossary#library
[acesso dinâmico]: /effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking

## Usando bibliotecas

Use `import` para especificar como um namespace de uma biblioteca é usado no
escopo de outra biblioteca.

Por exemplo, aplicações web Dart geralmente usam a biblioteca [`dart:js_interop`][],
que elas podem importar assim:

<?code-excerpt "misc/test/language_tour/browser_test.dart (dart-js-interop-import)"?>
```dart
import 'dart:js_interop';
```

O único argumento obrigatório para `import` é um URI especificando a
biblioteca.
Para bibliotecas integradas, o URI tem o esquema especial `dart:`.
Para outras bibliotecas, você pode usar um caminho de sistema de arquivos ou o esquema `package:`.
O esquema `package:` especifica bibliotecas fornecidas por um gerenciador de pacotes
como a ferramenta pub. Por exemplo:

<?code-excerpt "misc/test/language_tour/browser_test.dart (package-import)"?>
```dart
import 'package:test/test.dart';
```

:::note
*URI* significa identificador de recurso uniforme.
*URLs* (localizadores de recursos uniformes) são um tipo comum de URI.
:::

### Especificando um prefixo de biblioteca

Se você importar duas bibliotecas que têm identificadores conflitantes, então você
pode especificar um prefixo para uma ou ambas as bibliotecas. Por exemplo, se library1
e library2 ambas têm uma classe Element, então você pode ter código assim:

<?code-excerpt "misc/lib/language_tour/libraries/import_as.dart" replace="/(lib\d)\.dart/package:$1\/$&/g"?>
```dart
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

// Uses Element from lib1.
Element element1 = Element();

// Uses Element from lib2.
lib2.Element element2 = lib2.Element();
```

Prefixos de importação com o nome [wildcard][] `_` são não vinculantes,
mas fornecerão acesso às extensões não privadas nessa biblioteca.

[wildcard]: /language/variables#wildcard-variables

### Importando apenas parte de uma biblioteca

Se você deseja usar apenas parte de uma biblioteca, você pode importar seletivamente
a biblioteca. Por exemplo:

<?code-excerpt "misc/lib/language_tour/libraries/show_hide.dart (imports)" replace="/(lib\d)\.dart/package:$1\/$&/g"?>
```dart
// Import only foo.
import 'package:lib1/lib1.dart' show foo;

// Import all names EXCEPT foo.
import 'package:lib2/lib2.dart' hide foo;
```

#### Carregando uma biblioteca preguiçosamente {:#lazily-loading-a-library}

*Carregamento diferido* (também chamado de *lazy loading*)
permite que uma aplicação web carregue uma biblioteca sob demanda,
se e quando a biblioteca é necessária.
Use carregamento diferido quando você quiser atender a uma ou mais das seguintes necessidades.

* Reduzir o tempo de inicialização inicial de uma aplicação web.
* Realizar testes A/B—experimentar
  implementações alternativas de um algoritmo, por exemplo.
* Carregar funcionalidades raramente usadas, como telas e diálogos opcionais.

Isso não significa que Dart carrega todos os componentes diferidos no tempo de início.
A aplicação web pode baixar componentes diferidos via web quando necessário.

A ferramenta `dart` não suporta carregamento diferido para alvos diferentes de web.
Se você está construindo uma aplicação Flutter,
consulte sua implementação de carregamento diferido no guia Flutter sobre
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

No código anterior,
a palavra-chave `await` pausa a execução até que a biblioteca seja carregada.
Para mais informações sobre `async` e `await`,
confira [programação assíncrona](/language/async).

Você pode invocar `loadLibrary()` múltiplas vezes em uma biblioteca sem problemas.
A biblioteca é carregada apenas uma vez.

Tenha em mente o seguinte quando você usar carregamento diferido:

* As constantes de uma biblioteca diferida não são constantes no arquivo de importação.
  Lembre-se, essas constantes não existem até que a biblioteca diferida seja carregada.
* Você não pode usar tipos de uma biblioteca diferida no arquivo de importação.
  Em vez disso, considere mover tipos de interface para uma biblioteca importada por
  tanto a biblioteca diferida quanto o arquivo de importação.
* Dart implicitamente insere `loadLibrary()` no namespace que você define
  usando <code>deferred as <em>namespace</em></code>.
  A função `loadLibrary()` retorna
  uma [`Future`](/libraries/dart-async#future).

### A diretiva `library` {:#library-directive}

Para especificar [comentários de documentação][doc comments] ou [anotações de metadados][metadata annotations] em nível de biblioteca,
anexe-os a uma declaração `library` no início do arquivo.

<?code-excerpt "misc/lib/effective_dart/docs_good.dart (library-doc)"?>
```dart
/// A really great test library.
@TestOn('browser')
library;
```

## Implementando bibliotecas

Veja
[Criar Pacotes](/tools/pub/create-packages)
para orientação sobre como implementar um pacote, incluindo:

* Como organizar o código-fonte da biblioteca.
* Como usar a diretiva `export`.
* Quando usar a diretiva `part`.
* Como usar importações e exportações condicionais para implementar
  uma biblioteca que suporta múltiplas plataformas.

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[doc comments]: /effective-dart/documentation#consider-writing-a-library-level-doc-comment
[metadata annotations]: /language/metadata
