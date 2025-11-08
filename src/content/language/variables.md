---
ia-translate: true
title: Variáveis
description: Aprenda sobre variáveis em Dart.
prevpage:
  url: /language
  title: Introduction
nextpage:
  url: /language/operators
  title: Operators
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Aqui está um exemplo de criação de uma variável e inicialização dela:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-decl)"?>
```dart
var name = 'Bob';
```

Variáveis armazenam referências. A variável chamada `name` contém uma
referência a um objeto `String` com um valor de "Bob".

O tipo da variável `name` é inferido como `String`,
mas você pode mudar esse tipo especificando-o.
Se um objeto não está restrito a um único tipo,
especifique o tipo `Object` (ou `dynamic` se necessário).

<?code-excerpt "misc/lib/language_tour/variables.dart (type-decl)"?>
```dart
Object name = 'Bob';
```

Outra opção é declarar explicitamente o tipo que seria inferido:

<?code-excerpt "misc/lib/language_tour/variables.dart (static-types)"?>
```dart
String name = 'Bob';
```

:::note
Esta página segue a
[recomendação do guia de estilo](/effective-dart/design#types)
de usar `var`, em vez de annotations de tipo, para variáveis locais.
:::

## Null safety

A linguagem Dart impõe sound null safety.

Null safety previne um erro que resulta do acesso não intencional
de variáveis definidas como `null`. O erro é chamado de null dereference error.
Um null dereference error ocorre quando você acessa uma propriedade ou chama um método
em uma expressão que avalia para `null`.
Uma exceção a esta regra é quando `null` suporta a propriedade ou método,
como `toString()` ou `hashCode`. Com null safety, o compilador Dart
detecta esses erros potenciais em tempo de compilação.

Por exemplo, digamos que você queira encontrar o valor absoluto de uma variável `int` `i`.
Se `i` for `null`, chamar `i.abs()` causa um null dereference error.
Em outras linguagens, tentar isso pode levar a um erro em tempo de execução,
mas o compilador do Dart proíbe essas ações.
Portanto, aplicações Dart não podem causar erros em tempo de execução.

Null safety introduz três mudanças principais:

1.  Quando você especifica um tipo para uma variável, parâmetro ou outro
    componente relevante, você pode controlar se o tipo permite `null`.
    Para habilitar nullability, você adiciona um `?` ao final da declaração de tipo.

    ```dart
    String? name  // Nullable type. Can be `null` or string.

    String name   // Non-nullable type. Cannot be `null` but can be string.
    ```

2.  Você deve inicializar variáveis antes de usá-las.
    Variáveis nullable têm como padrão `null`, então elas são inicializadas por padrão.
    Dart não define valores iniciais para tipos não-nullable.
    Ele força você a definir um valor inicial.
    Dart não permite que você observe uma variável não inicializada.
    Isso impede que você acesse propriedades ou chame métodos
    onde o tipo do receptor pode ser `null`
    mas `null` não suporta o método ou propriedade usada.

3.  Você não pode acessar propriedades ou chamar métodos em uma expressão com um
    tipo nullable. A mesma exceção se aplica onde é uma propriedade ou método que `null` suporta como `hashCode` ou `toString()`.

Sound null safety transforma potenciais **erros em tempo de execução**
em erros de análise **em tempo de edição**.
Null safety sinaliza uma variável não-null quando ela foi:

* Não inicializada com um valor não-null.
* Atribuída um valor `null`.

Esta verificação permite que você corrija esses erros _antes_ de implantar sua aplicação.

## Valor padrão

Variáveis não inicializadas que têm um tipo nullable
têm um valor inicial de `null`.
Até variáveis com tipos numéricos são inicialmente null,
porque números—como tudo mais em Dart—são objetos.

<?code-excerpt "misc/test/language_tour/variables_test.dart (var-null-init)"?>
```dart
int? lineCount;
assert(lineCount == null);
```

:::note
Código de produção ignora a chamada `assert()`. Durante o desenvolvimento, por outro
lado, <code>assert(<em>condition</em>)</code> lança uma exceção se
_condition_ for false. Para detalhes, confira [Assert][].
:::

Com null safety, você deve inicializar os valores
de variáveis não-nullable antes de usá-las:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-ns-init)"?>
```dart
int lineCount = 0;
```

