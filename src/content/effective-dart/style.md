---
ia-translate: true
title: "Dart Efetivo: Estilo"
breadcrumb: Style
description: Regras de formatação e nomenclatura para código consistente e legível.
nextpage:
  url: /effective-dart/documentation
  title: Documentation
prevpage:
  url: /effective-dart
  title: Overview
---
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Uma parte surpreendentemente importante de um bom código é um bom estilo. Nomenclatura,
ordenação e formatação consistentes ajudam o código que *é* o mesmo a *parecer* o mesmo. Aproveita
a poderosa capacidade de reconhecimento de padrões que a maioria de nós tem em nossos
sistemas oculares. Se usarmos um estilo consistente em todo o ecossistema Dart,
isso facilita para todos nós aprendermos e contribuirmos com o código uns dos outros.

## Identificadores

Os identificadores vêm em três variações no Dart.

* Nomes `UpperCamelCase` capitalizam a primeira letra de cada palavra, incluindo
  a primeira.

* Nomes `lowerCamelCase` capitalizam a primeira letra de cada palavra, *exceto*
  a primeira, que é sempre minúscula, mesmo que seja um acrônimo.

* Nomes `lowercase_with_underscores` usam apenas letras minúsculas,
  mesmo para acrônimos, e separam palavras com `_`.

### DO name types using `UpperCamelCase`

{% render 'linter-rule-mention.md', rules:'camel_case_types' %}

Classes, tipos enum, typedefs e parâmetros de tipo devem capitalizar a primeira
letra de cada palavra (incluindo a primeira palavra) e não usar separadores.

<?code-excerpt "style_good.dart (type-names)"?>
```dart tag=good
class SliderMenu {
   ...
}

class HttpRequest {
   ...
}

typedef Predicate<T> = bool Function(T value);
```

Isso inclui até mesmo classes destinadas a serem usadas em anotações de metadados.

<?code-excerpt "style_good.dart (annotation-type-names)"?>
```dart tag=good
class Foo {
  const Foo([Object? arg]);
}

@Foo(anArg)
class A {
   ...
}

@Foo()
class B {
   ...
}
```

Se o construtor da classe de anotação não aceita parâmetros, você pode querer
criar uma constante `lowerCamelCase` separada para ela.

<?code-excerpt "style_good.dart (annotation-const)"?>
```dart tag=good
const foo = Foo();

@foo
class C {
   ...
}
```

### DO name extensions using `UpperCamelCase`

{% render 'linter-rule-mention.md', rules:'camel_case_extensions' %}

Como os tipos, [extensions][] devem capitalizar a primeira letra de cada palavra
(incluindo a primeira palavra)
e não usar separadores.

<?code-excerpt "style_good.dart (extension-names)"?>
```dart tag=good
extension MyFancyList<T> on List<T> {
   ...
}

extension SmartIterable<T> on Iterable<T> {
   ...
}
```

[extensions]: /language/extension-methods

<a id="do-name-libraries-and-source-files-using-lowercase_with_underscores"></a>
### DO name packages, directories, and source files using `lowercase_with_underscores` {:#do-name-packages-and-file-system-entities-using-lowercase-with-underscores}

{% render 'linter-rule-mention.md', rules:'file_names, package_names' %}

Alguns sistemas de arquivos não diferenciam maiúsculas de minúsculas, então muitos projetos exigem que os nomes de arquivo sejam
todos em minúsculas. Usar um caractere de separação permite que os nomes ainda sejam legíveis
nessa forma. Usar underscores como separador garante que o nome ainda seja
um identificador Dart válido, o que pode ser útil se a linguagem futuramente suportar
imports simbólicos.

```plaintext tag=good
my_package
└─ lib
   └─ file_system.dart
   └─ slider_menu.dart
```

```plaintext tag=bad
mypackage
└─ lib
   └─ file-system.dart
   └─ SliderMenu.dart
```


### DO name import prefixes using `lowercase_with_underscores`

{% render 'linter-rule-mention.md', rules:'library_prefixes' %}

<?code-excerpt "style_lib_good.dart (import-as)" replace="/(package):examples\/effective_dart\/foo.dart[^']*/$1:angular_components\/angular_components.dart/g; /(package):examples\/effective_dart\/bar.dart[^']*/$1:js\/js.dart/g"?>
```dart tag=good
import 'dart:math' as math;
import 'package:angular_components/angular_components.dart' as angular_components;
import 'package:js/js.dart' as js;
```

