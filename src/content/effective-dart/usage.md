---
ia-translate: true
title: "Dart Efetivo: Uso"
breadcrumb: Uso
description: Diretrizes para usar recursos da linguagem para escrever código de fácil manutenção.
nextpage:
  url: /effective-dart/design
  title: Design
prevpage:
  url: /effective-dart/documentation
  title: Documentação
---
<?code-excerpt plaster="none"?>
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Você pode usar estas diretrizes todos os dias nos corpos do seu código Dart. *Usuários*
da sua biblioteca podem não perceber que você internalizou as ideias aqui,
mas *mantenedores* dela certamente perceberão.

## Bibliotecas {:#libraries}

Estas diretrizes ajudam você a compor seu programa a partir de múltiplos arquivos de forma
consistente e de fácil manutenção. Para manter estas diretrizes breves, elas usam "import"
para abranger as diretivas `import` e `export`. As diretrizes se aplicam igualmente a ambas.

### FAÇA use strings em diretivas `part of` {:#do-use-strings-in-part-of-directives}

{% render 'linter-rule-mention.md', rules:'use_string_in_part_of_directives' %}

Muitos desenvolvedores Dart evitam usar `part` (parte) completamente. Eles acham mais fácil raciocinar
sobre seu código quando cada biblioteca é um único arquivo. Se você optar por usar
`part` para dividir parte de uma biblioteca em outro arquivo, o Dart exige que o outro
arquivo, por sua vez, indique a qual biblioteca ele faz parte.

O Dart permite que a diretiva `part of` use o *nome* de uma biblioteca.
Nomear bibliotecas é um recurso legado que agora é [desencorajado][desencorajado].
Nomes de bibliotecas podem introduzir ambiguidade
ao determinar a qual biblioteca uma parte pertence.

[desencorajado]: /effective-dart/style#dont-explicitly-name-libraries

A sintaxe preferida é usar uma string URI que aponta
diretamente para o arquivo da biblioteca.
Se você tem uma biblioteca, `my_library.dart`, que contém:

<?code-excerpt "my_library.dart" remove="ignore_for_file"?>
```dart title="my_library.dart"
library my_library;

part 'some/other/file.dart';
```

Então o arquivo de parte deve usar a string URI do arquivo da biblioteca:

<?code-excerpt "some/other/file.dart"?>
```dart tag=good
part of '../../my_library.dart';
```

Não o nome da biblioteca:

<?code-excerpt "some/other/file_2.dart (part-of)"?>
```dart tag=bad
part of my_library;
```

### NÃO importe bibliotecas que estão dentro do diretório `src` de outro pacote {:#dont-import-libraries-that-are-inside-the-src-directory-of-another-package}

{% render 'linter-rule-mention.md', rules:'implementation_imports' %}

O diretório `src` sob `lib` [é especificado][package guide] para conter
bibliotecas privadas para a própria implementação do pacote. A forma como os
mantenedores de pacotes versionam seus pacotes leva essa convenção em consideração. Eles
são livres para fazer mudanças abrangentes no código sob `src` sem que isso seja uma
mudança que quebre o pacote.

[package guide]: /tools/pub/package-layout

Isso significa que, se você importar uma biblioteca privada de outro pacote, uma
versão secundária teoricamente não-quebradora desse pacote pode quebrar seu código.


### NÃO permita que um caminho de importação alcance dentro ou fora de `lib` {:#dont-allow-an-import-path-to-reach-into-or-out-of-lib}

{% render 'linter-rule-mention.md', rules:'avoid_relative_lib_imports' %}

Uma importação `package:` permite que você acesse
uma biblioteca dentro do diretório `lib` de um pacote
sem ter que se preocupar onde o pacote está armazenado em seu computador.
Para que isso funcione, você não pode ter importações que exigem que o `lib`
esteja em algum local no disco em relação a outros arquivos.
Em outras palavras, um caminho de importação relativa em um arquivo dentro de `lib`
não pode alcançar e acessar um arquivo fora do diretório `lib`,
e uma biblioteca fora de `lib` não pode usar um caminho relativo
para alcançar o diretório `lib`.
Fazer qualquer um deles leva a erros confusos e programas quebrados.

Por exemplo, digamos que sua estrutura de diretórios seja assim:

```plaintext
my_package
└─ lib
   └─ api.dart
   test
   └─ api_test.dart
```

E digamos que `api_test.dart` importe `api.dart` de duas maneiras:

```dart title="api_test.dart" tag=bad
import 'package:my_package/api.dart';
import '../lib/api.dart';
```

O Dart pensa que essas são importações de duas bibliotecas completamente não relacionadas.
Para evitar confundir o Dart e você mesmo, siga estas duas regras:

* Não use `/lib/` em caminhos de importação.
* Não use `../` para escapar do diretório `lib`.

Em vez disso, quando você precisar alcançar o diretório `lib` de um pacote
(mesmo do diretório `test` do mesmo pacote
ou qualquer outro diretório de nível superior),
use uma importação `package:`.

```dart title="api_test.dart" tag=good
import 'package:my_package/api.dart';
```

Um pacote nunca deve alcançar *fora* de seu diretório `lib` e
importar bibliotecas de outros lugares do pacote.


### PREFIRA caminhos de importação relativos {:#prefer-relative-import-paths}

{% render 'linter-rule-mention.md', rules:'prefer_relative_imports' %}

Sempre que a regra anterior não entrar em jogo, siga esta.
Quando uma importação *não* alcança através de `lib`, prefira usar importações relativas.
Elas são mais curtas.
Por exemplo, digamos que sua estrutura de diretórios seja assim:

```plaintext
my_package
└─ lib
   ├─ src
   │  └─ stuff.dart
   │  └─ utils.dart
   └─ api.dart
   test
   │─ api_test.dart
   └─ test_utils.dart
```

Aqui está como as várias bibliotecas devem importar umas às outras:

```dart title="lib/api.dart" tag=good
import 'src/stuff.dart';
import 'src/utils.dart';
```

```dart title="lib/src/utils.dart" tag=good
import '../api.dart';
import 'stuff.dart';
```

```dart title="test/api_test.dart" tag=good
import 'package:my_package/api.dart'; // Não alcance 'lib'.

import 'test_utils.dart'; // Relativo dentro de 'test' está ok.
```


## Nulo {:#null}


### NÃO inicialize variáveis explicitamente com `null` {:#dont-explicitly-initialize-variables-to-null}

{% render 'linter-rule-mention.md', rules:'avoid_init_to_null' %}

Se uma variável tem um tipo não anulável, o Dart reporta um erro de compilação se você tentar
usá-la antes que ela tenha sido definitivamente inicializada. Se a variável é
anulável, então ela é implicitamente inicializada com `null` para você. Não há
conceito de "memória não inicializada" no Dart e não há necessidade de inicializar
explicitamente uma variável com `null` para ser "seguro".

<?code-excerpt "usage_good.dart (no-null-init)"?>
```dart tag=good
Item? bestDeal(List<Item> cart) {
  Item? bestItem;

  for (final item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
```

<?code-excerpt "usage_bad.dart (no-null-init)" replace="/ = null/[!$&!]/g"?>
```dart tag=bad
Item? bestDeal(List<Item> cart) {
  Item? bestItem[! = null!];

  for (final item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
```


### NÃO use um valor padrão explícito de `null` {:#dont-use-an-explicit-default-value-of-null}

