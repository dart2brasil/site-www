---
ia-translate: true
title: "Métodos de Extensão"
description: Aprenda como adicionar a APIs existentes.
prevpage:
  url: /language/dot-shorthands
  title: Dot shorthands
nextpage:
  url: /language/extension-types
  title: "Tipos de Extensão"
---

Métodos de extensão adicionam funcionalidade a bibliotecas existentes.
Você pode usar métodos de extensão sem nem mesmo saber disso.
Por exemplo, quando você usa o preenchimento automático de código em uma IDE,
ele sugere métodos de extensão junto com métodos regulares.

Se assistir a vídeos ajuda você a aprender,
confira esta visão geral de métodos de extensão.

<YouTubeEmbed id="D3j0OSfT9ZI" title="Dart extension methods"></YouTubeEmbed>

## Visão geral {:#overview}

Quando você está usando a API de outra pessoa ou
quando você implementa uma biblioteca que é amplamente usada,
geralmente é impraticável ou impossível mudar a API.
Mas você ainda pode querer adicionar alguma funcionalidade.

Por exemplo, considere o código a seguir que analisa uma string em um inteiro:

```dart
int.parse('42')
```

Poderia ser interessante—mais curto e mais fácil de usar com ferramentas—
ter essa funcionalidade em `String` em vez disso:

```dart
'42'.parseInt()
```

Para habilitar esse código,
você pode importar uma biblioteca que contém uma extensão da classe `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (basic)" plaster="none"?>
```dart
import 'string_apis.dart';

void main() {
  print('42'.parseInt()); // Use an extension method.
}
```

Extensões podem definir não apenas métodos,
mas também outros membros como getters, setters e operadores.
Além disso, extensões podem ter nomes, o que pode ser útil se surgir um conflito de API.
Veja como você pode implementar o método de extensão `parseInt()`,
usando uma extensão (nomeada `NumberParsing`) que opera em strings:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart (parseInt)" plaster="none"?>
```dart title="lib/string_apis.dart"
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}
```

A próxima seção descreve como _usar_ métodos de extensão.
Depois disso, há seções sobre _implementar_ métodos de extensão.


## Usando métodos de extensão {:#using-extension-methods}

Como todo código Dart, os métodos de extensão estão em bibliotecas.
Você já viu como usar um método de extensão—basta
importar a biblioteca em que ele está e usá-lo como um método comum:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (import-and-use)" plaster="none"?>
```dart
// Import a library that contains an extension on String.
import 'string_apis.dart';

void main() {
  print('42'.padLeft(5)); // Use a String method.
  print('42'.parseInt()); // Use an extension method.
}
```

Isso é tudo que você geralmente precisa saber para usar métodos de extensão.
Ao escrever seu código, você também pode precisar saber
como os métodos de extensão dependem de tipos estáticos (em vez de `dynamic`) e
como resolver [conflitos de API](#api-conflicts).

### Tipos estáticos e dynamic {:#static-types-and-dynamic}

Você não pode invocar métodos de extensão em variáveis do tipo `dynamic`.
Por exemplo, o código a seguir resulta em uma exceção em tempo de execução:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (dynamic)" plaster="none" replace="/  \/\/ print/print/g"?>
```dart
dynamic d = '2';
print(d.parseInt()); // Runtime exception: NoSuchMethodError
```

Métodos de extensão _funcionam_ com a inferência de tipo do Dart.
O código a seguir está correto porque
a variável `v` tem o tipo `String` inferido:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (var)"?>
```dart
var v = '2';
print(v.parseInt()); // Output: 2
```

A razão pela qual `dynamic` não funciona é que
métodos de extensão são resolvidos em relação ao tipo estático do receptor.
Como os métodos de extensão são resolvidos estaticamente,
eles são tão rápidos quanto chamar uma função estática.

Para mais informações sobre tipos estáticos e `dynamic`, veja
[O sistema de tipos do Dart](/language/type-system).

### Conflitos de API {:#api-conflicts}

Se um membro de extensão entra em conflito com
uma interface ou com outro membro de extensão,
você tem algumas opções.

Uma opção é alterar como você importa a extensão conflitante,
usando `show` ou `hide` para limitar a API exposta:

<?code-excerpt "extension_methods/lib/string_extensions/usage_import.dart (hide-conflicts)" plaster="none"?>
```dart
// Defines the String extension method parseInt().
import 'string_apis.dart';

