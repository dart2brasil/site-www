---
ia-translate: true
title: Variáveis
description: Aprenda sobre variáveis em Dart.
prevpage:
  url: /language
  title: Básico
nextpage:
  url: /language/operators
  title: Operadores
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Eis um exemplo de criação e inicialização de uma variável:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-decl)"?>
```dart
var name = 'Bob';
```

Variáveis armazenam referências. A variável chamada `name` contém uma
referência a um objeto `String` com o valor "Bob".

O tipo da variável `name` é inferido como `String`,
mas você pode alterar esse tipo especificando-o.
Se um objeto não estiver restrito a um único tipo,
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
[recomendação do guia de estilo][style guide recommendation]
de usar `var`, em vez de anotações de tipo, para variáveis locais.
:::

## Segurança Nula

A linguagem Dart impõe segurança nula (null safety) robusta.

A segurança nula evita um erro resultante do acesso não intencional
de variáveis definidas como `null`. O erro é chamado de erro de
desreferência nula. Um erro de desreferência nula ocorre quando você
acessa uma propriedade ou chama um método em uma expressão que é avaliada
como `null`. Uma exceção a esta regra é quando `null` suporta a
propriedade ou método, como `toString()` ou `hashCode`. Com a
segurança nula, o compilador Dart detecta esses possíveis erros em tempo de compilação.

Por exemplo, digamos que você queira encontrar o valor absoluto de uma
variável `int` chamada `i`. Se `i` for `null`, chamar `i.abs()` causa
um erro de desreferência nula. Em outras linguagens, tentar isso poderia
levar a um erro de tempo de execução, mas o compilador do Dart proíbe
essas ações. Portanto, os aplicativos Dart não podem causar erros de tempo de execução.

A segurança nula introduz três mudanças importantes:

1.  Quando você especifica um tipo para uma variável, parâmetro ou
    outro componente relevante, você pode controlar se o tipo permite
    `null`. Para habilitar a nulidade, você adiciona um `?` ao final da
    declaração de tipo.

    ```dart
    String? name  // Tipo anulável. Pode ser `null` ou string.

    String name   // Tipo não anulável. Não pode ser `null`, mas pode ser string.
    ```

2.  Você deve inicializar as variáveis antes de usá-las.
    Variáveis anuláveis usam `null` por padrão, então elas são
    inicializadas por padrão. O Dart não define valores iniciais para
    tipos não anuláveis. Ele força você a definir um valor inicial. O
    Dart não permite que você observe uma variável não inicializada. Isso
    impede que você acesse propriedades ou chame métodos onde o tipo do
    receptor pode ser `null`, mas `null` não suporta o método ou
    propriedade usado.

3.  Você não pode acessar propriedades ou chamar métodos em uma expressão com um
    tipo anulável. A mesma exceção se aplica onde é uma propriedade ou método que
    `null` suporta, como `hashCode` ou `toString()`.

A segurança nula robusta transforma possíveis **erros em tempo de execução**
em erros de análise em **tempo de edição**. A segurança nula sinaliza uma
variável não nula quando ela foi:

* Não inicializada com um valor não nulo.
* Atribuído um valor `null`.

Essa verificação permite que você corrija esses erros _antes_ de implantar seu aplicativo.

## Valor padrão

Variáveis não inicializadas que possuem um tipo anulável
têm um valor inicial de `null`.
Mesmo variáveis com tipos numéricos são inicialmente nulas,
porque números—assim como todo o resto em Dart—são objetos.

<?code-excerpt "misc/test/language_tour/variables_test.dart (var-null-init)"?>
```dart
int? lineCount;
assert(lineCount == null);
```

:::note
O código de produção ignora a chamada `assert()`. Durante o desenvolvimento, por outro
lado, <code>assert(<em>condição</em>)</code> lança uma exceção se
_condição_ for falsa. Para detalhes, confira [Assert][Assert].
:::

Com a segurança nula, você deve inicializar os valores
de variáveis não anuláveis antes de usá-las:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-ns-init)"?>
```dart
int lineCount = 0;
```

Você não precisa inicializar uma variável local onde ela é declarada,
mas você precisa atribuir um valor a ela antes que ela seja usada.
Por exemplo, o código a seguir é válido porque
o Dart pode detectar que `lineCount` não é nula no momento em que
ela é passada para `print()`:

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

## Variáveis Late

O modificador `late` tem dois casos de uso:

* Declarar uma variável não anulável que é inicializada após sua declaração.
* Inicializar uma variável preguiçosamente.

Muitas vezes, a análise de fluxo de controle do Dart pode detectar quando uma
variável não anulável é definida com um valor não nulo antes de ser
usada, mas às vezes a análise falha. Dois casos comuns são variáveis de
nível superior e variáveis de instância: O Dart geralmente não pode
determinar se elas estão definidas, então não tenta.

Se você tiver certeza de que uma variável está definida antes de ser usada,
mas o Dart discorda,
você pode corrigir o erro marcando a variável como `late`:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-late-top-level)" replace="/late/[!$&!]/g"?>
```dart
[!late!] String description;

void main() {
  description = 'Feijoada!';
  print(description);
}
```

