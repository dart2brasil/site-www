---
title: Documentation comment references
shortTitle: Comment references
description: Learn about doc comment references and their syntax.
---

Comentários de documentação podem conter referências a vários identificadores.
Elementos, como funções e classes, podem ser referenciados envolvendo seus nomes em
colchetes (`[...]`) em um comentário de documentação (um comentário que começa
com `///`). Alguns exemplos:

```dart
/// Retorna uma [String].
String f() => 'Olá';

/// Envolve [object] com [Future.value].
Future<T> g<T>(T object) => Future.value(object);
```

Esses comentários de documentação contêm referências à classe `String`,
ao parâmetro `object` e ao construtor `Future.value`.

## Recursos das referências {:#features-of-references}

Existem vários benefícios em referenciar elementos de código com
referências em comentários de documentação:

### Suporte do editor {:#editor-support}

Referências em comentários de documentação habilitam vários recursos de IDE (Ambiente de Desenvolvimento Integrado):

- **Preenchimento de código**
  O nome de um elemento pode ser preenchido automaticamente dentro de colchetes.
- **Refatoração de renomear**
  Quando um elemento é renomeado por meio de um comando de IDE, a IDE pode
  reescrever usos desse elemento, incluindo referências em comentários de documentação.
- **Encontrar referências**
  Quando uma IDE lista todas as "referências" a um elemento, ela pode
  incluir referências em comentários de documentação.
- **Ir para a definição**
  Uma IDE também pode fornecer suporte para Ir para a definição na
  localização de uma referência em um comentário de documentação.

:::tip
A regra de lint [`comment_references`][] pode ajudar a
garantir que as referências em comentários de documentação sejam válidas, evitando erros de digitação e usos incorretos.
Manter as referências em comentários de documentação válidas garante que esses recursos da IDE
estejam habilitados para cada referência.
:::

[`comment_references`]: /tools/linter-rules/comment_references

### Documentação da API {:#api-documentation}

Na documentação da API gerada por [`dart doc`](/tools/dart-doc), uma referência em
um comentário de documentação é vinculada, se possível, à página de documentação do elemento
sendo referenciado. Se o elemento não tiver uma página de documentação (por
exemplo, um parâmetro de função, um parâmetro de tipo ou uma classe privada), então nenhum
link é criado.

## O que pode ser referenciado {:#what-can-be-referenced}

Most library members can be referenced in a doc comment, including
classes, constants, enums, named extensions, extension types,
functions, mixins, and type aliases.
This includes all in-scope library members, either
declared locally, imported, or [imported with a doc import](#doc-imports).
Library members that are imported with an import prefix can
be referenced with the prefix.
For example:

```dart
import 'dart:math' as math;

/// [List] está em escopo.
/// Assim como [math.max].
int x = 7;
```

Most members of a class, an enum, an extension, an extension type, and a mixin
can also be referenced. A reference to a member that is not in scope must be
qualified (prefixed) with its container's name. For example, the `wait` static
method on the `Future` class can be referenced in a doc comment with
`[Future.wait]`. This is true for instance members as well; the `add` method
and the `length` property on the `List` class can be referenced with
`[List.add]` and `[List.length]`. When container members are in-scope, such as
in an instance method's doc comment, they can be referenced without the
qualifying container name:

```dart
abstract class MyList<E> implements List<E> {
  /// Consulte [add] e [contains], que é declarado em [Iterable].
  void myMethod() {}
}
```

Construtores não nomeados podem ser referenciados usando o nome `new`, semelhante ao
tear-off (desmembramento) de um construtor não nomeado. Por exemplo, `[DateTime.new]` é uma
referência ao construtor não nomeado `DateTime`.

Parâmetros de uma função e parâmetros de um tipo de função podem ser referenciados em
um comentário de documentação apenas quando estão em escopo. Eles podem, portanto, apenas ser
referenciados dentro de um comentário de documentação na função de tal parâmetro ou em um tipo
alias (apelido) para o tipo de função delimitadora de tal parâmetro.

Parâmetros de tipo podem ser referenciados em um comentário de documentação apenas quando estão em escopo.
Portanto, um parâmetro de tipo de um método, função de nível superior ou alias de tipo pode
ser referenciado apenas dentro de um comentário de documentação nesse elemento, e um parâmetro de tipo
de uma classe, enum, extensão, tipo de extensão e mixin pode ser referenciado apenas
dentro de um comentário de documentação nesse elemento ou em um de seus membros.

The doc comment for a type alias that aliases a class, enum, extension type, or
mixin can't reference any of the aliased type's members as if they were in
scope.

## Doc imports

Dart supports a `@docImport` documentation tag,
which enables external elements to be referenced in
documentation comments without actually importing them.
This tag can be specified in a doc comment above a `library` directive.
For example:

```dart highlightLines=1
/// @docImport 'dart:async';
library;

/// Doc comments can now reference elements like
/// [Future] and [Future.value] from `dart:async`,
/// even if the library is not imported with an actual import.
class Foo {}
```

Doc imports support the same URI styles as [regular Dart imports][],
including the `dart:` and `package:` schemes as well as relative paths.
However, they can't be deferred or configured with `as`, `show`, or `hide`.

[regular Dart imports]: /language/libraries#using-libraries

:::version-note
Support for doc imports was introduced in Dart 3.8.
:::
