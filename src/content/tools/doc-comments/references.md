---
ia-translate: true
title: Referências em comentários de documentação
short-title: Referências em comentários
description: Aprenda sobre referências em comentários de documentação e sua sintaxe.
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

A maioria dos membros da biblioteca pode ser referenciada em um comentário de documentação, incluindo classes,
constantes, enums (enumerações), named extensions (extensões nomeadas), extension types (tipos de extensão), funções, mixins e
aliases de tipo. Isso inclui todos os membros da biblioteca em escopo, sejam declarados
localmente ou importados. Membros da biblioteca que são importados com um prefixo de importação
podem ser referenciados com o prefixo. Por exemplo:

```dart
import 'dart:math' as math;

/// [List] está em escopo.
/// Assim como [math.max].
int x = 7;
```

A maioria dos membros de uma classe, um enum, uma extensão, um tipo de extensão e um mixin
também pode ser referenciada. Uma referência a um membro que não está em escopo deve ser
qualificada (prefixada) com o nome de seu container (contêiner). Por exemplo, o método estático `wait`
na classe `Future` pode ser referenciado em um comentário de documentação com
`[Future.wait]`. Isso também é válido para membros de instância; o método `add`
e a propriedade `length` na classe `List` podem ser referenciados com
`[List.add]` e `[List.length]`. Quando membros do contêiner estão em escopo, como
em um comentário de documentação de um método de instância, eles podem ser referenciados sem o
nome do contêiner qualificador:

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

O comentário de documentação para um alias de tipo que é um alias de uma classe, enum, tipo de extensão ou
mixin não pode referenciar nenhum dos membros do tipo alias como se estivessem em
escopo.