:::warning Atenção
Se você não conseguir inicializar uma variável `late`,
um erro de tempo de execução ocorrerá quando a variável for usada.
:::

Quando você marca uma variável como `late`, mas a inicializa em sua declaração,
o inicializador é executado na primeira vez que a variável é usada.
Essa inicialização preguiçosa é útil em alguns casos:

* A variável pode não ser necessária,
   e inicializá-la é caro.
* Você está inicializando uma variável de instância,
   e seu inicializador precisa acessar `this`.

No exemplo a seguir,
se a variável `temperature` nunca for usada,
a função cara `readThermometer()` nunca será chamada:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-late-lazy)" replace="/late/[!$&!]/g"?>
```dart
// Esta é a única chamada do programa para readThermometer().
[!late!] String temperature = readThermometer(); // Inicializada preguiçosamente.
```

## Final e const

Se você nunca pretende alterar uma variável, use `final` ou `const`,
seja em vez de `var` ou além de um tipo. Uma variável final pode ser
definida apenas uma vez; uma variável const é uma constante em tempo
de compilação. (Variáveis const são implicitamente final.)

:::note
[Variáveis de instância][Instance variables] podem ser `final`, mas não `const`.
:::

Aqui está um exemplo de criação e definição de uma variável `final`:

<?code-excerpt "misc/lib/language_tour/variables.dart (final)"?>
```dart
final name = 'Bob'; // Sem uma anotação de tipo
final String nickname = 'Bobby';
```

Você não pode alterar o valor de uma variável `final`:

<?code-excerpt "misc/lib/language_tour/variables.dart (cant-assign-to-final)"?>
```dart tag=fails-sa
name = 'Alice'; // Erro: uma variável final só pode ser definida uma vez.
```

Use `const` para variáveis que você deseja que sejam **constantes em tempo de compilação**. Se
a variável const estiver no nível da classe, marque-a como `static const`.
Onde você declara a variável, defina o valor para uma constante em tempo de
compilação, como um número ou literal de string, uma variável const ou o
resultado de uma operação aritmética em números constantes:

<?code-excerpt "misc/lib/language_tour/variables.dart (const)"?>
```dart
const bar = 1000000; // Unidade de pressão (dinas/cm2)
const double atm = 1.01325 * bar; // Atmosfera padrão
```

A palavra-chave `const` não é apenas para declarar variáveis constantes.
Você também pode usá-la para criar _valores_ constantes,
bem como para declarar construtores que _criam_ valores constantes.
Qualquer variável pode ter um valor constante.

<?code-excerpt "misc/lib/language_tour/variables.dart (const-vs-final)"?>
```dart
var foo = const [];
final bar = const [];
const baz = []; // Equivalente a `const []`
```

Você pode omitir `const` da expressão de inicialização de uma declaração
`const`, como para `baz` acima. Para detalhes, veja [NÃO use const
redundantemente][DON'T use const redundantly].

Você pode alterar o valor de uma variável não final e não const,
mesmo que ela costumava ter um valor `const`:

<?code-excerpt "misc/lib/language_tour/variables.dart (reassign-to-non-final)"?>
```dart
foo = [1, 2, 3]; // Era const []
```

Você não pode alterar o valor de uma variável `const`:

<?code-excerpt "misc/lib/language_tour/variables.dart (cant-assign-to-const)"?>
```dart tag=fails-sa
baz = [42]; // Erro: Variáveis constantes não podem receber um valor.
```

Você pode definir constantes que usam
[verificações e conversões de tipo][type checks and casts] (`is` e `as`),
[`if` de coleção][collection `if`],
e [operadores de propagação][spread operators] (`...` e `...?`):

<?code-excerpt "misc/lib/language_tour/variables.dart (const-dart-25)"?>
```dart
const Object i = 3; // Onde i é um Object const com um valor int...
const list = [i as int]; // Use uma conversão de tipo.
const map = {if (i is int) i: 'int'}; // Use is e if de coleção.
const set = {if (list is List<int>) ...list}; // ...e uma propagação.
```

:::note
Embora um objeto `final` não possa ser modificado,
seus campos podem ser alterados.
Em comparação, um objeto `const` e seus campos
não podem ser alterados: eles são _imutáveis_.
:::

Para mais informações sobre como usar `const` para criar valores constantes, veja
[Listas][Lists], [Mapas][Maps] e [Classes][Classes].

[style guide recommendation]: /effective-dart/design#types
[Assert]: /language/error-handling#assert
[Instance variables]: /language/classes#instance-variables
[DON'T use const redundantly]: /effective-dart/usage#dont-use-const-redundantly
[type checks and casts]: /language/operators#type-test-operators
[collection `if`]: /language/collections#control-flow-operators
[spread operators]: /language/collections#spread-operators
[Lists]: /language/collections#lists
[Maps]: /language/collections#maps
[Classes]: /language/classes
