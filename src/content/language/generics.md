---
ia-translate: true
title: Genéricos
description: Aprenda sobre tipos genéricos em Dart.
prevpage:
  url: /language/collections
  title: Coleções
nextpage:
  url: /language/typedefs
  title: Typedefs
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Se você olhar a documentação da API para o tipo básico de array,
[`List`][`List`], você verá que o tipo é na
verdade `List<E>`. A notação \<...\> marca List como um tipo *genérico*
(ou *parametrizado*) - um tipo que tem
parâmetros de tipo formais.
[Por convenção][By convention], a maioria das variáveis de tipo tem nomes de uma
única letra, como E, T, S, K e V.

## Por que usar genéricos?

Genéricos são frequentemente necessários para a segurança de tipo,
mas eles têm mais benefícios do que apenas permitir que seu código seja
executado:

*   Especificar corretamente os tipos genéricos resulta em um código
    gerado melhor.
*   Você pode usar genéricos para reduzir a duplicação de código.

Se você pretende que uma lista contenha apenas strings, você pode
declará-la como `List<String>` (leia isso como "lista de string"). Dessa
forma, você, seus colegas programadores e suas ferramentas podem detectar
que atribuir um não-string à lista é provavelmente um erro. Aqui está um
exemplo:

```dart tag=fails-sa
var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);
names.add(42); // Error
```

Outra razão para usar genéricos é reduzir a duplicação de código.
Genéricos permitem que você compartilhe uma única interface e
implementação entre muitos tipos, enquanto ainda aproveita a análise
estática. Por exemplo, digamos que você crie uma interface para
armazenar em cache um objeto:

<?code-excerpt "misc/lib/language_tour/generics/cache.dart (object-cache)"?>
```dart
abstract class ObjectCache {
  Object getByKey(String key);
  void setByKey(String key, Object value);
}
```

Você descobre que deseja uma versão específica para strings desta
interface, então você cria outra interface:

<?code-excerpt "misc/lib/language_tour/generics/cache.dart (string-cache)"?>
```dart
abstract class StringCache {
  String getByKey(String key);
  void setByKey(String key, String value);
}
```

Mais tarde, você decide que quer uma versão específica para números
desta interface... Você entendeu a ideia.

Tipos genéricos podem poupar o trabalho de criar todas essas interfaces.
Em vez disso, você pode criar uma única interface que recebe um
parâmetro de tipo:

<?code-excerpt "misc/lib/language_tour/generics/cache.dart (cache)"?>
```dart
abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}
```

Neste código, T é o tipo substituto. É um espaço reservado que você
pode pensar como um tipo que um desenvolvedor definirá mais tarde.

## Usando literais de coleção

Literais de lista, conjunto e mapa podem ser parametrizados. Literais
parametrizados são como os literais que você já viu, exceto que você
adiciona <code>&lt;*tipo*></code> (para listas e conjuntos) ou
<code>&lt;*tipoChave*, *tipoValor*></code> (para mapas) antes do
colchete de abertura. Aqui está um exemplo de uso de literais tipados:

<?code-excerpt "misc/lib/language_tour/generics/misc.dart (collection-literals)"?>
```dart
var names = <String>['Seth', 'Kathy', 'Lars'];
var uniqueNames = <String>{'Seth', 'Kathy', 'Lars'};
var pages = <String, String>{
  'index.html': 'Homepage',
  'robots.txt': 'Hints for web robots',
  'humans.txt': 'We are people, not machines'
};
```

## Usando tipos parametrizados com construtores

Para especificar um ou mais tipos ao usar um construtor, coloque os
tipos em colchetes angulares (`<...>`) logo após o nome da classe. Por
exemplo:

<?code-excerpt "misc/test/language_tour/generics_test.dart (constructor-1)"?>
```dart
var nameSet = Set<String>.from(names);
```

O código a seguir cria um mapa que tem chaves inteiras e valores do
tipo View:

<?code-excerpt "misc/test/language_tour/generics_test.dart (constructor-2)"?>
```dart
var views = Map<int, View>();
```

