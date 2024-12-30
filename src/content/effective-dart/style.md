---
ia-translate: true
title: "Effective Dart: Estilo"
description: Regras de formatação e nomenclatura para código consistente e legível.
nextpage:
  url: /effective-dart/documentation
  title: Documentação
prevpage:
  url: /effective-dart
  title: Visão Geral
---
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Uma parte surpreendentemente importante de um bom código é um bom estilo. 
Nomenclatura, ordenação e formatação consistentes ajudam o código que *é* o
mesmo a *parecer* o mesmo. Isso aproveita o poderoso hardware de correspondência
de padrões que a maioria de nós tem em nossos sistemas oculares. Se usarmos um
estilo consistente em todo o ecossistema Dart, isso torna mais fácil para todos
nós aprendermos e contribuirmos com o código uns dos outros.

## Identificadores

Os identificadores vêm em três tipos no Dart.

*   `UpperCamelCase` capitaliza a primeira letra de cada palavra, incluindo a
    primeira.

*   `lowerCamelCase` capitaliza a primeira letra de cada palavra, *exceto* a
    primeira, que é sempre minúscula, mesmo que seja um acrônimo.

*   `lowercase_with_underscores` usa apenas letras minúsculas, mesmo para
    acrônimos, e separa as palavras com `_`.

### USE `UpperCamelCase` para nomes de tipos

{% render 'linter-rule-mention.md', rules:'camel_case_types' %}

Classes, enum types, typedefs e type parameters devem capitalizar a primeira
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

Se o construtor da classe de anotação não receber parâmetros, você pode criar
uma constante `lowerCamelCase` separada para ele.

<?code-excerpt "style_good.dart (annotation-const)"?>
```dart tag=good
const foo = Foo();

@foo
class C { ... }
```

### USE `UpperCamelCase` para nomes de extensões

{% render 'linter-rule-mention.md', rules:'camel_case_extensions' %}

Como os tipos, as [extensões][extensions] devem capitalizar a primeira letra de cada palavra
(incluindo a primeira palavra) e
não usar separadores.

<?code-excerpt "style_good.dart (extension-names)"?>
```dart tag=good
extension MyFancyList<T> on List<T> { ... }

extension SmartIterable<T> on Iterable<T> { ... }
```

[extensions]: /language/extension-methods

<a id="do-name-libraries-and-source-files-using-lowercase_with_underscores"></a>
### USE `lowercase_with_underscores` para nomes de pacotes, diretórios e arquivos fonte {:#do-name-packages-and-file-system-entities-using-lowercase-with-underscores}

{% render 'linter-rule-mention.md', rules:'file_names, package_names' %}

Alguns sistemas de arquivos não diferenciam maiúsculas de minúsculas, então muitos
projetos exigem que os nomes de arquivos sejam todos minúsculos. Usar um caractere
separador permite que os nomes ainda sejam legíveis dessa forma. Usar underscores
como separador garante que o nome ainda seja um identificador Dart válido, o que
pode ser útil se a linguagem posteriormente suportar importações simbólicas.

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


### USE `lowercase_with_underscores` para nomes de prefixos de importação

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


### USE `lowerCamelCase` para outros identificadores

{% render 'linter-rule-mention.md', rules:'non_constant_identifier_names' %}

Membros de classe, definições de nível superior, variáveis, parâmetros e
parâmetros nomeados devem capitalizar a primeira letra de cada palavra *exceto*
a primeira palavra e não usar separadores.

<?code-excerpt "style_good.dart (misc-names)"?>
```dart tag=good
var count = 3;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
```


### PREFIRA usar `lowerCamelCase` para nomes de constantes

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

Você pode usar `SCREAMING_CAPS` para consistência com código existente, como nos
seguintes casos:

*   Ao adicionar código a um arquivo ou biblioteca que já usa `SCREAMING_CAPS`.
*   Ao gerar código Dart que é paralelo ao código Java, por exemplo, em tipos
    enumerados gerados a partir de [protobufs.][protobufs.]

:::note
Inicialmente, usamos o estilo `SCREAMING_CAPS` do Java para constantes. Mudamos
por alguns motivos:

*   `SCREAMING_CAPS` parece ruim em muitos casos, principalmente valores de enum
    para coisas como cores CSS.
*   As constantes costumam ser alteradas para variáveis finais não constantes,
    o que exigiria uma alteração de nome.