<?code-excerpt "style_lib_good.dart (import-as)" replace="/(package):examples\/effective_dart\/foo.dart[^']*/$1:angular_components\/angular_components.dart/g; /as angular_components/as angularComponents/g; /(package):examples\/effective_dart\/bar.dart[^']*/$1:js\/js.dart/g; / math/ Math/g;/as js/as JS/g"?>
```dart tag=bad
import 'dart:math' as Math;
import 'package:angular_components/angular_components.dart' as angularComponents;
import 'package:js/js.dart' as JS;
```


### DO name other identifiers using `lowerCamelCase`

{% render 'linter-rule-mention.md', rules:'non_constant_identifier_names' %}

Membros de classe, definições de nível superior, variáveis, parâmetros e parâmetros
nomeados devem capitalizar a primeira letra de cada palavra *exceto* a primeira
palavra, e não usar separadores.

<?code-excerpt "style_good.dart (misc-names)"?>
```dart tag=good
var count = 3;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
```


### PREFER using `lowerCamelCase` for constant names

{% render 'linter-rule-mention.md', rules:'constant_identifier_names' %}

Em código novo, use `lowerCamelCase` para nomes de constantes, incluindo valores enum.

<?code-excerpt "style_good.dart (const-names)"?>
```dart tag=good
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
```

<?code-excerpt "style_bad.dart (const-names)"?>
```dart tag=bad
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}
```

Você pode usar `SCREAMING_CAPS` para consistência com código existente,
como nos seguintes casos:

* Ao adicionar código a um arquivo ou biblioteca que já usa `SCREAMING_CAPS`.
* Ao gerar código Dart que seja paralelo ao código Java—por exemplo,
  em tipos enumerados gerados a partir de [protobufs.][]

:::note
Inicialmente, usamos o estilo `SCREAMING_CAPS` do Java para constantes. Nós
mudamos por algumas razões:

* `SCREAMING_CAPS` parece ruim para muitos casos,
  particularmente valores enum para coisas como cores CSS.
* Constantes são frequentemente alteradas para variáveis final não-const,
  o que exigiria uma mudança de nome.
* A propriedade `values` definida em um tipo enum é const e minúscula.

:::

[protobufs.]: {{site.pub-pkg}}/protobuf


### DO capitalize acronyms and abbreviations longer than two letters like words

Acrônimos capitalizados podem ser difíceis de ler,
e múltiplos acrônimos adjacentes podem levar a nomes ambíguos.
Por exemplo, dado um identificador `HTTPSFTP`,
o leitor não pode dizer se ele se refere a `HTTPS` `FTP` ou `HTTP` `SFTP`.
Para evitar isso,
capitalize a maioria dos acrônimos e abreviações como palavras regulares.
Este identificador seria `HttpsFtp` se referindo-se ao primeiro
ou `HttpSftp` para o último.

Abreviações e acrônimos de duas letras são a exceção.
Se ambas as letras forem capitalizadas em inglês,
então ambas devem permanecer capitalizadas quando usadas em um identificador.
Caso contrário, capitalize como uma palavra.

```dart tag=good
// Mais de duas letras, então sempre como uma palavra:
Http // "hypertext transfer protocol"
Nasa // "national aeronautics and space administration"
Uri // "uniform resource identifier"
Esq // "esquire"
Ave // "avenue"

// Duas letras, capitalizadas em inglês, então capitalizadas em um identificador:
ID // "identifier"
TV // "television"
UI // "user interface"

// Duas letras, não capitalizadas em inglês, então como uma palavra em um identificador:
Mr // "mister"
St // "street"
Rd // "road"
```

```dart tag=bad
HTTP // "hypertext transfer protocol"
NASA // "national aeronautics and space administration"
URI // "uniform resource identifier"
esq // "esquire"
ave // "avenue"

Id // "identifier"
Tv // "television"
Ui // "user interface"

MR // "mister"
ST // "street"
RD // "road"
```

Quando qualquer forma de abreviação vem no início
de um identificador `lowerCamelCase`, a abreviação deve estar toda em minúsculas:

```dart
var httpConnection = connect();
var tvSet = Television();
var mrRogers = 'hello, neighbor';
```

<a id="prefer-using-_-__-etc-for-unused-callback-parameters" aria-hidden="true"></a>

### PREFER using wildcards for unused callback parameters

