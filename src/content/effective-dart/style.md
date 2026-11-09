---
ia-translate: true
title: "Effective Dart: Estilo"
breadcrumb: Style
description: Regras de formatação e nomenclatura para um código consistente e legível.
nextpage:
  url: /effective-dart/documentation
  title: Documentação
prevpage:
  url: /effective-dart
  title: Visão geral
---
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Uma parte surpreendentemente importante de um bom código é um bom estilo. Nomes,
ordenação e formatação consistentes fazem com que códigos que *são* iguais também
*pareçam* iguais. Isso aproveita o poderoso hardware de reconhecimento de padrões
que a maioria de nós tem em seus sistemas visuais.  Se usarmos um estilo consistente
em todo o ecossistema Dart, fica mais fácil para todos nós aprender com o código
dos outros e contribuir para ele.

## Identificadores {:#identifiers}

Identificadores vêm em três variações no Dart.

* Nomes `UpperCamelCase` colocam em maiúscula a primeira letra de cada palavra,
  incluindo a primeira.

* Nomes `lowerCamelCase` colocam em maiúscula a primeira letra de cada palavra, *exceto*
  a primeira, que é sempre minúscula, mesmo que seja uma sigla.

* Nomes `lowercase_with_underscores` usam apenas letras minúsculas,
  mesmo para siglas, e separam as palavras com `_`.

### FAÇA nomear tipos usando `UpperCamelCase` {:#do-name-types-using-uppercamelcase}

{% render 'linter-rule-mention.md', rules:'camel_case_types' %}

Classes, tipos enum, typedefs e parâmetros de tipo devem colocar em maiúscula a primeira
letra de cada palavra (incluindo a primeira palavra), e não usar separadores.

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

Isso inclui até classes pensadas para serem usadas em anotações de metadados.

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

Se o construtor da classe de anotação não recebe parâmetros, você pode querer
criar uma constante `lowerCamelCase` separada para ela.

<?code-excerpt "style_good.dart (annotation-const)"?>
```dart tag=good
const foo = Foo();

@foo
class C {
   ...
}
```

### FAÇA nomear extensões usando `UpperCamelCase` {:#do-name-extensions-using-uppercamelcase}

{% render 'linter-rule-mention.md', rules:'camel_case_extensions' %}

Assim como os tipos, [extensões][extensions] devem colocar em maiúscula a primeira
letra de cada palavra (incluindo a primeira palavra),
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
### FAÇA nomear pacotes, diretórios e arquivos-fonte usando `lowercase_with_underscores` {:#do-name-packages-and-file-system-entities-using-lowercase-with-underscores}

{% render 'linter-rule-mention.md', rules:'file_names, package_names' %}

Alguns sistemas de arquivos não diferenciam maiúsculas de minúsculas, então muitos projetos exigem
que os nomes de arquivo sejam todos em minúsculas. Usar um caractere separador permite que os nomes
continuem legíveis nessa forma. Usar underscores como separador garante que o nome continue sendo
um identificador Dart válido, o que pode ser útil caso a linguagem venha a suportar imports simbólicos.

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


### FAÇA nomear prefixos de import usando `lowercase_with_underscores` {:#do-name-import-prefixes-using-lowercase_with_underscores}

{% render 'linter-rule-mention.md', rules:'library_prefixes' %}

<?code-excerpt "style_lib_good.dart (import-as)" replace="/(package):examples\/effective_dart\/foo.dart[^']*/$1:angular_components\/angular_components.dart/g; /(package):examples\/effective_dart\/bar.dart[^']*/$1:web\/web.dart/g; /as js/as web/g"?>
```dart tag=good
import 'dart:math' as math;

import 'package:angular_components/angular_components.dart' as angular_components;
import 'package:web/web.dart' as web;
```

<?code-excerpt "style_lib_good.dart (import-as)" replace="/(package):examples\/effective_dart\/foo.dart[^']*/$1:angular_components\/angular_components.dart/g; /as angular_components/as angularComponents/g; /(package):examples\/effective_dart\/bar.dart[^']*/$1:web\/web.dart/g; / math/ Math/g;/as js/as Web/g"?>
```dart tag=bad
import 'dart:math' as Math;

import 'package:angular_components/angular_components.dart' as angularComponents;
import 'package:web/web.dart' as Web;
```