*   A propriedade `values` definida em um tipo enum é const e minúscula.

:::

[protobufs.]: {{site.pub-pkg}}/protobuf

###  CAPITULIZE acrônimos e abreviações com mais de duas letras como palavras

Acrônimos capitalizados podem ser difíceis de ler,
e vários acrônimos adjacentes
podem levar a nomes ambíguos. Por exemplo, dado um
identificador `HTTPSFTP`, o
leitor não consegue dizer se ele se refere
a `HTTPS` `FTP` ou `HTTP` `SFTP`. Para
evitar isso, capitalize a maioria dos acrônimos e abreviações como palavras
regulares. Este identificador seria `HttpsFtp` se referindo ao primeiro ou
`HttpSftp` para o último.

Abreviações e acrônimos de duas letras são a exceção. Se ambas as letras são
capitalizadas em inglês, então elas devem permanecer capitalizadas quando usadas
em um identificador. Caso contrário,
capitalize-a como uma palavra.

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
Ave // "avenue"

Id // "identifier"
Tv // "television"
Ui // "user interface"

MR // "mister"
ST // "street"
RD // "road"
```

Quando qualquer forma de abreviação vem no início de um identificador
`lowerCamelCase`, a abreviação deve ser toda em minúsculas:

```dart
var httpConnection = connect();
var tvSet = Television();
var mrRogers = 'hello, neighbor';
```

### PREFIRA usar `_`, `__`, etc. para parâmetros de callback não utilizados

Às vezes, a assinatura de tipo de uma função de callback requer um parâmetro, mas
a implementação do callback não *usa* o parâmetro. Nesse caso, é idiomático nomear
o parâmetro não utilizado `_`. Se a função tiver vários parâmetros não utilizados,
use underscores adicionais para evitar
colisões de nomes: `__`, `___`, etc.

<?code-excerpt "style_good.dart (unused-callback-params)"?>
```dart tag=good
futureOfVoid.then((_) {
  print('Operação concluída.');
});
```

Esta diretriz é apenas para funções que são *anônimas e locais*. Essas funções
geralmente são usadas imediatamente em um contexto onde fica claro o que o
parâmetro não utilizado representa. Em contraste, as declarações de funções e
métodos de nível superior não têm esse contexto, então seus parâmetros devem ser
nomeados para que fique claro para que serve cada parâmetro, mesmo que não seja
usado.


### NÃO use um underscore inicial para identificadores que não são privados

O Dart usa um underscore inicial em um identificador para marcar membros e
declarações de nível superior como privados. Isso treina os usuários a associar
um underscore inicial a um desses tipos de declarações. Eles veem "_" e pensam "privado".

Não existe o conceito de "privado" para variáveis locais, parâmetros, funções
locais ou prefixos de biblioteca. Quando um deles tem um nome que começa com um
underscore, ele envia um sinal confuso ao leitor. Para evitar isso, não use
underscores iniciais nesses nomes.


### NÃO use letras de prefixo

A [notação húngara](https://en.wikipedia.org/wiki/Hungarian_notation) e outros
esquemas surgiram na época do BCPL, quando o compilador não fazia muito para
ajudá-lo a entender seu código. Como o Dart pode informar o tipo, escopo,
mutabilidade e outras propriedades de suas declarações, não há motivo para
codificar essas propriedades em nomes de identificadores.

```dart tag=good
defaultTimeout
```

```dart tag=bad
kDefaultTimeout
```

### NÃO nomeie explicitamente as bibliotecas

Anexar um nome à diretiva `library` é tecnicamente possível, mas é um recurso
legado e desencorajado.

O Dart gera uma tag exclusiva para cada biblioteca com base em seu caminho e nome
de arquivo. Nomear bibliotecas substitui esse URI gerado. Sem o URI, pode ser
mais difícil para as ferramentas encontrar o arquivo
principal da biblioteca em
questão.

<?code-excerpt "usage_bad.dart (library-dir)"?>
```dart tag=bad
library my_library;
```

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// Uma ótima biblioteca de teste.
@TestOn('browser')
library;
```

## Ordenação

Para manter o preâmbulo do seu arquivo organizado, temos uma ordem prescrita que
as diretivas devem aparecer. Cada "seção" deve ser separada por uma linha em branco.

Uma única regra do linter lida com todas as diretrizes de ordenação:
[directives_ordering.](/tools/linter-rules/directives_ordering)