{% render 'linter-rule-mention.md', rules:'avoid_init_to_null' %}

Se você torna um parâmetro anulável opcional, mas não lhe dá um valor padrão, a
linguagem implicitamente usa `null` como padrão, então não há necessidade de escrevê-lo.

<?code-excerpt "usage_good.dart (default-value-null)"?>
```dart tag=good
void error([String? message]) {
  stderr.write(message ?? '\n');
}
```

<?code-excerpt "usage_bad.dart (default-value-null)"?>
```dart tag=bad
void error([String? message = null]) {
  stderr.write(message ?? '\n');
}
```

<a id="prefer-using--to-convert-null-to-a-boolean-value"></a>
### NÃO use `true` ou `false` em operações de igualdade {:#dont-use-true-or-false-in-equality-operations}

Usar o operador de igualdade para avaliar uma expressão booleana *não anulável*
contra um literal booleano é redundante.
É sempre mais simples eliminar o operador de igualdade,
e usar o operador de negação unário `!` se necessário:

<?code-excerpt "usage_good.dart (non-null-boolean-expression)"?>
```dart tag=good
if (nonNullableBool) {
   ...
}

if (!nonNullableBool) {
   ...
}
```

<?code-excerpt "usage_bad.dart (non-null-boolean-expression)"?>
```dart tag=bad
if (nonNullableBool == true) {
   ...
}

if (nonNullableBool == false) {
   ...
}
```

Para avaliar uma expressão booleana que *é anulável*, você deve usar `??`
ou uma verificação explícita `!= null`.

<?code-excerpt "usage_good.dart (nullable-boolean-expression)"?>
```dart tag=good
// If you want null to result in false:
if (nullableBool ?? false) {
   ...
}

// If you want null to result in false
// and you want the variable to type promote:
if (nullableBool != null && nullableBool) {
   ...
}
```

<?code-excerpt "usage_bad.dart (nullable-boolean-expression)"?>
```dart tag=bad
// Static error if null:
if (nullableBool) {
   ...
}

// If you want null to be false:
if (nullableBool == true) {
   ...
}
```

`nullableBool == true` é uma expressão viável,
mas não deve ser usada por várias razões:

* Não indica que o código tem algo a ver com `null`.

* Por não ser evidentemente relacionado a `null`,
  pode ser facilmente confundido com o caso não anulável,
  onde o operador de igualdade é redundante e pode ser removido.
  Isso só é verdade quando a expressão booleana à esquerda
  não tem chance de produzir null, mas não quando pode.

* A lógica booleana é confusa. Se `nullableBool` é null,
  então `nullableBool == true` significa que a condição avalia para `false`.

O operador `??` deixa claro que algo a ver com null está acontecendo,
então não será confundido com uma operação redundante.
A lógica também é muito mais clara;
o resultado da expressão sendo `null` é o mesmo que o literal booleano.

Usar um operador nulo-ciente como `??` em uma variável dentro de uma condição
não promove a variável para um tipo não anulável.
Se você quer que a variável seja promovida dentro do corpo da instrução `if`,
é melhor usar uma verificação explícita `!= null` em vez de `??`.

### EVITE variáveis `late` se você precisar verificar se elas estão inicializadas {:#avoid-late-variables-if-you-need-to-check-whether-they-are-initialized}

O Dart não oferece uma maneira de dizer se uma variável `late` (atrasada)
foi inicializada ou atribuída.
Se você a acessa, ela executa imediatamente o inicializador
(se tiver um) ou lança uma exceção.
Às vezes você tem algum estado que é inicializado preguiçosamente
onde `late` pode ser uma boa opção,
mas você também precisa ser capaz de *dizer* se a inicialização já aconteceu.

Embora você possa detectar a inicialização armazenando o estado em uma variável `late`
e tendo um campo booleano separado
que rastreia se a variável foi definida,
isso é redundante porque o Dart *internamente*
mantém o status inicializado da variável `late`.
Em vez disso, geralmente é mais claro tornar a variável não-`late` e anulável.
Então você pode ver se a variável foi inicializada
verificando se é `null`.

Claro, se `null` é um valor inicializado válido para a variável,
então provavelmente faz sentido ter um campo booleano separado.


### CONSIDERE a promoção de tipo ou padrões de verificação nula para usar tipos anuláveis {:#consider-type-promotion-or-null-check-patterns-for-using-nullable-types}

Verificar se uma variável anulável não é igual a `null` promove a variável
para um tipo não anulável. Isso permite que você acesse membros na variável e a passe
para funções que esperam um tipo não anulável.