## Coleções genéricas e os tipos que elas contêm

Os tipos genéricos do Dart são *reificados*, o que significa que eles
carregam suas informações de tipo em tempo de execução. Por exemplo,
você pode testar o tipo de uma coleção:

<?code-excerpt "misc/test/language_tour/generics_test.dart (generic-collections)"?>
```dart
var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);
print(names is List<String>); // true
```

:::note
Em contraste, os genéricos em Java usam *erasure*, o que significa
que os parâmetros de tipo genérico são removidos em tempo de
execução. Em Java, você pode testar se um objeto é uma List, mas
não pode testar se é uma `List<String>`.
:::

## Restringindo o tipo parametrizado

Ao implementar um tipo genérico, você pode querer limitar os tipos
que podem ser fornecidos como argumentos, de modo que o argumento
deva ser um subtipo de um tipo específico. Você pode fazer isso usando
`extends`.

Um caso de uso comum é garantir que um tipo não seja anulável,
tornando-o um subtipo de `Object` (em vez do padrão,
[`Object?`][top-and-bottom]).

<?code-excerpt "misc/lib/language_tour/generics/misc.dart (non-nullable)"?>
```dart
class Foo<T extends Object> {
  // Qualquer tipo fornecido a Foo para T deve ser não anulável.
}
```

Você pode usar `extends` com outros tipos além de `Object`. Aqui
está um exemplo de extensão de `SomeBaseClass`, de modo que os membros de
`SomeBaseClass` possam ser chamados em objetos do tipo `T`:

<?code-excerpt "misc/lib/language_tour/generics/base_class.dart (generic)" replace="/extends SomeBaseClass(?=. \{)/[!$&!]/g"?>
```dart
class Foo<T [!extends SomeBaseClass!]> {
  // A implementação vai aqui...
  String toString() => "Instance of 'Foo<$T>'";
}

class Extender extends SomeBaseClass {...}
```

É aceitável usar `SomeBaseClass` ou qualquer um de seus subtipos
como argumento genérico:

<?code-excerpt "misc/test/language_tour/generics_test.dart (SomeBaseClass-ok)" replace="/Foo.\w+./[!$&!]/g"?>
```dart
var someBaseClassFoo = [!Foo<SomeBaseClass>!]();
var extenderFoo = [!Foo<Extender>!]();
```

Também é aceitável não especificar nenhum argumento genérico:

<?code-excerpt "misc/test/language_tour/generics_test.dart (no-generic-arg-ok)" replace="/expect\((.*?).toString\(\), .(.*?).\);/print($1); \/\/ $2/g"?>
```dart
var foo = Foo();
print(foo); // Instance of 'Foo<SomeBaseClass>'
```

Especificar qualquer tipo que não seja `SomeBaseClass` resulta em um
erro:

```dart tag=fails-sa
var foo = [!Foo<Object>!]();
```

## Usando métodos genéricos

Métodos e funções também permitem argumentos de tipo:

<!-- {{site.dartpad}}/a02c53b001977efa4d803109900f21bb -->
<!-- https://gist.github.com/a02c53b001977efa4d803109900f21bb -->
<?code-excerpt "misc/test/language_tour/generics_test.dart (method)" replace="/<T.(?=\()|T/[!$&!]/g"?>
```dart
[!T!] first[!<T>!](List<[!T!]> ts) {
  // Faça algum trabalho inicial ou verificação de erros, então...
  [!T!] tmp = ts[0];
  // Faça alguma verificação ou processamento adicional...
  return tmp;
}
```

Aqui, o parâmetro de tipo genérico em `first` (`<T>`) permite que
você use o argumento de tipo `T` em vários lugares:

*   No tipo de retorno da função (`T`).
*   No tipo de um argumento (`List<T>`).
*   No tipo de uma variável local (`T tmp`).

[`List`]: {{site.dart-api}}/dart-core/List-class.html
[By convention]: /effective-dart/design#do-follow-existing-mnemonic-conventions-when-naming-type-parameters
[top-and-bottom]: /null-safety/understanding-null-safety#top-and-bottom