Às vezes, a assinatura de tipo de uma função callback requer um parâmetro,
mas a implementação do callback não _usa_ o parâmetro.
Neste caso, é idiomático nomear o parâmetro não utilizado como `_`,
o que declara uma [variável wildcard][wildcards] que é non-binding.

<?code-excerpt "style_good.dart (unused-callback-param)"?>
```dart tag=good
futureOfVoid.then((_) {
  print('Operation complete.');
});
```

Como as variáveis wildcard são non-binding,
você pode nomear múltiplos parâmetros não utilizados como `_`.

<?code-excerpt "style_good.dart (unused-callback-params-multiple)"?>
```dart tag=good
.onError((_, _) {
  print('Operation failed.');
});
```

Esta diretriz é apenas para funções que são tanto *anônimas quanto locais*.
Essas funções são geralmente usadas imediatamente em um contexto onde está
claro o que o parâmetro não utilizado representa.
Em contraste, funções de nível superior e declarações de métodos não têm esse contexto,
então seus parâmetros devem ser nomeados para que fique claro para que serve cada parâmetro,
mesmo que não seja usado.

:::version-note
Declarar [variáveis wildcard][wildcards] non-binding requer
uma [versão da linguagem][language version] de pelo menos 3.7.

Em versões anteriores da linguagem, use underscores adicionais para
contornar colisões de nomes, como `__` e `___`.
Para evitar usá-los e simplificar a migração para wildcards mais tarde,
habilite o lint [`no_wildcard_variable_uses`][].

Para ajudar a migrar desta convenção para variáveis wildcard,
habilite o lint [`unnecessary_underscores`][].
:::

[wildcards]: /language/variables#wildcard-variables
[language version]: /resources/language/evolution#language-versioning
[`no_wildcard_variable_uses`]: /tools/linter-rules/no_wildcard_variable_uses
[`unnecessary_underscores`]: /tools/linter-rules/unnecessary_underscores

### DON'T use a leading underscore for identifiers that aren't private

Dart usa um underscore inicial em um identificador para marcar membros e declarações
de nível superior como privados. Isso treina os usuários a associarem um underscore inicial
com um desses tipos de declarações. Eles veem "_" e pensam "privado".

Não há conceito de "privado" para variáveis locais, parâmetros, funções
locais ou prefixos de biblioteca. Quando um desses tem um nome que começa com um
underscore, isso envia um sinal confuso ao leitor. Para evitar isso, não use
underscores iniciais nesses nomes.


### DON'T use prefix letters

[Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) e
outros esquemas surgiram no tempo do BCPL, quando o compilador não fazia muito para
ajudá-lo a entender seu código. Como o Dart pode informar o tipo, escopo,
mutabilidade e outras propriedades de suas declarações, não há razão para
codificar essas propriedades nos nomes dos identificadores.

```dart tag=good
defaultTimeout
```

```dart tag=bad
kDefaultTimeout
```

### DON'T explicitly name libraries

Adicionar um nome à diretiva `library` é tecnicamente possível,
mas é um recurso legado e desencorajado.

Dart gera uma tag única para cada biblioteca
com base em seu caminho e nome de arquivo.
Nomear bibliotecas sobrescreve este URI gerado.
Sem o URI, pode ser mais difícil para as ferramentas encontrar
o arquivo principal da biblioteca em questão.

<?code-excerpt "usage_bad.dart (library-dir)"?>
```dart tag=bad
library my_library;
```

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// A really great test library.
@TestOn('browser')
library;
```

## Ordenação

Para manter o preâmbulo do seu arquivo organizado, temos uma ordem prescrita em que
as diretivas devem aparecer. Cada "seção" deve ser separada por uma linha em branco.

Uma única regra do linter trata de todas as diretrizes de ordenação:
[directives_ordering.](/tools/linter-rules/directives_ordering)


### DO place `dart:` imports before other imports

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'dart:async';
import 'dart:collection';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
```


### DO place `package:` imports before relative imports

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
```


### DO specify exports in a separate section after all imports

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (export)"?>
```dart tag=good
import 'src/error.dart';
import 'src/foo_bar.dart';

export 'src/error.dart';
```

<?code-excerpt "style_lib_bad.dart (export)"?>
```dart tag=bad
import 'src/error.dart';
export 'src/error.dart';
import 'src/foo_bar.dart';
```


### DO sort sections alphabetically

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'foo.dart';
import 'foo/foo.dart';
```

