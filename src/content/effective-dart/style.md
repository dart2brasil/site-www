---
ia-translate: true
title: "Dart Eficaz: Estilo | Effective Dart: Style"
description: Regras de formatação e nomenclatura para código consistente e legível.
nextpage:
  url: /effective-dart/documentation
  title: Documentação
prevpage:
  url: /effective-dart
  title: Visão geral
---
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Uma parte surpreendentemente importante de um bom código é o bom estilo. Nomenclatura,
ordenação e formatação consistentes ajudam a fazer com que o código que *é* o mesmo *pareça* o mesmo. Isso tira
proveito do poderoso mecanismo de reconhecimento de padrões que a maioria de nós tem em nossos
sistemas oculares. Se usarmos um estilo consistente em todo o ecossistema Dart,
fica mais fácil para todos nós aprendermos e contribuirmos com o código uns dos outros.

## Identificadores {:#identifiers}

Os identificadores vêm em três tipos em Dart.

* `UpperCamelCase` os nomes capitalizam a primeira letra de cada palavra, incluindo
  a primeira.

* `lowerCamelCase` os nomes capitalizam a primeira letra de cada palavra, *exceto*
  a primeira, que sempre é minúscula, mesmo que seja uma sigla.

* `lowercase_with_underscores` os nomes usam apenas letras minúsculas,
  mesmo para siglas, e separam palavras com `_`.

### SIGA a nomenclatura de tipos usando `UpperCamelCase` {:#do-name-types-using-uppercamelcase}

{% render 'linter-rule-mention.md', rules:'camel_case_types' %}

Classes, tipos enum, typedefs (alias de tipos) e parâmetros de tipo devem capitalizar a primeira
letra de cada palavra (incluindo a primeira palavra) e não usar separadores.

<?code-excerpt "style_good.dart (type-names)"?>
```dart tag=good
class SliderMenu { ... }

class HttpRequest { ... }

typedef Predicate<T> = bool Function(T value);
```

Isso inclui até mesmo classes destinadas a serem usadas em anotações de metadados.

<?code-excerpt "style_good.dart (annotation-type-names)"?>
```dart tag=good
class Foo {
  const Foo([Object? arg]);
}

@Foo(anArg)
class A { ... }

@Foo()
class B { ... }
```

Se o construtor da classe de anotação não receber parâmetros, você pode querer
criar uma constante `lowerCamelCase` separada para ela.

<?code-excerpt "style_good.dart (annotation-const)"?>
```dart tag=good
const foo = Foo();

@foo
class C { ... }
```

### SIGA a nomenclatura de extensões usando `UpperCamelCase` {:#do-name-extensions-using-uppercamelcase}

{% render 'linter-rule-mention.md', rules:'camel_case_extensions' %}

Como os tipos, as [extensões][extensions] devem capitalizar a primeira letra de cada palavra
(incluindo a primeira palavra) e não usar separadores.

<?code-excerpt "style_good.dart (extension-names)"?>
```dart tag=good
extension MyFancyList<T> on List<T> { ... }

extension SmartIterable<T> on Iterable<T> { ... }
```

[extensions]: /language/extension-methods

<a id="do-name-libraries-and-source-files-using-lowercase_with_underscores"></a>
### SIGA a nomenclatura de pacotes, diretórios e arquivos-fonte usando `lowercase_with_underscores` {:#do-name-packages-and-file-system-entities-using-lowercase-with-underscores}

{% render 'linter-rule-mention.md', rules:'file_names, package_names' %}

Alguns sistemas de arquivos não diferenciam maiúsculas de minúsculas, portanto, muitos projetos exigem que os nomes de arquivo sejam
todos minúsculos. Usar um caractere separador permite que os nomes ainda sejam legíveis
nessa forma. O uso de sublinhados como separador garante que o nome ainda seja
um identificador Dart válido, o que pode ser útil se a linguagem mais tarde suportar
importações simbólicas.

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


