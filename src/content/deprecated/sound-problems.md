---
ia-translate: true
title: Corrigindo problemas comuns de tipos
description: Problemas comuns de tipos que você pode encontrar e como resolvê-los.
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="type_system"?>

Se você estiver tendo problemas com verificações de tipo,
esta página pode ajudar. Para aprender mais, leia sobre
o [sistema de tipos do Dart](/language/type-system) (Dart's type system),
e veja [estes outros recursos](/language/type-system#other-resources).

:::note Ajude-nos a melhorar esta página!
Se você encontrar um aviso ou erro que não
estiver listado aqui, por favor, abra uma issue clicando no ícone de **inseto** no canto superior
direito. Inclua a **mensagem de aviso ou erro** e, se possível, o código para
um pequeno caso reprodutível e seu equivalente correto.
:::

## Resolução de problemas {:#troubleshooting}

Dart impõe um sistema de tipos sólido.
Isso significa que você não pode escrever código onde o
valor de uma variável difere de seu tipo estático.
Uma variável com tipo `int` não pode armazenar um número com casas decimais.
Dart verifica os valores das variáveis em relação aos seus tipos em
[tempo de compilação](#static-errors-and-warnings) e [tempo de execução](#runtime-errors).

Você não pode entrar em uma situação em que o valor armazenado em uma variável seja
diferente do tipo estático da variável. Como a maioria das linguagens modernas com tipagem estática,
Dart consegue isso com uma combinação de verificações
[estáticas (em tempo de compilação)](#static-errors-and-warnings) e [dinâmicas (em tempo de execução)](#runtime-errors).

Por exemplo, o seguinte erro de tipo é detectado em tempo de compilação:

```dart tag=fails-sa
List<int> numbers = [1, 2, 3];
List<String> [!string = numbers!];
```

Como nem `List<int>` nem `List<String>` é um subtipo do outro,
Dart descarta isso estaticamente.

Você pode ver outros exemplos de erros de análise estática,
bem como outros tipos de erros, nas seções a seguir.


## Sem erros de tipo {:#no-type-errors}

Se você não estiver vendo os erros ou avisos esperados,
certifique-se de que está usando a versão mais recente do Dart
e que configurou corretamente sua [IDE ou editor](/tools#editors).

Você também pode executar a análise em seu programa usando a linha de comando
com o comando [`dart analyze`](/tools/dart-analyze).

Para verificar se a análise está funcionando conforme o esperado,
tente adicionar o seguinte código a um arquivo Dart.

<?code-excerpt "lib/strong_analysis.dart (static-analysis-enabled)"?>
```dart tag=fails-sa
bool b = [0][0];
```

Se configurado corretamente, o analisador produz o seguinte erro:

<?code-excerpt "analyzer-results-stable.txt" retain="/'int' can't be .* 'bool'/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - Um valor do tipo 'int' não pode ser atribuído a uma variável do tipo 'bool'. Tente alterar o tipo da variável ou converter o tipo do lado direito para 'bool'. - invalid_assignment
```

<a name="common-errors"></a>
## Erros e avisos estáticos {:#static-errors-and-warnings}

Esta seção mostra como corrigir alguns dos erros e avisos
que você pode ver no analisador ou em uma IDE.

A análise estática não pode capturar todos os erros.
Para obter ajuda para corrigir erros que aparecem apenas em tempo de execução,
consulte [Erros de tempo de execução](#runtime-errors).

### Membro não definido {:#undefined-member}

<?code-excerpt "analyzer-results-stable.txt" retain="/getter.*isn't defined for the type/" replace="/. Try.*.'context2D'. / /g; /getter/<member\x3E/g; /'\w+'/'...'/g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - O <member> '...' não está definido para o tipo '...' - undefined_<member>
```

Esses erros podem aparecer nas seguintes condições:

- Uma variável é estaticamente conhecida como algum supertipo, mas o código assume um subtipo.
- Uma classe genérica tem um parâmetro de tipo delimitado, mas uma expressão de criação de instância
  da classe omite o argumento de tipo.

#### Exemplo 1: Uma variável é estaticamente conhecida como algum supertipo, mas o código assume um subtipo {:#example-1-a-variable-is-statically-known-to-be-some-supertype-but-the-code-assumes-a-subtype}

No código a seguir, o analisador reclama que `context2D` não está definido:

<?code-excerpt "lib/common_fixes_analysis.dart (canvas-undefined)" replace="/context2D/[!$&!]/g"?>
```dart tag=fails-sa
var canvas = querySelector('canvas')!;
canvas.[!context2D!].lineTo(x, y);
```

<?code-excerpt "analyzer-results-stable.txt" retain="/context2D.*isn't defined for the type/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - O getter 'context2D' não está definido para o tipo 'Element'. Tente importar a biblioteca que define 'context2D', corrigindo o nome para o nome de um getter existente ou definindo um getter ou campo chamado 'context2D'. - undefined_getter
```

#### Correção: Substitua a definição do membro por uma declaração de tipo explícita ou uma conversão (downcast) {:#fix-replace-the-definition-of-the-member-with-an-explicit-type-declaration-or-a-downcast}

O tipo de retorno de `querySelector()` é `Element?`
(que o `!` converte para `Element`),
mas o código assume que é o subtipo `CanvasElement`
(que define `context2D`).
O campo `canvas` é declarado como `var`,
o que permite que o Dart infera `canvas` como um `Element`.

Você pode corrigir esse erro com uma conversão explícita (downcast):

<?code-excerpt "lib/common_fixes_analysis.dart (canvas-as)" replace="/as \w+/[!$&!]/g"?>
```dart tag=passes-sa
var canvas = querySelector('canvas') [!as CanvasElement!];
canvas.context2D.lineTo(x, y);
```

Caso contrário, use `dynamic` em situações em que você não pode usar um único tipo:

<?code-excerpt "lib/common_fixes_analysis.dart (canvas-dynamic)" replace="/dynamic/[!$&!]/g"?>
```dart tag=passes-sa
[!dynamic!] canvasOrImg = querySelector('canvas, img');
var width = canvasOrImg.width;
```

#### Exemplo 2: Parâmetros de tipo omitidos assumem seus limites de tipo {:#example-2-omitted-type-parameters-default-to-their-type-bounds}

Considere a seguinte **classe genérica** com um **parâmetro de tipo delimitado**
que estende `Iterable`:

<?code-excerpt "lib/bounded/my_collection.dart"?>
```dart
class C<T extends Iterable> {
  final T collection;
  C(this.collection);
}
```

O código a seguir cria uma nova instância dessa classe
(omitindo o argumento de tipo) e acessa seu membro `collection`:

<?code-excerpt "lib/bounded/instantiate_to_bound.dart (undefined-method)" replace="/c\.add\(2\)/[!$&!]/g"?>
```dart tag=fails-sa
var c = C(Iterable.empty()).collection;
[!c.add(2)!];
```

<?code-excerpt "analyzer-results-stable.txt" retain="/add.*isn't defined for the type/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - O método 'add' não está definido para o tipo 'Iterable'. Tente corrigir o nome para o nome de um método existente ou definir um método chamado 'add'. - undefined_method
```

Enquanto o tipo [List][] tem um método `add()`, [Iterable][] não tem.

#### Correção: Especifique argumentos de tipo ou corrija erros a jusante {:#fix-specify-type-arguments-or-fix-downstream-errors}

Quando uma classe genérica é instanciada sem argumentos de tipo explícitos,
cada parâmetro de tipo assume seu limite de tipo (`Iterable` neste exemplo) se
um for explicitamente fornecido, ou `dynamic` caso contrário.

Você precisa abordar a correção de tais erros caso a caso. É útil
ter um bom entendimento da intenção original do design.

Passar argumentos de tipo explicitamente é uma maneira eficaz de ajudar a identificar
erros de tipo. Por exemplo, se você alterar o código para especificar `List` como um tipo
argumento, o analisador pode detectar a incompatibilidade de tipo no argumento do construtor.
Corrija o erro fornecendo um argumento de construtor do tipo apropriado,
como um literal de lista:

<?code-excerpt "test/strong_test.dart (add-type-arg)" replace="/.List.|\[\]/[!$&!]/g"?>
```dart tag=passes-sa
var c = C[!<List>!]([![]!]).collection;
c.add(2);
```

<hr>

### Substituição de método inválida {:#invalid-method-override}

<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*add/" replace="/'[\w\.]+'/'...'/g; /\('.*?'\)//g; /-(.*?):(.*?):(.*?)-/-/g; /' . -/' -/g"?>
```plaintext
error - '...' não é uma substituição válida de '...' - invalid_override
```

Esses erros geralmente ocorrem quando uma subclasse restringe os tipos de parâmetro de um método
especificando uma subclasse da classe original.

:::note
Este problema também pode ocorrer quando uma subclasse genérica deixa de especificar um tipo.
Para mais informações, consulte [Argumentos de tipo ausentes](#missing-type-arguments).
:::

#### Exemplo

No exemplo a seguir, os parâmetros do método `add()` são do tipo `int`,
um subtipo de `num`, que é o tipo de parâmetro usado na classe pai.

<?code-excerpt "lib/common_fixes_analysis.dart (invalid-method-override)" replace="/int(?= \w\b.*=)/[!$&!]/g"?>
```dart tag=fails-sa
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  @override
  num add([!int!] a, [!int!] b) => a + b;
}
```

<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*add/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - 'MyAdder.add' ('num Function(int, int)') não é uma substituição válida de 'NumberAdder.add' ('num Function(num, num)'). - invalid_override
```

Considere o seguinte cenário em que valores de ponto flutuante
são passados para um `MyAdder`:

<?code-excerpt "lib/common_fixes_analysis.dart (runtime-failure-if-int)" replace="/1.2/[!1.2!]/g/3.4/[!3.4!]/g"?>
```dart tag=runtime-fail
NumberAdder adder = MyAdder();
adder.add([!1.2!], [!3.4!]);
```

Se a substituição fosse permitida, o código geraria um erro em tempo de execução.

#### Correção: Amplie os tipos de parâmetro do método {:#fix-widen-the-method-s-parameter-types}

O método da subclasse deve aceitar todos os
objetos que o método da superclasse recebe.

Corrija o exemplo expandindo os tipos na subclasse:

<?code-excerpt "lib/common_fixes_analysis.dart (invalid-method-override)" replace="/int(?= \w\b.*=)/[!num!]/g"?>
```dart tag=passes-sa
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  @override
  num add([!num!] a, [!num!] b) => a + b;
}
```

Para mais informações, consulte
[Use tipos de parâmetros de entrada adequados ao substituir métodos](/language/type-system#use-proper-param-types).

:::note
Se você tiver um motivo válido para usar um subtipo, poderá usar a
palavra-chave [covariant](#the-covariant-keyword).
:::

<hr>

### Argumentos de tipo ausentes {:#missing-type-arguments}

<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*method/" replace="/'\S+'/'...'/g; /\('.*?'\)//g; /-(.*?):(.*?):(.*?)-/-/g; /' . -/' -/g"?>
```plaintext
error - '...' não é uma substituição válida de '...' - invalid_override
```

#### Exemplo

No exemplo a seguir, `Subclass` estende `Superclass<T>`, mas não
especifica um argumento de tipo. O analisador infere `Subclass<dynamic>`,
o que resulta em um erro de substituição inválida em `method(int)`.

<?code-excerpt "lib/common_fixes_analysis.dart (type-arguments)" replace="/int/[!$&!]/g"?>
```dart tag=fails-sa
class Superclass<T> {
  void method(T param) { ... }
}

class Subclass extends Superclass {
  @override
  void method([!int!] param) { ... }
}
```

<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*method/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - 'Subclass.method' ('void Function(int)') não é uma substituição válida de 'Superclass.method' ('void Function(dynamic)'). - invalid_override
```

#### Correção: Especifique argumentos de tipo para a subclasse genérica {:#fix-specify-type-arguments-for-the-generic-subclass}

Quando uma subclasse genérica deixa de especificar um argumento de tipo,
o analisador infere o tipo `dynamic`. Isso provavelmente causará
erros.

Você pode corrigir o exemplo especificando o tipo na subclasse:

<?code-excerpt "lib/common_fixes_analysis.dart (type-arguments)" replace="/Superclass /Superclass[!<int\x3E!] /g"?>
```dart tag=passes-sa
class Superclass<T> {
  void method(T param) { ... }
}

class Subclass extends Superclass[!<int>!] {
  @override
  void method(int param) { ... }
}
```

Considere usar o analisador no modo _tipos brutos estritos_,
que garante que seu código especifique argumentos de tipo genéricos.
Aqui está um exemplo de como habilitar tipos brutos estritos em
o arquivo `analysis_options.yaml` do seu projeto:

```yaml
analyzer:
  language:
    strict-raw-types: true
```

Para saber mais sobre como personalizar o comportamento do analisador,
consulte [Personalizando a análise estática](/tools/analysis).

<hr>

<a id ="assigning-mismatched-types"></a>
### Tipo de elemento de coleção inesperado {:#unexpected-collection-element-type}

<?code-excerpt "analyzer-results-stable.txt" retain="/common_fixes_analysis.*'double' can't be assigned to a variable of type 'int'./" replace="/. Try.*'int'. / /g; /'\S+'/'...'/g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - Um valor do tipo '...' não pode ser atribuído a uma variável do tipo '...' - invalid_assignment
```

Isso às vezes acontece quando você cria uma coleção dinâmica simples
e o analisador infere o tipo de uma maneira que você não esperava.
Quando você adiciona posteriormente valores de um tipo diferente, o analisador relata um problema.

#### Exemplo

O código a seguir inicializa um mapa com vários
pares (`String`, `int`). O analisador infere que o mapa é do tipo `<String, int>`
mas o código parece assumir `<String, dynamic>` ou `<String, num>`.
Quando o código adiciona um par (`String`, `double`), o analisador reclama:

<?code-excerpt "lib/common_fixes_analysis.dart (inferred-collection-types)" replace="/1.5/[!1.5!]/g"?>
```dart tag=fails-sa
// Inferido como Map<String, int>
var map = {'a': 1, 'b': 2, 'c': 3};
map['d'] = [!1.5!];
```

<?code-excerpt "analyzer-results-stable.txt" retain="/common_fixes_analysis.*'double' can't be assigned to a variable of type 'int'/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - Um valor do tipo 'double' não pode ser atribuído a uma variável do tipo 'int'. Tente alterar o tipo da variável ou converter o tipo do lado direito para 'int'. - invalid_assignment
```

#### Correção: Especifique o tipo explicitamente {:#fix-specify-the-type-explicitly}

O exemplo pode ser corrigido definindo explicitamente
o tipo do mapa como `<String, num>`.

<?code-excerpt "lib/common_fixes_analysis.dart (inferred-collection-types-ok)" replace="/<.*?\x3E/[!$&!]/g"?>
```dart tag=passes-sa
var map = [!<String, num>!]{'a': 1, 'b': 2, 'c': 3};
map['d'] = 1.5;
```

Alternativamente, se você quiser que este mapa aceite qualquer valor,
especifique o tipo como `<String, dynamic>`.

<hr>

<a id="constructor-initialization-list"></a>
### Lista de inicialização do construtor - chamada super() {:#constructor-initialization-list-super-call}

<?code-excerpt "analyzer-results-stable.txt" retain="/The superconstructor call must be last in an initializer list.*/" replace="/Animal/.../g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - A chamada do superconstrutor deve ser a última em uma lista de inicializadores: '...'. - super_invocation_not_last
```

Este erro ocorre quando a chamada `super()` não é a última em uma lista de inicialização de um construtor.

#### Exemplo

<?code-excerpt "lib/common_fixes_analysis.dart (super-goes-last)" replace="/super/[!$&!]/g; /_HoneyBadger/HoneyBadger/g"?>
```dart tag=fails-sa
HoneyBadger(Eats food, String name)
    : [!super!](food),
      _name = name { ... }
```

<?code-excerpt "analyzer-results-stable.txt" retain="/The superconstructor call must be last in an initializer list.*/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - A chamada do superconstrutor deve ser a última em uma lista de inicializadores: 'Animal'. - super_invocation_not_last
```

#### Correção: Coloque a chamada `super()` por último {:#fix-put-the-super-call-last}

O compilador pode gerar código mais simples se depender da
chamada `super()` aparecendo por último.

Corrija esse erro movendo a chamada `super()`:

<?code-excerpt "lib/common_fixes_analysis.dart (super-goes-last-ok)" replace="/super/[!$&!]/g"?>
```dart tag=passes-sa
HoneyBadger(Eats food, String name)
    : _name = name,
      [!super!](food) { ... }
```

<hr>

<a name="uses-dynamic-as-bottom"></a>
### O tipo do argumento ... não pode ser atribuído ao tipo do parâmetro ... {:#the-argument-type-can-t-be-assigned-to-the-parameter-type}

<?code-excerpt "analyzer-results-stable.txt" retain="/The argument type.*bool Function/" replace="/'bool.*?\)'/'...'/g; /-(.*?):(.*?):(.*?)-/-/g"?>
```plaintext
error - O tipo de argumento '...' não pode ser atribuído ao tipo de parâmetro '...'. - argument_type_not_assignable
```

Em Dart 1.x, `dynamic` era simultaneamente um [tipo superior][] (supertipo de todos os tipos) e um
[tipo inferior][] (subtipo de todos os tipos)
dependendo do contexto. Isso significava que era válido atribuir, por exemplo,
uma função com um parâmetro do tipo `String` a um local que esperava uma
função com um parâmetro `dynamic`.

No entanto, no Dart 2, usar um tipo de parâmetro diferente de `dynamic` (ou outro tipo _superior_,
como `Object?`) resulta em um erro de compilação.

#### Exemplo

<?code-excerpt "lib/common_fixes_analysis.dart (func-fail)" replace="/String/[!$&!]/g"?>
```dart tag=fails-sa
void filterValues(bool Function(dynamic) filter) {}
filterValues(([!String!] x) => x.contains('Hello'));
```

<?code-excerpt "analyzer-results-stable.txt" retain="/The argument type.*bool Function/" replace="/-(.*?)-/-/g"?>
```plaintext
error - O tipo de argumento 'bool Function(String)' não pode ser atribuído ao tipo de parâmetro 'bool Function(dynamic)'. - argument_type_not_assignable
```

#### Correção: Adicione parâmetros de tipo _ou_ faça um cast de dynamic explicitamente {:#fix-add-type-parameters-or-cast-from-dynamic-explicitly}

Quando possível, evite esse erro adicionando parâmetros de tipo:

<?code-excerpt "lib/common_fixes_analysis.dart (func-T)" replace="/<\w+\x3E/[!$&!]/g"?>
```dart tag=passes-sa
void filterValues[!<T>!](bool Function(T) filter) {}
filterValues[!<String>!]((x) => x.contains('Hello'));
```

Caso contrário, use conversão (casting):

<?code-excerpt "lib/common_fixes_analysis.dart (func-cast)" replace="/([Ff]ilter)1/$1/g; /as \w+/[!$&!]/g"?>
```dart tag=passes-sa
void filterValues(bool Function(dynamic) filter) {}
filterValues((x) => (x [!as String!]).contains('Hello'));
```

<hr>

### Inferência de tipo incorreta {:#incorrect-type-inference}

Em raras ocasiões, a inferência de tipo do Dart pode inferir
o tipo errado para argumentos literais de função em uma invocação de construtor genérica.
Isso afeta principalmente `Iterable.fold`.

#### Exemplo

No código a seguir,
a inferência de tipo inferirá que `a` tem o tipo `Null`:

<?code-excerpt "lib/common_fixes_analysis.dart (type-inf-null)"?>
```dart tag=fails-sa
var ints = [1, 2, 3];
var maximumOrNull = ints.fold(null, (a, b) => a == null || a < b ? b : a);
```

#### Correção: Forneça o tipo apropriado como argumento de tipo explícito {:#fix-supply-appropriate-type-as-explicit-type-argument}

<?code-excerpt "lib/common_fixes_analysis.dart (type-inf-fix)"?>
```dart tag=passes-sa
var ints = [1, 2, 3];
var maximumOrNull =
    ints.fold<int?>(null, (a, b) => a == null || a < b ? b : a);
```

<hr>

### Superinterfaces conflitantes {:#conflicting-superinterfaces}

Uma classe que `implements` mais de uma superinterface deve ser capaz de
implementar substituições válidas para cada membro de cada superinterface.
Cada membro com um determinado nome requer assinaturas compatíveis entre as
superinterfaces.

As superinterfaces não devem incluir genéricos conflitantes.
Uma classe não pode implementar `C<A>` e `C<B>` simultaneamente, incluindo superinterfaces indiretas.

#### Exemplo

No código a seguir,
a classe `C` tem interfaces genéricas conflitantes.
Definições de substituições válidas para alguns membros seriam impossíveis.

<?code-excerpt "lib/common_fixes_analysis.dart (conflicting-generics)"?>
```dart tag=fails-sa
abstract class C implements List<int>, Iterable<num> {}
```

#### Correção: Use genéricos consistentes ou evite repetir interfaces transitivas {:#fix-use-consistent-generics-or-avoid-repeating-transitive-interfaces}

<?code-excerpt "lib/common_fixes_analysis.dart (compatible-generics)"?>
```dart tag=passes-sa
abstract class C implements List<int> {}
```

<a id="common-errors-and-warnings"></a>

## Erros de tempo de execução {:#runtime-errors}

Os erros discutidos nesta seção são relatados em
[tempo de execução](/language/type-system#runtime-checks).

### Conversões inválidas {:#invalid-casts}

Para garantir a segurança de tipo, Dart precisa inserir verificações _em tempo de execução_ em alguns casos.
Considere o seguinte método `assumeStrings`:

<?code-excerpt "test/strong_test.dart (downcast-check)" replace="/string = objects/[!$&!]/g"?>
```dart tag=passes-sa
void assumeStrings(dynamic objects) {
  List<String> strings = objects; // Verificação de conversão (downcast) em tempo de execução
  String string = strings[0]; // Espera um valor String
}
```

A atribuição a `strings` está _convertendo_ (downcasting) implicitamente o `dynamic` para `List<String>`
(como se você tivesse escrito `as List<String>`), então se o valor que você passar em
`objects` em tempo de execução for um `List<String>`, a conversão terá sucesso.

Caso contrário, a conversão falhará em tempo de execução:

<?code-excerpt "test/strong_test.dart (fail-downcast-check)" replace="/\[.*\]/[!$&!]/g"?>
```dart tag=runtime-fail
assumeStrings(<int>[![1, 2, 3]!]);
```

<?code-excerpt "test/strong_test.dart (downcast-check-msg)" replace="/const msg = ./Exception: /g; /.;//g"?>
```plaintext
Exception: o tipo 'List<int>' não é um subtipo do tipo 'List<String>'
```

#### Correção: Aperte ou corrija os tipos {:#fix-tighten-or-correct-types}

Às vezes, a falta de um tipo, especialmente com coleções vazias, significa que
uma coleção `<dynamic>` é criada, em vez da coleção tipada que você pretendia.
Adicionar um argumento de tipo explícito pode ajudar:

<?code-excerpt "test/strong_test.dart (typed-list-lit)" replace="/<String\x3E/[!$&!]/g"?>
```dart tag=runtime-success
var list = [!<String>!][!<String>!];
list.add('a string');
list.add('another');
assumeStrings(list);
```

Você também pode tipificar com mais precisão a variável local e deixar a inferência ajudar:

<?code-excerpt "test/strong_test.dart (typed-list)" replace="/<String\x3E/[!$&!]/g"?>
```dart tag=runtime-success
List[!<String>!] list = [];
list.add('a string');
list.add('another');
assumeStrings(list);
```

Em casos em que você está trabalhando com uma coleção que você não cria, como
de JSON ou de uma fonte de dados externa, você pode usar o método [cast()][]
fornecido por implementações de `Iterable`, como `List`.

Aqui está um exemplo da solução preferida: apertando o tipo do objeto.

<?code-excerpt "test/strong_test.dart (cast)" replace="/cast/[!$&!]/g"?>
```dart tag=runtime-success
Map<String, dynamic> json = fetchFromExternalSource();
var names = json['names'] as List;
assumeStrings(names.[!cast!]<String>());
```

## Apêndice {:#appendix}

### A palavra-chave covariant {:#the-covariant-keyword}

Alguns padrões de codificação (raramente usados) dependem do aperto de um tipo
subscrevendo o tipo de um parâmetro com um subtipo, o que é inválido.
Neste caso, você pode usar a palavra-chave `covariant` para
informar ao analisador que você está fazendo isso intencionalmente.
Isso remove o erro estático e, em vez disso, verifica se há um tipo de argumento inválido
em tempo de execução.

O seguinte mostra como você pode usar `covariant`:

<?code-excerpt "lib/covariant.dart" replace="/covariant/[!$&!]/g"?>
```dart tag=passes-sa
class Animal {
  void chase(Animal x) { ... }
}

class Mouse extends Animal { ... }

class Cat extends Animal {
  @override
  void chase([!covariant!] Mouse x) { ... }
}
```

Embora este exemplo mostre o uso de `covariant` no subtipo,
a palavra-chave `covariant` pode ser colocada no método da superclasse
ou na subclasse.
Geralmente, o método da superclasse é o melhor lugar para colocá-la.
A palavra-chave `covariant` se aplica a um único parâmetro e também é
suportada em setters e campos.

[tipo inferior]: https://en.wikipedia.org/wiki/Bottom_type
[cast()]: {{site.dart-api}}/dart-core/Iterable/cast.html
[Iterable]: {{site.dart-api}}/dart-core/Iterable-class.html
[List]: {{site.dart-api}}/dart-core/List-class.html
[tipo superior]: https://en.wikipedia.org/wiki/Top_type