<?code-excerpt "style_lib_bad.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
```dart tag=bad
import 'package:foo/foo.dart';
import 'package:bar/bar.dart';

import 'foo/foo.dart';
import 'foo.dart';
```


## Formatação

Como muitas linguagens, Dart ignora espaços em branco. No entanto, *humanos* não. Ter um
estilo de espaços em branco consistente ajuda a garantir que leitores humanos vejam o código da mesma
forma que o compilador vê.


### DO format your code using `dart format`

Formatação é um trabalho tedioso e é particularmente demorado durante
refatoração. Felizmente, você não precisa se preocupar com isso. Fornecemos um
formatador de código automatizado sofisticado chamado [`dart format`][] que faz isso por
você. As regras oficiais de tratamento de espaços em branco para Dart são
*o que quer que o `dart format` produza*. O [FAQ do formatador][formatter FAQ] pode fornecer mais informações
sobre as escolhas de estilo que ele aplica.

As diretrizes de formatação restantes são para as poucas coisas que o `dart format` não pode
corrigir para você.

[`dart format`]: /tools/dart-format
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ

### CONSIDER changing your code to make it more formatter-friendly

O formatador faz o melhor que pode com qualquer código que você jogue nele, mas não
pode fazer milagres. Se seu código tiver identificadores particularmente longos, expressões
profundamente aninhadas, uma mistura de diferentes tipos de operadores, etc., a
saída formatada ainda pode ser difícil de ler.

Quando isso acontecer, reorganize ou simplifique seu código. Considere encurtar um nome de
variável local ou elevar uma expressão para uma nova variável local. Em outras
palavras, faça os mesmos tipos de modificações que você faria se estivesse
formatando o código manualmente e tentando torná-lo mais legível. Pense no
`dart format` como uma parceria onde você trabalha juntos, às vezes iterativamente,
para produzir um código bonito.

<a id="avoid-lines-longer-than-80-characters"></a>
### PREFER lines 80 characters or fewer

{% render 'linter-rule-mention.md', rules:'lines_longer_than_80_chars' %}

Estudos de legibilidade mostram que linhas longas de texto são mais difíceis de ler porque seu
olho tem que percorrer uma distância maior ao se mover para o início da próxima linha. É por isso
que jornais e revistas usam várias colunas de texto.

Se você realmente se pegar querendo linhas com mais de 80 caracteres, nossa
experiência é que seu código provavelmente está muito verboso e poderia ser um pouco mais
compacto. O principal culpado geralmente é `VeryLongCamelCaseClassNames`. Pergunte a
si mesmo: "Cada palavra nesse nome de tipo me diz algo crítico ou
previne uma colisão de nomes?" Caso contrário, considere omiti-la.

Note que o `dart format` usa 80 caracteres ou menos por padrão, embora você possa
[configurar][configure] o padrão.
Ele não divide literais de string longos para caber em 80 colunas,
então você tem que fazer isso manualmente.

**Exception:** Quando um URI ou caminho de arquivo ocorre em um comentário ou string (geralmente em
um import ou export), ele pode permanecer inteiro mesmo que faça a linha ultrapassar
80 caracteres. Isso facilita a busca em arquivos fonte por um caminho.

**Exception:** Strings multi-linha podem conter linhas com mais de 80 caracteres
porque novas linhas são significativas dentro da string e dividir as linhas em
linhas menores pode alterar o programa.

[configure]: /tools/dart-format#configuring-formatter-page-width

<a id="do-use-curly-braces-for-all-flow-control-structures"></a>
### DO use curly braces for all flow control statements

{% render 'linter-rule-mention.md', rules:'curly_braces_in_flow_control_structures' %}

Fazer isso evita o problema do [dangling else][].

[dangling else]: https://en.wikipedia.org/wiki/Dangling_else

<?code-excerpt "style_good.dart (curly-braces)"?>
```dart tag=good
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
```

**Exception:** Quando você tem uma instrução `if` sem cláusula `else` e toda a
instrução `if` cabe em uma linha, você pode omitir as chaves se preferir:

<?code-excerpt "style_good.dart (one-line-if)"?>
```dart tag=good
if (arg == null) return defaultValue;
```

Se o corpo se estender para a próxima linha, use chaves:

<?code-excerpt "style_good.dart (one-line-if-wrap)"?>
```dart tag=good
if (overflowChars != other.overflowChars) {
  return overflowChars < other.overflowChars;
}
```

<?code-excerpt "style_bad.dart (one-line-if-wrap)"?>
```dart tag=bad
if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
```