A promoção de tipo só é suportada, no entanto, para variáveis locais, parâmetros e
campos finais privados. Valores que estão abertos à manipulação
[não podem ser promovidos por tipo][can't be type promoted].

Declarar membros [privados][private] e [finais][final], como geralmente recomendamos, é muitas vezes
suficiente para contornar essas limitações. Mas, nem sempre é uma opção.

Um padrão para contornar as limitações de promoção de tipo é usar um
[padrão de verificação nula][null-check pattern]. Isso confirma simultaneamente o valor do membro
não é nulo e associa esse valor a uma nova variável não anulável do
mesmo tipo base.

<?code-excerpt "usage_good.dart (null-check-promo)"?>
```dart tag=good
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (this.response case var response?) {
      return 'Could not complete upload to ${response.url} '
          '(error code ${response.errorCode}): ${response.reason}.';
    }
    return 'Could not upload (no response).';
  }
}
```

Outra solução é atribuir o valor do campo
a uma variável local. Verificações nulas nessa variável serão promovidas,
então você pode tratá-la com segurança como não anulável.

<?code-excerpt "usage_good.dart (shadow-nullable-field)"?>
```dart tag=good
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    final response = this.response;
    if (response != null) {
      return 'Could not complete upload to ${response.url} '
          '(error code ${response.errorCode}): ${response.reason}.';
    }
    return 'Could not upload (no response).';
  }
}
```

Tenha cuidado ao usar uma variável local. Se você precisar escrever de volta no campo,
certifique-se de não escrever de volta na variável local. (Tornar a
variável local [`final`][`final`] pode evitar tais erros.) Além disso, se o campo puder
mudar enquanto o local ainda estiver em escopo, o local poderá ter um
valor obsoleto.

Às vezes, é melhor simplesmente [usar `!`][use `!`] no campo.
Em alguns casos, no entanto, usar uma variável local ou um padrão de verificação nula
pode ser mais limpo e seguro do que usar `!` toda vez que você precisar tratar o valor
como não-nulo:

<?code-excerpt "usage_bad.dart (shadow-nullable-field)" replace="/!\./[!!!]./g"?>
```dart tag=bad
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (response != null) {
      return 'Could not complete upload to ${response[!!!].url} '
          '(error code ${response[!!!].errorCode}): ${response[!!!].reason}.';
    }

    return 'Could not upload (no response).';
  }
}
```

[can't be type promoted]: /tools/non-promotion-reasons
[private]: /effective-dart/design#prefer-making-declarations-private
[final]: /effective-dart/design#prefer-making-fields-and-top-level-variables-final
[null-check pattern]: /language/pattern-types#null-check
[`final`]: /effective-dart/usage#do-follow-a-consistent-rule-for-var-and-final-on-local-variables
[use `!`]: /null-safety/understanding-null-safety#not-null-assertion-operator

## Strings {:#strings}

Aqui estão algumas práticas recomendadas para ter em mente ao compor strings no Dart.

### FAÇA use strings adjacentes para concatenar strings literais {:#do-use-adjacent-strings-to-concatenate-string-literals}

{% render 'linter-rule-mention.md', rules:'prefer_adjacent_string_concatenation' %}

Se você tem duas strings literais — não valores, mas a forma literal
real entre aspas — você não precisa usar `+` para concatená-las. Assim como em C e
C++, simplesmente colocá-las lado a lado faz isso. Esta é uma boa maneira de fazer
uma única string longa que não cabe em uma linha.

<?code-excerpt "usage_good.dart (adjacent-strings-literals)"?>
```dart tag=good
raiseAlarm(
  'ERROR: Parts of the spaceship are on fire. Other '
  'parts are overrun by martians. Unclear which are which.',
);
```

<?code-excerpt "usage_bad.dart (adjacent-strings-literals)"?>
```dart tag=bad
raiseAlarm(
  'ERROR: Parts of the spaceship are on fire. Other ' +
      'parts are overrun by martians. Unclear which are which.',
);
```

### PREFIRA usar interpolação para compor strings e valores {:#prefer-using-interpolation-to-compose-strings-and-values}

{% render 'linter-rule-mention.md', rules:'prefer_interpolation_to_compose_strings' %}

Se você está vindo de outras linguagens, você está acostumado a usar longas cadeias de `+`
para construir uma string a partir de literais e outros valores. Isso funciona no Dart, mas
é quase sempre mais limpo e curto usar a interpolação:

<?code-excerpt "usage_good.dart (string-interpolation)"?>
```dart tag=good
'Hello, $name! You are ${year - birth} years old.';
```

<?code-excerpt "usage_bad.dart (string-interpolation)"?>
```dart tag=bad
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
```

Note que esta diretriz se aplica à combinação de *múltiplos* literais e valores.
Não há problema em usar `.toString()` ao converter apenas um único objeto para uma string.

### EVITE usar chaves na interpolação quando não necessário {:#avoid-using-curly-braces-in-interpolation-when-not-needed}

{% render 'linter-rule-mention.md', rules:'unnecessary_brace_in_string_interps' %}

Se você está interpolando um identificador simples não imediatamente seguido por mais
texto alfanumérico, o `{}` deve ser omitido.

<?code-excerpt "usage_good.dart (string-interpolation-avoid-curly)"?>
```dart tag=good
var greeting = 'Hi, $name! I love your ${decade}s costume.';
```

<?code-excerpt "usage_bad.dart (string-interpolation-avoid-curly)"?>
```dart tag=bad
var greeting = 'Hi, ${name}! I love your ${decade}s costume.';
```

## Coleções {:#collections}

Pronto para uso, o Dart suporta quatro tipos de coleção: listas, mapas, filas e conjuntos.
As seguintes práticas recomendadas se aplicam a coleções.

### FAÇA use literais de coleção quando possível {:#do-use-collection-literals-when-possible}

{% render 'linter-rule-mention.md', rules:'prefer_collection_literals' %}

O Dart tem três tipos de coleção principais: List (Lista), Map (Mapa) e Set (Conjunto). As classes Map e Set
têm construtores não nomeados como a maioria das classes. Mas porque estas
coleções são usadas com tanta frequência, o Dart tem uma sintaxe integrada mais agradável para criar
elas:

<?code-excerpt "usage_good.dart (collection-literals)"?>
```dart tag=good
var points = <Point>[];
var addresses = <String, Address>{};
var counts = <int>{};
```

<?code-excerpt "usage_bad.dart (collection-literals)"?>
```dart tag=bad
var addresses = Map<String, Address>();
var counts = Set<int>();
```

Observe que esta diretriz não se aplica aos construtores *nomeados* para essas
classes. `List.from()`, `Map.fromIterable()` e similares têm suas utilidades.
(A classe List também tem um construtor não nomeado, mas é proibido no Dart
com segurança nula.)

Literais de coleção são particularmente poderosos no Dart
porque eles dão acesso ao [operador de propagação][spread]
para incluir o conteúdo de outras coleções,
e [`if` e `for`][control] para realizar o fluxo de controle enquanto
constrói o conteúdo:

[spread]: /language/collections#spread-operators
[control]: /language/collections#control-flow-operators

<?code-excerpt "usage_good.dart (spread-etc)"?>
```dart tag=good
var arguments = [
  ...options,
  command,
  ...?modeFlags,
  for (var path in filePaths)
    if (path.endsWith('.dart')) path.replaceAll('.dart', '.js'),
];
```

<?code-excerpt "usage_bad.dart (spread-etc)"?>
```dart tag=bad
var arguments = <String>[];
arguments.addAll(options);
arguments.add(command);
if (modeFlags != null) arguments.addAll(modeFlags);
arguments.addAll(
  filePaths
      .where((path) => path.endsWith('.dart'))
      .map((path) => path.replaceAll('.dart', '.js')),
);
```


### NÃO use `.length` para ver se uma coleção está vazia {:#dont-use-length-to-see-if-a-collection-is-empty}

{% render 'linter-rule-mention.md', rules:'prefer_is_empty, prefer_is_not_empty' %}

O contrato [Iterable][iterable] não exige que uma coleção saiba seu comprimento ou
seja capaz de fornecê-lo em tempo constante. Chamar `.length` apenas para ver se a
coleção contém *algo* pode ser dolorosamente lento.

[iterable]: {{site.dart-api}}/dart-core/Iterable-class.html

Em vez disso, existem getters mais rápidos e legíveis: `.isEmpty` e
`.isNotEmpty`. Use aquele que não exige que você negue o resultado.

<?code-excerpt "usage_good.dart (dont-use-length)"?>
```dart tag=good
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
```

<?code-excerpt "usage_bad.dart (dont-use-length)"?>
```dart tag=bad
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
```


### EVITE usar `Iterable.forEach()` com um literal de função {:#avoid-using-iterable-foreach-with-a-function-literal}

{% render 'linter-rule-mention.md', rules:'avoid_function_literals_in_foreach_calls' %}

As funções `forEach()` são amplamente usadas em JavaScript porque o built in
loop `for-in` não faz o que você geralmente quer. No Dart, se você quer iterar
sobre uma sequência, a maneira idiomática de fazer isso é usando um loop.

<?code-excerpt "usage_good.dart (avoid-for-each)"?>
```dart tag=good
for (final person in people) {
  ...
}
```

<?code-excerpt "usage_bad.dart (avoid-for-each)"?>
```dart tag=bad
people.forEach((person) {
  ...
});
```

Note que esta diretriz diz especificamente "função *literal*". Se você quer
invocar alguma função *já existente* em cada elemento, `forEach()` está ok.

<?code-excerpt "usage_good.dart (forEach-over-func)"?>
```dart tag=good
people.forEach(print);
```

Observe também que está sempre OK usar `Map.forEach()`. Mapas não são iteráveis, então
esta diretriz não se aplica.

### NÃO use `List.from()` a menos que você pretenda mudar o tipo do resultado {:#dont-use-list-from-unless-you-intend-to-change-the-type-of-the-result}

Dado um Iterable, há duas maneiras óbvias de produzir uma nova Lista que
contém os mesmos elementos:

<?code-excerpt "../../test/effective_dart_test.dart (list-from-1)"?>
```dart
var copy1 = iterable.toList();
var copy2 = List.from(iterable);
```

A diferença óbvia é que a primeira é mais curta. A diferença *importante*
é que a primeira preserva o argumento de tipo do
objeto original:

<?code-excerpt "../../test/effective_dart_test.dart (list-from-good)"?>
```dart tag=good
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<int>":
print(iterable.toList().runtimeType);
```

<?code-excerpt "../../test/effective_dart_test.dart (list-from-bad)"?>
```dart tag=bad
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<dynamic>":
print(List.from(iterable).runtimeType);
```

Se você *quer* mudar o tipo, então chamar `List.from()` é útil:

<?code-excerpt "../../test/effective_dart_test.dart (list-from-3)"?>
```dart tag=good
var numbers = [1, 2.3, 4]; // List<num>.
numbers.removeAt(1); // Now it only contains integers.
var ints = List<int>.from(numbers);
```

Mas se seu objetivo é apenas copiar o iterável e preservar seu tipo original, ou
você não se importa com o tipo, então use `toList()`.


### FAÇA use `whereType()` para filtrar uma coleção por tipo {:#do-use-wheretype-to-filter-a-collection-by-type}

{% render 'linter-rule-mention.md', rules:'prefer_iterable_whereType' %}

Digamos que você tenha uma lista contendo uma mistura de objetos, e você quer obter
apenas os inteiros dela. Você pode usar `where()` assim:

<?code-excerpt "usage_bad.dart (where-type)"?>
```dart tag=bad
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int);
```

Isso é verboso, mas, pior, retorna um iterável cujo tipo provavelmente não é
o que você quer. No exemplo aqui, ele retorna um `Iterable<Object>` mesmo que
você provavelmente queira um `Iterable<int>`, já que esse é o tipo para o qual você está filtrando.

Às vezes você vê código que "corrige" o erro acima adicionando `cast()`:

<?code-excerpt "usage_bad.dart (where-type-2)"?>
```dart tag=bad
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int).cast<int>();
```

Isso é verboso e faz com que dois wrappers sejam criados, com duas camadas de
indireção e verificação de tempo de execução redundante. Felizmente, a biblioteca principal tem
o método [`whereType()`][where-type] para este caso de uso exato:

[where-type]: {{site.dart-api}}/dart-core/Iterable/whereType.html

<?code-excerpt "../../test/effective_dart_test.dart (where-type)"?>
```dart tag=good
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.whereType<int>();
```

Usar `whereType()` é conciso, produz um [Iterable][iterable] do tipo desejado,
e não tem níveis desnecessários de envolvimento.


### NÃO use `cast()` quando uma operação próxima o fará {:#dont-use-cast-when-a-nearby-operation-will-do}

Frequentemente, quando você está lidando com um iterável ou stream, você realiza várias
transformações sobre ele. No final, você quer produzir um objeto com um determinado
argumento de tipo. Em vez de adicionar uma chamada para `cast()`, veja se uma das
transformações existentes pode mudar o tipo.

Se você já está chamando `toList()`, substitua isso por uma chamada para
[`List<T>.from()`][list-from] onde `T` é o tipo da lista resultante que você quer.

[list-from]: {{site.dart-api}}/dart-core/List/List.from.html

<?code-excerpt "usage_good.dart (cast-list)"?>
```dart tag=good
var stuff = <dynamic>[1, 2];
var ints = List<int>.from(stuff);
```

<?code-excerpt "usage_bad.dart (cast-list)"?>
```dart tag=bad
var stuff = <dynamic>[1, 2];
var ints = stuff.toList().cast<int>();
```

Se você está chamando `map()`, dê a ele um argumento de tipo explícito para que ele
produza um iterável do tipo desejado. A inferência de tipo geralmente escolhe o correto
tipo para você com base na função que você passa para `map()`, mas às vezes você precisa
ser explícito.

<?code-excerpt "usage_good.dart (cast-map)" replace="/\(n as int\)/n/g"?>
```dart tag=good
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map<double>((n) => n * 2);
```

<?code-excerpt "usage_bad.dart (cast-map)" replace="/\(n as int\)/n/g"?>
```dart tag=bad
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map((n) => n * 2).cast<double>();
```


### EVITE usar `cast()` {:#avoid-using-cast}

Esta é a generalização mais branda da regra anterior. Às vezes não há
operação próxima que você pode usar para corrigir o tipo de algum objeto. Mesmo assim, quando
possível, evite usar `cast()` para "mudar" o tipo de uma coleção.

Prefira qualquer uma destas opções em vez disso:

*   **Crie com o tipo certo.** Mude o código onde a coleção é
    criada pela primeira vez para que ela tenha o tipo certo.

*   **Converta os elementos no acesso.** Se você iterar imediatamente sobre a
    coleção, converta cada elemento dentro da iteração.

*   **Converta ansiosamente usando `List.from()`.** Se você eventualmente acessar a maior parte
    dos elementos na coleção, e você não precisa que o objeto seja apoiado
    pelo objeto original, converta-o usando `List.from()`.

    O método `cast()` retorna uma coleção preguiçosa que verifica o tipo de elemento
    em *toda operação*. Se você executar apenas algumas operações em apenas alguns
    elementos, essa preguiça pode ser boa. Mas em muitos casos, a sobrecarga de preguiçoso
    validação e de encapsulamento supera os benefícios.

Aqui está um exemplo de **criá-lo com o tipo certo:**

<?code-excerpt "usage_good.dart (cast-at-create)"?>
```dart tag=good
List<int> singletonList(int value) {
  var list = <int>[];
  list.add(value);
  return list;
}
```

<?code-excerpt "usage_bad.dart (cast-at-create)"?>
```dart tag=bad
List<int> singletonList(int value) {
  var list = []; // List<dynamic>.
  list.add(value);
  return list.cast<int>();
}
```

Aqui está **convertendo cada elemento no acesso:**

<?code-excerpt "usage_good.dart (cast-iterate)" replace="/\(n as int\)/[!$&!]/g"?>
```dart tag=good
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (final n in objects) {
    if ([!(n as int)!].isEven) print(n);
  }
}
```

<?code-excerpt "usage_bad.dart (cast-iterate)"?>
```dart tag=bad
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (final n in objects.cast<int>()) {
    if (n.isEven) print(n);
  }
}
```

Aqui está **convertendo ansiosamente usando `List.from()`:**

<?code-excerpt "usage_good.dart (cast-from)"?>
```dart tag=good
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = List<int>.from(objects);
  ints.sort();
  return ints[ints.length ~/ 2];
}
```

<?code-excerpt "usage_bad.dart (cast-from)"?>
```dart tag=bad
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = objects.cast<int>();
  ints.sort();
  return ints[ints.length ~/ 2];
}
```

Essas alternativas nem sempre funcionam, é claro, e às vezes `cast()` é a
resposta correta. Mas considere esse método um pouco arriscado e indesejável—ele
pode ser lento e pode falhar em tempo de execução se você não tomar cuidado.


## Funções {:#functions}

Em Dart, até mesmo funções são objetos. Aqui estão algumas melhores práticas
envolvendo funções.


### USE uma declaração de função para vincular uma função a um nome {:#do-use-a-function-declaration-to-bind-a-function-to-a-name}

{% render 'linter-rule-mention.md', rules:'prefer_function_declarations_over_variables' %}

Linguagens modernas perceberam o quão úteis são funções locais aninhadas e
*closures* (fechamentos). É comum ter uma função definida dentro de outra. Em muitos
casos, essa função é usada como um *callback* (retorno de chamada) imediatamente e
não precisa de um nome. Uma expressão de função é ótima para isso.

Mas, se você precisar dar um nome a ela, use uma declaração de função em vez de
vincular um *lambda* a uma variável.

<?code-excerpt "usage_good.dart (func-decl)"?>
```dart tag=good
void main() {
  void localFunction() {
    ...
  }
}
```

<?code-excerpt "usage_bad.dart (func-decl)"?>
```dart tag=bad
void main() {
  var localFunction = () {
    ...
  };
}
```

### NÃO crie um *lambda* quando um *tear-off* (desmembramento) resolver {:#dont-create-a-lambda-when-a-tear-off-will-do}

{% render 'linter-rule-mention.md', rules:'unnecessary_lambdas' %}

Quando você se refere a uma função, método ou construtor nomeado sem parênteses,
Dart cria um *tear-off*. Este é um *closure* que recebe os mesmos parâmetros da
função e invoca a função subjacente quando você a chama. Se seu código precisa
de um *closure* que invoca uma função nomeada com os mesmos parâmetros que o
*closure* aceita, não envolva a chamada em um *lambda*.
Use um *tear-off*.

<?code-excerpt "usage_good.dart (use-tear-off)"?>
```dart tag=good
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();

// Function:
charCodes.forEach(print);

// Method:
charCodes.forEach(buffer.write);

// Named constructor:
var strings = charCodes.map(String.fromCharCode);

// Unnamed constructor:
var buffers = charCodes.map(StringBuffer.new);
```

<?code-excerpt "usage_bad.dart (use-tear-off)"?>
```dart tag=bad
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();

// Function:
charCodes.forEach((code) {
  print(code);
});

// Method:
charCodes.forEach((code) {
  buffer.write(code);
});

// Named constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Unnamed constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```


## Variáveis {:#variables}

As seguintes práticas recomendadas descrevem como usar melhor as variáveis em Dart.

### USE uma regra consistente para `var` e `final` em variáveis locais {:#do-follow-a-consistent-rule-for-var-and-final-on-local-variables}

A maioria das variáveis locais não deve ter anotações de tipo e deve ser
declarada usando apenas `var` ou `final`. Existem duas regras amplamente
utilizadas para quando usar um ou outro:

*   Use `final` para variáveis locais que não são reatribuídas e `var` para
    aquelas que são.

*   Use `var` para todas as variáveis locais, mesmo aquelas que não são
    reatribuídas. Nunca use `final` para locais. (Usar `final` para campos e
    variáveis de nível superior ainda é incentivado, é claro.)

Qualquer regra é aceitável, mas escolha *uma* e aplique-a consistentemente em
todo o seu código. Dessa forma, quando um leitor vir `var`, ele saberá se isso
significa que a variável será atribuída mais tarde na função.


### EVITE armazenar o que você pode calcular {:#avoid-storing-what-you-can-calculate}

Ao projetar uma classe, você geralmente deseja expor várias visões para o mesmo
estado (state) subjacente. Muitas vezes, você vê código que calcula todas essas
visões no construtor e as armazena:

<?code-excerpt "usage_bad.dart (calc-vs-store1)"?>
```dart tag=bad
class Circle {
  double radius;
  double area;
  double circumference;

  Circle(double radius)
    : radius = radius,
      area = pi * radius * radius,
      circumference = pi * 2.0 * radius;
}
```

Este código tem dois problemas. Primeiro, provavelmente está desperdiçando
memória. A área e a circunferência, estritamente falando, são *caches* (memórias
de acesso rápido). Elas são cálculos armazenados que poderíamos recalcular a partir
de outros dados que já temos. Elas estão trocando aumento de memória por uso
reduzido de CPU. Sabemos que temos um problema de desempenho que justifica essa troca?

Pior ainda, o código está *errado*. O problema com os caches é a *invalidação*
— como você sabe quando o cache está desatualizado e precisa ser recalculado?
Aqui, nunca fazemos isso, mesmo que `radius` seja mutável. Você pode atribuir um
valor diferente e a `area` e `circumference` manterão seus valores anteriores, agora incorretos.

Para lidar corretamente com a invalidação do cache, precisaríamos fazer isso:

<?code-excerpt "usage_bad.dart (calc-vs-store2)"?>
```dart tag=bad
class Circle {
  double _radius;
  double get radius => _radius;
  set radius(double value) {
    _radius = value;
    _recalculate();
  }

  double _area = 0.0;
  double get area => _area;

  double _circumference = 0.0;
  double get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
```

Isso é uma quantidade enorme de código para escrever, manter, depurar e ler. Em
vez disso, sua primeira implementação deve ser:

<?code-excerpt "usage_good.dart (calc-vs-store)"?>
```dart tag=good
class Circle {
  double radius;

  Circle(this.radius);

  double get area => pi * radius * radius;
  double get circumference => pi * 2.0 * radius;
}
```

Este código é mais curto, usa menos memória e é menos propenso a erros. Ele
armazena a quantidade mínima de dados necessária para representar o círculo. Não
há campos para ficarem dessincronizados porque existe apenas uma única fonte de verdade.

Em alguns casos, você pode precisar armazenar em cache o resultado de um cálculo
lento, mas faça isso somente depois de saber que tem um problema de desempenho,
faça-o com cuidado e deixe um comentário explicando a otimização.


## Membros {:#members}

Em Dart, os objetos têm membros que podem ser funções (métodos) ou dados
(variáveis de instância). As seguintes práticas recomendadas se aplicam aos membros de um objeto.

### NÃO envolva um campo em um *getter* e *setter* desnecessariamente {:#dont-wrap-a-field-in-a-getter-and-setter-unnecessarily}

{% render 'linter-rule-mention.md', rules:'unnecessary_getters_setters' %}

Em Java e C#, é comum ocultar todos os campos atrás de *getters* e *setters*
(ou propriedades em C#), mesmo que a implementação apenas encaminhe para o
campo. Dessa forma, se você precisar fazer mais trabalho nesses membros, poderá
fazer isso sem precisar tocar nos locais de chamada. Isso ocorre porque chamar um
método *getter* é diferente de acessar um campo em Java, e acessar uma
propriedade não é binariamente compatível com o acesso a um campo bruto em C#.

Dart não tem essa limitação. Campos e *getters/setters* são completamente
indistinguíveis. Você pode expor um campo em uma classe e, posteriormente,
envolvê-lo em um *getter* e um *setter* sem ter que tocar em nenhum código que use esse campo.

<?code-excerpt "usage_good.dart (dont-wrap-field)"?>
```dart tag=good
class Box {
  Object? contents;
}
```

<?code-excerpt "usage_bad.dart (dont-wrap-field)"?>
```dart tag=bad
class Box {
  Object? _contents;
  Object? get contents => _contents;
  set contents(Object? value) {
    _contents = value;
  }
}
```


### PREFIRA usar um campo `final` para criar uma propriedade somente leitura {:#prefer-using-a-final-field-to-make-a-read-only-property}

Se você tiver um campo que o código externo deve poder ver, mas não atribuir,
uma solução simples que funciona em muitos casos é simplesmente marcá-lo como `final`.

<?code-excerpt "usage_good.dart (final)"?>
```dart tag=good
class Box {
  final contents = [];
}
```

<?code-excerpt "usage_bad.dart (final)"?>
```dart tag=bad
class Box {
  Object? _contents;
  Object? get contents => _contents;
}
```

Claro, se você precisar atribuir internamente ao campo fora do construtor, pode
ser necessário fazer o padrão "campo privado, *getter* público", mas não faça
isso até que precise.


### CONSIDERE usar `=>` para membros simples {:#consider-using-for-simple-members}

{% render 'linter-rule-mention.md', rules:'prefer_expression_function_bodies' %}

Além de usar `=>` para expressões de função, o Dart também permite que você
defina membros com ele. Esse estilo é adequado para membros simples que apenas
calculam e retornam um valor.

<?code-excerpt "usage_good.dart (use-arrow)"?>
```dart tag=good
double get area => (right - left) * (bottom - top);

String capitalize(String name) =>
    '${name[0].toUpperCase()}${name.substring(1)}';
```

Pessoas que *escrevem* código parecem amar `=>`, mas é muito fácil abusar dele
e acabar com um código que é difícil de *ler*. Se sua declaração tiver mais de
algumas linhas ou contiver expressões profundamente aninhadas — *cascades* (cascatas)
e operadores condicionais são os culpados comuns — faça um favor a você e a todos
que tiverem que ler seu código e use um corpo de bloco e algumas declarações.

<?code-excerpt "usage_good.dart (arrow-long)"?>
```dart tag=good
Treasure? openChest(Chest chest, Point where) {
  if (_opened.containsKey(chest)) return null;

  var treasure = Treasure(where);
  treasure.addAll(chest.contents);
  _opened[chest] = treasure;
  return treasure;
}
```

<?code-excerpt "usage_bad.dart (arrow-long)"?>
```dart tag=bad
Treasure? openChest(Chest chest, Point where) => _opened.containsKey(chest)
    ? null
    : _opened[chest] = (Treasure(where)..addAll(chest.contents));
```

Você também pode usar `=>` em membros que não retornam um valor. Isso é
idiomático quando um *setter* é pequeno e tem um *getter* correspondente que usa `=>`.

<?code-excerpt "usage_good.dart (arrow-setter)"?>
```dart tag=good
num get x => center.x;
set x(num value) => center = Point(value, center.y);
```


### NÃO use `this.` exceto para redirecionar para um construtor nomeado ou para evitar sombreamento {:#dont-use-this-when-not-needed-to-avoid-shadowing}

{% render 'linter-rule-mention.md', rules:'unnecessary_this' %}

JavaScript requer um `this.` explícito para se referir aos membros do objeto cujo
método está sendo executado no momento, mas Dart - como C++, Java e C# - não
tem essa limitação.

Existem apenas duas vezes em que você precisa usar `this.`. Uma é quando uma
variável local com o mesmo nome sombreia o membro que você deseja acessar:

<?code-excerpt "usage_bad.dart (this-dot)"?>
```dart tag=bad
class Box {
  Object? value;

  void clear() {
    this.update(null);
  }

  void update(Object? value) {
    this.value = value;
  }
}
```

<?code-excerpt "usage_good.dart (this-dot)"?>
```dart tag=good
class Box {
  Object? value;

  void clear() {
    update(null);
  }

  void update(Object? value) {
    this.value = value;
  }
}
```

A outra vez para usar `this.` é ao redirecionar para um construtor nomeado:

<?code-excerpt "usage_bad.dart (this-dot-constructor)"?>
```dart tag=bad
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // This won't parse or compile!
  // ShadeOfGray.alsoBlack() : black();
}
```

<?code-excerpt "usage_good.dart (this-dot-constructor)"?>
```dart tag=good
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // But now it will!
  ShadeOfGray.alsoBlack() : this.black();
}
```

Observe que os parâmetros do construtor nunca sombreiam campos em listas de
inicialização do construtor:

<?code-excerpt "usage_good.dart (param-dont-shadow-field-ctr-init)"?>
```dart tag=good
class Box extends BaseBox {
  Object? value;

  Box(Object? value) : value = value, super(value);
}
```

Isso parece surpreendente, mas funciona como você deseja. Felizmente, códigos
como este são relativamente raros graças aos *formals* de inicialização e inicializadores *super*.


### INICIALIZE os campos em sua declaração quando possível {:#do-initialize-fields-at-their-declaration-when-possible}

Se um campo não depende de nenhum parâmetro do construtor, ele pode e deve ser
inicializado em sua declaração. Isso leva menos código e evita duplicação
quando a classe tem vários construtores.

<?code-excerpt "usage_bad.dart (field-init-at-decl)"?>
```dart tag=bad
class ProfileMark {
  final String name;
  final DateTime start;

  ProfileMark(this.name) : start = DateTime.now();
  ProfileMark.unnamed() : name = '', start = DateTime.now();
}
```

<?code-excerpt "usage_good.dart (field-init-at-decl)"?>
```dart tag=good
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

Alguns campos não podem ser inicializados em suas declarações porque precisam
referenciar `this` - para usar outros campos ou chamar métodos, por exemplo.
No entanto, se o campo for marcado como `late` (atrasado), o inicializador *pode* acessar `this`.

Claro, se um campo depender dos parâmetros do construtor ou for inicializado
de forma diferente por diferentes construtores, esta diretriz não se aplica.


## Construtores {:#constructors}

As seguintes práticas recomendadas se aplicam à declaração de construtores para uma classe.

### USE *formals* de inicialização quando possível {:#do-use-initializing-formals-when-possible}

{% render 'linter-rule-mention.md', rules:'prefer_initializing_formals' %}

Muitos campos são inicializados diretamente a partir de um parâmetro de construtor, como:

<?code-excerpt "usage_bad.dart (field-init-as-param)"?>
```dart tag=bad
class Point {
  double x, y;
  Point(double x, double y) : x = x, y = y;
}
```

Precisamos digitar `x` _quatro_ vezes aqui para definir um campo. Podemos fazer melhor:

<?code-excerpt "usage_good.dart (field-init-as-param)"?>
```dart tag=good
class Point {
  double x, y;
  Point(this.x, this.y);
}
```

Esta sintaxe `this.` antes de um parâmetro de construtor é chamada de "formal de
inicialização". Você nem sempre pode se aproveitar disso. Às vezes, você deseja
ter um parâmetro nomeado cujo nome não corresponda ao nome do campo que você
está inicializando. Mas quando você *pode* usar *formals* de inicialização, você *deve*.


### NÃO use `late` quando uma lista de inicialização do construtor resolver {:#dont-use-late-when-a-constructor-initializer-list-will-do}

Dart exige que você inicialize campos não nulos antes que eles possam ser lidos.
Como os campos podem ser lidos dentro do corpo do construtor, isso significa
que você recebe um erro se não inicializar um campo não nulo antes que o corpo
seja executado.

Você pode fazer esse erro desaparecer marcando o campo como `late`. Isso
transforma o erro em tempo de compilação em um erro em *tempo de execução* se
você acessar o campo antes que ele seja inicializado. É disso que você precisa
em alguns casos, mas muitas vezes a correção certa é inicializar o campo na lista de inicialização do construtor:

<?code-excerpt "usage_good.dart (late-init-list)"?>
```dart tag=good
class Point {
  double x, y;
  Point.polar(double theta, double radius)
    : x = cos(theta) * radius,
      y = sin(theta) * radius;
}
```

<?code-excerpt "usage_bad.dart (late-init-list)"?>
```dart tag=bad
class Point {
  late double x, y;
  Point.polar(double theta, double radius) {
    x = cos(theta) * radius;
    y = sin(theta) * radius;
  }
}
```


A lista de inicialização fornece acesso aos parâmetros do construtor e permite
inicializar os campos antes que eles possam ser lidos. Portanto, se for
possível usar uma lista de inicialização, isso é melhor do que tornar o campo
`late` e perder alguma segurança estática e desempenho.


### USE `;` em vez de `{}` para corpos de construtor vazios {:#do-use-instead-of-for-empty-constructor-bodies}

{% render 'linter-rule-mention.md', rules:'empty_constructor_bodies' %}

Em Dart, um construtor com um corpo vazio pode ser finalizado com apenas um
ponto e vírgula. (Na verdade, é necessário para construtores `const`).

<?code-excerpt "usage_good.dart (semicolon-for-empty-body)"?>
```dart tag=good
class Point {
  double x, y;
  Point(this.x, this.y);
}
```

<?code-excerpt "usage_bad.dart (semicolon-for-empty-body)"?>
```dart tag=bad
class Point {
  double x, y;
  Point(this.x, this.y) {}
}
```

### NÃO use `new` {:#dont-use-new}

{% render 'linter-rule-mention.md', rules:'unnecessary_new' %}

A palavra-chave `new` é opcional ao chamar um construtor. Seu significado não
é claro porque os construtores de fábrica significam que uma invocação `new`
pode não retornar um novo objeto.

A linguagem ainda permite `new`, mas considere-a obsoleta e evite usá-la em seu
código.

<?code-excerpt "usage_good.dart (no-new)"?>
```dart tag=good
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(child: Text('Increment')),
      Text('Click!'),
    ],
  );
}
```

<?code-excerpt "usage_bad.dart (no-new)" replace="/new/[!$&!]/g"?>
```dart tag=bad
Widget build(BuildContext context) {
  return [!new!] Row(
    children: [
      [!new!] RaisedButton(child: [!new!] Text('Increment')),
      [!new!] Text('Click!'),
    ],
  );
}
```


### NÃO use `const` de forma redundante {:#dont-use-const-redundantly}

{% render 'linter-rule-mention.md', rules:'unnecessary_const' %}

Em contextos onde uma expressão *deve* ser constante, a palavra-chave `const` é
implícita, não precisa ser escrita e não deve ser. Esses contextos são
qualquer expressão dentro de:

* Um literal de coleção `const`.
* Uma chamada de construtor `const`.
* Uma anotação de metadados.
* O inicializador para uma declaração de variável `const`.
* Uma expressão de `switch case` - a parte logo após `case` antes do `:`,
  não o corpo do caso.

(Valores padrão não estão incluídos nesta lista porque futuras versões do Dart
podem oferecer suporte a valores padrão não constantes.)

Basicamente, em qualquer lugar onde seria um erro escrever `new` em vez de
`const`, Dart permite que você omita o `const`.

<?code-excerpt "usage_good.dart (no-const)"?>
```dart tag=good
const primaryColors = [
  Color('red', [255, 0, 0]),
  Color('green', [0, 255, 0]),
  Color('blue', [0, 0, 255]),
];
```

<?code-excerpt "usage_bad.dart (no-const)" replace="/ (const)/ [!$1!]/g"?>
```dart tag=bad
const primaryColors = [!const!] [
  [!const!] Color('red', [!const!] [255, 0, 0]),
  [!const!] Color('green', [!const!] [0, 255, 0]),
  [!const!] Color('blue', [!const!] [0, 0, 255]),
];
```

## Tratamento de Erros {:#error-handling}

Dart usa exceções quando ocorre um erro em seu programa. As seguintes práticas
recomendadas se aplicam à captura e lançamento de exceções.

### EVITE capturas sem cláusulas `on` {:#avoid-catches-without-on-clauses}

{% render 'linter-rule-mention.md', rules:'avoid_catches_without_on_clauses' %}

Uma cláusula `catch` sem qualificador `on` captura *qualquer coisa* lançada pelo
código no bloco `try`. O [tratamento de exceção Pokémon][pokemon] muito
provavelmente não é o que você deseja. Seu código lida corretamente com
[StackOverflowError][StackOverflowError] ou [OutOfMemoryError][OutOfMemoryError]? Se você passar incorretamente o
argumento errado para um método naquele bloco `try`, deseja que seu depurador
aponte para o erro ou prefere que aquele útil [ArgumentError][ArgumentError] seja
engolido? Você quer que quaisquer declarações `assert()` dentro desse código
desapareçam efetivamente, já que você está capturando os [AssertionError][AssertionError]s lançados?

A resposta é provavelmente "não", caso em que você deve filtrar os tipos que
você captura. Na maioria dos casos, você deve ter uma cláusula `on` que o limite
aos tipos de falhas de tempo de execução dos quais você está ciente e está tratando corretamente.

Em casos raros, você pode querer capturar qualquer erro de tempo de execução.
Isso geralmente ocorre em código de *framework* ou de baixo nível que tenta
isolar um código de aplicativo arbitrário de causar problemas. Mesmo aqui,
geralmente é melhor capturar [Exception][Exception] do que capturar todos os tipos.
*Exception* é a classe base para todos os erros de *tempo de execução* e exclui erros que indicam bugs *programáticos* no código.


### NÃO descarte erros de capturas sem cláusulas `on` {:#dont-discard-errors-from-catches-without-on-clauses}

Se você realmente sentir que precisa capturar *tudo* que pode ser lançado de
uma região de código, *faça alguma coisa* com o que você captura. Registre-o,
exiba-o para o usuário ou relance-o, mas não o descarte silenciosamente.


### LANCE objetos que implementam `Error` apenas para erros programáticos {:#do-throw-objects-that-implement-error-only-for-programmatic-errors}

A classe [Error][Error] é a classe base para erros *programáticos*. Quando um objeto
desse tipo ou uma de suas subinterfaces como [ArgumentError][ArgumentError] é lançada, isso
significa que há um *bug* em seu código. Quando sua API deseja relatar a um
chamador que está sendo usada incorretamente, lançar um `Error` envia esse sinal claramente.

Por outro lado, se a exceção for algum tipo de falha de tempo de execução que
não indica um bug no código, lançar um `Error` é enganoso. Em vez disso, lance
uma das classes de *Exception* principais ou algum outro tipo.


### NÃO capture explicitamente `Error` ou tipos que o implementam {:#dont-explicitly-catch-error-or-types-that-implement-it}

{% render 'linter-rule-mention.md', rules:'avoid_catching_errors' %}

Isso segue o que foi dito acima. Como um *Error* indica um bug em seu código,
ele deve desenrolar toda a pilha de chamadas, interromper o programa e imprimir
um rastreamento de pilha para que você possa localizar e corrigir o bug.

Capturar erros desses tipos interrompe esse processo e mascara o bug. Em vez
de *adicionar* um código de tratamento de erros para lidar com essa exceção
posteriormente, volte e corrija o código que está fazendo com que ela seja lançada em primeiro lugar.


### USE `rethrow` para relançar uma exceção capturada {:#do-use-rethrow-to-rethrow-a-caught-exception}

{% render 'linter-rule-mention.md', rules:'use_rethrow_when_possible' %}

Se você decidir relançar uma exceção, prefira usar a instrução `rethrow` em
vez de lançar o mesmo objeto de exceção usando `throw`. `rethrow` preserva o
rastreamento de pilha original da exceção. `throw`, por outro lado, redefine o
rastreamento de pilha para a última posição lançada.

<?code-excerpt "usage_bad.dart (rethrow)"?>
```dart tag=bad
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
```

<?code-excerpt "usage_good.dart (rethrow)" replace="/rethrow/[!$&!]/g"?>
```dart tag=good
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) [!rethrow!];
  handle(e);
}
```


## Assincronia {:#asynchrony}

Dart possui vários recursos de linguagem para oferecer suporte à programação
assíncrona. As seguintes práticas recomendadas se aplicam à codificação assíncrona.

### PREFIRA `async/await` em vez de usar *futures* (futuros) brutos {:#prefer-asyncawait-over-using-raw-futures}

O código assíncrono é notoriamente difícil de ler e depurar, mesmo ao usar uma
boa abstração como *futures*. A sintaxe `async`/`await` melhora a legibilidade e
permite que você use todas as estruturas de fluxo de controle do Dart em seu código assíncrono.

<?code-excerpt "usage_good.dart (async-await)" replace="/async|await/[!$&!]/g"?>
```dart tag=good
Future<int> countActivePlayers(String teamName) [!async!] {
  try {
    var team = [!await!] downloadTeam(teamName);
    if (team == null) return 0;

    var players = [!await!] team.roster;
    return players.where((player) => player.isActive).length;
  } on DownloadException catch (e, _) {
    log.error(e);
    return 0;
  }
}
```

<?code-excerpt "usage_bad.dart (async-await)"?>
```dart tag=bad
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName)
      .then((team) {
        if (team == null) return Future.value(0);

        return team.roster.then((players) {
          return players.where((player) => player.isActive).length;
        });
      })
      .onError<DownloadException>((e, _) {
        log.error(e);
        return 0;
      });
}
```

### NÃO use `async` quando ele não tiver nenhum efeito útil {:#dont-use-async-when-it-has-no-useful-effect}

É fácil criar o hábito de usar `async` em qualquer função que faça algo
relacionado à assincronia. Mas, em alguns casos, é estranho. Se você puder
omitir o `async` sem alterar o comportamento da função, faça-o.

<?code-excerpt "usage_good.dart (unnecessary-async)"?>
```dart tag=good
Future<int> fastestBranch(Future<int> left, Future<int> right) {
  return Future.any([left, right]);
}
```

<?code-excerpt "usage_bad.dart (unnecessary-async)"?>
```dart tag=bad
Future<int> fastestBranch(Future<int> left, Future<int> right) async {
  return Future.any([left, right]);
}
```

Casos em que `async` *é* útil incluem:

*   Você está usando `await`. (Este é o óbvio.)

*   Você está retornando um erro de forma assíncrona. `async` e então `throw` é
    mais curto do que `return Future.error(...)`.

*   Você está retornando um valor e deseja que ele seja implicitamente
    envolvido em um *future*. `async` é mais curto do que `Future.value(...)`.

<?code-excerpt "usage_good.dart (async)"?>
```dart tag=good
Future<void> usesAwait(Future<String> later) async {
  print(await later);
}

