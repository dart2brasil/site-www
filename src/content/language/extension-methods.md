---
ia-translate: true
title: Extension methods
description: Aprenda como adicionar funcionalidades a APIs existentes.
prevpage:
  url: /language/dot-shorthands
  title: Dot shorthands
nextpage:
  url: /language/extension-types
  title: Extension types
---

Extension methods adicionam funcionalidade a bibliotecas existentes.
Você pode usar extension methods sem nem mesmo saber disso.
Por exemplo, quando você usa autocompletar de código em uma IDE,
ele sugere extension methods ao lado de métodos regulares.

Se assistir vídeos ajuda você a aprender,
confira esta visão geral sobre extension methods.

<YouTubeEmbed id="D3j0OSfT9ZI" title="Dart extension methods"></YouTubeEmbed>

## Visão geral

Quando você está usando a API de outra pessoa ou
quando você implementa uma biblioteca que é amplamente usada,
é frequentemente impraticável ou impossível mudar a API.
Mas você ainda pode querer adicionar alguma funcionalidade.

Por exemplo, considere o seguinte código que analisa uma string em um inteiro:

```dart
int.parse('42')
```

Seria mais agradável—mais curto e mais fácil de usar com ferramentas—se
essa funcionalidade estivesse em `String`:

```dart
'42'.parseInt()
```

Para habilitar esse código,
você pode importar uma biblioteca que contém um extension da classe `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (basic)" plaster="none"?>
```dart
import 'string_apis.dart';

void main() {
  print('42'.parseInt()); // Use an extension method.
}
```

Extensions podem definir não apenas métodos,
mas também outros membros como getter, setters e operadores.
Além disso, extensions podem ter nomes, o que pode ser útil se surgir um conflito de API.
Aqui está como você pode implementar o extension method `parseInt()`,
usando um extension (chamado `NumberParsing`) que opera em strings:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart (parseInt)" plaster="none"?>
```dart title="lib/string_apis.dart"
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}
```

A próxima seção descreve como _usar_ extension methods.
Depois disso, há seções sobre _implementar_ extension methods.


## Usando extension methods

Como todo código Dart, extension methods estão em bibliotecas.
Você já viu como usar um extension method—apenas
importe a biblioteca em que ele está, e use-o como um método comum:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (import-and-use)" plaster="none"?>
```dart
// Import a library that contains an extension on String.
import 'string_apis.dart';

void main() {
  print('42'.padLeft(5)); // Use a String method.
  print('42'.parseInt()); // Use an extension method.
}
```

Isso é tudo que você geralmente precisa saber para usar extension methods.
Enquanto você escreve seu código, você também pode precisar saber
como extension methods dependem de tipos estáticos (em oposição a `dynamic`) e
como resolver [conflitos de API](#api-conflicts).

### Static types e dynamic

Você não pode invocar extension methods em variáveis do tipo `dynamic`.
Por exemplo, o seguinte código resulta em uma exceção em tempo de execução:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (dynamic)" plaster="none" replace="/  \/\/ print/print/g"?>
```dart
dynamic d = '2';
print(d.parseInt()); // Runtime exception: NoSuchMethodError
```

Extension methods _funcionam_ com a inferência de tipos do Dart.
O seguinte código está correto porque
a variável `v` é inferida como tendo o tipo `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (var)"?>
```dart
var v = '2';
print(v.parseInt()); // Output: 2
```

A razão pela qual `dynamic` não funciona é que
extension methods são resolvidos contra o tipo estático do receptor.
Como extension methods são resolvidos estaticamente,
eles são tão rápidos quanto chamar uma função estática.

Para mais informações sobre static types e `dynamic`, veja
[O sistema de tipos do Dart](/language/type-system).

### Conflitos de API

Se um membro extension entra em conflito com
uma interface ou com outro membro extension,
então você tem algumas opções.

Uma opção é mudar como você importa o extension conflitante,
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

Outra opção é aplicar o extension explicitamente,
o que resulta em código que parece como se o extension fosse uma classe wrapper:

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

Se ambos os extensions têm o mesmo nome,
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
você pode invocar extension methods implicitamente mesmo se você importar usando um prefixo.
A única vez que você precisa usar o prefixo é
para evitar um conflito de nome ao invocar um extension explicitamente.


## Implementando extension methods

Use a seguinte sintaxe para criar um extension:

```plaintext
extension <extension name>? on <type> { // <extension-name> is optional
  (<member definition>)* // Can provide one or more <member definition>.
}
```

Por exemplo, aqui está como você pode implementar um extension na classe `String`:

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

Os membros de um extension podem ser métodos, getters, setters ou operadores.
Extensions também podem ter campos estáticos e métodos auxiliares estáticos.
Para acessar membros estáticos fora da declaração do extension,
invoque-os através do nome da declaração como [variáveis e métodos de classe][class variables and methods].

[class variables and methods]: /language/classes#class-variables-and-methods

### Extensions sem nome

Ao declarar um extension, você pode omitir o nome.
Extensions sem nome são visíveis apenas
na biblioteca onde são declarados.
Como eles não têm um nome,
eles não podem ser aplicados explicitamente
para resolver [conflitos de API](#api-conflicts).

<?code-excerpt "extension_methods/lib/string_extensions/string_apis_unnamed.dart (unnamed)"?>
```dart
extension on String {
  bool get isBlank => trim().isEmpty;
}
```

:::note
Você pode invocar membros estáticos de um extension sem nome
apenas dentro da declaração do extension.
:::

## Implementando extensions genéricos

Extensions podem ter parâmetros de tipo genérico.
Por exemplo, aqui está um código que estende o tipo built-in `List<T>`
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
Add more info about generic extensions.
For example, in the following code, `T` is `PENDING` because PENDING:

[PENDING: example]

[PENDING: Explain why it matters in normal usage.]
{% endcomment %}

## Recursos

Para mais informações sobre extension methods, veja o seguinte:

* [Article: Dart Extension Methods Fundamentals][article]
* [Feature specification][specification]
* [Extension methods sample][sample]

[specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#dart-static-extension-methods-design
[article]: https://blog.dart.dev/extension-methods-2d466cd8b308
[sample]: {{site.repo.dart.samples}}/tree/main/extension_methods
