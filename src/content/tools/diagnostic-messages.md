---
ia-translate: true
title: Mensagens de diagnóstico
description: Detalhes para diagnósticos produzidos pelo analisador Dart.
body_class: highlight-diagnostics
skipFreshness: true
---
{%- comment %}
AVISO: NÃO EDITE este arquivo diretamente. Ele é gerado automaticamente pelo script em
`pkg/analyzer/tool/diagnostics/generate.dart` no repositório sdk.
Instruções de atualização: https://github.com/dart-lang/site-www/issues/1949
{% endcomment -%}

Esta página lista as mensagens de diagnóstico produzidas pelo analisador Dart,
com detalhes sobre o que essas mensagens significam e como você pode corrigir seu código.
Para mais informações sobre o analisador, veja
[Personalizando a análise estática](/tools/analysis).

[contexto constante]: /resources/glossary#constant-context-contexto-constante
[atribuição definitiva]: /resources/glossary#definite-assignment
[aplicação de mixin]: /resources/glossary#mixin-application-aplicação-de-mixin
[inferência de override]: /resources/glossary#override-inference
[arquivo part]: /resources/glossary#part-file-arquivo-de-parte
[potencialmente não anulável]: /resources/glossary#potentially-non-nullable-potencialmente-não-anulável
[biblioteca pública]: /resources/glossary#public-library-biblioteca-pública

## Diagnósticos {:#diagnostics}

O analisador produz os seguintes diagnósticos para código que
não está em conformidade com a especificação da linguagem ou
que pode funcionar de maneiras inesperadas.

[tipo bottom]: https://dartbrasil.dev/null-safety/understanding-null-safety#top-and-bottom
[debugPrint]: https://api.flutter.dev/flutter/foundation/debugPrint.html
[ffi]: https://dartbrasil.dev/interop/c-interop
[IEEE 754]: https://en.wikipedia.org/wiki/IEEE_754
[padrão irrefutável]: https://dartbrasil.dev/resources/glossary#irrefutable-pattern
[kDebugMode]: https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
[meta-doNotSubmit]: https://pub.dev/documentation/meta/latest/meta/doNotSubmit-constant.html
[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
[meta-immutable]: https://pub.dev/documentation/meta/latest/meta/immutable-constant.html
[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
[meta-mustBeConst]: https://pub.dev/documentation/meta/latest/meta/mustBeConst-constant.html
[meta-mustCallSuper]: https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html
[meta-optionalTypeArgs]: https://pub.dev/documentation/meta/latest/meta/optionalTypeArgs-constant.html
[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
[meta-useResult]: https://pub.dev/documentation/meta/latest/meta/useResult-constant.html
[meta-UseResult]: https://pub.dev/documentation/meta/latest/meta/UseResult-class.html
[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
[meta-visibleForTesting]: https://pub.dev/documentation/meta/latest/meta/visibleForTesting-constant.html
[package-logging]: https://pub.dev/packages/logging
[padrão refutável]: https://dartbrasil.dev/resources/glossary#refutable-pattern

### abi_specific_integer_invalid {:#abi_specific_integer_invalid}

_Classes que estendem 'AbiSpecificInteger' devem ter exatamente um construtor const,
nenhum outro membro e nenhum parâmetro de tipo._

#### Descrição

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` não atende a todos os seguintes requisitos:
- deve haver exatamente um construtor
- o construtor deve ser marcado como `const`
- não deve haver nenhum membro além do único construtor
- não deve haver nenhum parâmetro de tipo

#### Exemplos

O código a seguir produz este diagnóstico porque a classe `C` não
define um construtor const:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
}
```

O código a seguir produz este diagnóstico porque o construtor não é
um construtor `const`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  C();
}
```

O código a seguir produz este diagnóstico porque a classe `C` define
vários construtores:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  const C.zero();
  const C.one();
}
```

O código a seguir produz este diagnóstico porque a classe `C` define
um campo:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  final int i;

  const C(this.i);
}
```

O código a seguir produz este diagnóstico porque a classe `C` tem um
parâmetro de tipo:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!]<T> extends AbiSpecificInteger { // parâmetros de tipo
  const C();
}
```

#### Correções comuns

Altere a classe para que ela atenda aos requisitos de não ter parâmetros
de tipo e um único membro que seja um construtor `const`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```

### abi_specific_integer_mapping_extra {:#abi_specific_integer_mapping_extra}

_Classes que estendem 'AbiSpecificInteger' devem ter exatamente uma
anotação 'AbiSpecificIntegerMapping' especificando o mapeamento de ABI para um inteiro 'NativeType' com um tamanho fixo._

#### Descrição

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` tem mais de uma
anotação `AbiSpecificIntegerMapping`.

#### Exemplo

O código a seguir produz este diagnóstico porque existem duas
anotações `AbiSpecificIntegerMapping` na classe `C`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
@[!AbiSpecificIntegerMapping!]({Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```

#### Correções comuns

Remova todas, exceto uma das anotações, mesclando os argumentos conforme
apropriado:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8(), Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```

### abi_specific_integer_mapping_missing {:#abi_specific_integer_mapping_missing}

_Classes que estendem 'AbiSpecificInteger' devem ter exatamente uma
anotação 'AbiSpecificIntegerMapping' especificando o mapeamento de ABI para um inteiro 'NativeType' com um tamanho fixo._

#### Descrição

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` não tem uma
anotação `AbiSpecificIntegerMapping`.

#### Exemplo

O código a seguir produz este diagnóstico porque não há
anotação `AbiSpecificIntegerMapping` na classe `C`:

```dart
import 'dart:ffi';

final class [!C!] extends AbiSpecificInteger {
  const C();
}
```

#### Correções comuns

Adicione uma anotação `AbiSpecificIntegerMapping` à classe:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```

### abi_specific_integer_mapping_unsupported {:#abi_specific_integer_mapping_unsupported}

_Mapeamento inválido para '{0}'; apenas mapeamentos para 'Int8', 'Int16', 'Int32', 'Int64',
'Uint8', 'Uint16', 'UInt32' e 'Uint64' são suportados._

#### Descrição

O analisador produz este diagnóstico quando um valor no argumento map de
uma anotação `AbiSpecificIntegerMapping` é diferente de um dos
seguintes tipos de inteiros:
- `Int8`
- `Int16`
- `Int32`
- `Int64`
- `Uint8`
- `Uint16`
- `UInt32`
- `Uint64`

#### Exemplo

O código a seguir produz este diagnóstico porque o valor da entrada do map
é `Array<Uint8>`, que não é um tipo inteiro válido:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : [!Array<Uint8>(4)!]})
final class C extends AbiSpecificInteger {
  const C();
}
```

#### Correções comuns

Use um dos tipos válidos como um valor no mapa:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```

### abstract_field_initializer {:#abstract_field_initializer}

_Campos abstratos não podem ter inicializadores._

#### Descrição

O analisador produz este diagnóstico quando um campo que tem o modificador
`abstract` também tem um inicializador.

#### Exemplos

O código a seguir produz este diagnóstico porque `f` está marcado como
`abstract` e tem um inicializador:

```dart
abstract class C {
  abstract int [!f!] = 0;
}
```

O código a seguir produz este diagnóstico porque `f` está marcado como
`abstract` e há um inicializador no construtor:

```dart
abstract class C {
  abstract int f;

  C() : [!f!] = 0;
}
```

#### Correções comuns

Se o campo precisar ser abstrato, remova o inicializador:

```dart
abstract class C {
  abstract int f;
}
```

Se o campo não precisar ser abstrato, remova a palavra-chave:

```dart
abstract class C {
  int f = 0;
}
```

### abstract_sealed_class {:#abstract_sealed_class}

_Uma classe 'sealed' não pode ser marcada como 'abstract' porque já é implicitamente
abstrata._

#### Descrição

O analisador produz este diagnóstico quando uma classe é declarada usando ambos
o modificador `abstract` e o modificador `sealed`. Classes seladas são
implicitamente abstratas, portanto, usar explicitamente ambos os modificadores não é permitido.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `C` é
declarada usando `abstract` e `sealed`:

```dart
abstract [!sealed!] class C {}
```

#### Correções comuns

Se a classe deve ser abstrata, mas não selada, remova o modificador
`sealed`:

```dart
abstract class C {}
```

Se a classe deve ser abstrata e selada, remova o
modificador `abstract`:

```dart
sealed class C {}
```

### abstract_super_member_reference {:#abstract_super_member_reference}

_O {0} '{1}' é sempre abstrato no supertipo._

#### Descrição

O analisador produz este diagnóstico quando um membro herdado é
referenciado usando `super`, mas não há implementação concreta do
membro na cadeia de superclasse. Membros abstratos não podem ser invocados.

#### Exemplo

O código a seguir produz este diagnóstico porque `B` não herda uma
implementação concreta de `a`:

```dart
abstract class A {
  int get a;
}
class B extends A {
  int get a => super.[!a!];
}
```

#### Correções comuns

Remova a invocação do membro abstrato, possivelmente substituindo-a por uma
invocação de um membro concreto.

### ambiguous_export {:#ambiguous_export}

_O nome '{0}' é definido nas bibliotecas '{1}' e '{2}'._

#### Descrição

O analisador produz este diagnóstico quando duas ou mais diretivas de
exportação fazem com que o mesmo nome seja exportado de várias bibliotecas.

#### Exemplo

Dado um arquivo `a.dart` contendo

```dart
class C {}
```

E um arquivo `b.dart` contendo

```dart
class C {}
```

O código a seguir produz este diagnóstico porque o nome `C` está sendo
exportado de `a.dart` e `b.dart`:

```dart
export 'a.dart';
export [!'b.dart'!];
```

#### Correções comuns

Se nenhum dos nomes em uma das bibliotecas precisar ser exportado,
remova as diretivas de exportação desnecessárias:

```dart
export 'a.dart';
```

Se todas as diretivas de exportação forem necessárias, oculte o nome em todas,
exceto uma das diretivas:

```dart
export 'a.dart';
export 'b.dart' hide C;
```

### ambiguous_extension_member_access {:#ambiguous_extension_member_access}

_Um membro chamado '{0}' é definido em '{1}' e '{2}', e nenhum é mais
específico._

_Um membro chamado '{0}' é definido em {1}, e nenhum é mais específico._

#### Descrição

Quando o código se refere a um membro de um objeto (por exemplo, `o.m()` ou `o.m` ou
`o[i]`) onde o tipo estático de `o` não declara o membro (`m` ou
`[]`, por exemplo), então o analisador tenta encontrar o membro em um
extension (extensão). Por exemplo, se o membro for `m`, o analisador procura
extensions que declaram um membro chamado `m` e têm um tipo estendido que
o tipo estático de `o` pode ser atribuído. Quando há mais de um desses
extension no escopo, a extension cujo tipo estendido é mais específico é
selecionada.

O analisador produz este diagnóstico quando nenhuma das extensions tem um
tipo estendido que seja mais específico do que os tipos estendidos de todas as
outras extensions, tornando a referência ao membro ambígua.

#### Exemplo

O código a seguir produz este diagnóstico porque não há como
escolher entre o membro em `E1` e o membro em `E2`:

```dart
extension E1 on String {
  int get charCount => 1;
}

extension E2 on String {
  int get charCount => 2;
}

void f(String s) {
  print(s.[!charCount!]);
}
```

#### Correções comuns

Se você não precisar de ambas as extensions, pode excluir ou ocultar uma delas.

Se você precisar de ambas, selecione explicitamente aquela que deseja usar
usando uma substituição de extension:

```dart
extension E1 on String {
  int get charCount => length;
}

extension E2 on String {
  int get charCount => length;
}

void f(String s) {
  print(E2(s).charCount);
}
```

### ambiguous_import {:#ambiguous_import}

_O nome '{0}' é definido nas bibliotecas {1}._

#### Descrição

O analisador produz este diagnóstico quando um nome é referenciado que é
declarado em duas ou mais bibliotecas importadas.

#### Exemplo

Dada uma biblioteca (`a.dart`) que define uma classe (`C` neste exemplo):

```dart
class A {}
class C {}
```

E uma biblioteca (`b.dart`) que define uma classe diferente com o mesmo nome:

```dart
class B {}
class C {}
```

O código a seguir produz este diagnóstico:

```dart
import 'a.dart';
import 'b.dart';

void f([!C!] c1, [!C!] c2) {}
```

#### Correções comuns

Se alguma das bibliotecas não for necessária, remova as diretivas de importação
para elas:

```dart
import 'a.dart';

void f(C c1, C c2) {}
```

Se o nome ainda for definido por mais de uma biblioteca, adicione uma cláusula
`hide` às diretivas de importação para todas, exceto uma biblioteca:

```dart
import 'a.dart' hide C;
import 'b.dart';

void f(C c1, C c2) {}
```

Se você precisar referenciar mais de um desses tipos, adicione um prefixo
a cada uma das diretivas de importação e qualifique as referências com o
prefixo apropriado:

```dart
import 'a.dart' as a;
import 'b.dart' as b;

void f(a.C c1, b.C c2) {}
```

### ambiguous_set_or_map_literal_both {:#ambiguous_set_or_map_literal_both}

_O literal não pode ser um mapa ou um set porque contém pelo menos uma
entrada de mapa literal ou um operador spread espalhando um 'Map', e pelo menos um elemento que não é nenhum deles._

#### Descrição

Como os literais de mapa e set usam os mesmos delimitadores (`{` e `}`), o
analisador analisa os argumentos de tipo e os elementos para determinar qual
tipo de literal você quis dizer. Quando não há argumentos de tipo, o
analisador usa os tipos dos elementos. Se todos os elementos forem literais
entradas de mapa e todos os operadores spread estiverem espalhando um `Map`, então é
um `Map`. Se nenhum dos elementos for uma entrada de mapa literal e todos os
operadores spread estiverem espalhando um `Iterable`, então é um `Set`. Se nenhum
desses for verdadeiro, então é ambíguo.

O analisador produz este diagnóstico quando pelo menos um elemento é uma
entrada de mapa literal ou um operador spread espalhando um `Map`, e pelo menos um
elemento não é nenhum desses, tornando impossível para o analisador
determinar se você está escrevendo um literal de mapa ou um literal de set.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    [!{...a, ...b, ...c}!];
```

A lista `b` só pode ser espalhada em um set, e os mapas `a` e `c` podem
só pode ser espalhado em um mapa, e o literal não pode ser ambos.

#### Correções comuns

Existem duas maneiras comuns de corrigir esse problema. A primeira é remover todos
os elementos spread de um tipo ou outro, para que os elementos sejam
consistente. Nesse caso, isso provavelmente significa remover a lista e decidir
o que fazer sobre o parâmetro agora não utilizado:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    {...a, ...c};
```

A segunda correção é alterar os elementos de um tipo em elementos que são
consistente com os outros elementos. Por exemplo, você pode adicionar os elementos
da lista como chaves que mapeiam para si mesmas:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    {...a, for (String s in b) s: s, ...c};
```

### ambiguous_set_or_map_literal_either {:#ambiguous_set_or_map_literal_either}

_Este literal deve ser um mapa ou um set, mas os elementos não têm informações suficientes
para a inferência de tipo funcionar._

#### Descrição

Como os literais de mapa e set usam os mesmos delimitadores (`{` e `}`), o
analisador analisa os argumentos de tipo e os elementos para determinar qual
tipo de literal você quis dizer. Quando não há argumentos de tipo e todos os
elementos são elementos spread (que são permitidos em ambos os tipos de literais)
então o analisador usa os tipos das expressões que estão sendo espalhadas.
Se todas as expressões tiverem o tipo `Iterable`, então é um set
literal; se todos eles tiverem o tipo `Map`, então é um literal de mapa.

Este diagnóstico é produzido quando nenhuma das expressões que estão sendo espalhadas tem
um tipo que permite que o analisador decida se você estava escrevendo um mapa
literal ou um literal de set.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
union(a, b) => [!{...a, ...b}!];
```

O problema ocorre porque não há argumentos de tipo e não há
informações sobre o tipo de `a` ou `b`.

#### Correções comuns

Existem três maneiras comuns de corrigir esse problema. A primeira é adicionar
argumentos de tipo para o literal. Por exemplo, se o literal se destina a ser um
literal de mapa, você pode escrever algo como isto:

```dart
union(a, b) => <String, String>{...a, ...b};
```

A segunda correção é adicionar informações de tipo para que as expressões tenham
o tipo `Iterable` ou o tipo `Map`. Você pode adicionar uma conversão explícita
ou, neste caso, adicione tipos às declarações dos dois parâmetros:

```dart
union(List<int> a, List<int> b) => {...a, ...b};
```

A terceira correção é adicionar informações de contexto. Neste caso, isso significa
adicionar um tipo de retorno à função:

```dart
Set<String> union(a, b) => {...a, ...b};
```

Em outros casos, você pode adicionar um tipo em outro lugar. Por exemplo, diga que o
código original se parece com isto:

```dart
union(a, b) {
  var x = [!{...a, ...b}!];
  return x;
}
```

Você pode adicionar uma anotação de tipo em `x`, assim:

```dart
union(a, b) {
  Map<String, String> x = {...a, ...b};
  return x;
}
```

### annotation_on_pointer_field {:#annotation_on_pointer_field}

_Campos em uma classe struct cujo tipo é 'Pointer' não devem ter
anotações._

#### Descrição

O analisador produz este diagnóstico quando um campo que é declarado em um
subclasse de `Struct` e tem o tipo `Pointer` também tem uma anotação
associado a ele.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `p`, que
tem o tipo `Pointer` e é declarado em uma subclasse de `Struct`, tem o
anotação `@Double()`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external Pointer<Int8> p;
}
```

#### Correções comuns

Remova as anotações do campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  external Pointer<Int8> p;
}
```

### argument_must_be_a_constant {:#argument_must_be_a_constant}

_O argumento '{0}' deve ser uma constante._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de
`Pointer.asFunction` ou `DynamicLibrary.lookupFunction` tem um argumento `isLeaf`
cujo valor não é uma expressão constante.

O analisador também produz este diagnóstico quando uma invocação de
`Pointer.fromFunction` ou `NativeCallable.isolateLocal` tem um
argumento `exceptionalReturn` cujo valor não é uma expressão constante.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o valor do
argumento `isLeaf` é um parâmetro e, portanto, não é uma constante:

```dart
import 'dart:ffi';

int Function(int) fromPointer(
    Pointer<NativeFunction<Int8 Function(Int8)>> p, bool isLeaf) {
  return p.asFunction(isLeaf: [!isLeaf!]);
}
```

#### Correções comuns

Se houver uma constante adequada que possa ser usada, substitua o argumento
com uma constante:

```dart
import 'dart:ffi';

const isLeaf = false;

int Function(int) fromPointer(Pointer<NativeFunction<Int8 Function(Int8)>> p) {
  return p.asFunction(isLeaf: isLeaf);
}
```

Se não houver uma constante adequada, substitua o argumento por um
literal booleano:

```dart
import 'dart:ffi';

int Function(int) fromPointer(Pointer<NativeFunction<Int8 Function(Int8)>> p) {
  return p.asFunction(isLeaf: true);
}
```

### argument_must_be_native {:#argument_must_be_native}

_O argumento para 'Native.addressOf' deve ser anotado com @Native_

#### Descrição

O analisador produz este diagnóstico quando o argumento passado para
`Native.addressOf` não é anotado com a anotação `Native`.

#### Exemplos

O código a seguir produz este diagnóstico porque o argumento para
`addressOf` é uma string, não um campo, e strings não podem ser anotadas:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf([!'f'!]));
}
```

O código a seguir produz este diagnóstico porque a função `f` é
sendo passada para `addressOf`, mas não é anotada como sendo `Native`:

```dart
import 'dart:ffi';

external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>([!f!]));
}
```

#### Correções comuns

Se o argumento não for um campo ou uma função, substitua o
argumento com um campo ou função que é anotado com `Native`:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>(f));
}
```

Se o argumento for um campo ou uma função, anote o campo
de função com `Native`:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>(f));
}
```

### argument_type_not_assignable {:#argument_type_not_assignable}

_O tipo do argumento '{0}' não pode ser atribuído ao tipo do parâmetro '{1}'. {2}_

#### Descrição

O analisador produz este diagnóstico quando o tipo estático de um argumento
não pode ser atribuído ao tipo estático do parâmetro correspondente.

#### Exemplo

O código a seguir produz este diagnóstico porque um `num` não pode ser
atribuído a uma `String`:

```dart
String f(String x) => x;
String g(num y) => f([!y!]);
```

#### Correções comuns

Se possível, reescreva o código para que o tipo estático seja atribuível. No
exemplo acima, você pode mudar o tipo do parâmetro `y`:

```dart
String f(String x) => x;
String g(String y) => f(y);
```

Se essa correção não for possível, adicione código para lidar com o caso em que o
valor do argumento não é o tipo exigido. Uma abordagem é forçar outros
tipos para o tipo necessário:

```dart
String f(String x) => x;
String g(num y) => f(y.toString());
```

Outra abordagem é adicionar testes de tipo explícitos e código de fallback:

```dart
String f(String x) => x;
String g(Object y) => f(y is String ? y : '');
```

Se você acredita que o tipo de tempo de execução do argumento sempre será o
mesmo que o tipo estático do parâmetro, e você está disposto a arriscar ter
uma exceção lançada em tempo de execução se você estiver errado, adicione uma conversão explícita:

```dart
String f(String x) => x;
String g(num y) => f(y as String);
```

### argument_type_not_assignable_to_error_handler {:#argument_type_not_assignable_to_error_handler}

_O tipo do argumento '{0}' não pode ser atribuído ao tipo do parâmetro '{1}
Function(Object)' ou '{1} Function(Object, StackTrace)'.
_

#### Descrição

O analisador produz este diagnóstico quando uma invocação de
`Future.catchError` tem um argumento que é uma função cujos parâmetros
não são compatíveis com os argumentos que serão passados para a função
quando ela for invocada. O tipo estático do primeiro argumento para `catchError`
é apenas `Function`, mesmo que a função que é passada deva ter um único
parâmetro do tipo `Object` ou dois parâmetros dos tipos `Object` e `StackTrace`.

#### Exemplos

O código a seguir produz este diagnóstico porque o closure sendo
passado para `catchError` não recebe nenhum parâmetro, mas a função
é obrigado a receber pelo menos um parâmetro:

```dart
void f(Future<int> f) {
  f.catchError([!() => 0!]);
}
```

O código a seguir produz este diagnóstico porque o closure sendo
passado para `catchError` recebe três parâmetros, mas não pode ter mais de
dois parâmetros obrigatórios:

```dart
void f(Future<int> f) {
  f.catchError([!(one, two, three) => 0!]);
}
```

O código a seguir produz este diagnóstico porque, mesmo que o closure
sendo passado para `catchError` recebe um parâmetro, o closure não tem
um tipo que seja compatível com `Object`:

```dart
void f(Future<int> f) {
  f.catchError([!(String error) => 0!]);
}
```

#### Correções comuns

Altere a função que está sendo passada para `catchError` para que ela tenha um ou
dois parâmetros obrigatórios e os parâmetros tenham os tipos necessários:

```dart
void f(Future<int> f) {
  f.catchError((Object error) => 0);
}
```

### assert_in_redirecting_constructor {:#assert_in_redirecting_constructor}

_Um construtor de redirecionamento não pode ter um inicializador 'assert'._

#### Descrição

O analisador produz este diagnóstico quando um construtor de redirecionamento (a
construtor que redireciona para outro construtor na mesma classe) tem um
assert na lista de inicializadores.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor sem nome
é um construtor de redirecionamento e também tem um assert no inicializador
lista:

```dart
class C {
  C(int x) : [!assert(x > 0)!], this.name();
  C.name() {}
}
```

#### Correções comuns

Se o assert não for necessário, remova-o:

```dart
class C {
  C(int x) : this.name();
  C.name() {}
}
```

Se o assert for necessário, converta o construtor em um factory
construtor:

```dart
class C {
  factory C(int x) {
    assert(x > 0);
    return C.name();
  }
  C.name() {}
}
```

### asset_directory_does_not_exist {:#asset_directory_does_not_exist}

_O diretório de assets '{0}' não existe._

#### Descrição

O analisador produz este diagnóstico quando uma lista de assets contém um valor
referenciando um diretório que não existe.

#### Exemplo

Assumindo que o diretório `assets` não existe, o código a seguir
produz este diagnóstico porque ele está listado como um diretório contendo
assets:

```yaml
name: example
flutter:
  assets:
    - [!assets/!]
```

#### Correções comuns

Se o caminho estiver correto, crie um diretório nesse caminho.

Se o caminho não estiver correto, altere o caminho para corresponder ao caminho do
diretório contendo os assets.

### asset_does_not_exist {:#asset_does_not_exist}

_O arquivo de asset '{0}' não existe._

#### Descrição

O analisador produz este diagnóstico quando uma lista de assets contém um valor
referenciando um arquivo que não existe.

#### Exemplo

Assumindo que o arquivo `doesNotExist.gif` não existe, o código a seguir
produz este diagnóstico porque ele está listado como um asset:

```yaml
name: example
flutter:
  assets:
    - [!doesNotExist.gif!]
```

#### Correções comuns

Se o caminho estiver correto, crie um arquivo nesse caminho.

Se o caminho não estiver correto, altere o caminho para corresponder ao caminho do
arquivo contendo o asset.

### asset_field_not_list {:#asset_field_not_list}

_Espera-se que o valor do campo 'assets' seja uma lista de arquivos
caminhos relativos._

#### Descrição

O analisador produz este diagnóstico quando o valor da chave `assets`
não é uma lista.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor do
chave `assets` é uma string quando uma lista é esperada:

```yaml
name: example
flutter:
  assets: [!assets/!]
```

#### Correções comuns

Altere o valor da lista de assets para que seja uma lista:

```yaml
name: example
flutter:
  assets:
    - assets/
```

### asset_missing_path {:#asset_missing_path}

_A entrada do mapa de assets deve conter um campo 'path'._

#### Descrição

O analisador produz este diagnóstico quando um mapa de assets está sem um valor
`path`.

#### Exemplo

O código a seguir produz este diagnóstico porque o mapa de assets está sem um
valor `path`:

```yaml
name: exemplo
flutter:
  assets:
    - flavors:
      - premium
```

#### Correções comuns

Altere o mapa de assets para que ele contenha um campo `path` com um valor string
(um caminho de arquivo no estilo POSIX válido):

```yaml
name: exemplo
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```

### asset_not_string {:#asset_not_string}

_Assets devem ser caminhos de arquivo (strings)._

#### Descrição

O analisador produz este diagnóstico quando uma lista `assets` contém um
valor que não é uma string.

#### Exemplo

O código a seguir produz este diagnóstico porque a lista `assets` contém um
mapa:

```yaml
name: exemplo
flutter:
  assets:
    - [!image.gif: true!]
```

#### Correções comuns

Altere a lista `assets` para que ela contenha apenas caminhos de arquivos
válidos no estilo POSIX:

```yaml
name: exemplo
flutter:
  assets:
    - assets/image.gif
```

### asset_not_string_or_map {:#asset_not_string_or_map}

_Um valor de asset deve ser um caminho de arquivo (string) ou um mapa._

#### Descrição

O analisador produz este diagnóstico quando um valor de asset não é uma
string ou um mapa.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor do asset é uma
lista:

```yaml
name: exemplo
flutter:
  assets:
    - [![one, two, three]!]
```

#### Correções comuns

Se você precisa especificar mais do que apenas o caminho para o asset, então substitua
o valor por um mapa com uma chave `path` (um caminho de arquivo no estilo POSIX válido):

```yaml
name: exemplo
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```

Se você precisa apenas especificar o caminho, então substitua o valor pelo
caminho para o asset (um caminho de arquivo no estilo POSIX válido):

```yaml
name: exemplo
flutter:
  assets:
    - assets/image.gif
```

### asset_path_not_string {:#asset_path_not_string}

_Caminhos de assets devem ser caminhos de arquivos (strings)._

#### Descrição

O analisador produz este diagnóstico quando um mapa de assets contém um
valor `path` que não é uma string.

#### Exemplo

O código a seguir produz este diagnóstico porque o mapa de assets contém
um valor `path` que é uma lista:

```yaml
name: exemplo
flutter:
  assets:
    - path: [![one, two, three]!]
      flavors:
      - premium
```

#### Correções comuns

Altere o mapa `asset` para que ele contenha um valor `path` que seja uma
string (um caminho de arquivo no estilo POSIX válido):

```yaml
name: exemplo
flutter:
  assets:
    - path: image.gif
      flavors:
      - premium
```

### assignment_of_do_not_store {:#assignment_of_do_not_store}

_'{0}' está marcado como 'doNotStore' e não deve ser atribuído a um campo ou
variável de nível superior._

#### Descrição

O analisador produz este diagnóstico quando o valor de uma função (incluindo
métodos e getters) que é explicitamente ou implicitamente marcada pela
anotação [`doNotStore`][meta-doNotStore] é armazenado em um campo ou variável
de nível superior.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor da função `f` está
sendo armazenado na variável de nível superior `x`:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 1;

var x = [!f()!];
```

#### Correções comuns

Substitua as referências ao campo ou variável por invocações da função que
produz o valor.

### assignment_to_const {:#assignment_to_const}

_Variáveis constantes não podem receber um valor._

#### Descrição

O analisador produz este diagnóstico quando encontra uma atribuição a uma
variável de nível superior, um campo estático ou uma variável local que tem
o modificador `const`. O valor de uma constante de tempo de compilação não
pode ser alterado em tempo de execução.

#### Exemplo

O código a seguir produz este diagnóstico porque `c` está recebendo um valor
mesmo que tenha o modificador `const`:

```dart
const c = 0;

void f() {
  [!c!] = 1;
  print(c);
}
```

#### Correções comuns

Se a variável deve ser atribuível, então remova o modificador `const`:

```dart
var c = 0;

void f() {
  c = 1;
  print(c);
}
```

Se a constante não deve ser alterada, então remova a atribuição ou use uma
variável local no lugar de referências à constante:

```dart
const c = 0;

void f() {
  var v = 1;
  print(v);
}
```

### assignment_to_final {:#assignment_to_final}

_'{0}' não pode ser usado como um setter porque é final._

#### Descrição

O analisador produz este diagnóstico quando encontra uma invocação de um
setter, mas não há setter porque o campo com o mesmo nome foi declarado como
`final` ou `const`.

#### Exemplo

O código a seguir produz este diagnóstico porque `v` é final:

```dart
class C {
  final v = 0;
}

f(C c) {
  c.[!v!] = 1;
}
```

#### Correções comuns

Se você precisar poder definir o valor do campo, então remova o modificador
`final` do campo:

```dart
class C {
  int v = 0;
}

f(C c) {
  c.v = 1;
}
```

### assignment_to_final_local {:#assignment_to_final_local}

_A variável final '{0}' só pode ser definida uma vez._

#### Descrição

O analisador produz este diagnóstico quando uma variável local que foi
declarada como final é atribuída depois de ter sido inicializada.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` é final, então não pode
ter um valor atribuído a ele após ter sido inicializado:

```dart
void f() {
  final x = 0;
  [!x!] = 3;
  print(x);
}
```

#### Correções comuns

Remova a palavra-chave `final` e substitua-a por `var` se não houver
anotação de tipo:

```dart
void f() {
  var x = 0;
  x = 3;
  print(x);
}
```

### assignment_to_final_no_setter {:#assignment_to_final_no_setter}

_Não há um setter chamado '{0}' na classe '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma referência a um setter é
encontrada; não há setter definido para o tipo; mas há um getter definido
com o mesmo nome.

#### Exemplo

O código a seguir produz este diagnóstico porque não há setter chamado `x`
em `C`, mas há um getter chamado `x`:

```dart
class C {
  int get x => 0;
  set y(int p) {}
}

void f(C c) {
  c.[!x!] = 1;
}
```

#### Correções comuns

Se você quiser invocar um setter existente, então corrija o nome:

```dart
class C {
  int get x => 0;
  set y(int p) {}
}

void f(C c) {
  c.y = 1;
}
```

Se você quiser invocar o setter, mas ele simplesmente não existe ainda, então
declare-o:

```dart
class C {
  int get x => 0;
  set x(int p) {}
  set y(int p) {}
}

void f(C c) {
  c.x = 1;
}
```

### assignment_to_function {:#assignment_to_function}

_Funções não podem receber um valor._

#### Descrição

O analisador produz este diagnóstico quando o nome de uma função aparece no
lado esquerdo de uma expressão de atribuição.

#### Exemplo

O código a seguir produz este diagnóstico porque a atribuição à função `f`
é inválida:

```dart
void f() {}

void g() {
  [!f!] = () {};
}
```

#### Correções comuns

Se o lado direito deve ser atribuído a outra coisa, como uma variável
local, então altere o lado esquerdo:

```dart
void f() {}

void g() {
  var x = () {};
  print(x);
}
```

Se a intenção é alterar a implementação da função, então defina uma variável
com valor de função em vez de uma função:

```dart
void Function() f = () {};

void g() {
  f = () {};
}
```

### assignment_to_method {:#assignment_to_method}

_Métodos não podem receber um valor._

#### Descrição

O analisador produz este diagnóstico quando o destino de uma atribuição é um
método.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` não pode receber um
valor porque é um método:

```dart
class C {
  void f() {}

  void g() {
    [!f!] = null;
  }
}
```

#### Correções comuns

Reescreva o código para que não haja uma atribuição a um método.

### assignment_to_type {:#assignment_to_type}

_Tipos não podem receber um valor._

#### Descrição

O analisador produz este diagnóstico quando o nome de um tipo aparece no
lado esquerdo de uma expressão de atribuição.

#### Exemplo

O código a seguir produz este diagnóstico porque a atribuição à classe `C`
é inválida:

```dart
class C {}

void f() {
  [!C!] = null;
}
```

#### Correções comuns

Se o lado direito deve ser atribuído a outra coisa, como uma variável
local, então altere o lado esquerdo:

```dart
void f() {}

void g() {
  var c = null;
  print(c);
}
```

### async_for_in_wrong_context {:#async_for_in_wrong_context}

_O loop async for-in só pode ser usado em uma função async._

#### Descrição

O analisador produz este diagnóstico quando um loop async for-in é encontrado
em uma função ou método cujo corpo não está marcado como sendo `async` ou
`async*`.

#### Exemplo

O código a seguir produz este diagnóstico porque o corpo de `f` não está
marcado como sendo `async` ou `async*`, mas `f` contém um loop async
for-in:

```dart
void f(list) {
  [!await!] for (var e in list) {
    print(e);
  }
}
```

#### Correções comuns

Se a função deve retornar um `Future`, então marque o corpo com `async`:

```dart
Future<void> f(list) async {
  await for (var e in list) {
    print(e);
  }
}
```

Se a função deve retornar um `Stream` de valores, então marque o corpo com
`async*`:

```dart
Stream<void> f(list) async* {
  await for (var e in list) {
    print(e);
  }
}
```

Se a função deve ser síncrona, então remova o `await` antes
do loop:

```dart
void f(list) {
  for (var e in list) {
    print(e);
  }
}
```

### await_in_late_local_variable_initializer {:#await_in_late_local_variable_initializer}

_A expressão 'await' não pode ser usada no inicializador de uma variável local 'late'._

#### Descrição

O analisador produz este diagnóstico quando uma variável local que tem o
modificador `late` usa uma expressão `await` no inicializador.

#### Exemplo

O código a seguir produz este diagnóstico porque uma expressão `await` é
usada no inicializador para `v`, uma variável local que está marcada como `late`:

```dart
Future<int> f() async {
  late var v = [!await!] 42;
  return v;
}
```

#### Correções comuns

Se o inicializador puder ser reescrito para não usar `await`, então reescreva-o:

```dart
Future<int> f() async {
  late var v = 42;
  return v;
}
```

Se o inicializador não puder ser reescrito, então remova o modificador `late`:

```dart
Future<int> f() async {
  var v = await 42;
  return v;
}
```

### await_of_incompatible_type {:#await_of_incompatible_type}

_A expressão 'await' não pode ser usada para uma expressão com um tipo de
extensão que não seja um subtipo de 'Future'._

#### Descrição

O analisador produz este diagnóstico quando o tipo da expressão em uma
expressão `await` é um tipo de extensão, e o tipo de extensão não é uma
subclasse de `Future`.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de extensão `E`
não é uma subclasse de `Future`:

```dart
extension type E(int i) {}

void f(E e) async {
  [!await!] e;
}
```

#### Correções comuns

Se o tipo de extensão estiver definido corretamente, então remova o `await`:

```dart
extension type E(int i) {}

void f(E e) {
  e;
}
```

Se o tipo de extensão for destinado a ser aguardável (awaitable), então
adicione `Future` (ou um subtipo de `Future`) à cláusula `implements`
(adicionando uma cláusula `implements` se já não houver uma) e faça o tipo
de representação corresponder:

```dart
extension type E(Future<int> i) implements Future<int> {}

void f(E e) async {
  await e;
}
```

### body_might_complete_normally {:#body_might_complete_normally}

_O corpo pode ser concluído normalmente, fazendo com que 'null' seja
retornado, mas o tipo de retorno, '{0}', é um tipo potencialmente não nulo._

#### Descrição

O analisador produz este diagnóstico quando um método ou função tem um tipo
de retorno que é [potencialmente não nulo][potencialmente não anulável] mas retornaria implicitamente
`null` se o controle atingisse o final da função.

#### Exemplos

O código a seguir produz este diagnóstico porque o método `m` tem um retorno
implícito de `null` inserido no final do método, mas o método é declarado
para não retornar `null`:

```dart
class C {
  int [!m!](int t) {
    print(t);
  }
}
```

O código a seguir produz este diagnóstico porque o método `m` tem um retorno
implícito de `null` inserido no final do método, mas como a classe `C` pode
ser instanciada com um argumento de tipo não nulo, o método é efetivamente
declarado para não retornar `null`:

```dart
class C<T> {
  T [!m!](T t) {
    print(t);
  }
}
```

#### Correções comuns

Se houver um valor razoável que possa ser retornado, então adicione uma
declaração `return` no final do método:

```dart
class C<T> {
  T m(T t) {
    print(t);
    return t;
  }
}
```

Se o método não atingir o retorno implícito, então adicione um `throw` no
final do método:

```dart
class C<T> {
  T m(T t) {
    print(t);
    throw '';
  }
}
```

Se o método intencionalmente retornar `null` no final, então adicione um
retorno explícito de `null` no final do método e altere o tipo de retorno
para que seja válido retornar `null`:

```dart
class C<T> {
  T? m(T t) {
    print(t);
    return null;
  }
}
```

### body_might_complete_normally_catch_error {:#body_might_complete_normally_catch_error}

_Este manipulador 'onError' deve retornar um valor atribuível a '{0}', mas
termina sem retornar um valor._

#### Descrição

O analisador produz este diagnóstico quando o closure (fechamento) passado
para o parâmetro `onError` do método `Future.catchError` é obrigado a
retornar um valor não-`null` (por causa do argumento de tipo do `Future`)
mas pode retornar implicitamente `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque o closure passado para o
método `catchError` é obrigado a retornar um `int`, mas não termina com um
`return` explícito, fazendo com que ele retorne implicitamente `null`:

```dart
void g(Future<int> f) {
  f.catchError((e, st) [!{!]});
}
```

#### Correções comuns

Se o closure deve às vezes retornar um valor não-`null`, então adicione um
retorno explícito ao closure:

```dart
void g(Future<int> f) {
  f.catchError((e, st) {
    return -1;
  });
}
```

Se o closure deve sempre retornar `null`, então altere o argumento de tipo
do `Future` para ser `void` ou `Null`:

```dart
void g(Future<void> f) {
  f.catchError((e, st) {});
}
```

### body_might_complete_normally_nullable {:#body_might_complete_normally_nullable}

_Esta função tem um tipo de retorno anulável de '{0}', mas termina sem
retornar um valor._

#### Descrição

O analisador produz este diagnóstico quando um método ou função pode
retornar implicitamente `null` ao cair no final. Embora este seja um código
Dart válido, é melhor que o retorno de `null` seja explícito.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f` retorna
implicitamente `null`:

```dart
String? [!f!]() {}
```

#### Correções comuns

Se o retorno de `null` for intencional, então torne-o explícito:

```dart
String? f() {
  return null;
}
```

Se a função deve retornar um valor não nulo ao longo desse caminho, então
adicione a declaração de retorno ausente:

```dart
String? f() {
  return '';
}
```

### break_label_on_switch_member {:#break_label_on_switch_member}

_Um label de break resolve para a declaração 'case' ou 'default'._

#### Descrição

O analisador produz este diagnóstico quando um break em uma cláusula case
dentro de uma declaração switch tem um label que está associado a outra cláusula case.

#### Exemplo

O código a seguir produz este diagnóstico porque o label `l` está associado
à cláusula case para `0`:

```dart
void f(int i) {
  switch (i) {
    l: case 0:
      break;
    case 1:
      break [!l!];
  }
}
```

#### Correções comuns

Se a intenção é transferir o controle para a declaração após o switch,
então remova o label da declaração break:

```dart
void f(int i) {
  switch (i) {
    case 0:
      break;
    case 1:
      break;
  }
}
```

Se a intenção é transferir o controle para um bloco case diferente, então
use `continue` em vez de `break`:

```dart
void f(int i) {
  switch (i) {
    l: case 0:
      break;
    case 1:
      continue l;
  }
}
```

### built_in_identifier_as_type {:#built_in_identifier_as_type}

_O identificador embutido '{0}' não pode ser usado como um tipo._

#### Descrição

O analisador produz este diagnóstico quando um identificador embutido é
usado onde um nome de tipo é esperado.

#### Exemplo

O código a seguir produz este diagnóstico porque `import` não pode ser usado
como um tipo porque é um identificador embutido:

```dart
[!import!]<int> x;
```

#### Correções comuns

Substitua o identificador embutido pelo nome de um tipo válido:

```dart
List<int> x;
```

### built_in_identifier_in_declaration {:#built_in_identifier_in_declaration}

_O identificador embutido '{0}' não pode ser usado como um nome de prefixo._

_O identificador embutido '{0}' não pode ser usado como um nome de tipo._

_O identificador embutido '{0}' não pode ser usado como um nome de parâmetro de tipo._

_O identificador embutido '{0}' não pode ser usado como um nome de typedef._

_O identificador embutido '{0}' não pode ser usado como um nome de extensão._

_O identificador embutido '{0}' não pode ser usado como um nome de tipo de extensão._

#### Descrição

O analisador produz este diagnóstico quando o nome usado na declaração de
uma classe, extensão, mixin, typedef, parâmetro de tipo ou prefixo de
importação é um identificador embutido. Identificadores embutidos não podem
ser usados para nomear nenhum desses tipos de declarações.

#### Exemplo

O código a seguir produz este diagnóstico porque `mixin` é um identificador
embutido:

```dart
extension [!mixin!] on int {}
```

#### Correções comuns

Escolha um nome diferente para a declaração.

### case_block_not_terminated {:#case_block_not_terminated}

_A última declaração do 'case' deve ser 'break', 'continue', 'rethrow',
'return' ou 'throw'._

#### Descrição

O analisador produz este diagnóstico quando a última declaração em um bloco
`case` não é um dos terminadores obrigatórios: `break`, `continue`,
`rethrow`, `return` ou `throw`.

#### Exemplo

O código a seguir produz este diagnóstico porque o bloco `case` termina com
uma atribuição:

```dart
void f(int x) {
  switch (x) {
    [!case!] 0:
      x += 2;
    default:
      x += 1;
  }
}
```

#### Correções comuns

Adicione um dos terminadores necessários:

```dart
void f(int x) {
  switch (x) {
    case 0:
      x += 2;
      break;
    default:
      x += 1;
  }
}
```

### case_expression_type_implements_equals {:#case_expression_type_implements_equals}

_O tipo da expressão do caso do switch '{0}' não pode sobrepor o operador '=='. _

#### Descrição

O analisador produz este diagnóstico quando o tipo da expressão após a
palavra-chave `case` tem uma implementação do operador `==` diferente da
que está em `Object`.

#### Exemplo

O código a seguir produz este diagnóstico porque a expressão após a
palavra-chave `case` (`C(0)`) tem o tipo `C`, e a classe `C` sobrepõe o
operador `==`:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  switch (c) {
    case [!C(0)!]:
      break;
  }
}
```

#### Correções comuns

Se não houver uma razão forte para não fazê-lo, então reescreva o código
para usar uma estrutura if-else:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  if (c == C(0)) {
    // ...
  }
}
```

Se você não puder reescrever a declaração switch e a implementação de `==`
não for necessária, então remova-a:

```dart
class C {
  final int value;

  const C(this.value);
}

void f(C c) {
  switch (c) {
    case C(0):
      break;
  }
}
```

Se você não puder reescrever a declaração switch e não puder remover a
definição de `==`, então encontre algum outro valor que possa ser usado para
controlar o switch:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  switch (c.value) {
    case 0:
      break;
  }
}
```

### case_expression_type_is_not_switch_expression_subtype {:#case_expression_type_is_not_switch_expression_subtype}

_O tipo da expressão do caso do switch '{0}' deve ser um subtipo do tipo da
expressão do switch '{1}'._

#### Descrição

O analisador produz este diagnóstico quando a expressão após `case` em uma
declaração `switch` tem um tipo estático que não é um subtipo do tipo
estático da expressão após `switch`.

#### Exemplo

O código a seguir produz este diagnóstico porque `1` é um `int`, que não é
um subtipo de `String` (o tipo de `s`):

```dart
void f(String s) {
  switch (s) {
    case [!1!]:
      break;
  }
}
```

#### Correções comuns

Se o valor da expressão `case` estiver errado, então altere a expressão
`case` para que ela tenha o tipo necessário:

```dart
void f(String s) {
  switch (s) {
    case '1':
      break;
  }
}
```

Se o valor da expressão `case` estiver correto, então altere a expressão
`switch` para ter o tipo necessário:

```dart
void f(int s) {
  switch (s) {
    case 1:
      break;
  }
}
```

### cast_from_nullable_always_fails {:#cast_from_nullable_always_fails}

_Este cast sempre lançará uma exceção porque a variável local anulável '{0}'
não está atribuída._

#### Descrição

O analisador produz este diagnóstico quando uma variável local que tem um
tipo anulável não foi atribuída e é convertida para um tipo não anulável.
Como a variável não foi atribuída, ela tem o valor padrão de `null`,
fazendo com que o cast lance uma exceção.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `x` é convertida
para um tipo não anulável (`int`) quando se sabe que ela tem o valor
`null`:

```dart
void f() {
  num? x;
  [!x!] as int;
  print(x);
}
```

#### Correções comuns

Se a variável deve ter um valor antes do cast, então adicione um
inicializador ou uma atribuição:

```dart
void f() {
  num? x = 3;
  x as int;
  print(x);
}
```

Se a variável não deve ser atribuída, então remova o cast:

```dart
void f() {
  num? x;
  print(x);
}
```

### cast_from_null_always_fails {:#cast_from_null_always_fails}

_Este cast sempre lança uma exceção porque a expressão sempre é avaliada como
'null'._

#### Descrição

O analisador produz este diagnóstico quando uma expressão cujo tipo é `Null`
está sendo convertida para um tipo não anulável.

#### Exemplo

O código a seguir produz este diagnóstico porque `n` é conhecido por sempre
ser `null`, mas está sendo convertido para um tipo não anulável:

```dart
void f(Null n) {
  [!n as int!];
}
```

#### Correções comuns

Remova o cast desnecessário:

```dart
void f(Null n) {
  n;
}
```

### cast_to_non_type {:#cast_to_non_type}

_O nome '{0}' não é um tipo, portanto, não pode ser usado em uma expressão 'as'._

#### Descrição

O analisador produz este diagnóstico quando o nome após o `as` em uma
expressão de cast é definido como algo diferente de um tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` é uma variável, não um
tipo:

```dart
num x = 0;
int y = x as [!x!];
```

#### Correções comuns

Substitua o nome pelo nome de um tipo:

```dart
num x = 0;
int y = x as int;
```

### class_used_as_mixin {:#class_used_as_mixin}

_A classe '{0}' não pode ser usada como um mixin porque não é uma mixin
class nem um mixin._

#### Descrição

O analisador produz este diagnóstico quando uma classe que não é uma `mixin
class` nem um `mixin` é usada em uma cláusula `with`.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `M` está sendo
usada como um mixin, mas não está definida como uma `mixin class`:

```dart
class M {}
class C with [!M!] {}
```

#### Correções comuns

Se a classe puder ser um mixin puro, então altere `class` para `mixin`:

```dart
mixin M {}
class C with M {}
```

Se a classe precisar ser tanto uma classe quanto um mixin, então adicione `mixin`:

```dart
mixin class M {}
class C with M {}
```

### collection_element_from_deferred_library {:#collection_element_from_deferred_library}

_Valores constantes de uma biblioteca adiada não podem ser usados como
chaves em um literal de mapa 'const'._

_Valores constantes de uma biblioteca adiada não podem ser usados como
valores em um construtor 'const'._

_Valores constantes de uma biblioteca adiada não podem ser usados como
valores em um literal de lista 'const'._

_Valores constantes de uma biblioteca adiada não podem ser usados como
valores em um literal de mapa 'const'._

_Valores constantes de uma biblioteca adiada não podem ser usados como
valores em um literal de conjunto 'const'._

#### Descrição

O analisador produz este diagnóstico quando um literal de coleção que é
explicitamente (porque é prefixado pela palavra-chave `const`) ou
implicitamente (porque aparece em um [contexto constante][contexto constante]) uma constante
contém um valor que é declarado em uma biblioteca que é importada usando
uma importação adiada. As constantes são avaliadas em tempo de compilação,
e os valores das bibliotecas adiadas não estão disponíveis em tempo de compilação.

Para mais informações, confira
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque o literal de lista
constante contém `a.zero`, que é importado usando uma importação `deferred`:

```dart
import 'a.dart' deferred as a;

var l = const [a.[!zero!]];
```

#### Correções comuns

Se o literal de coleção não for obrigado a ser constante, então remova a
palavra-chave `const`:

```dart
import 'a.dart' deferred as a;

var l = [a.zero];
```

Se a coleção for obrigada a ser constante e a constante importada precisar
ser referenciada, então remova a palavra-chave `deferred` da importação:

```dart
import 'a.dart' as a;

var l = const [a.zero];
```

Se você não precisar referenciar a constante, então substitua-a por um
valor adequado:

```dart
var l = const [0];
```

### compound_implements_finalizable {:#compound_implements_finalizable}

_A classe '{0}' não pode implementar Finalizable._

#### Descrição

O analisador produz este diagnóstico quando uma subclasse de `Struct` ou
`Union` implementa `Finalizable`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `S` implementa
`Finalizable`:

```dart
import 'dart:ffi';

final class [!S!] extends Struct implements Finalizable {
  external Pointer notEmpty;
}
```

#### Correções comuns

Tente remover a cláusula implements da classe:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

### concrete_class_has_enum_superinterface {:#concrete_class_has_enum_superinterface}

_Classes concretas não podem ter 'Enum' como superinterface._

#### Descrição

O analisador produz este diagnóstico quando uma classe concreta
indiretamente tem a classe `Enum` como uma superinterface.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe concreta `B` tem
`Enum` como uma superinterface como resultado da implementação de `A`:

```dart
abstract class A implements Enum {}

class [!B!] implements A {}
```

#### Correções comuns

Se a classe implementada não for a classe que você pretende implementar,
então altere-a:

```dart
abstract class A implements Enum {}

class B implements C {}

class C {}
```

Se a classe implementada puder ser alterada para não implementar `Enum`,
então faça isso:

```dart
abstract class A {}

class B implements A {}
```

Se a classe implementada não puder ser alterada para não implementar
`Enum`, remova-a da cláusula `implements`:

```dart
abstract class A implements Enum {}

class B {}
```

### concrete_class_with_abstract_member {:#concrete-class-with-abstract-member}

_'\{0}' deve ter um corpo de método porque '\{1}' não é abstrata._

#### Descrição

O analisador produz esse diagnóstico quando um membro de uma classe concreta
é encontrado e não tem uma implementação concreta. Não é permitido que
classes concretas contenham membros abstratos.

#### Exemplo

O código a seguir produz esse diagnóstico porque `m` é um método abstrato
mas `C` não é uma classe abstrata:

```dart
class C {
  [!void m();!]
}
```

#### Correções comuns

Se for válido criar instâncias da classe, forneça uma implementação
para o membro:

```dart
class C {
  void m() {}
}
```

Se não for válido criar instâncias da classe, marque a classe como sendo
abstrata:

```dart
abstract class C {
  void m();
}
```

### conflicting_constructor_and_static_member {:#conflicting_constructor_and_static_member}

_'{0}' não pode ser usado para nomear tanto um construtor quanto um campo estático
nesta classe._

_'{0}' não pode ser usado para nomear tanto um construtor quanto um getter estático
nesta classe._

_'{0}' não pode ser usado para nomear tanto um construtor quanto um método estático
nesta classe._

_'{0}' não pode ser usado para nomear tanto um construtor quanto um setter estático
nesta classe._

#### Description (Descrição)

O analisador produz esse diagnóstico quando um construtor nomeado e um método
estático ou um campo estático têm o mesmo nome.
Ambos são acessados usando
o nome da classe, então ter o mesmo nome torna a referência ambígua.

#### Examples (Exemplos)

O código a seguir produz esse diagnóstico porque o campo estático `foo`
e o construtor nomeado `foo` têm o mesmo nome:

```dart
class C {
  C.[!foo!]();
  static int foo = 0;
}
```

O código a seguir produz este diagnóstico porque o método estático `foo`
e o construtor nomeado `foo` têm o mesmo nome:

```dart
class C {
  C.[!foo!]();
  static void foo() {}
}
```

#### Common fixes (Correções comuns)

Renomeie o membro ou o construtor.

### conflicting_generic_interfaces {:#conflicting_generic_interfaces}

_O {0} '{1}' não pode implementar tanto '{2}' quanto '{3}' porque os
argumentos de tipo são diferentes._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma classe tenta
implementar uma interface genérica várias vezes e os valores
dos argumentos de tipo não são os mesmos.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque `C` é definida para
implementar tanto `I<int>` (porque estende `A`) quanto `I<String>`
(porque implementa `B`), mas `int` e `String` não são o mesmo tipo:

```dart
class I<T> {}
class A implements I<int> {}
class B implements I<String> {}
class [!C!] extends A implements B {}
```

#### Common fixes (Correções comuns)

Reestruture a hierarquia de tipos para evitar esta situação. Por exemplo,
você pode tornar um ou ambos os tipos herdados genéricos para que `C` possa
especificar o mesmo tipo para ambos os argumentos de tipo:

```dart
class I<T> {}
class A<S> implements I<S> {}
class B implements I<String> {}
class C extends A<String> implements B {}
```

### conflicting_type_variable_and_container {:#conflicting_type_variable_and_container}

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto a classe
na qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto o enum no
qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto a extensão
na qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto o tipo
de extensão no qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto o mixin
no qual o parâmetro de tipo é definido._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma declaração de classe,
mixin ou extensão declara um parâmetro de tipo com o mesmo nome da classe,
mixin ou extensão que a declara.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o parâmetro de tipo
`C` tem o mesmo nome da classe `C` da qual faz parte:

```dart
class C<[!C!]> {}
```

#### Common fixes (Correções comuns)

Renomeie o parâmetro de tipo ou a classe, mixin ou extensão:

```dart
class C<T> {}
```

### conflicting_type_variable_and_member {:#conflicting_type_variable_and_member}

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro nesta classe._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro neste enum._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um
membro neste tipo de extensão._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um
membro nesta extensão._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro neste mixin._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma declaração de classe,
mixin ou extensão declara um parâmetro de tipo com o mesmo nome de um
dos membros da classe, mixin ou extensão que a declara.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o parâmetro de tipo
`T` tem o mesmo nome do campo `T`:

```dart
class C<[!T!]> {
  int T = 0;
}
```

#### Common fixes (Correções comuns)

Renomeie o parâmetro de tipo ou o membro com o qual ele está em conflito:

```dart
class C<T> {
  int total = 0;
}
```

### constant_pattern_never_matches_value_type {:#constant_pattern_never_matches_value_type}

_O tipo de valor correspondido '{0}' nunca pode ser igual a esta constante do
tipo '{1}'._

#### Description (Descrição)

O analisador produz este diagnóstico quando um padrão constante nunca pode
corresponder ao valor contra o qual está sendo testado porque o tipo da constante
é conhecido por nunca corresponder ao tipo do valor.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o tipo do padrão constante
`(true)` é `bool`, e o tipo do valor que está sendo comparado (`x`) é `int`,
e um booleano nunca pode corresponder a um inteiro:

```dart
void f(int x) {
  if (x case [!true!]) {}
}
```

#### Common fixes (Correções comuns)

Se o tipo do valor estiver correto, reescreva o padrão para que seja
compatível:

```dart
void f(int x) {
  if (x case 3) {}
}
```

Se o tipo da constante estiver correto, reescreva o valor para que
seja compatível:

```dart
void f(bool x) {
  if (x case true) {}
}
```

### constant_pattern_with_non_constant_expression {:#constant_pattern_with_non_constant_expression}

_A expressão de um padrão constante deve ser uma constante válida._

#### Description (Descrição)

O analisador produz este diagnóstico quando um padrão constante tem um
expressão que não é uma constante válida.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o padrão constante
`i` não é uma constante:

```dart
void f(int e, int i) {
  switch (e) {
    case [!i!]:
      break;
  }
}
```

#### Common fixes (Correções comuns)

Se o valor que deve ser correspondido for conhecido, substitua a expressão
por uma constante:

```dart
void f(int e, int i) {
  switch (e) {
    case 0:
      break;
  }
}
```

Se o valor que deve ser correspondido não for conhecido, reescreva o código para
não usar um padrão:

```dart
void f(int e, int i) {
  if (e == i) {}
}
```

### const_constructor_param_type_mismatch {:#const_constructor_param_type_mismatch}

_Um valor do tipo '{0}' não pode ser atribuído a um parâmetro do tipo '{1}' em
um construtor const._

#### Description (Descrição)

O analisador produz este diagnóstico quando o tipo de tempo de execução de um
valor constante não pode ser atribuído ao tipo estático do parâmetro de um
construtor constante.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o tipo de tempo de execução
de `i` é `int`, que não pode ser atribuído ao tipo estático de `s`:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C([!i!]);
}
```

#### Common fixes (Correções comuns)

Passe um valor do tipo correto para o construtor:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C('$i');
}
```

### const_constructor_with_field_initialized_by_non_const {:#const_constructor_with_field_initialized_by_non_const}

_Não é possível definir o construtor 'const' porque o campo '{0}' é inicializado
com um valor não constante._

#### Description (Descrição)

O analisador produz este diagnóstico quando um construtor tem a palavra-chave
`const`, mas um campo na classe é inicializado com um valor não constante.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o campo `s` é inicializado
com um valor não constante:

```dart
String x = '3';
class C {
  final String s = x;
  [!const!] C();
}
```

#### Common fixes (Correções comuns)

Se o campo puder ser inicializado com um valor constante, altere o
inicializador para uma expressão constante:

```dart
class C {
  final String s = '3';
  const C();
}
```

Se o campo não puder ser inicializado com um valor constante, remova a
palavra-chave `const` do construtor:

```dart
String x = '3';
class C {
  final String s = x;
  C();
}
```

### const_constructor_with_non_const_super {:#const_constructor_with_non_const_super}

_Um construtor constante não pode chamar um super construtor não constante de '{0}'. _

#### Description (Descrição)

O analisador produz este diagnóstico quando um construtor marcado como
`const` invoca um construtor de sua superclasse que não está marcado
como `const`.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o construtor `const`
em `B` invoca o construtor `nonConst` da classe `A`, e o construtor
da superclasse não é um construtor `const`:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : [!super.nonConst()!];
}
```

#### Common fixes (Correções comuns)

Se não for essencial invocar o construtor da superclasse que está
sendo invocado no momento, invoque um construtor constante da
superclasse:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : super();
}
```

Se for essencial que o construtor atual seja invocado e você puder
modificá-lo, adicione `const` ao construtor na superclasse:

```dart
class A {
  const A();
  const A.nonConst();
}

class B extends A {
  const B() : super.nonConst();
}
```

Se for essencial que o construtor atual seja invocado e você não puder
modificá-lo, remova `const` do construtor na subclasse:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  B() : super.nonConst();
}
```

### const_constructor_with_non_final_field {:#const_constructor_with_non_final_field}

_Não é possível definir um construtor const para uma classe com campos não final._

#### Description (Descrição)

O analisador produz este diagnóstico quando um construtor é marcado como
um construtor const, mas o construtor é definido em uma classe que tem
pelo menos um campo de instância não final (diretamente ou por herança).

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o campo `x` não
é final:

```dart
class C {
  int x;

  const [!C!](this.x);
}
```

#### Common fixes (Correções comuns)

Se for possível marcar todos os campos como final, faça-o:

```dart
class C {
  final int x;

  const C(this.x);
}
```

Se não for possível marcar todos os campos como final, remova a
palavra-chave `const` do construtor:

```dart
class C {
  int x;

  C(this.x);
}
```

### const_deferred_class {:#const_deferred_class}

_Classes adiadas não podem ser criadas com 'const'._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma classe de uma biblioteca
importada usando uma importação adiada é usada para criar um objeto `const`.
As constantes são avaliadas em tempo de compilação e as classes de bibliotecas
adiadas não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque tenta criar uma instância
`const` de uma classe de uma biblioteca adiada:

```dart
import 'dart:convert' deferred as convert;

const json2 = [!convert.JsonCodec()!];
```

#### Common fixes (Correções comuns)

Se o objeto não precisar ser uma constante, altere o código para que uma
instância não constante seja criada:

```dart
import 'dart:convert' deferred as convert;

final json2 = convert.JsonCodec();
```

Se o objeto deve ser uma constante, remova `deferred` da
diretiva de importação:

```dart
import 'dart:convert' as convert;

const json2 = convert.JsonCodec();
```

### const_initialized_with_non_constant_value {:#const_initialized_with_non_constant_value}

_Variáveis Const devem ser inicializadas com um valor constante._

#### Description (Descrição)

O analisador produz este diagnóstico quando um valor que não é
estaticamente conhecido como uma constante é atribuído a uma variável declarada
como uma variável `const`.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque `x` não é declarado
como `const`:

```dart
var x = 0;
const y = [!x!];
```

#### Common fixes (Correções comuns)

Se o valor que está sendo atribuído puder ser declarado como `const`, altere a
declaração:

```dart
const x = 0;
const y = x;
```

Se o valor não puder ser declarado como `const`, remova o
modificador `const` da variável, possivelmente usando `final` em seu lugar:

```dart
var x = 0;
final y = x;
```

### const_initialized_with_non_constant_value_from_deferred_library {:#const_initialized_with_non_constant_value_from_deferred_library}

_Valores constantes de uma biblioteca adiada não podem ser usados para inicializar
uma variável 'const'._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma variável `const` é inicializada
usando uma variável `const` de uma biblioteca importada usando uma importação adiada.
As constantes são avaliadas em tempo de compilação e os valores de bibliotecas
adiadas não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque a variável `pi` está sendo
inicializada usando a constante `math.pi` da biblioteca `dart:math`, e `dart:math`
é importada como uma biblioteca adiada:

```dart
import 'dart:math' deferred as math;

const pi = math.[!pi!];
```

#### Common fixes (Correções comuns)

Se você precisar referenciar o valor da constante da biblioteca importada,
remova a palavra-chave `deferred`:

```dart
import 'dart:math' as math;

const pi = math.pi;
```

Se você não precisar referenciar a constante importada, remova a
referência:

```dart
const pi = 3.14;
```

### const_instance_field {:#const_instance_field}

_Apenas campos estáticos podem ser declarados como const._

#### Description (Descrição)

O analisador produz este diagnóstico quando um campo de instância é
marcado como sendo const.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque `f` é um
campo de instância:

```dart
class C {
  [!const!] int f = 3;
}
```

#### Common fixes (Correções comuns)

Se o campo precisar ser um campo de instância, remova a palavra-chave
`const` ou substitua-a por `final`:

```dart
class C {
  final int f = 3;
}
```

Se o campo realmente deve ser um campo const, torne-o um campo estático:

```dart
class C {
  static const int f = 3;
}
```

### const_map_key_not_primitive_equality {:#const_map_key_not_primitive_equality}

_O tipo de uma chave em um mapa constante não pode sobrescrever o operador
'==', ou 'hashCode', mas a classe '{0}' o faz._

#### Description (Descrição)

O analisador produz este diagnóstico quando a classe do objeto usado como chave
em um mapa literal constante implementa o operador `==`, o getter `hashCode` ou ambos.
A implementação de mapas constantes usa tanto o operador `==` quanto o getter `hashCode`,
portanto, qualquer implementação diferente daquelas herdadas de `Object` requer
a execução de código arbitrário em tempo de compilação,
o que não é suportado.

#### Examples (Exemplos)

O código a seguir produz este diagnóstico porque o mapa constante contém
uma chave cujo tipo é `C`, e a classe `C` substitui a
implementação de `==`:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

const map = {[!C()!] : 0};
```

O código a seguir produz este diagnóstico porque o mapa constante contém
uma chave cujo tipo é `C`, e a classe `C` substitui a
implementação de `hashCode`:

```dart
class C {
  const C();

  int get hashCode => 3;
}

const map = {[!C()!] : 0};
```

#### Common fixes (Correções comuns)

Se você puder remover a implementação de `==` e `hashCode`
da classe, faça-o:

```dart
class C {
  const C();
}

const map = {C() : 0};
```

Se você não puder remover a implementação de `==` e `hashCode` da classe,
torne o mapa não constante:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

final map = {C() : 0};
```

### const_not_initialized {:#const_not_initialized}

_A constante '{0}' deve ser inicializada._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma variável declarada como
constante não tem um inicializador.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque `c` não é inicializado:

```dart
const [!c!];
```

#### Common fixes (Correções comuns)

Adicione um inicializador:

```dart
const c = 'c';
```

### const_set_element_not_primitive_equality {:#const_set_element_not_primitive_equality}

<a id="const_set_element_type_implements_equals" aria-hidden="true"></a>_(Anteriormente conhecido como `const_set_element_type_implements_equals`)_

_Um elemento em um conjunto constante não pode sobrescrever o operador '==',
ou 'hashCode', mas o tipo '{0}' o faz._

#### Description (Descrição)

O analisador produz este diagnóstico quando a classe do objeto usado como
elemento em um conjunto literal constante implementa o operador `==`, o getter
`hashCode` ou ambos. A implementação de conjuntos constantes usa tanto o
operador `==` quanto o getter `hashCode`, portanto, qualquer implementação
diferente daquelas herdadas de `Object` requer a execução de código
arbitrário em tempo de compilação, o que não é suportado.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o conjunto constante contém
um elemento cujo tipo é `C`, e a classe `C` substitui a
implementação de `==`:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

const set = {[!C()!]};
```

O código a seguir produz este diagnóstico porque o conjunto constante
contém um elemento cujo tipo é `C`, e a classe `C` substitui a
implementação de `hashCode`:

```dart
class C {
  const C();

  int get hashCode => 3;
}

const map = {[!C()!]};
```

#### Common fixes (Correções comuns)

Se você puder remover a implementação de `==` e `hashCode`
da classe, faça-o:

```dart
class C {
  const C();
}

const set = {C()};
```

Se você não puder remover a implementação de `==` e `hashCode` da classe,
torne o conjunto não constante:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

final set = {C()};
```

### const_spread_expected_list_or_set {:#const_spread_expected_list_or_set}

_Uma lista ou um conjunto é esperado neste spread._

#### Description (Descrição)

O analisador produz este diagnóstico quando a expressão de um operador de
spread em uma lista ou conjunto constante é avaliada como algo diferente de uma
lista ou um conjunto.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o valor de `list1` é `null`,
que não é nem uma lista nem um conjunto:

```dart
const dynamic list1 = 42;
const List<int> list2 = [...[!list1!]];
```

#### Common fixes (Correções comuns)

Altere a expressão para algo que seja avaliado como uma lista constante
ou um conjunto constante:

```dart
const dynamic list1 = [42];
const List<int> list2 = [...list1];
```

### const_spread_expected_map {:#const_spread_expected_map}

_Um mapa é esperado neste spread._

#### Description (Descrição)

O analisador produz este diagnóstico quando a expressão de um operador
de spread em um mapa constante é avaliada como algo diferente de um mapa.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o valor de `map1` é `null`,
que não é um mapa:

```dart
const dynamic map1 = 42;
const Map<String, int> map2 = {...[!map1!]};
```

#### Common fixes (Correções comuns)

Altere a expressão para algo que seja avaliado como um mapa constante:

```dart
const dynamic map1 = {'answer': 42};
const Map<String, int> map2 = {...map1};
```

### const_with_non_const {:#const_with_non_const}

_O construtor que está sendo chamado não é um construtor const._

#### Description (Descrição)

O analisador produz este diagnóstico quando a palavra-chave `const`
é usada para invocar um construtor que não está marcado com `const`.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o construtor em `A` não é
um construtor const:

```dart
class A {
  A();
}

A f() => [!const!] A();
```

#### Common fixes (Correções comuns)

Se for desejável e possível tornar a classe uma classe constante
(tornando todos os campos da classe, incluindo os campos herdados, finais),
adicione a palavra-chave `const` ao construtor:

```dart
class A {
  const A();
}

A f() => const A();
```

Caso contrário, remova a palavra-chave `const`:

```dart
class A {
  A();
}

A f() => A();
```

### const_with_non_constant_argument {:#const_with_non_constant_argument}

_Argumentos de uma criação constante devem ser expressões constantes._

#### Description (Descrição)

O analisador produz este diagnóstico quando um construtor const é invocado
com um argumento que não é uma expressão constante.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque `i` não é uma constante:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => const C([!i!]);
```

#### Common fixes (Correções comuns)

Torne todos os argumentos expressões constantes ou remova a palavra-chave
`const` para usar a forma não constante do construtor:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => C(i);
```

### const_with_type_parameters {:#const_with_type_parameters}

_Um tearoff de construtor constante não pode usar um parâmetro de tipo como um argumento de tipo._

_Uma criação constante não pode usar um parâmetro de tipo como um argumento de tipo._

_Um tearoff de função constante não pode usar um parâmetro de tipo como um argumento de tipo._

#### Description (Descrição)

O analisador produz este diagnóstico quando um parâmetro de tipo é usado como
um argumento de tipo em uma invocação `const` de um construtor. Isso não é
permitido porque o valor do parâmetro de tipo (o tipo real que será usado em
tempo de execução) não pode ser conhecido em tempo de compilação.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
está sendo usado como um argumento de tipo ao criar uma constante:

```dart
class C<T> {
  const C();
}

C<T> newC<T>() => const C<[!T!]>();
```

#### Common fixes (Correções comuns)

Se o tipo que será usado para o parâmetro de tipo puder ser conhecido em
tempo de compilação, remova o uso do parâmetro de tipo:

```dart
class C<T> {
  const C();
}

C<int> newC() => const C<int>();
```

Se o tipo que será usado para o parâmetro de tipo não puder ser conhecido até
o tempo de execução, remova a palavra-chave `const`:

```dart
class C<T> {
  const C();
}

C<T> newC<T>() => C<T>();
```

### continue_label_invalid {:#continue_label_invalid}

<a id="continue_label_on_switch" aria-hidden="true"></a>_(Anteriormente conhecido como `continue_label_on_switch`)_

_O rótulo usado em uma declaração 'continue' deve ser definido em um loop ou em
um membro switch._

#### Description (Descrição)

O analisador produz este diagnóstico quando o rótulo em uma declaração `continue`
é resolvido para um rótulo em uma declaração `switch`.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque o rótulo `l`, usado para
rotular uma declaração `switch`, é usado na declaração `continue`:

```dart
void f(int i) {
  l: switch (i) {
    case 0:
      [!continue l;!]
  }
}
```

#### Common fixes (Correções comuns)

Encontre uma maneira diferente de obter o fluxo de controle de que você precisa; por exemplo, introduzindo um loop que reexecuta a declaração `switch`.

### creation_of_struct_or_union {:#creation_of_struct_or_union}

_Subclasses de 'Struct' e 'Union' são apoiadas por memória nativa e não podem ser instanciadas por um construtor generativo._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma subclasse de `Struct` ou `Union` é instanciada usando um construtor generativo.

Para mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque a classe `C` está sendo
instanciada usando um construtor generativo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int a;
}

void f() {
  [!C!]();
}
```

#### Common fixes (Correções comuns)

Se você precisar alocar a estrutura descrita pela classe, use o pacote `ffi` para fazê-lo:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  @Int32()
  external int a;
}

void f() {
  final pointer = calloc.allocate<C>(4);
  final c = pointer.ref;
  print(c);
  calloc.free(pointer);
}
```

### creation_with_non_type {:#creation_with_non_type}

_O nome '{0}' não é uma classe._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma criação de instância usando
`new` ou `const` especifica um nome que não está definido como uma classe.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque `f` é uma função em vez de uma classe:

```dart
int f() => 0;

void g() {
  new [!f!]();
}
```

#### Common fixes (Correções comuns)

Se uma classe deve ser criada, substitua o nome inválido pelo nome de uma classe válida:

```dart
int f() => 0;

void g() {
  new Object();
}
```

Se o nome for o nome de uma função e você quiser que essa função seja invocada,
remova a palavra-chave `new` ou `const`:

```dart
int f() => 0;

void g() {
  f();
}
```

### dead_code {:#dead_code}

_Código morto._

_Código morto: A variável curinga atribuída é marcada como late e nunca poderá
ser referenciada, portanto, este inicializador nunca será avaliado._

#### Description (Descrição)

O analisador produz este diagnóstico quando um código é encontrado que não
será executado porque a execução nunca alcançará o código.

#### Example (Exemplo)

O código a seguir produz este diagnóstico porque a invocação de `print`
ocorre depois que a função retornou:

```dart
void f() {
  return;
  [!print('here');!]
}
```

#### Common fixes (Correções comuns)

Se o código não for necessário, remova-o:

```dart
void f() {
  return;
}
```

Se o código precisar ser executado, mova o código para um local onde ele será executado:

```dart
void f() {
  print('here');
  return;
}
```

Ou, reescreva o código antes dele, para que ele possa ser alcançado:

```dart
void f({bool skipPrinting = true}) {
  if (skipPrinting) {
    return;
  }
  print('here');
}
```

### dead_code_catch_following_catch {:#dead_code_catch_following_catch}

_Código morto: Cláusulas Catch após um 'catch (e)' ou um 'on Object catch (e)'
nunca são alcançadas._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma cláusula `catch` é encontrada
e não pode ser executada porque está depois de uma cláusula `catch` da forma
`catch (e)` ou `on Object catch (e)`. A primeira cláusula `catch` que
corresponde ao objeto lançado é selecionada, e ambas as formas corresponderão
a qualquer objeto, portanto, nenhuma cláusula `catch` que as siga será selecionada.

#### Example (Exemplo)

O código a seguir produz este diagnóstico:

```dart
void f() {
  try {
  } catch (e) {
  } [!on String {!]
  [!}!]
}
```

#### Common fixes (Correções comuns)

Se a cláusula deve ser selecionável, mova a cláusula antes da
cláusula geral:

```dart
void f() {
  try {
  } on String {
  } catch (e) {
  }
}
```

Se a cláusula não precisa ser selecionável, remova-a:

```dart
void f() {
  try {
  } catch (e) {
  }
}
```

### dead_code_on_catch_subtype {:#dead_code_on_catch_subtype}

_Código morto: Este bloco on-catch não será executado porque '{0}' é um subtipo de '{1}' e, portanto, já terá sido capturado._

#### Description (Descrição)

O analisador produz este diagnóstico quando uma cláusula `catch` é encontrada
e não pode ser executada porque está depois de uma cláusula `catch` que
captura o mesmo tipo ou um supertipo do tipo da cláusula. A primeira
cláusula `catch` que corresponde ao objeto lançado é selecionada, e a
cláusula anterior sempre corresponde a qualquer coisa que possa ser
correspondida pela cláusula destacada, portanto, a cláusula destacada nunca será selecionada.

#### Example (Exemplo)

O código a seguir produz este diagnóstico:

```dart
void f() {
  try {
  } on num {
  } [!on int {!]
  [!}!]
}
```

#### Common fixes (Correções comuns)

Se a cláusula deve ser selecionável, mova a cláusula antes da
cláusula geral:

```dart
void f() {
  try {
  } on int {
  } on num {
  }
}
```

Se a cláusula não precisa ser selecionável, remova-a:

```dart
void f() {
  try {
  } on num {
  }
}
```
[ffi]: https://dartbrasil.dev/guides/libraries/c-interop
### dead_null_aware_expression {:#dead_null_aware_expression}

_O operando esquerdo não pode ser nulo, então o operando direito nunca é executado._

#### Descrição

O analisador produz este diagnóstico em dois casos.

O primeiro é quando o operando esquerdo de um operador `??` não pode ser `null`.
O operando direito só é avaliado se o operando esquerdo tiver o valor
`null`, e como o operando esquerdo não pode ser `null`, o operando direito
nunca é avaliado.

O segundo é quando o lado esquerdo de uma atribuição usando o operador `??=`
não pode ser `null`. O lado direito só é avaliado se o
lado esquerdo tiver o valor `null`, e como o lado esquerdo não pode
ser `null`, o lado direito nunca é avaliado.

#### Exemplos

O código a seguir produz este diagnóstico porque `x` não pode ser `null`:

```dart
int f(int x) {
  return x ?? [!0!];
}
```

O código a seguir produz este diagnóstico porque `f` não pode ser `null`:

```dart
class C {
  int f = -1;

  void m(int x) {
    f ??= [!x!];
  }
}
```

#### Correções Comuns

Se o diagnóstico for relatado para um operador `??`, remova o operador `??`
e o operando direito:

```dart
int f(int x) {
  return x;
}
```

Se o diagnóstico for relatado para uma atribuição, e a atribuição não for
necessária, então remova a atribuição:

```dart
class C {
  int f = -1;

  void m(int x) {
  }
}
```

Se a atribuição for necessária, mas deve ser baseada em uma condição diferente,
reescreva o código para usar `=` e a condição diferente:

```dart
class C {
  int f = -1;

  void m(int x) {
    if (f < 0) {
      f = x;
    }
  }
}
```

### default_list_constructor {:#default_list_constructor}

_O construtor padrão 'List' não está disponível quando o null safety (segurança nula) está ativado._

#### Descrição

O analisador produz este diagnóstico quando encontra um uso do
construtor padrão para a classe `List` em código que optou por null safety.

#### Exemplo

Assumindo que o código a seguir optou por null safety, ele produz este
diagnóstico porque usa o construtor padrão `List`:

```dart
var l = [!List<int>!]();
```

#### Correções Comuns

Se nenhum tamanho inicial for fornecido, converta o código para usar um literal
de lista:

```dart
var l = <int>[];
```

Se um tamanho inicial precisar ser fornecido e houver um único valor inicial
razoável para os elementos, use `List.filled`:

```dart
var l = List.filled(3, 0);
```

Se um tamanho inicial precisar ser fornecido, mas cada elemento precisar ser
calculado, use `List.generate`:

```dart
var l = List.generate(3, (i) => i);
```

### default_value_in_function_type {:#default_value_in_function_type}

_Parâmetros em um tipo de função não podem ter valores padrão._

#### Descrição

O analisador produz este diagnóstico quando um tipo de função associado a
um parâmetro inclui parâmetros opcionais que têm um valor padrão. Isso
não é permitido porque os valores padrão dos parâmetros não fazem parte do
tipo da função e, portanto, incluí-los não fornece nenhum valor.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro `p` tem um
valor padrão, mesmo que faça parte do tipo do parâmetro `g`:

```dart
void f(void Function([int p [!=!] 0]) g) {
}
```

#### Correções Comuns

Remova o valor padrão do parâmetro do tipo de função:

```dart
void f(void Function([int p]) g) {
}
```

### default_value_in_redirecting_factory_constructor {:#default_value_in_redirecting_factory_constructor}

_Valores padrão não são permitidos em construtores factory que redirecionam para outro
construtor._

#### Descrição

O analisador produz este diagnóstico quando um construtor *factory* (fábrica) que
redireciona para outro construtor especifica um valor padrão para um
parâmetro opcional.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor *factory*
em `A` tem um valor padrão para o parâmetro opcional `x`:

```dart
class A {
  factory A([int [!x!] = 0]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

#### Correções Comuns

Remova o valor padrão do construtor *factory*:

```dart
class A {
  factory A([int x]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

Observe que esta correção pode alterar o valor usado quando o parâmetro
opcional é omitido. Se isso acontecer e se essa mudança for um problema,
considere tornar o parâmetro opcional um parâmetro obrigatório no método
*factory*:

```dart
class A {
 factory A(int x) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

### default_value_on_required_parameter {:#default_value_on_required_parameter}

_Parâmetros nomeados obrigatórios não podem ter um valor padrão._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro nomeado tem ambos
o modificador `required` e um valor padrão. Se o parâmetro for obrigatório,
um valor para o parâmetro é sempre fornecido nos locais de chamada, então o
valor padrão nunca pode ser usado.

#### Exemplo

O código a seguir gera este diagnóstico:

```dart
void log({required String [!message!] = 'no message'}) {}
```

#### Correções Comuns

Se o parâmetro for realmente obrigatório, remova o valor padrão:

```dart
void log({required String message}) {}
```

Se o parâmetro nem sempre for obrigatório, remova o modificador `required`:

```dart
void log({String message = 'no message'}) {}
```

### deferred_import_of_extension {:#deferred_import_of_extension}

_Importações de bibliotecas adiadas devem ocultar todas as extensões._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca que é importada
usando uma importação adiada declara uma extensão que é visível na biblioteca
de importação. Métodos de extensão são resolvidos em tempo de compilação e
extensões de bibliotecas adiadas não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define uma extensão nomeada:

```dart
class C {}

extension E on String {
  int get size => length;
}
```

O código a seguir produz este diagnóstico porque a extensão nomeada é
visível para a biblioteca:

```dart
import [!'a.dart'!] deferred as a;

void f() {
  a.C();
}
```

#### Correções Comuns

Se a biblioteca deve ser importada como `deferred`, adicione uma cláusula
`show` listando os nomes que estão sendo referenciados ou adicione uma cláusula
`hide` listando todas as extensões nomeadas. Adicionar uma cláusula `show`
seria assim:

```dart
import 'a.dart' deferred as a show C;

void f() {
  a.C();
}
```

Adicionar uma cláusula `hide` seria assim:

```dart
import 'a.dart' deferred as a hide E;

void f() {
  a.C();
}
```

Com a primeira correção, o benefício é que, se novas extensões forem
adicionadas à biblioteca importada, as extensões não causarão a geração de
um diagnóstico.

Se a biblioteca não precisar ser importada como `deferred`, ou se você precisar
fazer uso do método de extensão declarado nela, remova a palavra-chave
`deferred`:

```dart
import 'a.dart' as a;

void f() {
  a.C();
}
```

### definitely_unassigned_late_local_variable {:#definitely_unassigned_late_local_variable}

_A variável local `late` '{0}' está definitivamente não atribuída neste ponto._

#### Descrição

O analisador produz este diagnóstico quando a análise de [atribuição
definida][atribuição definitiva] mostra que uma variável local que está marcada como `late` é lida
antes de ser atribuída.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` não foi atribuído a um
valor antes de ser lido:

```dart
void f(bool b) {
  late int x;
  print([!x!]);
}
```

#### Correções Comuns

Atribua um valor à variável antes de lê-la:

```dart
void f(bool b) {
  late int x;
  x = b ? 1 : 0;
  print(x);
}
```

### dependencies_field_not_map {:#dependencies_field_not_map}

_Espera-se que o valor do campo '{0}' seja um mapa._

#### Descrição

O analisador produz este diagnóstico quando o valor da chave `dependencies`
ou `dev_dependencies` não é um mapa.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor da chave
`dependencies` de nível superior é uma lista:

```yaml
name: example
dependencies:
  [!- meta!]
```

#### Correções Comuns

Use um mapa como o valor da chave `dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

### deprecated_colon_for_default_value {:#deprecated_colon_for_default_value}

_O uso de dois pontos como separador antes de um valor padrão está obsoleto e
não será suportado na versão 3.0 e posterior da linguagem._

#### Descrição

O analisador produz este diagnóstico quando dois pontos (`:`) são usados
como separador antes do valor padrão de um parâmetro nomeado opcional.
Embora esta sintaxe seja permitida, ela está obsoleta em favor
de usar um sinal de igual (`=`).

#### Exemplo

O código a seguir produz este diagnóstico porque dois pontos estão sendo
usados antes do valor padrão do parâmetro opcional `i`:

```dart
void f({int i [!:!] 0}) {}
```

#### Correções Comuns

Substitua os dois pontos por um sinal de igual.

```dart
void f({int i = 0}) {}
```

### deprecated_export_use {:#deprecated_export_use}

_A capacidade de importar '{0}' indiretamente está obsoleta._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca importa um nome
de uma segunda biblioteca e a segunda biblioteca exporta o nome de uma
terceira biblioteca, mas indicou que não exportará a terceira biblioteca no
futuro.

#### Exemplo

Dada uma biblioteca `a.dart` que define a classe `A`:

```dart
class A {}
```

E uma segunda biblioteca `b.dart` que exporta `a.dart`, mas marcou a
exportação como obsoleta:

```dart
import 'a.dart';

@deprecated
export 'a.dart';
```

O código a seguir produz este diagnóstico porque a classe `A` não será
exportada de `b.dart` em alguma versão futura:

```dart
import 'b.dart';

[!A!]? a;
```

#### Correções Comuns

Se o nome estiver disponível em uma biblioteca diferente que você pode
importar, substitua a importação existente por uma importação para essa
biblioteca (ou adicione uma importação para a biblioteca de definição se você
ainda precisar da importação antiga):

```dart
import 'a.dart';

A? a;
```

Se o nome não estiver disponível, procure instruções do autor da biblioteca
ou entre em contato diretamente com eles para descobrir como atualizar seu código.

### deprecated_field {:#deprecated_field}

_O campo '{0}' não é mais usado e pode ser removido._

#### Descrição

O analisador produz este diagnóstico quando uma chave é usada em um
arquivo `pubspec.yaml` que estava obsoleto. Chaves não usadas ocupam espaço e
podem implicar semânticas que não são mais válidas.

#### Exemplo

O código a seguir produz este diagnóstico porque a chave `author` não está
mais sendo usada:

```dart
name: example
author: 'Dash'
```

#### Correções Comuns

Remova a chave obsoleta:

```dart
name: example
```

### deprecated_member_use {:#deprecated_member_use}

_'{0}' está obsoleto e não deve ser usado._

_'{0}' está obsoleto e não deve ser usado. {1}_

#### Descrição

O analisador produz este diagnóstico quando um membro de biblioteca ou
classe obsoleto é usado em um pacote diferente.

#### Exemplo

Se o método `m` na classe `C` for anotado com `@deprecated`, então
o código a seguir produz este diagnóstico:

```dart
void f(C c) {
  c.[!m!]();
}
```

#### Correções Comuns

A documentação para declarações que são anotadas com `@deprecated`
deve indicar qual código usar no lugar do código obsoleto.

### deprecated_member_use_from_same_package {:#deprecated_member_use_from_same_package}

_'{0}' está obsoleto e não deve ser usado._

_'{0}' está obsoleto e não deve ser usado. {1}_

#### Descrição

O analisador produz este diagnóstico quando um membro de biblioteca ou
membro de classe obsoleto é usado no mesmo pacote em que é declarado.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` está obsoleto:

```dart
@deprecated
var x = 0;
var y = [!x!];
```

#### Correções Comuns

A correção depende do que foi depreciado e qual é a substituição. A
documentação para declarações obsoletas deve indicar qual código usar
em vez do código obsoleto.

### deprecated_new_in_comment_reference {:#deprecated_new_in_comment_reference}

_O uso da palavra-chave 'new' em uma referência de comentário está obsoleto._

#### Descrição

O analisador produz este diagnóstico quando uma referência de comentário
(o nome de uma declaração entre colchetes em um comentário de
documentação) usa a palavra-chave `new` para se referir a um construtor.
Esta forma está obsoleta.

#### Exemplos

O código a seguir produz este diagnóstico porque o construtor não nomeado
está sendo referenciado usando `new C`:

```dart
/// Veja [[!new!] C].
class C {
  C();
}
```

O código a seguir produz este diagnóstico porque o construtor nomeado
`c` está sendo referenciado usando `new C.c`:

```dart
/// Veja [[!new!] C.c].
class C {
  C.c();
}
```

#### Correções Comuns

Se você estiver referenciando um construtor nomeado, remova a palavra-chave
`new`:

```dart
/// Veja [C.c].
class C {
  C.c();
}
```

Se você estiver referenciando o construtor não nomeado, remova a palavra-
chave `new` e acrescente `.new` após o nome da classe:

```dart
/// Veja [C.new].
class C {
  C.c();
}
```

### deprecated_subtype_of_function {:#deprecated_subtype_of_function}

_Estender 'Function' está obsoleto._

_Implementar 'Function' não tem efeito._

_Fazer um mixin de 'Function' está obsoleto._

#### Descrição

O analisador produz este diagnóstico quando a classe `Function` é usada
na cláusula `extends`, `implements` ou `with` de uma classe ou mixin.
Usar a classe `Function` dessa forma não tem valor semântico, então é
efetivamente código morto.

#### Exemplo

O código a seguir produz este diagnóstico porque `Function` é usado como
a superclasse de `F`:

```dart
class F extends [!Function!] {}
```

#### Correções Comuns

Remova a classe `Function` de qualquer cláusula em que ela esteja e remova
toda a cláusula se `Function` for o único tipo na cláusula:

```dart
class F {}
```

### disallowed_type_instantiation_expression {:#disallowed_type_instantiation_expression}

_Apenas um tipo genérico, função genérica, método de instância genérico ou
construtor genérico pode ter argumentos de tipo._

#### Descrição

O analisador produz este diagnóstico quando uma expressão com um valor que
seja qualquer coisa diferente de um dos tipos de valores permitidos é seguida
por argumentos de tipo. Os tipos de valores permitidos são:
- tipos genéricos,
- construtores genéricos e
- funções genéricas, incluindo funções de nível superior, membros estáticos
  e de instância e funções locais.

#### Exemplo

O código a seguir produz este diagnóstico porque `i` é uma variável de nível
superior, que não é um dos casos permitidos:

```dart
int i = 1;

void f() {
  print([!i!]<int>);
}
```

#### Correções Comuns

Se o valor referenciado estiver correto, remova os argumentos de tipo:

```dart
int i = 1;

void f() {
  print(i);
}
```

### division_optimization {:#division_optimization}

_O operador x ~/ y é mais eficiente do que (x / y).toInt()._

#### Descrição

O analisador produz este diagnóstico quando o resultado da divisão de dois
números é convertido para um inteiro usando `toInt`. O Dart tem um operador
de divisão inteira embutido que é mais eficiente e mais conciso.

#### Exemplo

O código a seguir produz este diagnóstico porque o resultado da divisão
de `x` e `y` é convertido para um inteiro usando `toInt`:

```dart
int divide(int x, int y) => [!(x / y).toInt()!];
```

#### Correções Comuns

Use o operador de divisão inteira (`~/`):

```dart
int divide(int x, int y) => x ~/ y;
```

### duplicate_constructor {:#duplicate_constructor}

_O construtor com o nome '{0}' já está definido._

_O construtor não nomeado já está definido._

#### Descrição

O analisador produz este diagnóstico quando uma classe declara mais de um
construtor não nomeado ou quando ela declara mais de um construtor com o
mesmo nome.

#### Exemplos

O código a seguir produz este diagnóstico porque há duas declarações
para o construtor não nomeado:

```dart
class C {
  C();

  [!C!]();
}
```

O código a seguir produz este diagnóstico porque há duas declarações
para o construtor nomeado `m`:

```dart
class C {
  C.m();

  [!C.m!]();
}
```

#### Correções Comuns

Se houver vários construtores não nomeados e todos os construtores forem
necessários, então dê a todos eles, ou a todos, exceto um deles, um nome:

```dart
class C {
  C();

  C.n();
}
```

Se houver vários construtores não nomeados e todos, exceto um deles, forem
desnecessários, remova os construtores que não são necessários:

```dart
class C {
  C();
}
```

Se houver vários construtores nomeados e todos os construtores forem
necessários, renomeie todos, exceto um deles:

```dart
class C {
  C.m();

  C.n();
}
```

Se houver vários construtores nomeados e todos, exceto um deles, forem
desnecessários, remova os construtores que não são necessários:

```dart
class C {
  C.m();
}
```

### duplicate_definition {:#duplicate_definition}

_O nome '{0}' já está definido._

#### Descrição

O analisador produz este diagnóstico quando um nome é declarado e há
uma declaração anterior com o mesmo nome no mesmo escopo.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `x` é
declarado duas vezes:

```dart
int x = 0;
int [!x!] = 1;
```

#### Correções Comuns

Escolha um nome diferente para uma das declarações.

```dart
int x = 0;
int y = 1;
```

### duplicate_export {:#duplicate_export}

_Exportação duplicada._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva de exportação é
encontrada que é igual a uma exportação anterior no arquivo. A segunda
exportação não agrega valor e deve ser removida.

#### Exemplo

O código a seguir produz este diagnóstico porque a mesma biblioteca está
sendo exportada duas vezes:

```dart
export 'package:meta/meta.dart';
export [!'package:meta/meta.dart'!];
```

#### Correções Comuns

Remova a exportação desnecessária:

```dart
export 'package:meta/meta.dart';
```

### duplicate_field_formal_parameter {:#duplicate_field_formal_parameter}

_O campo '{0}' não pode ser inicializado por vários parâmetros no mesmo
construtor._

#### Descrição

O analisador produz este diagnóstico quando há mais de um
parâmetro formal de inicialização para o mesmo campo na lista de
parâmetros de um construtor. Não é útil atribuir um valor que será
imediatamente sobrescrito.

#### Exemplo

O código a seguir produz este diagnóstico porque `this.f` aparece duas
vezes na lista de parâmetros:

```dart
class C {
  int f;

  C(this.f, this.[!f!]) {}
}
```

#### Correções Comuns

Remova um dos parâmetros formais de inicialização:

```dart
class C {
  int f;

  C(this.f) {}
}
```

### duplicate_field_name {:#duplicate_field_name}

_O nome do campo '{0}' já está em uso neste registro._

#### Descrição

O analisador produz este diagnóstico quando um literal de registro ou
uma anotação de tipo de registro contém um campo cujo nome é o mesmo que
um campo declarado anteriormente no mesmo literal ou tipo.

#### Exemplos

O código a seguir produz este diagnóstico porque o literal de registro
tem dois campos chamados `a`:

```dart
var r = (a: 1, [!a!]: 2);
```

O código a seguir produz este diagnóstico porque a anotação de tipo de
registro tem dois campos chamados `a`, um campo posicional e o outro um
campo nomeado:

```dart
void f((int a, {int [!a!]}) r) {}
```

#### Correções Comuns

Renomeie um ou ambos os campos:

```dart
var r = (a: 1, b: 2);
```

### duplicate_hidden_name {:#duplicate_hidden_name}

_Nome oculto duplicado._

#### Descrição

O analisador produz este diagnóstico quando um nome ocorre várias vezes em
uma cláusula `hide`. Repetir o nome é desnecessário.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `min` está
oculto mais de uma vez:

```dart
import 'dart:math' hide min, [!min!];

var x = pi;
```

#### Correções Comuns

Se o nome foi digitado incorretamente em um ou mais lugares, corrija os
nomes digitados incorretamente:

```dart
import 'dart:math' hide max, min;

var x = pi;
```

Se o nome não foi digitado incorretamente, remova o nome desnecessário da
lista:

```dart
import 'dart:math' hide min;

var x = pi;
```

### duplicate_ignore {:#duplicate_ignore}

_O diagnóstico '{0}' não precisa ser ignorado aqui porque já está sendo
ignorado._

#### Descrição

O analisador produz este diagnóstico quando um nome de diagnóstico aparece
em um comentário `ignore`, mas o diagnóstico já está sendo ignorado, seja
porque já está incluído no mesmo comentário `ignore` ou porque aparece
em um comentário `ignore-in-file` (ignorar no arquivo).

#### Exemplos

O código a seguir produz este diagnóstico porque o diagnóstico nomeado
`unused_local_variable` já está sendo ignorado para todo o arquivo, então
não precisa ser ignorado em uma linha específica:

```dart
// ignore_for_file: unused_local_variable
void f() {
  // ignore: [!unused_local_variable!]
  var x = 0;
}
```

O código a seguir produz este diagnóstico porque o diagnóstico nomeado
`unused_local_variable` está sendo ignorado duas vezes na mesma linha:

```dart
void f() {
  // ignore: unused_local_variable, [!unused_local_variable!]
  var x = 0;
}
```

#### Correções Comuns

Remova o comentário ignore ou remova o nome de diagnóstico desnecessário
se o comentário ignore estiver ignorando mais de um diagnóstico:

```dart
// ignore_for_file: unused_local_variable
void f() {
  var x = 0;
}
```

### duplicate_import {:#duplicate_import}

_Importação duplicada._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva de importação é
encontrada que é igual a uma importação anterior no arquivo. A segunda
importação não agrega valor e deve ser removida.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
import 'package:meta/meta.dart';
import [!'package:meta/meta.dart'!];

@sealed class C {}
```

#### Correções Comuns

Remova a importação desnecessária:

```dart
import 'package:meta/meta.dart';

@sealed class C {}
```

### duplicate_named_argument {:#duplicate_named_argument}

_O argumento para o parâmetro nomeado '{0}' já foi especificado._

#### Descrição

O analisador produz este diagnóstico quando uma invocação tem dois ou
mais argumentos nomeados que têm o mesmo nome.

#### Exemplo

O código a seguir produz este diagnóstico porque existem dois argumentos
com o nome `a`:

```dart
void f(C c) {
  c.m(a: 0, [!a!]: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

#### Correções Comuns

Se um dos argumentos deve ter um nome diferente, altere o nome:

```dart
void f(C c) {
  c.m(a: 0, b: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

Se um dos argumentos estiver errado, remova-o:

```dart
void f(C c) {
  c.m(a: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

### duplicate_part {:#duplicate_part}

_A biblioteca já contém uma parte com o URI '{0}'._

#### Descrição

O analisador produz este diagnóstico quando um único arquivo é referenciado
em várias diretivas *part*.

#### Exemplo

Dado um arquivo `part.dart` contendo

```dart
part of 'test.dart';
```

O código a seguir produz este diagnóstico porque o arquivo `part.dart` é
incluído várias vezes:

```dart
part 'part.dart';
part [!'part.dart'!];
```

#### Correções Comuns

Remova todas, exceto a primeira, das diretivas *part* duplicadas:

```dart
part 'part.dart';
```

### duplicate_pattern_assignment_variable {:#duplicate_pattern_assignment_variable}

_A variável '{0}' já está atribuída neste padrão._

#### Descrição

O analisador produz este diagnóstico quando uma única variável de padrão
recebe um valor mais de uma vez na mesma atribuição de padrão.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `a` é
atribuída duas vezes no padrão `(a, a)`:

```dart
int f((int, int) r) {
  int a;
  (a, [!a!]) = r;
  return a;
}
```

#### Correções Comuns

Se você precisar capturar todos os valores, use uma variável exclusiva
para cada um dos subpadrões que estão sendo correspondidos:

```dart
int f((int, int) r) {
  int a, b;
  (a, b) = r;
  return a + b;
}
```

Se alguns dos valores não precisarem ser capturados, use um padrão curinga
`_` para evitar ter que vincular o valor a uma variável:

```dart
int f((int, int) r) {
  int a;
  (_, a) = r;
  return a;
}
```

### duplicate_pattern_field {:#duplicate_pattern_field}

_O campo '{0}' já está correspondido neste padrão._

#### Descrição

O analisador produz este diagnóstico quando um padrão de registro
corresponde ao mesmo campo mais de uma vez ou quando um padrão de objeto
corresponde ao mesmo getter mais de uma vez.

#### Exemplos

O código a seguir produz este diagnóstico porque o campo de registro `a`
é correspondido duas vezes no mesmo padrão de registro:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, [!a!]: 2):
      return;
  }
}
```

O código a seguir produz este diagnóstico porque o getter `f` é
correspondido duas vezes no mesmo padrão de objeto:

```dart
void f(Object o) {
  switch (o) {
    case C(f: 1, [!f!]: 2):
      return;
  }
}
class C {
  int? f;
}
```

#### Correções Comuns

Se o padrão deve corresponder a mais de um valor do campo duplicado, use um
padrão *logical-or*:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, b: _) || (a: 2, b: _):
      break;
  }
}
```

Se o padrão deve corresponder a vários campos, altere o nome de um dos
campos:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, b: 2):
      return;
  }
}
```

### duplicate_rest_element_in_pattern {:#duplicate_rest_element_in_pattern}

_No máximo um elemento resto é permitido em um padrão de lista ou mapa._

#### Descrição

O analisador produz este diagnóstico quando há mais de um padrão de
resto em um padrão de lista ou mapa. Um padrão de resto capturará
quaisquer valores não correspondidos por outros subpadrões, tornando
os padrões de resto subsequentes desnecessários porque não há mais nada para capturar.

#### Exemplo

O código a seguir produz este diagnóstico porque existem dois padrões
de resto no padrão de lista:

```dart
void f(List<int> x) {
  if (x case [0, ..., [!...!]]) {}
}
```

#### Correções Comuns

Remova todos, exceto um, dos padrões de resto:

```dart
void f(List<int> x) {
  if (x case [0, ...]) {}
}
```

### duplicate_shown_name {:#duplicate_shown_name}

_Nome mostrado duplicado._

#### Descrição

O analisador produz este diagnóstico quando um nome ocorre várias vezes em
uma cláusula `show`. Repetir o nome é desnecessário.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `min` é mostrado
mais de uma vez:

```dart
import 'dart:math' show min, [!min!];

var x = min(2, min(0, 1));
```

#### Correções Comuns

Se o nome foi digitado incorretamente em um ou mais lugares, corrija os
nomes digitados incorretamente:

```dart
import 'dart:math' show max, min;

var x = max(2, min(0, 1));
```

Se o nome não foi digitado incorretamente, remova o nome desnecessário da
lista:

```dart
import 'dart:math' show min;

var x = min(2, min(0, 1));
```

### duplicate_variable_pattern {:#duplicate_variable_pattern}

_A variável '{0}' já está definida neste padrão._

#### Descrição

O analisador produz este diagnóstico quando um ramo de um padrão
*logical-and* declara uma variável que já está declarada em um ramo
anterior do mesmo padrão.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `a` é
declarada em ambos os ramos do padrão *logical-and*:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, var [!a!])) {
    print(a);
  }
}
```

#### Correções Comuns

Se você precisar capturar o valor correspondido em vários ramos, altere os
nomes das variáveis para que sejam exclusivos:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, var b)) {
    print(a + b);
  }
}
```

Se você só precisar capturar o valor correspondido em um ramo, remova o
padrão de variável de todos, exceto de um ramo:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, _)) {
    print(a);
  }
}
```

### empty_map_pattern {:#empty_map_pattern}

_Um padrão de mapa deve ter pelo menos uma entrada._

#### Descrição

O analisador produz este diagnóstico quando um padrão de mapa está vazio.

#### Exemplo

O código a seguir produz este diagnóstico porque o padrão de mapa
está vazio:

```dart
void f(Map<int, String> x) {
  if (x case [!{}!]) {}
}
```

#### Correções Comuns

Se o padrão deve corresponder a qualquer mapa, substitua-### empty_record_literal_with_comma {:#empty_record_literal_with_comma}

_Um literal de record sem campos não pode ter uma vírgula à direita._

#### Descrição

O analisador produz este diagnóstico quando um literal de record que não
possui campos tem uma vírgula à direita. Literais de record vazios não
podem conter uma vírgula.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal de record vazio
tem uma vírgula à direita:

```dart
var r = ([!,!]);
```

#### Correções comuns

Se o record deve ser vazio, remova a vírgula:

```dart
var r = ();
```

Se o record deve ter um ou mais campos, adicione as expressões usadas para
calcular os valores desses campos:

```dart
var r = (3, 4);
```

### empty_record_type_named_fields_list {:#empty_record_type_named_fields_list}

_A lista de campos nomeados em um tipo de record não pode estar vazia._

#### Descrição

O analisador produz este diagnóstico quando um tipo de record possui uma
lista vazia de campos nomeados.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de record possui
uma lista vazia de campos nomeados:

```dart
void f((int, int, {[!}!]) r) {}
```

#### Correções comuns

Se o record deve ter campos nomeados, adicione os tipos e nomes dos campos:

```dart
void f((int, int, {int z}) r) {}
```

Se o record não deve ter campos nomeados, remova as chaves:

```dart
void f((int, int) r) {}
```

### empty_record_type_with_comma {:#empty_record_type_with_comma}

_Um tipo de record sem campos não pode ter uma vírgula à direita._

#### Descrição

O analisador produz este diagnóstico quando um tipo de record que não
possui campos tem uma vírgula à direita. Tipos de record vazios não
podem conter uma vírgula.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de record vazio
tem uma vírgula à direita:

```dart
void f(([!,!]) r) {}
```

#### Correções comuns

Se o tipo de record deve ser vazio, remova a vírgula:

```dart
void f(() r) {}
```

Se o tipo de record deve ter um ou mais campos, adicione os tipos desses
campos:

```dart
void f((int, int) r) {}
```

### empty_struct {:#empty_struct}

_A classe '{0}' não pode estar vazia porque é uma subclasse de '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma subclasse de `Struct` ou
`Union` não possui nenhum campo. Ter um `Struct` ou `Union` vazio não é
suportado.

Para obter mais informações sobre FFI, consulte [Interoperação com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `C`, que estende
`Struct`, não declara nenhum campo:

```dart
import 'dart:ffi';

final class [!C!] extends Struct {}
```

#### Correções comuns

Se a classe deve ser um struct, declare um ou mais campos:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

Se a classe deve ser usada como um argumento de tipo para `Pointer`, faça
dela uma subclasse de `Opaque`:

```dart
import 'dart:ffi';

final class C extends Opaque {}
```

Se a classe não deve ser um struct, remova ou altere a cláusula `extends`:

```dart
class C {}
```

### enum_constant_same_name_as_enclosing {:#enum_constant_same_name_as_enclosing}

_O nome do valor do enum não pode ser o mesmo que o nome do enum._

#### Descrição

O analisador produz este diagnóstico quando um valor de enum tem o mesmo
nome que o enum no qual ele é declarado.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor de enum `E` tem o
mesmo nome que o enum envolvente `E`:

```dart
enum E {
  [!E!]
}
```

#### Correções comuns

Se o nome do enum estiver correto, renomeie a constante:

```dart
enum E {
  e
}
```

Se o nome da constante estiver correto, renomeie o enum:

```dart
enum F {
  E
}
```

### enum_constant_with_non_const_constructor {:#enum_constant_with_non_const_constructor}

_O construtor invocado não é um construtor 'const'._

#### Descrição

O analisador produz este diagnóstico quando um valor de enum está sendo
criado usando um construtor factory ou um construtor gerador que não está
marcado como `const`.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor de enum `e` está
sendo inicializado por um construtor factory:

```dart
enum E {
  [!e!]();

  factory E() => e;
}
```

#### Correções comuns

Use um construtor gerador marcado como `const`:

```dart
enum E {
  e._();

  factory E() => e;

  const E._();
}
```

### enum_mixin_with_instance_variable {:#enum_mixin_with_instance_variable}

_Mixins aplicados a enums não podem ter variáveis de instância._

#### Descrição

O analisador produz este diagnóstico quando um mixin que é aplicado a um
enum declara uma ou mais variáveis de instância. Isso não é permitido
porque os valores de enum são constantes e não há como o construtor no
enum inicializar nenhum dos campos do mixin.

#### Exemplo

O código a seguir produz este diagnóstico porque o mixin `M` define o
campo de instância `x`:

```dart
mixin M {
  int x = 0;
}

enum E with [!M!] {
  a
}
```

#### Correções comuns

Se você precisa aplicar o mixin, altere todos os campos de instância em
pares getter e setter e implemente-os no enum, se necessário:

```dart
mixin M {
  int get x => 0;
}

enum E with M {
  a
}
```

Se você não precisa aplicar o mixin, remova-o:

```dart
enum E {
  a
}
```

### enum_with_abstract_member {:#enum_with_abstract_member}

_'{0}' deve ter um corpo de método porque '{1}' é um enum._

#### Descrição

O analisador produz este diagnóstico quando um membro de um enum é
encontrado sem uma implementação concreta. Enums não podem conter
membros abstratos.

#### Exemplo

O código a seguir produz este diagnóstico porque `m` é um método abstrato
e `E` é um enum:

```dart
enum E {
  e;

  [!void m();!]
}
```

#### Correções comuns

Forneça uma implementação para o membro:

```dart
enum E {
  e;

  void m() {}
}
```

### enum_with_name_values {:#enum_with_name_values}

_O nome 'values' não é um nome válido para um enum._

#### Descrição

O analisador produz este diagnóstico quando um enum é declarado com o nome
`values`. Isso não é permitido porque o enum tem um campo estático
implícito chamado `values`, e os dois entrariam em conflito.

#### Exemplo

O código a seguir produz este diagnóstico porque há uma declaração de enum
que tem o nome `values`:

```dart
enum [!values!] {
  c
}
```

#### Correções comuns

Renomeie o enum para algo diferente de `values`.

### equal_elements_in_const_set {:#equal_elements_in_const_set}

_Dois elementos em um literal de conjunto constante não podem ser iguais._

#### Descrição

O analisador produz este diagnóstico quando dois elementos em um literal
de conjunto constante têm o mesmo valor. O conjunto só pode conter cada
valor uma vez, o que significa que um dos valores é desnecessário.

#### Exemplo

O código a seguir produz este diagnóstico porque a string `'a'` é
especificada duas vezes:

```dart
const Set<String> set = {'a', [!'a'!]};
```

#### Correções comuns

Remova um dos valores duplicados:

```dart
const Set<String> set = {'a'};
```

Observe que os conjuntos literais preservam a ordem de seus elementos,
portanto, a escolha de qual elemento remover pode afetar a ordem em que os
elementos são retornados por um iterador.

### equal_elements_in_set {:#equal_elements_in_set}

_Dois elementos em um literal de conjunto não devem ser iguais._

#### Descrição

O analisador produz este diagnóstico quando um elemento em um conjunto
não constante é o mesmo que um elemento anterior no mesmo conjunto. Se
dois elementos são os mesmos, o segundo valor é ignorado, o que faz com
que ter ambos os elementos seja inútil e provavelmente sinalize um bug.

#### Exemplo

O código a seguir produz este diagnóstico porque o elemento `1` aparece
duas vezes:

```dart
const a = 1;
const b = 1;
var s = <int>{a, [!b!]};
```

#### Correções comuns

Se ambos os elementos devem ser incluídos no conjunto, altere um dos
elementos:

```dart
const a = 1;
const b = 2;
var s = <int>{a, b};
```

Se apenas um dos elementos for necessário, remova aquele que não é
necessário:

```dart
const a = 1;
var s = <int>{a};
```

Observe que os conjuntos literais preservam a ordem de seus elementos,
portanto, a escolha de qual elemento remover pode afetar a ordem em que os
elementos são retornados por um iterador.

### equal_keys_in_const_map {:#equal_keys_in_const_map}

_Duas chaves em um literal de mapa constante não podem ser iguais._

#### Descrição

O analisador produz este diagnóstico quando uma chave em um mapa constante
é a mesma que uma chave anterior no mesmo mapa. Se duas chaves são as
mesmas, o segundo valor substituiria o primeiro valor, o que faz com que
ter ambos os pares seja inútil.

#### Exemplo

O código a seguir produz este diagnóstico porque a chave `1` é usada duas
vezes:

```dart
const map = <int, String>{1: 'a', 2: 'b', [!1!]: 'c', 4: 'd'};
```

#### Correções comuns

Se ambas as entradas devem ser incluídas no mapa, altere uma das chaves
para ser diferente:

```dart
const map = <int, String>{1: 'a', 2: 'b', 3: 'c', 4: 'd'};
```

Se apenas uma das entradas for necessária, remova aquela que não é
necessária:

```dart
const map = <int, String>{1: 'a', 2: 'b', 4: 'd'};
```

Observe que os mapas literais preservam a ordem de suas entradas,
portanto, a escolha de qual entrada remover pode afetar a ordem em que
chaves e valores são retornados por um iterador.

### equal_keys_in_map {:#equal_keys_in_map}

_Duas chaves em um literal de mapa não devem ser iguais._

#### Descrição

O analisador produz este diagnóstico quando uma chave em um mapa não
constante é a mesma que uma chave anterior no mesmo mapa. Se duas chaves
são as mesmas, o segundo valor substitui o primeiro valor, o que faz com
que ter ambos os pares seja inútil e provavelmente sinalize um bug.

#### Exemplo

O código a seguir produz este diagnóstico porque as chaves `a` e `b` têm o
mesmo valor:

```dart
const a = 1;
const b = 1;
var m = <int, String>{a: 'a', [!b!]: 'b'};
```

#### Correções comuns

Se ambas as entradas devem ser incluídas no mapa, altere uma das chaves:

```dart
const a = 1;
const b = 2;
var m = <int, String>{a: 'a', b: 'b'};
```

Se apenas uma das entradas for necessária, remova aquela que não é
necessária:

```dart
const a = 1;
var m = <int, String>{a: 'a'};
```

Observe que os mapas literais preservam a ordem de suas entradas,
portanto, a escolha de qual entrada remover pode afetar a ordem em que as
chaves e valores são retornados por um iterador.

### equal_keys_in_map_pattern {:#equal_keys_in_map_pattern}

_Duas chaves em um padrão de mapa não podem ser iguais._

#### Descrição

O analisador produz este diagnóstico quando um padrão de mapa contém mais
de uma chave com o mesmo nome. A mesma chave não pode ser correspondida
duas vezes.

#### Exemplo

O código a seguir produz este diagnóstico porque a chave `'a'` aparece
duas vezes:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1, [!'a'!]: 2}) {}
}
```

#### Correções comuns

Se você estiver tentando corresponder duas chaves diferentes, altere uma
das chaves no padrão:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1, 'b': 2}) {}
}
```

Se você estiver tentando corresponder a mesma chave, mas permitir que
qualquer um de vários padrões corresponda, use um padrão lógico-ou:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1 || 2}) {}
}
```

### expected_one_list_pattern_type_arguments {:#expected_one_list_pattern_type_arguments}

_Padrões de lista exigem um argumento de tipo ou nenhum, mas {0} encontrado(s)._

#### Descrição

O analisador produz este diagnóstico quando um padrão de lista tem mais de
um argumento de tipo. Padrões de lista podem ter zero argumentos de tipo
ou um argumento de tipo, mas não podem ter mais de um.

#### Exemplo

O código a seguir produz este diagnóstico porque o padrão de lista (`[0]`)
tem dois argumentos de tipo:

```dart
void f(Object x) {
  if (x case [!<int, int>!][0]) {}
}
```

#### Correções comuns

Remova todos os argumentos de tipo, exceto um:

```dart
void f(Object x) {
  if (x case <int>[0]) {}
}
```

### expected_one_list_type_arguments {:#expected_one_list_type_arguments}

_Literais de lista exigem um argumento de tipo ou nenhum, mas {0} encontrado(s)._

#### Descrição

O analisador produz este diagnóstico quando um literal de lista tem mais de
um argumento de tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal de lista tem
dois argumentos de tipo quando pode ter no máximo um:

```dart
var l = [!<int, int>!][];
```

#### Correções comuns

Remova todos os argumentos de tipo, exceto um:

```dart
var l = <int>[];
```

### expected_one_set_type_arguments {:#expected_one_set_type_arguments}

_Literais de conjunto exigem um argumento de tipo ou nenhum, mas {0} foram encontrados._

#### Descrição

O analisador produz este diagnóstico quando um literal de conjunto tem mais
de um argumento de tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal de conjunto tem
três argumentos de tipo quando pode ter no máximo um:

```dart
var s = [!<int, String, int>!]{0, 'a', 1};
```

#### Correções comuns

Remova todos os argumentos de tipo, exceto um:

```dart
var s = <int>{0, 1};
```

### expected_two_map_pattern_type_arguments {:#expected_two_map_pattern_type_arguments}

_Padrões de mapa exigem dois argumentos de tipo ou nenhum, mas {0} encontrado(s)._

#### Descrição

O analisador produz este diagnóstico quando um padrão de mapa tem um
argumento de tipo ou mais de dois argumentos de tipo. Padrões de mapa
podem ter dois argumentos de tipo ou zero argumentos de tipo, mas não
podem ter nenhum outro número.

#### Exemplo

O código a seguir produz este diagnóstico porque o padrão de mapa
(`<int>{}`) tem um argumento de tipo:

```dart
void f(Object x) {
  if (x case [!<int>!]{0: _}) {}
}
```

#### Correções comuns

Adicione ou remova argumentos de tipo até que haja dois ou nenhum:

```dart
void f(Object x) {
  if (x case <int, int>{0: _}) {}
}
```

### expected_two_map_type_arguments {:#expected_two_map_type_arguments}

_Literais de mapa exigem dois argumentos de tipo ou nenhum, mas {0} encontrados._

#### Descrição

O analisador produz este diagnóstico quando um literal de mapa tem um ou
mais de dois argumentos de tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal de mapa tem
três argumentos de tipo quando pode ter dois ou zero:

```dart
var m = [!<int, String, int>!]{};
```

#### Correções comuns

Remova todos os argumentos de tipo, exceto dois:

```dart
var m = <int, String>{};
```

### export_internal_library {:#export_internal_library}

_A biblioteca '{0}' é interna e não pode ser exportada._

#### Descrição

O analisador produz este diagnóstico quando encontra uma exportação cuja
URI `dart:` referencia uma biblioteca interna.

#### Exemplo

O código a seguir produz este diagnóstico porque `_interceptors` é uma
biblioteca interna:

```dart
export [!'dart:_interceptors'!];
```

#### Correções comuns

Remova a diretiva de exportação.

### export_legacy_symbol {:#export_legacy_symbol}

_O símbolo '{0}' é definido em uma biblioteca legada e não pode ser
re-exportado de uma biblioteca com segurança nula ativada._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca que foi ativada
para segurança nula exporta outra biblioteca e a biblioteca exportada não
está ativada para segurança nula.

#### Exemplo

Dado uma biblioteca que não está ativada para segurança nula:

```dart
// @dart = 2.8
String s;
```

O código a seguir produz este diagnóstico porque está exportando símbolos
de uma biblioteca desativada:

```dart
export [!'optedOut.dart'!];

class C {}
```

#### Correções comuns

Se você puder fazê-lo, migre a biblioteca exportada para que ela não
precise ser desativada:

```dart
String? s;
```

Se você não puder migrar a biblioteca, remova a exportação:

```dart
class C {}
```

Se a biblioteca exportada (aquela que está desativada) ela mesma exportar
uma biblioteca ativada, então é válido para sua biblioteca exportar
indiretamente os símbolos da biblioteca ativada. Você pode fazer isso
adicionando um combinador `hide` à diretiva de exportação em sua
biblioteca que oculta todos os nomes declarados na biblioteca desativada.

### export_of_non_library {:#export_of_non_library}

_A biblioteca exportada '{0}' não pode ter uma diretiva part-of._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva de exportação
referencia uma part (parte) em vez de uma biblioteca.

#### Exemplo

Dado um arquivo `part.dart` contendo

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque o arquivo `part.dart` é
uma part e apenas bibliotecas podem ser exportadas:

```dart
library lib;

export [!'part.dart'!];
```

#### Correções comuns

Remova a diretiva de exportação ou altere a URI para ser a URI da
biblioteca que contém a part.

### expression_in_map {:#expression_in_map}

_Expressões não podem ser usadas em um literal de mapa._

#### Descrição

O analisador produz este diagnóstico quando o analisador encontra uma
expressão, em vez de uma entrada de mapa, no que parece ser um literal de
mapa.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
var map = <String, int>{'a': 0, 'b': 1, [!'c'!]};
```

#### Correções comuns

Se a expressão deve calcular uma chave ou um valor em uma entrada, corrija
o problema substituindo a expressão pela chave ou pelo valor. Por exemplo:

```dart
var map = <String, int>{'a': 0, 'b': 1, 'c': 2};
```

### extends_non_class {:#extends_non_class}

_Classes só podem estender outras classes._

#### Descrição

O analisador produz este diagnóstico quando uma cláusula `extends` contém
um nome que é declarado como algo diferente de uma classe.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` é declarado como uma
função:

```dart
void f() {}

class C extends [!f!] {}
```

#### Correções comuns

Se você deseja que a classe estenda uma classe diferente de `Object`,
substitua o nome na cláusula `extends` pelo nome dessa classe:

```dart
void f() {}

class C extends B {}

class B {}
```

Se você deseja que a classe estenda `Object`, remova a cláusula
`extends`:

```dart
void f() {}

class C {}
```

### extension_as_expression {:#extension_as_expression}

_A extensão '{0}' não pode ser usada como uma expressão._

#### Descrição

O analisador produz este diagnóstico quando o nome de uma extensão é usado
em uma expressão que não seja em um override de extensão ou para
qualificar um acesso a um membro estático da extensão. Como as classes
definem um tipo, o nome de uma classe pode ser usado para se referir à
instância de `Type` que representa o tipo da classe. As extensões, por
outro lado, não definem um tipo e não podem ser usadas como um literal de
tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque `E` é uma extensão:

```dart
extension E on int {
  static String m() => '';
}

var x = [!E!];
```

#### Correções comuns

Substitua o nome da extensão por um nome que possa ser referenciado, como
um membro estático definido na extensão:

```dart
extension E on int {
  static String m() => '';
}

var x = E.m();
```

### extension_conflicting_static_and_instance {:#extension_conflicting_static_and_instance}

_Uma extensão não pode definir um membro estático '{0}' e um membro de
instância com o mesmo nome._

#### Descrição

O analisador produz este diagnóstico quando uma declaração de extensão
contém um membro de instância e um membro estático que têm o mesmo nome. O
membro de instância e o membro estático não podem ter o mesmo nome porque
não está claro qual membro está sendo referenciado por um uso não
qualificado do nome dentro do corpo da extensão.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `a` está sendo
usado para dois membros diferentes:

```dart
extension E on Object {
  int get a => 0;
  static int [!a!]() => 0;
}
```

#### Correções comuns

Renomeie ou remova um dos membros:

```dart
extension E on Object {
  int get a => 0;
  static int b() => 0;
}
```

### extension_declares_abstract_member {:#extension_declares_abstract_member}

_Extensões não podem declarar membros abstratos._

#### Descrição

O analisador produz este diagnóstico quando uma declaração abstrata é
declarada em uma extensão. Extensões só podem declarar membros concretos.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `a` não tem
corpo:

```dart
extension E on String {
  int [!a!]();
}
```

#### Correções comuns

Forneça uma implementação para o membro ou remova-o.

### extension_declares_constructor {:#extension_declares_constructor}

_Extensões não podem declarar construtores._

#### Descrição

O analisador produz este diagnóstico quando uma declaração de construtor é
encontrada em uma extensão. Não é válido definir um construtor porque as
extensões não são classes e não é possível criar uma instância de uma
extensão.

#### Exemplo

O código a seguir produz este diagnóstico porque há uma declaração de
construtor em `E`:

```dart
extension E on String {
  [!E!]() : super();
}
```

#### Correções comuns

Remova o construtor ou substitua-o por um método estático.

### extension_declares_instance_field {:#extension_declares_instance_field}

_Extensões não podem declarar campos de instância_

#### Descrição

O analisador produz este diagnóstico quando uma declaração de campo de
instância é encontrada em uma extensão. Não é válido definir um campo de
instância porque as extensões só podem adicionar comportamento, não estado.

#### Exemplo

O código a seguir produz este diagnóstico porque `s` é um campo de
instância:

```dart
extension E on String {
  String [!s!];
}
```

#### Correções comuns

Remova o campo, torne-o um campo estático ou converta-o em um getter,
setter ou método.

### extension_declares_member_of_object {:#extension_declares_member_of_object}

_Extensões não podem declarar membros com o mesmo nome que um membro
declarado por 'Object'._

#### Descrição

O analisador produz este diagnóstico quando uma declaração de extensão
declara um membro com o mesmo nome que um membro declarado na classe
`Object`. Tal membro nunca poderá ser usado porque o membro em `Object` é
sempre encontrado primeiro.

#### Exemplo

O código a seguir produz este diagnóstico porque `toString` é definido por
`Object`:

```dart
extension E on String {
  String [!toString!]() => this;
}
```

#### Correções comuns

Remova o membro ou renomeie-o para que o nome não entre em conflito com o
membro em `Object`:

```dart
extension E on String {
  String displayString() => this;
}
```

### extension_override_access_to_static_member {:#extension_override_access_to_static_member}

_Um override de extensão não pode ser usado para acessar um membro
estático de uma extensão._

#### Descrição

O analisador produz este diagnóstico quando um override de extensão é o
receptor da invocação de um membro estático. Semelhante aos membros
estáticos em classes, os membros estáticos de uma extensão devem ser
acessados usando o nome da extensão, não um override de extensão.

#### Exemplo

O código a seguir produz este diagnóstico porque `m` é estático:

```dart
extension E on String {
  static void m() {}
}

void f() {
  E('').[!m!]();
}
```

#### Correções comuns

Substitua o override de extensão pelo nome da extensão:

```dart
extension E on String {
  static void m() {}
}

void f() {
  E.m();
}
```

### extension_override_argument_not_assignable {:#extension_override_argument_not_assignable}

_O tipo do argumento para o override de extensão '{0}' não é atribuível ao
tipo estendido '{1}'._

#### Descrição

O analisador produz este diagnóstico quando o argumento para um override
de extensão não é atribuível ao tipo que está sendo estendido pela
extensão.

#### Exemplo

O código a seguir produz este diagnóstico porque `3` não é uma `String`:

```dart
extension E on String {
  void method() {}
}

void f() {
  E([!3!]).method();
}
```

#### Correções comuns

Se você estiver usando a extensão correta, atualize o argumento para ter o
tipo correto:

```dart
extension E on String {
  void method() {}
}

void f() {
  E(3.toString()).method();
}
```

Se houver uma extensão diferente que seja válida para o tipo do argumento,
substitua o nome da extensão ou remova o argumento para que a extensão
correta seja encontrada.

### extension_override_without_access {:#extension_override_without_access}

_Um override de extensão só pode ser usado para acessar membros de
instância._

#### Descrição

O analisador produz este diagnóstico quando um override de extensão é
encontrado e não está sendo usado para acessar um dos membros da extensão.
A sintaxe de override de extensão não tem nenhuma semântica de tempo de
execução; ela só controla qual membro é selecionado em tempo de
compilação.

#### Exemplo

O código a seguir produz este diagnóstico porque `E(i)` não é uma
expressão:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print([!E(i)!]);
}
```

#### Correções comuns

Se você deseja invocar um dos membros da extensão, adicione a invocação:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print(E(i).a);
}
```

Se você não deseja invocar um membro, remova o argumento:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print(i);
}
```

### extension_override_with_cascade {:#extension_override_with_cascade}

_Overrides de extensão não têm valor, portanto, não podem ser usados como
o receptor de uma expressão em cascata._

#### Descrição

O analisador produz este diagnóstico quando um override de extensão é
usado como o receptor de uma expressão em cascata. O valor de uma
expressão em cascata `e..m` é o valor do receptor `e`, mas overrides de
extensão não são expressões e não têm valor.

#### Exemplo

O código a seguir produz este diagnóstico porque `E(3)` não é uma
expressão:

```dart
extension E on int {
  void m() {}
}
f() {
  [!E!](3)..m();
}
```

#### Correções comuns

Use `.` em vez de `..`:

```dart
extension E on int {
  void m() {}
}
f() {
  E(3).m();
}
```

Se houver vários acessos em cascata, você precisará duplicar o override de
extensão para cada um deles.

### extension_type_constructor_with_super_formal_parameter {:#extension_type_constructor_with_super_formal_parameter}

_Construtores de tipos de extensão não podem declarar parâmetros formais
super._

#### Descrição

O analisador produz este diagnóstico quando um construtor em um tipo de
extensão tem um super parâmetro. Super parâmetros não são válidos porque
tipos de extensão não têm uma superclasse.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor nomeado `n`
contém um super parâmetro:

```dart
extension type E(int i) {
  E.n(this.i, [!super!].foo);
}
```

#### Correções comuns

Se você precisar do parâmetro, substitua o super parâmetro por um
parâmetro normal:

```dart
extension type E(int i) {
  E.n(this.i, String foo);
}
```

Se você não precisar do parâmetro, remova o super parâmetro:

```dart
extension type E(int i) {
  E.n(this.i);
}
```

### extension_type_constructor_with_super_invocation {:#extension_type_constructor_with_super_invocation}

_Construtores de tipos de extensão não podem incluir inicializadores
super._

#### Descrição

O analisador produz este diagnóstico quando um construtor em um tipo de
extensão inclui uma invocação de um super construtor na lista de
inicializadores. Como os tipos de extensão não têm uma superclasse, não
há construtor para invocar.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor `E.n` invoca
um super construtor em sua lista de inicializadores:

```dart
extension type E(int i) {
  E.n() : i = 0, [!super!].n();
}
```

#### Correções comuns

Remova a invocação do super construtor:

```dart
extension type E(int i) {
  E.n() : i = 0;
}
```

### extension_type_declares_instance_field {:#extension_type_declares_instance_field}

_Tipos de extensão não podem declarar campos de instância._

#### Descrição

O analisador produz este diagnóstico quando há uma declaração de campo no
corpo de uma declaração de tipo de extensão.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de extensão `E`
declara um campo chamado `f`:

```dart
extension type E(int i) {
  final int [!f!] = 0;
}
```

#### Correções comuns

Se você não precisar do campo, remova-o ou substitua-o por um getter
e/ou setter:

```dart
extension type E(int i) {
  int get f => 0;
}
```

Se você precisar do campo, converta o tipo de extensão em uma classe:

```dart
class E {
  final int i;

  final int f = 0;

  E(this.i);
}
```
### extension_type_declares_member_of_object {:#extension_type_declares_member_of_object}

_Tipos de extensão (extension types) não podem declarar membros com o mesmo nome de um membro declarado por 'Object'._

#### Descrição

O analisador produz este diagnóstico quando o corpo de uma declaração de tipo de extensão
contém um membro com o mesmo nome de um dos membros
declarados por `Object`.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `Object`
já define um membro chamado `hashCode`:

```dart
extension type E(int i) {
  int get [!hashCode!] => 0;
}
```

#### Correções comuns

Se você precisa de um membro com a semântica implementada, então renomeie o
membro:

```dart
extension type E(int i) {
  int get myHashCode => 0;
}
```

Se você não precisa de um membro com a semântica implementada, então remova o
membro:

```dart
extension type E(int i) {}
```

### extension_type_implements_disallowed_type {:#extension_type_implements_disallowed_type}

_Tipos de extensão (extension types) não podem implementar '{0}'._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão implementa um
tipo que não tem permissão para implementar.

#### Exemplo

O código a seguir produz este diagnóstico porque tipos de extensão não podem
implementar o tipo `dynamic`:

```dart
extension type A(int i) implements [!dynamic!] {}
```

#### Correções comuns

Remova o tipo não permitido da cláusula implements:

```dart
extension type A(int i) {}
```

### extension_type_implements_itself {:#extension_type_implements_itself}

_O tipo de extensão (extension type) não pode implementar a si mesmo._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão implementa
a si mesmo, seja direta ou indiretamente.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de extensão `A`
implementa diretamente a si mesmo:

```dart
extension type [!A!](int i) implements A {}
```

O código a seguir produz este diagnóstico porque o tipo de extensão `A`
implementa indiretamente a si mesmo (através de `B`):

```dart
extension type [!A!](int i) implements B {}

extension type [!B!](int i) implements A {}
```

#### Correções comuns

Quebre o ciclo removendo um tipo da cláusula implements de pelo menos
um dos tipos envolvidos no ciclo:

```dart
extension type A(int i) implements B {}

extension type B(int i) {}
```

### extension_type_implements_not_supertype {:#extension_type_implements_not_supertype}

_'{0}' não é um supertipo de '{1}', o tipo de representação._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão implementa um
tipo que não é um supertipo do tipo de representação.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de extensão `A`
implementa `String`, mas `String` não é um supertipo do tipo de representação
`int`:

```dart
extension type A(int i) implements [!String!] {}
```

#### Correções comuns

Se o tipo de representação estiver correto, remova ou substitua o tipo na
cláusula implements:

```dart
extension type A(int i) {}
```

Se o tipo de representação não estiver correto, então substitua-o pelo tipo
correto:

```dart
extension type A(String s) implements String {}
```

### extension_type_implements_representation_not_supertype {:#extension_type_implements_representation_not_supertype}

_'{0}', o tipo de representação de '{1}', não é um supertipo de '{2}', o
tipo de representação de '{3}'._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão implementa
outro tipo de extensão, e o tipo de representação do tipo de extensão
implementado não é um subtipo do tipo de representação do tipo de extensão
implementador.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de extensão `B`
implementa `A`, mas o tipo de representação de `A` (`num`) não é um
subtipo do tipo de representação de `B` (`String`):

```dart
extension type A(num i) {}

extension type B(String s) implements [!A!] {}
```

#### Correções comuns

Altere os tipos de representação dos dois tipos de extensão para que
o tipo de representação do tipo implementado seja um supertipo do
tipo de representação do tipo implementador:

```dart
extension type A(num i) {}

extension type B(int n) implements A {}
```

Ou remova o tipo implementado da cláusula implements:

```dart
extension type A(num i) {}

extension type B(String s) {}
```

### extension_type_inherited_member_conflict {:#extension_type_inherited_member_conflict}

_O tipo de extensão (extension type) '{0}' tem mais de um membro distinto chamado '{1}' dos tipos implementados._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão implementa
dois ou mais outros tipos, e pelo menos dois desses tipos declaram um membro
com o mesmo nome.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de extensão `C`
implementa `A` e `B`, e ambos declaram um membro chamado `m`:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void m() {}
}

extension type [!C!](A a) implements A, B {}
```

#### Correções comuns

Se o tipo de extensão não precisa implementar todos os tipos listados,
remova todos, exceto um dos tipos que introduzem os membros conflitantes:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void m() {}
}

extension type C(A a) implements A {}
```

Se o tipo de extensão precisa implementar todos os tipos listados, mas você
pode renomear os membros nesses tipos, dê aos membros conflitantes
nomes únicos:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void n() {}
}

extension type C(A a) implements A, B {}
```

### extension_type_representation_depends_on_itself {:#extension_type_representation_depends_on_itself}

_A representação do tipo de extensão (extension type) não pode depender de si mesma._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão tem um
tipo de representação que depende do próprio tipo de extensão, seja
direta ou indiretamente.

#### Exemplo

O código a seguir produz este diagnóstico porque a representação
tipo do tipo de extensão `A` depende de `A` diretamente:

```dart
extension type [!A!](A a) {}
```

Os dois exemplos de código a seguir produzem este diagnóstico porque o
tipo de representação do tipo de extensão `A` depende de `A`
indiretamente através do tipo de extensão `B`:

```dart
extension type [!A!](B b) {}

extension type [!B!](A a) {}
```

```dart
extension type [!A!](List<B> b) {}

extension type [!B!](List<A> a) {}
```

#### Correções comuns

Remova a dependência escolhendo um tipo de representação diferente para
pelo menos um dos tipos no ciclo:

```dart
extension type A(String s) {}
```

### extension_type_representation_type_bottom {:#extension_type_representation_type_bottom}

_O tipo de representação não pode ser um tipo bottom._

#### Descrição

O analisador produz este diagnóstico quando o tipo de representação de um
tipo de extensão é o [tipo bottom][tipo bottom] `Never`. O tipo `Never` não pode ser
o tipo de representação de um tipo de extensão porque não há valores
que podem ser estendidos.

#### Exemplo

O código a seguir produz este diagnóstico porque a representação
tipo do tipo de extensão `E` é `Never`:

```dart
extension type E([!Never!] n) {}
```

#### Correções comuns

Substitua o tipo de extensão por um tipo diferente:

```dart
extension type E(String s) {}
```

### extension_type_with_abstract_member {:#extension_type_with_abstract_member}

_'{0}' deve ter um corpo de método porque '{1}' é um tipo de extensão (extension type)._

#### Descrição

O analisador produz este diagnóstico quando um tipo de extensão declara um
membro abstrato. Como as referências de membros de tipo de extensão são resolvidas
estaticamente, um membro abstrato em um tipo de extensão nunca poderia ser
executado.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `m` no
tipo de extensão `E` é abstrato:

```dart
extension type E(String s) {
  [!void m();!]
}
```

#### Correções comuns

Se o membro se destina a ser executável, forneça uma implementação
do membro:

```dart
extension type E(String s) {
  void m() {}
}
```

Se o membro não se destina a ser executável, remova-o:

```dart
extension type E(String s) {}
```

### external_with_initializer {:#external_with_initializer}

_Campos externos (external) não podem ter inicializadores._

_Variáveis externas (external) não podem ter inicializadores._

#### Descrição

O analisador produz este diagnóstico quando um campo ou variável marcada com
a palavra-chave `external` tem um inicializador, ou quando um campo externo é
inicializado em um construtor.

#### Exemplos

O código a seguir produz este diagnóstico porque o campo externo `x`
recebe um valor em um inicializador:

```dart
class C {
  external int x;
  C() : [!x!] = 0;
}
```

O código a seguir produz este diagnóstico porque o campo externo `x`
tem um inicializador:

```dart
class C {
  external final int [!x!] = 0;
}
```

O código a seguir produz este diagnóstico porque a variável externa de nível superior
`x` tem um inicializador:

```dart
external final int [!x!] = 0;
```

#### Correções comuns

Remova o inicializador:

```dart
class C {
  external final int x;
}
```

### extra_annotation_on_struct_field {:#extra_annotation_on_struct_field}

_Campos em uma classe struct devem ter exatamente uma anotação indicando o tipo nativo._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem mais de uma anotação descrevendo o tipo nativo do
campo.

Para obter mais informações sobre FFI, consulte [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `x` tem duas
anotações descrevendo o tipo nativo do campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  [!@Int16()!]
  external int x;
}
```

#### Correções comuns

Remova todas, exceto uma das anotações:

```dart
import 'dart:ffi';
final class C extends Struct {
  @Int32()
  external int x;
}
```

### extra_positional_arguments {:#extra_positional_arguments}

_Muitos argumentos posicionais: {0} esperados, mas {1} encontrados._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de método ou função
tem mais argumentos posicionais do que o método ou função permite.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` define 2
parâmetros, mas é invocado com 3 argumentos:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2, [!3!]);
}
```

#### Correções comuns

Remova os argumentos que não correspondem aos parâmetros:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2);
}
```

### extra_positional_arguments_could_be_named {:#extra_positional_arguments_could_be_named}

_Muitos argumentos posicionais: {0} esperados, mas {1} encontrados._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de método ou função
tem mais argumentos posicionais do que o método ou função permite, mas o
método ou função define parâmetros nomeados.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` define 2
parâmetros posicionais, mas tem um parâmetro nomeado que poderia ser usado para o
terceiro argumento:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2, [!3!]);
}
```

#### Correções comuns

Se alguns dos argumentos devem ser valores para parâmetros nomeados, adicione
os nomes antes dos argumentos:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2, c: 3);
}
```

Caso contrário, remova os argumentos que não correspondem a parâmetros posicionais:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2);
}
```

### extra_size_annotation_carray {:#extra_size_annotation_carray}

_Arrays devem ter exatamente uma anotação 'Array'._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem mais de uma anotação descrevendo o tamanho do array nativo.

Para obter mais informações sobre FFI, consulte [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `a0` tem duas
anotações que especificam o tamanho do array nativo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(4)
  [!@Array(8)!]
  external Array<Uint8> a0;
}
```

#### Correções comuns

Remova todas, exceto uma das anotações:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

### ffi_native_invalid_duplicate_default_asset {:#ffi_native_invalid_duplicate_default_asset}

_Pode haver no máximo uma anotação @DefaultAsset em uma biblioteca._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva library tem mais
de uma anotação `DefaultAsset` associada a ela.

#### Exemplo

O código a seguir produz este diagnóstico porque a diretiva library
tem duas anotações `DefaultAsset` associadas a ela:

```dart
@DefaultAsset('a')
@[!DefaultAsset!]('b')
library;

import 'dart:ffi';
```

#### Correções comuns

Remova todas, exceto uma das anotações `DefaultAsset`:

```dart
@DefaultAsset('a')
library;

import 'dart:ffi';
```

### ffi_native_invalid_multiple_annotations {:#ffi_native_invalid_multiple_annotations}

_Funções e campos nativos devem ter exatamente uma anotação `@Native`._

#### Descrição

O analisador produz este diagnóstico quando há mais de uma anotação `Native`
em uma única declaração.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f` tem
duas anotações `Native` associadas a ela:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>()
@[!Native!]<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```

#### Correções comuns

Remova todas, exceto uma das anotações:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```

### ffi_native_must_be_external {:#ffi_native_must_be_external}

_Funções nativas devem ser declaradas como external._

#### Descrição

O analisador produz este diagnóstico quando uma função anotada como sendo
`@Native` não é marcada como `external`.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `free` é
anotada como sendo `@Native`, mas a função não é marcada como `external`:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
void [!free!](Pointer<Void> ptr) {}
```

#### Correções comuns

Se a função for uma função nativa, adicione o modificador `external`
antes do tipo de retorno:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
external void free(Pointer<Void> ptr);
```

### ffi_native_unexpected_number_of_parameters {:#ffi_native_unexpected_number_of_parameters}

_Número inesperado de parâmetros de anotação Native. Esperado {0}, mas tem {1}._

#### Descrição

O analisador produz este diagnóstico quando o número de parâmetros no
tipo de função usado como argumento de tipo para a anotação `@Native` não
corresponde ao número de parâmetros na função que está sendo anotada.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de função usado
como argumento de tipo para a anotação `@Native` (`Void Function(Double)`)
tem um argumento e o tipo da função anotada
(`void f(double, double)`) tem dois argumentos:

```dart
import 'dart:ffi';

@Native<Void Function(Double)>(symbol: 'f')
external void [!f!](double x, double y);
```

#### Correções comuns

Se a função anotada estiver correta, atualize o tipo de função no
anotação `@Native` para corresponder:

```dart
import 'dart:ffi';

@Native<Void Function(Double, Double)>(symbol: 'f')
external void f(double x, double y);
```

Se o tipo de função na anotação `@Native` estiver correto, atualize
a função anotada para corresponder:

```dart
import 'dart:ffi';

@Native<Void Function(Double)>(symbol: 'f')
external void f(double x);
```

### ffi_native_unexpected_number_of_parameters_with_receiver {:#ffi_native_unexpected_number_of_parameters_with_receiver}

_Número inesperado de parâmetros de anotação Native. Esperado {0}, mas tem {1}.
A anotação do método de instância nativa deve ter o receptor como primeiro argumento._

#### Descrição

O analisador produz este diagnóstico quando o argumento de tipo usado no
anotação `@Native` de um método nativo não inclui um tipo para o
receptor do método.

#### Exemplo

O código a seguir produz este diagnóstico porque o argumento de tipo em
anotação `@Native` (`Void Function(Double)`) não inclui um tipo
para o receptor do método:

```dart
import 'dart:ffi';

class C {
  @Native<Void Function(Double)>()
  external void [!f!](double x);
}
```

#### Correções comuns

Adicione um parâmetro inicial cujo tipo seja o mesmo da classe em que o
método nativo está sendo declarado:

```dart
import 'dart:ffi';

class C {
  @Native<Void Function(C, Double)>()
  external void f(double x);
}
```

### field_initialized_by_multiple_initializers {:#field_initialized_by_multiple_initializers}

_O campo '{0}' não pode ser inicializado duas vezes no mesmo construtor._

#### Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor inicializa um campo mais de uma vez. Não há valor para permitir
ambos os inicializadores porque apenas o último valor é preservado.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `f` está sendo
inicializado duas vezes:

```dart
class C {
  int f;

  C() : f = 0, [!f!] = 1;
}
```

#### Correções comuns

Remova um dos inicializadores:

```dart
class C {
  int f;

  C() : f = 0;
}
```

### field_initialized_in_initializer_and_declaration {:#field_initialized_in_initializer_and_declaration}

_Campos não podem ser inicializados no construtor se forem final e já foram
inicializados em sua declaração._

#### Descrição

O analisador produz este diagnóstico quando um campo final é inicializado em
tanto a declaração do campo quanto em um inicializador em um construtor.
Campos finais só podem ser atribuídos uma vez, então não podem ser inicializados em ambos
lugares.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` é:

```dart
class C {
  final int f = 0;
  C() : [!f!] = 1;
}
```

#### Correções comuns

Se a inicialização não depender de nenhum valor passado para o
construtor, e se todos os construtores precisarem inicializar o campo para
o mesmo valor, remova o inicializador do construtor:

```dart
class C {
  final int f = 0;
  C();
}
```

Se a inicialização depender de um valor passado para o construtor, ou se
construtores diferentes precisam inicializar o campo de forma diferente, remova o inicializador na declaração do campo:

```dart
class C {
  final int f;
  C() : f = 1;
}
```

### field_initialized_in_parameter_and_initializer {:#field_initialized_in_parameter_and_initializer}

_Campos não podem ser inicializados tanto na lista de parâmetros quanto nos inicializadores._

#### Descrição

O analisador produz este diagnóstico quando um campo é inicializado em ambos
a lista de parâmetros e na lista de inicializadores de um construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `f` é
inicializado tanto por um parâmetro formal inicializador quanto no
lista de inicializadores:

```dart
class C {
  int f;

  C(this.f) : [!f!] = 0;
}
```

#### Correções comuns

Se o campo deve ser inicializado pelo parâmetro, remova o
inicialização na lista de inicializadores:

```dart
class C {
  int f;

  C(this.f);
}
```

Se o campo deve ser inicializado na lista de inicializadores e o
parâmetro não é necessário, remova o parâmetro:

```dart
class C {
  int f;

  C() : f = 0;
}
```

Se o campo deve ser inicializado na lista de inicializadores e o
parâmetro é necessário, torne-o um parâmetro normal:

```dart
class C {
  int f;

  C(int g) : f = g * 2;
}
```

### field_initializer_factory_constructor {:#field_initializer_factory_constructor}

_Parâmetros formais inicializadores não podem ser usados em construtores factory._

#### Descrição

O analisador produz este diagnóstico quando um construtor factory tem um
parâmetro formal inicializador. Construtores factory não podem atribuir valores para
campos porque nenhuma instância é criada; portanto, não há campo para atribuir.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor factory
usa um parâmetro formal inicializador:

```dart
class C {
  int? f;

  factory C([!this.f!]) => throw 0;
}
```

#### Correções comuns

Substitua o parâmetro formal inicializador por um parâmetro normal:

```dart
class C {
  int? f;

  factory C(int f) => throw 0;
}
```

### field_initializer_in_struct {:#field_initializer_in_struct}

_Construtores em subclasses de 'Struct' e 'Union' não podem ter inicializadores de campo._

#### Descrição

O analisador produz este diagnóstico quando um construtor em uma subclasse de
`Struct` ou `Union` tem um ou mais inicializadores de campo.

Para obter mais informações sobre FFI, consulte [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `C` tem um
construtor com um inicializador para o campo `f`:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  int f;

  C() : [!f = 0!];
}
```

#### Correções comuns

Remova o inicializador de campo:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  int f;

  C();
}
```

### field_initializer_not_assignable {:#field_initializer_not_assignable}

_O tipo do inicializador '{0}' não pode ser atribuído ao tipo do campo '{1}' em um construtor const._

_O tipo do inicializador '{0}' não pode ser atribuído ao tipo do campo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor inicializa um campo com um valor que não é atribuível ao
campo.

#### Exemplo

O código a seguir produz este diagnóstico porque `0` tem o tipo `int`,
e um `int` não pode ser atribuído a um campo do tipo `String`:

```dart
class C {
  String s;

  C() : s = [!0!];
}
```

#### Correções comuns

Se o tipo do campo estiver correto, altere o valor atribuído a ele
para que o valor tenha um tipo válido:

```dart
class C {
  String s;

  C() : s = '0';
}
```

Se o tipo do valor estiver correto, altere o tipo do campo para
permitir a atribuição:

```dart
class C {
  int s;

  C() : s = 0;
}
```

### field_initializer_outside_constructor {:#field_initializer_outside_constructor}

_Parâmetros formais de campo só podem ser usados em um construtor._

_Parâmetros formais inicializadores só podem ser usados em construtores._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro formal inicializador
é usado na lista de parâmetros para qualquer coisa que não seja um
construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque o inicializador
parâmetro formal `this.x` está sendo usado no método `m`:

```dart
class A {
  int x = 0;

  m([[!this.x!] = 0]) {}
}
```

#### Correções comuns

Substitua o parâmetro formal inicializador por um parâmetro normal e
atribua o campo dentro do corpo do método:

```dart
class A {
  int x = 0;

  m([int x = 0]) {
    this.x = x;
  }
}
```

### field_initializer_redirecting_constructor {:#field_initializer_redirecting_constructor}

_O construtor de redirecionamento não pode ter um inicializador de campo._

#### Descrição

O analisador produz este diagnóstico quando um construtor de redirecionamento
inicializa um campo no objeto. Isso não é permitido porque a instância
que tem o campo não foi criada no ponto em que deve ser
inicializado.

#### Exemplos

O código a seguir produz este diagnóstico porque o construtor
`C.zero`, que redireciona para o construtor `C`, tem um inicializador
parâmetro formal que inicializa o campo `f`:

```dart
class C {
  int f;

  C(this.f);

  C.zero([!this.f!]) : this(f);
}
```

O código a seguir produz este diagnóstico porque o construtor
`C.zero`, que redireciona para o construtor `C`, tem um inicializador que
inicializa o campo `f`:

```dart
class C {
  int f;

  C(this.f);

  C.zero() : [!f = 0!], this(1);
}
```

#### Correções comuns

Se a inicialização for feita por um parâmetro formal inicializador,
use um parâmetro normal:

```dart
class C {
  int f;

  C(this.f);

  C.zero(int f) : this(f);
}
```

Se a inicialização for feita em um inicializador, remova o
inicializador:

```dart
class C {
  int f;

  C(this.f);

  C.zero() : this(0);
}
```

### field_initializing_formal_not_assignable {:#field_initializing_formal_not_assignable}

_O tipo de parâmetro '{0}' é incompatível com o tipo de campo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando o tipo de um inicializador
parâmetro formal não é atribuível ao tipo do campo sendo
inicializado.

#### Exemplo

O código a seguir produz este diagnóstico porque o inicializador
parâmetro formal tem o tipo `String`, mas o tipo do campo é
`int`. O parâmetro deve ter um tipo que seja um subtipo do tipo do campo.

```dart
class C {
  int f;

  C([!String this.f!]);
}
```

#### Correções comuns

Se o tipo do campo estiver incorreto, altere o tipo do campo para
corresponder ao tipo do parâmetro e considere remover o tipo do
parâmetro:

```dart
class C {
  String f;

  C(this.f);
}
```

Se o tipo do parâmetro estiver incorreto, remova o tipo do
parâmetro:

```dart
class C {
  int f;

  C(this.f);
}
```

Se os tipos do campo e do parâmetro estiverem corretos, use um
inicializador em vez de um parâmetro formal inicializador para converter o
valor do parâmetro em um valor do tipo correto:

```dart
class C {
  int f;

  C(String s) : f = int.parse(s);
}
```

### field_in_struct_with_initializer {:#field_in_struct_with_initializer}

_Campos em subclasses de 'Struct' e 'Union' não podem ter inicializadores._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem um inicializador.

Para obter mais informações sobre FFI, consulte [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `p` tem um
inicializador:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer [!p!] = nullptr;
}
```

#### Correções comuns

Remova o inicializador:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer p;
}
```

### field_must_be_external_in_struct {:#field_must_be_external_in_struct}

_Campos de subclasses de 'Struct' e 'Union' devem ser marcados como external._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` não é marcado como `external`.

Para obter mais informações sobre FFI, consulte [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `a` não é
marcado como `external`:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  int [!a!];
}
```

#### Correções comuns

Adicione o modificador `external` necessário:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  external int a;
}
```

### final_initialized_in_declaration_and_constructor {:#final_initialized_in_declaration_and_constructor}

_'{0}' é final e recebeu um valor quando foi declarado, portanto, não pode ser definido para um novo valor._

#### Descrição

O analisador produz este diagnóstico quando um campo final é inicializado
duas vezes: uma vez onde é declarado e uma vez pelo parâmetro de um construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `f` é
inicializado duas vezes:

```dart
class C {
  final int f = 0;

  C(this.[!f!]);
}
```

#### Correções comuns

Se o campo deve ter o mesmo valor para todas as instâncias, remova o
inicialização na lista de parâmetros:

```dart
class C {
  final int f = 0;

  C();
}
```

Se o campo puder ter valores diferentes em instâncias diferentes, remova
a inicialização na declaração:

```dart
class C {
  final int f;

  C(this.f);
}
```

### final_not_initialized {:#final_not_initialized}

_A variável final '{0}' deve ser inicializada._

#### Descrição

O analisador produz este diagnóstico quando um campo ou variável final não é
inicializado.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` não tem um
inicializador:

```dart
final [!x!];
```

#### Correções comuns

Para variáveis e campos estáticos, você pode adicionar um inicializador:

```dart
final x = 0;
```

Para campos de instância, você pode adicionar um inicializador como mostrado no exemplo anterior,
ou você pode inicializar o campo em todos os construtores. Você pode
inicializar o campo usando um parâmetro formal inicializador:

```dart
class C {
  final int x;
  C(this.x);
}
```

Você também pode inicializar o campo usando um inicializador no
construtor:

```dart
class C {
  final int x;
  C(int y) : x = y * 2;
}
```

### final_not_initialized_constructor {:#final_not_initialized_constructor}

_Todas as variáveis `final` devem ser inicializadas, mas '{0}' e '{1}' não são._

_Todas as variáveis `final` devem ser inicializadas, mas '{0}' não é._

_Todas as variáveis `final` devem ser inicializadas, mas '{0}', '{1}' e mais {2} não são._

#### Descrição

O analisador produz esse diagnóstico quando uma classe define um ou mais
campos de instância `final` sem inicializadores e tem pelo menos um construtor
que não inicializa esses campos. Todos os campos de instância `final` devem ser
inicializados quando a instância é criada, seja pelo inicializador do campo ou
pelo construtor.

#### Exemplo

O código a seguir produz esse diagnóstico:

```dart
class C {
  final String value;

  [!C!]();
}
```

#### Correções comuns

Se o valor deve ser passado diretamente para o construtor, então use um
parâmetro formal de inicialização para inicializar o campo `value`:

```dart
class C {
  final String value;

  C(this.value);
}
```

Se o valor deve ser computado indiretamente a partir de um valor fornecido pelo
chamador, adicione um parâmetro e inclua um inicializador:

```dart
class C {
  final String value;

  C(Object o) : value = o.toString();
}
```

Se o valor do campo não depende de valores que podem ser passados para o
construtor, adicione um inicializador para o campo como parte da declaração do
campo:

```dart
class C {
  final String value = '';

  C();
}
```

Se o valor do campo não depende de valores que podem ser passados para o
construtor, mas diferentes construtores precisam inicializá-lo com
valores diferentes, adicione um inicializador para o campo na lista de
inicializadores:

```dart
class C {
  final String value;

  C() : value = '';

  C.named() : value = 'c';
}
```

No entanto, se o valor for o mesmo para todas as instâncias, considere usar um
campo `static` em vez de um campo de instância:

```dart
class C {
  static const String value = '';

  C();
}
```

### flutter_field_not_map {:#flutter_field_not_map}

_O valor do campo 'flutter' deve ser um mapa (map)._

#### Descrição

O analisador produz esse diagnóstico quando o valor da chave `flutter` não é um mapa (map).

#### Exemplo

O código a seguir produz esse diagnóstico porque o valor da
chave `flutter` de nível superior é uma string:

```yaml
name: example
flutter: [!true!]
```

#### Correções comuns

Se você precisa especificar opções específicas do Flutter, altere o valor para
ser um mapa (map):

```yaml
name: example
flutter:
  uses-material-design: true
```

Se você não precisa especificar opções específicas do Flutter, remova a chave
`flutter`:

```yaml
name: example
```

### for_in_of_invalid_element_type {:#for_in_of_invalid_element_type}

_O tipo '{0}' usado no loop 'for' deve implementar '{1}' com um argumento de tipo
que pode ser atribuído a '{2}'. _

#### Descrição

O analisador produz esse diagnóstico quando o `Iterable` ou `Stream` em um
loop for-in tem um tipo de elemento que não pode ser atribuído à variável de
loop.

#### Exemplo

O código a seguir produz esse diagnóstico porque `<String>[]` tem um
tipo de elemento `String`, e `String` não pode ser atribuído ao tipo de `e`
(`int`):

```dart
void f() {
  for (int e in [!<String>[]!]) {
    print(e);
  }
}
```

#### Correções comuns

Se o tipo da variável de loop estiver correto, atualize o tipo do
iterável (iterable):

```dart
void f() {
  for (int e in <int>[]) {
    print(e);
  }
}
```

Se o tipo do iterável (iterable) estiver correto, atualize o tipo da variável de loop:

```dart
void f() {
  for (String e in <String>[]) {
    print(e);
  }
}
```

### for_in_of_invalid_type {:#for_in_of_invalid_type}

_O tipo '{0}' usado no loop 'for' deve implementar '{1}'. _

#### Descrição

O analisador produz esse diagnóstico quando a expressão após `in` em um
loop for-in tem um tipo que não é uma subclasse de `Iterable`.

#### Exemplo

O código a seguir produz esse diagnóstico porque `m` é um `Map`, e
`Map` não é uma subclasse de `Iterable`:

```dart
void f(Map<String, String> m) {
  for (String s in [!m!]) {
    print(s);
  }
}
```

#### Correções comuns

Substitua a expressão por uma que produza um valor iterável (iterable):

```dart
void f(Map<String, String> m) {
  for (String s in m.values) {
    print(s);
  }
}
```

### for_in_with_const_variable {:#for_in_with_const_variable}

_Uma variável de loop for-in não pode ser 'const'._

#### Descrição

O analisador produz esse diagnóstico quando a variável de loop declarada em um
loop for-in é declarada como `const`. A variável não pode ser `const`
porque o valor não pode ser computado em tempo de compilação.

#### Exemplo

O código a seguir produz esse diagnóstico porque a variável de loop `x`
é declarada como `const`:

```dart
void f() {
  for ([!const!] x in [0, 1, 2]) {
    print(x);
  }
}
```

#### Correções comuns

Se houver uma anotação de tipo, remova o modificador `const` do
declaração.

Se não houver tipo, substitua o modificador `const` por `final`, `var` ou
uma anotação de tipo:

```dart
void f() {
  for (final x in [0, 1, 2]) {
    print(x);
  }
}
```

### generic_method_type_instantiation_on_dynamic {:#generic_method_type_instantiation_on_dynamic}

_Um tear-off de método em um receptor cujo tipo é 'dynamic' não pode ter
argumentos de tipo._

#### Descrição

O analisador produz esse diagnóstico quando um método de instância está sendo
extraído de um receptor cujo tipo é `dynamic`, e o tear-off inclui
argumentos de tipo. Como o analisador não pode saber quantos parâmetros de tipo o
método tem, ou se ele tem algum parâmetro de tipo, não há como ele
validar se os argumentos de tipo estão corretos. Como resultado, o tipo
argumentos não são permitidos.

#### Exemplo

O código a seguir produz esse diagnóstico porque o tipo de `p` é
`dynamic` e o tear-off de `m` tem argumentos de tipo:

```dart
void f(dynamic list) {
  [!list.fold!]<int>;
}
```

#### Correções comuns

Se você puder usar um tipo mais específico do que `dynamic`, altere o tipo do
receptor:

```dart
void f(List<Object> list) {
  list.fold<int>;
}
```

Se você não puder usar um tipo mais específico, remova os argumentos de tipo:

```dart
void f(dynamic list) {
  list.cast;
}
```

### generic_struct_subclass {:#generic_struct_subclass}

_A classe '{0}' não pode estender 'Struct' ou 'Union' porque '{0}' é genérica._

#### Descrição

O analisador produz esse diagnóstico quando uma subclasse de `Struct`
ou `Union` tem um parâmetro de tipo.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz esse diagnóstico porque a classe `S` define
o parâmetro de tipo `T`:

```dart
import 'dart:ffi';

final class [!S!]<T> extends Struct {
  external Pointer notEmpty;
}
```

#### Correções comuns

Remova os parâmetros de tipo da classe:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

### getter_not_subtype_setter_types {:#getter_not_subtype_setter_types}

_O tipo de retorno do getter '{0}' é '{1}', que não é um subtipo do tipo
'{2}' de seu setter '{3}'. _

#### Descrição

O analisador produz esse diagnóstico quando o tipo de retorno de um getter
não é um subtipo do tipo do parâmetro de um setter com o mesmo
nome.

A relação de subtipo é um requisito se o getter e o setter estiverem
na mesma classe ou se um deles estiver em uma superclasse do outro.

#### Exemplo

O código a seguir produz esse diagnóstico porque o tipo de retorno do
getter `x` é `num`, o tipo de parâmetro do setter `x` é `int`, e
`num` não é um subtipo de `int`:

```dart
class C {
  num get [!x!] => 0;

  set x(int y) {}
}
```

#### Correções comuns

Se o tipo do getter estiver correto, altere o tipo do setter:

```dart
class C {
  num get x => 0;

  set x(num y) {}
}
```

Se o tipo do setter estiver correto, altere o tipo do getter:

```dart
class C {
  int get x => 0;

  set x(int y) {}
}
```

### illegal_async_generator_return_type {:#illegal_async_generator_return_type}

_Funções marcadas como 'async*' devem ter um tipo de retorno que seja um supertipo
de 'Stream<T>' para algum tipo 'T'._

#### Descrição

O analisador produz esse diagnóstico quando o corpo de uma função tem o
modificador `async*` mesmo que o tipo de retorno da função não seja
`Stream` ou um supertipo de `Stream`.

#### Exemplo

O código a seguir produz esse diagnóstico porque o corpo da
função `f` tem o modificador 'async*' mesmo que o tipo de retorno `int`
não seja um supertipo de `Stream`:

```dart
[!int!] f() async* {}
```

#### Correções comuns

Se a função deve ser assíncrona, altere o tipo de retorno para ser
`Stream` ou um supertipo de `Stream`:

```dart
Stream<int> f() async* {}
```

Se a função deve ser síncrona, remova o modificador `async*`:

```dart
int f() => 0;
```

### illegal_async_return_type {:#illegal_async_return_type}

_Funções marcadas como 'async' devem ter um tipo de retorno que seja um supertipo
de 'Future'._

#### Descrição

O analisador produz esse diagnóstico quando o corpo de uma função tem o
modificador `async` mesmo que o tipo de retorno da função não seja
atribuível a `Future`.

#### Exemplo

O código a seguir produz esse diagnóstico porque o corpo da
função `f` tem o modificador `async` mesmo que o tipo de retorno não seja
atribuível a `Future`:

```dart
[!int!] f() async {
  return 0;
}
```

#### Correções comuns

Se a função deve ser assíncrona, altere o tipo de retorno para ser
atribuível a `Future`:

```dart
Future<int> f() async {
  return 0;
}
```

Se a função deve ser síncrona, remova o modificador `async`:

```dart
int f() => 0;
```

### illegal_concrete_enum_member {:#illegal_concrete_enum_member}

_Um membro de instância concreto chamado '{0}' não pode ser declarado em uma classe
que implementa 'Enum'._

_Um membro de instância concreto chamado '{0}' não pode ser herdado de '{1}' em uma classe
que implementa 'Enum'._

#### Descrição

O analisador produz esse diagnóstico quando uma declaração de enum, uma
classe que implementa `Enum` ou um mixin com uma restrição de superclasse de
`Enum`, declara ou herda um membro de instância concreto chamado `index`,
`hashCode` ou `==`.

#### Exemplos

O código a seguir produz esse diagnóstico porque o enum `E` declara
um getter de instância chamado `index`:

```dart
enum E {
  v;

  int get [!index!] => 0;
}
```

O código a seguir produz esse diagnóstico porque a classe `C`, que
implementa `Enum`, declara um campo de instância chamado `hashCode`:

```dart
abstract class C implements Enum {
  int [!hashCode!] = 0;
}
```

O código a seguir produz esse diagnóstico porque a classe `C`, que
implementa indiretamente `Enum` através da classe `A`, declara uma instância
getter chamado `hashCode`:

```dart
abstract class A implements Enum {}

abstract class C implements A {
  int get [!hashCode!] => 0;
}
```

O código a seguir produz este diagnóstico porque o mixin `M`, que
tem `Enum` na cláusula `on`, declara um operador explícito chamado `==`:

```dart
mixin M on Enum {
  bool operator [!==!](Object other) => false;
}
```

#### Correções comuns

Renomeie o membro conflitante:

```dart
enum E {
  v;

  int get getIndex => 0;
}
```

### illegal_enum_values {:#illegal_enum_values}

_Um membro de instância chamado 'values' não pode ser declarado em uma classe que
implementa 'Enum'._

_Um membro de instância chamado 'values' não pode ser herdado de '{0}' em uma classe que
implementa 'Enum'._

#### Descrição

O analisador produz esse diagnóstico quando uma classe que implementa
`Enum` ou um mixin com uma restrição de superclasse de `Enum` tem um
membro de instância chamado `values`.

#### Exemplos

O código a seguir produz esse diagnóstico porque a classe `C`, que
implementa `Enum`, declara um campo de instância chamado `values`:

```dart
abstract class C implements Enum {
  int get [!values!] => 0;
}
```

O código a seguir produz esse diagnóstico porque a classe `B`, que
implementa `Enum`, herda um método de instância chamado `values` de `A`:

```dart
abstract class A {
  int values() => 0;
}

abstract class [!B!] extends A implements Enum {}
```

#### Correções comuns

Altere o nome do membro conflitante:

```dart
abstract class C implements Enum {
  int get value => 0;
}
```

### illegal_sync_generator_return_type {:#illegal_sync_generator_return_type}

_Funções marcadas como 'sync*' devem ter um tipo de retorno que seja um supertipo
de 'Iterable<T>' para algum tipo 'T'._

#### Descrição

O analisador produz esse diagnóstico quando o corpo de uma função tem o
modificador `sync*` mesmo que o tipo de retorno da função não seja
`Iterable` ou um supertipo de `Iterable`.

#### Exemplo

O código a seguir produz esse diagnóstico porque o corpo da
função `f` tem o modificador 'sync*' mesmo que o tipo de retorno `int`
não seja um supertipo de `Iterable`:

```dart
[!int!] f() sync* {}
```

#### Correções comuns

Se a função deve retornar um iterável (iterable), altere o tipo de retorno para
ser `Iterable` ou um supertipo de `Iterable`:

```dart
Iterable<int> f() sync* {}
```

Se a função deve retornar um único valor, remova o `sync*`
modificador:

```dart
int f() => 0;
```

### implements_non_class {:#implements_non_class}

_Classes e mixins só podem implementar outras classes e mixins._

#### Descrição

O analisador produz este diagnóstico quando um nome usado na cláusula
`implements` de uma declaração de classe ou mixin é definido como algo
diferente de uma classe ou mixin.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` é uma variável
em vez de uma classe ou mixin:

```dart
var x;
class C implements [!x!] {}
```

#### Correções comuns

Se o nome for o nome de uma classe ou mixin existente que já está sendo
importado, adicione um prefixo à importação para que a definição local do
nome não ofusque o nome importado.

Se o nome for o nome de uma classe ou mixin existente que não está sendo
importado, adicione uma importação, com um prefixo, para a biblioteca na qual ele está
declarado.

Caso contrário, substitua o nome na cláusula `implements` pelo nome
de uma classe ou mixin existente, ou remova o nome de `implements`
cláusula.

### implements_repeated {:#implements_repeated}

_'{0}' só pode ser implementado uma vez._

#### Descrição

O analisador produz esse diagnóstico quando uma única classe é especificada mais
de uma vez em uma cláusula `implements`.

#### Exemplo

O código a seguir produz este diagnóstico porque `A` está na lista
duas vezes:

```dart
class A {}
class B implements A, [!A!] {}
```

#### Correções comuns

Remova todas as ocorrências do nome da classe, exceto uma:

```dart
class A {}
class B implements A {}
```

### implements_super_class {:#implements_super_class}

_'{0}' não pode ser usado nas cláusulas 'extends' e 'implements'._

_'{0}' não pode ser usado nas cláusulas 'extends' e 'with'._

#### Descrição

O analisador produz esse diagnóstico quando uma classe é listada no
cláusula `extends` de uma declaração de classe e também em `implements`
ou cláusula `with` da mesma declaração.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `A` é usada
tanto nas cláusulas `extends` quanto `implements` para a classe `B`:

```dart
class A {}

class B extends A implements [!A!] {}
```

O código a seguir produz este diagnóstico porque a classe `A` é usada
tanto nas cláusulas `extends` quanto `with` para a classe `B`:

```dart
mixin class A {}

class B extends A with [!A!] {}
```

#### Correções comuns

Se você quiser herdar a implementação da classe, remova o
classe da cláusula `implements`:

```dart
class A {}

class B extends A {}
```

Se você não quiser herdar a implementação da classe, remova o
cláusula `extends`:

```dart
class A {}

class B implements A {}
```

### implicit_super_initializer_missing_arguments {:#implicit_super_initializer_missing_arguments}

_O construtor não nomeado invocado implicitamente de '{0}' tem parâmetros obrigatórios._

#### Descrição

O analisador produz esse diagnóstico quando um construtor invoca
implicitamente o construtor não nomeado da superclasse, o não nomeado
construtor da superclasse tem um parâmetro obrigatório e não há
superparâmetro correspondente ao parâmetro obrigatório.

#### Exemplos

O código a seguir produz este diagnóstico porque o não nomeado
construtor na classe `B` invoca implicitamente o construtor não nomeado em
a classe `A`, mas o construtor em `A` tem uma posicional obrigatória
parâmetro nomeado `x`:

```dart
class A {
  A(int x);
}

class B extends A {
  [!B!]();
}
```

O código a seguir produz este diagnóstico porque o não nomeado
construtor na classe `B` invoca implicitamente o construtor não nomeado em
a classe `A`, mas o construtor em `A` tem um parâmetro nomeado obrigatório
chamado `x`:

```dart
class A {
  A({required int x});
}

class B extends A {
  [!B!]();
}
```

#### Correções comuns

Se você puder adicionar um parâmetro ao construtor na subclasse, adicione um
superparâmetro correspondente ao parâmetro obrigatório na superclasse'
construtor. O novo parâmetro pode ser obrigatório:

```dart
class A {
  A({required int x});
}

class B extends A {
  B({required super.x});
}
```

ou pode ser opcional:

```dart
class A {
  A({required int x});
}

class B extends A {
  B({super.x = 0});
}
```

Se você não puder adicionar um parâmetro ao construtor na subclasse, adicione
uma invocação explícita de superconstrutor com o argumento necessário:

```dart
class A {
  A(int x);
}

class B extends A {
  B() : super(0);
}
```

### implicit_this_reference_in_initializer {:#implicit_this_reference_in_initializer}

_O membro de instância '{0}' não pode ser acessado em um inicializador._

#### Descrição

O analisador produz esse diagnóstico quando encontra uma referência a um
membro de instância na lista de inicializadores de um construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque `defaultX` é um
membro de instância:

```dart
class C {
  int x;

  C() : x = [!defaultX!];

  int get defaultX => 0;
}
```

#### Correções comuns

Se o membro puder se tornar estático, faça isso:

```dart
class C {
  int x;

  C() : x = defaultX;

  static int get defaultX => 0;
}
```

Caso contrário, substitua a referência no inicializador por uma expressão
diferente que não use um membro de instância:

```dart
class C {
  int x;

  C() : x = 0;

  int get defaultX => 0;
}
```

### import_deferred_library_with_load_function {:#import_deferred_library_with_load_function}

_A biblioteca importada define uma função de nível superior chamada 'loadLibrary' que é
oculta ao adiar esta biblioteca._

#### Descrição

O analisador produz esse diagnóstico quando uma biblioteca que declara um
função chamada `loadLibrary` é importada usando uma importação adiada. A
importação adiada introduz uma função implícita chamada `loadLibrary`. Esse
função é usada para carregar o conteúdo da biblioteca adiada, e o
função implícita oculta a declaração explícita na biblioteca adiada.

Para mais informações, veja
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define uma função chamada `loadLibrary`:

```dart
void loadLibrary(Library library) {}

class Library {}
```

O código a seguir produz esse diagnóstico porque o implícito
declaração de `a.loadLibrary` está ocultando a declaração explícita de
`loadLibrary` em `a.dart`:

```dart
[!import 'a.dart' deferred as a;!]

void f() {
  a.Library();
}
```

#### Correções comuns

Se a biblioteca importada não precisa ser adiada, remova o
palavra-chave `deferred`:

```dart
import 'a.dart' as a;

void f() {
  a.Library();
}
```

Se a biblioteca importada precisa ser adiada e você precisa
referenciar a função importada, renomeie a função na importada
biblioteca:

```dart
void populateLibrary(Library library) {}

class Library {}
```

Se a biblioteca importada precisa ser adiada e você não precisa
referenciar a função importada, adicione uma cláusula `hide`:

```dart
import 'a.dart' deferred as a hide loadLibrary;

void f() {
  a.Library();
}
```

### import_internal_library {:#import_internal_library}

_A biblioteca '{0}' é interna e não pode ser importada._

#### Descrição

O analisador produz esse diagnóstico quando encontra uma importação cujo `dart:`
URI referencia uma biblioteca interna.

#### Exemplo

O código a seguir produz este diagnóstico porque `_interceptors` é um
biblioteca interna:

```dart
import [!'dart:_interceptors'!];
```

#### Correções comuns

Remova a diretiva de importação.

### import_of_legacy_library_into_null_safe {:#import_of_legacy_library_into_null_safe}

_A biblioteca '{0}' é legada e não deve ser importada em uma biblioteca null safe._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca que é null safe
importa uma biblioteca que não é null safe.

#### Exemplo

Dado um arquivo `a.dart` que contém o seguinte:

```dart
// @dart = 2.9

class A {}
```

O código a seguir produz este diagnóstico porque uma biblioteca que é null
safe está importando uma biblioteca que não é null safe:

```dart
import [!'a.dart'!];

A? f() => null;
```

#### Correções comuns

Se você puder migrar a biblioteca importada para ser null safe, migre-a
e atualize ou remova a versão de idioma da biblioteca migrada.

Se você não puder migrar a biblioteca importada, a biblioteca de importação
precisa ter uma versão de idioma anterior a 2.12, quando a segurança nula foi
habilitado por padrão.

### import_of_non_library {:#import_of_non_library}

_A biblioteca importada '{0}' não pode ter uma diretiva part-of._

#### Descrição

O analisador produz este diagnóstico quando um [arquivo part][arquivo part] é importado
em uma biblioteca.

#### Exemplo

Dado um [arquivo part][arquivo part] chamado `part.dart` contendo o seguinte:

```dart
part of lib;
```

O código a seguir produz esse diagnóstico porque arquivos importados não podem
ter uma diretiva part-of:

```dart
library lib;

import [!'part.dart'!];
```

#### Correções comuns

Importe a biblioteca que contém o [arquivo part][arquivo part] em vez do
[arquivo part][arquivo part] em si.

### inconsistent_inheritance {:#inconsistent_inheritance}

_Superinterfaces não têm uma substituição válida para '{0}': {1}._

#### Descrição

O analisador produz esse diagnóstico quando uma classe herda duas ou mais
assinaturas conflitantes para um membro e não fornece uma implementação
que satisfaça todas as assinaturas herdadas.

#### Exemplo

O código a seguir produz esse diagnóstico porque `C` está herdando o
declaração de `m` de `A`, e essa implementação não é consistente com
a assinatura de `m` que é herdada de `B`:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class [!C!] extends A implements B {
}
```

#### Correções comuns

Adicione uma implementação do método que satisfaça todas as herdadas
assinaturas:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class C extends A implements B {
  void m({int? a, int? b}) {}
}
```

### inconsistent_language_version_override {:#inconsistent_language_version_override}

_Parts devem ter exatamente a mesma substituição de versão de idioma que a biblioteca._

#### Descrição

O analisador produz este diagnóstico quando um [arquivo part][arquivo part] tem um idioma
comentário de substituição de versão que especifica uma versão de idioma diferente
daquela que está sendo usada para a biblioteca à qual a parte pertence.

#### Exemplo

Dado um [arquivo part][arquivo part] chamado `part.dart` que contém o seguinte:

```dart
// @dart = 2.14
part of 'test.dart';
```

O código a seguir produz este diagnóstico porque as partes de uma biblioteca
deve ter a mesma versão de idioma que a unidade de compilação de definição:

```dart
// @dart = 2.15
part [!'part.dart'!];
```

#### Correções comuns

Remova a substituição da versão do idioma do [arquivo part][arquivo part], para que
use implicitamente a mesma versão que a unidade de compilação de definição:

```dart
part of 'test.dart';
```

Se necessário, ajuste a substituição da versão do idioma na definição
unidade de compilação para ser apropriada para o código na parte, ou migrar
o código no [arquivo part][arquivo part] para ser consistente com o novo idioma
versão.

### inconsistent_pattern_variable_logical_or {:#inconsistent_pattern_variable_logical_or}

_A variável '{0}' tem um tipo e/ou finalidade diferente nesta ramificação do
padrão logical-or._

#### Descrição

O analisador produz esse diagnóstico quando uma variável de padrão que é
declarada em todas as ramificações de um padrão logical-or não tem o mesmo
tipo em cada ramificação. Também é produzido quando a variável tem um
finalidade diferente em diferentes ramificações. Uma variável de padrão declarada em
várias ramificações de um padrão logical-or é necessário ter o mesmo
tipo e finalidade em cada ramificação, para que o tipo e a finalidade do
variável pode ser conhecida no código que é protegido pelo padrão logical-or.

#### Exemplos

O código a seguir produz este diagnóstico porque a variável `a` é
definido como um `int` em uma ramificação e um `double` na outra:

```dart
void f(Object? x) {
  if (x case (int a) || (double [!a!])) {
    print(a);
  }
}
```

O código a seguir produz esse diagnóstico porque a variável `a` é
`final` no primeiro ramo e não é `final` no segundo ramo:

```dart
void f(Object? x) {
  if (x case (final int a) || (int [!a!])) {
    print(a);
  }
}
```

#### Correções comuns

Se a finalidade da variável for diferente, decida se deve ser
`final` ou não `final` e tornar os casos consistentes:

```dart
void f(Object? x) {
  if (x case (int a) || (int a)) {
    print(a);
  }
}
```

Se o tipo da variável for diferente e o tipo não for crítico para
a condição sendo correspondida, certifique-se de que a variável tenha a mesma
tipo em ambas as ramificações:

```dart
void f(Object? x) {
  if (x case (num a) || (num a)) {
    print(a);
  }
}
```

Se o tipo da variável for diferente e o tipo for crítico para
a condição sendo correspondida, considere dividir a condição em
várias instruções `if` ou cláusulas `case`:

```dart
void f(Object? x) {
  if (x case int a) {
    print(a);
  } else if (x case double a) {
    print(a);
  }
}
```

### initializer_for_non_existent_field {:#initializer_for_non_existent_field}

_'{0}' não é um campo na classe delimitadora._

#### Descrição

O analisador produz esse diagnóstico quando um construtor inicializa um
campo que não é declarado na classe que contém o construtor.
Construtores não podem inicializar campos que não são declarados e campos que
são herdados de superclasses.

#### Exemplo

O código a seguir produz esse diagnóstico porque o inicializador é
inicializando `x`, mas `x` não é um campo na classe:

```dart
class C {
  int? y;

  C() : [!x = 0!];
}
```

#### Correções comuns

Se um campo diferente deve ser inicializado, altere o nome para o
nome do campo:

```dart
class C {
  int? y;

  C() : y = 0;
}
```

Se o campo deve ser declarado, adicione uma declaração:

```dart
class C {
  int? x;
  int? y;

  C() : x = 0;
}
```

### initializer_for_static_field {:#initializer_for_static_field}

_'{0}' é um campo estático na classe delimitadora. Os campos inicializados em um
construtor não pode ser estático._

#### Descrição

O analisador produz esse diagnóstico quando um campo estático é inicializado
em um construtor usando um parâmetro formal de inicialização ou um
atribuição na lista de inicializadores.

#### Exemplo

O código a seguir produz esse diagnóstico porque o campo estático `a`
está sendo inicializado pelo parâmetro formal de inicialização `this.a`:

```dart
class C {
  static int? a;
  C([!this.a!]);
}
```

#### Correções comuns

Se o campo deve ser um campo de instância, remova a palavra-chave `static`:

```dart
class C {
  int? a;
  C(this.a);
}
```

Se você pretendia inicializar um campo de instância e digitou o nome errado,
corrija o nome do campo que está sendo inicializado:

```dart
class C {
  static int? a;
  int? b;
  C(this.b);
}
```

Se você realmente deseja inicializar o campo estático, mova o
inicialização no corpo do construtor:

```dart
class C {
  static int? a;
  C(int? c) {
    a = c;
  }
}
```

### initializing_formal_for_non_existent_field {:#initializing_formal_for_non_existent_field}

_'{0}' não é um campo na classe envolvente._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro formal de
inicialização é encontrado em um construtor em uma classe que não declara
o campo que está sendo inicializado. Construtores não podem inicializar
campos que não são declarados e campos que são herdados de superclasses.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `x` não está
definido:

```dart
class C {
  int? y;

  C([!this.x!]);
}
```

#### Correções comuns

Se o nome do campo estava errado, então altere-o para o nome de um campo
existente:

```dart
class C {
  int? y;

  C(this.y);
}
```

Se o nome do campo estiver correto, mas ainda não foi definido, então declare
o campo:

```dart
class C {
  int? x;
  int? y;

  C(this.x);
}
```

Se o parâmetro for necessário, mas não deve inicializar um campo, então
converta-o em um parâmetro normal e use-o:

```dart
class C {
  int y;

  C(int x) : y = x * 2;
}
```

Se o parâmetro não for necessário, então remova-o:

```dart
class C {
  int? y;

  C();
}
```

### instance_access_to_static_member {:#instance_access_to_static_member}

_O membro static (estático) {1} '{0}' não pode ser acessado através de uma instância._

#### Descrição

O analisador produz este diagnóstico quando um operador de acesso é usado
para acessar um membro estático através de uma instância da classe.

#### Exemplo

O código a seguir produz este diagnóstico porque `zero` é um campo
estático, mas está sendo acessado como se fosse um campo de instância:

```dart
void f(C c) {
  c.[!zero!];
}

class C {
  static int zero = 0;
}
```

#### Correções comuns

Use a classe para acessar o membro estático:

```dart
void f(C c) {
  C.zero;
}

class C {
  static int zero = 0;
}
```

### instance_member_access_from_factory {:#instance_member_access_from_factory}

_Membros de instância não podem ser acessados de um construtor factory (fábrica)._

#### Descrição

O analisador produz este diagnóstico quando um construtor *factory* contém
uma referência não qualificada a um membro de instância. Em um construtor
gerador, a instância da classe é criada e inicializada antes que o corpo
do construtor seja executado, então a instância pode ser vinculada a `this`
e acessada como seria em um método de instância. Mas, em um construtor
*factory*, a instância não é criada antes de executar o corpo, então `this`
não pode ser usado para referenciá-la.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` não está no escopo no
construtor *factory*:

```dart
class C {
  int x;
  factory C() {
    return C._([!x!]);
  }
  C._(this.x);
}
```

#### Correções comuns

Reescreva o código para que ele não faça referência ao membro de instância:

```dart
class C {
  int x;
  factory C() {
    return C._(0);
  }
  C._(this.x);
}
```

### instance_member_access_from_static {:#instance_member_access_from_static}

_Membros de instância não podem ser acessados de um método estático._

#### Descrição

O analisador produz este diagnóstico quando um método estático contém uma
referência não qualificada a um membro de instância.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo de instância `x`
está sendo referenciado em um método estático:

```dart
class C {
  int x = 0;

  static int m() {
    return [!x!];
  }
}
```

#### Correções comuns

Se o método deve referenciar o membro de instância, então ele não pode ser
estático, então remova a palavra-chave:

```dart
class C {
  int x = 0;

  int m() {
    return x;
  }
}
```

Se o método não puder ser transformado em um método de instância, então
adicione um parâmetro para que uma instância da classe possa ser passada:

```dart
class C {
  int x = 0;

  static int m(C c) {
    return c.x;
  }
}
```

### instantiate_abstract_class {:#instantiate_abstract_class}

_Classes abstratas não podem ser instanciadas._

#### Descrição

O analisador produz este diagnóstico quando encontra uma invocação de
construtor e o construtor é declarado em uma classe abstrata. Embora você
não possa criar uma instância de uma classe abstrata, classes abstratas
podem declarar construtores que podem ser invocados por subclasses.

#### Exemplo

O código a seguir produz este diagnóstico porque `C` é uma classe abstrata:

```dart
abstract class C {}

var c = new [!C!]();
```

#### Correções comuns

Se houver uma subclasse concreta da classe abstrata que possa ser usada,
então crie uma instância da subclasse concreta.

### instantiate_enum {:#instantiate_enum}

_Enums (enumerações) não podem ser instanciados._

#### Descrição

O analisador produz este diagnóstico quando um *enum* é instanciado. É
inválido criar uma instância de um *enum* invocando um construtor; somente
as instâncias nomeadas na declaração do *enum* podem existir.

#### Exemplo

O código a seguir produz este diagnóstico porque o *enum* `E` está sendo
instanciado:

```dart
// @dart = 2.16
enum E {a}

var e = [!E!]();
```

#### Correções comuns

Se você pretende usar uma instância do *enum*, então referencie uma das
constantes definidas no *enum*:

```dart
// @dart = 2.16
enum E {a}

var e = E.a;
```

Se você pretende usar uma instância de uma classe, então use o nome dessa
classe no lugar do nome do *enum*.

### instantiate_type_alias_expands_to_type_parameter {:#instantiate_type_alias_expands_to_type_parameter}

_Aliases de tipo que expandem para um parâmetro de tipo não podem ser instanciados._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de construtor é
encontrada onde o tipo que está sendo instanciado é um *alias* de tipo
para um dos parâmetros de tipo do *alias* de tipo. Isso não é permitido
porque o valor do parâmetro de tipo é um tipo em vez de uma classe.

#### Exemplo

O código a seguir produz este diagnóstico porque ele cria uma instância de
`A`, mesmo que `A` seja um *alias* de tipo que é definido para ser
equivalente a um parâmetro de tipo:

```dart
typedef A<T> = T;

void f() {
  const [!A!]<int>();
}
```

#### Correções comuns

Use um nome de classe ou um *alias* de tipo definido para ser uma classe,
em vez de um *alias* de tipo definido para ser um parâmetro de tipo:

```dart
typedef A<T> = C<T>;

void f() {
  const A<int>();
}

class C<T> {
  const C();
}
```

### integer_literal_imprecise_as_double {:#integer_literal_imprecise_as_double}

_O literal inteiro está sendo usado como um double, mas não pode ser
representado como um double de 64 bits sem estouro ou perda de precisão:
'{0}'._

#### Descrição

O analisador produz este diagnóstico quando um literal inteiro está sendo
implicitamente convertido em um *double*, mas não pode ser representado
como um *double* de 64 bits sem estouro ou perda de precisão. Literais
inteiros são implicitamente convertidos para *double* se o contexto
requer o tipo `double`.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor inteiro
`9223372036854775807` não pode ser representado exatamente como um *double*:

```dart
double x = [!9223372036854775807!];
```

#### Correções comuns

Se você precisa usar o valor exato, então use a classe `BigInt` para
representar o valor:

```dart
var x = BigInt.parse('9223372036854775807');
```

Se você precisa usar um *double*, então altere o valor para um que possa ser
representado exatamente:

```dart
double x = 9223372036854775808;
```

### integer_literal_out_of_range {:#integer_literal_out_of_range}

_O literal inteiro {0} não pode ser representado em 64 bits._

#### Descrição

O analisador produz este diagnóstico quando um literal inteiro tem um
valor que é muito grande (positivo) ou muito pequeno (negativo) para ser
representado em uma palavra de 64 bits.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor não pode ser
representado em 64 bits:

```dart
var x = [!9223372036854775810!];
```

#### Correções comuns

Se você precisa representar o valor atual, então envolva-o em uma instância
da classe `BigInt`:

```dart
var x = BigInt.parse('9223372036854775810');
```

### invalid_annotation {:#invalid_annotation}

_A anotação deve ser uma referência de variável const ou uma invocação de construtor const._

#### Descrição

O analisador produz este diagnóstico quando uma anotação é encontrada que
está usando algo que não é nem uma variável marcada como `const` nem a
invocação de um construtor `const`.

Getters não podem ser usados como anotações.

#### Exemplos

O código a seguir produz este diagnóstico porque a variável `v` não é
uma variável `const`:

```dart
var v = 0;

[!@v!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `f` não é uma variável:

```dart
[!@f!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `f` não é um
construtor:

```dart
[!@f()!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `g` é um *getter*:

```dart
[!@g!]
int get g => 0;
```

#### Correções comuns

Se a anotação estiver referenciando uma variável que não é um construtor
`const`, adicione a palavra-chave `const` à declaração da variável:

```dart
const v = 0;

@v
void f() {
}
```

Se a anotação não estiver referenciando uma variável, então remova-a:

```dart
int v = 0;

void f() {
}
```

### invalid_annotation_constant_value_from_deferred_library {:#invalid_annotation_constant_value_from_deferred_library}

_Valores constantes de uma biblioteca adiada (deferred) não podem ser usados em anotações._

#### Descrição

O analisador produz este diagnóstico quando uma constante definida em uma
biblioteca que é importada como uma biblioteca *deferred* é referenciada na
lista de argumentos de uma anotação. Anotações são avaliadas em tempo de
compilação, e valores de bibliotecas *deferred* não estão disponíveis em
tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

O código a seguir produz este diagnóstico porque a constante `pi` está
sendo referenciada na lista de argumentos de uma anotação, mesmo que a
biblioteca que a define esteja sendo importada como uma biblioteca
*deferred*:

```dart
import 'dart:math' deferred as math;

class C {
  const C(double d);
}

@C(math.[!pi!])
void f () {}
```

#### Correções comuns

Se você precisa referenciar a constante importada, então remova a palavra-
chave `deferred`:

```dart
import 'dart:math' as math;

class C {
  const C(double d);
}

@C(math.pi)
void f () {}
```

Se a importação precisar ser adiada e houver outra constante apropriada,
então use essa constante no lugar da constante da biblioteca *deferred*.

### invalid_annotation_from_deferred_library {:#invalid_annotation_from_deferred_library}

_Valores constantes de uma biblioteca adiada (deferred) não podem ser usados como anotações._

#### Descrição

O analisador produz este diagnóstico quando uma constante de uma biblioteca
que é importada usando uma importação *deferred* é usada como uma
anotação. Anotações são avaliadas em tempo de compilação, e constantes de
bibliotecas *deferred* não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

O código a seguir produz este diagnóstico porque a constante `pi` está
sendo usada como uma anotação quando a biblioteca `dart:math` é importada
como `deferred`:

```dart
import 'dart:math' deferred as math;

@[!math.pi!]
void f() {}
```

#### Correções comuns

Se você precisa referenciar a constante como uma anotação, então remova a
palavra-chave `deferred` da importação:

```dart
import 'dart:math' as math;

@math.pi
void f() {}
```

Se você pode usar uma constante diferente como uma anotação, então
substitua a anotação por uma constante diferente:

```dart
@deprecated
void f() {}
```

### invalid_annotation_target {:#invalid_annotation_target}

_A anotação '{0}' só pode ser usada em {1}._

#### Descrição

O analisador produz este diagnóstico quando uma anotação é aplicada a um
tipo de declaração que ela não suporta.

#### Exemplo

O código a seguir produz este diagnóstico porque a anotação
`optionalTypeArgs` não está definida para ser válida para variáveis de
nível superior:

```dart
import 'package:meta/meta.dart';

@[!optionalTypeArgs!]
int x = 0;
```

#### Correções comuns

Remova a anotação da declaração.

### invalid_assignment {:#invalid_assignment}

_Um valor do tipo '{0}' não pode ser atribuído a uma variável do tipo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando o tipo estático de uma
expressão que é atribuída a uma variável não é atribuível ao tipo da
variável.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo do inicializador
(`int`) não é atribuível ao tipo da variável (`String`):

```dart
int i = 0;
String s = [!i!];
```

#### Correções comuns

Se o valor que está sendo atribuído é sempre atribuível em tempo de
execução, mesmo que os tipos estáticos não reflitam isso, então adicione
um *cast* explícito.

Caso contrário, altere o valor que está sendo atribuído para que ele tenha
o tipo esperado. No exemplo anterior, isso pode ser algo como:

```dart
int i = 0;
String s = i.toString();
```

Se você não pode alterar o valor, então altere o tipo da variável para ser
compatível com o tipo do valor que está sendo atribuído:

```dart
int i = 0;
int s = i;
```

### invalid_dependency {:#invalid_dependency}

_Pacotes publicáveis não podem ter dependências '{0}'._

#### Descrição

O analisador produz este diagnóstico quando um pacote publicável inclui um
pacote na lista `dependencies` de seu arquivo `pubspec.yaml` que não é
uma dependência hospedada no *pub*.

Para saber mais sobre os diferentes tipos de fontes de dependência,
consulte [Dependências de pacote](https://dartbrasil.dev/tools/pub/dependencies).

#### Exemplo

O código a seguir produz este diagnóstico porque a dependência do pacote
`transmogrify` não é uma dependência hospedada no *pub*.

```yaml
name: example
dependencies:
  transmogrify:
    [!path!]: ../transmogrify
```

#### Correções comuns

Se você deseja publicar o pacote no `pub.dev`, então altere a dependência
para um pacote hospedado que seja publicado no `pub.dev`.

Se o pacote não se destina a ser publicado no `pub.dev`, então adicione
uma entrada `publish_to: none` em seu arquivo `pubspec.yaml` para
marcá-lo como não destinado a ser publicado:

```yaml
name: example
publish_to: none
dependencies:
  transmogrify:
    path: ../transmogrify
```

### invalid_exception_value {:#invalid_exception_value}

_O método {0} não pode ter um valor de retorno excepcional (o segundo
argumento) quando o tipo de retorno da função é 'void', 'Handle' ou 'Pointer'._

#### Descrição

O analisador produz este diagnóstico quando uma invocação do método
`Pointer.fromFunction` ou `NativeCallable.isolateLocal` tem um segundo
argumento (o valor de retorno excepcional) e o tipo a ser retornado da
invocação é `void`, `Handle` ou `Pointer`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque um segundo argumento é
fornecido quando o tipo de retorno de `f` é `void`:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f, [!42!]);
}
```

#### Correções comuns

Remova o valor de exceção:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f);
}
```

### invalid_export_of_internal_element {:#invalid_export_of_internal_element}

_O membro '{0}' não pode ser exportado como parte da API pública de um pacote._

#### Descrição

O analisador produz este diagnóstico quando uma [biblioteca pública][biblioteca pública]
exporta uma declaração que é marcada com a anotação
[`internal`][meta-internal].

#### Exemplo

Dado um arquivo `a.dart` no diretório `src` que contém:

```dart
import 'package:meta/meta.dart';

@internal class One {}
```

O código a seguir, quando encontrado em uma [biblioteca pública][biblioteca pública], produz
este diagnóstico porque a diretiva `export` está exportando um nome que se
destina apenas a ser usado internamente:

```dart
[!export 'src/a.dart';!]
```

#### Correções comuns

Se a exportação for necessária, então adicione uma cláusula `hide` para
ocultar os nomes internos:

```dart
export 'src/a.dart' hide One;
```

Se a exportação não for necessária, então remova-a.

### invalid_export_of_internal_element_indirectly {:#invalid_export_of_internal_element_indirectly}

_O membro '{0}' não pode ser exportado como parte da API pública de um pacote,
mas é exportado indiretamente como parte da assinatura de '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma [biblioteca pública][biblioteca pública]
exporta uma função de nível superior com um tipo de retorno ou pelo menos
um tipo de parâmetro que é marcado com a anotação
[`internal`][meta-internal].

#### Exemplo

Dado um arquivo `a.dart` no diretório `src` que contém o seguinte:

```dart
import 'package:meta/meta.dart';

@internal
typedef IntFunction = int Function();

int f(IntFunction g) => g();
```

O código a seguir produz este diagnóstico porque a função `f` tem um
parâmetro do tipo `IntFunction`, e `IntFunction` destina-se apenas a ser
usada internamente:

```dart
[!export 'src/a.dart' show f;!]
```

#### Correções comuns

Se a função precisar ser pública, então torne todos os tipos na assinatura
da função tipos públicos.

Se a função não precisar ser exportada, então pare de exportá-la, seja
removendo-a da cláusula `show`, adicionando-a à cláusula `hide`, ou
removendo a exportação.

### invalid_extension_argument_count {:#invalid_extension_argument_count}

_Substituições de extensão devem ter exatamente um argumento: o valor de
'this' no método de extensão._

#### Descrição

O analisador produz este diagnóstico quando uma substituição de extensão
não tem exatamente um argumento. O argumento é a expressão usada para
calcular o valor de `this` dentro do método de extensão, então deve haver
um argumento.

#### Exemplos

O código a seguir produz este diagnóstico porque não há argumentos:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E[!()!].join('b');
}
```

E, o código a seguir produz este diagnóstico porque há mais de um
argumento:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E[!('a', 'b')!].join('c');
}
```

#### Correções comuns

Forneça um argumento para a substituição de extensão:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E('a').join('b');
}
```

### invalid_factory_method_decl {:#invalid_factory_method_decl}

_O método factory (fábrica) '{0}' deve ter um tipo de retorno._

#### Descrição

O analisador produz este diagnóstico quando um método que é anotado com a
anotação [`factory`][meta-factory] tem um tipo de retorno `void`.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `createC` é
anotado com a anotação [`factory`][meta-factory], mas não retorna nenhum
valor:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  void [!createC!]() {}
}

class C {}
```

#### Correções comuns

Altere o tipo de retorno para algo diferente de `void`:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  C createC() => C();
}

class C {}
```

### invalid_factory_method_impl {:#invalid_factory_method_impl}

_O método factory (fábrica) '{0}' não retorna um objeto recém-alocado._

#### Descrição

O analisador produz este diagnóstico quando um método que é anotado com a
anotação [`factory`][meta-factory] não retorna um objeto recém-alocado.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `createC`
retorna o valor de um campo em vez de uma instância recém-criada de `C`:

```dart
import 'package:meta/meta.dart';

class Factory {
  C c = C();

  @factory
  C [!createC!]() => c;
}

class C {}
```

#### Correções comuns

Altere o método para retornar uma instância recém-criada do tipo de retorno:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  C createC() => C();
}

class C {}
```

### invalid_factory_name_not_a_class {:#invalid_factory_name_not_a_class}

_O nome de um construtor factory (fábrica) deve ser o mesmo que o nome da classe envolvente imediata._

#### Descrição

O analisador produz este diagnóstico quando o nome de um construtor
*factory* não é o mesmo que o nome da classe envolvente.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome do construtor
*factory* (`A`) não é o mesmo que a classe envolvente (`C`):

```dart
class A {}

class C {
  factory [!A!]() => throw 0;
}
```

#### Correções comuns

Se a *factory* retorna uma instância da classe envolvente e você pretende
que seja um construtor *factory* não nomeado, então renomeie a *factory*:

```dart
class A {}

class C {
  factory C() => throw 0;
}
```

Se a *factory* retorna uma instância da classe envolvente e você pretende
que seja um construtor *factory* nomeado, então prefixe o nome do
construtor *factory* com o nome da classe envolvente:

```dart
class A {}

class C {
  factory C.a() => throw 0;
}
```

Se a *factory* retorna uma instância de uma classe diferente, então mova a
*factory* para essa classe:

```dart
class A {
  factory A() => throw 0;
}

class C {}
```

Se a *factory* retorna uma instância de uma classe diferente, mas você não
pode modificar essa classe ou não quer mover a *factory*, então converta-a
para ser um método estático:

```dart
class A {}

class C {
  static A a() => throw 0;
}
```

### invalid_field_name {:#invalid_field_name}

_Nomes de campos de registro não podem ser um cifrão seguido por um inteiro
quando o inteiro é o índice de um campo posicional._

_Nomes de campos de registro não podem ser privados._

_Nomes de campos de registro não podem ser os mesmos que um membro de 'Object'._

#### Descrição

O analisador produz este diagnóstico quando um literal de registro ou uma
anotação de tipo de registro tem um campo cujo nome é inválido. O nome é
inválido se for:
- privado (começa com `_`)
- o mesmo que um dos membros definidos em `Object`
- o mesmo que o nome de um campo posicional (uma exceção é feita se o
  campo for um campo posicional com o nome especificado)

#### Exemplos

O código a seguir produz este diagnóstico porque o literal de registro tem
um campo chamado `toString`, que é um método definido em `Object`:

```dart
var r = (a: 1, [!toString!]: 4);
```

O código a seguir produz este diagnóstico porque a anotação de tipo de
registro tem um campo chamado `hashCode`, que é um *getter* definido em
`Object`:

```dart
void f(({int a, int [!hashCode!]}) r) {}
```

O código a seguir produz este diagnóstico porque o literal de registro tem
um campo privado chamado `_a`:

```dart
var r = ([!_a!]: 1, b: 2);
```

O código a seguir produz este diagnóstico porque a anotação de tipo de
registro tem um campo privado chamado `_a`:

```dart
void f(({int [!_a!], int b}) r) {}
```

O código a seguir produz este diagnóstico porque o literal de registro tem
um campo chamado `$1`, que também é o nome de um parâmetro posicional
diferente:

```dart
var r = (2, [!$1!]: 1);
```

O código a seguir produz este diagnóstico porque a anotação de tipo de
registro tem um campo chamado `$1`, que também é o nome de um parâmetro
posicional diferente:

```dart
void f((int, String, {int [!$1!]}) r) {}
```

#### Correções comuns

Renomeie o campo:

```dart
var r = (a: 1, d: 4);
```

### invalid_field_type_in_struct {:#invalid_field_type_in_struct}

_Campos em classes struct (estrutura) não podem ter o tipo '{0}'. Eles só podem
ser declarados como 'int', 'double', 'Array', 'Pointer', ou subtipo de
'Struct' ou 'Union'._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem um tipo diferente de `int`, `double`, `Array`, `Pointer`, ou
subtipo de `Struct` ou `Union`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `str` tem o tipo
`String`, que não é um dos tipos permitidos para campos em uma subclasse
de `Struct`:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!String!] s;

  @Int32()
  external int i;
}
```

#### Correções comuns

Use um dos tipos permitidos para o campo:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  external Pointer<Utf8> s;

  @Int32()
  external int i;
}
```

### invalid_implementation_override {:#invalid_implementation_override}

_'{1}.{0}' ('{2}') não é uma implementação concreta válida de '{3}.{0}' ('{4}')._

_O setter '{1}.{0}' ('{2}') não é uma implementação concreta válida de '{3}.{0}'
('{4}')._

#### Descrição

O analisador produz este diagnóstico quando todas as seguintes condições
são verdadeiras:

- Uma classe define um membro abstrato.
- Existe uma implementação concreta desse membro em uma superclasse.
- A implementação concreta não é uma implementação válida do método
  abstrato.

A implementação concreta pode ser inválida devido a incompatibilidades
no tipo de retorno, nos tipos dos parâmetros do método ou nos parâmetros
de tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `A.add` tem um
parâmetro do tipo `int`, e o método de sobreposição `B.add` tem um
parâmetro correspondente do tipo `num`:

```dart
class A {
  int add(int a) => a;
}
class [!B!] extends A {
  int add(num a);
}
```

Este é um problema porque em uma invocação de `B.add` como a seguinte:

```dart
void f(B b) {
  b.add(3.4);
}
```

`B.add` está esperando ser capaz de receber, por exemplo, um `double`, mas
quando o método `A.add` é executado (porque é a única implementação
concreta de `add`), uma exceção de tempo de execução será lançada porque
um `double` não pode ser atribuído a um parâmetro do tipo `int`.

#### Correções comuns

Se o método na subclasse puder estar em conformidade com a implementação
na superclasse, então altere a declaração na subclasse (ou remova-a se for
a mesma):

```dart
class A {
  int add(int a) => a;
}
class B	extends A {
  int add(int a);
}
```

Se o método na superclasse puder ser generalizado para ser uma
implementação válida do método na subclasse, então altere o método da
superclasse:

```dart
class A {
  int add(num a) => a.floor();
}
class B	extends A {
  int add(num a);
}
```

Se nem o método na superclasse nem o método na subclasse puderem ser
alterados, então forneça uma implementação concreta do método na
subclasse:

```dart
class A {
  int add(int a) => a;
}
class B	extends A {
  int add(num a) => a.floor();
}
```

### invalid_inline_function_type {:#invalid_inline_function_type}

_Tipos de função inline não podem ser usados para parâmetros em um tipo de
função genérica._

#### Descrição

O analisador produz este diagnóstico quando um tipo de função genérica tem
um parâmetro com valor de função que é escrito usando a sintaxe de tipo de
função inline mais antiga.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro `f`, no
tipo de função genérica usado para definir `F`, usa a sintaxe de tipo de
função inline:

```dart
typedef F = int Function(int f[!(!]String s));
```

#### Correções comuns

Use a sintaxe de função genérica para o tipo do parâmetro:

```dart
typedef F = int Function(int Function(String));
```

### invalid_internal_annotation {:#invalid_internal_annotation}

_Apenas elementos públicos na API privada de um pacote podem ser anotados
como sendo internos._

#### Descrição

O analisador produz este diagnóstico quando uma declaração é anotada com a
anotação [`internal`][meta-internal] e essa declaração está em uma
[biblioteca pública][biblioteca pública] ou tem um nome privado.

#### Exemplo

O código a seguir, quando em uma [biblioteca pública][biblioteca pública], produz este
diagnóstico porque a anotação [`internal`][meta-internal] não pode ser
aplicada a declarações em uma [biblioteca pública][biblioteca pública]:

```dart
import 'package:meta/meta.dart';

@[!internal!]
class C {}
```

O código a seguir, seja em uma biblioteca pública ou interna, produz este
diagnóstico porque a anotação [`internal`][meta-internal] não pode ser
aplicada a declarações com nomes privados:

```dart
import 'package:meta/meta.dart';

@[!internal!]
class _C {}

void f(_C c) {}
```

#### Correções comuns

Se a declaração tiver um nome privado, então remova a anotação:

```dart
class _C {}

void f(_C c) {}
```

Se a declaração tiver um nome público e for destinada a ser interna ao
pacote, mova a declaração anotada para uma biblioteca interna (em outras
palavras, uma biblioteca dentro do diretório `src`).

Caso contrário, remova o uso da anotação:

```dart
class C {}
```

### invalid_language_version_override {:#invalid_language_version_override}

_O comentário de override da versão da linguagem Dart não pode ser seguido por nenhum caractere que não seja espaço em branco._

_O comentário de override da versão da linguagem Dart deve ser especificado com um número de versão, como '2.0', após o caractere '='._

_O comentário de override da versão da linguagem Dart deve ser especificado com um caractere '='._

_O comentário de override da versão da linguagem Dart deve ser especificado com exatamente duas barras._

_O comentário de override da versão da linguagem Dart deve ser especificado com a palavra 'dart' em letras minúsculas._

_O número de override da versão da linguagem Dart não pode ser prefixado com uma letra._

_O número de override da versão da linguagem Dart deve começar com '@dart'._

_O override da versão da linguagem não pode especificar uma versão superior à versão de linguagem mais recente conhecida: {0}.{1}._

_O override da versão da linguagem deve ser especificado antes de qualquer declaração ou diretiva._

#### Descrição

O analisador produz este diagnóstico quando um comentário que parece ser uma tentativa de especificar um override da versão da linguagem não está em conformidade com os requisitos para tal comentário. Para mais informações, veja [Seleção da versão da linguagem por biblioteca](https://dartbrasil.dev/resources/language/evolution#per-library-language-version-selection) (em inglês).

#### Exemplo

O código a seguir produz este diagnóstico porque a palavra `dart` deve estar em minúsculas em tal comentário e porque não há sinal de igual entre a palavra `dart` e o número da versão:

```dart
[!// @Dart 2.13!]
```

#### Correções comuns

Se o comentário se destina a ser um override da versão da linguagem, então altere o comentário para seguir o formato correto:

```dart
// @dart = 2.13
```

### invalid_literal_annotation {:#invalid_literal_annotation}

_Apenas construtores `const` podem ter a anotação `@literal`._

#### Descrição

O analisador produz este diagnóstico quando a anotação [`literal`][meta-literal] é aplicada a algo que não seja um construtor `const`.

#### Exemplos

O código a seguir produz este diagnóstico porque o construtor não é um construtor `const`:

```dart
import 'package:meta/meta.dart';

class C {
  @[!literal!]
  C();
}
```

O código a seguir produz este diagnóstico porque `x` não é um construtor:

```dart
import 'package:meta/meta.dart';

@[!literal!]
var x;
```

#### Correções comuns

Se a anotação estiver em um construtor e o construtor sempre deva ser invocado com `const`, quando possível, marque o construtor com a palavra-chave `const`:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}
```

Se o construtor não puder ser marcado como `const`, remova a anotação.

Se a anotação estiver em algo que não seja um construtor, remova a anotação:

```dart
var x;
```

### invalid_modifier_on_constructor {:#invalid_modifier_on_constructor}

_O modificador '{0}' não pode ser aplicado ao corpo de um construtor._

#### Descrição

O analisador produz este diagnóstico quando o corpo de um construtor é prefixado por um dos seguintes modificadores: `async`, `async*` ou `sync*`. Corpos de construtores devem ser síncronos.

#### Exemplo

O código a seguir produz este diagnóstico porque o corpo do construtor para `C` está marcado como sendo `async`:

```dart
class C {
  C() [!async!] {}
}
```

#### Correções comuns

Se o construtor puder ser síncrono, remova o modificador:

```dart
class C {
  C();
}
```

Se o construtor não puder ser síncrono, use um método estático para criar a
instância em vez disso:

```dart
class C {
  C();
  static Future<C> c() async {
    return C();
  }
}
```

### invalid_modifier_on_setter {:#invalid_modifier_on_setter}

_Setters não podem usar 'async', 'async*' ou 'sync*'._

#### Descrição

O analisador produz este diagnóstico quando o corpo de um setter é prefixado por um dos seguintes modificadores: `async`, `async*` ou `sync*`. Corpos de setters devem ser síncronos.

#### Exemplo

O código a seguir produz este diagnóstico porque o corpo do setter `x` está marcado como sendo `async`:

```dart
class C {
  set x(int i) [!async!] {}
}
```

#### Correções comuns

Se o setter puder ser síncrono, remova o modificador:

```dart
class C {
  set x(int i) {}
}
```

Se o setter não puder ser síncrono, use um método para definir o valor
em vez disso:

```dart
class C {
  void x(int i) async {}
}
```

### invalid_non_virtual_annotation {:#invalid_non_virtual_annotation}

_A anotação '@nonVirtual' só pode ser aplicada a um membro de instância concreto._

#### Descrição

O analisador produz este diagnóstico quando a anotação `nonVirtual` é encontrada em uma declaração que não seja um membro de uma classe, mixin ou enum, ou se o membro não for um membro de instância concreto.

#### Exemplos

O código a seguir produz este diagnóstico porque a anotação está em uma declaração de classe em vez de um membro dentro da classe:

```dart
import 'package:meta/meta.dart';

@[!nonVirtual!]
class C {}
```

O código a seguir produz este diagnóstico porque o método `m` é um método abstrato:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  void m();
}
```

O código a seguir produz este diagnóstico porque o método `m` é um método estático:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  static void m() {}
}
```

#### Correções comuns

Se a declaração não for um membro de uma classe, mixin ou enum, remova a anotação:

```dart
class C {}
```

Se o membro se destina a ser um membro de instância concreto, torne-o assim:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @nonVirtual
  void m() {}
}
```

Se o membro não se destina a ser um membro de instância concreto, remova a anotação:

```dart
abstract class C {
  static void m() {}
}
```

### invalid_null_aware_operator {:#invalid_null_aware_operator}

_O elemento não pode ser nulo, então o operador null-aware '?' é desnecessário._

_A chave de entrada do mapa não pode ser nula, então o operador null-aware '?' é desnecessário._

_O valor da entrada do mapa não pode ser nulo, então o operador null-aware '?' é desnecessário._

_O receptor não pode ser 'null' devido a um curto-circuito, então o operador null-aware '{0}' não pode ser usado._

_O receptor não pode ser nulo, então o operador null-aware '{0}' é desnecessário._

#### Descrição

O analisador produz este diagnóstico quando um operador null-aware (`?.`, `?..`, `?[`, `?..[` ou `...?`) é usado em um receptor que se sabe que não é anulável.

#### Exemplos

O código a seguir produz este diagnóstico porque `s` não pode ser `null`:

```dart
int? getLength(String s) {
  return s[!?.!]length;
}
```

O código a seguir produz este diagnóstico porque `a` não pode ser `null`:

```dart
var a = [];
var b = [[!...?!]a];
```

O código a seguir produz este diagnóstico porque `s?.length` não pode retornar `null`:

```dart
void f(String? s) {
  s?.length[!?.!]isEven;
}
```

A razão pela qual `s?.length` não pode retornar `null` é porque o operador null-aware seguindo `s` faz um curto-circuito na avaliação de `length` e `isEven` se `s` for `null`. Em outras palavras, se `s` for `null`, então nem `length` nem `isEven` serão invocados, e se `s` não for `null`, então `length` não pode retornar um valor `null`. De qualquer forma, `isEven` não pode ser invocado em um valor `null`, então o operador null-aware não é necessário. Veja [Entendendo a segurança nula](/null-safety/understanding-null-safety#smarter-null-aware-methods) (em inglês) para mais detalhes.

O código a seguir produz este diagnóstico porque `s` não pode ser `null`.

```dart
void f(Object? o) {
  var s = o as String;
  s[!?.!]length;
}
```

A razão pela qual `s` não pode ser nulo, apesar do fato de que `o` pode ser `null`, é por causa do cast para `String`, que é um tipo não anulável. Se `o` alguma vez tiver o valor `null`, o cast falhará e a invocação de `length` não acontecerá.

O código a seguir produz este diagnóstico porque `s` não pode ser `null`:

```dart
List<String> makeSingletonList(String s) {
  return <String>[[!?!]s];
}
```

#### Correções comuns

Substitua o operador null-aware por um equivalente não null-aware; por exemplo, altere `?.` para `.`:

```dart
int getLength(String s) {
  return s.length;
}
```

(Observe que o tipo de retorno também foi alterado para ser não anulável, o que pode não ser apropriado em alguns casos.)

### invalid_override {:#invalid_override}

_'{1}.{0}' ('{2}') não é um override válido de '{3}.{0}' ('{4}')._

_O setter '{1}.{0}' ('{2}') não é um override válido de '{3}.{0}' ('{4}')._

#### Descrição

O analisador produz este diagnóstico quando um membro de uma classe é encontrado que faz um override de um membro de um supertipo e o override não é válido. Um override é válido se todos os seguintes forem verdadeiros:
- Ele permite todos os argumentos permitidos pelo membro que está sendo sobreescrito.
- Ele não requer nenhum argumento que não seja requerido pelo membro que está sendo sobreescrito.
- O tipo de cada parâmetro do membro que está sendo sobreescrito é atribuível ao parâmetro correspondente do override.
- O tipo de retorno do override é atribuível ao tipo de retorno do membro que está sendo sobreescrito.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo do parâmetro `s` (`String`) não é atribuível ao tipo do parâmetro `i` (`int`):

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void [!m!](String s) {}
}
```

#### Correções comuns

Se o método inválido se destina a fazer um override do método da superclasse, altere-o para estar em conformidade:

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void m(int i) {}
}
```

Se não se destina a fazer um override do método da superclasse, renomeie-o:

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void m2(String s) {}
}
```

### invalid_override_of_non_virtual_member {:#invalid_override_of_non_virtual_member}

_O membro '{0}' é declarado como não-virtual em '{1}' e não pode ser sobreescrito em subclasses._

#### Descrição

O analisador produz este diagnóstico quando um membro de uma classe, mixin ou enum faz um override de um membro que tem a anotação `@nonVirtual`.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `m` em `B` faz um override do método `m` em `A`, e o método `m` em `A` está anotado com a anotação `@nonVirtual`:

```dart
import 'package:meta/meta.dart';

class A {
  @nonVirtual
  void m() {}
}

class B extends A {
  @override
  void [!m!]() {}
}
```

#### Correções comuns

Se a anotação no método na superclasse estiver correta (o método na superclasse não se destina a ser sobreescrito), remova ou renomeie o método que está fazendo override:

```dart
import 'package:meta/meta.dart';

class A {
  @nonVirtual
  void m() {}
}

class B extends A {}
```

Se o método na superclasse se destina a ser sobreescrito, remova a anotação `@nonVirtual`:

```dart
class A {
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```

### invalid_pattern_variable_in_shared_case_scope {:#invalid_pattern_variable_in_shared_case_scope}

_A variável '{0}' não tem o mesmo tipo e/ou finalidade em todos os casos que compartilham este corpo._

_A variável '{0}' está disponível em alguns, mas não em todos os casos que compartilham este corpo._

_A variável '{0}' não está disponível porque existe um rótulo ou caso 'default'._

#### Descrição

O analisador produz este diagnóstico quando várias cláusulas case em uma declaração switch compartilham um corpo, e pelo menos uma delas declara uma variável que é referenciada nas declarações compartilhadas, mas a variável não é declarada em todas as cláusulas case ou é declarada de maneiras inconsistentes.

Se a variável não for declarada em todas as cláusulas case, ela não terá um valor se uma das cláusulas que não declaram a variável for a que corresponde e executa o corpo. Isso inclui a situação em que uma das cláusulas case é a cláusula `default`.

Se a variável for declarada de maneiras inconsistentes, sendo `final` em alguns casos e não `final` em outros ou tendo um tipo diferente em casos diferentes, então a semântica de qual deveria ser o tipo ou a finalidade da variável não está definida.

#### Exemplos

O código a seguir produz este diagnóstico porque a variável `a` é declarada apenas em uma das cláusulas case e não terá um valor se a segunda cláusula for a que correspondeu a `x`:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    case 0:
      [!a!];
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` não é declarada na cláusula `default` e não terá um valor se o corpo for executado porque nenhuma das outras cláusulas correspondeu a `x`:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    default:
      [!a!];
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` não terá um valor se o corpo for executado porque um grupo diferente de casos fez com que o controle continuasse no rótulo:

```dart
void f(Object? x) {
  switch (x) {
    someLabel:
    case int a when a > 0:
      [!a!];
    case int b when b < 0:
      continue someLabel;
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a`, embora esteja sendo atribuída em todas as cláusulas case, não tem o mesmo tipo associado a ela em cada cláusula:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a < 0:
    case num a when a > 0:
      [!a!];
  }
}
```

O código a seguir produz este diagnóstico porque a variável `a` é `final` na primeira cláusula case e não é `final` na segunda cláusula case:

```dart
void f(Object? x) {
  switch (x) {
    case final int a when a < 0:
    case int a when a > 0:
      [!a!];
  }
}
```

#### Correções comuns

Se a variável não for declarada em todos os casos e você precisar referenciá-la nas declarações, declare-a nos outros casos:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    case int a when a == 0:
      a;
  }
}
```

Se a variável não for declarada em todos os casos e você não precisar referenciá-la nas declarações, remova as referências a ela e remova as declarações dos outros casos:

```dart
void f(int x) {
  switch (x) {
    case > 0:
    case 0:
  }
}
```

Se o tipo da variável for diferente, decida o tipo que a variável deve ter e torne os casos consistentes:

```dart
void f(Object? x) {
  switch (x) {
    case num a when a < 0:
    case num a when a > 0:
      a;
  }
}
```

Se a finalidade da variável for diferente, decida se deve ser `final` ou não `final` e torne os casos consistentes:

```dart
void f(Object? x) {
  switch (x) {
    case final int a when a < 0:
    case final int a when a > 0:
      a;
  }
}
```

### invalid_platforms_field {:#invalid_platforms_field}

_O campo 'platforms' deve ser um mapa com plataformas como chaves._

#### Descrição

O analisador produz este diagnóstico quando um campo `platforms` de nível superior é especificado, mas seu valor não é um mapa com chaves. Para saber mais sobre como especificar as plataformas suportadas do seu pacote, consulte a [documentação sobre declarações de plataforma](https://dartbrasil.dev/tools/pub/pubspec#platforms) (em inglês).

#### Exemplo

O seguinte `pubspec.yaml` produz este diagnóstico porque `platforms` deve ser um mapa.

```yaml
name: example
platforms:
  [!- android!]
  [!- web!]
  [!- ios!]
```

#### Correções comuns

Se você puder confiar na detecção automática de plataforma, omita o campo `platforms` de nível superior.

```yaml
name: example
```

Se você precisar especificar manualmente a lista de plataformas suportadas, escreva o campo `platforms` como um mapa com nomes de plataforma como chaves.

```yaml
name: example
platforms:
  android:
  web:
  ios:
```

### invalid_reference_to_generative_enum_constructor {:#invalid_reference_to_generative_enum_constructor}

_Construtores de enum generativos só podem ser usados como alvos de redirecionamento._

#### Descrição

O analisador produz este diagnóstico quando um construtor generativo definido em um enum é usado em qualquer lugar que não seja para criar uma das constantes enum ou como alvo de um redirecionamento de outro construtor no mesmo enum.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor para `E` está sendo usado para criar uma instância na função `f`:

```dart
enum E {
  a(0);

  const E(int x);
}

E f() => const [!E!](2);
```

#### Correções comuns

Se houver um valor enum com o mesmo valor, ou se você adicionar tal constante, então referencie a constante diretamente:

```dart
enum E {
  a(0), b(2);

  const E(int x);
}

E f() => E.b;
```

Se você precisar usar uma invocação de construtor, use um construtor factory:

```dart
enum E {
  a(0);

  const E(int x);

  factory E.c(int x) => a;
}

E f() => E.c(2);
```

### invalid_reference_to_this {:#invalid_reference_to_this}

_Referência inválida à expressão 'this'._

#### Descrição

O analisador produz este diagnóstico quando `this` é usado fora de um método de instância ou um construtor generativo. A palavra reservada `this` é definida apenas no contexto de um método de instância, um construtor generativo ou o inicializador de uma declaração de campo de instância tardia.

#### Exemplo

O código a seguir produz este diagnóstico porque `v` é uma variável de nível superior:

```dart
C f() => [!this!];

class C {}
```

#### Correções comuns

Use uma variável do tipo apropriado no lugar de `this`, declarando-a se necessário:

```dart
C f(C c) => c;

class C {}
```

### invalid_return_type_for_catch_error {:#invalid_return_type_for_catch_error}

_Um valor do tipo '{0}' não pode ser retornado pelo manipulador 'onError' porque deve ser atribuível a '{1}'._

_O tipo de retorno '{0}' não é atribuível a '{1}', conforme exigido por 'Future.catchError'._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de `Future.catchError` tem um argumento cujo tipo de retorno não é compatível com o tipo retornado pela instância de `Future`. Em tempo de execução, o método `catchError` tenta retornar o valor do callback como resultado do future, o que resulta em outra exceção sendo lançada.

#### Exemplos

O código a seguir produz este diagnóstico porque `future` é declarado para retornar um `int` enquanto `callback` é declarado para retornar um `String`, e `String` não é um subtipo de `int`:

```dart
void f(Future<int> future, String Function(dynamic, StackTrace) callback) {
  future.catchError([!callback!]);
}
```

O código a seguir produz este diagnóstico porque o closure que está sendo passado para `catchError` retorna um `int` enquanto `future` é declarado para retornar um `String`:

```dart
void f(Future<String> future) {
  future.catchError((error, stackTrace) => [!3!]);
}
```

#### Correções comuns

Se a instância de `Future` for declarada corretamente, altere o callback para corresponder:

```dart
void f(Future<int> future, int Function(dynamic, StackTrace) callback) {
  future.catchError(callback);
}
```

Se a declaração da instância de `Future` estiver errada, altere-a para corresponder ao callback:

```dart
void f(Future<String> future, String Function(dynamic, StackTrace) callback) {
  future.catchError(callback);
}
```

### invalid_sealed_annotation {:#invalid_sealed_annotation}

_A anotação '@sealed' só pode ser aplicada a classes._

#### Descrição

O analisador produz este diagnóstico quando uma declaração que não seja uma declaração de classe tem a anotação `@sealed`.

#### Exemplo

O código a seguir produz este diagnóstico porque a anotação `@sealed` está em uma declaração de método:

```dart
import 'package:meta/meta.dart';

class A {
  @[!sealed!]
  void m() {}
}
```

#### Correções comuns

Remova a anotação:

```dart
class A {
  void m() {}
}
```

### invalid_super_formal_parameter_location {:#invalid-super-formal-parameter_location}

_Super parâmetros só podem ser usados em construtores generativos não redirecionadores._

#### Descrição

O analisador produz este diagnóstico quando um super parâmetro é usado em qualquer lugar que não seja um construtor generativo não redirecionador.

#### Exemplos

O código a seguir produz este diagnóstico porque o super parâmetro `x` está em um construtor generativo redirecionador:

```dart
class A {
  A(int x);
}

class B extends A {
  B.b([!super!].x) : this._();
  B._() : super(0);
}
```

O código a seguir produz este diagnóstico porque o super parâmetro `x` não está em um construtor generativo:

```dart
class A {
  A(int x);
}

class C extends A {
  factory C.c([!super!].x) => C._();
  C._() : super(0);
}
```

O código a seguir produz este diagnóstico porque o super parâmetro `x` está em um método:

```dart
class A {
  A(int x);
}

class D extends A {
  D() : super(0);

  void m([!super!].x) {}
}
```

#### Correções comuns

Se a função que contém o super parâmetro puder ser alterada para ser um construtor generativo não redirecionador, faça isso:

```dart
class A {
  A(int x);
}

class B extends A {
  B.b(super.x);
}
```

Se a função que contém o super parâmetro não puder ser alterada para ser um construtor generativo não redirecionador, remova o `super`:

```dart
class A {
  A(int x);
}

class D extends A {
  D() : super(0);

  void m(int x) {}
}
```

### invalid_type_argument_in_const_literal {:#invalid_type_argument_in_const_literal}

_Literais de lista constantes não podem usar um parâmetro de tipo em um argumento de tipo, como '{0}'._

_Literais de mapa constantes não podem usar um parâmetro de tipo em um argumento de tipo, como '{0}'._

_Literais de conjunto constantes não podem usar um parâmetro de tipo em um argumento de tipo, como '{0}'._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro de tipo é usado em um argumento de tipo em um literal de lista, mapa ou conjunto que é prefixado por `const`. Isso não é permitido porque o valor do parâmetro de tipo (o tipo real que será usado em tempo de execução) não pode ser conhecido em tempo de compilação.

#### Exemplos

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T` está sendo usado como um argumento de tipo ao criar uma lista constante:

```dart
List<T> newList<T>() => const <[!T!]>[];
```

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T` está sendo usado como um argumento de tipo ao criar um mapa constante:

```dart
Map<String, T> newSet<T>() => const <String, [!T!]>{};
```

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T` está sendo usado como um argumento de tipo ao criar um conjunto constante:

```dart
Set<T> newSet<T>() => const <[!T!]>{};
```

#### Correções comuns

Se o tipo que será usado para o parâmetro de tipo puder ser conhecido em tempo de compilação, remova o parâmetro de tipo:

```dart
List<int> newList() => const <int>[];
```

Se o tipo que será usado para o parâmetro de tipo não puder ser conhecido até o tempo de execução, remova a palavra-chave `const`:

```dart
List<T> newList<T>() => <T>[];
```

### invalid_uri {:#invalid_uri}

_Sintaxe de URI inválida: '{0}'._

#### Descrição

O analisador produz este diagnóstico quando um URI em uma diretiva não está em conformidade com a sintaxe de um URI válido.

#### Exemplo

O código a seguir produz este diagnóstico porque `'#'` não é um URI válido:

```dart
import [!'#'!];
```

#### Correções comuns

Substitua o URI inválido por um URI válido.

### invalid_use_of_covariant_in_extension {:#invalid_use_of_covariant_in_extension}

_Não pode ter o modificador '{0}' em uma extensão._

#### Descrição

O analisador produz este diagnóstico quando um membro declarado dentro de uma extensão usa a palavra-chave `covariant` na declaração de um parâmetro. Extensões não são classes e não têm subclasses, então a palavra-chave não tem propósito.

#### Exemplo

O código a seguir produz este diagnóstico porque `i` está marcado como sendo covariant:

```dart
extension E on String {
  void a([!covariant!] int i) {}
}
```

#### Correções comuns

Remova a palavra-chave `covariant`:

```dart
extension E on String {
  void a(int i) {}
}
```

### invalid_use_of_internal_member {:#invalid_use_of_internal_member}

_O membro '{0}' só pode ser usado dentro do seu pacote._

#### Descrição

O analisador produz este diagnóstico quando uma referência a uma declaração que é anotada com a anotação [`internal`][meta-internal] é encontrada fora do pacote que contém a declaração.

#### Exemplo

Dado um pacote `p` que define uma biblioteca contendo uma declaração marcada com a anotação [`internal`][meta-internal]:

```dart
import 'package:meta/meta.dart';

@internal
class C {}
```

O código a seguir produz este diagnóstico porque está referenciando a classe `C`, que não se destina a ser usada fora do pacote `p`:

```dart
import 'package:p/src/p.dart';

void f([!C!] c) {}
```

#### Correções comuns

Remova a referência à declaração interna.

### invalid_use_of_null_value {:#invalid_use_of_null_value}

_Uma expressão cujo valor é sempre 'null' não pode ser desreferenciada._

#### Descrição

O analisador produz este diagnóstico quando uma expressão cujo valor será sempre `null` é desreferenciada.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` será sempre `null`:

```dart
int f(Null x) {
  return x.[!length!];
}
```

#### Correções comuns

Se o valor puder ser algo diferente de `null`, altere o tipo da expressão:

```dart
int f(String? x) {
  return x!.length;
}
```

### invalid_use_of_type_outside_library {:#invalid-use-of-type-outside_library}

_A classe '{0}' não pode ser estendida fora de sua biblioteca porque é uma classe final._

_A classe '{0}' não pode ser estendida fora de sua biblioteca porque é uma classe de interface._

_A classe '{0}' não pode ser estendida, implementada ou usada como mixin fora de sua biblioteca porque é uma classe selada._

_A classe '{0}' não pode ser implementada fora de sua biblioteca porque é uma classe base._

_A classe '{0}' não pode ser implementada fora de sua biblioteca porque é uma classe final._

_A classe '{0}' não pode ser usada como uma restrição de superclasse mixin fora de sua biblioteca porque é uma classe final._

_O mixin '{0}' não pode ser implementado fora de sua biblioteca porque é um mixin base._

#### Descrição

O analisador produz este diagnóstico quando uma cláusula `extends`, `implements`, `with` ou `on` usa uma classe ou mixin de uma forma que não é permitida, dados os modificadores na declaração dessa classe ou mixin.

A mensagem especifica como a declaração está sendo usada e por que não é permitida.

#### Exemplo

Dado um arquivo `a.dart` que define uma classe base `A`:

```dart
base class A {}
```

O código a seguir produz este diagnóstico porque a classe `B` implementa a classe `A`, mas o modificador `base` impede que `A` seja implementada fora da biblioteca onde está definida:

```dart
import 'a.dart';

final class B implements [!A!] {}
```

#### Correções comuns

O uso deste tipo é restrito fora de sua biblioteca de declaração. Se um tipo diferente e não restrito estiver disponível e puder fornecer funcionalidade semelhante, substitua o tipo:

```dart
class B implements C {}
class C {}
```

Se não houver um tipo diferente que seja apropriado, remova o tipo e, possivelmente, toda a cláusula:

```dart
class B {}
```

### invalid_use_of_visible_for_overriding_member {:#invalid_use_of_visible_for_overriding_member}

_O membro '{0}' só pode ser usado para override._

#### Descrição

O analisador produz este diagnóstico quando um membro de instância que é anotado com [`visibleForOverriding`][meta-visibleForOverriding] é referenciado fora da biblioteca em que é declarado por qualquer motivo que não seja para fazer override dele.

#### Exemplo

Dado um arquivo `a.dart` contendo a seguinte declaração:

```dart
import 'package:meta/meta.dart';

class A {
  @visibleForOverriding
  void a() {}
}
```

O código a seguir produz este diagnóstico porque o método `m` está sendo invocado, embora a única razão para que seja público seja para permitir que seja sobreescrito:

```dart
import 'a.dart';

class B extends A {
  void b() {
    [!a!]();
  }
}
```

#### Correções comuns

Remova o uso inválido do membro.
### invalid_use_of_visible_for_testing_member {:#invalid_use_of_visible_for_testing_member}

_O membro '{0}' só pode ser usado dentro de '{1}' ou em um teste._

#### Descrição

O analisador produz este diagnóstico quando um membro anotado com
`@visibleForTesting` é referenciado em qualquer lugar que não seja a biblioteca em
que foi declarado ou em uma biblioteca no diretório `test`.

#### Exemplo

Dado um arquivo `c.dart` que contém o seguinte:

```dart
import 'package:meta/meta.dart';

class C {
  @visibleForTesting
  void m() {}
}
```

O código a seguir, quando não estiver dentro do diretório `test`, produz este
diagnóstico porque o método `m` está marcado como visível apenas para
testes:

```dart
import 'c.dart';

void f(C c) {
  c.[!m!]();
}
```

#### Correções comuns

Se o membro anotado não deve ser referenciado fora dos testes, então
remova a referência:

```dart
import 'c.dart';

void f(C c) {}
```

Se for aceitável referenciar o membro anotado fora dos testes, então remova
a anotação:

```dart
class C {
  void m() {}
}
```

### invalid_visibility_annotation {:#invalid_visibility_annotation}

_O membro '{0}' está anotado com '{1}', mas esta anotação só faz
sentido em declarações de membros públicos._

#### Descrição

O analisador produz este diagnóstico quando a anotação `visibleForTemplate`
ou [`visibleForTesting`][meta-visibleForTesting] é aplicada a
uma declaração não pública.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
import 'package:meta/meta.dart';

@[!visibleForTesting!]
void _someFunction() {}

void f() => _someFunction();
```

#### Correções comuns

Se a declaração não precisa ser usada pelo código de teste, então remova a
anotação:

```dart
void _someFunction() {}

void f() => _someFunction();
```

Se precisar, então torne-a pública:

```dart
import 'package:meta/meta.dart';

@visibleForTesting
void someFunction() {}

void f() => someFunction();
```

### invalid_visible_for_overriding_annotation {:#invalid_visible_for_overriding_annotation}

_A anotação 'visibleForOverriding' só pode ser aplicada a um membro de instância
público que pode ser sobrescrito._

#### Descrição

O analisador produz este diagnóstico quando algo diferente de um membro de
instância público de uma classe é anotado com
[`visibleForOverriding`][meta-visibleForOverriding]. Como apenas membros de
instância públicos podem ser sobrescritos fora da biblioteca de definição, não
faz sentido anotar quaisquer outras declarações.

#### Exemplo

O código a seguir produz este diagnóstico porque a anotação está em uma
classe, e classes não podem ser sobrescritas:

```dart
import 'package:meta/meta.dart';

@[!visibleForOverriding!]
class C {}
```

#### Correções comuns

Remova a anotação:

```dart
class C {}
```

### invalid_visible_outside_template_annotation {:#invalid_visible_outside_template_annotation}

_A anotação 'visibleOutsideTemplate' só pode ser aplicada a um membro de uma
classe, enum ou mixin que é anotado com 'visibleForTemplate'._

#### Descrição

O analisador produz este diagnóstico quando a anotação `@visibleOutsideTemplate`
é usada incorretamente. Esta anotação destina-se apenas a anotar
membros de uma classe, enum ou mixin que tenha a anotação `@visibleForTemplate`,
para retirar esses membros das restrições de visibilidade que
`@visibleForTemplate` impõe.

#### Exemplos

O código a seguir produz este diagnóstico porque não há
anotação `@visibleForTemplate` no nível da classe:

```dart
import 'package:angular_meta/angular_meta.dart';

class C {
  @[!visibleOutsideTemplate!]
  int m() {
    return 1;
  }
}
```

O código a seguir produz este diagnóstico porque a anotação está em
uma declaração de classe, e não em um membro de uma classe, enum ou mixin:

```dart
import 'package:angular_meta/angular_meta.dart';

@[!visibleOutsideTemplate!]
class C {}
```

#### Correções comuns

Se a classe é visível apenas para que os templates possam referenciá-la, então
adicione a anotação `@visibleForTemplate` à classe:

```dart
import 'package:angular_meta/angular_meta.dart';

@visibleForTemplate
class C {
  @visibleOutsideTemplate
  int m() {
    return 1;
  }
}
```

Se a anotação `@visibleOutsideTemplate` estiver em algo que não seja um
membro de uma classe, enum ou mixin com a anotação `@visibleForTemplate`,
remova a anotação:

```dart
class C {}
```

### invocation_of_extension_without_call {:#invocation_of_extension_without_call}

_A extensão '{0}' não define um método 'call', portanto, a sobreposição não
pode ser usada em uma invocação._

#### Descrição

O analisador produz este diagnóstico quando uma sobreposição de extensão é
usada para invocar uma função, mas a extensão não declara um método `call`.

#### Exemplo

O código a seguir produz este diagnóstico porque a extensão `E`
não define um método `call`:

```dart
extension E on String {}

void f() {
  [!E('')!]();
}
```

#### Correções comuns

Se a extensão destina-se a definir um método `call`, então declare-o:

```dart
extension E on String {
  int call() => 0;
}

void f() {
  E('')();
}
```

Se o tipo estendido define um método `call`, então remova a sobreposição
de extensão.

Se o método `call` não estiver definido, então reescreva o código para que
ele não invoque o método `call`.

### invocation_of_non_function {:#invocation_of_non_function}

_'{0}' não é uma função._

#### Descrição

O analisador produz este diagnóstico quando encontra uma invocação de função,
mas o nome da função que está sendo invocada é definido para ser algo
diferente de uma função.

#### Exemplo

O código a seguir produz este diagnóstico porque `Binary` é o nome de um
tipo de função, não uma função:

```dart
typedef Binary = int Function(int, int);

int f() {
  return [!Binary!](1, 2);
}
```

#### Correções comuns

Substitua o nome pelo nome de uma função.

### invocation_of_non_function_expression {:#invocation_of_non_function_expression}

_A expressão não avalia para uma função, portanto, não pode ser invocada._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de função é
encontrada, mas o nome que está sendo referenciado não é o nome de uma função,
ou quando a expressão que calcula a função não calcula uma função.

#### Exemplos

O código a seguir produz este diagnóstico porque `x` não é uma função:

```dart
int x = 0;

int f() => x;

var y = [!x!]();
```

O código a seguir produz este diagnóstico porque `f()` não retorna uma
função:

```dart
int x = 0;

int f() => x;

var y = [!f()!]();
```

#### Correções comuns

Se você precisa invocar uma função, então substitua o código antes da lista
de argumentos pelo nome de uma função ou por uma expressão que calcule uma
função:

```dart
int x = 0;

int f() => x;

var y = f();
```

### label_in_outer_scope {:#label_in_outer_scope}

_Não é possível referenciar o rótulo '{0}' declarado em um método externo._

#### Descrição

O analisador produz este diagnóstico quando uma declaração `break` ou
`continue` referencia um rótulo que é declarado em um método ou função
que contém a função na qual a declaração `break` ou `continue`
aparece. As declarações `break` e `continue` não podem ser usadas para
transferir o controle para fora da função que as contém.

#### Exemplo

O código a seguir produz este diagnóstico porque o rótulo `loop` é
declarado fora da função local `g`:

```dart
void f() {
  loop:
  while (true) {
    void g() {
      break [!loop!];
    }

    g();
  }
}
```

#### Correções comuns

Tente reescrever o código para que não seja necessário transferir o controle
para fora da função local, possivelmente incluindo a função local:

```dart
void f() {
  loop:
  while (true) {
    break loop;
  }
}
```

Se isso não for possível, tente reescrever a função local para que um
valor retornado pela função possa ser usado para determinar se o controle é
transferido:

```dart
void f() {
  loop:
  while (true) {
    bool g() {
      return true;
    }

    if (g()) {
      break loop;
    }
  }
}
```

### label_undefined {:#label_undefined}

_Não é possível referenciar um rótulo indefinido '{0}'._

#### Descrição

O analisador produz este diagnóstico quando encontra uma referência a um
rótulo que não está definido no escopo da declaração `break` ou
`continue` que o está referenciando.

#### Exemplo

O código a seguir produz este diagnóstico porque o rótulo `loop` não está
definido em lugar nenhum:

```dart
void f() {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break [!loop!];
      }
    }
  }
}
```

#### Correções comuns

Se o rótulo deve estar na declaração `do`, `for`, `switch` ou
`while` mais interna, então remova o rótulo:

```dart
void f() {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break;
      }
    }
  }
}
```

Se o rótulo deve estar em alguma outra declaração, então adicione o rótulo:

```dart
void f() {
  loop: for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break loop;
      }
    }
  }
}
```

### late_final_field_with_const_constructor {:#late_final_field_with_const_constructor}

_Não é possível ter um campo `late final` em uma classe com um construtor
`const` generativo._

#### Descrição

O analisador produz este diagnóstico quando uma classe que tem pelo menos um
construtor `const` também tem um campo marcado como `late` e `final`.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `A` tem um
construtor `const` e o campo `final` `f` está marcado como `late`:

```dart
class A {
  [!late!] final int f;

  const A();
}
```

#### Correções comuns

Se o campo não precisa ser marcado como `late`, então remova o modificador
`late` do campo:

```dart
class A {
  final int f = 0;

  const A();
}
```

Se o campo deve ser marcado como `late`, então remova o modificador `const`
dos construtores:

```dart
class A {
  late final int f;

  A();
}
```

### late_final_local_already_assigned {:#late_final_local_already_assigned}

_A variável local `late final` já foi atribuída._

#### Descrição

O analisador produz este diagnóstico quando o analisador pode provar que uma
variável local marcada como `late` e `final` já foi atribuída a um
valor no ponto em que ocorre outra atribuição.

Como as variáveis `final` só podem ser atribuídas uma vez, as atribuições
subsequentes são garantidas para falhar, então elas são sinalizadas.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `final`
`v` recebe um valor em dois lugares:

```dart
int f() {
  late final int v;
  v = 0;
  [!v!] += 1;
  return v;
}
```

#### Correções comuns

Se você precisa ser capaz de reatribuir a variável, então remova a
palavra-chave `final`:

```dart
int f() {
  late int v;
  v = 0;
  v += 1;
  return v;
}
```

Se você não precisa reatribuir a variável, então remova todas as atribuições
exceto a primeira:

```dart
int f() {
  late final int v;
  v = 0;
  return v;
}
```

### leaf_call_must_not_return_handle {:#leaf_call_must_not_return_handle}

_Uma chamada leaf de FFI não pode retornar um 'Handle'._

#### Descrição

O analisador produz este diagnóstico quando o valor do argumento `isLeaf`
em uma invocação de `Pointer.asFunction` ou
`DynamicLibrary.lookupFunction` é `true` e a função que seria
retornada teria um tipo de retorno de `Handle`.

O analisador também produz este diagnóstico quando o valor do argumento
`isLeaf` em uma anotação `Native` é `true` e o argumento de tipo na
anotação é um tipo de função cujo tipo de retorno é `Handle`.

Em todos esses casos, as chamadas leaf só são compatíveis com os tipos
`bool`, `int`, `float`, `double` e, como um tipo de retorno, `void`.

Para obter mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a função `p`
retorna um `Handle`, mas o argumento `isLeaf` é `true`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Handle Function()>> p) {
  p.[!asFunction!]<Object Function()>(isLeaf: true);
}
```

#### Correções comuns

Se a função retorna um handle (manipulador), então remova o argumento
`isLeaf`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Handle Function()>> p) {
  p.asFunction<Object Function()>();
}
```

Se a função retorna um dos tipos compatíveis, então corrija o tipo
informação:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Int32 Function()>> p) {
  p.asFunction<int Function()>(isLeaf: true);
}
```

### leaf_call_must_not_take_handle {:#leaf_call_must_not_take_handle}

_Uma chamada leaf de FFI não pode receber argumentos do tipo 'Handle'._

#### Descrição

O analisador produz este diagnóstico quando o valor do argumento `isLeaf`
em uma invocação de `Pointer.asFunction` ou
`DynamicLibrary.lookupFunction` é `true` e a função que seria
retornada teria um parâmetro do tipo `Handle`.

Para obter mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a função `p` tem um
parâmetro do tipo `Handle`, mas o argumento `isLeaf` é `true`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Handle)>> p) {
  p.[!asFunction!]<void Function(Object)>(isLeaf: true);
}
```

#### Correções comuns

Se a função tiver pelo menos um parâmetro do tipo `Handle`, então remova
o argumento `isLeaf`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Handle)>> p) {
  p.asFunction<void Function(Object)>();
}
```

Se nenhum dos parâmetros da função for `Handle`s, então corrija o tipo
informação:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Int8)>> p) {
  p.asFunction<void Function(int)>(isLeaf: true);
}
```

### list_element_type_not_assignable {:#list_element_type_not_assignable}

_O tipo de elemento '{0}' não pode ser atribuído ao tipo de lista '{1}'._

#### Descrição

O analisador produz este diagnóstico quando o tipo de um elemento em um
literal de lista não é atribuível ao tipo de elemento da lista.

#### Exemplo

O código a seguir produz este diagnóstico porque `2.5` é um double, e
a lista pode conter apenas inteiros:

```dart
List<int> x = [1, [!2.5!], 3];
```

#### Correções comuns

Se você pretendia adicionar um objeto diferente à lista, então substitua o
elemento por uma expressão que calcule o objeto pretendido:

```dart
List<int> x = [1, 2, 3];
```

Se o objeto não deveria estar na lista, então remova o elemento:

```dart
List<int> x = [1, 3];
```

Se o objeto que está sendo calculado estiver correto, então amplie o tipo de
elemento da lista para permitir todos os diferentes tipos de objetos que
ela precisa conter:

```dart
List<num> x = [1, 2.5, 3];
```

### main_first_positional_parameter_type {:#main_first_positional_parameter_type}

_O tipo do primeiro parâmetro posicional da função 'main' deve ser um
super tipo de 'List<String>'._

#### Descrição

O analisador produz este diagnóstico quando o primeiro parâmetro posicional
de uma função chamada `main` não é um super tipo de `List<String>`.

#### Exemplo

O código a seguir produz este diagnóstico porque `List<int>` não é um
super tipo de `List<String>`:

```dart
void main([!List<int>!] args) {}
```

#### Correções comuns

Se a função é um ponto de entrada, então altere o tipo do primeiro
parâmetro posicional para ser um super tipo de `List<String>`:

```dart
void main(List<String> args) {}
```

Se a função não é um ponto de entrada, então altere o nome da função:

```dart
void f(List<int> args) {}
```

### main_has_required_named_parameters {:#main_has_required_named_parameters}

_A função 'main' não pode ter nenhum parâmetro nomeado obrigatório._

#### Descrição

O analisador produz este diagnóstico quando uma função chamada `main` tem
um ou mais parâmetros nomeados obrigatórios.

#### Exemplo

O código a seguir produz este diagnóstico porque a função chamada
`main` tem um parâmetro nomeado obrigatório (`x`):

```dart
void [!main!]({required int x}) {}
```

#### Correções comuns

Se a função é um ponto de entrada, então remova a palavra-chave `required`:

```dart
void main({int? x}) {}
```

Se a função não é um ponto de entrada, então altere o nome da função:

```dart
void f({required int x}) {}
```

### main_has_too_many_required_positional_parameters {:#main_has_too_many_required_positional_parameters}

_A função 'main' não pode ter mais de dois parâmetros posicionais
obrigatórios._

#### Descrição

O analisador produz este diagnóstico quando uma função chamada `main` tem
mais de dois parâmetros posicionais obrigatórios.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `main` tem
três parâmetros posicionais obrigatórios:

```dart
void [!main!](List<String> args, int x, int y) {}
```

#### Correções comuns

Se a função é um ponto de entrada e os parâmetros extras não são usados,
então remova-os:

```dart
void main(List<String> args, int x) {}
```

Se a função é um ponto de entrada, mas os parâmetros extras usados são para
quando a função não está sendo usada como um ponto de entrada, então torne os
parâmetros extras opcionais:

```dart
void main(List<String> args, int x, [int y = 0]) {}
```

Se a função não é um ponto de entrada, então altere o nome da função:

```dart
void f(List<String> args, int x, int y) {}
```

### main_is_not_function {:#main_is_not_function}

_A declaração nomeada 'main' deve ser uma função._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca contém uma
declaração do nome `main` que não é a declaração de uma função de nível
superior.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `main` está
sendo usado para declarar uma variável de nível superior:

```dart
var [!main!] = 3;
```

#### Correções comuns

Use um nome diferente para a declaração:

```dart
var mainIndex = 3;
```

### map_entry_not_in_map {:#map_entry_not_in_map}

_As entradas de mapa só podem ser usadas em um literal de mapa._

#### Descrição

O analisador produz este diagnóstico quando uma entrada de mapa (um par
chave/valor) é encontrada em um literal de conjunto.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal tem uma entrada
de mapa mesmo que seja um literal de conjunto:

```dart
var collection = <String>{[!'a' : 'b'!]};
```

#### Correções comuns

Se você pretendia que a coleção fosse um mapa, então altere o código para
que seja um mapa. No exemplo anterior, você pode fazer isso adicionando
outro argumento de tipo:

```dart
var collection = <String, String>{'a' : 'b'};
```

Em outros casos, você pode precisar alterar o tipo explícito de `Set` para
`Map`.

Se você pretendia que a coleção fosse um conjunto, então remova a entrada de
mapa, possivelmente substituindo os dois pontos por uma vírgula se ambos os
valores devem ser incluídos no conjunto:

```dart
var collection = <String>{'a', 'b'};
```

### map_key_type_not_assignable {:#map_key_type_not_assignable}

_O tipo de elemento '{0}' não pode ser atribuído ao tipo de chave de mapa '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma chave de um par chave-valor
em um literal de mapa tem um tipo que não é atribuível ao tipo de chave do
mapa.

#### Exemplo

O código a seguir produz este diagnóstico porque `2` é um `int`, mas
as chaves do mapa devem ser `String`s:

```dart
var m = <String, String>{[!2!] : 'a'};
```

#### Correções comuns

Se o tipo do mapa estiver correto, então altere a chave para ter o tipo
correto:

```dart
var m = <String, String>{'2' : 'a'};
```

Se o tipo da chave estiver correto, então altere o tipo de chave do mapa:

```dart
var m = <int, String>{2 : 'a'};
```

### map_value_type_not_assignable {:#map_value_type_not_assignable}

_O tipo de elemento '{0}' não pode ser atribuído ao tipo de valor de mapa '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um valor de um par chave-valor
em um literal de mapa tem um tipo que não é atribuível ao tipo de valor do
mapa.

#### Exemplo

O código a seguir produz este diagnóstico porque `2` é um `int`, mas/
os valores do mapa devem ser `String`s:

```dart
var m = <String, String>{'a' : [!2!]};
```

#### Correções comuns

Se o tipo do mapa estiver correto, então altere o valor para ter o
tipo correto:

```dart
var m = <String, String>{'a' : '2'};
```

Se o tipo do valor estiver correto, então altere o tipo de valor do mapa:

```dart
var m = <String, int>{'a' : 2};
```

### mismatched_annotation_on_struct_field {:#mismatched_annotation_on_struct_field}

_A anotação não corresponde ao tipo declarado do campo._

#### Descrição

O analisador produz este diagnóstico quando a anotação em um campo em uma
subclasse de `Struct` ou `Union` não corresponde ao tipo Dart do campo.

Para obter mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a anotação
`Double` não corresponde ao tipo Dart `int`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external int x;
}
```

#### Correções comuns

Se o tipo do campo estiver correto, então altere a anotação para corresponder:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

Se a anotação estiver correta, então altere o tipo do campo para corresponder:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Double()
  external double x;
}
```

### missing_annotation_on_struct_field {:#missing_annotation_on_struct_field}

_Os campos do tipo '{0}' em uma subclasse de '{1}' devem ter uma anotação
indicando o tipo nativo._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` cujo tipo requer uma anotação não tem uma.
Os tipos Dart `int`, `double` e `Array` são usados para representar múltiplos
tipos C, e a anotação especifica qual dos tipos C compatíveis o
campo representa.

Para obter mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `x` não tem
uma anotação indicando a largura subjacente do valor inteiro:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!int!] x;
}
```

#### Correções comuns

Adicione uma anotação apropriada ao campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int64()
  external int x;
}
```

### missing_dart_library {:#missing_dart_library}

_A biblioteca necessária '{0}' está faltando._

#### Descrição

O analisador produz este diagnóstico quando o SDK do Dart ou Flutter
não está instalado corretamente e, como resultado, uma das bibliotecas
`dart:` não pode ser encontrada.

#### Correções comuns

Reinstale o SDK do Dart ou Flutter.

### missing_default_value_for_parameter {:#missing_default_value_for_parameter}

_O parâmetro '{0}' não pode ter um valor 'null' por causa de seu tipo, mas o
valor padrão implícito é 'null'._

_Com segurança nula, use a palavra-chave 'required', não a anotação '@required'._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro opcional, seja
posicional ou nomeado, tem um tipo [potencialmente não anulável][potencialmente não anulável] e não
especifica um valor padrão. Parâmetros opcionais que não têm um padrão
explícito têm um valor padrão implícito de `null`. Se o tipo do
parâmetro não permitir que o parâmetro tenha um valor de `null`, então o
valor padrão implícito não é válido.

#### Exemplos

O código a seguir produz este diagnóstico porque `x` não pode ser `null`
e nenhum valor padrão não `null` é especificado:

```dart
void f([int [!x!]]) {}
```

Assim como este:

```dart
void g({int [!x!]}) {}
```

#### Correções comuns

Se você quiser usar `null` para indicar que nenhum valor foi fornecido, então
você precisa tornar o tipo anulável:

```dart
void f([int? x]) {}
void g({int? x}) {}
```

Se o parâmetro não pode ser null, então forneça um valor padrão:

```dart
void f([int x = 1]) {}
void g({int x = 2}) {}
```

ou torne o parâmetro um parâmetro obrigatório:

```dart
void f(int x) {}
void g({required int x}) {}
```

### missing_dependency {:#missing_dependency}

_Faltando uma dependência do pacote importado '{0}'._

#### Descrição

O analisador produz este diagnóstico quando há um pacote que foi
importado na fonte, mas não está listado como uma dependência do
pacote de importação.

#### Exemplo

O código a seguir produz este diagnóstico porque o pacote `path` não
está listado como uma dependência, enquanto há uma declaração de importação
com o pacote `path` no código-fonte do pacote `example`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

#### Correções comuns

Adicione o pacote ausente `path` ao campo `dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
  path: any
```

### missing_enum_constant_in_switch {:#missing_enum_constant_in_switch}

_Cláusula case ausente para '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma declaração `switch` para um
enum não inclui uma opção para um dos valores no enum.

Observe que `null` é sempre um valor possível para um enum e, portanto, também
deve ser tratado.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor do enum `e2`
não é tratado:

```dart
enum E { e1, e2 }

void f(E e) {
  [!switch (e)!] {
    case E.e1:
      break;
  }
}
```

#### Correções comuns

Se houver tratamento especial para os valores ausentes, então adicione uma
cláusula `case` para cada um dos valores ausentes:

```dart
enum E { e1, e2 }

void f(E e) {
  switch (e) {
    case E.e1:
      break;
    case E.e2:
      break;
  }
}
```

Se os valores ausentes devem ser tratados da mesma forma, então adicione um
cláusula `default`:

```dart
enum E { e1, e2 }

void f(E e) {
  switch (e) {
    case E.e1:
      break;
    default:
      break;
  }
}
```

### missing_exception_value {:#missing_exception_value}

_O método {0} deve ter um valor de retorno excepcional (o segundo argumento)
quando o tipo de retorno da função não é 'void', 'Handle' nem 'Pointer'._

#### Descrição

O analisador produz este diagnóstico quando uma invocação do método
`Pointer.fromFunction` ou `NativeCallable.isolateLocal`
não tem um segundo argumento (o valor de retorno excepcional) quando o tipo a
ser retornado da invocação não é `void`, `Handle` nem `Pointer`.

Para obter mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo retornado por
`f` deve ser um inteiro de 8 bits, mas a chamada para `fromFunction`
não inclui um argumento de retorno excepcional:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  Pointer.[!fromFunction!]<Int8 Function(Int8)>(f);
}
```

#### Correções comuns

Adicione um tipo de retorno excepcional:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  Pointer.fromFunction<Int8 Function(Int8)>(f, 0);
}
```

### missing_field_type_in_struct {:#missing_field_type_in_struct}

_Os campos em classes struct devem ter um tipo explicitamente declarado
de 'int', 'double' ou 'Pointer'._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` não tem uma anotação de tipo. Cada campo deve ter
um tipo explícito, e o tipo deve ser `int`, `double`, `Pointer` ou uma
subclasse de `Struct` ou `Union`.

Para obter mais informações sobre FFI, consulte [Interoperação C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `str`
não tem uma anotação de tipo:

```dart
import 'dart:ffi';

final class C extends Struct {
  external var [!str!];

  @Int32()
  external int i;
}
```

#### Correções comuns

Especifique explicitamente o tipo do campo:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  external Pointer<Utf8> str;

  @Int32()
  external int i;
}
```

### missing_name {:#missing_name}

_O campo 'name' é obrigatório, mas está ausente._

#### Descrição

O analisador produz este diagnóstico quando não há uma chave `name` de
nível superior. A chave `name` fornece o nome do pacote, que é obrigatório.

#### Exemplo

O código a seguir produz este diagnóstico porque o pacote não
tem um nome:

```yaml
dependencies:
  meta: ^1.0.2
```

#### Correções comuns

Adicione a chave de nível superior `name` com um valor que seja o nome do pacote:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

### missing_named_pattern_field_name {:#missing_named_pattern_field_name}

_O nome do getter (acessador) não é especificado explicitamente, e o padrão não é uma
variável._

#### Descrição

O analisador produz este diagnóstico quando, dentro de um padrão de objeto, a
especificação de uma propriedade e o padrão usado para corresponder ao
valor da propriedade não têm:

- um nome de getter antes dos dois pontos
- um padrão de variável do qual o nome do getter pode ser inferido

#### Exemplo

O código a seguir produz este diagnóstico porque não há nome de getter
antes dos dois pontos e nenhum padrão de variável depois dos dois pontos no
padrão de objeto (`C(:0)`):

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C([!:0!]):
      break;
  }
}
```

#### Correções comuns

Se você precisar usar o valor real da propriedade dentro do escopo do padrão,
adicione um padrão de variável onde o nome da variável é o mesmo que o nome
da propriedade que está sendo correspondida:

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C(:var f) when f == 0:
      print(f);
  }
}
```

Se você não precisar usar o valor real da propriedade dentro do escopo
do padrão, adicione o nome da propriedade que está sendo correspondida
antes dos dois pontos:

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C(f: 0):
      break;
  }
}
```

### missing_override_of_must_be_overridden {:#missing_override_of_must_be_overridden}

_Implementação concreta ausente de '{0}'._

_Implementações concretas ausentes de '{0}' e '{1}'._

_Implementações concretas ausentes de '{0}', '{1}' e mais {2}._

#### Descrição

O analisador produz este diagnóstico quando um membro de instância que tem a
anotação `@mustBeOverridden` não é sobrescrito em uma subclasse.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `B` não tem uma
sobrescrita do método herdado `A.m` quando `A.m` é anotado com
`@mustBeOverridden`:

```dart
import 'package:meta/meta.dart';

class A {
  @mustBeOverridden
  void m() {}
}

class [!B!] extends A {}
```

#### Correções comuns

Se a anotação for apropriada para o membro, sobrescreva o membro na
subclasse:

```dart
import 'package:meta/meta.dart';

class A {
  @mustBeOverridden
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```

Se a anotação não for apropriada para o membro, remova a anotação:

```dart
class A {
  void m() {}
}

class B extends A {}
```

### missing_required_argument {:#missing_required_argument}

_O parâmetro nomeado '{0}' é obrigatório, mas não há argumento correspondente._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de uma função está
perdendo um parâmetro nomeado obrigatório.

#### Exemplo

O código a seguir produz este diagnóstico porque a invocação de `f` não
inclui um valor para o parâmetro nomeado obrigatório `end`:

```dart
void f(int start, {required int end}) {}
void g() {
  [!f!](3);
}
```

#### Correções comuns

Adicione um argumento nomeado correspondente ao parâmetro obrigatório
ausente:

```dart
void f(int start, {required int end}) {}
void g() {
  f(3, end: 5);
}
```

### missing_required_param {:#missing_required_param}

_O parâmetro '{0}' é obrigatório._

_O parâmetro '{0}' é obrigatório. {1}._

#### Descrição

O analisador produz este diagnóstico quando um método ou função com um
parâmetro nomeado que é anotado como obrigatório é invocado sem
fornecer um valor para o parâmetro.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro nomeado `x`
é obrigatório:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  [!f!]();
}
```

#### Correções comuns

Forneça o valor obrigatório:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  f(x: 2);
}
```

### missing_return {:#missing_return}

_Esta função tem um tipo de retorno de '{0}', mas não termina com um comando
return._

#### Descrição

Qualquer função ou método que não termina com um retorno explícito ou um
lançamento implicitamente retorna `null`. Este raramente é o comportamento
desejado. O analisador produz este diagnóstico quando encontra um retorno
implícito.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` não termina com um
return:

```dart
int [!f!](int x) {
  if (x < 0) {
    return 0;
  }
}
```

#### Correções comuns

Adicione um comando `return` que torna o valor de retorno explícito, mesmo
se `null` for o valor apropriado.

### missing_size_annotation_carray {:#missing_size_annotation_carray}

_Campos do tipo 'Array' devem ter exatamente uma anotação 'Array'._

#### Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` tem um tipo de `Array`, mas não tem uma única
anotação `Array` indicando as dimensões da matriz (array).

Para mais informações sobre FFI (Foreign Function Interface), veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `a0` não tem uma
anotação `Array`:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!Array<Uint8>!] a0;
}
```

#### Correções comuns

Certifique-se de que haja exatamente uma anotação `Array` no campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

### missing_variable_pattern {:#missing_variable_pattern}

_O padrão de variável '{0}' está faltando nesta ramificação do padrão lógico-ou._

#### Descrição

O analisador produz este diagnóstico quando uma ramificação de um padrão
lógico-ou não declara uma variável que é declarada na outra ramificação
do mesmo padrão.

#### Exemplo

O código a seguir produz este diagnóstico porque o lado direito do
padrão lógico-ou não declara a variável `a`:

```dart
void f((int, int) r) {
  if (r case (var a, 0) || [!(0, _)!]) {
    print(a);
  }
}
```

#### Correções comuns

Se a variável precisar ser referenciada nas declarações controladas,
adicione uma declaração da variável a todas as ramificações do padrão
lógico-ou:

```dart
void f((int, int) r) {
  if (r case (var a, 0) || (0, var a)) {
    print(a);
  }
}
```

Se a variável não precisar ser referenciada nas declarações controladas,
remova a declaração da variável de todas as ramificações do padrão
lógico-ou:

```dart
void f((int, int) r) {
  if (r case (_, 0) || (0, _)) {
    print('found a zero');
  }
}
```

Se a variável precisar ser referenciada se uma ramificação do padrão
corresponder, mas não quando a outra corresponder, divida o padrão em duas
partes:

```dart
void f((int, int) r) {
  switch (r) {
    case (var a, 0):
      print(a);
    case (0, _):
      print('found a zero');
  }
}
```

### mixin_application_concrete_super_invoked_member_type {:#mixin_application_concrete_super_invoked_member_type}

_O membro super-invocado '{0}' tem o tipo '{1}', e o membro concreto na
classe tem o tipo '{2}'._

#### Descrição

O analisador produz este diagnóstico quando um mixin que invoca um método
usando `super` é usado em uma classe onde a implementação concreta desse
método tem uma assinatura diferente da assinatura definida para esse método
pelo tipo `on` do mixin. A razão pela qual isso é um erro é porque a
invocação no mixin pode invocar o método de uma forma que seja
incompatível com o método que realmente será executado.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `C` usa o
mixin `M`, o mixin `M` invoca `foo` usando `super`, e a versão abstrata
de `foo` declarada em `I` (o tipo `on` do mixin) não tem a mesma
assinatura que a versão concreta de `foo` declarada em `A`:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]);
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B with [!M!] {}
```

#### Correções comuns

Se a classe não precisar usar o mixin, remova-o da cláusula `with`:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int? p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]);
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B {}
```

Se a classe precisar usar o mixin, certifique-se de que haja uma
implementação concreta do método que esteja em conformidade com a assinatura
esperada pelo mixin:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int? p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]) {
    super.foo(p);
  }
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B with M {}
```

### mixin_application_not_implemented_interface {:#mixin_application_not_implemented_interface}

_'{0}' não pode ser misturado em '{1}' porque '{1}' não implementa '{2}'._

#### Descrição

O analisador produz este diagnóstico quando um mixin que tem uma restrição
de superclasse é usado em uma [aplicação de mixin][aplicação de mixin] com uma superclasse
que não implementa a restrição necessária.

#### Exemplo

O código a seguir produz este diagnóstico porque o mixin `M` exige que a
classe à qual ele é aplicado seja uma subclasse de `A`, mas `Object` não é
uma subclasse de `A`:

```dart
class A {}

mixin M on A {}

class X = Object with [!M!];
```

#### Correções comuns

Se você precisar usar o mixin, altere a superclasse para ser a mesma que
ou uma subclasse da restrição de superclasse:

```dart
class A {}

mixin M on A {}

class X = A with M;
```

### mixin_application_no_concrete_super_invoked_member {:#mixin_application_no_concrete_super_invoked_member}

_A classe não tem uma implementação concreta do membro super-invocado
'{0}'._

_A classe não tem uma implementação concreta do setter super-invocado
'{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma [aplicação de mixin][aplicação de mixin]
contém uma invocação de um membro de sua superclasse, e não há membro
concreto desse nome na superclasse da aplicação de mixin.

#### Exemplo

O código a seguir produz este diagnóstico porque o mixin `M` contém a
invocação `super.m()`, e a classe `A`, que é a superclasse da
[aplicação de mixin][aplicação de mixin] `A+M`, não define uma implementação concreta de
`m`:

```dart
abstract class A {
  void m();
}

mixin M on A {
  void bar() {
    super.m();
  }
}

abstract class B extends A with [!M!] {}
```

#### Correções comuns

Se você pretendia aplicar o mixin `M` a uma classe diferente, uma que
tenha uma implementação concreta de `m`, altere a superclasse de `B` para
essa classe:

```dart
abstract class A {
  void m();
}

mixin M on A {
  void bar() {
    super.m();
  }
}

class C implements A {
  void m() {}
}

abstract class B extends C with M {}
```

Se você precisar fazer de `B` uma subclasse de `A`, adicione uma
implementação concreta de `m` em `A`:

```dart
abstract class A {
  void m() {}
}

mixin M on A {
  void bar() {
    super.m();
  }
}

abstract class B extends A with M {}
```

### mixin_class_declaration_extends_not_object {:#mixin_class_declaration_extends_not_object}

_A classe '{0}' não pode ser declarada um mixin porque estende uma classe
diferente de 'Object'._

#### Descrição

O analisador produz este diagnóstico quando uma classe que é marcada com o
modificador `mixin` estende uma classe diferente de `Object`. Uma classe
mixin não pode ter uma superclasse diferente de `Object`.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `B`, que
tem o modificador `mixin`, estende `A`:

```dart
class A {}

mixin class B extends [!A!] {}
```

#### Correções comuns

Se você quiser que a classe seja usada como um mixin, altere a superclasse
para `Object`, explicitamente ou removendo a cláusula `extends`:

```dart
class A {}

mixin class B {}
```

Se a classe precisar ter uma superclasse diferente de `Object`, remova
o modificador `mixin`:

```dart
class A {}

class B extends A {}
```

Se você precisar de um mixin e uma subclasse de uma classe diferente de
`Object`, mova os membros da subclasse para um novo mixin, remova o
modificador `mixin` da subclasse e aplique o novo mixin à subclasse:

```dart
class A {}

class B extends A with M {}

mixin M {}
```

Dependendo dos membros da subclasse, isso pode exigir a adição de uma
cláusula `on` ao mixin.

### mixin_class_declares_constructor {:#mixin_class_declares_constructor}

_A classe '{0}' não pode ser usada como um mixin porque declara um
construtor._

#### Descrição

O analisador produz este diagnóstico quando uma classe é usada como um mixin
e a classe mixada define um construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `A`, que
define um construtor, está sendo usada como um mixin:

```dart
//@dart=2.19
class A {
  A();
}

class B with [!A!] {}
```

#### Correções comuns

Se for possível converter a classe em um mixin, faça isso:

```dart
mixin A {
}

class B with A {}
```

Se a classe não puder ser um mixin e for possível remover o construtor,
faça isso:

```dart
//@dart=2.19
class A {
}

class B with A {}
```

Se a classe não puder ser um mixin e você não puder remover o construtor,
tente estender ou implementar a classe em vez de misturá-la:

```dart
class A {
  A();
}

class B extends A {}
```

### mixin_inherits_from_not_object {:#mixin_inherits_from_not_object}

_A classe '{0}' não pode ser usada como um mixin porque estende uma classe
diferente de 'Object'._

#### Descrição

O analisador produz este diagnóstico quando uma classe que estende uma
classe diferente de `Object` é usada como um mixin.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `B`, que
estende `A`, está sendo usada como um mixin por `C`:

```dart
//@dart=2.19
class A {}

class B extends A {}

class C with [!B!] {}
```

#### Correções comuns

Se a classe que está sendo usada como um mixin puder ser alterada para
estender `Object`, altere-a:

```dart
//@dart=2.19
class A {}

class B {}

class C with B {}
```

Se a classe que está sendo usada como um mixin não puder ser alterada e a
classe que a está usando estender `Object`, estenda a classe que está
sendo usada como um mixin:

```dart
class A {}

class B extends A {}

class C extends B {}
```

Se a classe não estender `Object` ou se você quiser ser capaz de misturar
o comportamento de `B` em outros lugares, crie um mixin real:

```dart
class A {}

mixin M on A {}

class B extends A with M {}

class C extends A with M {}
```

### mixin_instantiate {:#mixin_instantiate}

_Mixins não podem ser instanciados._

#### Descrição

O analisador produz este diagnóstico quando um mixin é instanciado.

#### Exemplo

O código a seguir produz este diagnóstico porque o mixin `M` está sendo
instanciado:

```dart
mixin M {}

var m = [!M!]();
```

#### Correções comuns

Se você pretende usar uma instância de uma classe, use o nome dessa classe
em vez do nome do mixin.

### mixin_of_non_class {:#mixin_of_non_class}

_Classes só podem misturar mixins e classes._

#### Descrição

O analisador produz este diagnóstico quando um nome em uma cláusula `with` é
definido como algo diferente de um mixin ou uma classe.

#### Exemplo

O código a seguir produz este diagnóstico porque `F` é definido como um
tipo de função:

```dart
typedef F = int Function(String);

class C with [!F!] {}
```

#### Correções comuns

Remova o nome inválido da lista, possivelmente substituindo-o pelo nome
do mixin ou classe pretendido:

```dart
typedef F = int Function(String);

class C {}
```

### mixin_on_sealed_class {:#mixin_on_sealed_class}

_A classe '{0}' não deve ser usada como uma restrição de mixin porque é
sealed (selada), e qualquer classe que misture neste mixin deve ter '{0}'
como uma superclasse._

#### Descrição

O analisador produz este diagnóstico quando a restrição de superclasse de um
mixin é uma classe de um pacote diferente que foi marcada como
[`sealed`][meta-sealed] (selada). Classes que são seladas não podem ser
estendidas, implementadas, misturadas ou usadas como uma restrição de
superclasse.

#### Exemplo

Se o pacote `p` define uma classe selada:

```dart
import 'package:meta/meta.dart';

@sealed
class C {}
```

Então, o código a seguir, quando em um pacote diferente de `p`, produz este
diagnóstico:

```dart
import 'package:p/p.dart';

[!mixin M on C {}!]
```

#### Correções comuns

Se as classes que usam o mixin não precisam ser subclasses da classe
selada, considere adicionar um campo e delegar à instância encapsulada
da classe selada.

### mixin_super_class_constraint_deferred_class {:#mixin_super_class_constraint_deferred_class}

_Classes adiadas não podem ser usadas como restrições de superclasse._

#### Descrição

O analisador produz este diagnóstico quando uma restrição de superclasse de um
mixin é importada de uma biblioteca adiada (deferred).

#### Exemplo

O código a seguir produz este diagnóstico porque a restrição de
superclasse de `math.Random` é importada de uma biblioteca adiada:

```dart
import 'dart:async' deferred as async;

mixin M<T> on [!async.Stream<T>!] {}
```

#### Correções comuns

Se a importação não precisar ser adiada, remova a palavra-chave
`deferred`:

```dart
import 'dart:async' as async;

mixin M<T> on async.Stream<T> {}
```

Se a importação precisar ser adiada, remova a restrição de superclasse:

```dart
mixin M<T> {}
```

### mixin_super_class_constraint_non_interface {:#mixin_super_class_constraint_non_interface}

_Apenas classes e mixins podem ser usados como restrições de superclasse._

#### Descrição

O analisador produz este diagnóstico quando um tipo que segue a palavra-
chave `on` em uma declaração de mixin não é uma classe nem um mixin.

#### Exemplo

O código a seguir produz este diagnóstico porque `F` não é uma classe
nem um mixin:

```dart
typedef F = void Function();

mixin M on [!F!] {}
```

#### Correções comuns

Se o tipo pretendia ser uma classe, mas foi digitado incorretamente,
substitua o nome.

Caso contrário, remova o tipo da cláusula `on`.

### multiple_redirecting_constructor_invocations {:#multiple_redirecting-constructor-invocations}

_Construtores podem ter apenas um redirecionamento 'this', no máximo._

#### Descrição

O analisador produz este diagnóstico quando um construtor redireciona para
mais de um outro construtor na mesma classe (usando `this`).

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor não nomeado
em `C` está redirecionando para `this.a` e `this.b`:

```dart
class C {
  C() : this.a(), [!this.b()!];
  C.a();
  C.b();
}
```

#### Correções comuns

Remova todos os redirecionamentos, exceto um:

```dart
class C {
  C() : this.a();
  C.a();
  C.b();
}
```

### multiple_super_initializers {:#multiple_super_initializers}

_Um construtor pode ter no máximo um inicializador 'super'._

#### Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor contém mais de uma invocação de um construtor da superclasse.
A lista de inicializadores é obrigada a ter exatamente uma dessas chamadas,
que pode ser explícita ou implícita.

#### Exemplo

O código a seguir produz este diagnóstico porque a lista de
inicializadores para o construtor de `B` invoca o construtor `one` e o
construtor `two` da superclasse `A`:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0), [!super.two('')!];
}
```

#### Correções comuns

Se um dos super construtores inicializar totalmente a instância, remova o
outro:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0);
}
```

Se a inicialização alcançada por um dos super construtores puder ser
realizada no corpo do construtor, remova sua super invocação e execute a
inicialização no corpo:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0) {
    s = '';
  }
}
```

Se a inicialização só puder ser realizada em um construtor na superclasse,
adicione um novo construtor ou modifique um dos construtores existentes
para que haja um construtor que permita que toda a inicialização necessária
ocorra em uma única chamada:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
  A.three(this.x, this.s);
}

class B extends A {
  B() : super.three(0, '');
}
```

### must_be_a_native_function_type {:#must_be_a_native_function_type}

_O tipo '{0}' fornecido para '{1}' deve ser um tipo de função nativa
'dart:ffi' válido._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de `Pointer.fromFunction`,
`DynamicLibrary.lookupFunction` ou um construtor `NativeCallable`, tem um
argumento de tipo (seja explícito ou inferido) que não é um tipo de função
nativa.

Para mais informações sobre FFI (Foreign Function Interface), veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo `T` pode ser
qualquer subclasse de `Function`, mas o argumento de tipo para
`fromFunction` é obrigatório para ser um tipo de função nativa:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

class C<T extends Function> {
  void g() {
    Pointer.fromFunction<[!T!]>(f, 0);
  }
}
```

#### Correções comuns

Use um tipo de função nativa como o argumento de tipo para a invocação:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

class C<T extends Function> {
  void g() {
    Pointer.fromFunction<Int32 Function(Int32)>(f, 0);
  }
}
```

### must_be_a_subtype {:#must_be_a_subtype}

_O tipo '{0}' deve ser um subtipo de '{1}' para '{2}'._

#### Descrição

O analisador produz este diagnóstico em dois casos:
- Em uma invocação de `Pointer.fromFunction`, ou um
  construtor `NativeCallable` onde o argumento de tipo
  (seja explícito ou inferido) não é um supertipo do tipo da
  função passada como o primeiro argumento para o método.
- Em uma invocação de `DynamicLibrary.lookupFunction` onde o primeiro
  argumento de tipo não é um supertipo do segundo argumento de tipo.

Para mais informações sobre FFI (Foreign Function Interface), veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo da função `f`
(`String Function(int)`) não é um subtipo do argumento de tipo `T`
(`Int8 Function(Int8)`):

```dart
import 'dart:ffi';

typedef T = Int8 Function(Int8);

double f(double i) => i;

void g() {
  Pointer.fromFunction<T>([!f!], 5.0);
}
```

#### Correções comuns

Se a função estiver correta, altere o argumento de tipo para
corresponder:

```dart
import 'dart:ffi';

typedef T = Float Function(Float);

double f(double i) => i;

void g() {
  Pointer.fromFunction<T>(f, 5.0);
}
```

Se o argumento de tipo estiver correto, altere a função para
corresponder:

```dart
import 'dart:ffi';

typedef T = Int8 Function(Int8);

int f(int i) => i;

void g() {
  Pointer.fromFunction<T>(f, 5);
}
```

### must_be_immutable {:#must_be_immutable}

_Esta classe (ou uma classe da qual esta classe herda) é marcada como
'@immutable', mas um ou mais de seus campos de instância não são final: {0}_

#### Descrição

O analisador produz este diagnóstico quando uma classe imutável define um
ou mais campos de instância que não são final. Uma classe é imutável se
ela é marcada como imutável usando a anotação
[`immutable`][meta-immutable] ou se é uma subclasse de uma classe
imutável.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `x` não é
final:

```dart
import 'package:meta/meta.dart';

@immutable
class [!C!] {
  int x;

  C(this.x);
}
```

#### Correções comuns

Se as instâncias da classe devem ser imutáveis, adicione a palavra-chave
`final` a todas as declarações de campo não final:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final int x;

  C(this.x);
}
```

Se as instâncias da classe devem ser mutáveis, remova a anotação ou
escolha uma superclasse diferente se a anotação for herdada:

```dart
class C {
  int x;

  C(this.x);
}
```

### must_call_super {:#must_call_super}

_Este método sobrescreve um método anotado como '@mustCallSuper' em '{0}',
mas não invoca o método sobrescrito._

#### Descrição

O analisador produz este diagnóstico quando um método que sobrescreve um
método que é anotado como [`mustCallSuper`][meta-mustCallSuper] não invoca
o método sobrescrito conforme necessário.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `m` em `B`
não invoca o método sobrescrito `m` em `A`:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  [!m!]() {}
}
```

#### Correções comuns

Adicione uma invocação do método sobrescrito no método de sobrescrita:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  m() {
    super.m();
  }
}
```

### must_return_void {:#must_return_void}

_O tipo de retorno da função passada para 'NativeCallable.listener' deve
ser 'void' em vez de '{0}'._

#### Descrição

O analisador produz este diagnóstico quando você passa uma função
que não retorna `void` para o construtor `NativeCallable.listener`.

`NativeCallable.listener` cria um callable nativo que pode ser invocado
de qualquer thread. O código nativo que invoca o callable envia uma
mensagem de volta para o isolate que criou o callable e não espera por
uma resposta. Portanto, não é possível retornar um resultado do callable.

Para mais informações sobre FFI (Foreign Function Interface), veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a função
`f` retorna `int` em vez de `void`.

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  NativeCallable<Int32 Function(Int32)>.listener([!f!]);
}
```

#### Correções comuns

Altere o tipo de retorno da função para `void`.

```dart
import 'dart:ffi';

void f(int i) => print(i * 2);

void g() {
  NativeCallable<Void Function(Int32)>.listener(f);
}
```

### name_not_string {:#name_not_string}

_O valor do campo 'name' deve ser uma string._

#### Descrição

O analisador produz este diagnóstico quando a chave `name` de nível
superior tem um valor que não é uma string.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor que segue a
chave `name` é uma lista:

```yaml
name:
  [!- example!]
```

#### Correções comuns

Substitua o valor por uma string:

```yaml
name: example
```

### native_field_invalid_type {:#native_field_invalid_type}

_'{0}' é um tipo não suportado para campos nativos. Campos nativos só
suportam ponteiros, arrays ou tipos numéricos e compostos._

#### Descrição

O analisador produz este diagnóstico quando um campo anotado com `@Native`
tem um tipo não suportado para campos nativos.

Campos nativos suportam ponteiros, arrays, tipos numéricos e subtipos de
`Compound` (ou seja, structs ou unions). Outros subtipos de `NativeType`,
como `Handle` ou `NativeFunction` não são permitidos como campos nativos.

Funções nativas devem ser usadas com funções externas em vez de
campos externos.

Handles não são suportados porque não há como carregar e armazenar
objetos Dart em ponteiros de forma transparente.

Para mais informações sobre FFI (Foreign Function Interface), veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `free` usa
um tipo nativo não suportado, `NativeFunction`:

```dart
import 'dart:ffi';

@Native<NativeFunction<Void Function()>>()
external void Function() [!free!];
```

#### Correções comuns

Se você pretendia vincular a uma função nativa existente com um campo
`NativeFunction`, use métodos `@Native` em vez disso:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
external void free(Pointer<Void> ptr);
```

Para vincular a um campo que armazena um ponteiro de função em C, use um tipo pointer
para o campo Dart:

```dart
import 'dart:ffi';

@Native()
external Pointer<NativeFunction<Void Function(Pointer<Void>)>> free;
```

### native_field_missing_type {:#native-field-missing-type}

_O tipo nativo deste campo não pôde ser inferido e deve ser especificado
na anotação._

#### Descrição

O analisador produz este diagnóstico quando um campo anotado com `@Native`
requer uma dica de tipo na anotação para inferir o tipo nativo.

Tipos Dart como `int` e `double` têm múltiplas representações nativas
possíveis. Como o tipo nativo precisa ser conhecido em tempo de compilação
para gerar os carregamentos e armazenamentos corretos ao acessar o campo,
um tipo explícito deve ser fornecido.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `f` tem
o tipo `int` (para o qual existem múltiplas representações nativas), mas
nenhum parâmetro de tipo explícito na anotação `Native`:

```dart
import 'dart:ffi';

@Native()
external int [!f!];
```

#### Correções comuns

Para corrigir este diagnóstico, descubra a representação nativa correta
da declaração nativa do campo. Então, adicione o tipo correspondente à
anotação. Por exemplo, se `f` foi declarado como `uint8_t` em C,
o campo Dart deve ser declarado como:

```dart
import 'dart:ffi';

@Native<Uint8>()
external int f;
```

Para mais informações sobre FFI (Foreign Function Interface), veja [Interoperabilidade com C usando dart:ffi][ffi].

### native_field_not_static {:#native_field_not_static}

_Campos nativos devem ser estáticos._

#### Descrição

O analisador produz este diagnóstico quando um campo de instância em uma
classe foi anotado com `@Native`.
Campos nativos referem-se a variáveis globais em C, C++ ou outras linguagens
nativas, enquanto campos de instância em Dart são específicos para uma
instância dessa classe. Portanto, campos nativos devem ser estáticos.

Para mais informações sobre FFI (Foreign Function Interface), veja [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `f` na
classe `C` é `@Native`, mas não `static`:

```dart
import 'dart:ffi';

class C {
  @Native<Int>()
  external int [!f!];
}
```

#### Correções comuns

Torne o campo estático:

```dart
import 'dart:ffi';

class C {
  @Native<Int>()
  external static int f;
}
```

Ou mova-o para fora de uma classe, caso em que nenhum modificador `static`
explícito é necessário:

```dart
import 'dart:ffi';

class C {
}

@Native<Int>()
external int f;
```

Se você pretendia anotar um campo de instância que deveria fazer parte de
uma struct (estrutura), omita a anotação `@Native`:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int()
  external int f;
}
```

### native_function_missing_type

_O tipo nativo desta função não pôde ser inferido, portanto, deve ser especificado
na anotação._

#### Descrição

O analisador produz este diagnóstico quando uma função anotada com `@Native`
requer uma dica de tipo na anotação para inferir o tipo da função nativa.

Tipos Dart como `int` e `double` têm múltiplas representações nativas possíveis.
Como o tipo nativo precisa ser conhecido em tempo de compilação para gerar
bindings (ligações) e instruções de chamada corretas para a função, um tipo
explícito deve ser fornecido.

Para mais informações sobre FFI, veja [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f()` tem o tipo de
retorno `int`, mas não tem um parâmetro de tipo explícito na anotação `Native`:

```dart
import 'dart:ffi';

@Native()
external int [!f!]();
```

#### Correções Comuns

Adicione o tipo correspondente à anotação. Por exemplo, se `f()` foi declarada
para retornar um `int32_t` em C, a função Dart deve ser declarada como:

```dart
import 'dart:ffi';

@Native<Int32 Function()>()
external int f();
```

### negative_variable_dimension

_A dimensão variável de um array de comprimento variável deve ser não negativa._

#### Descrição

O analisador produz este diagnóstico em dois casos.

O primeiro é quando a dimensão variável fornecida em uma anotação
`Array.variableWithVariableDimension` é negativa. A dimensão variável é o
primeiro argumento na anotação.

O segundo é quando a dimensão variável fornecida em uma anotação
`Array.variableMulti` é negativa. A dimensão variável é especificada no
argumento `variableDimension` da anotação.

Para mais informações sobre FFI, veja [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplos

O código a seguir produz este diagnóstico porque uma dimensão variável de `-1`
foi fornecida na anotação `Array.variableWithVariableDimension`:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variableWithVariableDimension([!-1!])
  external Array<Uint8> a0;
}
```

O código a seguir produz este diagnóstico porque uma dimensão variável de `-1`
foi fornecida na anotação `Array.variableMulti`:

```dart
import 'dart:ffi';

final class MyStruct2 extends Struct {
  @Array.variableMulti(variableDimension: [!-1!], [1, 2])
  external Array<Array<Array<Uint8>>> a0;
}
```

#### Correções Comuns

Altere a dimensão variável com zero (`0`) ou um número positivo:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variableWithVariableDimension(1)
  external Array<Uint8> a0;
}
```

Altere a dimensão variável com zero (`0`) ou um número positivo:

```dart
import 'dart:ffi';

final class MyStruct2 extends Struct {
  @Array.variableMulti(variableDimension: 1, [1, 2])
  external Array<Array<Array<Uint8>>> a0;
}
```
[ffi]: https://dart.dev/guides/libraries/c-interop

### new_with_undefined_constructor_default {:#new_with_undefined_constructor_default}

_A classe '{0}' não tem um construtor não nomeado._

#### Descrição

O analisador produz este diagnóstico quando um construtor não nomeado é
invocado em uma classe que define construtores nomeados, mas a classe não
tem um construtor não nomeado.

#### Exemplo

O código a seguir produz este diagnóstico porque `A` não define um
construtor não nomeado:

```dart
class A {
  A.a();
}

A f() => [!A!]();
```

#### Correções comuns

Se um dos construtores nomeados faz o que você precisa, então use-o:

```dart
class A {
  A.a();
}

A f() => A.a();
```

Se nenhum dos construtores nomeados faz o que você precisa, e você pode
adicionar um construtor não nomeado, então adicione o construtor:

```dart
class A {
  A();
  A.a();
}

A f() => A();
```

### non_abstract_class_inherits_abstract_member {:#non_abstract_class_inherits_abstract_member}

_Implementação concreta ausente de '{0}'._

_Implementações concretas ausentes de '{0}' e '{1}'._

_Implementações concretas ausentes de '{0}', '{1}', '{2}', '{3}', e mais {4}._

_Implementações concretas ausentes de '{0}', '{1}', '{2}', e '{3}'._

_Implementações concretas ausentes de '{0}', '{1}', e '{2}'._

#### Descrição

O analisador produz este diagnóstico quando uma classe concreta herda um ou
mais membros abstratos, e não fornece ou herda uma implementação para
pelo menos um desses membros abstratos.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `B` não tem
uma implementação concreta de `m`:

```dart
abstract class A {
  void m();
}

class [!B!] extends A {}
```

#### Correções comuns

Se a subclasse pode fornecer uma implementação concreta para alguns ou todos
os membros abstratos herdados, então adicione as implementações concretas:

```dart
abstract class A {
  void m();
}

class B extends A {
  void m() {}
}
```

Se houver um mixin que fornece uma implementação dos métodos herdados,
então aplique o mixin à subclasse:

```dart
abstract class A {
  void m();
}

class B extends A with M {}

mixin M {
  void m() {}
}
```

Se a subclasse não pode fornecer uma implementação concreta para todos os
membros abstratos herdados, então marque a subclasse como abstrata:

```dart
abstract class A {
  void m();
}

abstract class B extends A {}
```

### non_bool_condition {:#non_bool_condition}

_Condições devem ter um tipo estático de 'bool'._

#### Descrição

O analisador produz este diagnóstico quando uma condição, como um loop `if`
ou `while`, não tem o tipo estático `bool`.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` tem o tipo estático
`int`:

```dart
void f(int x) {
  if ([!x!]) {
    // ...
  }
}
```

#### Correções comuns

Altere a condição para que ela produza um valor booleano:

```dart
void f(int x) {
  if (x == 0) {
    // ...
  }
}
```

### non_bool_expression {:#non_bool_expression}

_A expressão em um assert deve ser do tipo 'bool'._

#### Descrição

O analisador produz este diagnóstico quando a primeira expressão em um
assert tem um tipo diferente de `bool`.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de `p` é
`int`, mas um `bool` é requerido:

```dart
void f(int p) {
  assert([!p!]);
}
```

#### Correções comuns

Altere a expressão para que ela tenha o tipo `bool`:

```dart
void f(int p) {
  assert(p > 0);
}
```

### non_bool_negation_expression {:#non_bool_negation_expression}

_Um operando de negação deve ter um tipo estático de 'bool'._

#### Descrição

O analisador produz este diagnóstico quando o operando do operador de
negação unário (`!`) não tem o tipo `bool`.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` é um `int` quando
deve ser um `bool`:

```dart
int x = 0;
bool y = ![!x!];
```

#### Correções comuns

Substitua o operando por uma expressão que tenha o tipo `bool`:

```dart
int x = 0;
bool y = !(x > 0);
```

### non_bool_operand {:#non_bool_operand}

_Os operandos do operador '{0}' devem ser atribuíveis a 'bool'._

#### Descrição

O analisador produz este diagnóstico quando um dos operandos do operador
`&&` ou `||` não tem o tipo `bool`.

#### Exemplo

O código a seguir produz este diagnóstico porque `a` não é um valor
booleano:

```dart
int a = 3;
bool b = [!a!] || a > 1;
```

#### Correções comuns

Altere o operando para um valor booleano:

```dart
int a = 3;
bool b = a == 0 || a > 1;
```

### non_constant_annotation_constructor {:#non_constant_annotation_constructor}

_A criação de anotação só pode chamar um construtor const._

#### Descrição

O analisador produz este diagnóstico quando uma anotação é a invocação
de um construtor existente, mesmo que o construtor invocado não seja um
construtor const.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor para `C`
não é um construtor const:

```dart
[!@C()!]
void f() {
}

class C {
  C();
}
```

#### Correções comuns

Se for válido para a classe ter um construtor const, então crie um
construtor const que possa ser usado para a anotação:

```dart
@C()
void f() {
}

class C {
  const C();
}
```

Se não for válido para a classe ter um construtor const, então remova a
anotação ou use uma classe diferente para a anotação.

### non_constant_case_expression {:#non_constant_case_expression}

_Expressões case devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando a expressão em uma cláusula
`case` não é uma expressão constante.

#### Exemplo

O código a seguir produz este diagnóstico porque `j` não é uma constante:

```dart
void f(int i, int j) {
  switch (i) {
    case [!j!]:
      // ...
      break;
  }
}
```

#### Correções comuns

Torne a expressão uma expressão constante ou reescreva a declaração `switch`
como uma sequência de declarações `if`:

```dart
void f(int i, int j) {
  if (i == j) {
    // ...
  }
}
```

### non_constant_case_expression_from_deferred_library {:#non_constant_case_expression_from_deferred_library}

_Valores constantes de uma biblioteca adiada não podem ser usados como uma expressão case._

#### Descrição

O analisador produz este diagnóstico quando a expressão em uma cláusula
case referencia uma constante de uma biblioteca que é importada usando
uma importação adiada (deferred). Para que as declarações switch sejam
compiladas de forma eficiente, as constantes referenciadas nas cláusulas
case precisam estar disponíveis em tempo de compilação, e constantes de
bibliotecas adiadas não estão disponíveis em tempo de compilação.

Para mais informações, verifique
[Carregamento preguiçoso de uma biblioteca](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque a biblioteca `a.dart` é
importada usando uma importação `deferred`, e a constante `a.zero`,
declarada na biblioteca importada, é usada em uma cláusula case:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  switch (x) {
    case a.[!zero!]:
      // ...
      break;
  }
}
```

#### Correções comuns

Se você precisa referenciar a constante da biblioteca importada, então
remova a palavra-chave `deferred`:

```dart
import 'a.dart' as a;

void f(int x) {
  switch (x) {
    case a.zero:
      // ...
      break;
  }
}
```

Se você precisa referenciar a constante da biblioteca importada e também
precisa que a biblioteca importada seja adiada, então reescreva a declaração
switch como uma sequência de declarações `if`:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  if (x == a.zero) {
    // ...
  }
}
```

Se você não precisa referenciar a constante, então substitua a expressão
case:

```dart
void f(int x) {
  switch (x) {
    case 0:
      // ...
      break;
  }
}
```

### non_constant_default_value {:#non_constant_default_value}

_O valor padrão de um parâmetro opcional deve ser constante._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro opcional,
nomeado ou posicional, tem um valor padrão que não é uma constante de
tempo de compilação.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
var defaultValue = 3;

void f([int value = [!defaultValue!]]) {}
```

#### Correções comuns

Se o valor padrão pode ser convertido para ser uma constante, então
converta-o:

```dart
const defaultValue = 3;

void f([int value = defaultValue]) {}
```

Se o valor padrão precisa mudar ao longo do tempo, então aplique o valor
padrão dentro da função:

```dart
var defaultValue = 3;

void f([int? value]) {
  value ??= defaultValue;
}
```

### non_constant_default_value_from_deferred_library {:#non_constant_default_value_from_deferred_library}

_Valores constantes de uma biblioteca adiada não podem ser usados como um valor de parâmetro padrão._

#### Descrição

O analisador produz este diagnóstico quando o valor padrão de um parâmetro
opcional usa uma constante de uma biblioteca importada usando uma
importação adiada. Valores padrão precisam estar disponíveis em tempo de
compilação, e constantes de bibliotecas adiadas não estão disponíveis em
tempo de compilação.

Para mais informações, verifique
[Carregamento preguiçoso de uma biblioteca](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque `zero` é declarado em
uma biblioteca importada usando uma importação adiada:

```dart
import 'a.dart' deferred as a;

void f({int x = a.[!zero!]}) {}
```

#### Correções comuns

Se você precisa referenciar a constante da biblioteca importada, então
remova a palavra-chave `deferred`:

```dart
import 'a.dart' as a;

void f({int x = a.zero}) {}
```

Se você não precisa referenciar a constante, então substitua o valor
padrão:

```dart
void f({int x = 0}) {}
```

### non_constant_list_element {:#non_constant_list_element}

_Os valores em um literal de lista const devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando um elemento em um literal de
lista constante não é um valor constante. O literal de lista pode ser
constante explicitamente (porque é prefixado pela palavra-chave `const`)
ou implicitamente (porque aparece em um [contexto constante][contexto constante]).

#### Exemplo

O código a seguir produz este diagnóstico porque `x` não é uma constante,
mesmo que apareça em um literal de lista implicitamente constante:

```dart
var x = 2;
var y = const <int>[0, 1, [!x!]];
```

#### Correções comuns

Se a lista precisa ser uma lista constante, então converta o elemento para
ser uma constante. No exemplo acima, você pode adicionar a palavra-chave
`const` à declaração de `x`:

```dart
const x = 2;
var y = const <int>[0, 1, x];
```

Se a expressão não pode ser transformada em uma constante, então a lista
também não pode ser uma constante, então você deve alterar o código para
que a lista não seja uma constante. No exemplo acima, isso significa
remover a palavra-chave `const` antes do literal de lista:

```dart
var x = 2;
var y = <int>[0, 1, x];
```

### non_constant_map_element {:#non_constant_map_element}

_Os elementos em um literal de mapa const devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando um elemento `if` ou um elemento
spread em um mapa constante não é um elemento constante.

#### Exemplos

O código a seguir produz este diagnóstico porque está tentando espalhar um
mapa não constante:

```dart
var notConst = <int, int>{};
var map = const <int, int>{...[!notConst!]};
```

Da mesma forma, o código a seguir produz este diagnóstico porque a
condição no elemento `if` não é uma expressão constante:

```dart
bool notConst = true;
var map = const <int, int>{if ([!notConst!]) 1 : 2};
```

#### Correções comuns

Se o mapa precisa ser um mapa constante, então torne os elementos
constantes. No exemplo de spread, você pode fazer isso tornando a coleção
que está sendo espalhada uma constante:

```dart
const notConst = <int, int>{};
var map = const <int, int>{...notConst};
```

Se o mapa não precisa ser um mapa constante, então remova a palavra-chave
`const`:

```dart
bool notConst = true;
var map = <int, int>{if (notConst) 1 : 2};
```

### non_constant_map_key {:#non_constant_map_key}

_As chaves em um literal de mapa const devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando uma chave em um literal de mapa
constante não é um valor constante.

#### Exemplo

O código a seguir produz este diagnóstico porque `a` não é uma constante:

```dart
var a = 'a';
var m = const {[!a!]: 0};
```

#### Correções comuns

Se o mapa precisa ser um mapa constante, então torne a chave uma constante:

```dart
const a = 'a';
var m = const {a: 0};
```

Se o mapa não precisa ser um mapa constante, então remova a palavra-chave
`const`:

```dart
var a = 'a';
var m = {a: 0};
```

### non_constant_map_pattern_key {:#non_constant_map_pattern_key}

_Expressões de chave em padrões de mapa devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando uma chave em um padrão de mapa
não é uma expressão constante.

#### Exemplo

O código a seguir produz este diagnóstico porque a chave `A()` não é uma
constante:

```dart
void f(Object x) {
  if (x case {[!A()!]: 0}) {}
}

class A {
  const A();
}
```

#### Correções comuns

Use uma constante para a chave:

```dart
void f(Object x) {
  if (x case {const A(): 0}) {}
}

class A {
  const A();
}
```

### non_constant_map_value {:#non_constant_map_value}

_Os valores em um literal de mapa const devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando um valor em um literal de mapa
constante não é um valor constante.

#### Exemplo

O código a seguir produz este diagnóstico porque `a` não é uma constante:

```dart
var a = 'a';
var m = const {0: [!a!]};
```

#### Correções comuns

Se o mapa precisa ser um mapa constante, então torne a chave uma constante:

```dart
const a = 'a';
var m = const {0: a};
```

Se o mapa não precisa ser um mapa constante, então remova a palavra-chave
`const`:

```dart
var a = 'a';
var m = {0: a};
```

### non_constant_relational_pattern_expression {:#non_constant_relational_pattern_expression}

_A expressão de padrão relacional deve ser uma constante._

#### Descrição

O analisador produz este diagnóstico quando o valor em uma expressão de
padrão relacional não é uma expressão constante.

#### Exemplo

O código a seguir produz este diagnóstico porque o operando do operador
`>`, `a`, não é uma constante:

```dart
final a = 0;

void f(int x) {
  if (x case > [!a!]) {}
}
```

#### Correções comuns

Substitua o valor por uma expressão constante:

```dart
const a = 0;

void f(int x) {
  if (x case > a) {}
}
```

### non_constant_set_element {:#non_constant_set_element}

_Os valores em um literal de conjunto const devem ser constantes._

#### Descrição

O analisador produz este diagnóstico quando um literal de conjunto
constante contém um elemento que não é uma constante de tempo de
compilação.

#### Exemplo

O código a seguir produz este diagnóstico porque `i` não é uma constante:

```dart
var i = 0;

var s = const {[!i!]};
```

#### Correções comuns

Se o elemento pode ser alterado para ser uma constante, então altere-o:

```dart
const i = 0;

var s = const {i};
```

Se o elemento não pode ser uma constante, então remova a palavra-chave
`const`:

```dart
var i = 0;

var s = {i};
```

### non_constant_type_argument {:#non_constant_type_argument}

_Os argumentos de tipo para '{0}' devem ser conhecidos em tempo de compilação,
então eles não podem ser parâmetros de tipo._

#### Descrição

O analisador produz este diagnóstico quando os argumentos de tipo para um
método precisam ser conhecidos em tempo de compilação, mas um parâmetro de
tipo, cujo valor não pode ser conhecido em tempo de compilação, é usado
como um argumento de tipo.

Para mais informações sobre FFI (Foreign Function Interface), veja [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o argumento de tipo para
`Pointer.asFunction` deve ser conhecido em tempo de compilação, mas o
parâmetro de tipo `R`, que não é conhecido em tempo de compilação, está
sendo usado como o argumento de tipo:

```dart
import 'dart:ffi';

typedef T = int Function(int);

class C<R extends T> {
  void m(Pointer<NativeFunction<T>> p) {
    p.asFunction<[!R!]>();
  }
}
```

#### Correções comuns

Remova quaisquer usos de parâmetros de tipo:

```dart
import 'dart:ffi';

class C {
  void m(Pointer<NativeFunction<Int64 Function(Int64)>> p) {
    p.asFunction<int Function(int)>();
  }
}
```

### non_const_argument_for_const_parameter {:#non_const_argument_for_const_parameter}

_O argumento '{0}' deve ser uma constante._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro é anotado com a
anotação [`mustBeConst`][meta-mustBeConst] e o argumento correspondente não é
uma expressão constante.

#### Exemplo

O código a seguir produz este diagnóstico na invocação da função `f`
porque o valor do argumento passado para a função `g` não é uma
constante:

```dart
import 'package:meta/meta.dart' show mustBeConst;

int f(int value) => g([!value!]);

int g(@mustBeConst int value) => value + 1;
```

#### Correções comuns

Se uma constante adequada estiver disponível para usar, então substitua o
argumento por uma constante:

```dart
import 'package:meta/meta.dart' show mustBeConst;

const v = 3;

int f() => g(v);

int g(@mustBeConst int value) => value + 1;
```

### non_const_call_to_literal_constructor {:#non_const_call_to_literal_constructor}

_Esta criação de instância deve ser 'const', porque o construtor {0} é marcado
como '@literal'._

#### Descrição

O analisador produz este diagnóstico quando um construtor que tem a
anotação [`literal`][meta-literal] é invocado sem usar a palavra-chave
`const`, mas todos os argumentos para o construtor são constantes. A
anotação indica que o construtor deve ser usado para criar um valor
constante sempre que possível.

#### Exemplo

O código a seguir produz este diagnóstico:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}

C f() => [!C()!];
```

#### Correções comuns

Adicione a palavra-chave `const` antes da invocação do construtor:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}

void f() => const C();
```

### non_const_generative_enum_constructor {:#non_const_generative_enum_constructor}

_Construtores de enum generativos devem ser 'const'._

#### Descrição

O analisador produz este diagnóstico quando uma declaração enum contém um
construtor generativo que não é marcado como `const`.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor em `E`
não é marcado como sendo `const`:

```dart
enum E {
  e;

  [!E!]();
}
```

#### Correções comuns

Adicione a palavra-chave `const` antes do construtor:

```dart
enum E {
  e;

  const E();
}
```

### non_covariant_type_parameter_position_in_representation_type {:#non_covariant_type_parameter_position_in_representation_type}

_Um parâmetro de tipo de extensão não pode ser usado em uma posição não-covariante de seu tipo de representação._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro de tipo de um
tipo de extensão é usado em uma posição não-covariante no tipo de
representação desse tipo de extensão.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
é usado como um tipo de parâmetro no tipo de função `void Function(T)`, e
os parâmetros não são covariantes:

```dart
extension type A<[!T!]>(void Function(T) f) {}
```

#### Correções comuns

Remova o uso do parâmetro de tipo:

```dart
extension type A(void Function(String) f) {}
```

### non_exhaustive_switch_expression {:#non_exhaustive_switch_expression}

_O tipo '{0}' não é exaustivamente correspondido pelos casos switch, pois não
corresponde a '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma expressão `switch` está
perdendo um caso para um ou mais dos possíveis valores que poderiam fluir
através dela.

#### Exemplo

O código a seguir produz este diagnóstico porque a expressão switch não
tem um caso para o valor `E.three`:

```dart
enum E { one, two, three }

String f(E e) => [!switch!] (e) {
    E.one => 'one',
    E.two => 'two',
  };
```

#### Correções comuns

Se os valores ausentes são distintamente significativos para a expressão
switch, então adicione um caso para cada um dos valores faltando uma
correspondência:

```dart
enum E { one, two, three }

String f(E e) => switch (e) {
    E.one => 'one',
    E.two => 'two',
    E.three => 'three',
  };
```

Se os valores ausentes não precisam ser correspondidos, então adicione um
padrão curinga que retorna um padrão simples:

```dart
enum E { one, two, three }

String f(E e) => switch (e) {
    E.one => 'one',
    E.two => 'two',
    _ => 'unknown',
  };
```

Esteja ciente de que um padrão curinga lidará com quaisquer valores
adicionados ao tipo no futuro. Você perderá a capacidade de ter o
compilador avisando se o `switch` precisa ser atualizado para levar em conta os tipos recém-adicionados.

### non_exhaustive_switch_statement {:#non_exhaustive_switch_statement}

_O tipo '{0}' não é exaustivamente correspondido pelos casos switch, pois não
corresponde a '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma declaração `switch`
alternando sobre um tipo exaustivo está perdendo um caso para um ou mais
dos possíveis valores que poderiam fluir através dela.

#### Exemplo

O código a seguir produz este diagnóstico porque a declaração switch não
tem um caso para o valor `E.three`, e `E` é um
tipo exaustivo:

```dart
enum E { one, two, three }

void f(E e) {
  [!switch!] (e) {
    case E.one:
    case E.two:
  }
}
```

#### Correções comuns

Adicione um caso para cada uma das constantes que não estão sendo correspondidas atualmente:

```dart
enum E { one, two, three }

void f(E e) {
  switch (e) {
    case E.one:
    case E.two:
      break;
    case E.three:
  }
}
```

Se os valores ausentes não precisam ser correspondidos, então adicione uma
cláusula `default` ou um padrão curinga:

```dart
enum E { one, two, three }

void f(E e) {
  switch (e) {
    case E.one:
    case E.two:
      break;
    default:
  }
}
```

Mas esteja ciente de que adicionar uma cláusula `default` ou padrão
curinga fará com que quaisquer valores futuros do tipo exaustivo também
sejam tratados, então você terá perdido a capacidade do compilador avisá-lo
se o `switch` precisa ser atualizado.

### non_final_field_in_enum {:#non_final_field_in_enum}

_Enums só podem declarar campos final._

#### Descrição

O analisador produz este diagnóstico quando um campo de instância em um
enum não é marcado como `final`.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `f` não é um
campo final:

```dart
enum E {
  c;

  int [!f!] = 0;
}
```

#### Correções comuns

Se o campo deve ser definido para o enum, então marque o campo como
sendo `final`:

```dart
enum E {
  c;

  final int f = 0;
}
```

Se o campo pode ser removido, então remova-o:

```dart
enum E {
  c
}
```

### non_generative_constructor {:#non_generative_constructor}

_O construtor generativo '{0}' é esperado, mas um factory foi encontrado._

#### Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de
um construtor invoca um construtor da superclasse, e o construtor invocado
é um construtor factory. Apenas um construtor generativo pode ser invocado
na lista de inicializadores.

#### Exemplo

O código a seguir produz este diagnóstico porque a invocação do construtor
`super.one()` está invocando um construtor factory:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : [!super.one()!];
}
```

#### Correções comuns

Altere a invocação super para invocar um construtor generativo:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : super.two();
}
```

Se o construtor generativo for o construtor não nomeado, e se não houver
argumentos sendo passados para ele, então você pode remover a invocação
super.

### non_generative_implicit_constructor {:#non_generative_implicit_constructor}

_O construtor não nomeado da superclasse '{0}' (chamado pelo construtor padrão
de '{1}') deve ser um construtor generativo, mas um factory foi encontrado._

#### Descrição

O analisador produz este diagnóstico quando uma classe tem um construtor
generativo implícito e a superclasse tem um construtor factory não nomeado
explícito. O construtor implícito na subclasse invoca implicitamente o
construtor não nomeado na superclasse, mas construtores generativos só
podem invocar outro construtor generativo, não um construtor factory.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor implícito
em `B` invoca o construtor não nomeado em `A`, mas o construtor em `A`
é um construtor factory, quando um construtor generativo é requerido:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class [!B!] extends A {}
```

#### Correções comuns

Se o construtor não nomeado na superclasse pode ser um construtor
generativo, então altere-o para ser um construtor generativo:

```dart
class A {
  A();
  A.named();
}

class B extends A { }
```

Se o construtor não nomeado não pode ser um construtor generativo e existem
outros construtores generativos na superclasse, então invoque
explicitamente um deles:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class B extends A {
  B() : super.named();
}
```

Se não houver construtores generativos que podem ser usados e nenhum pode
ser adicionado, então implemente a superclasse em vez de estendê-la:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class B implements A {}
```

### non_native_function_type_argument_to_pointer {:#non-native-function-type-argument-to-pointer}

_Não é possível invocar 'asFunction' porque a assinatura da função '{0}' para o ponteiro
não é uma assinatura de função C válida._

#### Descrição

O analisador produz este diagnóstico quando o método `asFunction` é
invocado em um ponteiro para uma função nativa, mas a assinatura da função
nativa não é uma assinatura de função C válida.

Para mais informações sobre FFI, veja [Interoperabilidade com C usando dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque a assinatura da função
associada ao ponteiro `p` (`FNative`) não é uma assinatura de função C
válida:

```dart
import 'dart:ffi';

typedef FNative = int Function(int);
typedef F = int Function(int);

class C {
  void f(Pointer<NativeFunction<FNative>> p) {
    p.asFunction<[!F!]>();
  }
}
```

#### Correções comuns

Faça com que a assinatura `NativeFunction` seja uma assinatura C válida:

```dart
import 'dart:ffi';

typedef FNative = Int8 Function(Int8);
typedef F = int Function(int);

class C {
  void f(Pointer<NativeFunction<FNative>> p) {
    p.asFunction<F>();
  }
}
```

### non_positive_array_dimension {:#non-positive-array-dimension}

_As dimensões do array devem ser números positivos._

#### Descrição

O analisador produz esse diagnóstico quando uma dimensão fornecida em uma anotação `Array` é menor ou igual a zero (`0`).

Para mais informações sobre FFI (Foreign Function Interface), veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz esse diagnóstico porque uma dimensão de array de `-8`
foi fornecida:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array([!-8!])
  external Array<Uint8> a0;
}
```

#### Correções comuns

Altere a dimensão para ser um inteiro positivo:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

Se este for um array (matriz) inline de comprimento variável, altere a anotação
para `Array.variable()`:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variable()
  external Array<Uint8> a0;
}
```

### non_sized_type_argument {:#non_sized_type_argument}

_O tipo '{1}' não é um argumento de tipo válido para '{0}'. O argumento de tipo deve ser
um inteiro nativo, 'Float', 'Double', 'Pointer', ou subtipo de 'Struct', 'Union', ou 'AbiSpecificInteger'._

#### Descrição

O analisador produz esse diagnóstico quando o argumento de tipo para a classe
`Array` não é um dos tipos válidos: um inteiro nativo, `Float`,
`Double`, `Pointer`, ou subtipo de `Struct`, `Union`, ou
`AbiSpecificInteger`.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz esse diagnóstico porque o argumento de tipo para
`Array` é `Void`, e `Void` não é um dos tipos válidos:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<[!Void!]> a0;
}
```

#### Correções comuns

Altere o argumento de tipo para um dos tipos válidos:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

### non_sync_factory {:#non_sync_factory}

_Corpos de factory (fábrica) não podem usar 'async', 'async*', ou 'sync*'._

#### Descrição

O analisador produz esse diagnóstico quando o corpo de um construtor
factory é marcado com `async`, `async*`, ou `sync*`. Todos os construtores,
incluindo construtores factory, são obrigados a retornar uma instância da
classe na qual são declarados, não um `Future`, `Stream`, ou `Iterator`.

#### Exemplo

O código a seguir produz esse diagnóstico porque o corpo do construtor
factory é marcado com `async`:

```dart
class C {
  factory C() [!async!] {
    return C._();
  }
  C._();
}
```

#### Correções comuns

Se o membro deve ser declarado como um construtor factory, remova a
palavra-chave que aparece antes do corpo:

```dart
class C {
  factory C() {
    return C._();
  }
  C._();
}
```

Se o membro deve retornar algo diferente de uma instância da classe
envolvente, então faça do membro um método estático:

```dart
class C {
  static Future<C> m() async {
    return C._();
  }
  C._();
}
```

### non_type_as_type_argument {:#non_type_as_type_argument}

_O nome '{0}' não é um tipo, portanto não pode ser usado como um argumento de tipo._

#### Descrição

O analisador produz esse diagnóstico quando um identificador que não é um tipo
é usado como um argumento de tipo.

#### Exemplo

O código a seguir produz esse diagnóstico porque `x` é uma variável, não
um tipo:

```dart
var x = 0;
List<[!x!]> xList = [];
```

#### Correções comuns

Altere o argumento de tipo para ser um tipo:

```dart
var x = 0;
List<int> xList = [];
```

### non_type_in_catch_clause {:#non_type_in_catch_clause}

_O nome '{0}' não é um tipo e não pode ser usado em uma cláusula on-catch._

#### Descrição

O analisador produz esse diagnóstico quando o identificador que segue o
`on` em uma cláusula `catch` é definido para ser algo diferente de um tipo.

#### Exemplo

O código a seguir produz esse diagnóstico porque `f` é uma função, não
um tipo:

```dart
void f() {
  try {
    // ...
  } on [!f!] {
    // ...
  }
}
```

#### Correções comuns

Altere o nome para o tipo de objeto que deve ser capturado:

```dart
void f() {
  try {
    // ...
  } on FormatException {
    // ...
  }
}
```

### non_void_return_for_operator {:#non_void_return_for_operator}

_O tipo de retorno do operador []= deve ser 'void'._

#### Descrição

O analisador produz esse diagnóstico quando uma declaração do operador
`[]=` tem um tipo de retorno diferente de `void`.

#### Exemplo

O código a seguir produz esse diagnóstico porque a declaração do
operador `[]=` tem um tipo de retorno de `int`:

```dart
class C {
  [!int!] operator []=(int index, int value) => 0;
}
```

#### Correções comuns

Altere o tipo de retorno para `void`:

```dart
class C {
  void operator []=(int index, int value) => 0;
}
```

### non_void_return_for_setter {:#non_void_return_for_setter}

_O tipo de retorno do setter deve ser 'void' ou ausente._

#### Descrição

O analisador produz esse diagnóstico quando um setter é definido com um
tipo de retorno diferente de `void`.

#### Exemplo

O código a seguir produz esse diagnóstico porque o setter `p` tem um
tipo de retorno de `int`:

```dart
class C {
  [!int!] set p(int i) => 0;
}
```

#### Correções comuns

Altere o tipo de retorno para `void` ou omita o tipo de retorno:

```dart
class C {
  set p(int i) => 0;
}
```

### not_assigned_potentially_non_nullable_local_variable {:#not_assigned_potentially_non_nullable_local_variable}

_A variável local não anulável '{0}' deve ser atribuída antes que possa ser usada._

#### Descrição

O analisador produz esse diagnóstico quando uma variável local é referenciada
e tem todas estas características:
- Tem um tipo que é [potencialmente não anulável][potencialmente não anulável].
- Não tem um inicializador.
- Não é marcada como `late` (tardia).
- O analisador não pode provar que a variável local será atribuída antes
  da referência com base na especificação de [atribuição definida][atribuição definitiva].

#### Exemplos

O código a seguir produz esse diagnóstico porque `x` não pode ter um valor
de `null`, mas é referenciado antes que um valor seja atribuído a ele:

```dart
String f() {
  int x;
  return [!x!].toString();
}
```

O código a seguir produz esse diagnóstico porque a atribuição para `x`
pode não ser executada, então pode ter um valor de `null`:

```dart
int g(bool b) {
  int x;
  if (b) {
    x = 1;
  }
  return [!x!] * 2;
}
```

O código a seguir produz esse diagnóstico porque o analisador não pode
provar, com base na análise de atribuição definida, que `x` não será referenciado
sem ter um valor atribuído a ele:

```dart
int h(bool b) {
  int x;
  if (b) {
    x = 1;
  }
  if (b) {
    return [!x!] * 2;
  }
  return 0;
}
```

#### Correções comuns

Se `null` for um valor válido, torne a variável anulável:

```dart
String f() {
  int? x;
  return x!.toString();
}
```

Se `null` não for um valor válido e houver um valor padrão razoável, então
adicione um inicializador:

```dart
int g(bool b) {
  int x = 2;
  if (b) {
    x = 1;
  }
  return x * 2;
}
```

Caso contrário, certifique-se de que um valor foi atribuído em todos os possíveis caminhos de código
antes que o valor seja acessado:

```dart
int g(bool b) {
  int x;
  if (b) {
    x = 1;
  } else {
    x = 2;
  }
  return x * 2;
}
```

Você também pode marcar a variável como `late`, o que remove o diagnóstico, mas
se a variável não receber um valor antes de ser acessada, isso
resultará em uma exceção sendo lançada em tempo de execução. Essa abordagem deve ser usada apenas
se você tiver certeza de que a variável sempre será atribuída, mesmo
que o analisador não possa provar isso com base na análise de atribuição definida.

```dart
int h(bool b) {
  late int x;
  if (b) {
    x = 1;
  }
  if (b) {
    return x * 2;
  }
  return 0;
}
```

### not_a_type {:#not_a_type}

_{0} não é um tipo._

#### Descrição

O analisador produz esse diagnóstico quando um nome é usado como um tipo, mas
declarado para ser algo diferente de um tipo.

#### Exemplo

O código a seguir produz esse diagnóstico porque `f` é uma função:

```dart
f() {}
g([!f!] v) {}
```

#### Correções comuns

Substitua o nome pelo nome de um tipo.

### not_binary_operator {:#not_binary_operator}

_'{0}' não é um operador binário._

#### Descrição

O analisador produz esse diagnóstico quando um operador que só pode ser
usado como um operador unário é usado como um operador binário.

#### Exemplo

O código a seguir produz esse diagnóstico porque o operador `~` pode
ser usado apenas como um operador unário:

```dart
var a = 5 [!~!] 3;
```

#### Correções comuns

Substitua o operador pelo operador binário correto:

```dart
var a = 5 - 3;
```

### not_enough_positional_arguments {:#not_enough_positional_arguments}

_1 argumento posicional esperado por '{0}', mas 0 encontrado._

_1 argumento posicional esperado, mas 0 encontrado._

_{0} argumentos posicionais esperados por '{2}', mas {1} encontrados._

_{0} argumentos posicionais esperados, mas {1} encontrados._

#### Descrição

O analisador produz esse diagnóstico quando uma invocação de método ou função
tem menos argumentos posicionais do que o número de parâmetros posicionais
obrigatórios.

#### Exemplo

O código a seguir produz esse diagnóstico porque `f` declara dois
parâmetros obrigatórios, mas apenas um argumento é fornecido:

```dart
void f(int a, int b) {}
void g() {
  f(0[!)!];
}
```

#### Correções comuns

Adicione argumentos correspondentes aos parâmetros restantes:

```dart
void f(int a, int b) {}
void g() {
  f(0, 1);
}
```

### not_initialized_non_nullable_instance_field {:#not_initialized_non_nullable_instance_field}

_O campo de instância não anulável '{0}' deve ser inicializado._

#### Descrição

O analisador produz esse diagnóstico quando um campo é declarado e tem todos
estas características:
- Tem um tipo que é [potencialmente não anulável][potencialmente não anulável]
- Não tem um inicializador
- Não é marcado como `late` (tardio)

#### Exemplos

O código a seguir produz esse diagnóstico porque `x` é implicitamente
inicializado como `null` quando não é permitido ser `null`:

```dart
class C {
  int [!x!];
}
```

Da mesma forma, o código a seguir produz esse diagnóstico porque `x` é
implicitamente inicializado como `null`, quando não é permitido ser `null`, por
um dos construtores, mesmo que seja inicializado por outros
construtores:

```dart
class C {
  int x;

  C(this.x);

  [!C!].n();
}
```

#### Correções comuns

Se houver um valor padrão razoável para o campo que seja o mesmo para todos
as instâncias, adicione uma expressão inicializadora:

```dart
class C {
  int x = 0;
}
```

Se o valor do campo deve ser fornecido quando uma instância é criada,
adicione um construtor que defina o valor do campo ou atualize um
construtor existente:

```dart
class C {
  int x;

  C(this.x);
}
```

Você também pode marcar o campo como `late`, o que remove o diagnóstico, mas se
o campo não receber um valor antes de ser acessado, isso resultará em
uma exceção sendo lançada em tempo de execução. Essa abordagem só deve ser usada se
você tiver certeza de que o campo sempre será atribuído antes de ser referenciado.

```dart
class C {
  late int x;
}
```

### not_initialized_non_nullable_variable {:#not_initialized_non_nullable_variable}

_A variável não anulável '{0}' deve ser inicializada._

#### Descrição

O analisador produz esse diagnóstico quando um campo estático ou uma variável de nível superior
tem um tipo que não é anulável e não tem um inicializador.
Campos e variáveis que não têm um inicializador são normalmente
inicializados como `null`, mas o tipo do campo ou variável não permite
que ele seja definido como `null`, então um inicializador explícito deve ser fornecido.

#### Exemplos

O código a seguir produz esse diagnóstico porque o campo `f` não pode ser
inicializado como `null`:

```dart
class C {
  static int [!f!];
}
```

Da mesma forma, o código a seguir produz esse diagnóstico porque o
variável de nível superior `v` não pode ser inicializada como `null`:

```dart
int [!v!];
```

#### Correções comuns

Se o campo ou variável não puder ser inicializado como `null`, adicione um
inicializador que o define como um valor não nulo:

```dart
class C {
  static int f = 0;
}
```

Se o campo ou variável deve ser inicializado como `null`, altere o
tipo para ser anulável:

```dart
int? v;
```

Se o campo ou variável não puder ser inicializado na declaração, mas sempre
será inicializado antes de ser referenciado, então marque-o como sendo `late` (tardio):

```dart
class C {
  static late int f;
}
```

### not_iterable_spread {:#not_iterable_spread}

_Elementos spread em literais de lista ou conjunto devem implementar 'Iterable'._

#### Descrição

O analisador produz esse diagnóstico quando o tipo estático da
expressão de um elemento spread que aparece em um literal de lista ou um
literal de conjunto não implementa o tipo `Iterable`.

#### Exemplo

O código a seguir produz esse diagnóstico:

```dart
var m = <String, int>{'a': 0, 'b': 1};
var s = <String>{...[!m!]};
```

#### Correções comuns

A correção mais comum é substituir a expressão por uma que produza um
objeto iterável:

```dart
var m = <String, int>{'a': 0, 'b': 1};
var s = <String>{...m.keys};
```

### not_map_spread {:#not_map_spread}

_Elementos spread em literais de mapa devem implementar 'Map'._

#### Descrição

O analisador produz esse diagnóstico quando o tipo estático da
expressão de um elemento spread que aparece em um literal de mapa não
implementa o tipo `Map`.

#### Exemplo

O código a seguir produz esse diagnóstico porque `l` não é um `Map`:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...[!l!]};
```

#### Correções comuns

A correção mais comum é substituir a expressão por uma que produza um
mapa:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...l.asMap()};
```

### no_annotation_constructor_arguments {:#no_annotation_constructor_arguments}

_A criação de anotação deve ter argumentos._

#### Descrição

O analisador produz esse diagnóstico quando uma anotação consiste em um
único identificador, mas esse identificador é o nome de uma classe em vez de um
variável. Para criar uma instância da classe, o identificador deve ser
seguido por uma lista de argumentos.

#### Exemplo

O código a seguir produz esse diagnóstico porque `C` é uma classe, e um
classe não pode ser usada como uma anotação sem invocar um construtor `const`
da classe:

```dart
class C {
  const C();
}

[!@C!]
var x;
```

#### Correções comuns

Adicione a lista de argumentos ausente:

```dart
class C {
  const C();
}

@C()
var x;
```

### no_combined_super_signature {:#no-combined-super_signature}

_Não é possível inferir os tipos ausentes em '{0}' de métodos substituídos: {1}._

#### Descrição

O analisador produz esse diagnóstico quando há uma declaração de método
para o qual um ou mais tipos precisam ser inferidos, e esses tipos não podem ser
inferidos porque nenhum dos métodos substituídos tem um tipo de função que é
um supertipo de todos os outros métodos substituídos, conforme especificado por
[inferência de sobrescrita][inferência de override].

#### Exemplo

O código a seguir produz esse diagnóstico porque o método `m` declarado
na classe `C` está faltando tanto o tipo de retorno quanto o tipo do
parâmetro `a`, e nenhum dos tipos ausentes pode ser inferido para ele:

```dart
abstract class A {
  A m(String a);
}

abstract class B {
  B m(int a);
}

abstract class C implements A, B {
  [!m!](a);
}
```

Neste exemplo, a inferência de sobrescrita não pode ser realizada porque
os métodos sobrescritos são incompatíveis destas formas:
- Nenhum tipo de parâmetro (`String` e `int`) é um supertipo do outro.
- Nenhum tipo de retorno é um subtipo do outro.

#### Correções comuns

Se possível, adicione tipos ao método na subclasse que sejam consistentes
com os tipos de todos os métodos substituídos:

```dart
abstract class A {
  A m(String a);
}

abstract class B {
  B m(int a);
}

abstract class C implements A, B {
  C m(Object a);
}
```

### no_generative_constructors_in_superclass {:#no_generative_constructors_in_superclass}

_A classe '{0}' não pode estender '{1}' porque '{1}' tem apenas construtores factory
(sem construtores generativos), e '{0}' tem pelo menos um construtor generativo._

#### Descrição

O analisador produz esse diagnóstico quando uma classe que tem pelo menos um
construtor generativo (explícito ou implícito) tem uma superclasse
que não tem nenhum construtor generativo. Cada generativo
construtor, exceto o definido em `Object`, invoca, ou
explicitamente ou implicitamente, um dos construtores generativos de seu
superclasse.

#### Exemplo

O código a seguir produz esse diagnóstico porque a classe `B` tem um
construtor generativo implícito que não pode invocar um construtor generativo
de `A` porque `A` não tem nenhum construtor generativo:

```dart
class A {
  factory A.none() => throw '';
}

class B extends [!A!] {}
```

#### Correções comuns

Se a superclasse deve ter um construtor generativo, adicione um:

```dart
class A {
  A();
  factory A.none() => throw '';
}

class B extends A {}
```

Se a subclasse não deve ter um construtor generativo, remova-o
adicionando um construtor factory:

```dart
class A {
  factory A.none() => throw '';
}

class B extends A {
  factory B.none() => throw '';
}
```

Se a subclasse deve ter um construtor generativo, mas a superclasse
não pode ter um, implemente a superclasse em vez disso:

```dart
class A {
  factory A.none() => throw '';
}

class B implements A {}
```

### nullable_type_in_catch_clause {:#nullable_type_in_catch_clause}

_Um tipo potencialmente anulável não pode ser usado em uma cláusula 'on' porque não é
válido lançar uma expressão anulável._

#### Descrição

O analisador produz esse diagnóstico quando o tipo que segue `on` em um
cláusula `catch` é um tipo anulável. Não é válido especificar um anulável
tipo porque não é possível capturar `null` (porque é um tempo de execução
erro para lançar `null`).

#### Exemplo

O código a seguir produz esse diagnóstico porque o tipo de exceção é
especificado para permitir `null` quando `null` não pode ser lançado:

```dart
void f() {
  try {
    // ...
  } on [!FormatException?!] {
  }
}
```

#### Correções comuns

Remova o ponto de interrogação do tipo:

```dart
void f() {
  try {
    // ...
  } on FormatException {
  }
}
```

### nullable_type_in_extends_clause {:#nullable_type_in_extends_clause}

_Uma classe não pode estender um tipo anulável._

#### Descrição

O analisador produz esse diagnóstico quando uma declaração de classe usa uma
cláusula `extends` para especificar uma superclasse, e a superclasse é seguida por
um `?`.

Não é válido especificar uma superclasse anulável porque fazer isso não teria
nenhum significado; não mudaria a interface ou implementação sendo
herdado pela classe que contém a cláusula `extends`.

Observe, no entanto, que _é_ válido usar um tipo anulável como um argumento de tipo
para a superclasse, como `class A extends B<C?> {}`.

#### Exemplo

O código a seguir produz esse diagnóstico porque `A?` é um anulável
tipo, e tipos anuláveis não podem ser usados em uma cláusula `extends`:

```dart
class A {}
class B extends [!A?!] {}
```

#### Correções comuns

Remova o ponto de interrogação do tipo:

```dart
class A {}
class B extends A {}
```

### nullable_type_in_implements_clause {:#nullable_type_in_implements_clause}

_Uma classe, mixin ou tipo de extensão não pode implementar um tipo anulável._

#### Descrição

O analisador produz esse diagnóstico quando uma classe, mixin ou
declaração de tipo de extensão tem uma cláusula `implements`, e uma
interface é seguida por um `?`.

Não é válido especificar uma interface anulável porque fazer isso não teria
nenhum significado; não mudaria a interface que está sendo herdada pela classe
contendo a cláusula `implements`.

Observe, no entanto, que _é_ válido usar um tipo anulável como um argumento de tipo
para a interface, como `class A implements B<C?> {}`.


#### Exemplo

O código a seguir produz esse diagnóstico porque `A?` é um tipo anulável
tipo, e tipos anuláveis não podem ser usados em uma cláusula `implements`:

```dart
class A {}
class B implements [!A?!] {}
```

#### Correções comuns

Remova o ponto de interrogação do tipo:

```dart
class A {}
class B implements A {}
```

### nullable_type_in_on_clause {:#nullable_type_in_on_clause}

_Um mixin não pode ter um tipo anulável como uma restrição de superclasse._

#### Descrição

O analisador produz esse diagnóstico quando uma declaração de mixin usa um `on`
cláusula para especificar uma restrição de superclasse, e a classe que é especificada
é seguido por um `?`.

Não é válido especificar uma restrição de superclasse anulável porque fazer isso
não teria nenhum significado; não mudaria a interface da qual se depende
pelo mixin contendo a cláusula `on`.

Observe, no entanto, que _é_ válido usar um tipo anulável como um argumento de tipo
para a restrição de superclasse, como `mixin A on B<C?> {}`.


#### Exemplo

O código a seguir produz esse diagnóstico porque `A?` é um tipo anulável
e tipos anuláveis não podem ser usados em uma cláusula `on`:

```dart
class C {}
mixin M on [!C?!] {}
```

#### Correções comuns

Remova o ponto de interrogação do tipo:

```dart
class C {}
mixin M on C {}
```

### nullable_type_in_with_clause {:#nullable_type_in_with_clause}

_Uma classe ou mixin não pode misturar um tipo anulável._

#### Descrição

O analisador produz esse diagnóstico quando uma declaração de classe ou mixin tem
uma cláusula `with`, e um mixin é seguido por um `?`.

Não é válido especificar um mixin anulável porque fazer isso não teria
nenhum significado; não mudaria a interface ou implementação sendo
herdado pela classe que contém a cláusula `with`.

Observe, no entanto, que _é_ válido usar um tipo anulável como um argumento de tipo
para o mixin, como `class A with B<C?> {}`.

#### Exemplo

O código a seguir produz esse diagnóstico porque `A?` é um anulável
tipo, e tipos anuláveis não podem ser usados em uma cláusula `with`:

```dart
mixin M {}
class C with [!M?!] {}
```

#### Correções comuns

Remova o ponto de interrogação do tipo:

```dart
mixin M {}
class C with M {}
```

### null_argument_to_non_null_type {:#null_argument_to_non_null_type}

_'{0}' não deve ser chamado com um argumento 'null' para o tipo não anulável
argumento '{1}'._

#### Descrição

O analisador produz esse diagnóstico quando `null` é passado para o
construtor `Future.value` ou o método `Completer.complete` quando o tipo
argumento usado para criar a instância não era anulável. Embora o tipo
sistema não pode expressar essa restrição, passar um `null` resulta em um
exceção em tempo de execução.

#### Exemplo

O código a seguir produz esse diagnóstico porque `null` está sendo passado
para o construtor `Future.value`, mesmo que o argumento de tipo seja o
tipo não anulável `String`:

```dart
Future<String> f() {
  return Future.value([!null!]);
}
```

#### Correções comuns

Passe um valor não nulo:

```dart
Future<String> f() {
  return Future.value('');
}
```

### null_check_always_fails {:#null_check_always_fails}

_Esta verificação de nulo sempre lançará uma exceção porque a expressão sempre
avaliará para 'null'._

#### Descrição

O analisador produz esse diagnóstico quando o operador de verificação nula (`!`)
é usado em uma expressão cujo valor só pode ser `null`. Em tal caso
o operador sempre lança uma exceção, o que provavelmente não é o pretendido
comportamento.

#### Exemplo

O código a seguir produz esse diagnóstico porque a função `g` sempre
retornará `null`, o que significa que a verificação nula em `f` sempre
lançará:

```dart
void f() {
  [!g()!!];
}

Null g() => null;
```

#### Correções comuns

Se você pretende sempre lançar uma exceção, substitua a verificação nula
com uma expressão `throw` explícita para deixar a intenção mais clara:

```dart
void f() {
  g();
  throw TypeError();
}

Null g() => null;
```

### obsolete_colon_for_default_value {:#obsolete_colon_for_default_value}

_Usar dois pontos como separador antes de um valor padrão não é mais suportado._

#### Descrição

O analisador produz esse diagnóstico quando dois pontos (`:`) são usados como o
separador antes do valor padrão de um parâmetro nomeado opcional.
Embora essa sintaxe fosse permitida, ela foi removida em favor de
usando um sinal de igual (`=`).

#### Exemplo

O código a seguir produz esse diagnóstico porque dois pontos estão sendo usados
antes do valor padrão do parâmetro opcional `i`:

```dart
void f({int i [!:!] 0}) {}
```

#### Correções comuns

Substitua os dois pontos por um sinal de igual:

```dart
void f({int i = 0}) {}
```

### on_repeated {:#on_repeated}

_O tipo '{0}' pode ser incluído nas restrições de superclasse apenas uma vez._

#### Descrição

O analisador produz esse diagnóstico quando o mesmo tipo é listado em
as restrições de superclasse de um mixin várias vezes.

#### Exemplo

O código a seguir produz esse diagnóstico porque `A` está incluído duas vezes
nas restrições de superclasse para `M`:

```dart
mixin M on A, [!A!] {
}

class A {}
class B {}
```

#### Correções comuns

Se um tipo diferente deve ser incluído nas restrições de superclasse, então
substitua uma das ocorrências pelo outro tipo:

```dart
mixin M on A, B {
}

class A {}
class B {}
```

Se nenhum outro tipo foi pretendido, remova o nome do tipo repetido:

```dart
mixin M on A {
}

class A {}
class B {}
```

### optional_parameter_in_operator {:#optional_parameter_in_operator}

_Parâmetros opcionais não são permitidos ao definir um operador._

#### Descrição

O analisador produz esse diagnóstico quando um ou mais dos parâmetros em
uma declaração de operador são opcionais.

#### Exemplo

O código a seguir produz esse diagnóstico porque o parâmetro `other`
é um parâmetro opcional:

```dart
class C {
  C operator +([[!C? other!]]) => this;
}
```

#### Correções comuns

Faça com que todos os parâmetros sejam parâmetros obrigatórios:

```dart
class C {
  C operator +(C other) => this;
}
```

### override_on_non_overriding_member {:#override_on_non_overriding_member}

_O campo não substitui um getter ou setter herdado._

_O getter não substitui um getter herdado._

_O método não substitui um método herdado._

_O setter não substitui um setter herdado._

#### Descrição

O analisador produz esse diagnóstico quando um membro de classe é anotado com
a anotação `@override`, mas o membro não é declarado em nenhuma das
supertipos da classe.

#### Exemplo

O código a seguir produz esse diagnóstico porque `m` não é declarado em
nenhum dos supertipos de `C`:

```dart
class C {
  @override
  String [!m!]() => '';
}
```

#### Correções comuns

Se o membro se destina a substituir um membro com um nome diferente,
atualize o membro para ter o mesmo nome:

```dart
class C {
  @override
  String toString() => '';
}
```

Se o membro se destina a substituir um membro que foi removido do
superclasse, considere remover o membro da subclasse.

Se o membro não puder ser removido, remova a anotação.

### packed_annotation {:#packed_annotation}

_Structs (estruturas) devem ter no máximo uma anotação 'Packed'._

#### Descrição

O analisador produz esse diagnóstico quando uma subclasse de `Struct` tem mais
de uma anotação `Packed`.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz esse diagnóstico porque a classe `C`, que
é uma subclasse de `Struct`, tem duas anotações `Packed`:

```dart
import 'dart:ffi';

@Packed(1)
[!@Packed(1)!]
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

#### Correções comuns

Remova todas, exceto uma, das anotações:

```dart
import 'dart:ffi';

@Packed(1)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

### packed_annotation_alignment {:#packed_annotation_alignment}

_Apenas o empacotamento para 1, 2, 4, 8 e 16 bytes é suportado._

#### Descrição

O analisador produz esse diagnóstico quando o argumento para o `Packed`
anotação não é um dos valores permitidos: 1, 2, 4, 8 ou 16.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz esse diagnóstico porque o argumento para o
anotação `Packed` (`3`) não é um dos valores permitidos:

```dart
import 'dart:ffi';

@Packed([!3!])
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

#### Correções comuns

Altere o alinhamento para ser um dos valores permitidos:

```dart
import 'dart:ffi';

@Packed(4)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

### part_of_different_library {:#part_of_different_library}

_Esperava-se que esta biblioteca fizesse parte de '{0}', não de '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca tenta incluir um
arquivo como parte de si mesma, quando o outro arquivo faz parte de uma
biblioteca diferente.

#### Exemplo

Dado um arquivo `part.dart` contendo

```dart
part of 'library.dart';
```

O código a seguir, em qualquer arquivo diferente de `library.dart`, produz
este diagnóstico porque tenta incluir `part.dart` como parte de si mesmo
quando `part.dart` faz parte de uma biblioteca diferente:

```dart
part [!'package:a/part.dart'!];
```

#### Correções comuns

Se a biblioteca deve usar um arquivo diferente como parte, então altere o
URI na diretiva part para ser o URI do outro arquivo.

Se o [arquivo part][arquivo part] deve ser uma parte desta biblioteca, então atualize o
URI (ou nome da biblioteca) na diretiva part-of para ser o URI (ou nome) da
biblioteca correta.

### part_of_non_part {:#part_of_non_part}

_A parte incluída '{0}' deve ter uma diretiva part-of._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva part é encontrada e
o arquivo referenciado não tem uma diretiva part-of.

#### Exemplo

Dado um arquivo `a.dart` contendo:

```dart
class A {}
```

O código a seguir produz este diagnóstico porque `a.dart` não
contém uma diretiva part-of:

```dart
part [!'a.dart'!];
```

#### Correções comuns

Se o arquivo referenciado se destina a ser parte de outra biblioteca, então
adicione uma diretiva part-of ao arquivo:

```dart
part of 'test.dart';

class A {}
```

Se o arquivo referenciado se destina a ser uma biblioteca, então substitua
a diretiva part por uma diretiva import:

```dart
import 'a.dart';
```

### part_of_unnamed_library {:#part_of_unnamed_library}

_A biblioteca não tem nome. Espera-se um URI, não um nome de biblioteca '{0}', na
diretiva part-of._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca que não tem uma
diretiva `library` (e, portanto, não tem nome) contém uma diretiva `part` e
a diretiva `part of` no [arquivo part][arquivo part] usa um nome para especificar
a biblioteca da qual faz parte.

#### Exemplo

Dado um [arquivo part][arquivo part] chamado `part_file.dart` contendo o seguinte
código:

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque a biblioteca que inclui
o [arquivo part][arquivo part] não tem um nome, mesmo que o [arquivo part][arquivo part] use um
nome para especificar de qual biblioteca faz parte:

```dart
part [!'part_file.dart'!];
```

#### Correções comuns

Altere a diretiva `part of` no [arquivo part][arquivo part] para especificar sua biblioteca
por URI:

```dart
part of 'test.dart';
```

### path_does_not_exist {:#path_does_not_exist}

_O caminho '{0}' não existe._

#### Descrição

O analisador produz este diagnóstico quando uma dependência tem uma chave
`path` que referencia um diretório que não existe.

#### Exemplo

Supondo que o diretório `doesNotExist` não exista, o seguinte código
produz este diagnóstico porque ele está listado como o caminho de um pacote:

```yaml
name: example
dependencies:
  local_package:
    path: [!doesNotExist!]
```

#### Correções comuns

Se o caminho estiver correto, crie um diretório nesse caminho.

Se o caminho não estiver correto, altere o caminho para corresponder ao
caminho para a raiz do pacote.

### path_not_posix {:#path_not_posix}

_O caminho '{0}' não é um caminho no estilo POSIX._

#### Descrição

O analisador produz este diagnóstico quando uma dependência tem uma chave
`path` cujo valor é uma string, mas não é um caminho no estilo POSIX.

#### Exemplo

O código a seguir produz este diagnóstico porque o caminho após a
chave `path` é um caminho do Windows:

```yaml
name: example
dependencies:
  local_package:
    path: [!E:\local_package!]
```

#### Correções comuns

Converta o caminho para um caminho POSIX.

### path_pubspec_does_not_exist {:#path_pubspec_does_not_exist}

_O diretório '{0}' não contém um pubspec._

#### Descrição

O analisador produz este diagnóstico quando uma dependência tem uma chave
`path` que referencia um diretório que não contém um arquivo `pubspec.yaml`.

#### Exemplo

Supondo que o diretório `local_package` não contenha um arquivo
`pubspec.yaml`, o seguinte código produz este diagnóstico porque ele
está listado como o caminho de um pacote:

```yaml
name: example
dependencies:
  local_package:
    path: [!local_package!]
```

#### Correções comuns

Se o caminho se destina a ser a raiz de um pacote, adicione um
arquivo `pubspec.yaml` no diretório:

```yaml
name: local_package
```

Se o caminho estiver errado, substitua-o pelo caminho correto.

### pattern_assignment_not_local_variable {:#pattern_assignment_not_local_variable}

_Apenas variáveis locais podem ser atribuídas em atribuições de pattern (padrão)._

#### Descrição

O analisador produz este diagnóstico quando uma atribuição de pattern
(padrão) atribui um valor a algo que não seja uma variável local. Patterns
(padrões) não podem ser atribuídos a campos ou variáveis de nível superior.

#### Exemplo

Se o código estiver mais limpo ao desestruturar com um pattern (padrão),
reescreva o código para atribuir o valor a uma variável local em uma
declaração de pattern (padrão), atribuindo a variável não local separadamente:

```dart
class C {
  var x = 0;

  void f((int, int) r) {
    ([!x!], _) = r;
  }
}
```

#### Correções comuns

Se o código estiver mais limpo ao usar uma atribuição de pattern (padrão),
reescreva o código para atribuir o valor a uma variável local, atribuindo a
variável não local separadamente:

```dart
class C {
  var x = 0;

  void f((int, int) r) {
    var (a, _) = r;
    x = a;
  }
}
```

Se o código estiver mais limpo sem usar uma atribuição de pattern
(padrão), reescreva o código para não usar uma atribuição de pattern
(padrão):

```dart
class C {
  var x = 0;

  void f((int, int) r) {
    x = r.$1;
  }
}
```

### pattern_constant_from_deferred_library {:#pattern_constant_from_deferred_library}

_Valores constantes de uma biblioteca adiada (deferred) não podem ser usados em patterns (padrões)._

#### Descrição

O analisador produz este diagnóstico quando um pattern (padrão) contém um
valor declarado em uma biblioteca diferente, e essa biblioteca é importada
usando uma importação adiada (deferred). Constantes são avaliadas em tempo
de compilação, mas valores de bibliotecas adiadas (deferred) não estão
disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca de forma Lazy](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque o pattern (padrão) constante
`a.zero` é importado usando uma importação adiada (deferred):

```dart
import 'a.dart' deferred as a;

void f(int x) {
  switch (x) {
    case a.[!zero!]:
      // ...
      break;
  }
}
```

#### Correções comuns

Se você precisar referenciar a constante da biblioteca importada, remova a
palavra-chave `deferred`:

```dart
import 'a.dart' as a;

void f(int x) {
  switch (x) {
    case a.zero:
      // ...
      break;
  }
}
```

Se você precisar referenciar a constante da biblioteca importada e também
precisar que a biblioteca importada seja adiada (deferred), reescreva o
comando switch como uma sequência de comandos `if`:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  if (x == a.zero) {
    // ...
  }
}
```

Se você não precisar referenciar a constante, substitua a expressão do caso:

```dart
void f(int x) {
  switch (x) {
    case 0:
      // ...
      break;
  }
}
```

### pattern_type_mismatch_in_irrefutable_context {:#pattern_type_mismatch_in_irrefutable_context}

_O valor correspondente do tipo '{0}' não é atribuível ao tipo obrigatório '{1}'._

#### Descrição

O analisador produz este diagnóstico quando o tipo do valor no lado direito
de uma atribuição de pattern (padrão) ou declaração de pattern (padrão) não
corresponde ao tipo exigido pelo pattern (padrão) usado para combiná-lo.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` pode não ser uma
`String` e, portanto, pode não corresponder ao pattern (padrão) de objeto:

```dart
void f(Object x) {
  var [!String(length: a)!] = x;
  print(a);
}
```

#### Correções comuns

Altere o código para que o tipo da expressão no lado direito
corresponda ao tipo exigido pelo pattern (padrão):

```dart
void f(String x) {
  var String(length: a) = x;
  print(a);
}
```

### pattern_variable_assignment_inside_guard {:#pattern_variable_assignment_inside_guard}

_Variáveis de pattern (padrão) não podem ser atribuídas dentro da guarda do pattern (padrão) protegido envolvente._

#### Descrição

O analisador produz este diagnóstico quando uma variável de pattern
(padrão) recebe um valor dentro de uma cláusula de guarda (`when`).

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `a` recebe
um valor dentro da cláusula de guarda:

```dart
void f(int x) {
  if (x case var a when ([!a!] = 1) > 0) {
    print(a);
  }
}
```

#### Correções comuns

Se houver um valor que você precise capturar, atribua-o a uma variável
diferente:

```dart
void f(int x) {
  var b;
  if (x case var a when (b = 1) > 0) {
    print(a + b);
  }
}
```

Se não houver um valor que você precise capturar, remova a atribuição:

```dart
void f(int x) {
  if (x case var a when 1 > 0) {
    print(a);
  }
}
```

### platform_value_disallowed {:#platform_value_disallowed}

_As chaves no campo `platforms` não podem ter valores._

#### Descrição

O analisador produz este diagnóstico quando uma chave no mapa `platforms`
tem um valor.
Para saber mais sobre como especificar as plataformas suportadas do seu pacote,
consulte a [documentação sobre declarações de plataforma](https://dartbrasil.dev/tools/pub/pubspec#platforms).

#### Exemplo

O seguinte `pubspec.yaml` produz este diagnóstico porque a chave `web`
tem um valor.

```yaml
name: example
platforms:
  web: [!"chrome"!]
```

#### Correções comuns

Omita o valor e deixe a chave sem um valor:

```yaml
name: example
platforms:
  web:
```

Valores para chaves no campo `platforms` estão atualmente reservados para
um possível comportamento futuro.

### positional_field_in_object_pattern {:#positional_field_in_object_pattern}

_Patterns (padrões) de objeto só podem usar campos nomeados._

#### Descrição

O analisador produz este diagnóstico quando um pattern (padrão) de objeto
contém um campo sem especificar o nome do getter (acessador). Os campos de
pattern (padrão) de objeto correspondem aos valores que os getters (acessadores) do objeto retornam. Sem um nome de getter (acessador)
especificado, o campo de pattern (padrão) não pode acessar um valor para tentar corresponder.

#### Exemplo

O código a seguir produz este diagnóstico porque o pattern (padrão) de
objeto `String(1)` não especifica qual getter (acessador) de `String`
acessar e comparar com o valor `1`:

```dart
void f(Object o) {
  if (o case String([!1!])) {}
}
```

#### Correções comuns

Adicione o nome do getter (acessador) para acessar o valor, seguido
por dois pontos antes do pattern (padrão) para corresponder:

```dart
void f(Object o) {
  if (o case String(length: 1)) {}
}
```

### positional_super_formal_parameter_with_positional_argument {:#positional_super_formal_parameter_with_positional_argument}

_Parâmetros super posicionais não podem ser usados quando a invocação do construtor super tem um argumento posicional._

#### Descrição

O analisador produz este diagnóstico quando alguns, mas não todos, dos
parâmetros posicionais fornecidos ao construtor da superclasse estão
usando um super parâmetro.

Super parâmetros posicionais são associados a parâmetros posicionais no
construtor super por seu índice. Ou seja, o primeiro super parâmetro
está associado ao primeiro parâmetro posicional no super
construtor, o segundo com o segundo, e assim por diante. O mesmo é
verdade para argumentos posicionais. Ter super parâmetros posicionais e
argumentos posicionais significa que existem dois valores associados ao
mesmo parâmetro no construtor da superclasse, e portanto não é permitido.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor
`B.new` está usando um super parâmetro para passar um dos parâmetros
posicionais necessários para o super construtor em `A`, mas está passando
explicitamente o outro na invocação do super construtor:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(int x, super.[!y!]) : super(x);
}
```

#### Correções comuns

Se todos os parâmetros posicionais podem ser super parâmetros, então converta os parâmetros
posicionais normais para serem super parâmetros:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(super.x, super.y);
}
```

Se alguns parâmetros posicionais não podem ser super parâmetros, então converta os
super parâmetros para serem parâmetros normais:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(int x, int y) : super(x, y);
}
```

### prefix_collides_with_top_level_member {:#prefix_collides_with_top_level_member}

_O nome '{0}' já é usado como um prefixo de importação e não pode ser usado para nomear um elemento de nível superior._

#### Descrição

O analisador produz este diagnóstico quando um nome é usado como um prefixo
de importação e o nome de uma declaração de nível superior na mesma
biblioteca.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` é usado como um
prefixo de importação e o nome de uma função:

```dart
import 'dart:math' as f;

int [!f!]() => f.min(0, 1);
```

#### Correções comuns

Se você quiser usar o nome para o prefixo de importação, renomeie a
declaração de nível superior:

```dart
import 'dart:math' as f;

int g() => f.min(0, 1);
```

Se você quiser usar o nome para a declaração de nível superior, renomeie o
prefixo de importação:

```dart
import 'dart:math' as math;

int f() => math.min(0, 1);
```

### prefix_identifier_not_followed_by_dot {:#prefix_identifier_not_followed_by_dot}

_O nome '{0}' se refere a um prefixo de importação, portanto, deve ser seguido por '.'._

#### Descrição

O analisador produz este diagnóstico quando um prefixo de importação é
usado por si só, sem acessar nenhum dos nomes declarados nas bibliotecas
associadas ao prefixo. Prefixos não são variáveis e, portanto, não podem
ser usados como um valor.

#### Exemplo

O código a seguir produz este diagnóstico porque o prefixo `math` está
sendo usado como se fosse uma variável:

```dart
import 'dart:math' as math;

void f() {
  print([!math!]);
}
```

#### Correções comuns

Se o código estiver incompleto, referencie algo em uma das bibliotecas
associadas ao prefixo:

```dart
import 'dart:math' as math;

void f() {
  print(math.pi);
}
```

Se o nome estiver errado, corrija o nome.

### prefix_shadowed_by_local_declaration {:#prefix_shadowed_by_local_declaration}

_O prefixo '{0}' não pode ser usado aqui porque está obscurecido por uma declaração local._

#### Descrição

O analisador produz este diagnóstico quando um prefixo de importação é usado
em um contexto onde não é visível porque foi obscurecido por uma
declaração local.

#### Exemplo

O código a seguir produz este diagnóstico porque o prefixo `a` está sendo
usado para acessar a classe `Future`, mas não é visível porque está
obscurecido pelo parâmetro `a`:

```dart
import 'dart:async' as a;

a.Future? f(int a) {
  [!a!].Future? x;
  return x;
}
```

#### Correções comuns

Renomeie o prefixo:

```dart
import 'dart:async' as p;

p.Future? f(int a) {
  p.Future? x;
  return x;
}
```

Ou renomeie a variável local:

```dart
import 'dart:async' as a;

a.Future? f(int p) {
  a.Future? x;
  return x;
}
```

### private_collision_in_mixin_application {:#private-collision-in-mixin_application}

_O nome privado '{0}', definido por '{1}', entra em conflito com o mesmo nome definido por '{2}'._

#### Descrição

O analisador produz este diagnóstico quando dois mixins que definem o mesmo
membro privado são usados juntos em uma única classe em uma biblioteca que
não seja aquela que define os mixins.

#### Exemplo

Dado um arquivo `a.dart` contendo o seguinte código:

```dart
mixin A {
  void _foo() {}
}

mixin B {
  void _foo() {}
}
```

O código a seguir produz este diagnóstico porque os mixins `A` e `B`
ambos definem o método `_foo`:

```dart
import 'a.dart';

class C extends Object with A, [!B!] {}
```

#### Correções comuns

Se você não precisar de ambos os mixins, remova um deles da
cláusula `with`:

```dart
import 'a.dart';

class C extends Object with A, [!B!] {}
```

Se você precisar de ambos os mixins, renomeie o membro conflitante em um
dos dois mixins.

### private_optional_parameter {:#private_optional_parameter}

_Parâmetros nomeados não podem começar com um sublinhado._

#### Descrição

O analisador produz este diagnóstico quando o nome de um parâmetro nomeado
começa com um sublinhado.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro nomeado
`_x` começa com um sublinhado:

```dart
class C {
  void m({int [!_x!] = 0}) {}
}
```

#### Correções comuns

Renomeie o parâmetro para que não comece com um sublinhado:

```dart
class C {
  void m({int x = 0}) {}
}
```

### private_setter {:#private_setter}

_O setter '{0}' é privado e não pode ser acessado fora da biblioteca que o declara._

#### Descrição

O analisador produz este diagnóstico quando um setter privado é usado em
uma biblioteca onde não é visível.

#### Exemplo

Dado um arquivo `a.dart` que contém o seguinte:

```dart
class A {
  static int _f = 0;
}
```

O código a seguir produz este diagnóstico porque ele referencia o
setter privado `_f` mesmo que o setter não seja visível:

```dart
import 'a.dart';

void f() {
  A.[!_f!] = 0;
}
```

#### Correções comuns

Se você puder tornar o setter público, então faça isso:

```dart
class A {
  static int f = 0;
}
```

Se você não puder tornar o setter público, então encontre uma maneira
diferente de implementar o código.

### read_potentially_unassigned_final {:#read_potentially_unassigned_final}

_A variável final '{0}' não pode ser lida porque está potencialmente não atribuída neste ponto._

#### Descrição

O analisador produz este diagnóstico quando uma variável local final que
não é inicializada no local da declaração é lida em um ponto onde o
compilador não pode provar que a variável é sempre inicializada antes de
ser referenciada.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável local final
`x` é lida (na linha 3) quando é possível que ela ainda não tenha
sido inicializada:

```dart
int f() {
  final int x;
  return [!x!];
}
```

#### Correções comuns

Certifique-se de que a variável foi inicializada antes de ser lida:

```dart
int f(bool b) {
  final int x;
  if (b) {
    x = 0;
  } else {
    x = 1;
  }
  return x;
}
```

### record_literal_one_positional_no_trailing_comma {:#record_literal_one_positional_no_trailing_comma}

_Um literal de registro com exatamente um campo posicional requer uma vírgula final._

#### Descrição

O analisador produz este diagnóstico quando um literal de registro com um
único campo posicional não tem uma vírgula final após o campo.

Em alguns locais, um literal de registro com um único campo posicional
também pode ser uma expressão entre parênteses. Uma vírgula final é
necessária para desambiguar essas duas interpretações válidas.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal de registro tem
um campo posicional, mas não tem uma vírgula final:

```dart
var r = const (1[!)!];
```

#### Correções comuns

Adicione uma vírgula final:

```dart
var r = const (1,);
```

### record_type_one_positional_no_trailing_comma {:#record_type_one_positional_no_trailing_comma}

_Um tipo de registro com exatamente um campo posicional requer uma vírgula final._

#### Descrição

O analisador produz este diagnóstico quando uma anotação de tipo de
registro com um único campo posicional não tem uma vírgula final após o
campo.

Em alguns locais, um tipo de registro com um único campo posicional
também pode ser uma expressão entre parênteses. Uma vírgula final é
necessária para desambiguar essas duas interpretações válidas.

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo de registro tem
um campo posicional, mas não tem uma vírgula final:

```dart
void f((int[!)!] r) {}
```

#### Correções comuns

Adicione uma vírgula final:

```dart
void f((int,) r) {}
```

### recursive_compile_time_constant {:#recursive_compile_time_constant}

_A expressão constante em tempo de compilação depende de si mesma._

#### Descrição

O analisador produz este diagnóstico quando o valor de uma constante em
tempo de compilação é definido em termos de si mesmo, direta ou
indiretamente, criando um loop infinito.

#### Exemplo

O código a seguir produz este diagnóstico duas vezes porque ambas as
constantes são definidas em termos uma da outra:

```dart
const [!secondsPerHour!] = minutesPerHour * 60;
const [!minutesPerHour!] = secondsPerHour / 60;
```

#### Correções comuns

Quebre o ciclo encontrando uma forma alternativa de definir pelo menos uma
das constantes:

```dart
const secondsPerHour = minutesPerHour * 60;
const minutesPerHour = 60;
```

### recursive_constructor_redirect {:#recursive_constructor_redirect}

_Construtores não podem redirecionar para si mesmos direta ou indiretamente._

#### Descrição

O analisador produz este diagnóstico quando um construtor redireciona para
si mesmo, direta ou indiretamente, criando um loop infinito.

#### Exemplos

O código a seguir produz este diagnóstico porque os construtores
generativos `C.a` e `C.b` cada um redireciona para o outro:

```dart
class C {
  C.a() : [!this.b()!];
  C.b() : [!this.a()!];
}
```

O código a seguir produz este diagnóstico porque os construtores de fábrica
`A` e `B` cada um redireciona para o outro:

```dart
abstract class A {
  factory A() = [!B!];
}
class B implements A {
  factory B() = [!A!];
  B.named();
}
```

#### Correções comuns

No caso de construtores generativos, quebre o ciclo definindo
pelo menos um dos construtores para não redirecionar para outro construtor:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

No caso de construtores de fábrica, quebre o ciclo definindo pelo menos
um dos construtores de fábrica para fazer uma das seguintes ações:

- Redirecione para um construtor generativo:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  factory B() = B.named;
  B.named();
}
```

- Não redirecione para outro construtor:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  factory B() {
    return B.named();
  }

  B.named();
}
```

- Não seja um construtor de fábrica:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  B();
  B.named();
}
```

### recursive_interface_inheritance {:#recursive_interface_inheritance}

_'{0}' não pode ser uma superinterface de si mesmo: {1}._

_'{0}' não pode estender a si mesmo._

_'{0}' não pode implementar a si mesmo._

_'{0}' não pode usar a si mesmo como um mixin._

_'{0}' não pode usar a si mesmo como uma restrição de superclasse._

#### Descrição

O analisador produz este diagnóstico quando há uma circularidade na
hierarquia de tipos. Isso acontece quando um tipo, direta ou
indiretamente, é declarado como um subtipo de si mesmo.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `A` é
declarada como um subtipo de `B`, e `B` é um subtipo de `A`:

```dart
class [!A!] extends B {}
class B implements A {}
```

#### Correções comuns

Altere a hierarquia de tipos para que não haja circularidade.

### redeclare_on_non_redeclaring_member {:#redeclare_on_non_redeclaring_member}

_O {0} não redefine um {0} declarado em uma superinterface._

#### Descrição

O analisador produz este diagnóstico quando um membro de um tipo de extensão
é anotado com `@redeclare`, mas nenhuma das interfaces implementadas tem
um membro com o mesmo nome.

#### Exemplo

O código a seguir produz este diagnóstico porque o membro `n`
declarado pelo tipo de extensão `E` é anotado com `@redeclare`, mas `C`
não tem um membro chamado `n`:

```dart
import 'package:meta/meta.dart';

class C {
  void m() {}
}

extension type E(C c) implements C {
  @redeclare
  void [!n!]() {}
}
```

#### Correções comuns

Se o membro anotado tiver o nome correto, remova a anotação:

```dart
class C {
  void m() {}
}

extension type E(C c) implements C {
  void n() {}
}
```

Se o membro anotado for suposto substituir um membro das
interfaces implementadas, altere o nome do membro anotado para
corresponder ao membro que está sendo substituído:

```dart
import 'package:meta/meta.dart';

class C {
  void m() {}
}

extension type E(C c) implements C {
  @redeclare
  void m() {}
}
```

### redirect_generative_to_missing_constructor {:#redirect_generative_to_missing_constructor}

_O construtor '{0}' não pôde ser encontrado em '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um construtor generativo
redireciona para um construtor que não está definido.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor `C.a`
redireciona para o construtor `C.b`, mas `C.b` não está definido:

```dart
class C {
  C.a() : [!this.b()!];
}
```

#### Correções comuns

Se o construtor ausente precisar ser chamado, defina-o:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

Se o construtor ausente não precisar ser chamado, remova o
redirecionamento:

```dart
class C {
  C.a();
}
```

### redirect_generative_to_non_generative_constructor {:#redirect_generative_to_non_generative_constructor}

_Construtores generativos não podem redirecionar para um construtor de fábrica._

#### Descrição

O analisador produz este diagnóstico quando um construtor generativo
redireciona para um construtor de fábrica.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor generativo
`C.a` redireciona para o construtor de fábrica `C.b`:

```dart
class C {
  C.a() : [!this.b()!];
  factory C.b() => C.a();
}
```

#### Correções comuns

Se o construtor generativo não precisar redirecionar para outro
construtor, remova o redirecionamento.

```dart
class C {
  C.a();
  factory C.b() => C.a();
}
```

Se o construtor generativo precisar redirecionar para outro construtor,
faça o outro construtor ser um construtor generativo (não de fábrica):

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

### redirect_to_abstract_class_constructor {:#redirect_to_abstract_class_constructor}

_O construtor de redirecionamento '{0}' não pode redirecionar para um construtor da classe abstrata '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um construtor redireciona para
um construtor em uma classe abstrata.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor de fábrica
em `A` redireciona para um construtor em `B`, mas `B` é um
classe abstrata:

```dart
class A {
  factory A() = [!B!];
}

abstract class B implements A {}
```

#### Correções comuns

Se o código redirecionar para o construtor correto, altere a classe para
que não seja abstrata:

```dart
class A {
  factory A() = B;
}

class B implements A {}
```

Caso contrário, altere o construtor de fábrica para que ele redirecione
para um construtor em uma classe concreta ou tenha uma implementação
concreta.

### redirect_to_invalid_function_type {:#redirect_to_invalid_function_type}

_O construtor redirecionado '{0}' tem parâmetros incompatíveis com '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um construtor de fábrica tenta
redirecionar para outro construtor, mas os dois têm parâmetros
incompatíveis. Os parâmetros são compatíveis se todos os parâmetros do
construtor de redirecionamento puderem ser passados para o outro
construtor e se o outro construtor não exigir nenhum parâmetro que não seja
declarado pelo construtor de redirecionamento.

#### Exemplos

O código a seguir produz este diagnóstico porque o construtor para `A`
não declara um parâmetro que o construtor para `B` exige:

```dart
abstract class A {
  factory A() = [!B!];
}

class B implements A {
  B(int x);
  B.zero();
}
```

O código a seguir produz este diagnóstico porque o construtor para `A`
declara um parâmetro nomeado (`y`) que o construtor para `B` não
permite:

```dart
abstract class A {
  factory A(int x, {int y}) = [!B!];
}

class B implements A {
  B(int x);
}
```

#### Correções comuns

Se houver um construtor diferente que seja compatível com o construtor de
redirecionamento, redirecione para esse construtor:

```dart
abstract class A {
  factory A() = B.zero;
}

class B implements A {
  B(int x);
  B.zero();
}
```

Caso contrário, atualize o construtor de redirecionamento para ser compatível:

```dart
abstract class A {
  factory A(int x) = B;
}

class B implements A {
  B(int x);
}
```

### redirect_to_invalid_return_type {:#redirect_to_invalid_return_type}

_O tipo de retorno '{0}' do construtor redirecionado não é um subtipo de '{1}'._

#### Descrição

O analisador produz esse diagnóstico quando um construtor factory (fábrica) redireciona
para um construtor cujo tipo de retorno não é um subtipo do tipo que o
construtor factory é declarado para produzir.

#### Exemplo

O código a seguir produz esse diagnóstico porque `A` não é uma subclasse
de `C`, o que significa que o valor retornado pelo construtor `A()`
não poderia ser retornado do construtor `C()`:

```dart
class A {}

class B implements C {}

class C {
  factory C() = [!A!];
}
```

#### Correções comuns

Se o construtor factory estiver redirecionando para um construtor na classe errada,
então atualize o construtor factory para redirecionar para o construtor correto:

```dart
class A {}

class B implements C {}

class C {
  factory C() = B;
}
```

Se a classe que define o construtor sendo redirecionado é a classe que
deveria ser retornada, então faça dela um subtipo do tipo de retorno do factory:

```dart
class A implements C {}

class B implements C {}

class C {
  factory C() = A;
}
```

### redirect_to_missing_constructor {:#redirect_to_missing_constructor}

_O construtor '{0}' não pôde ser encontrado em '{1}'._

#### Descrição

O analisador produz esse diagnóstico quando um construtor redireciona para um
construtor que não existe.

#### Exemplo

O código a seguir produz esse diagnóstico porque o construtor factory
em `A` redireciona para um construtor em `B` que não existe:

```dart
class A {
  factory A() = [!B.name!];
}

class B implements A {
  B();
}
```

#### Correções comuns

Se o construtor para o qual está sendo redirecionado estiver correto, então defina o
construtor:

```dart
class A {
  factory A() = B.name;
}

class B implements A {
  B();
  B.name();
}
```

Se um construtor diferente deve ser invocado, então atualize o redirecionamento:

```dart
class A {
  factory A() = B;
}

class B implements A {
  B();
}
```

### redirect_to_non_class {:#redirect_to_non_class}

_O nome '{0}' não é um tipo e não pode ser usado em um construtor redirecionado._

#### Descrição

Uma forma de implementar um construtor factory é redirecionar para outro
construtor referenciando o nome do construtor. O analisador
produz esse diagnóstico quando o redirecionamento é para algo que não seja um
construtor.

#### Exemplo

O código a seguir produz esse diagnóstico porque `f` é uma função:

```dart
C f() => throw 0;

class C {
  factory C() = [!f!];
}
```

#### Correções comuns

Se o construtor não estiver definido, então defina-o ou substitua-o por
um construtor que esteja definido.

Se o construtor estiver definido, mas a classe que o define não estiver visível,
então você provavelmente precisa adicionar um import.

Se você estiver tentando retornar o valor retornado por uma função, então reescreva
o construtor para retornar o valor do corpo do construtor:

```dart
C f() => throw 0;

class C {
  factory C() => f();
}
```

### redirect_to_non_const_constructor {:#redirect_to_non_const_constructor}

_Um construtor constante (const) de redirecionamento não pode redirecionar para um construtor não constante._

#### Descrição

O analisador produz esse diagnóstico quando um construtor marcado como `const`
redireciona para um construtor que não está marcado como `const`.

#### Exemplo

O código a seguir produz esse diagnóstico porque o construtor `C.a`
está marcado como `const`, mas redireciona para o construtor `C.b`, que não está:

```dart
class C {
  const C.a() : this.[!b!]();
  C.b();
}
```

#### Correções comuns

Se o construtor não constante puder ser marcado como `const`, então marque-o como
`const`:

```dart
class C {
  const C.a() : this.b();
  const C.b();
}
```

Se o construtor não constante não puder ser marcado como `const`, então remova o
redirecionamento ou remova `const` do construtor de redirecionamento:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

### redirect_to_type_alias_expands_to_type_parameter {:#redirect_to_type_alias_expands_to_type_parameter}

_Um construtor de redirecionamento não pode redirecionar para um alias de tipo que se expande para um parâmetro de tipo._

#### Descrição

O analisador produz esse diagnóstico quando um construtor factory de
redirecionamento redireciona para um alias de tipo, e o alias de tipo se expande para um dos
parâmetros de tipo do alias de tipo. Isso não é permitido porque o valor
do parâmetro de tipo é um tipo em vez de uma classe.

#### Exemplo

O código a seguir produz esse diagnóstico porque o redirecionamento para `B<A>`
é para um alias de tipo cujo valor é `T`, mesmo que pareça que o valor
deveria ser `A`:

```dart
class A implements C {}

typedef B<T> = T;

abstract class C {
  factory C() = [!B!]<A>;
}
```

#### Correções comuns

Use um nome de classe ou um alias de tipo que esteja definido para ser uma classe
em vez de um alias de tipo definido para ser um parâmetro de tipo:

```dart
class A implements C {}

abstract class C {
  factory C() = A;
}
```

### referenced_before_declaration {:#referenced_before_declaration}

_A variável local '{0}' não pode ser referenciada antes de ser declarada._

#### Descrição

O analisador produz este diagnóstico quando uma variável é referenciada antes
de ser declarada. Em Dart, as variáveis são visíveis em todos os lugares no bloco em
que são declaradas, mas só podem ser referenciadas depois de serem
declaradas.

O analisador também produz uma mensagem de contexto que indica onde a
declaração está localizada.

#### Exemplo

O código a seguir produz esse diagnóstico porque `i` é usado antes de ser
declarado:

```dart
void f() {
  print([!i!]);
  int i = 5;
}
```

#### Correções comuns

Se você pretendia referenciar a variável local, mova a declaração
antes da primeira referência:

```dart
void f() {
  int i = 5;
  print(i);
}
```

Se você pretendia referenciar um nome de um escopo externo, como um
parâmetro, campo de instância ou variável de nível superior, então renomeie a local
declaração para que não oculte a variável externa.

```dart
void f(int i) {
  print(i);
  int x = 5;
  print(x);
}
```

### refutable_pattern_in_irrefutable_context {:#refutable_pattern_in_irrefutable_context}

_Padrões refutáveis não podem ser usados em um contexto irrefutável._

#### Descrição

O analisador produz esse diagnóstico quando um [padrão refutável][padrão refutável] é usado
em um contexto onde apenas um [padrão irrefutável][padrão irrefutável] é permitido.

Os padrões refutáveis que são proibidos são:
- logical-or (ou lógico)
- relational (relacional)
- null-check (verificação nula)
- constant (constante)

Os contextos que são verificados são:
- declarações de variáveis baseadas em padrão
- loops for baseados em padrão
- atribuições com um padrão no lado esquerdo

#### Exemplo

O código a seguir produz esse diagnóstico porque o padrão de verificação nula (null-check),
que é um padrão refutável, está em uma declaração de variável baseada em padrão,
que não permite padrões refutáveis:

```dart
void f(int? x) {
  var ([!_?!]) = x;
}
```

#### Correções comuns

Reescreva o código para não usar um padrão refutável em um contexto irrefutável.

### relational_pattern_operand_type_not_assignable {:#relational_pattern_operand_type_not_assignable}

_O tipo de expressão constante '{0}' não é atribuível ao tipo de parâmetro
'{1}' do operador '{2}'._

#### Descrição

O analisador produz este diagnóstico quando o operando de um padrão relacional
tem um tipo que não é atribuível ao parâmetro do operador
que será invocado.

#### Exemplo

O código a seguir produz esse diagnóstico porque o operando no
padrão relacional (`0`) é um `int`, mas o operador `>` definido em `C`
espera um objeto do tipo `C`:

```dart
class C {
  const C();

  bool operator >(C other) => true;
}

void f(C c) {
  switch (c) {
    case > [!0!]:
      print('positivo');
  }
}
```

#### Correções comuns

Se o switch estiver usando o valor correto, então altere o case para comparar
o valor com o tipo correto de objeto:

```dart
class C {
  const C();

  bool operator >(C other) => true;
}

void f(C c) {
  switch (c) {
    case > const C():
      print('positivo');
  }
}
```

Se o switch estiver usando o valor errado, então altere a expressão usada para
calcular o valor que está sendo comparado:

```dart
class C {
  const C();

  bool operator >(C other) => true;

  int get toInt => 0;
}

void f(C c) {
  switch (c.toInt) {
    case > 0:
      print('positivo');
  }
}
```

### relational_pattern_operator_return_type_not_assignable_to_bool {:#relational_pattern_operator_return_type_not_assignable_to_bool}

_O tipo de retorno dos operadores usados em padrões relacionais deve ser atribuível a 'bool'._

#### Descrição

O analisador produz este diagnóstico quando um padrão relacional referencia
um operador que não produz um valor do tipo `bool`.

#### Exemplo

O código a seguir produz este diagnóstico porque o operador `>`, usado
no padrão relacional `> c2`, retorna um valor do tipo `int` em vez de um
`bool`:

```dart
class C {
  const C();

  int operator >(C c) => 3;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case [!>!] c2) {}
}
```

#### Correções comuns

Se houver um operador diferente que deve ser usado, então altere o
operador:

```dart
class C {
  const C();

  int operator >(C c) => 3;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case < c2) {}
}
```

Se o operador deve retornar `bool`, então atualize a declaração
do operador:

```dart
class C {
  const C();

  bool operator >(C c) => true;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case > c2) {}
}
```

### rest_element_in_map_pattern {:#rest_element_in_map_pattern}

_Um padrão de mapa não pode conter um padrão de resto._

#### Descrição

O analisador produz este diagnóstico quando um padrão de mapa contém um padrão de resto.
Padrões de mapa correspondem a um mapa com mais chaves do que aquelas explicitamente dadas no
padrão (contanto que as chaves dadas correspondam), então um padrão de resto é
desnecessário.

#### Exemplo

O código a seguir produz esse diagnóstico porque o padrão de mapa contém
um padrão de resto:

```dart
void f(Map<int, String> x) {
  if (x case {0: _, [!...!]}) {}
}
```

#### Correções comuns

Remova o padrão de resto:

```dart
void f(Map<int, String> x) {
  if (x case {0: _}) {}
}
```

### rethrow_outside_catch {:#rethrow_outside_catch}

_Um rethrow deve estar dentro de uma cláusula catch._

#### Descrição

O analisador produz esse diagnóstico quando uma instrução `rethrow` está fora
de uma cláusula `catch`. A instrução `rethrow` é usada para lançar uma
exceção capturada novamente, mas não há exceção capturada fora de um
cláusula `catch`.

#### Exemplo

O código a seguir produz esse diagnóstico porque a instrução `rethrow`
está fora de uma cláusula `catch`:

```dart
void f() {
  [!rethrow!];
}
```

#### Correções comuns

Se você estiver tentando relançar uma exceção, então envolva a instrução `rethrow`
em uma cláusula `catch`:

```dart
void f() {
  try {
    // ...
  } catch (exception) {
    rethrow;
  }
}
```

Se você estiver tentando lançar uma nova exceção, então substitua a instrução
`rethrow` por uma expressão `throw`:

```dart
void f() {
  throw UnsupportedError('Ainda não implementado');
}
```

### return_in_generative_constructor {:#return_in_generative_constructor}

_Construtores não podem retornar valores._

#### Descrição

O analisador produz este diagnóstico quando um construtor generativo
contém uma instrução `return` que especifica um valor a ser retornado.
Construtores generativos sempre retornam o objeto que foi criado, e
portanto, não podem retornar um objeto diferente.

#### Exemplo

O código a seguir produz esse diagnóstico porque a instrução `return`
tem uma expressão:

```dart
class C {
  C() {
    return [!this!];
  }
}
```

#### Correções comuns

Se o construtor deve criar uma nova instância, então remova a
instrução `return` ou a expressão:

```dart
class C {
  C();
}
```

Se o construtor não deve criar uma nova instância, então converta-o para ser um
construtor factory (fábrica):

```dart
class C {
  factory C() {
    return _instance;
  }

  static C _instance = C._();

  C._();
}
```

### return_in_generator {:#return_in_generator}

_Não é possível retornar um valor de uma função geradora que usa o modificador 'async*' ou
'sync*'. _

#### Descrição

O analisador produz esse diagnóstico quando uma função geradora (uma cujo
corpo é marcado com `async*` ou `sync*`) usa uma instrução `return`
para retornar um valor ou retorna implicitamente um valor por causa do uso de
`=>`. Em qualquer um desses casos, eles devem usar `yield` em vez de `return`.

#### Exemplos

O código a seguir produz esse diagnóstico porque o método `f` é um
gerador e está usando `return` para retornar um valor:

```dart
Iterable<int> f() sync* {
  [!return!] 3;
}
```

O código a seguir produz esse diagnóstico porque a função `f` é um
gerador e está retornando implicitamente um valor:

```dart
Stream<int> f() async* [!=>!] 3;
```

#### Correções comuns

Se a função estiver usando `=>` para o corpo da função, então converta-a
para um corpo de função de bloco e use `yield` para retornar um valor:

```dart
Stream<int> f() async* {
  yield 3;
}
```

Se o método for destinado a ser um gerador, então use `yield` para retornar um
valor:

```dart
Iterable<int> f() sync* {
  yield 3;
}
```

Se o método não for destinado a ser um gerador, então remova o modificador
do corpo (ou use `async` se você estiver retornando um future):

```dart
int f() {
  return 3;
}
```

### return_of_do_not_store {:#return_of_do_not_store}

_'{0}' é anotado com 'doNotStore' e não deve ser retornado a menos que '{1}' também seja anotado._

#### Descrição

O analisador produz esse diagnóstico quando um valor anotado com
a anotação [`doNotStore`][meta-doNotStore] é retornado de um método,
getter ou função que não tem a mesma anotação.

#### Exemplo

O código a seguir produz esse diagnóstico porque o resultado da invocação de
`f` não deve ser armazenado, mas a função `g` não está anotada para preservar
essa semântica:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

int g() => [!f()!];
```

#### Correções comuns

Se o valor que não deve ser armazenado for o valor correto a ser retornado, então
marque a função com a anotação [`doNotStore`][meta-doNotStore]:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

@doNotStore
int g() => f();
```

Caso contrário, retorne um valor diferente da função:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

int g() => 0;
```

### return_of_invalid_type {:#return_of_invalid_type}

_Um valor do tipo '{0}' não pode ser retornado do construtor '{2}' porque ele tem
um tipo de retorno de '{1}'._

_Um valor do tipo '{0}' não pode ser retornado da função '{2}' porque ele tem
um tipo de retorno de '{1}'._

_Um valor do tipo '{0}' não pode ser retornado do método '{2}' porque ele tem
um tipo de retorno de '{1}'._

#### Descrição

O analisador produz esse diagnóstico quando um método ou função retorna um
valor cujo tipo não é atribuível ao tipo de retorno declarado.

#### Exemplo

O código a seguir produz esse diagnóstico porque `f` tem um tipo de retorno
de `String`, mas está retornando um `int`:

```dart
String f() => [!3!];
```

#### Correções comuns

Se o tipo de retorno estiver correto, então substitua o valor que está sendo retornado por um
valor do tipo correto, possivelmente convertendo o valor existente:

```dart
String f() => 3.toString();
```

Se o valor estiver correto, então altere o tipo de retorno para corresponder:

```dart
int f() => 3;
```

### return_of_invalid_type_from_closure {:#return_of_invalid_type_from_closure}

_O tipo retornado '{0}' não pode ser retornado de uma função '{1}', conforme exigido
pelo contexto do closure._

#### Descrição

O analisador produz este diagnóstico quando o tipo estático de uma expressão
retornada não é atribuível ao tipo de retorno que o closure é obrigado
a ter.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` é definido como uma
função que retorna uma `String`, mas o closure atribuído a ela retorna um
`int`:

```dart
String Function(String) f = (s) => [!3!];
```

#### Correções comuns

Se o tipo de retorno estiver correto, então substitua o valor retornado por um valor
do tipo correto, possivelmente convertendo o valor existente:

```dart
String Function(String) f = (s) => 3.toString();
```

### return_without_value {:#return_without_value}

_O valor de retorno está faltando após 'return'._

#### Descrição

O analisador produz esse diagnóstico quando encontra uma instrução `return`
sem uma expressão em uma função que declara um tipo de retorno.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f`
deveria retornar um `int`, mas nenhum valor está sendo retornado:

```dart
int f() {
  [!return!];
}
```

#### Correções comuns

Adicione uma expressão que calcule o valor a ser retornado:

```dart
int f() {
  return 0;
}
```

### sdk_version_async_exported_from_core {:#sdk_version_async_exported_from_core}

_A classe '{0}' não foi exportada de 'dart:core' até a versão 2.1, mas este
código é necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz esse diagnóstico quando a classe `Future` ou
`Stream` é referenciada em uma biblioteca que não importa `dart:async` em
código que tem uma restrição de SDK cujo limite inferior é menor que 2.1.0. Em
versões anteriores, essas classes não eram definidas em `dart:core`, então a
importação era necessária.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.1.0:

```yaml
environment:
  sdk: '>=2.0.0 <2.4.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
void f([!Future!] f) {}
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que as classes sejam referenciadas:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então importe a
biblioteca `dart:async`.

```dart
import 'dart:async';

void f(Future f) {}
```

### sdk_version_as_expression_in_const_context {:#sdk_version_as_expression_in_const_context}

_O uso de uma expressão as em um contexto constante não era suportado até a
versão 2.3.2, mas este código é necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz esse diagnóstico quando uma expressão `as` dentro de um
[contexto constante][contexto constante] é encontrada em código que tem uma restrição de SDK cujo
limite inferior é menor que 2.3.2. Usar uma expressão `as` em um
[contexto constante][contexto constante] não era suportado em versões anteriores, então esse código
não poderá ser executado em versões anteriores do SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz
esse diagnóstico:

```dart
const num n = 3;
const int i = [!n as int!];
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que a expressão seja usada:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então reescreva o
código para não usar uma expressão `as`, ou altere o código para que a expressão `as`
não esteja em um [contexto constante][contexto constante]:

```dart
num x = 3;
int y = x as int;
```

### sdk_version_bool_operator_in_const_context {:#sdk_version_bool_operator_in_const_context}

_O uso do operador '{0}' para operandos 'bool' em um contexto constante não era
suportado até a versão 2.3.2, mas este código é necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz este diagnóstico quando qualquer uso dos operadores `&`, `|` ou `^`
na classe `bool` dentro de um [contexto constante][contexto constante] é encontrado em
código que tem uma restrição de SDK cujo limite inferior é menor que 2.3.2. Usar
esses operadores em um [contexto constante][contexto constante] não era suportado em
versões anteriores, então esse código não poderá ser executado em versões anteriores do
SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
const bool a = true;
const bool b = false;
const bool c = a [!&!] b;
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que os operadores sejam usados:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então reescreva o
código para não usar esses operadores, ou altere o código para que a expressão
não esteja em um [contexto constante][contexto constante]:

```dart
const bool a = true;
const bool b = false;
bool c = a & b;
```

### sdk_version_constructor_tearoffs {:#sdk_version_constructor_tearoffs}

_Extrair um construtor (tear-off) requer o recurso de linguagem 'constructor-tearoffs'._

#### Descrição

O analisador produz esse diagnóstico quando um tear-off de construtor é encontrado
em código que tem uma restrição de SDK cujo limite inferior é menor que 2.15.
Tear-offs de construtor não eram suportados em versões anteriores, então este código
não poderá ser executado em versões anteriores do SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.15:

```yaml
environment:
  sdk: '>=2.9.0 <2.15.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
var setConstructor = [!Set.identity!];
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que o operador seja usado:

```yaml
environment:
  sdk: '>=2.15.0 <2.16.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então reescreva o código
para não usar tear-offs de construtor:

```dart
var setConstructor = () => Set.identity();
```

### sdk_version_eq_eq_operator_in_const_context {:#sdk_version_eq_eq_operator_in_const_context}

_O uso do operador '==' para tipos não primitivos não era suportado até a versão
2.3.2, mas este código é necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz esse diagnóstico quando o operador `==` é usado em um
tipo não primitivo dentro de um [contexto constante][contexto constante] é encontrado em
código que tem uma restrição de SDK cujo limite inferior é menor que 2.3.2.
Usar esse operador em um [contexto constante][contexto constante] não era suportado em
versões anteriores, então esse código não poderá ser executado em versões anteriores do
SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
class C {}
const C a = null;
const C b = null;
const bool same = a [!==!] b;
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que o operador seja usado:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então reescreva o
código para não usar o operador `==`, ou altere o código para que a
expressão não esteja em um [contexto constante][contexto constante]:

```dart
class C {}
const C a = null;
const C b = null;
bool same = a == b;
```

### sdk_version_extension_methods {:#sdk_version_extension_methods}

_Métodos de extensão não eram suportados até a versão 2.6.0, mas este código é
necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz esse diagnóstico quando uma declaração de extensão ou um
override de extensão é encontrado em código que tem uma restrição de SDK cujo
limite inferior é menor que 2.6.0. Usar extensões não era suportado em
versões anteriores, então esse código não poderá ser executado em versões anteriores do
SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.6.0:

```yaml
environment:
 sdk: '>=2.4.0 <2.7.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
[!extension!] E on String {
  void sayHello() {
    print('Olá $this');
  }
}
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.6.0 <2.7.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então reescreva o código
para não usar extensões. A maneira mais comum de fazer isso é reescrever
os membros da extensão como funções de nível superior (ou métodos) que recebem
o valor que teria sido vinculado a `this` como um parâmetro:

```dart
void sayHello(String s) {
  print('Olá $s');
}
```

### sdk_version_gt_gt_gt_operator {:#sdk_version_gt_gt_gt_operator}

_O operador '>>>' não era suportado até a versão 2.14.0, mas este código é
necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz este diagnóstico quando o operador `>>>` é usado em
código que tem uma restrição de SDK cujo limite inferior é menor que 2.14.0.
Este operador não era suportado em versões anteriores, então este código não poderá
ser executado em versões anteriores do SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.14.0:

```yaml
environment:
 sdk: '>=2.0.0 <2.15.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
int x = 3 [!>>>!] 4;
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que o operador seja usado:

```yaml
environment:
  sdk: '>=2.14.0 <2.15.0'
```

Se você precisar oferecer suporte a versões mais antigas do SDK, então reescreva o código
para não usar o operador `>>>`:

```dart
int x = logicalShiftRight(3, 4);

int logicalShiftRight(int leftOperand, int rightOperand) {
  int divisor = 1 << rightOperand;
  if (divisor == 0) {
    return 0;
  }
  return leftOperand ~/ divisor;
}
```

### sdk_version_is_expression_in_const_context {:#sdk_version_is_expression_in_const_context}

_O uso de uma expressão is em um contexto constante não era suportado até a
versão 2.3.2, mas este código é necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz esse diagnóstico quando uma expressão `is` dentro de um
[contexto constante][contexto constante] é encontrada em código que tem uma restrição de SDK cujo
limite inferior é menor que 2.3.2. Usar uma expressão `is` em um
[contexto constante][contexto constante] não era suportado em versões anteriores, então esse código
não poderá ser executado em versões anteriores do SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz esse
diagnóstico:

```dart
const Object x = 4;
const y = [!x is int!] ? 0 : 1;
```

#### Correções comuns

Se você não precisa oferecer suporte a versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que a expressão seja usada:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

Se você precisa suportar versões mais antigas do SDK, reescreva o
código para não usar o operador `is` ou, se isso não for possível, altere o
código para que a expressão `is` não esteja em um
[contexto constante][contexto constante]:

```dart
const Object x = 4;
var y = x is int ? 0 : 1;
```

### sdk_version_never {:#sdk-version-never}

_O tipo 'Never' não era suportado até a versão 2.12.0, mas este código é
necessário para poder ser executado em versões anteriores._

#### Descrição

O analisador produz este diagnóstico quando uma referência à classe `Never`
é encontrada em código que tem uma restrição de SDK cujo limite inferior é menor que
2.12.0. Essa classe não foi definida em versões anteriores, então este código não
será capaz de ser executado em versões anteriores do SDK.

#### Exemplo

Aqui está um exemplo de um pubspec que define uma restrição de SDK com um limite
inferior menor que 2.12.0:

```yaml
environment:
  sdk: '>=2.5.0 <2.6.0'
```

No pacote que tem esse pubspec, um código como o seguinte produz este
diagnóstico:

```dart
[!Never!] n;
```

#### Correções comuns

Se você não precisa suportar versões mais antigas do SDK, então você pode
aumentar a restrição do SDK para permitir que o tipo seja usado:

```yaml
environment:
  sdk: '>=2.12.0 <2.13.0'
```

Se você precisa suportar versões mais antigas do SDK, então reescreva o código para
não referenciar esta classe:

```dart
dynamic x;
```

### sdk_version_set_literal {:#sdk-version-set-literal}

_Literais de conjunto não eram suportados até a versão 2.2, mas este código é necessário para
poder ser executado em versões anteriores._

#### Descrição

O analisador produz este diagnóstico quando um literal de conjunto é encontrado em código
que tem uma restrição de SDK cujo limite inferior é menor que 2.2.0. Set
literais não eram suportados em versões anteriores, então este código não será capaz
de ser executado em versões anteriores do SDK.

#### Exemplo

Eis um exemplo de um `pubspec` que define uma restrição de SDK com um limite inferior menor que 2.2.0:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

No pacote que tem esse `pubspec`, código como o seguinte produz este
diagnóstico:

```dart
var s = [!<int>{}!];
```

#### Correções comuns

Se você não precisa dar suporte a versões mais antigas do SDK, então você
pode aumentar a restrição do SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.2.0 <2.4.0'
```

Se você precisa dar suporte a versões mais antigas do SDK, então substitua
o literal de conjunto com código que cria o conjunto sem o uso de um literal:

```dart
var s = new Set<int>();
```

### sdk_version_ui_as_code {:#sdk_version_ui_as_code}

_Os elementos for, if e spread (espalhamento) não eram suportados até a versão 2.3.0, mas este código é necessário para poder rodar em versões anteriores._

#### Descrição

O analisador produz este diagnóstico quando um elemento for, if ou spread é
encontrado em código que possui uma restrição de SDK cujo limite inferior é
menor que 2.3.0. Usar um elemento for, if ou spread não era suportado em
versões anteriores, então este código não será capaz de rodar contra versões
anteriores do SDK.

#### Exemplo

Eis um exemplo de um `pubspec` que define uma restrição de SDK com um
limite inferior menor que 2.3.0:

```yaml
environment:
  sdk: '>=2.2.0 <2.4.0'
```

No pacote que tem esse `pubspec`, código como o seguinte produz este
diagnóstico:

```dart
var digits = [[!for (int i = 0; i < 10; i++) i!]];
```

#### Correções comuns

Se você não precisa dar suporte a versões mais antigas do SDK, então você
pode aumentar a restrição do SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.3.0 <2.4.0'
```

Se você precisa dar suporte a versões mais antigas do SDK, então reescreva o
código para não fazer uso desses elementos:

```dart
var digits = _initializeDigits();

List<int> _initializeDigits() {
  var digits = <int>[];
  for (int i = 0; i < 10; i++) {
    digits.add(i);
  }
  return digits;
}
```

### sdk_version_ui_as_code_in_const_context {:#sdk_version_ui_as_code_in_const_context}

_Os elementos if e spread não eram suportados em expressões constantes até a versão 2.5.0, mas este código é necessário para poder rodar em versões anteriores._

#### Descrição

O analisador produz este diagnóstico quando um elemento if ou spread dentro
de um [contexto constante][contexto constante] é encontrado em código que tem uma restrição de
SDK cujo limite inferior é menor que 2.5.0. Usar um elemento if ou spread
dentro de um [contexto constante][contexto constante] não era suportado em versões anteriores,
então este código não será capaz de rodar contra versões anteriores do SDK.

#### Exemplo

Eis um exemplo de um `pubspec` que define uma restrição de SDK com um
limite inferior menor que 2.5.0:

```yaml
environment:
  sdk: '>=2.4.0 <2.6.0'
```

No pacote que tem esse `pubspec`, código como o seguinte produz este
diagnóstico:

```dart
const a = [1, 2];
const b = [[!...a!]];
```

#### Correções comuns

Se você não precisa dar suporte a versões mais antigas do SDK, então você
pode aumentar a restrição do SDK para permitir que a sintaxe seja usada:

```yaml
environment:
  sdk: '>=2.5.0 <2.6.0'
```

Se você precisa dar suporte a versões mais antigas do SDK, então reescreva o
código para não fazer uso desses elementos:

```dart
const a = [1, 2];
const b = [1, 2];
```

Se isso não for possível, mude o código para que o elemento não esteja em um
[contexto constante][contexto constante]:

```dart
const a = [1, 2];
var b = [...a];
```

### set_element_type_not_assignable {:#set_element_type_not_assignable}

_O tipo do elemento '{0}' não pode ser atribuído ao tipo de conjunto '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um elemento em um literal de
conjunto tem um tipo que não pode ser atribuído ao tipo de elemento do
conjunto.

#### Exemplo

O seguinte código produz este diagnóstico porque o tipo do literal de
string `'0'` é `String`, que não pode ser atribuído a `int`, o tipo de
elemento do conjunto:

```dart
var s = <int>{[!'0'!]};
```

#### Correções comuns

Se o tipo de elemento do literal de conjunto estiver errado, então mude o
tipo de elemento do conjunto:

```dart
var s = <String>{'0'};
```

Se o tipo do elemento estiver errado, então mude o elemento:

```dart
var s = <int>{'0'.length};
```

### shared_deferred_prefix {:#shared_deferred_prefix}

_O prefixo de uma importação adiada não pode ser usado em outras diretivas
de importação._

#### Descrição

O analisador produz este diagnóstico quando um prefixo em uma importação
adiada também é usado como um prefixo em outras importações (sejam elas
adiadas ou não). O prefixo em uma importação adiada não pode ser compartilhado
com outras importações porque o prefixo é usado para carregar a biblioteca
importada.

#### Exemplo

O seguinte código produz este diagnóstico porque o prefixo `x` é usado
como prefixo para uma importação adiada e também é usado para uma outra
importação:

```dart
import 'dart:math' [!deferred!] as x;
import 'dart:convert' as x;

var y = x.json.encode(x.min(0, 1));
```

#### Correções comuns

Se você puder usar um nome diferente para a importação adiada, então faça
isso:

```dart
import 'dart:math' deferred as math;
import 'dart:convert' as x;

var y = x.json.encode(math.min(0, 1));
```

Se você puder usar um nome diferente para as outras importações, então
faça isso:

```dart
import 'dart:math' deferred as x;
import 'dart:convert' as convert;

var y = convert.json.encode(x.min(0, 1));
```

### size_annotation_dimensions {:#size_annotation_dimensions}

_Arrays devem ter uma anotação 'Array' que corresponda às dimensões._

#### Descrição

O analisador produz este diagnóstico quando o número de dimensões
especificado em uma anotação `Array` não corresponde ao número de arrays
aninhados especificados pelo tipo de um campo.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

#### Exemplo

O seguinte código produz este diagnóstico porque o campo `a0` tem um
tipo com três arrays aninhados, mas apenas duas dimensões são dadas na
anotação `Array`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Array(8, 8)!]
  external Array<Array<Array<Uint8>>> a0;
}
```

#### Correções comuns

Se o tipo do campo estiver correto, então corrija a anotação para ter o
número de dimensões requerido:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8, 8, 4)
  external Array<Array<Array<Uint8>>> a0;
}
```

Se o tipo do campo estiver errado, então corrija o tipo do campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8, 8)
  external Array<Array<Uint8>> a0;
}
```

### static_access_to_instance_member {:#static_access_to_instance_member}

_O membro de instância '{0}' não pode ser acessado usando acesso estático._

#### Descrição

O analisador produz este diagnóstico quando um nome de classe é usado para
acessar um campo de instância. Campos de instância não existem em uma
classe; eles existem apenas em uma instância da classe.

#### Exemplo

O seguinte código produz este diagnóstico porque `x` é um campo de
instância:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f() => C.[!b!];
```

#### Correções comuns

Se você pretende acessar um campo estático, então mude o nome do campo
para um campo estático existente:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f() => C.a;
```

Se você pretende acessar o campo de instância, então use uma instância da
classe para acessar o campo:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f(C c) => c.b;
```

### subtype_of_base_or_final_is_not_base_final_or_sealed {:#subtype_of_base_or_final_is_not_base_final_or_sealed}

_O mixin '{0}' deve ser 'base' porque o supertipo '{1}' é 'base'._

_O mixin '{0}' deve ser 'base' porque o supertipo '{1}' é 'final'._

_O tipo '{0}' deve ser 'base', 'final' ou 'sealed' porque o supertipo '{1}'
é 'base'._

_O tipo '{0}' deve ser 'base', 'final' ou 'sealed' porque o supertipo '{1}'
é 'final'._

#### Descrição

O analisador produz este diagnóstico quando uma classe ou mixin tem um
supertipo direto ou indireto que é `base` ou `final`, mas a própria classe ou
mixin não é marcado como `base`, `final` ou `sealed`.

#### Exemplo

O seguinte código produz este diagnóstico porque a classe `B` é um
subtipo de `A`, e `A` é uma classe `base`, mas `B` não é nem `base`,
`final` ou `sealed`:

```dart
base class A {}
class [!B!] extends A {}
```

#### Correções comuns

Adicione `base`, `final` ou `sealed` à declaração da classe ou mixin:

```dart
base class A {}
final class B extends A {}
```

### subtype_of_deferred_class {:#subtype_of_deferred_class}

_Classes e mixins não podem implementar classes adiadas._

_Classes não podem estender classes adiadas._

_Classes não podem usar mixin de classes adiadas._

#### Descrição

O analisador produz este diagnóstico quando um tipo (classe ou mixin) é um
subtipo de uma classe de uma biblioteca que está sendo importada usando uma
importação adiada. Os supertipos de um tipo devem ser compilados ao mesmo
tempo que o tipo, e classes de bibliotecas adiadas não são compiladas até
que a biblioteca seja carregada.

Para mais informações, veja
[Carregando uma biblioteca preguiçosamente](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

Dado um arquivo `a.dart` que define a classe `A`:

```dart
class A {}
```

O seguinte código produz este diagnóstico porque a superclasse de `B`
é declarada em uma biblioteca adiada:

```dart
import 'a.dart' deferred as a;

class B extends [!a.A!] {}
```

#### Correções comuns

Se você precisa criar um subtipo de um tipo da biblioteca adiada, então
remova a palavra-chave `deferred`:

```dart
import 'a.dart' as a;

class B extends a.A {}
```

### subtype_of_disallowed_type {:#subtype_of_disallowed_type}

_'{0}' não pode ser usado como uma restrição de superclasse._

_Classes e mixins não podem implementar '{0}'._

_Classes não podem estender '{0}'._

_Classes não podem usar mixin de '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma das classes restritas é
usada em uma cláusula `extends`, `implements`, `with` ou `on`. As classes
`bool`, `double`, `FutureOr`, `int`, `Null`, `num` e `String` são todas
restritas desta forma, para permitir implementações mais eficientes.

#### Exemplos

O seguinte código produz este diagnóstico porque `String` é usado em uma
cláusula `extends`:

```dart
class A extends [!String!] {}
```

O seguinte código produz este diagnóstico porque `String` é usado em uma
cláusula `implements`:

```dart
class B implements [!String!] {}
```

O seguinte código produz este diagnóstico porque `String` é usado em uma
cláusula `with`:

```dart
class C with [!String!] {}
```

O seguinte código produz este diagnóstico porque `String` é usado em uma
cláusula `on`:

```dart
mixin M on [!String!] {}
```

#### Correções comuns

Se um tipo diferente deve ser especificado, então substitua o tipo:

```dart
class A extends Object {}
```

Se não houver um tipo diferente que seria apropriado, então remova o tipo
e, possivelmente, toda a cláusula:

```dart
class B {}
```

### subtype_of_ffi_class {:#subtype_of_ffi_class}

_A classe '{0}' não pode estender '{1}'._

_A classe '{0}' não pode implementar '{1}'._

_A classe '{0}' não pode usar mixin de '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma classe estende qualquer
classe FFI que não seja `Struct` ou `Union`, ou implementa ou usa mixin de
qualquer classe FFI. `Struct` e `Union` são as únicas classes FFI que podem
ser subtipadas, e então apenas estendendo-as.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

#### Exemplo

O seguinte código produz este diagnóstico porque a classe `C` estende
`Double`:

```dart
import 'dart:ffi';

final class C extends [!Double!] {}
```

#### Correções comuns

Se a classe deve estender `Struct` ou `Union`, então mude a declaração
da classe:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int i;
}
```

Se a classe não deve estender `Struct` ou `Union`, então remova
qualquer referência às classes FFI:

```dart
final class C {}
```

### subtype_of_sealed_class {:#subtype_of_sealed_class}

_A classe '{0}' não deve ser estendida, ter mixin ou ser implementada porque é
sealed (selada)._

#### Descrição

O analisador produz este diagnóstico quando uma classe selada (uma que
tem a anotação [`sealed`][meta-sealed] ou herda ou usa mixin de uma classe
selada) é referenciada na cláusula `extends`, `implements` ou `with` de
uma declaração de classe ou mixin se a declaração não estiver no mesmo
pacote que a classe selada.

#### Exemplo

Dada uma biblioteca em um pacote diferente do pacote que está sendo
analisado que contém o seguinte:

```dart
import 'package:meta/meta.dart';

class A {}

@sealed
class B {}
```

O seguinte código produz este diagnóstico porque `C`, que não está no
mesmo pacote que `B`, está estendendo a classe selada `B`:

```dart
import 'package:a/a.dart';

[!class C extends B {}!]
```

#### Correções comuns

Se a classe não precisa ser um subtipo da classe selada, então mude a
declaração para que não seja:

```dart
import 'package:a/a.dart';

class B extends A {}
```

Se a classe precisa ser um subtipo da classe selada, então mude a classe
selada para que ela não seja mais selada ou mova a subclasse para o
mesmo pacote que a classe selada.

### subtype_of_struct_class {:#subtype_of_struct_class}

_A classe '{0}' não pode estender '{1}' porque '{1}' é um subtipo de 'Struct',
'Union' ou 'AbiSpecificInteger'._

_A classe '{0}' não pode implementar '{1}' porque '{1}' é um subtipo de 'Struct',
'Union' ou 'AbiSpecificInteger'._

_A classe '{0}' não pode usar mixin de '{1}' porque '{1}' é um subtipo de
'Struct', 'Union' ou 'AbiSpecificInteger'._

#### Descrição

O analisador produz este diagnóstico quando uma classe estende,
implementa ou usa mixin de uma classe que estende `Struct` ou `Union`.
Classes só podem estender `Struct` ou `Union` diretamente.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

#### Exemplo

O seguinte código produz este diagnóstico porque a classe `C` estende
`S`, e `S` estende `Struct`:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer f;
}

final class C extends [!S!] {
  external Pointer g;
}
```

#### Correções comuns

Se você está tentando definir uma struct ou union que compartilha alguns
campos declarados por uma struct ou union diferente, então estenda
`Struct` ou `Union` diretamente e copie os campos compartilhados:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer f;
}

final class C extends Struct {
  external Pointer f;

  external Pointer g;
}
```

### supertype_expands_to_type_parameter {:#supertype_expands_to_type_parameter}

_Um alias de tipo que se expande para um parâmetro de tipo não pode ser
implementado._

_Um alias de tipo que se expande para um parâmetro de tipo não pode ser
usado como mixin._

_Um alias de tipo que se expande para um parâmetro de tipo não pode ser
usado como uma restrição de superclasse._

_Um alias de tipo que se expande para um parâmetro de tipo não pode ser
usado como uma superclasse._

#### Descrição

O analisador produz este diagnóstico quando um alias de tipo que se
expande para um parâmetro de tipo é usado em uma cláusula `extends`,
`implements`, `with` ou `on`.

#### Exemplo

O seguinte código produz este diagnóstico porque o alias de tipo `T`,
que se expande para o parâmetro de tipo `S`, é usado na cláusula `extends`
da classe `C`:

```dart
typedef T<S> = S;

class C extends [!T!]<Object> {}
```

#### Correções comuns

Use o valor do argumento de tipo diretamente:

```dart
typedef T<S> = S;

class C extends Object {}
```

### super_formal_parameter_type_is_not_subtype_of_associated {:#super_formal_parameter_type_is_not_subtype_of_associated}

_O tipo '{0}' deste parâmetro não é um subtipo do tipo '{1}' do parâmetro
do super construtor associado._

#### Descrição

O analisador produz este diagnóstico quando o tipo de um super parâmetro
não é um subtipo do parâmetro correspondente do super construtor.

#### Exemplo

O seguinte código produz este diagnóstico porque o tipo do super
parâmetro `x` no construtor para `B` não é um subtipo do parâmetro `x` no
construtor para `A`:

```dart
class A {
  A(num x);
}

class B extends A {
  B(String super.[!x!]);
}
```

#### Correções comuns

Se o tipo do super parâmetro pode ser o mesmo que o parâmetro do super
construtor, então remova a anotação de tipo do super parâmetro (se o tipo
for implícito, ele é inferido do tipo no super construtor):

```dart
class A {
  A(num x);
}

class B extends A {
  B(super.x);
}
```

Se o tipo do super parâmetro pode ser um subtipo do tipo do parâmetro
correspondente, então mude o tipo do super parâmetro:

```dart
class A {
  A(num x);
}

class B extends A {
  B(int super.x);
}
```

Se o tipo do super parâmetro não pode ser mudado, então use um parâmetro
normal em vez de um super parâmetro:

```dart
class A {
  A(num x);
}

class B extends A {
  B(String x) : super(x.length);
}
```

### super_formal_parameter_without_associated_named {:#super_formal_parameter_without_associated_named}

_Nenhum parâmetro de super construtor nomeado associado._

#### Descrição

O analisador produz este diagnóstico quando há um super parâmetro
nomeado em um construtor e o super construtor invocado implícita ou
explicitamente não tem um parâmetro nomeado com o mesmo nome.

Super parâmetros nomeados são associados por nome com parâmetros nomeados
no super construtor.

#### Exemplo

O seguinte código produz este diagnóstico porque o construtor em `A`
não tem um parâmetro nomeado `y`:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({super.[!y!]});
}
```

#### Correções comuns

Se o super parâmetro deve ser associado a um parâmetro existente do super
construtor, então mude o nome para corresponder ao nome do parâmetro
correspondente:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({super.x});
}
```

Se o super parâmetro deve ser associado a um parâmetro que ainda não foi
adicionado ao super construtor, então adicione-o:

```dart
class A {
  A({int? x, int? y});
}

class B extends A {
  B({super.y});
}
```

Se o super parâmetro não corresponde a um parâmetro nomeado do super
construtor, então mude-o para ser um parâmetro normal:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({int? y});
}
```

### super_formal_parameter_without_associated_positional {:#super_formal_parameter_without_associated_positional}

_Nenhum parâmetro de super construtor posicional associado._

#### Descrição

O analisador produz este diagnóstico quando há um super parâmetro
posicional em um construtor e o super construtor invocado implícita ou
explicitamente não tem um parâmetro posicional no índice correspondente.

Super parâmetros posicionais são associados com parâmetros posicionais no
super construtor pelo seu índice. Isto é, o primeiro super parâmetro é
associado com o primeiro parâmetro posicional no super construtor, o
segundo com o segundo e assim por diante.

#### Exemplos

O seguinte código produz este diagnóstico porque o construtor em `B`
tem um super parâmetro posicional, mas não há parâmetro posicional no
super construtor em `A`:

```dart
class A {
  A({int? x});
}

class B extends A {
  B(super.[!x!]);
}
```

O seguinte código produz este diagnóstico porque o construtor em `B`
tem dois super parâmetros posicionais, mas há apenas um parâmetro
posicional no super construtor em `A`, o que significa que não há nenhum
parâmetro correspondente para `y`:

```dart
class A {
  A(int x);
}

class B extends A {
  B(super.x, super.[!y!]);
}
```

#### Correções comuns

Se o super construtor deve ter um parâmetro posicional correspondente
ao super parâmetro, então atualize o super construtor adequadamente:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(super.x, super.y);
}
```

Se o super construtor estiver correto, ou não puder ser mudado, então
converta o super parâmetro em um parâmetro normal:

```dart
class A {
  A(int x);
}

class B extends A {
  B(super.x, int y);
}
```

### super_invocation_not_last {:#super_invocation_not_last}

<a id="invalid_super_invocation" aria-hidden="true"></a>_(Anteriormente conhecido como `invalid_super_invocation`)_

_A chamada do superconstrutor deve ser a última na lista de inicializadores:
'{0}'._

#### Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de
um construtor contém uma invocação de um construtor na superclasse, mas
a invocação não é o último item na lista de inicializadores.

#### Exemplo

O seguinte código produz este diagnóstico porque a invocação do
construtor da superclasse não é o último item na lista de
inicializadores:

```dart
class A {
  A(int x);
}

class B extends A {
  B(int x) : [!super!](x), assert(x >= 0);
}
```

#### Correções comuns

Mova a invocação do construtor da superclasse para o final da lista de
inicializadores:

```dart
class A {
  A(int x);
}

class B extends A {
  B(int x) : assert(x >= 0), super(x);
}
```

### super_in_enum_constructor {:#super_in_enum_constructor}

_O construtor enum não pode ter um inicializador 'super'._

#### Descrição

O analisador produz este diagnóstico quando a lista de inicializadores
em um construtor em um enum contém uma invocação de um super construtor.

#### Exemplo

O seguinte código produz este diagnóstico porque o construtor no enum
`E` tem uma invocação de super construtor na lista de inicializadores:

```dart
enum E {
  e;

  const E() : [!super!]();
}
```

#### Correções comuns

Remova a invocação do super construtor:

```dart
enum E {
  e;

  const E();
}
```

### super_in_extension {:#super_in_extension}

_A palavra-chave 'super' não pode ser usada em uma extensão porque uma
extensão não tem uma superclasse._

#### Descrição

O analisador produz este diagnóstico quando um membro declarado dentro de
uma extensão usa a palavra-chave `super`. Extensões não são classes e não
têm superclasses, então a palavra-chave `super` não tem propósito.

#### Exemplo

O seguinte código produz este diagnóstico porque `super` não pode ser
usado em uma extensão:

```dart
extension E on Object {
  String get displayString => [!super!].toString();
}
```

#### Correções comuns

Remova a palavra-chave `super`:

```dart
extension E on Object {
  String get displayString => toString();
}
```

### super_in_extension_type {:#super_in_extension_type}

_A palavra-chave 'super' não pode ser usada em um tipo de extensão porque
um tipo de extensão não tem uma superclasse._

#### Descrição

O analisador produz este diagnóstico quando `super` é usado em um membro
de instância de um tipo de extensão. Tipos de extensão não têm
superclasses, então não há nenhum membro herdado que possa ser invocado.

#### Exemplo

O seguinte código produz este diagnóstico porque:

```dart
extension type E(String s) {
  void m() {
    [!super!].m();
  }
}
```

#### Correções comuns

Substitua ou remova a invocação `super`:

```dart
extension type E(String s) {
  void m() {
    s.toLowerCase();
  }
}
```

### super_in_invalid_context {:#super_in_invalid_context}

_Contexto inválido para invocação 'super'._

#### Descrição

O analisador produz este diagnóstico quando a palavra-chave `super` é
usada fora de um método de instância.

#### Exemplo

O seguinte código produz este diagnóstico porque `super` é usado em uma
função de nível superior:

```dart
void f() {
  [!super!].f();
}
```

#### Correções comuns

Reescreva o código para não usar `super`.

### super_in_redirecting_constructor {:#super_in_redirecting_constructor}

_O construtor de redirecionamento não pode ter um inicializador 'super'._

#### Descrição

O analisador produz este diagnóstico quando um construtor que redireciona
para outro construtor também tenta invocar um construtor da superclasse.
O construtor da superclasse será invocado quando o construtor para o qual
o construtor de redirecionamento é redirecionado for invocado.

#### Exemplo

O seguinte código produz este diagnóstico porque o construtor `C.a`
redireciona para `C.b` e invoca um construtor da superclasse:

```dart
class C {
  C.a() : this.b(), [!super()!];
  C.b();
}
```

#### Correções comuns

Remova a invocação do construtor `super`:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

### switch_case_completes_normally {:#switch_case_completes_normally}

_O 'case' não deve completar normalmente._

#### Descrição

O analisador produz este diagnóstico quando as declarações que seguem um
rótulo `case` em uma declaração `switch` podem passar para o próximo
rótulo `case` ou `default`.

#### Exemplo

O seguinte código produz este diagnóstico porque o rótulo `case` com
um valor de zero (`0`) passa para as declarações `default`:

```dart
void f(int a) {
  switch (a) {
    [!case!] 0:
      print(0);
    default:
      return;
  }
}
```

#### Correções comuns

Mude o fluxo de controle para que o `case` não passe. Há várias
maneiras de fazer isso, incluindo adicionar um dos seguintes no final da
lista atual de declarações:
- uma declaração `return`,
- uma expressão `throw`,
- uma declaração `break`,
- um `continue`, ou
- uma invocação de uma função ou método cujo tipo de retorno é `Never`.

### switch_expression_not_assignable {:#switch_expression_not_assignable}

_O tipo '{0}' da expressão switch não pode ser atribuído ao tipo '{1}' das
expressões case._

#### Descrição

O analisador produz este diagnóstico quando o tipo da expressão em uma
declaração `switch` não pode ser atribuído ao tipo das expressões nas
cláusulas `case`.

#### Exemplo

O seguinte código produz este diagnóstico porque o tipo de `s`
(`String`) não pode ser atribuído ao tipo de `0` (`int`):

```dart
void f(String s) {
  switch ([!s!]) {
    case 0:
      break;
  }
}
```

#### Correções comuns

Se o tipo das expressões `case` estiver correto, então mude a expressão
na declaração `switch` para ter o tipo correto:

```dart
void f(String s) {
  switch (int.parse(s)) {
    case 0:
      break;
  }
}
```

Se o tipo da expressão `switch` estiver correto, então mude as expressões
`case` para ter o tipo correto:

```dart
void f(String s) {
  switch (s) {
    case '0':
      break;
  }
}
```

### tearoff_of_generative_constructor_of_abstract_class {:#tearoff_of_generative_constructor_of_abstract_class}

_Um construtor generativo de uma classe abstrata não pode ser desmembrado (torn off)._

#### Descrição

O analisador produz este diagnóstico quando um construtor generativo de
uma classe abstrata está sendo desmembrado (torn off). Isso não é
permitido porque não é válido criar uma instância de uma classe abstrata,
o que significa que não há nenhum uso válido para o construtor
desmembrado.

#### Exemplo

O seguinte código produz este diagnóstico porque o construtor `C.new`
está sendo desmembrado e a classe `C` é uma classe abstrata:

```dart
abstract class C {
  C();
}

void f() {
  [!C.new!];
}
```

#### Correções comuns

Desmembre o construtor de uma classe concreta.

### text_direction_code_point_in_comment {:#text_direction_code_point_in_comment}

_O ponto de código Unicode 'U+{0}' muda a aparência do texto de como ele é
interpretado pelo compilador._

#### Descrição

O analisador produz este diagnóstico quando encontra código-fonte que
contém pontos de código Unicode de direção de texto. Esses pontos de
código fazem com que o código-fonte em um literal de string ou em um
comentário seja interpretado e compilado de forma diferente de como ele
aparece nos editores, levando a possíveis vulnerabilidades de segurança.

#### Exemplo

O seguinte código produz este diagnóstico duas vezes porque há
caracteres ocultos no início e no final da string do rótulo:

```dart
var label = '[!I!]nteractive text[!'!];
```

#### Correções comuns

Se os code points devem ser incluídos no string literal,
então escape-os:

```dart
var label = '\u202AInteractive text\u202C';
```

Se os code points não devem ser incluídos no string literal,
então remova-os:

```dart
var label = 'Interactive text';
```

### text_direction_code_point_in_literal {:#text_direction_code_point_in_literal}

_O ponto de código Unicode 'U+{0}' altera a aparência do texto de como ele é
interpretado pelo compilador._

#### Descrição

O analisador produz esse diagnóstico quando encontra código-fonte que
contém pontos de código Unicode de direção de texto. Esses pontos de código fazem
com que o código-fonte em um literal de string ou comentário seja interpretado
e compilado de forma diferente de como ele aparece nos editores, levando a
possíveis vulnerabilidades de segurança.

#### Exemplo

O código a seguir produz este diagnóstico duas vezes porque existem
caracteres ocultos no início e no final da string (cadeia de caracteres) `label`:

```dart
var label = '[!I!]texto interativo[!'!];
```

#### Correções comuns

Se os pontos de código devem ser incluídos no literal de string,
então, escape-os:

```dart
var label = '\u202Atexto interativo\u202C';
```

Se os pontos de código não devem ser incluídos no literal de string,
então remova-os:

```dart
var label = 'texto interativo';
```

### throw_of_invalid_type {:#throw_of_invalid_type}

_O tipo '{0}' da expressão lançada deve ser atribuível a 'Object'._

#### Descrição

O analisador produz este diagnóstico quando o tipo da expressão em uma
expressão `throw` não é atribuível a `Object`. Não é válido lançar
`null`, então não é válido usar uma expressão que possa ser avaliada como
`null`.

#### Exemplo

O código a seguir produz este diagnóstico porque `s` pode ser `null`:

```dart
void f(String? s) {
  throw [!s!];
}
```

#### Correções comuns

Adicione uma verificação explícita de nulo à expressão:

```dart
void f(String? s) {
  throw s!;
}
```

### top_level_cycle {:#top_level_cycle}

_O tipo de '{0}' não pode ser inferido porque ele depende de si mesmo através do
ciclo: {1}._

#### Descrição

O analisador produz este diagnóstico quando uma variável de nível superior não tem anotação de tipo e o inicializador da variável se refere à variável, direta ou indiretamente.

#### Exemplo

O código a seguir produz este diagnóstico porque as variáveis `x` e
`y` são definidas em termos uma da outra e nenhuma tem um tipo explícito,
portanto, o tipo da outra não pode ser inferido:

```dart
var x = y;
var y = [!x!];
```

#### Correções comuns

Se as duas variáveis não precisam se referir uma à outra, então quebre o
ciclo:

```dart
var x = 0;
var y = x;
```

Se as duas variáveis precisam se referir uma à outra, então forneça a pelo menos uma delas um tipo explícito:

```dart
int x = y;
var y = x;
```

Observe, no entanto, que, embora este código não produza nenhum diagnóstico, ele
produzirá um estouro de pilha em tempo de execução, a menos que pelo menos uma das
variáveis ​​receba um valor que não dependa das outras variáveis
antes que qualquer uma das variáveis ​​no ciclo seja referenciada.

### type_alias_cannot_reference_itself {:#type_alias_cannot_reference_itself}

_Typedefs (alias de tipo) não podem se referenciar direta ou recursivamente através de outro
typedef._

#### Descrição

O analisador produz este diagnóstico quando um typedef se refere a si mesmo,
direta ou indiretamente.

#### Exemplo

O código a seguir produz este diagnóstico porque `F` depende de si mesmo
indiretamente através de `G`:

```dart
typedef [!F!] = void Function(G);
typedef G = void Function(F);
```

#### Correções comuns

Altere um ou mais dos typedefs no ciclo de forma que nenhum deles se refira
a si mesmos:

```dart
typedef F = void Function(G);
typedef G = void Function(int);
```

### type_annotation_deferred_class {:#type_annotation_deferred_class}

_O tipo adiado '{0}' não pode ser usado em uma declaração, conversão ou teste de tipo._

#### Descrição

O analisador produz este diagnóstico quando a anotação de tipo está em uma
declaração de variável, ou o tipo usado em uma conversão (`as`) ou teste de tipo (`is`)
é um tipo declarado em uma biblioteca que é importada usando um import diferido (deferred).
Esses tipos precisam estar disponíveis em tempo de compilação, mas não estão.

Para obter mais informações, consulte
[Carregando uma biblioteca de forma lazy](https://dartbrasil.dev/language/libraries#lazily-loading-a-library).

#### Exemplo

O código a seguir produz este diagnóstico porque o tipo do
parâmetro `f` é importado de uma biblioteca diferida (deferred):

```dart
import 'dart:io' deferred as io;

void f([!io.File!] f) {}
```

#### Correções comuns

Se você precisar referenciar o tipo importado, remova a palavra-chave `deferred`:

```dart
import 'dart:io' as io;

void f(io.File f) {}
```

Se a importação precisar ser diferida e houver outro tipo apropriado,
use esse tipo em vez do tipo da biblioteca diferida.

### type_argument_not_matching_bounds {:#type_argument_not_matching_bounds}

_'{0}' não está em conformidade com o limite '{2}' do parâmetro de tipo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um argumento de tipo não é o mesmo que ou uma subclasse dos limites do parâmetro de tipo correspondente.

#### Exemplo

O código a seguir produz este diagnóstico porque `String` não é um
subclasse de `num`:

```dart
class A<E extends num> {}

var a = A<[!String!]>();
```

#### Correções comuns

Altere o argumento de tipo para ser uma subclasse dos limites:

```dart
class A<E extends num> {}

var a = A<int>();
```

### type_check_with_null {:#type_check_with_null}

_Testes para não nulo devem ser feitos com '!= null'._

_Testes para nulo devem ser feitos com '== null'._

#### Descrição

O analisador produz este diagnóstico quando há uma verificação de tipo (usando o operador `as`) em que o tipo é `Null`. Há apenas um valor cujo tipo é `Null`, então o código é mais legível e tem melhor desempenho quando testa explicitamente por `null`.

#### Exemplos

O código a seguir produz este diagnóstico porque o código está testando
para ver se o valor de `s` é `null` usando uma verificação de tipo:

```dart
void f(String? s) {
  if ([!s is Null!]) {
    return;
  }
  print(s);
}
```

O código a seguir produz este diagnóstico porque o código está testando
para ver se o valor de `s` é algo diferente de `null` usando um tipo
verificação:

```dart
void f(String? s) {
  if ([!s is! Null!]) {
    print(s);
  }
}
```

#### Correções comuns

Substitua a verificação de tipo pela comparação equivalente com `null`:

```dart
void f(String? s) {
  if (s == null) {
    return;
  }
  print(s);
}
```

### type_parameter_referenced_by_static {:#type_parameter_referenced_by_static}

_Membros estáticos não podem referenciar parâmetros de tipo da classe._

#### Descrição

O analisador produz este diagnóstico quando um membro estático referencia um
parâmetro de tipo que é declarado para a classe. Parâmetros de tipo só têm
significado para instâncias da classe.

#### Exemplo

O código a seguir produz este diagnóstico porque o método estático
`hasType` tem uma referência ao parâmetro de tipo `T`:

```dart
class C<T> {
  static bool hasType(Object o) => o is [!T!];
}
```

#### Correções comuns

Se o membro pode ser um membro de instância, remova a palavra-chave `static`:

```dart
class C<T> {
  bool hasType(Object o) => o is T;
}
```

Se o membro precisar ser um membro estático, faça com que o membro seja genérico:

```dart
class C<T> {
  static bool hasType<S>(Object o) => o is S;
}
```

Observe, no entanto, que não há uma relação entre `T` e `S`, então esta
segunda opção altera a semântica do que provavelmente era pretendido.

### type_parameter_supertype_of_its_bound {:#type_parameter_supertype_of_its_bound}

_'{0}' não pode ser um supertipo de seu limite superior._

#### Descrição

O analisador produz este diagnóstico quando o limite de um parâmetro de tipo
(o tipo após a palavra-chave `extends`) é direta ou indiretamente o
próprio parâmetro de tipo. Afirmar que o parâmetro de tipo deve ser o mesmo
que si mesmo ou uma subtipo de si mesmo ou um subtipo de si mesmo não é útil
porque sempre será o mesmo que si mesmo.

#### Exemplos

O código a seguir produz este diagnóstico porque o limite de `T` é
`T`:

```dart
class C<[!T!] extends T> {}
```

O código a seguir produz este diagnóstico porque o limite de `T1` é
`T2`, e o limite de `T2` é `T1`, efetivamente fazendo com que o limite de `T1`
seja `T1`:

```dart
class C<[!T1!] extends T2, T2 extends T1> {}
```

#### Correções comuns

Se o parâmetro de tipo precisa ser uma subclasse de algum tipo, substitua o
limite com o tipo necessário:

```dart
class C<T extends num> {}
```

Se o parâmetro de tipo pode ser qualquer tipo, remova a cláusula `extends`:

```dart
class C<T> {}
```

### type_test_with_non_type {:#type_test_with_non_type}

_O nome '{0}' não é um tipo e não pode ser usado em uma expressão 'is'._

#### Descrição

O analisador produz este diagnóstico quando o lado direito de um `is`
ou teste `is!` não é um tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o lado direito é
um parâmetro, não um tipo:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is [!b!]) {
    return;
  }
}
```

#### Correções comuns

Se você pretendia usar um teste de tipo, substitua o lado direito por um
tipo:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is B) {
    return;
  }
}
```

Se você pretendia usar um tipo diferente de teste, altere o teste:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a == b) {
    return;
  }
}
```

### type_test_with_undefined_name {:#type_test_with_undefined_name}

_O nome '{0}' não está definido, portanto, não pode ser usado em uma expressão 'is'._

#### Descrição

O analisador produz este diagnóstico quando o nome após o `is` em um
expressão de teste de tipo não está definida.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `Srting` não está
definido:

```dart
void f(Object o) {
  if (o is [!Srting!]) {
    // ...
  }
}
```

#### Correções comuns

Substitua o nome pelo nome de um tipo:

```dart
void f(Object o) {
  if (o is String) {
    // ...
  }
}
```

### unchecked_use_of_nullable_value {:#unchecked_use_of_nullable_value}

_Uma expressão anulável não pode ser usada como uma condição._

_Uma expressão anulável não pode ser usada como um iterador em um loop for-in._

_Uma expressão anulável não pode ser usada em um spread._

_Uma expressão anulável não pode ser usada em uma declaração yield-each._

_A função não pode ser invocada incondicionalmente porque pode ser 'null'._

_O método '{0}' não pode ser invocado incondicionalmente porque o receptor pode ser
'null'._

_O operador '{0}' não pode ser invocado incondicionalmente porque o receptor pode ser
'null'._

_A propriedade '{0}' não pode ser acessada incondicionalmente porque o receptor pode
ser 'null'._

#### Descrição

O analisador produz este diagnóstico quando uma expressão cujo tipo é
[potencialmente não anulável][potencialmente não anulável] é desreferenciada sem primeiro verificar se
o valor não é `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque `s` pode ser `null` em
o ponto onde é referenciado:

```dart
void f(String? s) {
  if (s.[!length!] > 3) {
    // ...
  }
}
```

#### Correções comuns

Se o valor realmente puder ser `null`, adicione um teste para garantir que os membros
só são acessados quando o valor não é `null`:

```dart
void f(String? s) {
  if (s != null && s.length > 3) {
    // ...
  }
}
```

Se a expressão for uma variável e o valor nunca deva ser `null`, então
altere o tipo da variável para não anulável:

```dart
void f(String s) {
  if (s.length > 3) {
    // ...
  }
}
```

Se você acredita que o valor da expressão nunca deve ser `null`, mas
você não pode alterar o tipo da variável e está disposto a arriscar
ter uma exceção lançada em tempo de execução se você estiver errado, você pode afirmar
que o valor não é nulo:

```dart
void f(String? s) {
  if (s!.length > 3) {
    // ...
  }
}
```

### undefined_annotation {:#undefined_annotation}

_Nome indefinido '{0}' usado como uma anotação._

#### Descrição

O analisador produz este diagnóstico quando um nome que não está definido é
usado como uma anotação.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `undefined`
não está definido:

```dart
[!@undefined!]
void f() {}
```

#### Correções comuns

Se o nome estiver correto, mas ainda não foi declarado, declare o nome como
um valor constante:

```dart
const undefined = 'undefined';

@undefined
void f() {}
```

Se o nome estiver errado, substitua o nome pelo nome de uma constante válida:

```dart
@deprecated
void f() {}
```

Caso contrário, remova a anotação.

### undefined_class {:#undefined_class}

_Classe indefinida '{0}'._

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de uma classe, mas não está definido ou não é visível
no escopo em que está sendo referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque `Piont` não está definido:

```dart
class Point {}

void f([!Piont!] p) {}
```

#### Correções comuns

Se o identificador não estiver definido, defina-o ou substitua-o por
o nome de uma classe que está definida. O exemplo acima pode ser corrigido por
corrigir a grafia da classe:

```dart
class Point {}

void f(Point p) {}
```

Se a classe estiver definida, mas não estiver visível, você provavelmente precisará adicionar um
importação.

### undefined_constructor_in_initializer {:#undefined_constructor_in_initializer}

_A classe '{0}' não tem um construtor chamado '{1}'._

_A classe '{0}' não tem um construtor não nomeado._

#### Descrição

O analisador produz este diagnóstico quando um construtor de superclasse é
invocado na lista de inicializadores de um construtor, mas a superclasse
não define o construtor sendo invocado.

#### Exemplos

O código a seguir produz este diagnóstico porque `A` não tem um
construtor não nomeado:

```dart
class A {
  A.n();
}
class B extends A {
  B() : [!super()!];
}
```

O código a seguir produz este diagnóstico porque `A` não tem um
construtor nomeado `m`:

```dart
class A {
  A.n();
}
class B extends A {
  B() : [!super.m()!];
}
```

#### Correções comuns

Se a superclasse definir um construtor que deve ser invocado, altere
o construtor sendo invocado:

```dart
class A {
  A.n();
}
class B extends A {
  B() : super.n();
}
```

Se a superclasse não definir um construtor apropriado, defina
o construtor sendo invocado:

```dart
class A {
  A.m();
  A.n();
}
class B extends A {
  B() : super.m();
}
```

### undefined_enum_constant {:#undefined_enum_constant}

_Não existe uma constante chamada '{0}' em '{1}'._

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador
que parece ser o nome de um valor de enum e o nome não é
definido ou não é visível no escopo em que está sendo referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque `E` não define um
constante nomeada `c`:

```dart
enum E {a, b}

var e = E.[!c!];
```

#### Correções comuns

Se a constante deve ser definida, adicione-a à declaração do
enum:

```dart
enum E {a, b, c}

var e = E.c;
```

Se a constante não deve ser definida, altere o nome para o nome de
uma constante existente:

```dart
enum E {a, b}

var e = E.b;
```

### undefined_enum_constructor {:#undefined_enum_constructor}

_O enum não tem um construtor chamado '{0}'._

_O enum não tem um construtor não nomeado._

#### Descrição

O analisador produz este diagnóstico quando o construtor invocado para
inicializar um valor de enum não existe.

#### Exemplos

O código a seguir produz este diagnóstico porque o valor de enum `c`
está sendo inicializado pelo construtor não nomeado, mas não há não nomeado
construtor definido em `E`:

```dart
enum E {
  [!c!]();

  const E.x();
}
```

O código a seguir produz este diagnóstico porque o valor de enum `c` é
sendo inicializado pelo construtor nomeado `x`, mas não há construtor
nomeado `x` definido em `E`:

```dart
enum E {
  c.[!x!]();

  const E.y();
}
```

#### Correções comuns

Se o valor do enum estiver sendo inicializado pelo construtor não nomeado e um
dos construtores nomeados deveria ter sido usado, adicione o nome do
construtor:

```dart
enum E {
  c.x();

  const E.x();
}
```

Se o valor do enum estiver sendo inicializado pelo construtor não nomeado e nenhum
dos construtores nomeados são apropriados, defina o não nomeado
construtor:

```dart
enum E {
  c();

  const E();
}
```

Se o valor do enum estiver sendo inicializado por um construtor nomeado e um
dos construtores existentes deveriam ter sido usados, altere o nome do
construtor sendo invocado (ou remova-o se o construtor não nomeado
deve ser usado):

```dart
enum E {
  c.y();

  const E();
  const E.y();
}
```

Se o valor do enum estiver sendo inicializado por um construtor nomeado e nenhum
dos construtores existentes deveriam ter sido usados, defina um construtor
com o nome que foi usado:

```dart
enum E {
  c.x();

  const E.x();
}
```

### undefined_extension_getter {:#undefined_extension_getter}

_O getter '{0}' não está definido para a extensão '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma substituição de extensão é usada para
invocar um getter, mas o getter não é definido pela extensão especificada.
O analisador também produz este diagnóstico quando um getter estático é
referenciado, mas não é definido pela extensão especificada.

#### Exemplos

O código a seguir produz este diagnóstico porque a extensão `E`
não declara um getter de instância chamado `b`:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').[!b!];
}
```

O código a seguir produz este diagnóstico porque a extensão `E`
não declara um getter estático chamado `a`:

```dart
extension E on String {}

var x = E.[!a!];
```

#### Correções comuns

Se o nome do getter estiver incorreto, altere-o para o nome de um
getter existente:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').a;
}
```

Se o nome do getter estiver correto, mas o nome da extensão estiver
errado, altere o nome da extensão para o nome correto:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  F('c').b;
}
```

Se o nome do getter e a extensão estiverem corretos, mas o getter
não está definido, defina o getter:

```dart
extension E on String {
  String get a => 'a';
  String get b => 'z';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').b;
}
```

### undefined_extension_method {:#undefined_extension_method}

_O método '{0}' não está definido para a extensão '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma substituição de extensão é usada para
invocar um método, mas o método não é definido pela extensão especificada.
O analisador também produz este diagnóstico quando um método estático é
referenciado, mas não é definido pela extensão especificada.

#### Exemplos

O código a seguir produz este diagnóstico porque a extensão `E`
não declara um método de instância chamado `b`:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').[!b!]();
}
```

O código a seguir produz este diagnóstico porque a extensão `E`
não declara um método estático chamado `a`:

```dart
extension E on String {}

var x = E.[!a!]();
```

#### Correções comuns

Se o nome do método estiver incorreto, altere-o para o nome de um
método existente:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').a();
}
```

Se o nome do método estiver correto, mas o nome da extensão estiver
errado, altere o nome da extensão para o nome correto:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  F('c').b();
}
```

Se o nome do método e a extensão estiverem corretos, mas o método
não está definido, defina o método:

```dart
extension E on String {
  String a() => 'a';
  String b() => 'z';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').b();
}
```

### undefined_extension_operator {:#undefined_extension_operator}

_O operador '{0}' não está definido para a extensão '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um operador é invocado em um
extensão específica quando essa extensão não implementa o operador.

#### Exemplo

O código a seguir produz este diagnóstico porque a extensão `E`
não define o operador `*`:

```dart
var x = E('') [!*!] 4;

extension E on String {}
```

#### Correções comuns

Se a extensão deve implementar o operador, adicione um
implementação do operador à extensão:

```dart
var x = E('') * 4;

extension E on String {
  int operator *(int multiplier) => length * multiplier;
}
```

Se o operador for definido por uma extensão diferente, altere o nome
da extensão para o nome daquela que define o operador.

Se o operador estiver definido no argumento da substituição da extensão, então
remova a substituição da extensão:

```dart
var x = '' * 4;

extension E on String {}
```

### undefined_extension_setter {:#undefined_extension_setter}

_O setter '{0}' não está definido para a extensão '{1}'._

#### Descrição

O analisador produz este diagnóstico quando uma substituição de extensão é usada para
invocar um setter, mas o setter não é definido pela extensão especificada.
O analisador também produz este diagnóstico quando um setter estático é
referenciado, mas não é definido pela extensão especificada.

#### Exemplos

O código a seguir produz este diagnóstico porque a extensão `E`
não declara um setter de instância chamado `b`:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').[!b!] = 'd';
}
```

O código a seguir produz este diagnóstico porque a extensão `E`
não declara um setter estático chamado `a`:

```dart
extension E on String {}

void f() {
  E.[!a!] = 3;
}
```

#### Correções comuns

Se o nome do setter estiver incorreto, altere-o para o nome de um
setter existente:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').a = 'd';
}
```

Se o nome do setter estiver correto, mas o nome da extensão estiver
errado, altere o nome da extensão para o nome correto:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  F('c').b = 'd';
}
```

Se o nome do setter e a extensão estiverem corretos, mas o setter
não está definido, defina o setter:

```dart
extension E on String {
  set a(String v) {}
  set b(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').b = 'd';
}
```

### undefined_function {:#undefined_function}

_A função '{0}' não está definida._

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de uma função, mas não está definido ou não é
visível no escopo em que está sendo referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `emty` não está
definido:

```dart
List<int> empty() => [];

void main() {
  print([!emty!]());
}
```

#### Correções comuns

Se o identificador não estiver definido, defina-o ou substitua-o por
o nome de uma função que está definida. O exemplo acima pode ser corrigido
corrigindo a grafia da função:

```dart
List<int> empty() => [];

void main() {
  print(empty());
}
```

Se a função estiver definida, mas não estiver visível, você provavelmente precisará adicionar
uma importação ou reorganizar seu código para tornar a função visível.

### undefined_getter {:#undefined_getter}

_O getter '{0}' não está definido para o tipo de função '{1}'._

_O getter '{0}' não está definido para o tipo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de um getter, mas não está definido ou não é
visível no escopo em que está sendo referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque `String` não tem membro
nomeado `len`:

```dart
int f(String s) => s.[!len!];
```

#### Correções comuns

Se o identificador não estiver definido, defina-o ou substitua-o por
o nome de um getter que está definido. O exemplo acima pode ser corrigido por
corrigindo a grafia do getter:

```dart
int f(String s) => s.length;
```

### undefined_hidden_name {:#undefined_hidden_name}

_A biblioteca '{0}' não exporta um membro com o nome oculto '{1}'._

#### Descrição

O analisador produz este diagnóstico quando um combinador `hide` inclui um
nome que não está definido pela biblioteca que está sendo importada.

#### Exemplo

O código a seguir produz este diagnóstico porque `dart:math` não
define o nome `String`:

```dart
import 'dart:math' hide [!String!], max;

var x = min(0, 1);
```

#### Correções comuns

Se um nome diferente deve ser oculto, corrija o nome. Caso contrário,
remova o nome da lista:

```dart
import 'dart:math' hide max;

var x = min(0, 1);
```

### undefined_identifier {:#undefined_identifier}

_Nome indefinido '{0}'._

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador que
não está definido ou não é visível no escopo em que está sendo
referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `rihgt` não está
definido:

```dart
int min(int left, int right) => left <= [!rihgt!] ? left : right;
```

#### Correções comuns

Se o identificador não estiver definido, defina-o ou substitua-o por
um identificador que está definido. O exemplo acima pode ser corrigido por
corrigir a grafia da variável:

```dart
int min(int left, int right) => left <= right ? left : right;
```

Se o identificador estiver definido, mas não estiver visível, você provavelmente precisará
adicionar uma importação ou reorganizar seu código para tornar o identificador visível.

### undefined_identifier_await {:#undefined_identifier_await}

_Nome indefinido 'await' no corpo da função não marcado com 'async'._

#### Descrição

O analisador produz este diagnóstico quando o nome `await` é usado em um
corpo de método ou função sem ser declarado, e o corpo não está marcado
com a palavra-chave `async`. O nome `await` apenas introduz um await
expressão em uma função assíncrona.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome `await` é
usado no corpo de `f` mesmo que o corpo de `f` não esteja marcado com o
palavra-chave `async`:

```dart
void f(p) { [!await!] p; }
```

#### Correções comuns

Adicione a palavra-chave `async` ao corpo da função:

```dart
void f(p) async { await p; }
```

### undefined_method {:#undefined_method}

_O método '{0}' não está definido para o tipo de função '{1}'._

_O método '{0}' não está definido para o tipo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de um método, mas não está definido ou não é
visível no escopo em que está sendo referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque o identificador
`removeMiddle` não está definido:

```dart
int f(List<int> l) => l.[!removeMiddle!]();
```

#### Correções comuns

Se o identificador não estiver definido, defina-o ou substitua-o por
o nome de um método que está definido. O exemplo acima pode ser corrigido por
corrigir a grafia do método:

```dart
int f(List<int> l) => l.removeLast();
```

### undefined_named_parameter {:#undefined_named_parameter}

_O parâmetro nomeado '{0}' não está definido._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de método ou função
tem um argumento nomeado, mas o método ou função que está sendo invocado não
define um parâmetro com o mesmo nome.

#### Exemplo

O código a seguir produz este diagnóstico porque `m` não declara um
parâmetro nomeado chamado `a`:

```dart
class C {
  m({int? b}) {}
}

void f(C c) {
  c.m([!a!]: 1);
}
```

#### Correções comuns

Se o nome do argumento estiver digitado incorretamente, substitua-o pelo nome correto.
O exemplo acima pode ser corrigido alterando `a` para `b`:

```dart
class C {
  m({int? b}) {}
}

void f(C c) {
  c.m(b: 1);
}
```

Se uma subclasse adicionar um parâmetro com o nome em questão, converta o
receptor para a subclasse:

```dart
class C {
  m({int? b}) {}
}

class D extends C {
  m({int? a, int? b}) {}
}

void f(C c) {
  (c as D).m(a: 1);
}
```

Se o parâmetro deve ser adicionado à função, adicione-o:

```dart
class C {
  m({int? a, int? b}) {}
}

void f(C c) {
  c.m(a: 1);
}
```

### undefined_operator {:#undefined_operator}

_O operador '{0}' não está definido para o tipo '{1}'. _

#### Descrição

O analisador produz este diagnóstico quando um operador definível pelo usuário é
invocado em um objeto para o qual o operador não está definido.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `C` não
define o operador `+`:

```dart
class C {}

C f(C c) => c [!+!] 2;
```

#### Correções comuns

Se o operador deve ser definido para a classe, então defina-o:

```dart
class C {
  C operator +(int i) => this;
}

C f(C c) => c + 2;
```

### undefined_prefixed_name {:#undefined_prefixed_name}

_O nome '{0}' está sendo referenciado através do prefixo '{1}', mas não está
definido em nenhuma das bibliotecas importadas usando esse prefixo._

#### Descrição

O analisador produz este diagnóstico quando um identificador com prefixo é encontrado
onde o prefixo é válido, mas o identificador não é declarado em nenhuma das
bibliotecas importadas usando esse prefixo.

#### Exemplo

O código a seguir produz este diagnóstico porque `dart:core` não
define nada chamado `a`:

```dart
import 'dart:core' as p;

void f() {
  p.[!a!];
}
```

#### Correções comuns

Se a biblioteca na qual o nome é declarado ainda não foi importada, adicione uma
importação para a biblioteca.

Se o nome estiver errado, altere-o para um dos nomes que são declarados nas
bibliotecas importadas.

### undefined_referenced_parameter {:#undefined_referenced_parameter}

_O parâmetro '{0}' não está definido por '{1}'. _

#### Descrição

O analisador produz este diagnóstico quando uma anotação da forma
[`UseResult.unless(parameterDefined: parameterName)`][meta-UseResult]
especifica um nome de parâmetro que não é definido pela função anotada.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f`
não tem um parâmetro chamado `b`:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: [!'b'!])
int f([int? a]) => a ?? 0;
```

#### Correções comuns

Altere o argumento nomeado `parameterDefined` para corresponder ao nome de um dos
parâmetros para a função:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: 'a')
int f([int? a]) => a ?? 0;
```

### undefined_setter {:#undefined_setter}

_O setter '{0}' não está definido para o tipo de função '{1}'. _

_O setter '{0}' não está definido para o tipo '{1}'. _

#### Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de um setter mas não está definido ou não é
visível no escopo em que o identificador está sendo referenciado.

#### Exemplo

O código a seguir produz este diagnóstico porque não há um setter
chamado `z`:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.[!z!] = y;
  }
}
```

#### Correções comuns

Se o identificador não estiver definido, então defina-o ou substitua-o pelo
nome de um setter que esteja definido. O exemplo acima pode ser corrigido
corrigindo a ortografia do setter:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.x = y;
  }
}
```

### undefined_shown_name {:#undefined_shown_name}

_A biblioteca '{0}' não exporta um membro com o nome mostrado '{1}'. _

#### Descrição

O analisador produz este diagnóstico quando um combinador show inclui um
nome que não está definido pela biblioteca que está sendo importada.

#### Exemplo

O código a seguir produz este diagnóstico porque `dart:math` não
define o nome `String`:

```dart
import 'dart:math' show min, [!String!];

var x = min(0, 1);
```

#### Correções comuns

Se um nome diferente deve ser mostrado, então corrija o nome. Caso contrário,
remova o nome da lista:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```

### undefined_super_member {:#undefined_super_member}

<a id="undefined_super_method" aria-hidden="true"></a>_(Anteriormente conhecido como `undefined_super_method`)_

_O getter '{0}' não está definido em uma superclasse de '{1}'. _

_O método '{0}' não está definido em uma superclasse de '{1}'. _

_O operador '{0}' não está definido em uma superclasse de '{1}'. _

_O setter '{0}' não está definido em uma superclasse de '{1}'. _

#### Descrição

O analisador produz este diagnóstico quando um membro herdado (método,
getter, setter ou operador) é referenciado usando `super`, mas não há
membro com esse nome na cadeia de superclasses.

#### Exemplos

O código a seguir produz este diagnóstico porque `Object` não define
um método chamado `n`:

```dart
class C {
  void m() {
    super.[!n!]();
  }
}
```

O código a seguir produz este diagnóstico porque `Object` não define
um getter chamado `g`:

```dart
class C {
  void m() {
    super.[!g!];
  }
}
```

#### Correções comuns

Se o membro herdado que você pretende invocar tem um nome diferente, então
faça com que o nome do membro invocado corresponda ao membro herdado.

Se o membro que você pretende invocar estiver definido na mesma classe, então
remova o `super.`.

Se o membro não estiver definido, então adicione o membro a uma das
superclasses ou remova a invocação.

### unknown_platform {:#unknown_platform}

_A plataforma '{0}' não é uma plataforma reconhecida._

#### Descrição

O analisador produz este diagnóstico quando um nome de plataforma desconhecido é
usado como uma chave no mapa `platforms`.
Para saber mais sobre como especificar as plataformas suportadas do seu pacote,
consulte a [documentação sobre declarações de plataforma](https://dartbrasil.dev/tools/pub/pubspec#platforms).

#### Exemplo

O seguinte `pubspec.yaml` produz este diagnóstico porque a plataforma
`browser` é desconhecida.

```yaml
name: example
platforms:
  [!browser:!]
```

#### Correções comuns

Se você pode confiar na detecção automática de plataforma, então omita a
chave `platforms` de nível superior.

```yaml
name: example
```

Se você precisar especificar manualmente a lista de plataformas suportadas, então
escreva o campo `platforms` como um mapa com nomes de plataformas conhecidas como chaves.

```yaml
name: example
platforms:
  # Estas são as plataformas conhecidas
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```

### unnecessary_cast {:#unnecessary_cast}

_Cast desnecessário._

#### Descrição

O analisador produz este diagnóstico quando o valor que está sendo convertido já é
conhecido por ser do tipo para o qual está sendo convertido.

#### Exemplo

O código a seguir produz este diagnóstico porque `n` já é conhecido por
ser um `int` como resultado do teste `is`:

```dart
void f(num n) {
  if (n is int) {
    ([!n as int!]).isEven;
  }
}
```

#### Correções comuns

Remova o cast desnecessário:

```dart
void f(num n) {
  if (n is int) {
    n.isEven;
  }
}
```

### unnecessary_dev_dependency {:#unnecessary_dev_dependency}

_A dependência de desenvolvimento (dev dependency) em {0} é desnecessária porque também existe uma dependência normal nesse pacote._

#### Descrição

O analisador produz este diagnóstico quando há uma entrada em
`dev_dependencies` para um pacote que também está listado em `dependencies`.
Os pacotes em `dependencies` estão disponíveis para todo o código do
pacote, então não há necessidade de listá-los também em `dev_dependencies`.

#### Exemplo

O código a seguir produz este diagnóstico porque o pacote `meta` está
listado em `dependencies` e `dev_dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
dev_dependencies:
  [!meta!]: ^1.0.2
```

#### Correções comuns

Remova a entrada em `dev_dependencies` (e a chave `dev_dependencies`
se esse for o único pacote listado lá):

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

### unnecessary_final

_A palavra-chave 'final' não é necessária porque o parâmetro é implicitamente
'final'._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro de inicialização de campo ou um super parâmetro em um construtor tem a palavra-chave `final`.
Em ambos os casos, a palavra-chave é desnecessária porque o parâmetro é
implicitamente `final`.

#### Exemplos

O código a seguir produz este diagnóstico porque o parâmetro de inicialização de campo tem a palavra-chave `final`:

```dart
class A {
  int value;

  A([!final!] this.value);
}
```

O código a seguir produz este diagnóstico porque o super parâmetro em
`B` tem a palavra-chave `final`:

```dart
class A {
  A(int value);
}

class B extends A {
  B([!final!] super.value);
}
```

#### Correções comuns

Remova a palavra-chave `final` desnecessária:

```dart
class A {
  A(int value);
}

class B extends A {
  B(super.value);
}
```

### unnecessary_import {:#unnecessary_import}

_A importação de '{0}' é desnecessária porque todos os elementos usados também
são fornecidos pela importação de '{1}'. _

#### Descrição

O analisador produz este diagnóstico quando uma importação não é necessária porque
todos os nomes que são importados e referenciados dentro da biblioteca de importação
também são visíveis através de outra importação.

#### Exemplo

Dado um arquivo `a.dart` que contém o seguinte:

```dart
class A {}
```

E, dado um arquivo `b.dart` que contém o seguinte:

```dart
export 'a.dart';

class B {}
```

O código a seguir produz este diagnóstico porque a classe `A`, que é
importada de `a.dart`, também é importada de `b.dart`. Removendo a importação
de `a.dart` deixa a semântica inalterada:

```dart
import [!'a.dart'!];
import 'b.dart';

void f(A a, B b) {}
```

#### Correções comuns

Se a importação não for necessária, então remova-a.

Se alguns dos nomes importados por esta importação se destinam a ser usados, mas
ainda não são, e se esses nomes não forem importados por outras importações, então
adicione as referências ausentes a esses nomes.

### unnecessary_nan_comparison {:#unnecessary_nan_comparison}

_Um double não pode ser igual a 'double.nan', então a condição é sempre 'false'._

_Um double não pode ser igual a 'double.nan', então a condição é sempre 'true'._

#### Descrição

O analisador produz este diagnóstico quando um valor é comparado a
`double.nan` usando `==` ou `!=`.

Dart segue o padrão de ponto flutuante [IEEE 754] para a semântica de
operações de ponto flutuante, que afirma que, para qualquer valor de ponto flutuante
`x` (incluindo NaN, infinito positivo e infinito negativo),
- `NaN == x` é sempre falso
- `NaN != x` é sempre verdadeiro

Como resultado, comparar qualquer valor com NaN não tem sentido porque o resultado já é
conhecido (com base no operador de comparação que está sendo usado).

#### Exemplo

O código a seguir produz este diagnóstico porque `d` está sendo comparado
com `double.nan`:

```dart
bool isNaN(double d) => d [!== double.nan!];
```

#### Correções comuns

Use o getter `double.isNaN` em vez disso:

```dart
bool isNaN(double d) => d.isNaN;
```

### unnecessary_non_null_assertion {:#unnecessary_non_null_assertion}

_O '!' não terá efeito porque o receptor não pode ser nulo._

#### Descrição

O analisador produz este diagnóstico quando o operando do operador `!`
não pode ser `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque `x` não pode ser `null`:

```dart
int f(int x) {
  return x[!!!];
}
```

#### Correções comuns

Remova o operador de verificação nula (`!`):

```dart
int f(int x) {
  return x;
}
```

### unnecessary_no_such_method {:#unnecessary_no_such_method}

_Declaração 'noSuchMethod' desnecessária._

#### Descrição

O analisador produz este diagnóstico quando há uma declaração de
`noSuchMethod`, a única coisa que a declaração faz é invocar a
declaração sobreposta, e a declaração sobreposta não é a
declaração em `Object`.

Substituir a implementação de `noSuchMethod` de `Object` (não importa o que
a implementação faça) sinaliza para o analisador que ele não deve sinalizar nenhum
método abstrato herdado que não seja implementado nessa classe. Isso
funciona mesmo se a implementação de sobreposição for herdada de uma superclasse,
portanto, não há valor em declará-la novamente em uma subclasse.

#### Exemplo

O código a seguir produz este diagnóstico porque a declaração de
`noSuchMethod` em `A` torna a declaração de `noSuchMethod` em `B`
desnecessária:

```dart
class A {
  @override
  dynamic noSuchMethod(x) => super.noSuchMethod(x);
}
class B extends A {
  @override
  dynamic [!noSuchMethod!](y) {
    return super.noSuchMethod(y);
  }
}
```

#### Correções comuns

Remova a declaração desnecessária:

```dart
class A {
  @override
  dynamic noSuchMethod(x) => super.noSuchMethod(x);
}
class B extends A {}
```

### unnecessary_null_assert_pattern {:#unnecessary_null_assert_pattern}

_O padrão de null-assert não terá efeito porque o tipo correspondido não é
nullable._

#### Descrição

O analisador produz este diagnóstico quando um padrão de null-assert é usado
para corresponder a um valor que não é nullable.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `x` não é
nullable:

```dart
void f(int x) {
  if (x case var a[!!!] when a > 0) {}
}
```

#### Correções comuns

Remova o padrão de null-assert:

```dart
void f(int x) {
  if (x case var a when a > 0) {}
}
```

### unnecessary_null_check_pattern {:#unnecessary_null_check_pattern}

_O padrão de verificação nula não terá efeito porque o tipo correspondido não é
nullable._

#### Descrição

O analisador produz este diagnóstico quando um padrão de verificação nula é usado para
corresponder a um valor que não é nullable.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor `x` não é
nullable:

```dart
void f(int x) {
  if (x case var a[!?!] when a > 0) {}
}
```

#### Correções comuns

Remova o padrão de verificação nula:

```dart
void f(int x) {
  if (x case var a when a > 0) {}
}
```

### unnecessary_null_comparison {:#unnecessary_null_comparison}

_O operando não pode ser 'null', então a condição é sempre 'false'._

_O operando não pode ser 'null', então a condição é sempre 'true'._

_O operando deve ser 'null', então a condição é sempre 'false'._

_O operando deve ser 'null', então a condição é sempre 'true'._

#### Descrição

O analisador produz este diagnóstico quando encontra uma comparação de igualdade
(seja `==` ou `!=`) com um operando de `null` e o outro operando
não pode ser `null`. Tais comparações são sempre `true` ou `false`, então
não servem a nenhum propósito.

#### Exemplos

O código a seguir produz este diagnóstico porque `x` nunca pode ser
`null`, então a comparação sempre avalia para `true`:

```dart
void f(int x) {
  if (x [!!= null!]) {
    print(x);
  }
}
```

O código a seguir produz este diagnóstico porque `x` nunca pode ser
`null`, então a comparação sempre avalia para `false`:

```dart
void f(int x) {
  if (x [!== null!]) {
    throw ArgumentError("x can't be null");
  }
}
```

#### Correções comuns

Se o outro operando deve poder ser `null`, então altere o tipo do
operando:

```dart
void f(int? x) {
  if (x != null) {
    print(x);
  }
}
```

Se o outro operando realmente não pode ser `null`, então remova a condição:

```dart
void f(int x) {
  print(x);
}
```

### unnecessary_question_mark {:#unnecessary_question_mark}

_O '?' é desnecessário porque '{0}' é nullable sem ele._

#### Descrição

O analisador produz este diagnóstico quando o tipo `dynamic` ou o
tipo `Null` é seguido por um ponto de interrogação. Ambos os tipos são
inerentemente anuláveis, então o ponto de interrogação não altera a semântica.

#### Exemplo

O código a seguir produz este diagnóstico porque o ponto de interrogação
seguindo `dynamic` não é necessário:

```dart
dynamic[!?!] x;
```

#### Correções comuns

Remova o ponto de interrogação desnecessário:

```dart
dynamic x;
```

### unnecessary_set_literal {:#unnecessary_set_literal}

_Chaves envolvem desnecessariamente esta expressão em um literal de conjunto._

#### Descrição

O analisador produz este diagnóstico quando uma função que tem um retorno
tipo de `void`, `Future<void>`, ou `FutureOr<void>` usa uma expressão
corpo da função (`=>`) e o valor retornado é um conjunto literal contendo um
único elemento.

Embora a linguagem permita, retornar um valor de uma função `void`
não é útil porque não pode ser usado no local da chamada. Neste caso particular
o retorno é muitas vezes devido a um mal-entendido sobre a sintaxe. As
chaves não são necessárias e podem ser removidas.

#### Exemplo

O código a seguir produz este diagnóstico porque o closure sendo
passado para `g` tem um tipo de retorno de `void`, mas está retornando um conjunto:

```dart
void f() {
  g(() => [!{1}!]);
}

void g(void Function() p) {}
```

#### Correções comuns

Remova as chaves em torno do valor:

```dart
void f() {
  g(() => 1);
}

void g(void Function() p) {}
```

### unnecessary_type_check {:#unnecessary_type_check}

_Verificação de tipo desnecessária; o resultado é sempre 'false'._

_Verificação de tipo desnecessária; o resultado é sempre 'true'._

#### Descrição

O analisador produz este diagnóstico quando o valor de uma verificação de tipo (usando
`is` ou `is!`) é conhecido em tempo de compilação.

#### Exemplo

O código a seguir produz este diagnóstico porque o teste `a is Object?`
é sempre `true`:

```dart
bool f<T>(T a) => [!a is Object?!];
```

#### Correções comuns

Se a verificação de tipo não verifica o que você pretendia verificar, então altere o
teste:

```dart
bool f<T>(T a) => a is Object;
```

Se a verificação de tipo verificar o que você pretendia verificar, então substitua a
verificação de tipo com seu valor conhecido ou remova-a completamente:

```dart
bool f<T>(T a) => true;
```

### unqualified_reference_to_non_local_static_member {:#unqualified_reference_to_non_local_static_member}

_Membros estáticos de supertipos devem ser qualificados pelo nome do tipo que
os define._

#### Descrição

O analisador produz este diagnóstico quando o código em uma classe referencia um
membro estático em uma superclasse sem prefixar o nome do membro com o
nome da superclasse. Membros estáticos só podem ser referenciados sem um
prefixo na classe em que foram declarados.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo estático `x` é
referenciado no getter `g` sem prefixá-lo com o nome do
classe definidora:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => [!x!];
}
```

#### Correções comuns

Prefixe o nome do membro estático com o nome da classe declaradora:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => A.x;
}
```

### unqualified_reference_to_static_member_of_extended_type {:#unqualified_reference_to_static_member_of_extended_type}

_Membros estáticos do tipo estendido ou de uma de suas superclasses devem ser
qualificados pelo nome do tipo que os define._

#### Descrição

O analisador produz este diagnóstico quando um nome não definido é encontrado, e
o nome é o mesmo que um membro estático do tipo estendido ou de um de seus
superclasses.

#### Exemplo

O código a seguir produz este diagnóstico porque `m` é um membro estático
do tipo estendido `C`:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    [!m!]();
  }
}
```

#### Correções comuns

Se você está tentando referenciar um membro estático que está declarado fora do
extensão, então adicione o nome da classe ou extensão antes da referência
ao membro:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    C.m();
  }
}
```

Se você está referenciando um membro que ainda não foi declarado, adicione uma declaração:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    m();
  }

  void m() {}
}
```

### unreachable_switch_case {:#unreachable_switch_case}

_Este case é coberto pelos cases anteriores._

#### Descrição

O analisador produz este diagnóstico quando uma cláusula `case` em um
declaração `switch` não corresponde a nada porque todos os valores correspondentes são
correspondidos por uma cláusula `case` anterior.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor `1` foi
correspondido no case anterior:

```dart
void f(int x) {
  switch (x) {
    case 1:
      print('one');
    [!case!] 1:
      print('two');
  }
}
```

#### Correções comuns

Altere um ou ambos os cases conflitantes para corresponder a valores diferentes:

```dart
void f(int x) {
  switch (x) {
    case 1:
      print('one');
    case 2:
      print('two');
  }
}
```

### unreachable_switch_default {:#unreachable_switch_default}

_Esta cláusula default é coberta pelos cases anteriores._

#### Descrição

O analisador produz este diagnóstico quando uma cláusula `default` em um
declaração `switch` não corresponde a nada porque todos os valores correspondentes
são correspondidos por uma cláusula `case` anterior.

#### Exemplo

O código a seguir produz este diagnóstico porque os valores `E.e1` e
`E.e2` foram correspondidos nos cases anteriores:

```dart
enum E { e1, e2 }

void f(E x) {
  switch (x) {
    case E.e1:
      print('one');
    case E.e2:
      print('two');
    [!default!]:
      print('other');
  }
}
```

#### Correções comuns

Remova a cláusula `default` desnecessária:

```dart
enum E { e1, e2 }
void f(E x) {
  switch (x) {
    case E.e1:
      print('one');
    case E.e2:
      print('two');
  }
}
```

### unused_catch_clause {:#unused_catch_clause}

_A variável de exceção '{0}' não é usada, então a cláusula 'catch' pode ser removida._

#### Descrição

O analisador produz este diagnóstico quando uma cláusula `catch` é encontrada, e
nem o parâmetro de exceção nem o parâmetro opcional de stack trace são
usados no bloco `catch`.

#### Exemplo

O código a seguir produz este diagnóstico porque `e` não é referenciado:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException catch ([!e!]) {
    // ignorado
  }
}
```

#### Correções comuns

Remova a cláusula `catch` não utilizada:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException {
    // ignorado
  }
}
```

### unused_catch_stack {:#unused_catch_stack}

_A variável de stack trace '{0}' não é usada e pode ser removida._

#### Descrição

O analisador produz este diagnóstico quando o parâmetro de stack trace em um
cláusula `catch` não é referenciada dentro do corpo do bloco `catch`.

#### Exemplo

O código a seguir produz este diagnóstico porque `stackTrace` não é
referenciado:

```dart
void f() {
  try {
    // ...
  } catch (exception, [!stackTrace!]) {
    // ...
  }
}
```

#### Correções comuns

Se você precisar referenciar o parâmetro de stack trace, então adicione uma referência a
ele. Caso contrário, remova-o:

```dart
void f() {
  try {
    // ...
  } catch (exception) {
    // ...
  }
}
```

### unused_element {:#unused_element}

_A declaração '{0}' não é referenciada._

#### Descrição

O analisador produz este diagnóstico quando uma declaração privada não é
referenciada na biblioteca que contém a declaração. Os seguintes
tipos de declarações são analisados:
- Declarações privadas de nível superior e todos os seus membros
- Membros privados de declarações públicas

Nem todas as referências a um elemento o marcarão como "usado":
- Atribuir um valor a uma variável de nível superior (com um padrão `=`
  atribuição, ou uma atribuição `??=` com reconhecimento nulo) não conta como usar
  ela.
- Referir-se a um elemento em uma referência de comentário de documentação não conta como
  usando ele.
- Referir-se a uma classe, mixin ou enum no lado direito de um `is`
  expressão não conta como usá-lo.

#### Exemplo

Assumindo que nenhum código na biblioteca referencia `_C`, o código a seguir
produz este diagnóstico:

```dart
class [!_C!] {}
```

#### Correções comuns

Se a declaração não for necessária, então remova-a.

Se a declaração se destina a ser usada, então adicione o código para usá-la.

### unused_element_parameter {:#unused_element_parameter}

_Um valor para o parâmetro opcional '{0}' nunca é fornecido._

#### Descrição

O analisador produz este diagnóstico quando um valor nunca é passado para um
parâmetro opcional declarado dentro de uma declaração privada.

#### Exemplo

Assumindo que nenhum código na biblioteca passa um valor para `y` em qualquer
invocação de `_m`, o código a seguir produz este diagnóstico:

```dart
class C {
  void _m(int x, [int? [!y!]]) {}

  void n() => _m(0);
}
```

#### Correções comuns

Se a declaração não for necessária, então remova-a:

```dart
class C {
  void _m(int x) {}

  void n() => _m(0);
}
```

Se a declaração se destina a ser usada, então adicione o código para usá-la.

### unused_field {:#unused_field}

_O valor do campo '{0}' não é usado._

#### Descrição

O analisador produz este diagnóstico quando um campo privado é declarado, mas
nunca lido, mesmo que seja escrito em um ou mais lugares.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo
`_originalValue` não é lido em nenhum lugar da biblioteca:

```dart
class C {
  final String [!_originalValue!];
  final String _currentValue;

  C(this._originalValue) : _currentValue = _originalValue;

  String get value => _currentValue;
}
```

Pode parecer que o campo `_originalValue` está sendo lido no
inicializador (`_currentValue = _originalValue`), mas essa é realmente uma
referência ao parâmetro de mesmo nome, não uma referência ao campo.

#### Correções comuns

Se o campo não for necessário, então remova-o.

Se o campo se destinar a ser usado, então adicione o código ausente.

### unused_import {:#unused_import}

_Importação não utilizada: '{0}'. _

#### Descrição

O analisador produz este diagnóstico quando uma importação não é necessária porque
nenhum dos nomes que são importados são referenciados dentro da importação
biblioteca.

#### Exemplo

O código a seguir produz este diagnóstico porque nada definido em
`dart:async` é referenciado na biblioteca:

```dart
import [!'dart:async'!];

void main() {}
```

#### Correções comuns

Se a importação não for necessária, então remova-a.

Se alguns dos nomes importados se destinam a ser usados, então adicione o
código ausente.

### unused_label {:#unused_label}

_O label '{0}' não é usado._

#### Descrição

O analisador produz este diagnóstico quando um label que não é usado é
encontrado.

#### Exemplo

O código a seguir produz este diagnóstico porque o label `loop` não é
referenciado em nenhum lugar do método:

```dart
void f(int limit) {
  [!loop:!] for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

#### Correções comuns

Se o label não for necessário, então remova-o:

```dart
void f(int limit) {
  for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

Se o label for necessário, então use-o:

```dart
void f(int limit) {
  loop: for (int i = 0; i < limit; i++) {
    print(i);
    if (i != 0) {
      break loop;
    }
  }
}
```

### unused_local_variable {:#unused_local_variable}

_O valor da variável local '{0}' não é usado._

#### Descrição

O analisador produz este diagnóstico quando uma variável local é declarada, mas
nunca lida, mesmo que seja escrita em um ou mais lugares.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor de `count` é
nunca lido:

```dart
void main() {
  int [!count!] = 0;
}
```

#### Correções comuns

Se a variável não for necessária, então remova-a.

Se a variável se destinava a ser usada, então adicione o código ausente.

### unused_result {:#unused_result}

_'{0}' deve ser usado. {1}._

_O valor de '{0}' deve ser usado._

#### Descrição

O analisador produz este diagnóstico quando uma função anotada com
[`useResult`][meta-useResult] é invocado, e o valor retornado por essa
função não é usado. O valor é considerado como usado se um membro do
valor é invocado, se o valor é passado para outra função, ou se o
valor é atribuído a uma variável ou campo.

#### Exemplo

O código a seguir produz este diagnóstico porque a invocação de
`c.a()` não é usada, mesmo que o método `a` seja anotado com
[`useResult`][meta-useResult]:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  c.[!a!]();
}
```

#### Correções comuns

Se você pretendia invocar a função anotada, então use o valor que
foi retornado:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  print(c.a());
}
```

Se você pretendia invocar uma função diferente, então corrija o nome da
função que está sendo invocada:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  c.b();
}
```

### unused_shown_name {:#unused_shown_name}

_O nome {0} é mostrado, mas não é usado._

#### Descrição

O analisador produz este diagnóstico quando um combinador `show` inclui um
nome que não é usado dentro da biblioteca. Como não é referenciado, o
nome pode ser removido.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `max`
não é usada:

```dart
import 'dart:math' show min, [!max!];

var x = min(0, 1);
```

#### Correções comuns

Use o nome ou remova-o:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```

### uri_does_not_exist {:#uri_does_not_exist}

_O alvo da URI não existe: '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva `import`, `export` ou
`part` é encontrada onde a URI se refere a um arquivo que não existe.

#### Exemplos

Se o arquivo `lib.dart` não existir, o código a seguir produz este
diagnóstico:

```dart
import [!'lib.dart'!];
```

#### Correções comuns

Se a URI foi digitada incorretamente ou é inválida, corrija a URI.

Se a URI estiver correta, crie o arquivo.

### uri_does_not_exist_in_doc_import {:#uri_does_not_exist_in_doc_import}

_O alvo da URI não existe: '{0}'._

#### Descrição

O analisador produz este diagnóstico quando um doc-import (importação de documentação) é
encontrado onde a URI se refere a um arquivo que não existe.

#### Exemplos

Se o arquivo `lib.dart` não existir, o código a seguir produz este
diagnóstico:

```dart
/// @docImport [!'lib.dart'!];
library;
```

#### Correções comuns

Se a URI foi digitada incorretamente ou é inválida, corrija a URI.

Se a URI estiver correta, crie o arquivo.

### uri_has_not_been_generated {:#uri_has_not_been_generated}

_O alvo da URI não foi gerado: '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva
`import`, `export` ou `part` é encontrada onde a URI se refere a um
arquivo que não existe e o nome do arquivo termina com um padrão
que é comumente produzido por geradores de código, como um dos seguintes:
- `.g.dart`
- `.pb.dart`
- `.pbenum.dart`
- `.pbserver.dart`
- `.pbjson.dart`
- `.template.dart`

#### Exemplo

Se o arquivo `lib.g.dart` não existir, o código a seguir produz este
diagnóstico:

```dart
import [!'lib.g.dart'!];
```

#### Correções comuns

Se o arquivo for um arquivo gerado, execute o gerador que gera o
arquivo.

Se o arquivo não for um arquivo gerado, verifique a ortografia da URI ou
crie o arquivo.

### uri_with_interpolation {:#uri_with_interpolation}

_URIs não podem usar interpolação de strings._

#### Descrição

O analisador produz este diagnóstico quando a string literal em uma diretiva
`import`, `export` ou `part` contém uma interpolação. A resolução das URIs
em diretivas deve ocorrer antes que as declarações sejam compiladas,
portanto, as expressões não podem ser avaliadas ao determinar
os valores das URIs.

#### Exemplo

O código a seguir produz este diagnóstico porque a string na diretiva
`import` contém uma interpolação:

```dart
import [!'dart:$m'!];

const m = 'math';
```

#### Correções comuns

Remova a interpolação da URI:

```dart
import 'dart:math';

var zero = min(0, 0);
```

### use_of_native_extension {:#use_of_native_extension}

_Extensões nativas Dart estão obsoletas e não estão disponíveis no Dart 2.15._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca é importada usando
o esquema `dart-ext`.

#### Exemplo

O código a seguir produz este diagnóstico porque a biblioteca nativa `x` está
sendo importada usando um esquema `dart-ext`:

```dart
import [!'dart-ext:x'!];
```

#### Correções comuns

Reescreva o código para usar `dart:ffi` como uma forma de invocar o conteúdo da biblioteca nativa.

### use_of_void_result {:#use_of_void_result}

_Esta expressão tem um tipo 'void', portanto, seu valor não pode ser usado._

#### Descrição

O analisador produz este diagnóstico quando encontra uma expressão cujo
tipo é `void`, e a expressão é usada em um lugar onde um valor é esperado,
como antes de um acesso a membro ou no lado direito de
uma atribuição.

#### Exemplo

O código a seguir produz este diagnóstico porque `f` não produz um objeto
no qual `toString` pode ser invocado:

```dart
void f() {}

void g() {
  [!f()!].toString();
}
```

#### Correções comuns

Reescreva o código para que a expressão tenha um valor ou reescreva o
código para que ele não dependa do valor.

### values_declaration_in_enum {:#values_declaration_in_enum}

_Um membro chamado 'values' não pode ser declarado em um enum (tipo enumeração)._

#### Descrição

O analisador produz este diagnóstico quando uma declaração de enum define
um membro chamado `values`, seja o membro um valor enum, um membro de
instância ou um membro estático.

Qualquer membro desse tipo entra em conflito com a declaração implícita do
getter (acessor) estático chamado `values` que retorna uma lista contendo
todas as constantes enum.

#### Exemplo

O código a seguir produz este diagnóstico porque o enum `E` define um membro
de instância chamado `values`:

```dart
enum E {
  v;
  void [!values!]() {}
}
```

#### Correções comuns

Altere o nome do membro conflitante:

```dart
enum E {
  v;
  void getValues() {}
}
```

### variable_length_array_not_last {:#variable_length_array_not_last}

_Arrays de comprimento variável devem ocorrer apenas como o último campo de Structs._

#### Descrição

O analisador produz este diagnóstico quando um `Array` (matriz) inline de
comprimento variável não é o último membro de um `Struct` (estrutura).

Para obter mais informações sobre FFI, consulte [C interop using dart:ffi][ffi].

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `a0` tem
um tipo com três matrizes aninhadas, mas apenas duas dimensões são fornecidas
na anotação `Array`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Array.variable()!]
  external Array<Uint8> a0;

  @Uint8()
  external int a1;
}
```

#### Correções comuns

Mova o `Array` inline de comprimento variável para ser o último campo na struct (estrutura).

```dart
import 'dart:ffi';

final class C extends Struct {
  @Uint8()
  external int a1;

  @Array.variable()
  external Array<Uint8> a0;
}
```

Se a matriz inline tiver um tamanho fixo, anote-a com o tamanho:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(10)
  external Array<Uint8> a0;

  @Uint8()
  external int a1;
}
```

### variable_pattern_keyword_in_declaration_context {:#variable_pattern_keyword_in_declaration_context}

_Padrões de variáveis no contexto de declaração não podem especificar a
palavra-chave 'var' ou 'final'._

#### Descrição

O analisador produz este diagnóstico quando um padrão de variável é usado
dentro de um contexto de declaração.

#### Exemplo

O código a seguir produz este diagnóstico porque os padrões de variáveis no
padrão de registro estão em um contexto de declaração:

```dart
void f((int, int) r) {
  var ([!var!] x, y) = r;
  print(x + y);
}
```

#### Correções comuns

Remova as palavras-chave `var` ou `final` dentro do padrão de variável:

```dart
void f((int, int) r) {
  var (x, y) = r;
  print(x + y);
}
```

### variable_type_mismatch {:#variable_type_mismatch}

_Um valor do tipo '{0}' não pode ser atribuído a uma variável const do tipo '{1}'._

#### Descrição

O analisador produz este diagnóstico quando a avaliação de uma expressão constante resultaria em uma `CastException` (exceção de conversão).

#### Exemplo

O código a seguir produz este diagnóstico porque o valor de `x` é um `int`, que não pode ser atribuído a `y` porque um `int` não é uma `String`:

```dart
const dynamic x = 0;
const String y = [!x!];
```

#### Correções comuns

Se a declaração da constante estiver correta, altere o valor que está sendo atribuído para ser do tipo correto:

```dart
const dynamic x = 0;
const String y = '$x';
```

Se o valor atribuído estiver correto, altere a declaração para ter o tipo correto:

```dart
const int x = 0;
const int y = x;
```

### workspace_field_not_list {:#workspace_field_not_list}

_O valor do campo 'workspace' deve ser uma lista de caminhos de arquivos relativos._

#### Descrição

O analisador produz este diagnóstico quando o valor da chave `workspace` não é uma lista.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor da chave `workspace` é uma string quando uma lista é esperada:

```yaml
name: example
workspace: [!notPaths!]
```

#### Correções comuns

Altere o valor do campo de workspace para que seja uma lista:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```

### workspace_value_not_string {:#workspace_value_not_string}

_As entradas de workspace devem ser caminhos de diretórios (strings)._

#### Descrição

O analisador produz este diagnóstico quando uma lista de `workspace` contém um valor que não é uma string.

#### Exemplo

O código a seguir produz este diagnóstico porque a lista `workspace` contém um mapa:

```yaml
name: example
workspace:
    - [!image.gif: true!]
```

#### Correções comuns

Altere a lista de `workspace` para que ela contenha apenas caminhos de diretório válidos no estilo POSIX:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```

### workspace_value_not_subdirectory {:#workspace_value_not_subdirectory}

_Os valores de workspace devem ser um caminho relativo de um subdiretório de '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma lista de `workspace` contém um valor que não é um subdiretório do diretório que contém o arquivo `pubspec.yaml`.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor na lista `workspace` não é um caminho relativo de um subdiretório do diretório que contém o arquivo 'pubspec.yaml':

```yaml
name: example
workspace:
    - /home/my_package
```

#### Correções comuns

Altere a lista de `workspace` para que ela contenha apenas caminhos de subdiretório.

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```

### wrong_number_of_parameters_for_operator {:#wrong_number_of_parameters_for_operator}

_O operador '-' deve declarar 0 ou 1 parâmetro, mas {0} foram encontrados._

_O operador '{0}' deve declarar exatamente {1} parâmetros, mas {2} foram encontrados._

#### Descrição

O analisador produz este diagnóstico quando uma declaração de um operador tem o número errado de parâmetros.

#### Exemplo

O código a seguir produz este diagnóstico porque o operador `+` deve ter um único parâmetro correspondente ao operando direito:

```dart
class C {
  int operator [!+!](a, b) => 0;
}
```

#### Correções comuns

Adicione ou remova parâmetros para corresponder ao número necessário:

```dart
class C {
  int operator +(a) => 0;
}
```

### wrong_number_of_parameters_for_setter {:#wrong_number_of_parameters_for_setter}

_Setters devem declarar exatamente um parâmetro posicional obrigatório._

#### Descrição

O analisador produz este diagnóstico quando um setter é encontrado que não declara exatamente um parâmetro posicional obrigatório.

#### Exemplos

O código a seguir produz este diagnóstico porque o setter `s` declara dois parâmetros obrigatórios:

```dart
class C {
  set [!s!](int x, int y) {}
}
```

O código a seguir produz este diagnóstico porque o setter `s` declara um parâmetro opcional:

```dart
class C {
  set [!s!]([int? x]) {}
}
```

#### Correções comuns

Altere a declaração para que haja exatamente um parâmetro posicional obrigatório:

```dart
class C {
  set s(int x) {}
}
```

### wrong_number_of_type_arguments {:#wrong_number_of_type_arguments}

_O tipo '{0}' é declarado com {1} parâmetros de tipo, mas {2} argumentos de tipo foram fornecidos._

#### Descrição

O analisador produz este diagnóstico quando um tipo que tem parâmetros de tipo é usado e argumentos de tipo são fornecidos, mas o número de argumentos de tipo não é o mesmo que o número de parâmetros de tipo.

O analisador também produz este diagnóstico quando um construtor é invocado e o número de argumentos de tipo não corresponde ao número de parâmetros de tipo declarados para a classe.

#### Exemplos

O código a seguir produz este diagnóstico porque `C` tem um parâmetro de tipo, mas dois argumentos de tipo são fornecidos quando ele é usado como uma anotação de tipo:

```dart
class C<E> {}

void f([!C<int, int>!] x) {}
```

O código a seguir produz este diagnóstico porque `C` declara um parâmetro de tipo, mas dois argumentos de tipo são fornecidos ao criar uma instância:

```dart
class C<E> {}

var c = [!C<int, int>!]();
```

#### Correções comuns

Adicione ou remova argumentos de tipo, conforme necessário, para corresponder ao número de parâmetros de tipo definidos para o tipo:

```dart
class C<E> {}

void f(C<int> x) {}
```

### wrong_number_of_type_arguments_constructor {:#wrong_number_of_type_arguments_constructor}

_O construtor '{0}.{1}' não tem parâmetros de tipo._

#### Descrição

O analisador produz este diagnóstico quando argumentos de tipo são fornecidos após o nome de um construtor nomeado. Construtores não podem declarar parâmetros de tipo, portanto, as invocações só podem fornecer os argumentos de tipo associados à classe, e esses argumentos de tipo devem seguir o nome da classe em vez do nome do construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque os parâmetros de tipo (`<String>`) seguem o nome do construtor em vez do nome da classe:

```dart
class C<T> {
  C.named();
}
C f() => C.named[!<String>!]();
```

#### Correções comuns

Se os argumentos de tipo forem para os parâmetros de tipo da classe, mova os argumentos de tipo para seguir o nome da classe:

```dart
class C<T> {
  C.named();
}
C f() => C<String>.named();
```

Se os argumentos de tipo não forem para os parâmetros de tipo da classe, remova-os:

```dart
class C<T> {
  C.named();
}
C f() => C.named();
```

### wrong_number_of_type_arguments_enum {:#wrong_number_of_type_arguments_enum}

_O enum (tipo enumeração) é declarado com {0} parâmetros de tipo, mas {1} argumentos de tipo foram fornecidos._

#### Descrição

O analisador produz este diagnóstico quando um valor enum em um enum que tem parâmetros de tipo é instanciado e argumentos de tipo são fornecidos, mas o número de argumentos de tipo não é o mesmo que o número de parâmetros de tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o valor enum `c` fornece um argumento de tipo, embora o enum `E` seja declarado para ter dois parâmetros de tipo:

```dart
enum E<T, U> {
  c[!<int>!]()
}
```

#### Correções comuns

Se o número de parâmetros de tipo estiver correto, altere o número de argumentos de tipo para corresponder ao número de parâmetros de tipo:

```dart
enum E<T, U> {
  c<int, String>()
}
```

Se o número de argumentos de tipo estiver correto, altere o número de parâmetros de tipo para corresponder ao número de argumentos de tipo:

```dart
enum E<T> {
  c<int>()
}
```

### wrong_number_of_type_arguments_extension {:#wrong_number_of_type_arguments_extension}

_A extension (extensão) '{0}' é declarada com {1} parâmetros de tipo, mas {2} argumentos de tipo foram fornecidos._

#### Descrição

O analisador produz este diagnóstico quando uma extensão que tem parâmetros de tipo é usada e argumentos de tipo são fornecidos, mas o número de argumentos de tipo não é o mesmo que o número de parâmetros de tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque a extensão `E` é declarada para ter um único parâmetro de tipo (`T`), mas a substituição da extensão tem dois argumentos de tipo:

```dart
extension E<T> on List<T> {
  int get len => length;
}

void f(List<int> p) {
  E[!<int, String>!](p).len;
}
```

#### Correções comuns

Altere os argumentos de tipo para que haja o mesmo número de argumentos de tipo que o número de parâmetros de tipo:

```dart
extension E<T> on List<T> {
  int get len => length;
}

void f(List<int> p) {
  E<int>(p).len;
}
```

### wrong_number_of_type_arguments_method {:#wrong_number_of_type_arguments_method}

_O método '{0}' é declarado com {1} parâmetros de tipo, mas {2} argumentos de tipo são fornecidos._

#### Descrição

O analisador produz este diagnóstico quando um método ou função é invocado com um número diferente de argumentos de tipo do que o número de parâmetros de tipo especificado em sua declaração. Não deve haver argumentos de tipo ou o número de argumentos deve corresponder ao número de parâmetros.

#### Exemplo

O código a seguir produz este diagnóstico porque a invocação do método `m` tem dois argumentos de tipo, mas a declaração de `m` tem apenas um parâmetro de tipo:

```dart
class C {
  int m<A>(A a) => 0;
}

int f(C c) => c.m[!<int, int>!](2);
```

#### Correções comuns

Se os argumentos de tipo forem necessários, faça com que eles correspondam ao número de parâmetros de tipo adicionando ou removendo argumentos de tipo:

```dart
class C {
  int m<A>(A a) => 0;
}

int f(C c) => c.m<int>(2);
```

Se os argumentos de tipo não forem necessários, remova-os:

```dart
class C {
  int m<A>(A a) => 0;
}

int f(C c) => c.m(2);
```

### yield_in_non_generator {:#yield_in_non_generator}

_Instruções Yield devem estar em uma função geradora (uma marcada com 'async*' ou 'sync*')._

_Instruções Yield-each devem estar em uma função geradora (uma marcada com 'async*' ou 'sync*')._

#### Descrição

O analisador produz este diagnóstico quando uma instrução `yield` ou `yield*` aparece em uma função cujo corpo não está marcado com um dos modificadores `async*` ou `sync*`.

#### Exemplos

O código a seguir produz este diagnóstico porque `yield` está sendo usado em uma função cujo corpo não tem um modificador:

```dart
Iterable<int> get digits {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

O código a seguir produz este diagnóstico porque `yield*` está sendo usado em uma função cujo corpo tem o modificador `async` em vez do modificador `async*`:

```dart
Stream<int> get digits async {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

#### Correções comuns

Adicione um modificador ou altere o modificador existente para ser `async*` ou `sync*`:

```dart
Iterable<int> get digits sync* {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

### yield_of_invalid_type {:#yield_of_invalid_type}

_Um valor 'yielded' (produzido) do tipo '{0}' deve ser atribuível a '{1}'._

_O tipo '{0}' implícito pela expressão 'yield*' deve ser atribuível a '{1}'._

#### Descrição

O analisador produz este diagnóstico quando o tipo de objeto produzido por uma expressão `yield` ou `yield*` não corresponde ao tipo de objetos que devem ser retornados dos tipos `Iterable` ou `Stream` que são retornados de um gerador (uma função ou método marcado com `sync*` ou `async*`).

#### Exemplo

O código a seguir produz este diagnóstico porque o getter `zero` é declarado para retornar um `Iterable` que retorna inteiros, mas o `yield` está retornando uma string do iterável:

```dart
Iterable<int> get zero sync* {
  yield [!'0'!];
}
```

#### Correções comuns

Se o tipo de retorno da função estiver correto, corrija a expressão após a palavra-chave `yield` para retornar o tipo correto:

```dart
Iterable<int> get zero sync* {
  yield 0;
}
```

Se a expressão após o `yield` estiver correta, altere o tipo de retorno da função para permiti-lo:

```dart
Iterable<String> get zero sync* {
  yield '0';
}
```

### always_declare_return_types {:#always_declare_return_types}

_A função '{0}' deve ter um tipo de retorno, mas não tem._

_O método '{0}' deve ter um tipo de retorno, mas não tem._

#### Descrição

O analisador produz este diagnóstico quando um método ou função não tem um tipo de retorno explícito.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f` não tem um tipo de retorno:

```dart
[!f!]() {}
```

#### Correções comuns

Adicione um tipo de retorno explícito:

```dart
void f() {}
```

### always_put_control_body_on_new_line {:#always_put_control_body_on_new_line}

_A instrução deve estar em uma linha separada._

#### Descrição

O analisador produz este diagnóstico quando o código sendo controlado por uma instrução de fluxo de controle (`if`, `for`, `while` ou `do`) está na mesma linha que a instrução de fluxo de controle.

#### Exemplo

O código a seguir produz este diagnóstico porque a instrução `return` está na mesma linha que o `if` que controla se o `return` será executado:

```dart
void f(bool b) {
  if (b) [!return!];
}
```

#### Correções comuns

Coloque a instrução controlada em uma linha separada e recuada:

```dart
void f(bool b) {
  if (b)
    return;
}
```

### always_put_required_named_parameters_first {:#always_put_required_named_parameters_first}

_Parâmetros nomeados obrigatórios devem estar antes dos parâmetros nomeados opcionais._

#### Descrição

O analisador produz este diagnóstico quando parâmetros nomeados obrigatórios ocorrem após parâmetros nomeados opcionais.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro obrigatório `x` está após o parâmetro opcional `y`:

```dart
void f({int? y, required int [!x!]}) {}
```

#### Correções comuns

Reordene os parâmetros para que todos os parâmetros nomeados obrigatórios estejam antes de quaisquer parâmetros nomeados opcionais:

```dart
void f({required int x, int? y}) {}
```

### always_use_package_imports {:#always_use_package_imports}

_Use imports 'package:' para arquivos no diretório 'lib'._

#### Descrição

O analisador produz este diagnóstico quando um `import` em uma biblioteca dentro do diretório `lib` usa um caminho relativo para importar outra biblioteca dentro do diretório `lib` do mesmo pacote.

#### Exemplo

Dado que um arquivo chamado `a.dart` e o código abaixo estão ambos dentro do diretório `lib` do mesmo pacote, o código a seguir produz este diagnóstico porque uma URI relativa é usada para importar `a.dart`:

```dart
import [!'a.dart'!];
```

#### Correções comuns

Use um import de pacote:

```dart
import 'package:p/a.dart';
```

### annotate_overrides {:#annotate_overrides}

_O membro '{0}' sobrescreve um membro herdado, mas não está anotado com '@override'._

#### Descrição

O analisador produz este diagnóstico quando um membro sobrescreve um membro herdado, mas não é anotado com `@override`.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `m` na classe `B` sobrescreve o método com o mesmo nome na classe `A`, mas não está marcado como uma sobrescrita intencional:

```dart
class A {
  void m() {}
}

class B extends A {
  void [!m!]() {}
}
```

#### Correções comuns

Se o membro na subclasse tiver a intenção de substituir o membro na superclasse, adicione uma anotação `@override`:

```dart
class A {
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```

Se o membro na subclasse não tiver a intenção de sobrescrever o membro na superclasse, renomeie um dos membros:

```dart
class A {
  void m() {}
}

class B extends A {
  void m2() {}
}
```

### avoid_empty_else {:#avoid_empty_else}

_Instruções vazias não são permitidas em uma cláusula 'else'._

#### Descrição

O analisador produz este diagnóstico quando a instrução após um `else` é uma instrução vazia (um ponto e vírgula).

Para obter mais informações, consulte a documentação para
[`avoid_empty_else`](https://dartbrasil.dev/diagnostics/avoid_empty_else).

#### Exemplo

O código a seguir produz este diagnóstico porque a instrução após o `else` é uma instrução vazia:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  else [!;!]
    print("2");
}
```

#### Correções comuns

Se a instrução após a instrução vazia tiver a intenção de ser executada somente quando a condição for `false`, remova a instrução vazia:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  else
    print("2");
}
```

Se não houver código que deva ser executado somente quando a condição for `false`, remova toda a cláusula `else`:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  print("2");
}
```

### avoid_function_literals_in_foreach_calls {:#avoid_function_literals_in_foreach_calls}

_Funções literais não devem ser passadas para 'forEach'._

#### Descrição

O analisador produz este diagnóstico quando o argumento para `Iterable.forEach` é um closure (função anônima).

#### Exemplo

O código a seguir produz este diagnóstico porque o argumento para a invocação de `forEach` é um closure:

```dart
void f(Iterable<String> s) {
  s.[!forEach!]((e) => print(e));
}
```

#### Correções comuns

Se o closure puder ser substituído por um tear-off (extração de método), substitua o closure:

```dart
void f(Iterable<String> s) {
  s.forEach(print);
}
```

Se o closure não puder ser substituído por um tear-off, use um loop `for` para iterar sobre os elementos:

```dart
void f(Iterable<String> s) {
  for (var e in s) {
    print(e);
  }
}
```

### avoid_futureor_void {:#avoid_futureor_void}

_Não use o tipo 'FutureOr<void>'._

#### Descrição

O analisador produz este diagnóstico quando o tipo `FutureOr<void>`
é usado como o tipo de um resultado (para ser preciso: é usado em
uma posição que não é contravariante). O tipo `FutureOr<void>` é
problemático porque pode parecer codificar que um resultado é
`Future<void>`, ou o resultado deve ser descartado (quando é `void`).
No entanto, não há maneira segura de detectar se temos um ou
outro caso, porque uma expressão do tipo `void` pode ser avaliada
para qualquer objeto, incluindo um futuro de qualquer tipo.

Também é conceitualmente incorreto ter um tipo cujo significado
é algo como "ignore este objeto; além disso, dê uma
olhada porque pode ser um futuro".

Uma exceção é feita para ocorrências contravariantes do
tipo `FutureOr<void>` (por exemplo, para o tipo de um
parâmetro formal), e nenhum aviso é emitido para essas
ocorrências. O motivo dessa exceção é que o tipo não
descreve um resultado, ele descreve uma restrição em um
valor fornecido por outros. Da mesma forma, uma exceção
é feita para declarações de alias de tipo, porque elas podem ser usadas em uma
posição contravariante (por exemplo, como o tipo de um parâmetro formal).
Portanto, em declarações de alias de tipo, apenas os limites dos parâmetros de tipo são verificados.

#### Exemplo

```dart
import 'dart:async';

[!FutureOr<void>!] m() => null;
```

#### Correções comuns

Uma substituição para o tipo `FutureOr<void>` que costuma ser útil é `Future<void>?`. Este tipo codifica que um resultado é um `Future<void>` ou é nulo, e não há ambiguidade em tempo de execução, pois nenhum objeto pode ter ambos os tipos.

Pode nem sempre ser possível usar o tipo `Future<void>?` como um substituto para o tipo `FutureOr<void>`, porque o último é um supertipo de todos os tipos, e o primeiro não. Neste caso, pode ser um remédio útil substituir `FutureOr<void>` pelo tipo `void`.

### avoid_init_to_null {:#avoid_init_to_null}

_Inicialização redundante para 'null'._

#### Descrição

O analisador produz este diagnóstico quando uma variável anulável é explicitamente inicializada como `null`. A variável pode ser uma variável local, um campo ou uma variável de nível superior.

Uma variável ou campo que não é explicitamente inicializado é inicializado automaticamente como `null`. Não existe o conceito de "memória não inicializada" no Dart.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `f` é explicitamente inicializada como `null`:

```dart
class C {
  int? [!f = null!];

  void m() {
    if (f != null) {
      print(f);
    }
  }
}
```

#### Correções comuns

Remova a inicialização desnecessária:

```dart
class C {
  int? f;

  void m() {
    if (f != null) {
      print(f);
    }
  }
}
```

### avoid_print {:#avoid_print}

_Não invoque 'print' em código de produção._

#### Descrição

O analisador produz este diagnóstico quando a função `print` é invocada em código de produção.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `print` não pode ser invocada em produção:

```dart
void f(int x) {
  [!print!]('x = $x');
}
```

#### Correções comuns

Se você estiver escrevendo código que usa o Flutter, use a função [`debugPrint`][debugPrint], protegida por um teste usando [`kDebugMode`][kDebugMode]:

```dart
import 'package:flutter/foundation.dart';

void f(int x) {
  if (kDebugMode) {
    debugPrint('x = $x');
  }
}
```

Se você estiver escrevendo código que não usa o Flutter, use um serviço de log, como [`package:logging`][package-logging], para gravar as informações.

### avoid_relative_lib_imports {:#avoid_relative_lib_imports}

_Não é possível usar um caminho relativo para importar uma biblioteca em 'lib'._

#### Descrição

O analisador produz este diagnóstico quando a URI em uma diretiva `import` tem `lib` no caminho.

#### Exemplo

Supondo que haja um arquivo chamado `a.dart` no diretório `lib`:

```dart
class A {}
```

O código a seguir produz este diagnóstico porque o import contém um caminho que inclui `lib`:

```dart
import [!'../lib/a.dart'!];
```

#### Correções comuns

Reescreva o import para não incluir `lib` na URI:

```dart
import 'a.dart';
```

### avoid_renaming_method_parameters {:#avoid_renaming_method_parameters}

_O nome do parâmetro '{0}' não corresponde ao nome '{1}' no método sobrescrito._

#### Descrição

O analisador produz este diagnóstico quando um método que sobrescreve um método de uma superclasse altera os nomes dos parâmetros.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro do método `m` em `B` é nomeado `b`, que é diferente do nome do parâmetro do método sobrescrito em `A`:

```dart
class A {
  void m(int a) {}
}

class B extends A {
  @override
  void m(int [!b!]) {}
}
```

#### Correções comuns

Renomeie um dos parâmetros para que eles sejam iguais:

```dart
class A {
  void m(int a) {}
}

class B extends A {
  @override
  void m(int a) {}
}
```

### avoid_return_types_on_setters {:#avoid_return_types_on_setters}

_Tipo de retorno desnecessário em um setter._

#### Descrição

O analisador produz este diagnóstico quando um setter tem um tipo de
retorno explícito.

Setters nunca retornam um valor, então declarar o tipo de retorno de um é
redundante.

#### Exemplo

O código a seguir produz este diagnóstico porque o setter `s` tem um tipo
de retorno explícito (`void`):

```dart
[!void!] set s(int p) {}
```

#### Correções comuns

Remova o tipo de retorno:

```dart
set s(int p) {}
```

### avoid_returning_null_for_void {:#avoid_returning_null_for_void}

_Não retorne 'null' de uma função com um tipo de retorno 'void'._

_Não retorne 'null' de um método com um tipo de retorno 'void'._

#### Descrição

O analisador produz este diagnóstico quando uma função que tem um tipo de
retorno `void` retorna explicitamente `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque há um retorno explícito
de `null` em uma função `void`:

```dart
void f() {
  [!return null;!]
}
```

#### Correções comuns

Remova o `null` explícito desnecessário:

```dart
void f() {
  return;
}
```

### avoid_shadowing_type_parameters {:#avoid_shadowing_type_parameters}

_O parâmetro de tipo '{0}' sombreia um parâmetro de tipo do {1} envolvente._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro de tipo sombreia
um parâmetro de tipo de uma declaração envolvente.

Sombrear um parâmetro de tipo com um parâmetro de tipo diferente pode
levar a bugs sutis que são difíceis de depurar.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
definido pelo método `m` sombreia o parâmetro de tipo `T` definido pela
classe `C`:

```dart
class C<T> {
  void m<[!T!]>() {}
}
```

#### Correções comuns

Renomeie um dos parâmetros de tipo:

```dart
class C<T> {
  void m<S>() {}
}
```

### avoid_single_cascade_in_expression_statements {:#avoid_single_cascade_in_expression_statements}

_Expressão em cascata desnecessária._

#### Descrição

O analisador produz este diagnóstico quando um único operador de cascata é
usado e o valor da expressão não está sendo usado para nada (como sendo
atribuído a uma variável ou sendo passado como um argumento).

#### Exemplo

O código a seguir produz este diagnóstico porque o valor da expressão em
cascata `s..length` não está sendo usado:

```dart
void f(String s) {
  [!s..length!];
}
```

#### Correções comuns

Substitua o operador de cascata por um operador de acesso simples:

```dart
void f(String s) {
  s.length;
}
```

### avoid_slow_async_io {:#avoid_slow_async_io}

_Uso de um método async 'dart:io'._

#### Descrição

O analisador produz este diagnóstico quando um método assíncrono de E/S
de arquivo com um equivalente síncrono é usado.

Os seguintes são os métodos assíncronos específicos sinalizados:

- `Directory.exists`
- `Directory.stat`
- `File.lastModified`
- `File.exists`
- `File.stat`
- `FileSystemEntity.isDirectory`
- `FileSystemEntity.isFile`
- `FileSystemEntity.isLink`
- `FileSystemEntity.type`

#### Exemplo

O código a seguir produz este diagnóstico porque o método async `exists` é
invocado:

```dart
import 'dart:io';

Future<void> g(File f) async {
  await [!f.exists()!];
}
```

#### Correções comuns

Use a versão síncrona do método:

```dart
import 'dart:io';

void g(File f) {
  f.existsSync();
}
```

### avoid_type_to_string {:#avoid_type_to_string}

_Usar 'toString' em um 'Type' não é seguro em código de produção._

#### Descrição

O analisador produz este diagnóstico quando o método `toString` é
invocado em um valor cujo tipo estático é `Type` (tipo).

#### Exemplo

O código a seguir produz este diagnóstico porque o método `toString` é
invocado no `Type` (tipo) retornado por `runtimeType`:

```dart
bool isC(Object o) => o.runtimeType.[!toString!]() == 'C';

class C {}
```

#### Correções comuns

Se for essencial que o tipo seja exatamente o mesmo, use uma comparação
explícita:

```dart
bool isC(Object o) => o.runtimeType == C;

class C {}
```

Se for aceitável que instâncias de subtipos do tipo retornem `true`, use
uma verificação de tipo:

```dart
bool isC(Object o) => o is C;

class C {}
```

### avoid_types_as_parameter_names {:#avoid_types_as_parameter_names}

_O nome do parâmetro '{0}' corresponde a um nome de tipo visível._

#### Descrição

O analisador produz este diagnóstico quando o nome de um parâmetro em uma
lista de parâmetros é o mesmo que um tipo visível (um tipo cujo nome está
no escopo).

Isso geralmente indica que o nome pretendido do parâmetro está faltando,
fazendo com que o nome do tipo seja usado como o nome do parâmetro em vez
do tipo do parâmetro. Mesmo quando esse não é o caso (o nome do parâmetro
é intencional), o nome do parâmetro sombreará o tipo existente, o que pode
levar a bugs difíceis de diagnosticar.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f` tem um
parâmetro chamado `int`, que sombreia o tipo `int` de `dart:core`:

```dart
void f([!int!]) {}
```

#### Correções comuns

Se o nome do parâmetro estiver faltando, adicione um nome para o
parâmetro:

```dart
void f(int x) {}
```

Se o parâmetro se destina a ter um tipo implícito de `dynamic`, renomeie o
parâmetro para que ele não sombreie o nome de nenhum tipo visível:

```dart
void f(int_) {}
```

### avoid_unnecessary_containers {:#avoid_unnecessary_containers}

_Instância desnecessária de 'Container' (Contâiner)._

#### Descrição

O analisador produz este diagnóstico quando uma árvore de widgets
(componentes de tela) contém uma instância de `Container` e o único
argumento para o construtor é `child:`.

#### Exemplo

O código a seguir produz este diagnóstico porque a invocação do construtor
`Container` tem apenas um argumento `child:`:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return [!Container!](
    child: Row(
      children: [
        Text('a'),
        Text('b'),
      ],
    )
  );
}
```

#### Correções comuns

Se você pretendia fornecer outros argumentos para o construtor, adicione-os:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Container(
    color: Colors.red.shade100,
    child: Row(
      children: [
        Text('a'),
        Text('b'),
      ],
    )
  );
}
```

Se nenhum outro argumento for necessário, desempacote o widget filho:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: [
      Text('a'),
      Text('b'),
    ],
  );
}
```

### avoid_web_libraries_in_flutter {:#avoid_web_libraries_in_flutter}

_Não use bibliotecas somente da web fora dos plugins Flutter web._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca em um pacote
que não é um plugin web contém uma importação de uma biblioteca somente
web:
- `dart:html`
- `dart:js`
- `dart:js_util`
- `dart:js_interop`
- `dart:js_interop_unsafe`
- `package:js`
- `package:web`

#### Exemplo

Quando encontrado em um pacote que não é um plugin web, o código a seguir
produz este diagnóstico porque importa `dart:html`:

```dart
import [!'dart:html'!];

import 'package:flutter/material.dart';

class C {}
```

#### Correções comuns

Se o pacote não se destina a ser um plugin web, remova a importação:

```dart
import 'package:flutter/material.dart';

class C {}
```

Se o pacote se destina a ser um plugin web, adicione as seguintes linhas
ao arquivo `pubspec.yaml` do pacote:

```yaml
flutter:
  plugin:
    platforms:
      web:
        pluginClass: HelloPlugin
        fileName: hello_web.dart
```

Consulte [Desenvolvendo pacotes e plugins](https://flutter.dev/to/develop-packages)
para mais informações.

### await_only_futures {:#await_only_futures}

_Usa 'await' em uma instância de '{0}', que não é um subtipo de 'Future'._

#### Descrição

O analisador produz este diagnóstico quando a expressão após `await` tem
qualquer tipo diferente de `Future<T>`, `FutureOr<T>`, `Future<T>?`,
`FutureOr<T>?` ou `dynamic`.

Uma exceção é feita para a expressão `await null` porque é uma maneira
comum de introduzir um atraso de microtarefa.

A menos que a expressão possa produzir um `Future` (objeto assíncrono), o
`await` é desnecessário e pode fazer com que um leitor assuma um nível de
assincronia que não existe.

#### Exemplo

O código a seguir produz este diagnóstico porque a expressão após `await`
tem o tipo `int`:

```dart
void f() async {
  [!await!] 23;
}
```

#### Correções comuns

Remova o `await`:

```dart
void f() async {
  23;
}
```

### camel_case_extensions {:#camel_case_extensions}

_O nome da extensão '{0}' não é um identificador UpperCamelCase._

#### Descrição

O analisador produz este diagnóstico quando o nome de uma extensão não usa
a convenção de nomenclatura 'UpperCamelCase'.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome da extensão não
começa com uma letra maiúscula:

```dart
extension [!stringExtension!] on String {}
```

#### Correções comuns

Se a extensão precisar ter um nome (precisa ser visível fora desta
biblioteca), renomeie a extensão para que ela tenha um nome válido:

```dart
extension StringExtension on String {}
```

Se a extensão não precisar ter um nome, remova o nome da extensão:

```dart
extension on String {}
```

### camel_case_types {:#camel_case_types}

_O nome do tipo '{0}' não é um identificador UpperCamelCase._

#### Descrição

O analisador produz este diagnóstico quando o nome de um tipo (uma classe,
mixin, enum ou typedef) não usa a convenção de nomenclatura
'UpperCamelCase'.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome da classe não
começa com uma letra maiúscula:

```dart
class [!c!] {}
```

#### Correções comuns

Renomeie o tipo para que ele tenha um nome válido:

```dart
class C {}
```

### cancel_subscriptions {:#cancel_subscriptions}

_Instância não cancelada de 'StreamSubscription' (Assinatura de fluxo)._

#### Descrição

O analisador produz este diagnóstico quando uma instância de
`StreamSubscription` é criada, mas o método `cancel` não é invocado.

#### Exemplo

O código a seguir produz este diagnóstico porque a `subscription` (assinatura)
não é cancelada:

```dart
import 'dart:async';

void f(Stream stream) {
  // ignore: unused_local_variable
  var [!subscription = stream.listen((_) {})!];
}
```

#### Correções comuns

Cancele a assinatura:

```dart
import 'dart:async';

void f(Stream stream) {
  var subscription = stream.listen((_) {});
  subscription.cancel();
}
```

### close_sinks {:#close_sinks}

_Instância não fechada de 'Sink' (Ponto de coleta)._

#### Descrição

O analisador produz este diagnóstico quando uma instância de `Sink` (ponto
de coleta) é criada, mas o método `close` (fechar) não é invocado.

#### Exemplo

O código a seguir produz este diagnóstico porque o `sink` (ponto de
coleta) não está fechado:

```dart
import 'dart:io';

void g(File f) {
  var [!sink = f.openWrite()!];
  sink.write('x');
}
```

#### Correções comuns

Feche o ponto de coleta:

```dart
import 'dart:io';

void g(File f) {
  var sink = f.openWrite();
  sink.write('x');
  sink.close();
}
```

### collection_methods_unrelated_type {:#collection_methods_unrelated_type}

_O tipo de argumento '{0}' não está relacionado a '{1}'._

#### Descrição

O analisador produz este diagnóstico quando qualquer um dos vários
métodos nas bibliotecas principais são invocados com argumentos de um tipo
inapropriado. Esses métodos são aqueles que não fornecem um tipo
específico o suficiente para o parâmetro para permitir que a verificação
de tipo normal detecte o erro.

Os argumentos que são verificados são:
- um argumento para `Iterable<E>.contains` deve estar relacionado a `E`
- um argumento para `List<E>.remove` deve estar relacionado a `E`
- um argumento para `Map<K, V>.containsKey` deve estar relacionado a `K`
- um argumento para `Map<K, V>.containsValue` deve estar relacionado a `V`
- um argumento para `Map<K, V>.remove` deve estar relacionado a `K`
- um argumento para `Map<K, V>.[]` deve estar relacionado a `K`
- um argumento para `Queue<E>.remove` deve estar relacionado a `E`
- um argumento para `Set<E>.lookup` deve estar relacionado a `E`
- um argumento para `Set<E>.remove` deve estar relacionado a `E`

#### Exemplo

O código a seguir produz este diagnóstico porque o argumento para
`contains` é uma `String`, que não é atribuível a `int`, o tipo de
elemento da lista `l`:

```dart
bool f(List<int> l)  => l.contains([!'1'!]);
```

#### Correções comuns

Se o tipo de elemento estiver correto, altere o argumento para ter o
mesmo tipo:

```dart
bool f(List<int> l)  => l.contains(1);
```

Se o tipo de argumento estiver correto, altere o tipo de elemento:

```dart
bool f(List<String> l)  => l.contains('1');
```

### constant_identifier_names {:#constant_identifier_names}

_O nome da constante '{0}' não é um identificador lowerCamelCase._

#### Descrição

O analisador produz este diagnóstico quando o nome de uma constante não
segue a convenção de nomenclatura lowerCamelCase.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome da variável de
nível superior não é um identificador lowerCamelCase:

```dart
const [!EMPTY_STRING!] = '';
```

#### Correções comuns

Reescreva o nome para seguir a convenção de nomenclatura lowerCamelCase:

```dart
const emptyString = '';
```

### control_flow_in_finally {:#control_flow_in_finally}

_Uso de '{0}' em uma cláusula 'finally'._

#### Descrição

O analisador produz este diagnóstico quando uma cláusula `finally` contém
uma instrução `return`, `break` ou `continue`.

#### Exemplo

O código a seguir produz este diagnóstico porque há uma instrução `return`
dentro de um bloco `finally`:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  } finally {
    [!return 0;!]
  }
}
```

#### Correções comuns

Se a instrução não for necessária, remova a instrução e remova a cláusula
`finally` se o bloco estiver vazio:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  }
}
```

Se a instrução for necessária, mova a instrução para fora do bloco
`finally`:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  }
  return 0;
}
```

### curly_braces_in_flow_control_structures {:#curly_braces_in_flow_control_structures}

_As instruções em {0} devem ser incluídas em um bloco._

#### Descrição

O analisador produz este diagnóstico quando uma estrutura de controle
(instrução `if`, `for`, `while` ou `do`) tem uma instrução diferente de
um bloco.

#### Exemplo

O código a seguir produz este diagnóstico porque a instrução `then` não
está incluída em um bloco:

```dart
int f(bool b) {
  if (b)
    [!return 1;!]
  return 0;
}
```

#### Correções comuns

Adicione chaves em torno da instrução que deve ser um bloco:

```dart
int f(bool b) {
  if (b) {
    return 1;
  }
  return 0;
}
```

### dangling_library_doc_comments {:#dangling_library_doc_comments}

_Comentário de documentação de biblioteca pendente._

#### Descrição

O analisador produz este diagnóstico quando um comentário de documentação
que parece ser documentação de biblioteca não é seguido por uma diretiva
`library` (biblioteca). Mais especificamente, ele é produzido quando um
comentário de documentação aparece antes da primeira diretiva na
biblioteca, assumindo que não é uma diretiva `library`, ou antes da
primeira declaração de nível superior e é separado da declaração por uma
ou mais linhas em branco.

#### Exemplo

O código a seguir produz este diagnóstico porque há um comentário de
documentação antes da primeira diretiva `import`:

```dart
[!/// Esta é uma ótima biblioteca.!]
import 'dart:core';
```

O código a seguir produz este diagnóstico porque há um comentário de
documentação antes da primeira declaração de classe, mas há uma linha em
branco entre o comentário e a declaração.

```dart
[!/// Esta é uma ótima biblioteca.!]

class C {}
```

#### Correções comuns

Se o comentário for documentação da biblioteca, adicione uma diretiva
`library` sem um nome:

```dart
/// Esta é uma ótima biblioteca.
library;

import 'dart:core';
```

Se o comentário for documentação para a seguinte declaração, remova a
linha em branco:

```dart
/// Esta é uma ótima biblioteca.
class C {}
```

### depend_on_referenced_packages {:#depend_on_referenced_packages}

_O pacote importado '{0}' não é uma dependência do pacote importador._

#### Descrição

O analisador produz este diagnóstico quando uma importação de pacote se
refere a um pacote que não é especificado no arquivo `pubspec.yaml`.

Depender explicitamente de pacotes aos quais você se refere garante que
eles sempre existirão e permite que você coloque uma restrição de
dependência sobre eles para se proteger contra alterações que quebrem o
código.

#### Exemplo

Dado um arquivo `pubspec.yaml` contendo o seguinte:

```yaml
dependencies:
  meta: ^3.0.0
```

O código a seguir produz este diagnóstico porque não há dependência do
pacote `a`:

```dart
import 'package:a/a.dart';
```

#### Correções comuns

Se a dependência deve ser uma dependência regular ou uma dependência de
desenvolvimento depende se o pacote é referenciado de uma biblioteca
pública (uma em `lib` ou `bin`), ou apenas bibliotecas privadas (como uma
em `test`).

Se o pacote for referenciado de pelo menos uma biblioteca pública,
adicione uma dependência regular no pacote ao arquivo `pubspec.yaml` sob o
campo `dependencies`:

```yaml
dependencies:
  a: ^1.0.0
  meta: ^3.0.0
```

Se o pacote for referenciado apenas de bibliotecas privadas, adicione uma
dependência de desenvolvimento no pacote ao arquivo `pubspec.yaml` sob o
campo `dev_dependencies`:

```yaml
dependencies:
  meta: ^3.0.0
dev_dependencies:
  a: ^1.0.0
```

### empty_catches {:#empty_catches}

_Bloco catch vazio._

#### Descrição

O analisador produz este diagnóstico quando o bloco em uma cláusula
`catch` está vazio.

#### Exemplo

O código a seguir produz este diagnóstico porque o bloco catch está vazio:

```dart
void f() {
  try {
    print('Olá');
  } catch (exception) [!{}!]
}
```

#### Correções comuns

Se a exceção não deve ser ignorada, adicione código para lidar com a
exceção:

```dart
void f() {
  try {
    print('Podemos imprimir.');
  } catch (exception) {
    print('Não podemos imprimir.');
  }
}
```

Se a exceção deve ser ignorada, adicione um comentário explicando o
porquê:

```dart
void f() {
  try {
    print('Podemos imprimir.');
  } catch (exception) {
    // Nada a fazer.
  }
}
```

Se a exceção deve ser ignorada e não houver uma boa explicação do porquê,
renomeie o parâmetro de exceção:

```dart
void f() {
  try {
    print('Podemos imprimir.');
  } catch (_) {}
}
```

### empty_constructor_bodies {:#empty_constructor_bodies}

_Corpos de construtores vazios devem ser escritos usando ';' em vez de '{}'._

#### Descrição

O analisador produz este diagnóstico quando um construtor tem um corpo de
bloco vazio.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor para `C` tem
um corpo de bloco que está vazio:

```dart
class C {
  C() [!{}!]
}
```

#### Correções comuns

Substitua o bloco por um ponto e vírgula:

```dart
class C {
  C();
}
```

### empty_statements {:#empty_statements}

_Instrução vazia desnecessária._

#### Descrição

O analisador produz este diagnóstico quando uma instrução vazia é
encontrada.

#### Exemplo

O código a seguir produz este diagnóstico porque a instrução controlada
pelo loop `while` é uma instrução vazia:

```dart
void f(bool condition) {
  while (condition)[!;!]
    g();
}

void g() {}
```

#### Correções comuns

Se não houver instruções que precisem ser controladas, remova tanto a
instrução vazia quanto a estrutura de controle da qual ela faz parte
(tendo cuidado para que qualquer outro código que esteja sendo removido não
tenha um efeito colateral que precise ser preservado):

```dart
void f(bool condition) {
  g();
}

void g() {}
```

Se não houver instruções que precisem ser controladas, mas a estrutura de
controle ainda for necessária por outros motivos, substitua a instrução
vazia por um bloco para tornar a estrutura do código mais óbvia:

```dart
void f(bool condition) {
  while (condition) {}
  g();
}

void g() {}
```

Se houver instruções que precisam ser controladas, remova a instrução
vazia e ajuste o código para que as instruções apropriadas sejam
controladas, possivelmente adicionando um bloco:

```dart
void f(bool condition) {
  while (condition) {
    g();
  }
}

void g() {}
```

### file_names {:#file_names}

_O nome do arquivo '{0}' não é um identificador lower\_case\_with\_underscores._

#### Descrição

O analisador produz este diagnóstico quando o nome de um arquivo `.dart`
não usa lower_case_with_underscores (minúsculas com underscores).

#### Exemplo

Um arquivo chamado `SliderMenu.dart` produz este diagnóstico porque o
nome do arquivo usa a convenção UpperCamelCase.

#### Correções comuns

Renomeie o arquivo para usar a convenção lower_case_with_underscores,
como `slider_menu.dart`.

### hash_and_equals {:#hash_and_equals}

_Faltando uma substituição correspondente de '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma classe ou mixin
substitui a definição de `==`, mas não substitui a definição de
`hashCode`, ou vice-versa, substitui a definição de `hashCode`, mas não
substitui a definição de `==`.

Tanto o operador `==` quanto a propriedade `hashCode` dos objetos devem
ser consistentes para que uma implementação de mapa hash comum funcione
corretamente. Como resultado, ao substituir qualquer um dos métodos, ambos
devem ser substituídos.

#### Exemplo

O código a seguir produz este diagnóstico porque a classe `C` substitui o
operador `==`, mas não substitui o getter `hashCode`:

```dart
class C {
  final int value;

  C(this.value);

  @override
  bool operator [!==!](Object other) =>
      other is C &&
      other.runtimeType == runtimeType &&
      other.value == value;
}
```

#### Correções comuns

Se você precisar substituir um dos membros, adicione uma substituição do
outro:

```dart
class C {
  final int value;

  C(this.value);

  @override
  bool operator ==(Object other) =>
      other is C &&
      other.runtimeType == runtimeType &&
      other.value == value;

  @override
  int get hashCode => value.hashCode;
}
```

Se você não precisar substituir nenhum dos membros, remova a substituição
desnecessária:

```dart
class C {
  final int value;

  C(this.value);
}
```

### implementation_imports {:#implementation_imports}

_Importação de uma biblioteca no diretório 'lib/src' de outro pacote._

#### Descrição

O analisador produz este diagnóstico quando uma importação faz referência
a uma biblioteca que está dentro do diretório `lib/src` de um pacote
diferente, o que viola [a convenção para pacotes pub](https://dartbrasil.dev/tools/pub/package-layout#implementation-files).

#### Exemplo

O código a seguir, assumindo que não faz parte do pacote `ffi`, produz
este diagnóstico porque a biblioteca que está sendo importada está dentro
do diretório `src` de nível superior:

```dart
import [!'package:ffi/src/allocation.dart'!];
```

#### Correções comuns

Se a biblioteca que está sendo importada contém código que faz parte da
API pública, importe a biblioteca pública que exporta a API pública:

```dart
import 'package:ffi/ffi.dart';
```

Se a biblioteca que está sendo importada não faz parte da API pública do
pacote, encontre uma maneira diferente de atingir seu objetivo,
assumindo que seja possível, ou abra um issue (problema) pedindo aos
autores do pacote para torná-lo parte da API pública.

### implicit_call_tearoffs {:#implicit_call_tearoffs}

_Tear-off (desconexão) implícito do método 'call'._

#### Descrição

O analisador produz este diagnóstico quando um objeto com um método
`call` é atribuído a uma variável com tipo de função, desconectando
implicitamente o método `call`.

#### Exemplo

O código a seguir produz este diagnóstico porque uma instância de
`Callable` é passada para uma função esperando uma `Function`:

```dart
class Callable {
  void call() {}
}

void callIt(void Function() f) {
  f();
}

void f() {
  callIt([!Callable()!]);
}
```

#### Correções comuns

Desconecte explicitamente o método `call`:

```dart
class Callable {
  void call() {}
}

void callIt(void Function() f) {
  f();
}

void f() {
  callIt(Callable().call);
}
```

### invalid_runtime_check_with_js_interop_types {:#invalid_runtime_check_with_js_interop_types}

_O cast de '{0}' para '{1}' converte um valor Dart para um tipo de interoperação JS, o que pode não ser consistente com a plataforma._

_O cast de '{0}' para '{1}' converte um valor de interoperação JS para um tipo Dart, o que pode não ser consistente com a plataforma._

_O cast de '{0}' para '{1}' converte um valor de interoperação JS para um tipo de interoperação JS incompatível, o que pode não ser consistente com a plataforma._

_A verificação em tempo de execução entre '{0}' e '{1}' verifica se um valor Dart é um tipo de interoperação JS, o que pode não ser consistente com a plataforma._

_A verificação em tempo de execução entre '{0}' e '{1}' verifica se um valor de interoperação JS é um tipo Dart, o que pode não ser consistente com a plataforma._

_A verificação em tempo de execução entre '{0}' e '{1}' envolve uma verificação em tempo de execução não trivial entre dois tipos de interoperação JS que podem não ser consistentes com a plataforma._

_A verificação em tempo de execução entre '{0}' e '{1}' envolve uma verificação em tempo de execução entre um valor de interoperação JS e um tipo de interoperação JS não relacionado que sempre será verdadeiro e não verificará o tipo subjacente._

#### Descrição

O analisador produz este diagnóstico quando um teste `is` tem:
- um tipo de interoperação JS no lado direito, seja diretamente ou como um
  argumento de tipo para outro tipo, ou
- um valor de interoperação JS no lado esquerdo.

#### Exemplos

O código a seguir produz este diagnóstico porque o tipo de interoperação
JS `JSBoolean` está no lado direito de um teste `is`:

```dart
import 'dart:js_interop';

bool f(Object b) => [!b is JSBoolean!];
```

O código a seguir produz este diagnóstico porque o tipo de interoperação
JS `JSString` é usado como um argumento de tipo no lado direito de um
teste `is`:

```dart
import 'dart:js_interop';

bool f(List<Object> l) => [!l is List<JSString>!];
```

O código a seguir produz este diagnóstico porque o valor de interoperação
JS `a` está no lado esquerdo de um teste `is`:

```dart
import 'dart:js_interop';

bool f(JSAny a) => [!a is String!];
```

#### Correções comuns

Use um auxiliar de interoperação JS, como `isA`, para verificar o tipo
subjacente dos valores de interoperação JS:

```dart
import 'dart:js_interop';

void f(Object b) => b.jsify()?.isA<JSBoolean>();
```

### invalid_use_of_do_not_submit_member {:#invalid_use_of_do_not_submit_member}

_Usos de '{0}' não devem ser enviados para o controle de código fonte._

#### Descrição

O analisador produz este diagnóstico quando um membro que é anotado com
[`@doNotSubmit`][meta-doNotSubmit] é referenciado fora de uma
declaração de membro que também é anotada com `@doNotSubmit`.

#### Exemplo

Dado um arquivo `a.dart` contendo a seguinte declaração:

```dart
import 'package:meta/meta.dart';

@doNotSubmit
void emulateCrash() { /* ... */ }
```

O código a seguir produz este diagnóstico porque a declaração está sendo
referenciada fora de um membro que também é anotado com `@doNotSubmit`:

```dart
import 'a.dart';

void f() {
  [!emulateCrash!]();
}
```

#### Correções comuns

Mais comumente, quando concluído com testes locais, a referência ao membro
deve ser removida.

Se estiver construindo funcionalidades adicionais sobre o membro, anote o
membro recém-adicionado com `@doNotSubmit` também:

```dart
import 'package:meta/meta.dart';

import 'a.dart';

@doNotSubmit
void emulateCrashWithOtherFunctionality() {
  emulateCrash();
  // faça outras coisas.
}
```

### library_annotations {:#library_annotations}

_Esta anotação deve ser anexada a uma diretiva library._

#### Descrição

O analisador produz este diagnóstico quando uma anotação que se aplica a
toda uma biblioteca não está associada a uma diretiva `library`.

#### Exemplo

O código a seguir produz este diagnóstico porque a anotação `TestOn`, que
se aplica a toda a biblioteca, está associada a uma diretiva `import` em
vez de uma diretiva `library`:

```dart
[!@TestOn('browser')!]

import 'package:test/test.dart';

void main() {}
```

#### Correções comuns

Associe a anotação a uma diretiva `library`, adicionando uma se necessário:

```dart
@TestOn('browser')
library;

import 'package:test/test.dart';

void main() {}
```

### library_names {:#library_names}

_O nome da biblioteca '{0}' não é um identificador lower\_case\_with\_underscores._

#### Descrição

O analisador produz este diagnóstico quando o nome de uma biblioteca não
usa a convenção de nomenclatura lower_case_with_underscores.

#### Exemplo

O código a seguir produz este diagnóstico porque o nome da biblioteca
`libraryName` não é um identificador lower_case_with_underscores:

```dart
library [!libraryName!];
```

#### Correções comuns

Se o nome da biblioteca não for necessário, remova o nome da biblioteca:

```dart
library;
```

Se o nome da biblioteca for necessário, converta-o para usar a
convenção de nomenclatura `lower_case_with_underscores` (minúsculas_com_sublinhados):

```dart
library library_name;
```

### library_prefixes {:#library_prefixes}

_O prefixo '{0}' não é um identificador lower\_case\_with\_underscores (minúsculas com underscores)._

#### Descrição

O analisador produz este diagnóstico quando um prefixo de importação não usa a convenção de nomenclatura lower_case_with_underscores (minúsculas com underscores).

#### Exemplo

O seguinte código produz este diagnóstico porque o prefixo `ffiSupport` não é um identificador lower_case_with_underscores (minúsculas com underscores):

```dart
import 'package:ffi/ffi.dart' as [!ffiSupport!];
```

#### Correções comuns

Converta o prefixo para usar a convenção de nomenclatura lower_case_with_underscores (minúsculas com underscores):

```dart
import 'package:ffi/ffi.dart' as ffi_support;
```

### library_private_types_in_public_api {:#library_private_types_in_public_api}

_Uso inválido de um tipo privado em uma API pública._

#### Descrição

O analisador produz este diagnóstico quando um tipo que não faz parte da API pública de uma biblioteca é referenciado na API pública dessa biblioteca.

Usar um tipo privado em uma API pública pode tornar a API inutilizável fora da biblioteca que a define.

#### Exemplo

O seguinte código produz este diagnóstico porque o parâmetro `c` da função pública `f` tem um tipo que é privado da biblioteca (`_C`):

```dart
void f([!_C!] c) {}

class _C {}
```

#### Correções comuns

Se a API não precisar ser usada fora da biblioteca que a define, torne-a privada:

```dart
void _f(_C c) {}

class _C {}
```

Se a API precisar fazer parte da API pública da biblioteca, use um tipo diferente que seja público ou torne o tipo referenciado público:

```dart
void f(C c) {}

class C {}
```

### literal_only_boolean_expressions {:#literal_only_boolean_expressions}

_A expressão booleana tem um valor constante._

#### Descrição

O analisador produz este diagnóstico quando o valor da condição em uma instrução `if` ou loop é conhecido por ser sempre `true` ou sempre `false`. Uma exceção é feita para um loop `while` cuja condição é o literal booleano `true`.

#### Exemplos

O seguinte código produz este diagnóstico porque a condição sempre será avaliada como `true`:

```dart
void f() {
  [!if (true) {!]
    [!print('true');!]
  [!}!]
}
```

O lint avaliará um subconjunto de expressões que são compostas de constantes, então o código a seguir também produzirá este diagnóstico porque a condição sempre será avaliada como `false`:

```dart
void g(int i) {
  [!if (1 == 0 || 3 > 4) {!]
    [!print('false');!]
  [!}!]
}
```

#### Correções comuns

Se a condição estiver errada, corrija a condição para que seu valor não possa ser conhecido em tempo de compilação:

```dart
void g(int i) {
  if (i == 0 || i > 4) {
    print('false');
  }
}
```

Se a condição estiver correta, simplifique o código para não avaliar a condição:

```dart
void f() {
  print('true');
}
```

### no_adjacent_strings_in_list {:#no_adjacent_strings_in_list}

_Não use strings adjacentes em um literal de lista._

#### Descrição

O analisador produz este diagnóstico quando dois literais de string são adjacentes em um literal de lista. Strings adjacentes em Dart são concatenadas para formar uma única string, mas a intenção pode ser que cada string seja um elemento separado na lista.

#### Exemplo

O seguinte código produz este diagnóstico porque as strings `'a'` e `'b'` são adjacentes:

```dart
List<String> list = [[!'a' 'b'!], 'c'];
```

#### Correções comuns

Se as duas strings tiverem a intenção de serem elementos separados da lista, adicione uma vírgula entre elas:

```dart
List<String> list = ['a', 'b', 'c'];
```

Se as duas strings tiverem a intenção de serem uma única string concatenada, mescle manualmente as strings:

```dart
List<String> list = ['ab', 'c'];
```

Ou use o operador `+` para concatenar as strings:

```dart
List<String> list = ['a' + 'b', 'c'];
```

### no_duplicate_case_values {:#no_duplicate_case_values}

_O valor da cláusula case ('{0}') é igual ao valor de uma cláusula case anterior ('{1}')._

#### Descrição

O analisador produz este diagnóstico quando duas ou mais cláusulas `case` na mesma instrução `switch` têm o mesmo valor.

Quaisquer cláusulas `case` após a primeira não podem ser executadas, portanto, ter cláusulas `case` duplicadas é enganoso.

Este diagnóstico é frequentemente o resultado de um erro de digitação ou de uma alteração no valor de uma constante.

#### Exemplo

O seguinte código produz este diagnóstico porque duas cláusulas case têm o mesmo valor (1):

```dart
// @dart = 2.14
void f(int v) {
  switch (v) {
    case 1:
      break;
    case [!1!]:
      break;
  }
}
```

#### Correções comuns

Se uma das cláusulas deve ter um valor diferente, altere o valor da cláusula:

```dart
void f(int v) {
  switch (v) {
    case 1:
      break;
    case 2:
      break;
  }
}
```

Se o valor estiver correto, mescle as instruções em uma única cláusula:

```dart
void f(int v) {
  switch (v) {
    case 1:
      break;
  }
}
```

### no_leading_underscores_for_library_prefixes {:#no_leading_underscores_for_library_prefixes}

_O prefixo da biblioteca '{0}' começa com um underscore._

#### Descrição

O analisador produz este diagnóstico quando o nome de um prefixo declarado em uma importação começa com um underscore.

Prefixos de biblioteca são inerentemente não visíveis fora da biblioteca declarante, então um underscore inicial indicando private não agrega valor.

#### Exemplo

O seguinte código produz este diagnóstico porque o prefixo `_core` começa com um underscore:

```dart
import 'dart:core' as [!_core!];
```

#### Correções comuns

Remova o underscore:

```dart
import 'dart:core' as core;
```

### no_leading_underscores_for_local_identifiers {:#no_leading_underscores_for_local_identifiers}

_A variável local '{0}' começa com um underscore._

#### Descrição

O analisador produz este diagnóstico quando o nome de uma variável local começa com um underscore.

Variáveis locais são inerentemente não visíveis fora da biblioteca declarante, então um underscore inicial indicando private não agrega valor.

#### Exemplo

O seguinte código produz este diagnóstico porque o parâmetro `_s` começa com um underscore:

```dart
int f(String [!_s!]) => _s.length;
```

#### Correções comuns

Remova o underscore:

```dart
int f(String s) => s.length;
```

### no_logic_in_create_state {:#no_logic_in_create_state}

_Não coloque nenhuma lógica em 'createState'._

#### Descrição

O analisador produz este diagnóstico quando uma implementação de `createState` em uma subclasse de `StatefulWidget` contém qualquer lógica que não seja o retorno do resultado da invocação de um construtor sem argumentos.

#### Exemplos

O seguinte código produz este diagnóstico porque a invocação do construtor tem argumentos:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  MyState createState() => [!MyState(0)!];
}

class MyState extends State {
  int x;

  MyState(this.x);
}
```

#### Correções comuns

Reescreva o código para que `createState` não contenha nenhuma lógica:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  MyState createState() => MyState();
}

class MyState extends State {
  int x = 0;

  MyState();
}
```

### no_wildcard_variable_uses {:#no_wildcard_variable_uses}

_O identificador referenciado é um curinga._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro ou variável local cujo nome consiste apenas em underscores é referenciado. Esses nomes se tornarão não vinculativos em uma versão futura da linguagem Dart, tornando a referência ilegal.

#### Exemplo

O seguinte código produz este diagnóstico porque o nome do parâmetro consiste em dois underscores:

```dart
// @dart = 3.6
void f(int __) {
  print([!__!]);
}
```

O seguinte código produz este diagnóstico porque o nome da variável local consiste em um único underscore:

```dart
// @dart = 3.6
void f() {
  int _ = 0;
  print([!_!]);
}
```

#### Correções comuns

Se a variável ou parâmetro tiver a intenção de ser referenciado, dê a ele um nome que tenha pelo menos um caractere que não seja underscore:

```dart
void f(int p) {
  print(p);
}
```

Se a variável ou parâmetro não tiver a intenção de ser referenciado, substitua a referência por uma expressão diferente:

```dart
void f() {
  print(0);
}
```

### non_constant_identifier_names {:#non_constant_identifier_names}

_O nome da variável '{0}' não é um identificador lowerCamelCase (minúsculas com camel case)._

#### Descrição

O analisador produz este diagnóstico quando o nome de um membro de classe, declaração de nível superior, variável, parâmetro, parâmetro nomeado ou construtor nomeado que não é declarado como `const`, não usa a convenção lowerCamelCase (minúsculas com camel case).

#### Exemplo

O seguinte código produz este diagnóstico porque a variável de nível superior `Count` não começa com uma letra minúscula:

```dart
var [!Count!] = 0;
```

#### Correções comuns

Altere o nome na declaração para seguir a convenção lowerCamelCase (minúsculas com camel case):

```dart
var count = 0;
```

### null_check_on_nullable_type_parameter {:#null_check_on_nullable_type_parameter}

_O operador de verificação de nulo não deve ser usado em uma variável cujo tipo é um parâmetro de tipo potencialmente anulável._

#### Descrição

O analisador produz este diagnóstico quando um operador de verificação de nulo é usado em uma variável cujo tipo é `T?`, onde `T` é um parâmetro de tipo que permite que o argumento de tipo seja anulável (não tem limite ou tem um limite que é anulável).

Dado um parâmetro de tipo genérico `T` que tem um limite anulável, é muito fácil introduzir verificações de nulo errôneas ao trabalhar com uma variável do tipo `T?`. Especificamente, não é incomum ter `T? x;` e querer afirmar que `x` foi definido com um valor válido do tipo `T`. Um erro comum é fazê-lo usando `x!`. Isso quase sempre está incorreto, porque se `T` é um tipo anulável, `x` pode conter validamente `null` como um valor do tipo `T`.

#### Exemplo

O seguinte código produz este diagnóstico porque `t` tem o tipo `T?` e `T` permite que o argumento de tipo seja anulável (porque não tem cláusula `extends`):

```dart
T f<T>(T? t) => t[!!!];
```

#### Correções comuns

Use o parâmetro de tipo para converter a variável:

```dart
T f<T>(T? t) => t as T;
```

### overridden_fields {:#overridden_fields}

_O campo sobrescreve um campo herdado de '{0}'._

#### Descrição

O analisador produz este diagnóstico quando uma classe define um campo que
sobrescreve um campo de uma superclasse.

Sobrescrever um campo com outro campo faz com que o objeto tenha dois campos
distintos, mas como os campos têm o mesmo nome, apenas um dos campos pode ser
referenciado em um determinado escopo. Isso pode levar à confusão onde uma
referência a um dos campos pode ser confundida com uma
referência ao outro.

#### Exemplo

O seguinte código produz este diagnóstico porque o campo `f` em `B` sombreia
o campo `f` em `A`:

```dart
class A {
  int f = 1;
}

class B extends A {
  @override
  int [!f!] = 2;
}
```

#### Correções comuns

Se os dois campos estiverem representando a mesma propriedade, remova o
campo da subclasse:

```dart
class A {
  int f = 1;
}

class B extends A {}
```

Se os dois campos devem ser distintos, renomeie um dos campos:

```dart
class A {
  int f = 1;
}

class B extends A {
  int g = 2;
}
```

Se os dois campos estiverem relacionados de alguma forma, mas não puderem
ser os mesmos, encontre uma maneira diferente de implementar a semântica que você precisa.

### package_names {:#package_names}

_O nome do pacote '{0}' não é um identificador lower\_case\_with\_underscores (minúsculas com underscores)._

#### Descrição

O analisador produz este diagnóstico quando o nome de um pacote
não usa a convenção de nomenclatura lower_case_with_underscores (minúsculas com underscores).

#### Exemplo

O seguinte código produz este diagnóstico porque o nome do pacote
usa a convenção de nomenclatura lowerCamelCase (minúsculas com camel case):

```yaml
name: [!somePackage!]
```

#### Correções comuns

Reescreva o nome do pacote usando a convenção de nomenclatura
lower_case_with_underscores (minúsculas com underscores):

```yaml
name: some_package
```

### package_prefixed_library_names {:#package_prefixed_library_names}

_O nome da biblioteca não é um caminho separado por pontos prefixado pelo nome do pacote._

#### Descrição

O analisador produz este diagnóstico quando uma biblioteca tem um nome que
não segue estas diretrizes:

- Prefixe todos os nomes de biblioteca com o nome do pacote.
- Faça com que a biblioteca de entrada tenha o mesmo nome do pacote.
- Para todas as outras bibliotecas em um pacote, após o nome do pacote, adicione o caminho separado por pontos para o arquivo Dart da biblioteca.
- Para bibliotecas em `lib`, omita o nome do diretório superior.

Por exemplo, dado um pacote chamado `my_package`, aqui estão os
nomes de biblioteca para vários arquivos no pacote:

#### Exemplo

Assumindo que o arquivo que contém o código a seguir não está em um arquivo
chamado `special.dart` no diretório `lib` de um pacote chamado `something`
(que seria uma exceção à regra), o analisador produz este diagnóstico porque
o nome da biblioteca não está em conformidade
com as diretrizes acima:

```dart
library [!something.special!];
```

#### Correções comuns

Altere o nome da biblioteca para estar em conformidade com as diretrizes.

### prefer_adjacent_string_concatenation {:#prefer_adjacent_string_concatenation}

_Literais de string não devem ser concatenados pelo operador '+'._

#### Descrição

O analisador produz este diagnóstico quando o operador `+` é usado para concatenar dois literais de string.

#### Exemplo

O seguinte código produz este diagnóstico porque dois literais de string estão sendo concatenados usando o operador `+`:

```dart
var s = 'a' [!+!] 'b';
```

#### Correções comuns

Remova o operador:

```dart
var s = 'a' 'b';
```

### prefer_collection_literals {:#prefer_collection_literals}

_Invocação de construtor desnecessária._

#### Descrição

O analisador produz este diagnóstico quando um construtor é usado para criar uma lista, mapa ou conjunto, mas um literal produziria o mesmo resultado.

#### Exemplo

O seguinte código produz este diagnóstico porque o construtor para `Map` está sendo usado para criar um mapa que também poderia ser criado usando um literal:

```dart
var m = [!Map<String, String>()!];
```

#### Correções comuns

Use a representação literal:

```dart
var m = <String, String>{};
```

### prefer_conditional_assignment {:#prefer_conditional_assignment}

_A instrução 'if' pode ser substituída por uma atribuição com reconhecimento de nulo._

#### Descrição

O analisador produz este diagnóstico quando uma atribuição a uma variável é condicional com base em se a variável tem o valor `null` e o operador `??=` poderia ser usado em vez disso.

#### Exemplo

O seguinte código produz este diagnóstico porque o parâmetro `s` está sendo comparado a `null` para determinar se deve atribuir um valor diferente:

```dart
int f(String? s) {
  [!if (s == null) {!]
    [!s = '';!]
  [!}!]
  return s.length;
}
```

#### Correções comuns

Use o operador `??=` em vez de uma instrução `if` explícita:

```dart
int f(String? s) {
  s ??= '';
  return s.length;
}
```

### prefer_const_constructors {:#prefer_const_constructors}

_Use 'const' com o construtor para melhorar o desempenho._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de um construtor const não é precedida por `const` ou em um [contexto constante][contexto constante].

#### Exemplo

O seguinte código produz este diagnóstico porque a invocação do construtor `const` não é prefixada por `const` nem em um [contexto constante][contexto constante]:

```dart
class C {
  const C();
}

C c = [!C()!];
```

#### Correções comuns

Se o contexto pode ser transformado em um [contexto constante][contexto constante], faça isso:

```dart
class C {
  const C();
}

const C c = C();
```

Se o contexto não pode ser transformado em um [contexto constante][contexto constante], adicione `const` antes da invocação do construtor:

```dart
class C {
  const C();
}

C c = const C();
```

### prefer_const_constructors_in_immutables {:#prefer_const_constructors_in_immutables}

_Construtores em classes '@immutable' devem ser declarados como 'const'._

#### Descrição

O analisador produz este diagnóstico quando um construtor não-`const` é encontrado em uma classe que tem a anotação `@immutable`.

#### Exemplo

O seguinte código produz este diagnóstico porque o construtor em `C` não é declarado como `const` mesmo que `C` tenha a anotação `@immutable`:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  [!C!](this.f);
}
```

#### Correções comuns

Se a classe realmente tem a intenção de ser imutável, adicione o modificador `const` ao construtor:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}
```

Se a classe for mutável, remova a anotação `@immutable`:

```dart
class C {
  final f;

  C(this.f);
}
```

### prefer_const_declarations {:#prefer_const_declarations}

_Use 'const' para variáveis final inicializadas com um valor constante._

#### Descrição

O analisador produz este diagnóstico quando uma variável de nível superior, campo estático ou variável local é marcada como `final` e é inicializada com um valor constante.

#### Exemplos

O seguinte código produz este diagnóstico porque a variável de nível superior `v` é `final` e inicializada com um valor constante:

```dart
[!final v = const <int>[]!];
```

O seguinte código produz este diagnóstico porque o campo estático `f` é `final` e inicializado com um valor constante:

```dart
class C {
  static [!final f = const <int>[]!];
}
```

O seguinte código produz este diagnóstico porque a variável local `v` é `final` e inicializada com um valor constante:

```dart
void f() {
  [!final v = const <int>[]!];
  print(v);
}
```

#### Correções comuns

Substitua a palavra-chave `final` por `const` e remova `const` do inicializador:

```dart
class C {
  static const f = <int>[];
}
```

### prefer_const_literals_to_create_immutables {:#prefer_const_literals_to_create_immutables}

_Use literais 'const' como argumentos para construtores de classes '@immutable'._

#### Descrição

O analisador produz este diagnóstico quando um literal de lista, mapa ou conjunto não-const é passado como um argumento para um construtor declarado em uma classe anotada com `@immutable`.

#### Exemplo

O seguinte código produz este diagnóstico porque o literal de lista (`[1]`) está sendo passado para um construtor em uma classe imutável, mas não é uma lista constante:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = C([![1]!]);
```

#### Correções comuns

Se o contexto pode ser transformado em um [contexto constante][contexto constante], faça isso:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

const C c = C([1]);
```

Se o contexto não puder ser transformado em um [contexto constante][contexto constante] mas o construtor puder ser invocado usando `const`, adicione `const` antes da invocação do construtor:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = const C([1]);
```

Se o contexto não puder ser transformado em um [contexto constante][contexto constante] e o construtor não puder ser invocado usando `const`, adicione a palavra-chave `const` antes do literal da coleção:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = C(const [1]);
```

### prefer_contains {:#prefer_contains}

_Sempre 'false' porque 'indexOf' é sempre maior ou igual a -1._

_Sempre 'true' porque 'indexOf' é sempre maior ou igual a -1._

_Uso desnecessário de 'indexOf' para testar a contenção._

#### Descrição

O analisador produz este diagnóstico quando o método `indexOf` é usado e o resultado é comparado apenas com `-1` ou `0` de uma forma em que a semântica é equivalente a usar `contains`.

#### Exemplo

O seguinte código produz este diagnóstico porque a condição na instrução `if` está verificando se a lista contém a string:

```dart
void f(List<String> l, String s) {
  if ([!l.indexOf(s) < 0!]) {
    // ...
  }
}
```

#### Correções comuns

Use `contains` em vez disso, negando a condição quando necessário:

```dart
void f(List<String> l, String s) {
  if (l.contains(s)) {
    // ...
  }
}
```

### prefer_double_quotes {:#prefer_double_quotes}

_Uso desnecessário de aspas simples._

#### Descrição

O analisador produz este diagnóstico quando um literal de string usa aspas simples (`'`) quando poderia usar aspas duplas (`"`) sem precisar de escapes extras e sem prejudicar a legibilidade.

#### Exemplo

O seguinte código produz este diagnóstico porque o literal de string usa aspas simples, mas não precisa:

```dart
void f(String name) {
  print([!'Hello $name'!]);
}
```

#### Correções comuns

Use aspas duplas no lugar de aspas simples:

```dart
void f(String name) {
  print("Hello $name");
}
```

### prefer_final_fields {:#prefer_final_fields}

_O campo privado {0} poderia ser 'final'._

#### Descrição

O analisador produz este diagnóstico quando um campo privado é atribuído apenas uma vez. O campo pode ser inicializado em vários construtores e ainda ser sinalizado porque apenas um desses construtores pode ser executado.

#### Exemplo

O seguinte código produz este diagnóstico porque o campo `_f` é atribuído apenas uma vez, no inicializador do campo:

```dart
class C {
  int [!_f = 1!];

  int get f => _f;
}
```

#### Correções comuns

Marque o campo como `final`:

```dart
class C {
  final int _f = 1;

  int get f => _f;
}
```

### prefer_for_elements_to_map_fromiterable {:#prefer_for_elements_to_map_fromiterable}

_Use elementos 'for' ao construir mapas de iteráveis._

#### Descrição

O analisador produz este diagnóstico quando `Map.fromIterable` é usado para construir um mapa que poderia ser construído usando o elemento `for`.

#### Exemplo

O seguinte código produz este diagnóstico porque `fromIterable` está sendo usado para construir um mapa que poderia ser construído usando um elemento `for`:

```dart
void f(Iterable<String> data) {
  [!Map<String, int>.fromIterable(!]
    [!data,!]
    [!key: (element) => element,!]
    [!value: (element) => element.length,!]
  [!)!];
}
```

#### Correções comuns

Use um elemento `for` para construir o mapa:

```dart
void f(Iterable<String> data) {
  <String, int>{
    for (var element in data)
      element: element.length
  };
}
```

### prefer_function_declarations_over_variables {:#prefer_function_declarations_over_variables}

_Use uma declaração de função em vez de uma atribuição de variável para vincular uma função a um nome._

#### Descrição

O analisador produz este diagnóstico quando um closure é atribuído a uma variável local e a variável local não é reatribuída em nenhum lugar.

#### Exemplo

O seguinte código produz este diagnóstico porque a variável local `f` é inicializada para ser um closure e não recebe nenhum outro valor:

```dart
void g() {
  var [!f = (int i) => i * 2!];
  f(1);
}
```

#### Correções comuns

Substitua a variável local por uma função local:

```dart
void g() {
  int f(int i) => i * 2;
  f(1);
}
```

### prefer_generic_function_type_aliases {:#prefer_generic_function_type_aliases}

_Use a sintaxe de tipo de função genérica em 'typedef's._

#### Descrição

O analisador produz este diagnóstico quando um typedef é escrito usando a sintaxe mais antiga para aliases de tipo de função na qual o nome que está sendo declarado é incorporado no tipo de função.

#### Exemplo

O seguinte código produz este diagnóstico porque usa a sintaxe mais antiga:

```dart
typedef void [!F!]<T>();
```

#### Correções comuns

Reescreva o typedef para usar a sintaxe mais recente:

```dart
typedef F<T> = void Function();
```

### prefer_if_null_operators {:#prefer_if_null_operators}

_Use o operador '??' em vez de '?:' ao testar 'null'._

#### Descrição

O analisador produz este diagnóstico quando uma expressão condicional (usando o operador `?:`) é usada para selecionar um valor diferente quando uma variável local é `null`.

#### Exemplo

O seguinte código produz este diagnóstico porque a variável `s` está sendo comparada a `null` para que um valor diferente possa ser retornado quando `s` é `null`:

```dart
String f(String? s) => [!s == null ? '' : s!];
```

#### Correções comuns

Use o operador if-null em vez disso:

```dart
String f(String? s) => s ?? '';
```

### prefer_initializing_formals {:#prefer_initializing_formals}

_Use um formal inicializador para atribuir um parâmetro a um campo._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro de construtor é usado para inicializar um campo sem modificação.

#### Exemplo

O seguinte código produz este diagnóstico porque o parâmetro `c` é usado apenas para definir o campo `c`:

```dart
class C {
  int c;

  C(int c) : [!this.c = c!];
}
```

#### Correções comuns

Use um parâmetro formal inicializador para inicializar o campo:

```dart
class C {
  int c;

  C(this.c);
}
```

### prefer_inlined_adds {:#prefer_inlined_adds}

_A adição de um item de lista pode ser inline._

_A adição de vários itens de lista pode ser inline._

#### Descrição

O analisador produz este diagnóstico quando os métodos `add` e `addAll` são invocados em um literal de lista onde os elementos que estão sendo adicionados poderiam ser incluídos no literal de lista.

#### Exemplo

O seguinte código produz este diagnóstico porque o método `add` está sendo usado para adicionar `b`, quando ele poderia ter sido incluído diretamente no literal da lista:

```dart
List<String> f(String a, String b) {
  return [a]..[!add!](b);
}
```

O seguinte código produz este diagnóstico porque o método `addAll` está sendo usado para adicionar os elementos de `b`, quando eles poderiam ter sido incluídos diretamente no literal da lista:

```dart
List<String> f(String a, List<String> b) {
  return [a]..[!addAll!](b);
}
```

#### Correções comuns

Se o método `add` estiver sendo usado, transforme o argumento em um elemento da lista e remova a invocação:

```dart
List<String> f(String a, String b) {
  return [a, b];
}
```

Se o método `addAll` estiver sendo usado, use o operador spread no argumento para adicionar seus elementos à lista e remover a invocação:

```dart
List<String> f(String a, List<String> b) {
  return [a, ...b];
}
```

### prefer_interpolation_to_compose_strings {:#prefer_interpolation_to_compose_strings}

_Use interpolação para compor strings e valores._

#### Descrição

O analisador produz este diagnóstico quando literais de string e strings calculadas estão sendo concatenadas usando o operador `+`, mas a interpolação de string alcançaria o mesmo resultado.

#### Exemplo

O seguinte código produz este diagnóstico porque a String `s` é concatenada com outras strings usando o operador `+`:

```dart
String f(String s) {
  return [!'(' + s!] + ')';
}
```

#### Correções comuns

Use interpolação de string:

```dart
String f(List<String> l) {
  return '(${l[0]}, ${l[1]})';
}
```

### prefer_is_empty {:#prefer_is_empty}

_A comparação é sempre 'false' porque o comprimento é sempre maior ou igual a 0._

_A comparação é sempre 'true' porque o comprimento é sempre maior ou igual a 0._

_Use 'isEmpty' em vez de 'length' para testar se a coleção está vazia._

_Use 'isNotEmpty' em vez de 'length' para testar se a coleção está vazia._

#### Descrição

O analisador produz este diagnóstico quando o resultado da invocação de `Iterable.length` ou `Map.length` é comparado por igualdade com zero (`0`).

#### Exemplo

O seguinte código produz este diagnóstico porque o resultado da invocação de `length` é verificado por igualdade com zero:

```dart
int f(Iterable<int> p) => [!p.length == 0!] ? 0 : p.first;
```

#### Correções comuns

Substitua o uso de `length` por um uso de `isEmpty` ou `isNotEmpty`:

```dart
void f(Iterable<int> p) => p.isEmpty ? 0 : p.first;
```

### prefer_is_not_empty {:#prefer_is_not_empty}

_Use 'isNotEmpty' em vez de negar o resultado de 'isEmpty'._

#### Descrição

O analisador produz este diagnóstico quando o resultado da invocação de `Iterable.isEmpty` ou `Map.isEmpty` é negado.

#### Exemplo

O seguinte código produz este diagnóstico porque o resultado da invocação de `Iterable.isEmpty` é negado:

```dart
void f(Iterable<int> p) => [!!p.isEmpty!] ? p.first : 0;
```

#### Correções comuns

Reescreva o código para usar `isNotEmpty`:

```dart
void f(Iterable<int> p) => p.isNotEmpty ? p.first : 0;
```

### prefer_is_not_operator {:#prefer_is_not_operator}

_Use o operador 'is!' em vez de negar o valor do operador 'is'._

#### Descrição

O analisador produz este diagnóstico quando o operador prefixo `!` é usado para negar o resultado de um teste `is`.

#### Exemplo

O seguinte código produz este diagnóstico porque o resultado do teste para ver se `o` é uma `String` é negado usando o operador prefixo `!`:

```dart
String f(Object o) {
  if ([!!(o is String)!]) {
    return o.toString();
  }
  return o;
}
```

#### Correções comuns

Use o operador `is!` em vez disso:

```dart
String f(Object o) {
  if (o is! String) {
    return o.toString();
  }
  return o;
}
```
### prefer_iterable_wheretype {:#prefer_iterable_wheretype}

_Use 'whereType' para selecionar elementos de um tipo específico._

#### Descrição

O analisador produz este diagnóstico quando o método `Iterable.where`
está sendo usado para filtrar elementos com base em seu tipo.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `where` está
sendo usado para acessar apenas as strings dentro do iterável:

```dart
Iterable<Object> f(Iterable<Object> p) => p.[!where!]((e) => e is String);
```

#### Correções comuns

Reescreva o código para usar `whereType`:

```dart
Iterable<String> f(Iterable<Object> p) => p.whereType<String>();
```

Isso também pode permitir que você restrinja os tipos em seu código ou remova
outras verificações de tipo.

### prefer_null_aware_operators {:#prefer_null_aware_operators}

_Use o operador null-aware (operador de reconhecimento nulo) `?.` em vez de uma comparação explícita com 'null'._

#### Descrição

O analisador produz este diagnóstico quando uma comparação com `null` é
usada para proteger uma referência de membro, e `null` é usado como resultado quando o
alvo protegido é `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque a invocação de
`length` é protegida por uma comparação com `null`, mesmo quando o valor padrão
é `null`:

```dart
int? f(List<int>? p) {
  return [!p == null ? null : p.length!];
}
```

#### Correções comuns

Use um operador de acesso null-aware (de reconhecimento nulo) em vez disso:

```dart
int? f(List<int>? p) {
  return p?.length;
}
```

### prefer_relative_imports {:#prefer_relative_imports}

_Use imports relativos para arquivos no diretório 'lib'._

#### Descrição

O analisador produz este diagnóstico quando um `import` em uma biblioteca dentro
do diretório `lib` usa um URI `package:` para se referir a outra biblioteca no
mesmo pacote.

#### Exemplo

O código a seguir produz este diagnóstico porque ele usa um URI `package:`
quando um URI relativo poderia ter sido usado:

```dart
import 'package:my_package/bar.dart';
```

#### Correções comuns

Use um URI relativo para importar a biblioteca:

```dart
import 'bar.dart';
```

### prefer_single_quotes {:#prefer_single_quotes}

_Uso desnecessário de aspas duplas._

#### Descrição

O analisador produz este diagnóstico quando um literal string usa aspas duplas
(`"`) quando poderia usar aspas simples (`'`) sem precisar de escapes extras
e sem prejudicar a legibilidade.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal string
usa aspas duplas, mas não precisa:

```dart
void f(String name) {
  print([!"Hello $name"!]);
}
```

#### Correções comuns

Use aspas simples em vez de aspas duplas:

```dart
void f(String name) {
  print('Hello $name');
}
```

### prefer_typing_uninitialized_variables {:#prefer_typing_uninitialized_variables}

_Um campo não inicializado deve ter uma anotação de tipo explícita._

_Uma variável não inicializada deve ter uma anotação de tipo explícita._

#### Descrição

O analisador produz este diagnóstico quando uma variável sem um
inicializador não tem uma anotação de tipo explícita.

Sem uma anotação de tipo ou um inicializador, uma variável tem o
tipo `dynamic`, o que permite que qualquer valor seja atribuído à variável,
geralmente causando bugs difíceis de identificar.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável `r`
não tem uma anotação de tipo nem um inicializador:

```dart
Object f() {
  var [!r!];
  r = '';
  return r;
}
```

#### Correções comuns

Se a variável puder ser inicializada, adicione um inicializador:

```dart
Object f() {
  var r = '';
  return r;
}
```

Se a variável não puder ser inicializada, adicione um tipo explícito
anotação:

```dart
Object f() {
  String r;
  r = '';
  return r;
}
```

### prefer_void_to_null {:#prefer_void_to_null}

_Uso desnecessário do tipo 'Null'._

#### Descrição

O analisador produz este diagnóstico quando `Null` é usado em um local
onde `void` seria uma escolha válida.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f` é
declarada para retornar `null` (em algum momento futuro):

```dart
Future<[!Null!]> f() async {}
```

#### Correções comuns

Substitua o uso de `Null` pelo uso de `void`:

```dart
Future<void> f() async {}
```

### provide_deprecation_message {:#provide_deprecation_message}

_Faltando uma mensagem de descontinuação (deprecation)._

#### Descrição

O analisador produz este diagnóstico quando uma anotação `deprecated` é
usada em vez da anotação `Deprecated`.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `f` é
anotada com `deprecated`:

```dart
[!@deprecated!]
void f() {}
```

#### Correções comuns

Converta o código para usar a forma mais longa:

```dart
@Deprecated('Use g instead. Will be removed in 4.0.0.')
void f() {}
```

### recursive_getters {:#recursive_getters}

_O getter '{0}' retorna recursivamente a si mesmo._

#### Descrição

O analisador produz este diagnóstico quando um getter invoca a si mesmo,
resultando em um loop infinito.

#### Exemplo

O código a seguir produz este diagnóstico porque o getter `count`
invoca a si mesmo:

```dart
class C {
  int _count = 0;

  int get [!count!] => count;
}
```

#### Correções comuns

Altere o getter para não invocar a si mesmo:

```dart
class C {
  int _count = 0;

  int get count => _count;
}
```

### secure_pubspec_urls {:#secure_pubspec_urls}

_O protocolo '{0}' não deve ser usado porque não é seguro._

#### Descrição

O analisador produz este diagnóstico quando uma URL em um arquivo `pubspec.yaml` está
usando um esquema não seguro, como `http`.

#### Exemplo

O código a seguir produz este diagnóstico porque o arquivo `pubspec.yaml`
contém uma URL `http`:

```yaml
dependencies:
  example: any
    repository: [!http://github.com/dart-lang/example!]
```

#### Correções comuns

Altere o esquema da URL para usar um esquema seguro, como `https`:

```yaml
dependencies:
  example: any
    repository: https://github.com/dart-lang/example
```

### sized_box_for_whitespace {:#sized_box_for_whitespace}

_Use um 'SizedBox' para adicionar espaço em branco a um layout._

#### Descrição

O analisador produz este diagnóstico quando um `Container` é criado usando
apenas os argumentos `height` e/ou `width`.

#### Exemplo

O código a seguir produz este diagnóstico porque o `Container` tem
apenas o argumento `width`:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: <Widget>[
      const Text('...'),
      [!Container!](
        width: 4,
        child: Text('...'),
      ),
      const Expanded(
        child: Text('...'),
      ),
    ],
  );
}
```

#### Correções comuns

Substitua o `Container` por um `SizedBox` das mesmas dimensões:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: <Widget>[
      Text('...'),
      SizedBox(
        width: 4,
        child: Text('...'),
      ),
      Expanded(
        child: Text('...'),
      ),
    ],
  );
}
```

### sized_box_shrink_expand {:#sized_box_shrink_expand}

_Use 'SizedBox.{0}' para evitar a necessidade de especificar 'height' e 'width'._

#### Descrição

O analisador produz este diagnóstico quando uma invocação de construtor
`SizedBox` especifica os valores de `height` e `width` como `0.0` ou `double.infinity`.

#### Exemplos

O código a seguir produz este diagnóstico porque tanto o `height` quanto o
`width` são `0.0`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!SizedBox!](
    height: 0.0,
    width: 0.0,
    child: const Text(''),
  );
}
```

O código a seguir produz este diagnóstico porque tanto o `height` quanto o
`width` são `double.infinity`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!SizedBox!](
    height: double.infinity,
    width: double.infinity,
    child: const Text(''),
  );
}
```

#### Correções comuns

Se ambos forem `0.0`, use `SizedBox.shrink`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return SizedBox.shrink(
    child: const Text(''),
  );
}
```

Se ambos forem `double.infinity`, use `SizedBox.expand`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return SizedBox.expand(
    child: const Text(''),
  );
}
```

### slash_for_doc_comments {:#slash_for_doc_comments}

_Use a forma de fim de linha ('///') para comentários de documentação._

#### Descrição

O analisador produz este diagnóstico quando um comentário de documentação usa
o estilo de comentário de bloco (delimitado por `/**` e `*/`).

#### Exemplo

O código a seguir produz este diagnóstico porque a documentação
comentário para `f` usa um estilo de comentário de bloco:

```dart
[!/**!]
[! * Example.!]
[! */!]
void f() {}
```

#### Correções comuns

Use um estilo de comentário de fim de linha:

```dart
/// Example.
void f() {}
```

### sort_child_properties_last {:#sort_child_properties_last}

_O argumento '{0}' deve ser o último nas invocações do construtor do widget._

#### Descrição

O analisador produz este diagnóstico quando o argumento `child` ou `children`
não é o último argumento em uma invocação do construtor de uma classe de widget.
Uma exceção é feita se todos os argumentos após o
argumento `child` ou `children` são expressões de função.

#### Exemplo

O código a seguir produz este diagnóstico porque o argumento `child`
não é o último argumento na invocação do construtor `Center`:

```dart
import 'package:flutter/material.dart';

Widget createWidget() {
  return Center(
    [!child: Text('...')!],
    widthFactor: 0.5,
  );
}
```

#### Correções comuns

Mova o argumento `child` ou `children` para ser o último:

```dart
import 'package:flutter/material.dart';

Widget createWidget() {
  return Center(
    widthFactor: 0.5,
    child: Text('...'),
  );
}
```

### sort_constructors_first {:#sort_constructors_first}

_As declarações de construtor devem estar antes das declarações não construtoras._

#### Descrição

O analisador produz este diagnóstico quando uma declaração de construtor é
precedida por uma ou mais declarações não construtoras.

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor para
`C` aparece após o método `m`:

```dart
class C {
  void m() {}

  [!C!]();
}
```

#### Correções comuns

Mova todas as declarações de construtor antes de qualquer outra declaração:

```dart
class C {
  C();

  void m() {}
}
```

### sort_pub_dependencies {:#sort_pub_dependencies}

_Dependências não ordenadas alfabeticamente._

#### Descrição

O analisador produz este diagnóstico quando as chaves em um mapa de dependência em
o arquivo `pubspec.yaml` não está classificado alfabeticamente. Os mapas de dependência
que são verificados são os mapas `dependencies`, `dev_dependencies` e
`dependency_overrides`.

#### Exemplo

O código a seguir produz este diagnóstico porque as entradas no mapa
`dependencies` não estão ordenadas:

```yaml
dependencies:
  path: any
  collection: any
```

#### Correções comuns

Classifique as entradas:

```yaml
dependencies:
  collection: any
  path: any
```

### sort_unnamed_constructors_first {:#sort_unnamed_constructors_first}

_Localização inválida para o construtor não nomeado._

#### Descrição

O analisador produz este diagnóstico quando um construtor não nomeado aparece
após um construtor nomeado.

#### Exemplo

O código a seguir produz este diagnóstico porque o não nomeado
construtor está depois do construtor nomeado:

```dart
class C {
  C.named();

  [!C!]();
}
```

#### Correções comuns

Mova o construtor não nomeado antes de quaisquer outros construtores:

```dart
class C {
  C();

  C.named();
}
```

### test_types_in_equals {:#test_types_in_equals}

_Teste de tipo ausente para '{0}' em '=='._

#### Descrição

O analisador produz este diagnóstico quando uma substituição do operador `==`
não inclui um teste de tipo no valor do parâmetro.

#### Exemplo

O código a seguir produz este diagnóstico porque `other` não é testado por tipo:

```dart
class C {
  final int f;

  C(this.f);

  @override
  bool operator ==(Object other) {
    return ([!other as C!]).f == f;
  }
}
```

#### Correções comuns

Execute um teste `is` como parte do cálculo do valor de retorno:

```dart
class C {
  final int f;

  C(this.f);

  @override
  bool operator ==(Object other) {
    return other is C && other.f == f;
  }
}
```

### throw_in_finally {:#throw_in_finally}

_Uso de '{0}' no bloco 'finally'._

#### Descrição

O analisador produz este diagnóstico quando uma instrução `throw` é encontrada
dentro de um bloco `finally`.

#### Exemplo

O código a seguir produz este diagnóstico porque existe um comando `throw`
dentro de um bloco `finally`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  } finally {
    [!throw 'error'!];
  }
}
```

#### Correções comuns

Reescreva o código para que a instrução `throw` não esteja dentro de um
bloco `finally`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  }
  throw 'error';
}
```

### type_init_formals {:#type_init_formals}

_Não anote desnecessariamente os formals de inicialização._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro formal inicializador
(`this.x`) ou um super parâmetro (`super.x`) tem um tipo explícito
anotação que é a mesma que o campo ou parâmetro substituído.

Se um parâmetro do construtor estiver usando `this.x` para inicializar um campo, então
o tipo do parâmetro é implicitamente o mesmo tipo do campo. Se um
parâmetro do construtor está usando `super.x` para encaminhar para um super
construtor, então o tipo do parâmetro é implicitamente o mesmo que o
parâmetro super construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro `this.c`
tem um tipo explícito que é o mesmo que o campo `c`:

```dart
class C {
  int c;

  C([!int!] this.c);
}
```

O código a seguir produz este diagnóstico porque o parâmetro
`super.a` tem um tipo explícito que é o mesmo que o parâmetro `a` do
superclasse:

```dart
class A {
  A(int a);
}

class B extends A {
  B([!int!] super.a);
}
```

#### Correções comuns

Remova a anotação de tipo do parâmetro:

```dart
class C {
  int c;

  C(this.c);
}
```

### type_literal_in_constant_pattern {:#type_literal_in_constant_pattern}

_Use 'TypeName \_' em vez de um literal de tipo._

#### Descrição

O analisador produz este diagnóstico quando um literal de tipo aparece como um
padrão (pattern).

#### Exemplo

O código a seguir produz este diagnóstico porque um literal de tipo é usado
como um padrão constante (constant pattern):

```dart
void f(Object? x) {
  if (x case [!num!]) {
    // ...
  }
}
```

#### Correções comuns

Se o literal de tipo for destinado a corresponder a um objeto do tipo fornecido, então
use um padrão de variável:

```dart
void f(Object? x) {
  if (x case num _) {
    // ...
  }
}
```

Ou um padrão de objeto:

```dart
void f(Object? x) {
  if (x case num()) {
    // ...
  }
}
```

Se o literal de tipo for destinado a corresponder ao literal de tipo, escreva-o
como um padrão constante:

```dart
void f(Object? x) {
  if (x case const (num)) {
    // ...
  }
}
```

### unawaited_futures {:#unawaited_futures}

_Faltando um 'await' para o 'Future' calculado por esta expressão._

#### Descrição

O analisador produz este diagnóstico quando uma instância de `Future` é
retornado de uma invocação dentro de um método ou função `async` (ou `async*`) e o
futuro não é aguardado nem passado para a função `unawaited`.

#### Exemplo

O código a seguir produz este diagnóstico porque a função `g`
retorna um futuro, mas o futuro não é aguardado:

```dart
Future<void> f() async {
  [!g();!]
}

Future<int> g() => Future.value(0);
```

#### Correções comuns

Se o futuro precisar ser concluído antes que o código a seguir seja executado,
então adicione um `await` antes da invocação:

```dart
Future<void> f() async {
  await g();
}

Future<int> g() => Future.value(0);
```

Se o futuro não precisar ser concluído antes que o código a seguir seja
executado, então envolva a invocação que retorna `Future` em uma invocação de
a função `unawaited` (não aguardado):

```dart
import 'dart:async';

Future<void> f() async {
  unawaited(g());
}

Future<int> g() => Future.value(0);
```

### unintended_html_in_doc_comment {:#unintended_html_in_doc_comment}

_Colchetes angulares serão interpretados como HTML._

#### Descrição

O analisador produz este diagnóstico quando um comentário de documentação
contém texto entre colchetes angulares (`<...>`) que não é uma das exceções permitidas.

Tal texto é interpretado pelo markdown como sendo uma tag HTML, o que raramente
era o que se pretendia.

Veja a [descrição da regra de lint](https://dartbrasil.dev/tools/linter-rules/unintended_html_in_doc_comment)
para a lista de exceções permitidas.

#### Exemplo

O código a seguir produz este diagnóstico porque a documentação
comentário contém o texto `<int>`, que não é uma das exceções permitidas:

```dart
/// Converte uma List[!<int>!] para uma String separada por vírgulas.
String f(List<int> l) => '';
```

#### Correções comuns

Se o texto pretendia fazer parte de um trecho de código, adicione
crases ao redor do código:

```dart
/// Converte uma `List<int>` para uma String separada por vírgulas.
String f(List<int> l) => '';
```

Se o texto pretendia fazer parte de um link, adicione colchetes
ao redor do código:

```dart
/// Converte uma [List<int>] para uma String separada por vírgulas.
String f(List<int> l) => '';
```

Se o texto pretendia ser impresso como está, incluindo o ângulo
colchetes, adicione escapes de barra invertida antes dos colchetes angulares:

```dart
/// Converte uma List\<int\> para uma String separada por vírgulas.
String f(List<int> l) => '';
```

### unnecessary_brace_in_string_interps {:#unnecessary_brace_in_string_interps}

_Chaves desnecessárias em uma interpolação de string._

#### Descrição

O analisador produz este diagnóstico quando uma interpolação de string com
chaves é usado para interpolar um identificador simples e não é seguido por
texto alfanumérico.

#### Exemplo

O código a seguir produz este diagnóstico porque a interpolação
elemento `${s}` usa chaves quando não são necessárias:

```dart
String f(String s) {
  return '"[!${s}!]"';
}
```

#### Correções comuns

Remova as chaves desnecessárias:

```dart
String f(String s) {
  return '"$s"';
}
```

### unnecessary_const {:#unnecessary_const}

_Palavra-chave 'const' desnecessária._

#### Descrição

O analisador produz este diagnóstico quando a palavra-chave `const` é usada em
um [contexto constante][contexto constante]. A palavra-chave não é necessária porque está implícita.

#### Exemplo

O código a seguir produz este diagnóstico porque a palavra-chave `const` em
o literal de lista não é necessário:

```dart
const l = [!const!] <int>[];
```

A lista é implicitamente `const` por causa da palavra-chave `const` na
declaração de variável.

#### Correções comuns

Remova a palavra-chave desnecessária:

```dart
const l = <int>[];
```

### unnecessary_constructor_name {:#unnecessary_constructor_name}

_Nome de construtor '.new' desnecessário._

#### Descrição

O analisador produz este diagnóstico quando uma referência a um construtor não nomeado
usa `.new`. O único lugar onde `.new` é necessário é em um
tear-off de construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque `.new` está sendo usado
para se referir ao construtor não nomeado onde não é necessário:

```dart
var o = Object.[!new!]();
```

#### Correções comuns

Remova o `.new` desnecessário:

```dart
var o = Object();
```

### unnecessary_final

_Variáveis locais não devem ser marcadas como 'final'._

#### Descrição

O analisador produz este diagnóstico quando uma variável local é marcada como
sendo `final`.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável local `c`
é marcado como sendo `final`:

```dart
void f(int a, int b) {
  [!final!] c = a + b;
  print(c);
}
```

#### Correções comuns

Se a variável não tiver uma anotação de tipo, substitua o `final`
com `var`:

```dart
void f(int a, int b) {
  var c = a + b;
  print(c);
}
```

Se a variável tiver uma anotação de tipo, remova o modificador `final`:

```dart
void f(int a, int b) {
  int c = a + b;
  print(c);
}
```

### unnecessary_getters_setters {:#unnecessary_getters_setters}

_Uso desnecessário de getter e setter para envolver um campo._

#### Descrição

O analisador produz este diagnóstico quando um par getter e setter
retorna e define o valor de um campo sem nenhum processamento adicional.

#### Exemplo

O código a seguir produz este diagnóstico porque o par getter/setter
nomeado `c` apenas expõe o campo nomeado `_c`:

```dart
class C {
  int? _c;

  int? get [!c!] => _c;

  set c(int? v) => _c = v;
}
```

#### Correções comuns

Torne o campo público e remova o getter e o setter:

```dart
class C {
  int? c;
}
```

### unnecessary_lambdas {:#unnecessary_lambdas}

_O Closure deve ser um tear-off._

#### Descrição

O analisador produz este diagnóstico quando um closure (lambda) pode ser
substituído por um tear-off.

#### Exemplo

O código a seguir produz este diagnóstico porque o closure passado para
`forEach` contém apenas uma invocação da função `print` com o
parâmetro do closure:

```dart
void f(List<String> strings) {
  strings.forEach([!(string) {!]
    [!print(string);!]
  [!}!]);
}
```

#### Correções comuns

Substitua o closure por um tear-off da função ou método sendo
invocado com o closure:

```dart
void f(List<String> strings) {
  strings.forEach(print);
}
```

### unnecessary_late {:#unnecessary_late}

_Modificador 'late' desnecessário._

#### Descrição

O analisador produz este diagnóstico quando uma variável de nível superior ou estática
campo com um inicializador é marcado como `late`. Variáveis de nível superior e
campos estáticos são implicitamente late, então eles não precisam ser explicitamente
marcado.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo estático `c`
tem o modificador `late` mesmo que tenha um inicializador:

```dart
class C {
  static [!late!] String c = '';
}
```

#### Correções comuns

Remova a palavra-chave `late`:

```dart
class C {
  static String c = '';
}
```

### unnecessary_library_name {:#unnecessary_library_name}

_Nomes de biblioteca não são necessários._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva `library` especifica
um nome.

#### Exemplo

O código a seguir produz este diagnóstico porque o `library`
diretiva inclui um nome:

```dart
library [!some.name!];

class C {}
```

#### Correções comuns

Remova o nome da diretiva `library`:

```dart
library;

class C {}
```

Se a biblioteca tiver alguma parte, qualquer declaração `part of` que use
o nome da biblioteca deve ser atualizado para usar o URI da biblioteca em vez disso.

### unnecessary_new {:#unnecessary_new}

_Palavra-chave 'new' desnecessária._

#### Descrição

O analisador produz este diagnóstico quando a palavra-chave `new` é usada para
invocar um construtor.

#### Exemplo

O código a seguir produz este diagnóstico porque a palavra-chave `new` é
usado para invocar o construtor não nomeado de `Object`:

```dart
var o = [!new!] Object();
```

#### Correções comuns

Remova a palavra-chave `new`:

```dart
var o = Object();
```

### unnecessary_null_aware_assignments {:#unnecessary_null_aware_assignments}

_Atribuição desnecessária de 'null'._

#### Descrição

O analisador produz este diagnóstico quando o lado direito de uma
atribuição null-aware é o literal `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque o null aware
operador está sendo usado para atribuir `null` a `s` quando `s` já é `null`:

```dart
void f(String? s) {
  [!s ??= null!];
}
```

#### Correções comuns

Se um valor não nulo deve ser atribuído ao operando do lado esquerdo,
altere o lado direito:

```dart
void f(String? s) {
  s ??= '';
}
```

Se não houver um valor não nulo para atribuir ao operando do lado esquerdo,
remova a atribuição:

```dart
void f(String? s) {
}
```

### unnecessary_null_in_if_null_operators {:#unnecessary_null_in_if_null_operators}

_Uso desnecessário de '??' com 'null'._

#### Descrição

O analisador produz este diagnóstico quando o operando direito do `??`
operador é o literal `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque o operando do lado direito
do operador `??` é `null`:

```dart
String? f(String? s) => s ?? [!null!];
```

#### Correções comuns

Se um valor não nulo deve ser usado para o operando do lado direito,
altere o lado direito:

```dart
String f(String? s) => s ?? '';
```

Se não houver valor não nulo para usar para o operando do lado direito,
remova o operador e o operando do lado direito:

```dart
String? f(String? s) => s;
```

### unnecessary_nullable_for_final_variable_declarations {:#unnecessary_nullable_for_final_variable_declarations}

_O tipo poderia ser não anulável._

#### Descrição

O analisador produz este diagnóstico quando um campo ou variável final tem um
tipo anulável, mas é inicializado para um valor não anulável.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável final `i`
tem um tipo anulável (`int?`), mas nunca pode ser `null`:

```dart
final int? [!i!] = 1;
```

#### Correções comuns

Torne o tipo não anulável:

```dart
final int i = 1;
```

### unnecessary_overrides {:#unnecessary_overrides}

_Substituição desnecessária._

#### Descrição

O analisador produz este diagnóstico quando um membro de instância substitui um
membro herdado, mas apenas invoca o membro substituído com exatamente os
mesmos argumentos.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `D.m`
não faz nada além de invocar o método substituído:

```dart
class C {
  int m(int x) => x;
}

class D extends C {
  @override
  int [!m!](int x) => super.m(x);
}
```

#### Correções comuns

Se o método deve fazer algo mais do que o método substituído
faz, então implemente a funcionalidade ausente:

```dart
class C {
  int m(int x) => x;
}

class D extends C {
  @override
  int m(int x) => super.m(x) + 1;
}
```

Se o método substituído deve ser modificado alterando o tipo de retorno ou
um ou mais dos tipos de parâmetro, tornando um dos parâmetros
`covariant`, tendo um comentário de documentação, ou tendo adicionais
anotações, atualize o código:

```dart
import 'package:meta/meta.dart';

class C {
  int m(int x) => x;
}

class D extends C {
  @mustCallSuper
  @override
  int m(int x) => super.m(x);
}
```

Se o método de substituição não alterar ou aprimorar a semântica do
código, então remova-o:

```dart
class C {
  int m(int x) => x;
}

class D extends C {}
```

### unnecessary_parenthesis {:#unnecessary_parenthesis}

_Uso desnecessário de parênteses._

#### Descrição

O analisador produz este diagnóstico quando os parênteses são usados onde eles
não afetam a semântica do código.

#### Exemplo

O código a seguir produz este diagnóstico porque os parênteses em torno
a expressão binária não são necessários:

```dart
int f(int a, int b) => [!(a + b)!];
```

#### Correções comuns

Remova os parênteses desnecessários:

```dart
int f(int a, int b) => a + b;
```

### unnecessary_raw_strings {:#unnecessary-raw_strings}

_Uso desnecessário de uma raw string._

#### Descrição

O analisador produz este diagnóstico quando um literal de string é marcado como
sendo raw (é prefixado com um `r`), mas tornar a string raw não
altera o valor da string.

#### Exemplo

O código a seguir produz este diagnóstico porque o literal de string
terá o mesmo valor sem o `r` que tem com o `r`:

```dart
var s = [!r'abc'!];
```

#### Correções comuns

Remova o `r` na frente do literal de string:

```dart
var s = 'abc';
```

### unnecessary_statements {:#unnecessary_statements}

_Instrução desnecessária._

#### Descrição

O analisador produz este diagnóstico quando uma instrução de expressão não tem
efeito claro.

#### Exemplo

O código a seguir produz este diagnóstico porque a adição do
valores retornados pelas duas invocações não tem efeito claro:

```dart
void f(int Function() first, int Function() second) {
  [!first() + second()!];
}
```

#### Correções comuns

Se a expressão não precisar ser calculada, remova-a:

```dart
void f(int Function() first, int Function() second) {
}
```

Se o valor da expressão for necessário, use-o, possivelmente
atribuindo-o primeiro a uma variável local:

```dart
void f(int Function() first, int Function() second) {
  print(first() + second());
}
```

Se partes da expressão precisam ser executadas, então remova as
partes desnecessárias:

```dart
void f(int Function() first, int Function() second) {
  first();
  second();
}
```

### unnecessary_string_escapes {:#unnecessary-string-escapes}

_Escape desnecessário em string literal._

#### Descrição

O analisador produz este diagnóstico quando caracteres em uma string são
escapados quando escapá-los é desnecessário.

#### Exemplo

O código a seguir produz este diagnóstico porque aspas simples não
precisam ser escapadas dentro de strings delimitadas por aspas duplas:

```dart
var s = "Don[!\!]'t use a backslash here.";
```

#### Correções comuns

Remova as barras invertidas desnecessárias:

```dart
var s = "Don't use a backslash here.";
```

### unnecessary_string_interpolations {:#unnecessary-string-interpolations}

_Uso desnecessário de interpolação de string._

#### Descrição

O analisador produz este diagnóstico quando um string literal contém uma
única interpolação de uma variável de valor `String` e nenhum outro
caractere.

#### Exemplo

O código a seguir produz este diagnóstico porque o string literal
contém uma única interpolação e não contém nenhum caractere fora
da interpolação:

```dart
String f(String s) => [!'$s'!];
```

#### Correções comuns

Substitua o literal de string pelo conteúdo da interpolação:

```dart
String f(String s) => s;
```

### unnecessary_this {:#unnecessary_this}

_Qualificador 'this.' desnecessário._

#### Descrição

O analisador produz este diagnóstico quando a palavra-chave `this` é usada para
acessar um membro que não está sombreado (shadowed).

#### Exemplo

O código a seguir produz este diagnóstico porque o uso de `this` para
acessar o campo `_f` não é necessário:

```dart
class C {
  int _f = 2;

  int get f => [!this!]._f;
}
```

#### Correções comuns

Remova o `this.`:

```dart
class C {
  int _f = 2;

  int get f => _f;
}
```

### unnecessary_to_list_in_spreads {:#unnecessary_to_list_in_spreads}

_Uso desnecessário de 'toList' em um spread._

#### Descrição

O analisador produz este diagnóstico quando `toList` é usado para converter um
`Iterable` em uma `List` (Lista)  imediatamente antes de um operador spread ser aplicado à
lista. O operador spread pode ser aplicado a qualquer `Iterable`, então a
conversão não é necessária.

#### Exemplo

O código a seguir produz este diagnóstico porque `toList` é invocado no
resultado de `map`, que é um `Iterable` ao qual o operador spread poderia
ser aplicado diretamente:

```dart
List<String> toLowercase(List<String> strings) {
  return [
    ...strings.map((String s) => s.toLowerCase()).[!toList!](),
  ];
}
```

#### Correções comuns

Remova a invocação de `toList`:

```dart
List<String> toLowercase(List<String> strings) {
  return [
    ...strings.map((String s) => s.toLowerCase()),
  ];
}
```

### unnecessary_underscores

_Uso desnecessário de múltiplos underscores (sublinhados)._

#### Descrição

O analisador produz este diagnóstico quando uma variável não utilizada é nomeada
com múltiplos underscores (por exemplo, `__`). Uma única variável curinga `_`
pode ser usada em vez disso.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro `__` não é usado:

```dart
void function(int [!__!]) { }
```

#### Correções Comuns

Substitua o nome por um único underscore:

```dart
void function(int _) { }
```

### unrelated_type_equality_checks {:#unrelated_type_equality_checks}

_O tipo do operando ('{0}') não é um subtipo ou um supertipo do valor que
está sendo comparado ('{1}')._

_O tipo do operando direito ('{0}') não é um subtipo ou um supertipo do
operando esquerdo ('{1}')._

#### Descrição

O analisador produz este diagnóstico quando dois objetos estão sendo comparados
e nenhum dos tipos estáticos dos dois objetos é um subtipo do
outro.

Essa comparação geralmente retornará `false` e pode não refletir a
intenção do programador.

Pode haver falsos positivos. Por exemplo, uma classe chamada `Point` pode
ter subclasses chamadas `CartesianPoint` e `PolarPoint`, nenhuma das quais
é um subtipo da outra, mas ainda pode ser apropriado testar a
igualdade de instâncias.

Como um caso concreto, as classes `Int64` e `Int32` do `package:fixnum`
permitem comparar instâncias com um `int` desde que o `int` esteja no
lado direito. Este caso é especificamente permitido pelo diagnóstico, mas
outros casos semelhantes não são.

#### Exemplo

O código a seguir produz este diagnóstico porque a string `s` está
sendo comparada com o inteiro `1`:

```dart
bool f(String s) {
  return s [!==!] 1;
}
```

#### Correções comuns

Substitua um dos operandos por algo compatível com o outro
operando:

```dart
bool f(String s) {
  return s.length == 1;
}
```

### unsafe_variance {:#unsafe_variance}

_Este tipo não é seguro: um parâmetro de tipo ocorre em uma posição não
covariante._

#### Descrição

Este lint avisa contra a declaração de membros não covariantes.

Uma variável de instância cujo tipo contém um parâmetro de tipo da
classe, mixin ou enum circundante em uma posição não covariante
provavelmente causará falhas em tempo de execução devido à falha em verificações de tipo.
Por exemplo, em `class C<X> {...}`, uma variável de instância
da forma `void Function(X) myVariable;` pode causar esse tipo
de falha em tempo de execução.

O mesmo vale para um getter ou método cujo tipo de retorno tenha uma
ocorrência não covariante de um parâmetro de tipo da
declaração circundante.

Este lint sinaliza esse tipo de declaração de membro.

#### Exemplo

**INCORRETO:**
```dart
class C<X> {
  final bool Function([!X!]) fun; // LINT
  C(this.fun);
}

void main() {
  C<num> c = C<int>((i) => i.isEven);
  c.fun(10); // Lança exceção.
}
```

O problema é que `X` ocorre como um tipo de parâmetro no tipo
de `fun`.

#### Correções comuns

Uma maneira de reduzir o potencial de erros de tipo em tempo de execução é
garantir que o membro não covariante `fun` seja _apenas_ usado em
`this`. Não podemos impor isso estritamente, mas podemos torná-lo
privado e adicionar um método de encaminhamento `fun` para que possamos verificar
localmente na mesma biblioteca que esta restrição é satisfeita:

**MELHOR:**
```dart
class C<X> {
  // NB: Ensure manually that `_f` is only accessed on `this`.
  // ignore: unsafe_variance
  bool Function(X) _f;

void main() {
  C<num> c = C<int>((i) => i.isEven);
  c.fun(10); // Sucesso.
}
```

Uma abordagem totalmente segura requer um recurso que Dart ainda não
possui, nomeadamente variância verificada estaticamente. Com isso,
poderíamos especificar que o parâmetro de tipo `X` é invariante (`inout X`).

É possível emular a invariância sem suporte para verificação estática
de variância. Isso impõe algumas restrições à criação de
subtipos, mas fornece fielmente a tipagem que `inout` daria:

**BOM:**
```dart
typedef Inv<X> = X Function(X);
typedef C<X> = _C<X, Inv<X>>;

class _C<X, Invariance extends Inv<X>> {
  // ignore: unsafe_variance
  final bool Function(X) fun; // Seguro!
  _C(this.fun);
}

void main() {
  C<int> c = C<int>((i) => i.isEven);
  c.fun(10); // Sucesso.
}
```

Com esta abordagem, `C<int>` não é um subtipo de `C<num>`, então
`c` deve ter um tipo declarado diferente.

Outra possibilidade é declarar que a variável tenha um tipo seguro
mas mais geral. É seguro usar a variável
em si, mas cada invocação terá que ser verificada em tempo de
execução:

**HONESTO:**
```dart
class C<X> {
  final bool Function(Never) fun;
  C(this.fun);
}

void main() {
  C<num> c = C<int>((int i) => i.isEven);
  var cfun = c.fun; // Variável local, permite promoção.
  if (cfun is bool Function(int)) cfun(10); // Sucesso.
  if (cfun is bool Function(bool)) cfun(true); // Não chamado.
}
```

### use_build_context_synchronously {:#use_build_context_synchronously}

_Não use 'BuildContext's em gaps assíncronos, protegidos por uma verificação
'mounted' não relacionada._

_Não use 'BuildContext's em gaps assíncronos._

#### Descrição

O analisador produz este diagnóstico quando um `BuildContext` é referenciado
por um `StatefulWidget` após um gap assíncrono sem primeiro verificar a
propriedade `mounted`.

Armazenar um `BuildContext` para uso posterior pode levar a falhas difíceis
de diagnosticar. Gaps assíncronos armazenam implicitamente um `BuildContext`,
tornando-os fáceis de ignorar para o diagnóstico.

#### Exemplo

O código a seguir produz este diagnóstico porque o `context` é
passado para um construtor após o `await`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of([!context!]).pop();
  }
}
```

#### Correções comuns

Se você puder remover o gap assíncrono, faça-o:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) {
    Navigator.of(context).pop();
  }
}
```

Se você não puder remover o gap assíncrono, use `mounted` para proteger o
uso do `context`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
```

### use_colored_box {:#use_colored_box}

_Use um 'ColoredBox' em vez de um 'Container' com apenas um 'Color'._

#### Descrição

O analisador produz este diagnóstico quando um `Container` é criado que
apenas define a cor.

#### Exemplo

O código a seguir produz este diagnóstico porque o único atributo do
container que está definido é o `color`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!Container!](
    color: Colors.red,
    child: const Text('hello'),
  );
}
```

#### Correções comuns

Substitua o `Container` por um `ColoredBox`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return ColoredBox(
    color: Colors.red,
    child: const Text('hello'),
  );
}
```

### use_decorated_box {:#use_decorated_box}

_Use 'DecoratedBox' em vez de um 'Container' com apenas um 'Decoration'._

#### Descrição

O analisador produz este diagnóstico quando um `Container` é criado que
apenas define a decoração.

#### Exemplo

O código a seguir produz este diagnóstico porque o único atributo do
container que está definido é a `decoration` (decoração):

```dart
import 'package:flutter/material.dart';

Widget buildArea() {
  return [!Container!](
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: const Text('...'),
  );
}
```

#### Correções comuns

Substitua o `Container` por um `DecoratedBox`:

```dart
import 'package:flutter/material.dart';

Widget buildArea() {
  return DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: const Text('...'),
  );
}
```

### use_full_hex_values_for_flutter_colors {:#use_full_hex_values_for_flutter_colors}

_Instâncias de 'Color' devem ser criadas usando um inteiro hexadecimal de 8
dígitos (como '0xFFFFFFFF')._

#### Descrição

O analisador produz este diagnóstico quando o argumento para o construtor
da classe `Color` é um inteiro literal que não é representado como um
inteiro hexadecimal de 8 dígitos.

#### Exemplo

O código a seguir produz este diagnóstico porque o argumento (`1`)
não é representado como um inteiro hexadecimal de 8 dígitos:

```dart
import 'package:flutter/material.dart';

Color c = Color([!1!]);
```

#### Correções comuns

Converta a representação para ser um inteiro hexadecimal de 8 dígitos:

```dart
import 'package:flutter/material.dart';

Color c = Color(0x00000001);
```

### use_function_type_syntax_for_parameters {:#use_function_type_syntax_for_parameters}

_Use a sintaxe de tipo de função genérica para declarar o parâmetro '{0}'._

#### Descrição

O analisador produz este diagnóstico quando a sintaxe de parâmetro com
valor de função de estilo antigo é usada.

#### Exemplo

O código a seguir produz este diagnóstico porque o parâmetro com valor de
função `f` é declarado usando uma sintaxe de estilo antigo:

```dart
void g([!bool f(String s)!]) {}
```

#### Correções comuns

Use a sintaxe de tipo de função genérica para declarar o parâmetro:

```dart
void g(bool Function(String) f) {}
```

### use_if_null_to_convert_nulls_to_bools {:#use_if_null_to_convert_nulls_to_bools}

_Use um operador if-null para converter um 'null' em um 'bool'._

#### Descrição

O analisador produz este diagnóstico quando uma expressão anulável com
valor `bool` é comparada (usando `==` ou `!=`) a um literal booleano.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável booleana
anulável `b` é comparada a `true`:

```dart
void f(bool? b) {
  if ([!b == true!]) {
    // Trata `null` como `false`.
  }
}
```

#### Correções comuns

Reescreva a condição para usar `??` em vez disso:

```dart
void f(bool? b) {
  if (b ?? false) {
    // Trata `null` como `false`.
  }
}
```

### use_key_in_widget_constructors {:#use_key_in_widget_constructors}

_Construtores para widgets públicos devem ter um parâmetro nomeado 'key'._

#### Descrição

O analisador produz este diagnóstico quando um construtor em uma subclasse de
`Widget` que não é privado para sua biblioteca não tem um parâmetro nomeado
`key` (chave).

#### Exemplo

O código a seguir produz este diagnóstico porque o construtor para a
classe `MyWidget` não tem um parâmetro chamado `key`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  [!MyWidget!]({required int height});
}
```

O código a seguir produz este diagnóstico porque o construtor padrão
para a classe `MyWidget` não tem um parâmetro chamado `key`:

```dart
import 'package:flutter/material.dart';

class [!MyWidget!] extends StatelessWidget {}
```

#### Correções comuns

Adicione um parâmetro chamado `key` ao construtor, declarando
explicitamente o construtor, se necessário:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key, required int height});
}
```

### use_late_for_private_fields_and_variables {:#use_late_for_private_fields_and_variables}

_Use 'late' para membros privados com um tipo não anulável._

#### Descrição

O analisador produz este diagnóstico quando um campo ou variável privado é
marcado como sendo anulável, mas cada referência assume que a variável nunca
é `null`.

#### Exemplo

O código a seguir produz este diagnóstico porque a variável privada de
nível superior `_i` é anulável, mas cada referência assume que ela não
será `null`:

```dart
void f() {
  _i!.abs();
}

int? [!_i!];
```

#### Correções comuns

Marque a variável ou campo como sendo não anulável e `late` para
indicar que ela sempre será atribuída com um valor não nulo:

```dart
void f() {
  _i.abs();
}

late int _i;
```

### use_named_constants {:#use_named_constants}

_Use a constante '{0}' em vez de um construtor que retorna o mesmo
objeto._

#### Descrição

O analisador produz este diagnóstico quando uma constante é criada com o
mesmo valor de uma variável `const` conhecida.

#### Exemplo

O código a seguir produz este diagnóstico porque existe um
campo `const` conhecido (`Duration.zero`) cujo valor é o mesmo que o
que a invocação do construtor irá avaliar:

```dart
Duration d = [!const Duration(seconds: 0)!];
```

#### Correções comuns

Substitua a invocação do construtor por uma referência à variável
`const` conhecida:

```dart
Duration d = Duration.zero;
```

### use_raw_strings {:#use_raw_strings}

_Use uma string raw para evitar o uso de escapes._

#### Descrição

O analisador produz este diagnóstico quando um literal de string contendo
escapes, e nenhuma interpolação, poderia ser marcado como raw para
evitar a necessidade de escapes.

#### Exemplo

O código a seguir produz este diagnóstico porque a string contém
caracteres de escape que não precisariam ser escapados se a string fosse
feita uma string raw:

```dart
var s = [!'A string with only \\ and \$'!];
```

#### Correções comuns

Marque a string como raw e remova as barras invertidas desnecessárias:

```dart
var s = r'A string with only \ and $';
```

### use_rethrow_when_possible {:#use_rethrow_when_possible}

_Use 'rethrow' para relançar uma exceção capturada._

#### Descrição

O analisador produz este diagnóstico quando uma exceção capturada é lançada
usando uma expressão `throw` em vez de uma declaração `rethrow`.

#### Exemplo

O código a seguir produz este diagnóstico porque a exceção capturada
`e` é lançada usando uma expressão `throw`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    [!throw e!];
  }
}
```

#### Correções comuns

Use `rethrow` em vez de `throw`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    rethrow;
  }
}
```

### use_setters_to_change_properties {:#use_setters_to_change_properties}

_O método é usado para alterar uma propriedade._

#### Descrição

O analisador produz este diagnóstico quando um método é usado para definir o
valor de um campo, ou uma função é usada para definir o valor de uma variável
de nível superior, e nada mais.

#### Exemplo

O código a seguir produz este diagnóstico porque o método `setF` é
usado para definir o valor do campo `_f` e não faz nenhum outro trabalho:

```dart
class C {
  int _f = 0;

  void [!setF!](int value) => _f = value;
}
```

#### Correções comuns

Converta o método para um setter:

```dart
class C {
  int _f = 0;

  set f(int value) => _f = value;
}
```

### use_string_buffers {:#use_string_buffers}

_Use um buffer de string em vez de '+' para compor strings._

#### Descrição

O analisador produz este diagnóstico quando os valores são concatenados a
uma string dentro de um loop sem usar um `StringBuffer` para fazer a
concatenação.

#### Exemplo

O código a seguir produz este diagnóstico porque a string `result` é
calculada por concatenação repetida dentro do loop `for`:

```dart
String f() {
  var result = '';
  for (int i = 0; i < 10; i++) {
    [!result += 'a'!];
  }
  return result;
}
```

#### Correções comuns

Use um `StringBuffer` para calcular o resultado:

```dart
String f() {
  var buffer = StringBuffer();
  for (int i = 0; i < 10; i++) {
    buffer.write('a');
  }
  return buffer.toString();
}
```

### use_string_in_part_of_directives {:#use_string_in_part_of_directives}

_A diretiva part-of usa um nome de biblioteca._

#### Descrição

O analisador produz este diagnóstico quando uma diretiva `part of` usa um
nome de biblioteca para se referir à biblioteca da qual a parte faz parte.

#### Exemplo

Dado um arquivo chamado `lib.dart` que contém o seguinte:

```dart
library lib;

part 'test.dart';
```

O código a seguir produz este diagnóstico porque a diretiva `part of`
usa o nome da biblioteca em vez do URI da biblioteca da qual
faz parte:

```dart
[!part of lib;!]
```

#### Correções comuns

Use um URI para referenciar a biblioteca:

```dart
part of 'lib.dart';
```

### use_super_parameters {:#use_super_parameters}

_O parâmetro '{0}' pode ser um super parâmetro._

_Os parâmetros '{0}' podem ser super parâmetros._

#### Descrição

O analisador produz este diagnóstico quando um parâmetro para um construtor
é passado para um super construtor sem ser referenciado ou modificado e um
parâmetro `super` não é usado.

#### Exemplo

O código a seguir produz este diagnóstico porque os parâmetros do
construtor para `B` são usados apenas como argumentos para o super
construtor:

```dart
class A {
  A({int? x, int? y});
}
class B extends A {
  [!B!]({int? x, int? y}) : super(x: x, y: y);
}
```

#### Correções comuns

Use um parâmetro `super` para passar os argumentos:

```dart
class A {
  A({int? x, int? y});
}
class B extends A {
  B({super.x, super.y});
}
```

### use_truncating_division {:#use_truncating_division}

_Use divisão truncada._

#### Descrição

O analisador produz este diagnóstico quando o resultado da divisão de dois
números é convertido em um inteiro usando `toInt`.

Dart tem um operador de divisão inteira embutido que é mais eficiente
e mais conciso.

#### Exemplo

O código a seguir produz este diagnóstico porque o resultado da divisão
de `x` e `y` é convertido em um inteiro usando `toInt`:

```dart
int divide(int x, int y) => [!(x / y).toInt()!];
```

#### Correções comuns

Use o operador de divisão inteira (`~/`):

```dart
int divide(int x, int y) => x ~/ y;
```

### valid_regexps {:#valid_regexps}

_Sintaxe de expressão regular inválida._

#### Descrição

O analisador produz este diagnóstico quando a string passada para o
construtor padrão da classe `RegExp` não contém uma expressão regular
válida.

Uma expressão regular criada com sintaxe inválida lançará uma
`FormatException` em tempo de execução.

#### Exemplo

O código a seguir produz este diagnóstico porque a expressão regular
não é válida:

```dart
var r = RegExp([!r'('!]);
```

#### Correções comuns

Corrija a expressão regular:

```dart
var r = RegExp(r'\(');
```

### void_checks {:#void_checks}

_Atribuição a uma variável do tipo 'void'._

#### Descrição

O analisador produz este diagnóstico quando um valor é atribuído a uma
variável do tipo `void`.

Não é possível acessar o valor de tal variável, então a
atribuição não tem valor.

#### Exemplo

O código a seguir produz este diagnóstico porque o campo `value` tem
o tipo `void`, mas um valor está sendo atribuído a ele:

```dart
class A<T> {
  T? value;
}

void f(A<void> a) {
  [!a.value = 1!];
}
```

O código a seguir produz este diagnóstico porque o tipo do
parâmetro `p` no método `m` é `void`, mas um valor está sendo atribuído
a ele na invocação:

```dart
class A<T> {
  void m(T p) { }
}

void f(A<void> a) {
  a.m([!1!]);
}
```

#### Correções comuns

Se o tipo da variável estiver incorreto, altere o tipo da
variável:

```dart
class A<T> {
  T? value;
}

void f(A<int> a) {
  a.value = 1;
}
```

Se o tipo da variável estiver correto, remova a atribuição:

```dart
class A<T> {
  T? value;
}

void f(A<void> a) {}
```