### FAÇA nomear os demais identificadores usando `lowerCamelCase` {:#do-name-other-identifiers-using-lowercamelcase}

{% render 'linter-rule-mention.md', rules:'non_constant_identifier_names' %}

Membros de classe, definições de nível superior, variáveis, parâmetros e parâmetros nomeados
devem colocar em maiúscula a primeira letra de cada palavra *exceto* a primeira
palavra, e não usar separadores.

<?code-excerpt "style_good.dart (misc-names)"?>
```dart tag=good
var count = 3;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
```


### PREFIRA usar `lowerCamelCase` para nomes de constantes {:#prefer-using-lowercamelcase-for-constant-names}

{% render 'linter-rule-mention.md', rules:'constant_identifier_names' %}

Em código novo, use `lowerCamelCase` para variáveis constantes, incluindo valores de enum.

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

Você pode usar `SCREAMING_CAPS` por consistência com o código existente,
como nos seguintes casos:

* Ao adicionar código a um arquivo ou biblioteca que já usa `SCREAMING_CAPS`.
* Ao gerar código Dart que é paralelo a código Java, por exemplo,
  em tipos enumerados gerados a partir de [protobufs.][]

:::note
Inicialmente usamos o estilo `SCREAMING_CAPS` do Java para constantes. Mudamos
por alguns motivos:

* `SCREAMING_CAPS` fica ruim em muitos casos,
  principalmente em valores de enum para coisas como cores CSS.
* Constantes frequentemente são trocadas por variáveis `final` não const,
  o que exigiria uma mudança de nome.
* A propriedade `values` definida em um tipo enum é const e em minúsculas.

:::

[protobufs.]: {{site.pub-pkg}}/protobuf


### FAÇA escrever com maiúscula siglas e abreviações com mais de duas letras, como palavras {:#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words}

Siglas em maiúsculas podem ser difíceis de ler,
e várias siglas adjacentes podem gerar nomes ambíguos.
Por exemplo, dado o identificador `HTTPSFTP`,
o leitor não consegue saber se ele se refere a `HTTPS` `FTP` ou a `HTTP` `SFTP`.
Para evitar isso,
escreva a maioria das siglas e abreviações com maiúscula inicial, como palavras comuns.
Esse identificador seria `HttpsFtp` se se referisse ao primeiro caso,
ou `HttpSftp` para o segundo.

Siglas e abreviações de duas letras são a exceção.
Se as duas letras são maiúsculas em inglês,
elas devem continuar maiúsculas quando usadas em um identificador.
Caso contrário, escreva como uma palavra.