### SIGA a nomenclatura de prefixos de importação usando `lowercase_with_underscores` {:#do-name-import-prefixes-using-lowercase_with_underscores}

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


### SIGA a nomenclatura de outros identificadores usando `lowerCamelCase` {:#do-name-other-identifiers-using-lowercamelcase}

{% render 'linter-rule-mention.md', rules:'non_constant_identifier_names' %}

Membros de classe, definições de nível superior, variáveis, parâmetros e parâmetros nomeados devem capitalizar a primeira letra de cada palavra *exceto* a primeira
palavra e não usar separadores.

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

Em código novo, use `lowerCamelCase` para variáveis constantes, incluindo valores enum.

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

Você pode usar `SCREAMING_CAPS` para manter a consistência com o código existente,
como nos seguintes casos:

* Ao adicionar código a um arquivo ou biblioteca que já usa `SCREAMING_CAPS`.
* Ao gerar código Dart que é paralelo ao código Java — por exemplo,
  em tipos enumerados gerados a partir de [protobufs.][protobufs.]

:::note
Inicialmente, usamos o estilo `SCREAMING_CAPS` do Java para constantes. Mudamos por algumas razões:

* `SCREAMING_CAPS` fica ruim em muitos casos,
  especialmente valores enum para coisas como cores CSS.
* Constantes são frequentemente alteradas para variáveis finais não constantes,
  o que exigiria uma alteração de nome.
* A propriedade `values` definida em um tipo enum é constante e minúscula.

:::

[protobufs.]: {{site.pub-pkg}}/protobuf


### SIGA a capitalização de siglas e abreviações com mais de duas letras como palavras {:#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words}

Siglas capitalizadas podem ser difíceis de ler,
e várias siglas adjacentes podem levar a nomes ambíguos.
Por exemplo, dado um identificador `HTTPSFTP`,
o leitor não consegue dizer se ele se refere a `HTTPS` `FTP` ou `HTTP` `SFTP`.
Para evitar isso,
capitalize a maioria das siglas e abreviações como palavras comuns.
Este identificador seria `HttpsFtp` se referindo ao primeiro
ou `HttpSftp` para o último.

Abreviações e siglas de duas letras são a exceção.
Se ambas as letras são maiúsculas em inglês,
então ambas devem permanecer maiúsculas quando usadas em um identificador.
Caso contrário, capitalize como uma palavra.

```dart tag=good
// Mais de duas letras, então sempre como uma palavra:
Http // "hypertext transfer protocol" (protocolo de transferência de hipertexto)
Nasa // "national aeronautics and space administration" (Administração Nacional da Aeronáutica e Espaço)
Uri // "uniform resource identifier" (identificador uniforme de recurso)
Esq // "esquire" (escudeiro)
Ave // "avenue" (avenida)

// Duas letras, maiúsculas em inglês, então maiúsculas em um identificador:
ID // "identifier" (identificador)
TV // "television" (televisão)
UI // "user interface" (interface do usuário)

// Duas letras, não maiúsculas em inglês, então como uma palavra em um identificador:
Mr // "mister" (senhor)
St // "street" (rua)
Rd // "road" (estrada)
```

```dart tag=bad
HTTP // "hypertext transfer protocol"
NASA // "national aeronautics and space administration"
URI // "uniform resource identifier"
esq // "esquire"
Ave // "avenue"

Id // "identifier"
Tv // "television"
Ui // "user interface"

MR // "mister"
ST // "street"
RD // "road"
```

Quando qualquer forma de abreviação aparece no início
de um identificador `lowerCamelCase`, a abreviação deve ser toda minúscula:

```dart
var httpConnection = connect();
var tvSet = Television();
var mrRogers = 'hello, neighbor';
```

### PREFIRA usar `_`, `__`, etc. para parâmetros de retorno de chamada não usados {:#prefer-using-_-__-etc-for-unused-callback-parameters}

