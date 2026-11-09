---
ia-translate: true
title: Métodos de extensão
description: Aprenda a adicionar funcionalidades a APIs existentes.
prevpage:
  url: /language/dot-shorthands
  title: Atalhos de ponto
nextpage:
  url: /language/extension-types
  title: Tipos de extensão
---

Extension methods adicionam funcionalidade a bibliotecas existentes.
Você pode usar extension methods sem nem saber disso.
Por exemplo, quando você usa o autocompletar de código em uma IDE,
ele sugere extension methods junto com os métodos comuns.

Se assistir a vídeos ajuda você a aprender,
confira esta visão geral sobre extension methods.

<YouTubeEmbed id="D3j0OSfT9ZI" title="Dart extension methods"></YouTubeEmbed>

## Visão geral {:#overview}

Quando você está usando a API de outra pessoa ou
quando implementa uma biblioteca amplamente usada,
muitas vezes é impraticável, ou impossível, mudar a API.
Mesmo assim, você pode querer adicionar alguma funcionalidade.

Por exemplo, considere o código a seguir, que converte uma string em um inteiro:

```dart
int.parse('42')
```

Seria mais agradável (mais curto e mais fácil de usar com ferramentas) ter
essa funcionalidade em `String`:

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

Extensions podem definir não apenas métodos,
mas também outros membros, como getters, setters e operadores.
Além disso, extensions podem ter nomes, o que ajuda se surgir um conflito de API.
Veja como você pode implementar o extension method `parseInt()`,
usando uma extension (chamada `NumberParsing`) que opera sobre strings:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart (parseInt)" plaster="none"?>
```dart title="lib/string_apis.dart"
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}
```

A próxima seção descreve como _usar_ extension methods.
Depois dela, há seções sobre _implementar_ extension methods.


## Usando extension methods {:#using-extension-methods}

Como todo código Dart, extension methods ficam em bibliotecas.
Você já viu como usar um extension method: basta
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

Isso é tudo o que você costuma precisar saber para usar extension methods.
À medida que escreve seu código, pode também precisar saber
como extension methods dependem de tipos estáticos (em oposição a `dynamic`) e
como resolver [conflitos de API](#api-conflicts).

### Tipos estáticos e dynamic {:#static-types-and-dynamic}

Você não pode invocar extension methods em variáveis do tipo `dynamic`.
Por exemplo, o código a seguir resulta em uma exceção em tempo de execução:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (dynamic)" plaster="none" replace="/  \/\/ print/print/g"?>
```dart
dynamic d = '2';
print(d.parseInt()); // Runtime exception: NoSuchMethodError
```

Extension methods _funcionam_ com a inferência de tipos do Dart.
O código a seguir está correto porque
a variável `v` é inferida como tendo o tipo `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (var)"?>
```dart
var v = '2';
print(v.parseInt()); // Output: 2
```

A razão pela qual `dynamic` não funciona é que
extension methods são resolvidos com base no tipo estático do receptor.
Como são resolvidos estaticamente,
eles são tão rápidos quanto chamar uma função estática.

Para mais informações sobre tipos estáticos e `dynamic`, veja
[O sistema de tipos do Dart](/language/type-system).

### Conflitos de API {:#api-conflicts}

Se um membro de extension entrar em conflito com
uma interface ou com outro membro de extension,
você tem algumas opções.

Uma opção é mudar a forma como você importa a extension conflitante,
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

Outra opção é aplicar a extension explicitamente,
o que resulta em um código que parece uma classe wrapper:

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

Se as duas extensions tiverem o mesmo nome,
talvez você precise importar usando um prefixo:

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
você pode invocar extension methods implicitamente mesmo se importar usando um prefixo.
A única vez em que você precisa usar o prefixo é
para evitar um conflito de nome ao invocar uma extension explicitamente.


## Implementando extension methods {:#implementing-extension-methods}

Use a sintaxe a seguir para criar uma extension:

```plaintext
extension <extension name>? on <type> { // <extension-name> is optional
  (<member definition>)* // Can provide one or more <member definition>.
}
```

Por exemplo, veja como você pode implementar uma extension na classe `String`:

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

Os membros de uma extension podem ser métodos, getters, setters ou operadores.
Extensions também podem ter campos estáticos e métodos auxiliares estáticos.
Para acessar membros estáticos fora da declaração da extension,
invoque-os pelo nome da declaração, como em [variáveis e métodos de classe][class variables and methods].

[class variables and methods]: /language/classes#class-variables-and-methods

### Extensions sem nome {:#unnamed-extensions}

Ao declarar uma extension, você pode omitir o nome.
Extensions sem nome são visíveis apenas
na biblioteca onde são declaradas.
Como não têm nome,
elas não podem ser aplicadas explicitamente
para resolver [conflitos de API](#api-conflicts).

<?code-excerpt "extension_methods/lib/string_extensions/string_apis_unnamed.dart (unnamed)"?>
```dart
extension on String {
  bool get isBlank => trim().isEmpty;
}
```

:::note
Você pode invocar membros estáticos de uma extension sem nome
apenas dentro da declaração da extension.
:::

## Implementando extensions genéricas {:#implementing-generic-extensions}

Extensions podem ter parâmetros de tipo genéricos.
Por exemplo, aqui está um código que estende o tipo embutido `List<T>`
com um getter, um operador e um método:

<?code-excerpt "extension_methods/lib/fancylist.dart (generic)"?>
```dart
extension MyFancyList<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];
}
```

O tipo `T` é vinculado com base no tipo estático da lista sobre
a qual os métodos são chamados.
{% comment %}
TODO (https://github.com/dart-lang/site-www/issues/2171):
Add more info about generic extensions.
For example, in the following code, `T` is `PENDING` because PENDING:

[PENDING: example]

[PENDING: Explain why it matters in normal usage.]
{% endcomment %}

## Recursos {:#resources}

Para mais informações sobre extension methods, veja o seguinte:

* [Artigo: Dart Extension Methods Fundamentals][article]
* [Especificação da funcionalidade][specification]
* [Exemplo de extension methods][sample]

[specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#dart-static-extension-methods-design
[article]: /blog/dart-extension-method-fundamentals
[sample]: {{site.repo.dart.samples}}/tree/main/extension_methods