```dart tag=good
// Longer than two letters, so always like a word:
Http // "hypertext transfer protocol"
Nasa // "national aeronautics and space administration"
Uri // "uniform resource identifier"
Esq // "esquire"
Ave // "avenue"

// Two letters, capitalized in English, so capitalized in an identifier:
ID // "identifier"
TV // "television"
UI // "user interface"

// Two letters, not capitalized in English, so like a word in an identifier:
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

Quando qualquer forma de abreviação vem no início de um identificador `lowerCamelCase`,
a abreviação deve ficar toda em minúsculas:

```dart
var httpConnection = connect();
var tvSet = Television();
var mrRogers = 'hello, neighbor';
```

<a id="prefer-using-_-__-etc-for-unused-callback-parameters" aria-hidden="true"></a>

### PREFIRA usar curingas para parâmetros de callback não usados {:#prefer-using-wildcards-for-unused-callback-parameters}

Às vezes a assinatura de tipo de uma função de callback exige um parâmetro,
mas a implementação do callback não *usa* esse parâmetro.
Nesse caso, é idiomático nomear o parâmetro não usado como `_`,
o que declara uma [variável curinga][wildcards] que não faz vínculo.

<?code-excerpt "style_good.dart (unused-callback-param)"?>
```dart tag=good
futureOfVoid.then((_) {
  print('Operation complete.');
});
```

Como variáveis curinga não fazem vínculo,
você pode nomear vários parâmetros não usados como `_`.

<?code-excerpt "style_good.dart (unused-callback-params-multiple)"?>
```dart tag=good
.onError((_, _) {
  print('Operation failed.');
});
```

Esta diretriz vale apenas para funções que são, ao mesmo tempo, *anônimas e locais*.
Essas funções geralmente são usadas imediatamente em um contexto em que
fica claro o que o parâmetro não usado representa.
Em contraste, funções de nível superior e declarações de método não têm esse contexto,
então seus parâmetros devem ser nomeados para que fique claro para que serve cada um,
mesmo que não sejam usados.

:::version-note
Declarar [variáveis curinga][wildcards] que não fazem vínculo exige
uma [versão da linguagem][language version] de pelo menos 3.7.

Em versões anteriores da linguagem, use underscores adicionais para
contornar colisões de nome, como `__` e `___`.
Para impedir o uso deles e simplificar a migração para curingas depois,
ative a regra [`no_wildcard_variable_uses`][].

Para ajudar a migrar dessa convenção para variáveis curinga,
ative a regra [`unnecessary_underscores`][].
:::

[wildcards]: /language/variables#wildcard-variables
[language version]: /language/versioning
[`no_wildcard_variable_uses`]: /tools/linter-rules/no_wildcard_variable_uses
[`unnecessary_underscores`]: /tools/linter-rules/unnecessary_underscores

### NÃO use underscore inicial em identificadores que não são privados {:#dont-use-a-leading-underscore-for-identifiers-that-arent-private}

O Dart usa um underscore inicial em um identificador para marcar membros e declarações
de nível superior como privados. Isso ensina os usuários a associar um underscore inicial
a um desses tipos de declaração. Eles veem "_" e pensam "privado".

Não existe o conceito de "privado" para variáveis locais, parâmetros, funções locais
ou prefixos de biblioteca. Quando um desses tem um nome que começa com underscore, ele envia
um sinal confuso para o leitor. Para evitar isso, não use underscores iniciais nesses nomes.


### NÃO use letras de prefixo {:#dont-use-prefix-letters}

A [notação húngara](https://en.wikipedia.org/wiki/Hungarian_notation) e
outros esquemas surgiram na época do BCPL, quando o compilador não fazia muito para
ajudar você a entender seu código. Como o Dart consegue informar o tipo, o escopo,
a mutabilidade e outras propriedades das suas declarações, não há motivo para
codificar essas propriedades nos nomes dos identificadores.

```dart tag=good
defaultTimeout
```

```dart tag=bad
kDefaultTimeout
```

### NÃO nomeie bibliotecas explicitamente {:#dont-explicitly-name-libraries}

Acrescentar um nome à diretiva `library` é tecnicamente possível,
mas é um recurso legado e desencorajado.

O Dart gera uma tag única para cada biblioteca
com base no seu caminho e nome de arquivo.
Nomear bibliotecas substitui essa URI gerada.
Sem a URI, fica mais difícil para as ferramentas encontrarem
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

## Ordenação {:#ordering}

Para manter o cabeçalho do seu arquivo organizado, temos uma ordem prescrita em que
as diretivas devem aparecer. Cada "seção" deve ser separada por uma linha em branco.

Uma única regra do linter cuida de todas as diretrizes de ordenação:
[directives_ordering.](/tools/linter-rules/directives_ordering)


### FAÇA colocar imports `dart:` antes dos outros imports {:#do-place-dart-imports-before-other-imports}

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'dart:async';
import 'dart:collection';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
```