Às vezes, a assinatura de tipo de uma função de retorno de chamada (callback) requer um parâmetro,
mas a implementação do retorno de chamada não *usa* o parâmetro.
Neste caso, é idiomático nomear o parâmetro não usado `_`.
Se a função tiver vários parâmetros não usados, use sublinhados adicionais para evitar colisões de nome: `__`, `___`, etc.

<?code-excerpt "style_good.dart (unused-callback-params)"?>
```dart tag=good
futureOfVoid.then((_) {
  print('Operação concluída.');
});
```

Esta diretriz é apenas para funções que são *anônimas e locais*.
Essas funções geralmente são usadas imediatamente em um contexto em que está
claro o que o parâmetro não usado representa.
Em contraste, as funções de nível superior e as declarações de método não têm esse contexto,
portanto, seus parâmetros devem ser nomeados para que fique claro para que cada parâmetro serve,
mesmo que não seja usado.


### NÃO use um sublinhado inicial para identificadores que não são privados {:#dont-use-a-leading-underscore-for-identifiers-that-arent-private}

Dart usa um sublinhado inicial em um identificador para marcar membros e nível superior
declarações como privadas. Isso treina os usuários a associar um sublinhado inicial
a um desses tipos de declarações. Eles veem "_" e pensam "privado".

Não existe o conceito de "privado" para variáveis locais, parâmetros, funções locais ou prefixos de biblioteca. Quando um deles tem um nome que começa com um
sublinhado, ele envia um sinal confuso para o leitor. Para evitar isso, não use
sublinhados iniciais nesses nomes.


### NÃO use letras de prefixo {:#dont-use-prefix-letters}

