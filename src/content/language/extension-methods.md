---
ia-translate: true
title: Métodos de Extensão
description: Aprenda como adicionar a APIs existentes.
prevpage:
  url: /language/enums
  title: Enums
nextpage:
  url: /language/extension-types
  title: Tipos de Extensão
---

Métodos de extensão adicionam funcionalidades a bibliotecas existentes.
Você pode usar métodos de extensão sem nem mesmo saber.
Por exemplo, quando você usa o preenchimento de código em uma IDE,
ela sugere métodos de extensão junto com métodos regulares.

Se assistir vídeos te ajuda a aprender,
confira esta visão geral sobre métodos de extensão.

{% ytEmbed "D3j0OSfT9ZI", "Dart extension methods" %}

## Visão geral

Quando você está usando a API de outra pessoa ou
quando você implementa uma biblioteca que é amplamente usada,
é frequentemente impraticável ou impossível mudar a API.
Mas você ainda pode querer adicionar alguma funcionalidade.

Por exemplo, considere o seguinte código que analisa uma string em um inteiro:

```dart
int.parse('42')
```

Poderia ser bom—mais curto e mais fácil de usar com ferramentas—
ter essa funcionalidade em `String` em vez disso:

```dart
'42'.parseInt()
```

Para habilitar esse código,
você pode importar uma biblioteca que contém uma extensão da classe `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (basic)" replace="/  print/print/g"?>
```dart
import 'string_apis.dart';
// ···
print('42'.parseInt()); // Usa um método de extensão.
```

Extensões podem definir não apenas métodos,
mas também outros membros, como getters, setters e operadores.
Além disso, extensões podem ter nomes, o que pode ser útil se surgir um conflito de API.
Aqui está como você pode implementar o método de extensão `parseInt()`,
usando uma extensão (chamada `NumberParsing`) que opera em strings:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart (parseInt)"?>
```dart title="lib/string_apis.dart"
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
  // ···
}
```

A próxima seção descreve como _usar_ métodos de extensão.
Depois disso, há seções sobre _implementar_ métodos de extensão.

## Usando métodos de extensão

Como todo código Dart, os métodos de extensão estão em bibliotecas.
Você já viu como usar um método de extensão—basta
importar a biblioteca em que ele está e usá-lo como um método comum:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (import-and-use)" replace="/  print/print/g"?>
```dart
// Importa uma biblioteca que contém uma extensão em String.
import 'string_apis.dart';
// ···
print('42'.padLeft(5)); // Usa um método String.
print('42'.parseInt()); // Usa um método de extensão.
```

Isso é tudo que você geralmente precisa saber para usar métodos de extensão.
Ao escrever seu código, você também pode precisar saber
como os métodos de extensão dependem de tipos estáticos (em vez de `dynamic`) e
como resolver [conflitos de API](#api-conflicts).

### Tipos estáticos e dynamic

Você não pode invocar métodos de extensão em variáveis do tipo `dynamic`.
Por exemplo, o código a seguir resulta em uma exceção em tempo de execução:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (dynamic)" plaster="none" replace="/  \/\/ print/print/g"?>
```dart
dynamic d = '2';
print(d.parseInt()); // Exceção em tempo de execução: NoSuchMethodError
```

Métodos de extensão _funcionam_ com a inferência de tipo do Dart.
O código a seguir está correto porque
a variável `v` é inferida para ter o tipo `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (var)"?>
```dart
var v = '2';
print(v.parseInt()); // Saída: 2
```

A razão pela qual `dynamic` não funciona é que
métodos de extensão são resolvidos contra o tipo estático do receptor.
Como os métodos de extensão são resolvidos estaticamente,
eles são tão rápidos quanto chamar uma função estática.

Para mais informações sobre tipos estáticos e `dynamic`, veja
[O sistema de tipos do Dart](/language/type-system).

### Conflitos de API

Se um membro de extensão conflitar com
uma interface ou com outro membro de extensão,
você tem algumas opções.

Uma opção é mudar como você importa a extensão conflitante,
usando `show` ou `hide` para limitar a API exposta:

<?code-excerpt "extension_methods/lib/string_extensions/usage_import.dart (hide-conflicts)" replace="/  //g"?>
```dart
// Define o método de extensão String parseInt().
import 'string_apis.dart';

// Também define parseInt(), mas ocultar NumberParsing2
// oculta esse método de extensão.
import 'string_apis_2.dart' hide NumberParsing2;

// ···
// Usa o parseInt() definido em 'string_apis.dart'.
print('42'.parseInt());
```