Future<void> asyncError() async {
  throw 'Error!';
}

Future<String> asyncValue() async => 'value';
```

### CONSIDERE usar métodos de ordem superior para transformar um *stream* (fluxo) {:#consider-using-higher-order-methods-to-transform-a-stream}

Isso é semelhante à sugestão acima sobre iteráveis. Os *streams* suportam muitos
dos mesmos métodos e também lidam com coisas como transmissão de erros,
fechamento, etc., corretamente.

### EVITE usar `Completer` diretamente {:#avoid-using-completer-directly}

Muitas pessoas novas na programação assíncrona desejam escrever um código que
produza um *future*. Os construtores em *Future* parecem não atender às suas
necessidades, então eles acabam encontrando a classe `Completer` e a usando.

<?code-excerpt "usage_bad.dart (avoid-completer)"?>
```dart tag=bad
Future<bool> fileContainsBear(String path) {
  var completer = Completer<bool>();

  File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
```

`Completer` é necessário para dois tipos de código de baixo nível: novas
primitivas assíncronas e interface com código assíncrono que não usa
*futures*. A maioria dos outros códigos deve usar `async/await` ou
[`Future.then()`][then], porque eles são mais claros e tornam o tratamento de erros mais fácil.

[then]: {{site.dart-api}}/dart-async/Future/then.html

<?code-excerpt "usage_good.dart (avoid-completer)"?>
```dart tag=good
Future<bool> fileContainsBear(String path) {
  return File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
```

<?code-excerpt "usage_good.dart (avoid-completer-alt)"?>
```dart tag=good
Future<bool> fileContainsBear(String path) async {
  var contents = await File(path).readAsString();
  return contents.contains('bear');
}
```


### TESTE para `Future<T>` ao desambiguar um `FutureOr<T>` cujo argumento de tipo pode ser `Object` {:#do-test-for-futuret-when-disambiguating-a-futureort-whose-type-argument-could-be-object}

Antes que você possa fazer algo útil com um `FutureOr<T>`, você normalmente
precisa fazer uma verificação `is` para ver se você tem um `Future<T>` ou um
`T` puro. Se o argumento do tipo for algum tipo específico como em
`FutureOr<int>`, não importa qual teste você use, `is int` ou `is Future<int>`.
Qualquer um funciona porque esses dois tipos são disjuntos.

No entanto, se o tipo de valor for `Object` ou um parâmetro de tipo que possivelmente
pode ser instanciado com `Object`, então os dois branches se sobrepõem. `Future<Object>`
por si só implementa `Object`, então `is Object` ou `is T` onde `T` é algum tipo
parâmetro que pode ser instanciado com `Object` retorna true mesmo quando o
objeto é um futuro. Em vez disso, teste explicitamente o caso `Future`:

<?code-excerpt "usage_good.dart (test-future-or)"?>
```dart  tag=good
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is Future<T>) {
    var result = await value;
    print(result);
    return result;
  } else {
    print(value);
    return value;
  }
}
```

<?code-excerpt "usage_bad.dart (test-future-or)"?>
```dart tag=bad
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is T) {
    print(value);
    return value;
  } else {
    var result = await value;
    print(result);
    return result;
  }
}
```

No exemplo ruim, se você passar um `Future<Object>`, ele o trata incorretamente
como um valor síncrono simples.

[pokemon]: https://blog.codinghorror.com/new-programming-jargon/
[Error]: {{site.dart-api}}/dart-core/Error-class.html
[StackOverflowError]: {{site.dart-api}}/dart-core/StackOverflowError-class.html
[OutOfMemoryError]: {{site.dart-api}}/dart-core/OutOfMemoryError-class.html
[ArgumentError]: {{site.dart-api}}/dart-core/ArgumentError-class.html
[AssertionError]: {{site.dart-api}}/dart-core/AssertionError-class.html
[Exception]: {{site.dart-api}}/dart-core/Exception-class.html
