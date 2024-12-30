---
ia-translate: true
title: Libraries & imports
short-title: Libraries
description: Orientações sobre importação e implementação de bibliotecas.
prevpage:
  url: /language/metadata
  title: Metadados
nextpage:
  url: /language/keywords
  title: Palavras-chave
---

As diretivas `import` e `library` podem ajudar você a criar uma
base de código modular e compartilhável. As bibliotecas não fornecem apenas APIs, mas
são uma unidade de privacidade: identificadores que começam com um sublinhado (`_`)
são visíveis apenas dentro da biblioteca. *Todo arquivo Dart (mais suas partes) é uma
[biblioteca][library]*, mesmo que não use uma diretiva [`library`](#library-directive).

As bibliotecas podem ser distribuídas usando [pacotes](/tools/pub/packages).

:::note
Para entender por que o Dart usa sublinhados em vez de palavras-chave de modificadores de acesso
como `public` ou `private`, consulte
[SDK issue 33383]({{site.repo.dart.sdk}}/issues/33383).
:::

[library]: /tools/pub/glossary#library

## Usando bibliotecas

Use `import` para especificar como um namespace de uma biblioteca é usado no
escopo de outra biblioteca.

Por exemplo, aplicativos web Dart geralmente usam a biblioteca [dart:html][dart:html],
que eles podem importar assim:

<?code-excerpt "misc/test/language_tour/browser_test.dart (dart-html-import)"?>
```dart
import 'dart:html';
```

O único argumento obrigatório para `import` é um URI que especifica a
biblioteca.
Para bibliotecas internas, o URI tem o esquema especial `dart:`.
Para outras bibliotecas, você pode usar um caminho do sistema de arquivos ou o esquema `package:`.
O esquema `package:` especifica as bibliotecas fornecidas por um gerenciador de pacotes
como a ferramenta pub. Por exemplo:

<?code-excerpt "misc/test/language_tour/browser_test.dart (package-import)"?>
```dart
import 'package:test/test.dart';
```

:::note
*URI* significa identificador uniforme de recurso.
*URLs* (localizadores uniformes de recurso) são um tipo comum de URI.
:::

### Especificando um prefixo de biblioteca

Se você importar duas bibliotecas que têm identificadores conflitantes, então você
pode especificar um prefixo para uma ou ambas as bibliotecas. Por exemplo, se library1
e library2 ambas têm uma classe Element, então você pode ter um código como
este:

<?code-excerpt "misc/lib/language_tour/libraries/import_as.dart" replace="/(lib\d)\.dart/package:$1\/$&/g"?>
```dart
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

// Usa Element de lib1.
Element element1 = Element();

// Usa Element de lib2.
lib2.Element element2 = lib2.Element();
```

### Importando apenas parte de uma biblioteca

Se você quiser usar apenas parte de uma biblioteca, você pode importar seletivamente
a biblioteca. Por exemplo:

<?code-excerpt "misc/lib/language_tour/libraries/show_hide.dart (imports)" replace="/(lib\d)\.dart/package:$1\/$&/g"?>
```dart
// Importa apenas foo.
import 'package:lib1/lib1.dart' show foo;

// Importa todos os nomes, EXCETO foo.
import 'package:lib2/lib2.dart' hide foo;
```

#### Carregamento lento de uma biblioteca {:#lazily-loading-a-library}

*Carregamento adiado* (também chamado de *carregamento lento*)
permite que um aplicativo web carregue uma biblioteca sob demanda,
se e quando a biblioteca for necessária.
Use o carregamento adiado quando você quiser atender uma ou mais das seguintes necessidades.

* Reduza o tempo de inicialização inicial de um aplicativo web.
* Realize testes A/B—experimentando
  implementações alternativas de um algoritmo, por exemplo.
* Carregue funcionalidades raramente usadas, como telas e diálogos opcionais.

Isso não significa que o Dart carrega todos os componentes adiados no tempo de inicialização.
O aplicativo web pode baixar componentes adiados através da web quando necessário.

A ferramenta `dart` não suporta carregamento adiado para alvos que não sejam a web.
Se você estiver construindo um aplicativo Flutter,
consulte sua implementação de carregamento adiado no guia do Flutter sobre
[componentes adiados][flutter-deferred].

[flutter-deferred]: {{site.flutter-docs}}/perf/deferred-components

Para carregar uma biblioteca lentamente, primeiro importe-a usando `deferred as`.

<?code-excerpt "misc/lib/language_tour/libraries/greeter.dart (import)" replace="/hello\.dart/package:greetings\/$&/g"?>
```dart
import 'package:greetings/hello.dart' deferred as hello;
```

Quando você precisa da biblioteca, invoque
`loadLibrary()` usando o identificador da biblioteca.

<?code-excerpt "misc/lib/language_tour/libraries/greeter.dart (load-library)"?>
```dart
Future<void> greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
```

No código precedente,
a palavra-chave `await` pausa a execução até que a biblioteca seja carregada.
Para mais informações sobre `async` e `await`,
veja [suporte a assincronia](/language/async).

Você pode invocar `loadLibrary()` várias vezes em uma biblioteca sem problemas.
A biblioteca é carregada apenas uma vez.

Tenha em mente o seguinte quando você usar o carregamento adiado:

* As constantes de uma biblioteca adiada não são constantes no arquivo de importação.
  Lembre-se, essas constantes não existem até que a biblioteca adiada seja carregada.
* Você não pode usar tipos de uma biblioteca adiada no arquivo de importação.
  Em vez disso, considere mover os tipos de interface para uma biblioteca importada
  tanto pela biblioteca adiada quanto pelo arquivo de importação.
* O Dart insere implicitamente `loadLibrary()` no namespace que você define
  usando <code>deferred as <em>namespace</em></code>.
  A função `loadLibrary()` retorna
  um [`Future`](/libraries/dart-async#future).

### A diretiva `library` {:#library-directive}

Para especificar [comentários de documentação][doc comments] em nível de biblioteca ou [anotações de metadados][metadata annotations],
anexe-os a uma declaração `library` no início do arquivo.

<?code-excerpt "misc/lib/effective_dart/docs_good.dart (library-doc)"?>
```dart
/// Uma ótima biblioteca de teste.
@TestOn('browser')
library;
```

## Implementando bibliotecas

Veja
[Crie Pacotes](/tools/pub/create-packages)
para obter conselhos sobre como implementar um pacote, incluindo:

* Como organizar o código-fonte da biblioteca.
* Como usar a diretiva `export`.
* Quando usar a diretiva `part`.
* Como usar importações e exportações condicionais para implementar
  uma biblioteca que suporte múltiplas plataformas.

[dart:html]: {{site.dart-api}}/dart-html
[doc comments]: /effective-dart/documentation#consider-writing-a-library-level-doc-comment
[metadata annotations]: /language/metadata