Outra opção é aplicar a extensão explicitamente,
o que resulta em um código que parece que a extensão é uma classe wrapper:

<?code-excerpt "extension_methods/lib/string_extensions/usage_explicit.dart (conflicts-explicit)" replace="/  //g"?>
```dart
// Ambas as bibliotecas definem extensões em String que contêm parseInt(),
// e as extensões têm nomes diferentes.
import 'string_apis.dart'; // Contém a extensão NumberParsing.
import 'string_apis_2.dart'; // Contém a extensão NumberParsing2.

// ···
// print('42'.parseInt()); // Não funciona.
print(NumberParsing('42').parseInt());
print(NumberParsing2('42').parseInt());
```

Se ambas as extensões tiverem o mesmo nome,
você pode precisar importar usando um prefixo:

<?code-excerpt "extension_methods/lib/string_extensions/usage_prefix.dart (conflicts-prefix)" replace="/  //g"?>
```dart
// Ambas as bibliotecas definem extensões chamadas NumberParsing
// que contêm o método de extensão parseInt(). Uma extensão NumberParsing
// (em 'string_apis_3.dart') também define parseNum().
import 'string_apis.dart';
import 'string_apis_3.dart' as rad;

// ···
// print('42'.parseInt()); // Não funciona.

// Usa a extensão ParseNumbers de string_apis.dart.
print(NumberParsing('42').parseInt());

// Usa a extensão ParseNumbers de string_apis_3.dart.
print(rad.NumberParsing('42').parseInt());

// Apenas string_apis_3.dart tem parseNum().
print('42'.parseNum());
```

Como o exemplo mostra,
você pode invocar métodos de extensão implicitamente mesmo se importar usando um prefixo.
A única vez que você precisa usar o prefixo é
para evitar um conflito de nome ao invocar uma extensão explicitamente.

## Implementando métodos de extensão

Use a seguinte sintaxe para criar uma extensão:

```plaintext
extension <nome da extensão>? on <tipo> { // <nome-da-extensão> é opcional
  (<definição de membro>)* // Pode fornecer uma ou mais <definição de membro>.
}
```

Por exemplo, aqui está como você pode implementar uma extensão na classe `String`:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart"?>
```dart title="lib/string_apis.dart"
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}
```

Os membros de uma extensão podem ser métodos, getters, setters ou operadores.
Extensões também podem ter campos estáticos e métodos auxiliares estáticos.
Para acessar membros estáticos fora da declaração da extensão,
invoque-os através do nome da declaração como [variáveis e métodos de classe][class variables and methods].

[class variables and methods]: /language/classes#class-variables-and-methods

### Extensões não nomeadas

Ao declarar uma extensão, você pode omitir o nome.
Extensões não nomeadas são visíveis apenas
na biblioteca onde são declaradas.
Como elas não têm nome,
elas não podem ser aplicadas explicitamente
para resolver [conflitos de API](#api-conflicts).

<?code-excerpt "extension_methods/lib/string_extensions/string_apis_unnamed.dart (unnamed)"?>
```dart
extension on String {
  bool get isBlank => trim().isEmpty;
}
```

:::note
Você pode invocar os membros estáticos de uma extensão não nomeada
apenas dentro da declaração da extensão.
:::

## Implementando extensões genéricas

Extensões podem ter parâmetros de tipo genéricos.
Por exemplo, aqui está um código que estende o tipo `List<T>` integrado
com um getter, um operador e um método:

<?code-excerpt "extension_methods/lib/fancylist.dart (generic)"?>
```dart
extension MyFancyList<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];
}
```

O tipo `T` é vinculado com base no tipo estático da lista em que
os métodos são chamados.
{% comment %}
TODO (https://github.com/dart2brasil/site-www/issues/2171):
Adicionar mais informações sobre extensões genéricas.
Por exemplo, no seguinte código, `T` é `PENDING` porque PENDING:

[PENDING: exemplo]

[PENDING: Explique por que isso importa no uso normal.]
{% endcomment %}

## Recursos

Para mais informações sobre métodos de extensão, veja o seguinte:

* [Artigo: Fundamentos de Métodos de Extensão Dart][article]
* [Especificação do recurso][specification]
* [Exemplo de métodos de extensão][sample]

[specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#dart-static-extension-methods-design
[article]: https://medium.com/dartlang/extension-methods-2d466cd8b308
[sample]: {{site.repo.dart.org}}/samples/tree/main/extension_methods