Você não precisa inicializar uma variável local onde ela é declarada,
mas você precisa atribuir a ela um valor antes de ser usada.
Por exemplo, o código a seguir é válido porque
Dart pode detectar que `lineCount` é não-null no momento
em que é passada para `print()`:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-ns-flow)"?>
```dart
int lineCount;

if (weLikeToCount) {
  lineCount = countLines();
} else {
  lineCount = 0;
}

print(lineCount);
```

Variáveis de nível superior e de classe são inicializadas preguiçosamente;
o código de inicialização é executado
na primeira vez que a variável é usada.


## Variáveis late

O modificador `late` tem dois casos de uso:

* Declarar uma variável não-nullable que é inicializada após sua declaração.
* Inicializar preguiçosamente uma variável.

Frequentemente a análise de fluxo de controle do Dart pode detectar quando uma variável não-nullable
é definida com um valor não-null antes de ser usada,
mas às vezes a análise falha.
Dois casos comuns são variáveis de nível superior e variáveis de instância:
Dart frequentemente não pode determinar se elas estão definidas,
então não tenta.

Se você tem certeza de que uma variável é definida antes de ser usada,
mas Dart discorda,
você pode corrigir o erro marcando a variável como `late`:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-late-top-level)" replace="/late/[!$&!]/g"?>
```dart
[!late!] String description;

void main() {
  description = 'Feijoada!';
  print(description);
}
```

:::warning Aviso
Se você falhar em inicializar uma variável `late`,
um erro em tempo de execução ocorre quando a variável é usada.
:::

Quando você marca uma variável como `late` mas a inicializa em sua declaração,
então o inicializador é executado na primeira vez que a variável é usada.
Esta inicialização preguiçosa é útil em alguns casos:

* A variável pode não ser necessária,
  e inicializá-la é custoso.
* Você está inicializando uma variável de instância,
  e seu inicializador precisa acessar `this`.

No exemplo a seguir,
se a variável `temperature` nunca for usada,
então a função cara `readThermometer()` nunca é chamada:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-late-lazy)" replace="/late/[!$&!]/g"?>
```dart
// This is the program's only call to readThermometer().
[!late!] String temperature = readThermometer(); // Lazily initialized.
```


## Final e const

Se você nunca pretende mudar uma variável, use `final` ou `const`, ou
em vez de `var` ou além de um tipo. Uma variável final pode ser definida
apenas uma vez; uma variável const é uma constante em tempo de compilação. (Variáveis const
são implicitamente final.)

:::note
[Variáveis de instância][Instance variables] podem ser `final` mas não `const`.
:::

Aqui está um exemplo de criação e definição de uma variável `final`:

<?code-excerpt "misc/lib/language_tour/variables.dart (final)"?>
```dart
final name = 'Bob'; // Without a type annotation
final String nickname = 'Bobby';
```

Você não pode mudar o valor de uma variável `final`:

<?code-excerpt "misc/lib/language_tour/variables.dart (cant-assign-to-final)"?>
```dart tag=fails-sa
name = 'Alice'; // Error: a final variable can only be set once.
```

Use `const` para variáveis que você quer que sejam **constantes em tempo de compilação**. Se
a variável const está no nível de classe, marque-a como `static const`.
Onde você declara a variável, defina o valor para uma constante em tempo de compilação
como um número ou string literal, uma variável const,
ou o resultado de uma operação aritmética em números constantes:

<?code-excerpt "misc/lib/language_tour/variables.dart (const)"?>
```dart
const bar = 1000000; // Unit of pressure (dynes/cm2)
const double atm = 1.01325 * bar; // Standard atmosphere
```

A keyword `const` não é apenas para declarar variáveis constantes.
Você também pode usá-la para criar _valores_ constantes,
assim como para declarar construtores que _criam_ valores constantes.
Qualquer variável pode ter um valor constante.

