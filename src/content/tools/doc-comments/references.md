---
title: Referências em comentários de documentação
shortTitle: Referências em comentários
description: Aprenda sobre referências em comentários de documentação e sua sintaxe.
ia-translate: true
---

Doc comments podem conter referências a vários identificadores.
Elementos, como funções e classes, podem ser referenciados envolvendo
seu nome em colchetes (`[...]`) em um doc comment (um comentário que
começa com `///`). Alguns exemplos:

```dart
/// Returns a [String].
String f() => 'Hello';

/// Wraps [object] with [Future.value].
Future<T> g<T>(T object) => Future.value(object);
```

Esses doc comments contêm referências à classe `String`,
ao parâmetro `object` e ao construtor `Future.value`.

## Recursos das referências

Existem vários benefícios em se referir a elementos de código com
referências em doc comments:

### Suporte do editor

As referências em doc comments habilitam vários recursos de IDE:

- **Autocompletar código**
  O nome de um elemento pode ser autocompletado dentro de colchetes.
- **Refatoração de renomeação**
  Quando um elemento é renomeado via comando de IDE, a IDE pode
  reescrever os usos desse elemento, incluindo referências em doc comments.
- **Encontrar referências**
  Quando uma IDE lista todas as "referências" a um elemento, ela pode
  incluir referências em doc comments.
- **Ir para definição**
  Uma IDE também pode fornecer suporte para Ir-para-definição no
  local de uma referência em doc comment.

:::tip
A regra de lint [`comment_references`][] pode ajudar a
garantir que as referências em doc comments sejam válidas, evitando erros de digitação e usos incorretos.
Manter as referências em doc comments válidas garante que esses recursos de IDE
sejam habilitados para cada referência.
:::

[`comment_references`]: /tools/linter-rules/comment_references

### Documentação da API

Na documentação da API gerada por [`dart doc`](/tools/dart-doc), uma referência
em doc comment é vinculada, se possível, à página de documentação do elemento
sendo referenciado. Se o elemento não tiver uma página de documentação (por
exemplo, um parâmetro de função, um parâmetro de tipo ou uma classe privada), então
nenhum link é criado.

## O que pode ser referenciado

A maioria dos membros de biblioteca pode ser referenciada em um doc comment, incluindo
classes, constantes, enums, extensions nomeadas, extension types,
funções, mixins e type aliases.
Isso inclui todos os membros de biblioteca no escopo, sejam eles
declarados localmente, importados ou [importados com um doc import](#doc-imports).
Membros de biblioteca que são importados com um prefixo de importação podem
ser referenciados com o prefixo.
Por exemplo:

```dart
import 'dart:math' as math;

/// [List] is in scope.
/// So is [math.max].
int x = 7;
```

A maioria dos membros de uma classe, um enum, uma extension, um extension type e um mixin
também pode ser referenciada. Uma referência a um membro que não está no escopo deve ser
qualificada (prefixada) com o nome de seu contêiner. Por exemplo, o método estático `wait`
na classe `Future` pode ser referenciado em um doc comment com
`[Future.wait]`. Isso também é verdade para membros de instância; o método `add`
e a propriedade `length` na classe `List` podem ser referenciados com
`[List.add]` e `[List.length]`. Quando membros de contêiner estão no escopo, como
em um doc comment de método de instância, eles podem ser referenciados sem o
nome qualificador do contêiner:

```dart
abstract class MyList<E> implements List<E> {
  /// Refer to [add] and [contains], which is declared on [Iterable].
  void myMethod() {}
}
```

Construtores não nomeados podem ser referenciados usando o nome `new`, similar ao
tear-off de um construtor não nomeado. Por exemplo, `[DateTime.new]` é uma
referência ao construtor não nomeado de `DateTime`.

Parâmetros de uma função e parâmetros de um tipo de função podem ser referenciados em
um doc comment apenas quando estão no escopo. Portanto, eles só podem ser
referenciados dentro de um doc comment em tal função do parâmetro ou em um
type alias para o tipo de função envolvente de tal parâmetro.

Parâmetros de tipo podem ser referenciados em um doc comment apenas quando estão no escopo.
Portanto, um parâmetro de tipo de um método, função de nível superior ou type alias pode
ser referenciado apenas dentro de um doc comment nesse elemento, e um parâmetro de tipo
de uma classe, enum, extension, extension type e mixin pode ser referenciado apenas
dentro de um doc comment nesse elemento ou em um de seus membros.

O doc comment para um type alias que cria um alias para uma classe, enum, extension type ou
mixin não pode referenciar nenhum dos membros do tipo com alias como se estivessem no
escopo.

## Doc imports

Dart suporta uma tag de documentação `@docImport`,
que permite que elementos externos sejam referenciados em
comentários de documentação sem realmente importá-los.
Essa tag pode ser especificada em um doc comment acima de uma diretiva `library`.
Por exemplo:

```dart highlightLines=1
/// @docImport 'dart:async';
library;

/// Doc comments can now reference elements like
/// [Future] and [Future.value] from `dart:async`,
/// even if the library is not imported with an actual import.
class Foo {}
```

Doc imports suportam os mesmos estilos de URI que [importações Dart regulares][],
incluindo os esquemas `dart:` e `package:`, bem como caminhos relativos.
No entanto, eles não podem ser adiados ou configurados com `as`, `show` ou `hide`.

[regular Dart imports]: /language/libraries#using-libraries

:::version-note
O suporte para doc imports foi introduzido no Dart 3.8.
:::