### COLOQUE as importações `dart:` antes de outras importações

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
```


### COLOQUE as importações `package:` antes das importações relativas

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
```


### ESPECIFIQUE as exportações em uma seção separada após todas as importações

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


### CLASSIFIQUE as seções alfabeticamente

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

Como muitas linguagens, o Dart ignora espaços em branco. No entanto, os *humanos*
não. Ter um estilo de espaço em branco consistente ajuda a garantir que os
leitores humanos vejam o código da mesma forma que o compilador.


### FORMATE seu código usando `dart format`

A formatação é um trabalho tedioso e é particularmente demorado durante a
refatoração. Felizmente, você não precisa se preocupar com isso. Nós fornecemos
um sofisticado formatador de código automatizado chamado [`dart format`][`dart format`] que
faz isso por você. As regras oficiais de tratamento de espaços em branco para
Dart são *tudo o que `dart format` produz*. O [formatter FAQ][formatter FAQ] pode fornecer
mais informações sobre as escolhas de estilo que ele impõe.

As diretrizes de formatação restantes são para as poucas coisas que `dart format`
não pode corrigir para você.

[`dart format`]: /tools/dart-format
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ

### CONSIDERE alterar seu código para torná-lo mais amigável ao formatador

O formatador faz o melhor que pode com qualquer código que você jogue nele, mas
não pode fazer milagres. Se o seu código tiver identificadores particularmente
longos, expressões profundamente aninhadas, uma mistura de diferentes tipos de
operadores, etc., a saída formatada ainda pode ser difícil de ler.

Quando isso acontecer, reorganize ou simplifique seu código. Considere encurtar
um nome de variável local ou elevar uma expressão para uma nova variável local.
Em outras palavras, faça os mesmos tipos de modificações que você faria se
estivesse formatando o código manualmente e tentando torná-lo mais legível. Pense
em `dart format` como uma parceria onde vocês trabalham juntos, às vezes
iterativamente, para produzir um código bonito.


### EVITE linhas com mais de 80 caracteres

{% render 'linter-rule-mention.md', rules:'lines_longer_than_80_chars' %}

Estudos de legibilidade mostram que longas linhas de texto são mais difíceis de
ler porque seu olho tem que viajar mais longe ao se mover para o início da
próxima linha. É por isso que jornais e revistas usam várias colunas de texto.

Se você realmente se vir querendo linhas com mais de 80 caracteres, nossa
experiência é que seu código provavelmente é muito verboso e pode ser um pouco
mais compacto. O principal ofensor geralmente é `VeryLongCamelCaseClassNames`.
Pergunte a si mesmo: "Cada palavra nesse nome de tipo me diz algo crítico ou
impede uma colisão de nome?" Caso contrário, considere omiti-lo.

Observe que `dart format` faz 99% disso para você, mas o último 1% é você. Ele
não divide literais de string longas para caber em 80 colunas, então você tem
que fazer isso manualmente.

**Exceção:** Quando um URI ou caminho de arquivo ocorre em um comentário ou string
(geralmente em uma importação ou exportação), ele pode permanecer inteiro mesmo
que faça com que a linha ultrapasse 80 caracteres. Isso torna mais fácil pesquisar arquivos de origem por um caminho.

**Exceção:** Strings de várias linhas podem conter linhas com mais de 80
caracteres porque as novas linhas são significativas dentro da string e dividir
as linhas em linhas mais curtas pode alterar o programa.

<a id="do-use-curly-braces-for-all-flow-control-structures"></a>
### USE chaves para todas as instruções de controle de fluxo

{% render 'linter-rule-mention.md', rules:'curly_braces_in_flow_control_structures' %}

Isso evita o problema do [dangling else][dangling else].

[dangling else]: https://en.wikipedia.org/wiki/Dangling_else

<?code-excerpt "style_good.dart (curly-braces)"?>
```dart tag=good
if (isWeekDay) {
  print('Vá de bicicleta para o trabalho!');
} else {
  print('Vá dançar ou leia um livro!');
}
```

**Exceção:** Quando você tem uma instrução `if` sem cláusula `else` e toda a
instrução `if` cabe em uma linha, você pode omitir as chaves se preferir:

<?code-excerpt "style_good.dart (one-line-if)"?>
```dart tag=good
if (arg == null) return defaultValue;
```

Se o corpo for para a próxima linha, no entanto, use chaves:

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