<?code-excerpt "misc/lib/language_tour/variables.dart (const-vs-final)"?>
```dart
var foo = const [];
final bar = const [];
const baz = []; // Equivalent to `const []`
```

Você pode omitir `const` da expressão de inicialização de uma declaração `const`,
como para `baz` acima. Para detalhes, veja [NÃO use const redundantemente][DON'T use const redundantly].

Você pode mudar a referência de uma variável não-final, não-const,
mesmo se ela costumava ter um valor `const`:

<?code-excerpt "misc/lib/language_tour/variables.dart (reassign-to-non-final)"?>
```dart
foo = [1, 2, 3]; // Was const []
```

Você não pode mudar o valor de uma variável `const`:

<?code-excerpt "misc/lib/language_tour/variables.dart (cant-assign-to-const)"?>
```dart tag=fails-sa
baz = [42]; // Error: Constant variables can't be assigned a value.
```

Você pode definir constantes que usam
[verificações e casts de tipo][type checks and casts] (`is` e `as`),
[`if` em coleções][collection `if`],
e [operadores spread][spread operators] (`...` e `...?`):

<?code-excerpt "misc/lib/language_tour/variables.dart (const-dart-25)"?>
```dart
const Object i = 3; // Where i is a const Object with an int value...
const list = [i as int]; // Use a typecast.
const map = {if (i is int) i: 'int'}; // Use is and collection if.
const set = {if (list is List<int>) ...list}; // ...and a spread.
```

:::note
Embora um objeto `final` não possa ser modificado,
seus campos podem ser alterados.
Em comparação, um objeto `const` e seus campos
não podem ser alterados: eles são _immutable_.
:::

Para mais informações sobre usar `const` para criar valores constantes, veja
[Lists][], [Maps][] e [Classes][].


## Variáveis wildcard

:::version-note
Variáveis wildcard requerem
uma [versão da linguagem][language version] de pelo menos 3.7.
:::

Uma variável wildcard com o nome `_` declara uma variável local ou parâmetro
que é não-vinculante; essencialmente, um placeholder.
O inicializador, se houver um, ainda é executado, mas o valor não está acessível.
Múltiplas declarações nomeadas `_` podem existir no mesmo namespace sem um erro de colisão.

Declarações de nível superior ou membros onde a privacidade da biblioteca pode ser afetada não são
usos válidos para variáveis wildcard.
Declarações locais a um escopo de bloco, como os exemplos a seguir,
podem declarar um wildcard:

* Declaração de variável local.
  ```dart
  main() {
    var _ = 1;
    int _ = 2;
  }
  ```

* Declaração de variável de loop for.
  ```dart
  for (var _ in list) {}
  ```

* Parâmetros de cláusula catch.
  ```dart
  try {
    throw '!';
  } catch (_) {
    print('oops');
  }
  ```

* Parâmetros de tipo genérico e de tipo de função.
  ```dart
  class T<_> {}
  void genericFunction<_>() {}

  takeGenericCallback(<_>() => true);
  ```

* Parâmetros de função.
  ```dart
  Foo(_, this._, super._, void _()) {}

  list.where((_) => true);

  void f(void g(int _, bool _)) {}

  typedef T = void Function(String _, String _);
  ```

:::tip
Habilite o lint [`unnecessary_underscores`][] para identificar onde uma única
variável wildcard não-vinculante `_` pode substituir a convenção anterior de usar
múltiplos underscores vinculantes (`__`,`___`, etc.) para evitar colisões de nome.
:::

[Assert]: /language/error-handling#assert
[Instance variables]: /language/classes#instance-variables
[DON'T use const redundantly]: /effective-dart/usage#dont-use-const-redundantly
[type checks and casts]: /language/operators#type-test-operators
[collection `if`]: /language/collections#control-flow-operators
[spread operators]: /language/collections#spread-operators
[Lists]: /language/collections#lists
[Maps]: /language/collections#maps
[Classes]: /language/classes
[language version]: /resources/language/evolution#language-versioning
[`unnecessary_underscores`]: /tools/linter-rules/unnecessary_underscores