### FAÇA colocar imports `package:` antes dos imports relativos {:#do-place-package-imports-before-relative-imports}

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
```


### FAÇA especificar exports em uma seção separada, depois de todos os imports {:#do-specify-exports-in-a-separate-section-after-all-imports}

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


### FAÇA ordenar as seções em ordem alfabética {:#do-sort-sections-alphabetically}

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


## Formatação {:#formatting}

Como muitas linguagens, o Dart ignora espaços em branco. No entanto, *as pessoas* não ignoram.
Ter um estilo consistente de espaçamento ajuda a garantir que os leitores humanos vejam o código
da mesma forma que o compilador.


### FAÇA formatar seu código usando `dart format` {:#do-format-your-code-using-dart-format}

Formatar é um trabalho tedioso e especialmente demorado durante
refatorações. Felizmente, você não precisa se preocupar com isso. Fornecemos um formatador de código
automatizado sofisticado chamado [`dart format`][] que faz isso por você. As regras oficiais de
espaçamento do Dart são
*o que quer que o `dart format` produza*. A [FAQ do formatador][formatter FAQ] pode dar mais
detalhes sobre as escolhas de estilo que ele impõe.

As demais diretrizes de formatação são para as poucas coisas que o `dart format` não consegue
corrigir para você.

[`dart format`]: /tools/dart-format
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ

### CONSIDERE mudar seu código para torná-lo mais amigável ao formatador {:#consider-changing-your-code-to-make-it-more-formatter-friendly}

O formatador faz o melhor que pode com o código que você entrega, mas
não consegue fazer milagres. Se o seu código tem identificadores especialmente longos, expressões
muito aninhadas, uma mistura de diferentes tipos de operadores etc., a saída formatada
pode continuar difícil de ler.

Quando isso acontecer, reorganize ou simplifique seu código. Considere encurtar um nome de variável
local ou extrair uma expressão para uma nova variável local. Em outras
palavras, faça os mesmos tipos de modificação que faria se estivesse formatando o código
à mão e tentando torná-lo mais legível. Pense no `dart format` como uma parceria em que vocês
trabalham juntos, às vezes de forma iterativa,
para produzir código bonito.

<a id="avoid-lines-longer-than-80-characters"></a>
### PREFIRA linhas com 80 caracteres ou menos {:#prefer-lines-80-characters-or-fewer}

{% render 'linter-rule-mention.md', rules:'lines_longer_than_80_chars' %}

Estudos de legibilidade mostram que linhas longas de texto são mais difíceis de ler, porque o seu
olho precisa percorrer uma distância maior ao voltar para o início da linha seguinte. É por isso que
jornais e revistas usam várias colunas de texto.

Se você realmente sente que precisa de linhas com mais de 80 caracteres, nossa
experiência mostra que seu código provavelmente está verboso demais e poderia ser um pouco mais
compacto. O principal culpado costuma ser `VeryLongCamelCaseClassNames`. Pergunte
a si mesmo: "Cada palavra desse nome de tipo me diz algo essencial ou evita uma colisão de nomes?"
Se não, considere omiti-la.

Observe que o `dart format` usa 80 caracteres ou menos por padrão, embora você possa
[configurar][configure] esse padrão.
Ele não quebra literais de string longos para caber em 80 colunas,
então você precisa fazer isso manualmente.

**Exceção:** quando uma URI ou caminho de arquivo aparece em um comentário ou string (geralmente em
um import ou export), ele pode permanecer inteiro mesmo que faça a linha passar de
80 caracteres. Isso facilita buscar o caminho nos arquivos-fonte.

**Exceção:** strings multilinha podem conter linhas com mais de 80 caracteres,
porque as quebras de linha são significativas dentro da string, e dividi-las em linhas
menores pode alterar o programa.

[configure]: /tools/dart-format#page-width

<a id="do-use-curly-braces-for-all-flow-control-structures"></a>
### FAÇA usar chaves em todas as estruturas de controle de fluxo {:#do-use-curly-braces-for-all-flow-control-statements}

{% render 'linter-rule-mention.md', rules:'curly_braces_in_flow_control_structures' %}

Isso evita o problema do [*else* pendente][dangling else].

[dangling else]: https://en.wikipedia.org/wiki/Dangling_else

<?code-excerpt "style_good.dart (curly-braces)"?>
```dart tag=good
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
```

**Exceção:** quando você tem um `if` sem cláusula `else` e
a instrução `if` inteira cabe em uma linha, você pode omitir as chaves, se preferir:

<?code-excerpt "style_good.dart (one-line-if)"?>
```dart tag=good
if (arg == null) return defaultValue;
```

Se o corpo quebrar para a linha seguinte, porém, use chaves:

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