A [notação húngara](https://en.wikipedia.org/wiki/Hungarian_notation) e
outros esquemas surgiram na época do BCPL, quando o compilador não fazia muito para
ajudar você a entender seu código. Como Dart pode dizer a você o tipo, escopo,
mutabilidade e outras propriedades de suas declarações, não há razão para
codificar essas propriedades em nomes de identificadores.

```dart tag=good
defaultTimeout
```

```dart tag=bad
kDefaultTimeout
```

### NÃO nomeie bibliotecas explicitamente {:#dont-explicitly-name-libraries}

Acrescentar um nome à diretiva `library` é tecnicamente possível,
mas é um recurso legado e desencorajado.

Dart gera uma tag exclusiva para cada biblioteca
com base em seu caminho e nome de arquivo.
Nomear bibliotecas substitui este URI gerado.
Sem o URI, pode ser mais difícil para as ferramentas encontrarem
o arquivo da biblioteca principal em questão.

<?code-excerpt "usage_bad.dart (library-dir)"?>
```dart tag=bad
library my_library;
```

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// Uma biblioteca de teste realmente ótima.
@TestOn('browser')
library;
```

## Ordenação {:#ordering}

Para manter o preâmbulo do seu arquivo arrumado, temos uma ordem prescrita que
as diretivas devem aparecer. Cada "seção" deve ser separada por uma linha em branco.

Uma única regra do linter lida com todas as diretrizes de ordenação:
[directives_ordering.](/tools/linter-rules/directives_ordering)


### SIGA a colocação de importações `dart:` antes de outras importações {:#do-place-dart-imports-before-other-imports}

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
```


### SIGA a colocação de importações `package:` antes de importações relativas {:#do-place-package-imports-before-relative-imports}

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
```


### SIGA a especificação de exportações em uma seção separada após todas as importações {:#do-specify-exports-in-a-separate-section-after-all-imports}

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


### SIGA a classificação das seções em ordem alfabética {:#do-sort-sections-alphabetically}

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

Como muitas linguagens, Dart ignora espaços em branco. No entanto, *humanos* não. Ter um
estilo de espaço em branco consistente ajuda a garantir que os leitores humanos vejam o código da mesma maneira que o compilador.


### SIGA a formatação do seu código usando `dart format` {:#do-format-your-code-using-dart-format}

A formatação é um trabalho tedioso e é particularmente demorado durante
a refatoração. Felizmente, você não precisa se preocupar com isso. Fornecemos um
formatador de código automático sofisticado chamado [`dart format`][`dart format`] que faz isso para
você. As regras oficiais de tratamento de espaços em branco para Dart são
*o que `dart format` produz*. A [FAQ do formatador][formatter FAQ] pode fornecer mais informações
sobre as escolhas de estilo que ele impõe.

As diretrizes de formatação restantes são para as poucas coisas que `dart format` não pode
corrigir para você.

[`dart format`]: /tools/dart-format
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ

### CONSIDERE alterar seu código para torná-lo mais amigável ao formatador {:#consider-changing-your-code-to-make-it-more-formatter-friendly}

O formatador faz o melhor que pode com qualquer código que você lhe der, mas ele
não pode fazer milagres. Se seu código tiver identificadores particularmente longos, expressões profundamente
aninhadas, uma mistura de diferentes tipos de operadores etc., a
saída formatada ainda pode ser difícil de ler.

Quando isso acontece, reorganize ou simplifique seu código. Considere encurtar um
nome de variável local ou elevar uma expressão para uma nova variável local. Em outras palavras, faça os mesmos tipos de modificações que você faria se estivesse
formatando o código manualmente e tentando torná-lo mais legível. Pense em
`dart format` como uma parceria em que vocês trabalham juntos, às vezes iterativamente,
para produzir código bonito.


### EVITE linhas com mais de 80 caracteres {:#avoid-lines-longer-than-80-characters}

{% render 'linter-rule-mention.md', rules:'lines_longer_than_80_chars' %}

Estudos de legibilidade mostram que linhas longas de texto são mais difíceis de ler porque seus
olhos precisam percorrer mais quando se movem para o início da próxima linha. É por isso que
jornais e revistas usam várias colunas de texto.

Se você realmente se sentir com vontade de usar linhas com mais de 80 caracteres, nossa
experiência é que seu código provavelmente é muito verboso e poderia ser um pouco mais
compacto. O principal infrator geralmente é `VeryLongCamelCaseClassNames`. Pergunte a si mesmo: "Cada palavra nesse nome de tipo me diz algo crítico ou
previne uma colisão de nome?". Se não, considere omiti-la.

Observe que `dart format` faz 99% disso por você, mas o último 1% é você.
Ele não divide literais de string longos para caber em 80 colunas,
então você tem que fazer isso manualmente.

**Exceção:** Quando um URI ou caminho de arquivo ocorre em um comentário ou string (geralmente em
uma importação ou exportação), ele pode permanecer inteiro mesmo que isso faça com que a linha ultrapasse
80 caracteres. Isso facilita a busca de arquivos-fonte por um caminho.

**Exceção:** Strings de várias linhas podem conter linhas com mais de 80 caracteres
porque as novas linhas são significativas dentro da string e dividir as linhas em
outras mais curtas pode alterar o programa.

<a id="do-use-curly-braces-for-all-flow-control-structures"></a>
### SIGA o uso de chaves para todas as estruturas de controle de fluxo {:#do-use-curly-braces-for-all-flow-control-statements}

{% render 'linter-rule-mention.md', rules:'curly_braces_in_flow_control_structures' %}

Fazê-lo evita o problema do [dangling else][dangling else]. (else pendente)

[dangling else]: https://en.wikipedia.org/wiki/Dangling_else

<?code-excerpt "style_good.dart (curly-braces)"?>
```dart tag=good
if (isWeekDay) {
  print('Vá de bicicleta para o trabalho!');
} else {
  print('Vá dançar ou leia um livro!');
}
```

**Exceção:** Quando você tem uma instrução `if` sem uma cláusula `else` e a
instrução `if` inteira cabe em uma linha, você pode omitir as chaves se preferir:

<?code-excerpt "style_good.dart (one-line-if)"?>
```dart tag=good
if (arg == null) return defaultValue;
```

Se o corpo quebrar para a próxima linha, no entanto, use chaves:

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