// Also defines parseInt(), but hiding NumberParsing2
// hides that extension method.
import 'string_apis_2.dart' hide NumberParsing2;

void main() {
  // Uses the parseInt() defined in 'string_apis.dart'.
  print('42'.parseInt());
}
```

Outra opção é aplicar a extensão explicitamente,
o que resulta em código que parece que a extensão é uma classe wrapper (empacotadora):

<?code-excerpt "extension_methods/lib/string_extensions/usage_explicit.dart (conflicts-explicit)" plaster="none"?>
```dart
// Both libraries define extensions on String that contain parseInt(),
// and the extensions have different names.
import 'string_apis.dart'; // Contains NumberParsing extension.
import 'string_apis_2.dart'; // Contains NumberParsing2 extension.

void main() {
  // print('42'.parseInt()); // Doesn't work.
  print(NumberParsing('42').parseInt());
  print(NumberParsing2('42').parseInt());
}
```

Se ambas as extensões tiverem o mesmo nome,
então você pode precisar importar usando um prefixo:

<?code-excerpt "extension_methods/lib/string_extensions/usage_prefix.dart"?>
```dart
// Both libraries define extensions named NumberParsing
// that contain the extension method parseInt(). One NumberParsing
// extension (in 'string_apis_3.dart') also defines parseNum().
import 'string_apis.dart';
import 'string_apis_3.dart' as rad;

void main() {
  // print('42'.parseInt()); // Doesn't work.

  // Use the ParseNumbers extension from string_apis.dart.
  print(NumberParsing('42').parseInt());

  // Use the ParseNumbers extension from string_apis_3.dart.
  print(rad.NumberParsing('42').parseInt());

  // Only string_apis_3.dart has parseNum().
  print('42'.parseNum());
}
```

Como o exemplo mostra,
você pode invocar métodos de extensão implicitamente mesmo se importar usando um prefixo.
A única vez que você precisa usar o prefixo é
para evitar um conflito de nome ao invocar uma extensão explicitamente.


## Implementando métodos de extensão {:#implementing-extension-methods}

Use a seguinte sintaxe para criar uma extensão:

```plaintext
extension <nome da extensão>? on <tipo> { // <nome-da-extensão> é opcional
  (<definição de membro>)* // Pode fornecer uma ou mais <definição de membro>.
}
```

Por exemplo, veja como você pode implementar uma extensão na classe `String`:

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
Para acessar membros estáticos fora da declaração de extensão,
invoque-os através do nome da declaração como [variáveis e métodos de classe][class variables and methods].

[class variables and methods]: /language/classes#class-variables-and-methods

### Extensões não nomeadas {:#unnamed-extensions}

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

## Implementando extensões genéricas {:#implementing-generic-extensions}

Extensões podem ter parâmetros de tipo genérico.
Por exemplo, aqui está algum código que estende o tipo `List<T>` integrado
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
TODO (https://github.com/dart-lang/site-www/issues/2171):
Adicione mais informações sobre extensões genéricas.
Por exemplo, no código a seguir, `T` é `PENDING` porque PENDENTE:

[PENDENTE: exemplo]

[PENDENTE: Explique por que isso importa no uso normal.]
{% endcomment %}

## Recursos {:#resources}

Para mais informações sobre métodos de extensão, veja o seguinte:

* [Artigo: Fundamentos de Métodos de Extensão do Dart][article]
* [Especificação da funcionalidade][specification]
* [Exemplo de métodos de extensão][sample]

[specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#dart-static-extension-methods-design
[article]: https://blog.dart.dev/extension-methods-2d466cd8b308
[sample]: {{site.repo.dart.samples}}/tree/main/extension_methods
