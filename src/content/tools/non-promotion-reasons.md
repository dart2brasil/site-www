---
title: Fixing type promotion failures
description: >-
  Solutions for cases where you know more about a
  field's type than Dart can determine.
ia-translate: true
---

[Type promotion][] ocorre quando a análise de fluxo pode confirmar de forma sólida
que uma variável com um [tipo nullable][] *não é null*, e
que ela não mudará a partir desse ponto.
Muitas circunstâncias podem enfraquecer a solidez de um tipo,
causando falha na promoção de tipo.

Esta página lista as razões pelas quais falhas de promoção de tipo ocorrem,
com dicas sobre como corrigi-las.
Para saber mais sobre análise de fluxo e promoção de tipo,
confira a página [Understanding null safety][].

[Type promotion]: /null-safety/understanding-null-safety#type-promotion-on-null-checks
[nullable type]: /null-safety/understanding-null-safety#non-nullable-and-nullable-types
[Understanding null safety]: /null-safety/understanding-null-safety

## Versão de linguagem não suportada para promoção de campo {:#language-version}

**A causa:**
Você está tentando promover um campo, mas a promoção de campo é versionada por linguagem,
e seu código está definido para uma versão de linguagem anterior à 3.2.

Se você já está usando uma versão do SDK >= Dart 3.2,
seu código ainda pode estar explicitamente direcionado para uma [versão de linguagem][language version] anterior.
Isso pode acontecer porque:

* Seu [`pubspec.yaml`][] declara uma constraint SDK com um
  limite inferior abaixo de 3.2, ou
* Você tem um comentário `// @dart=version` no topo do arquivo,
  onde `version` é inferior a 3.2.

**Exemplo:**

```dart tag=bad
// @dart=3.1

class C {
  final int? _i;
  C(this._i);

  void f() {
    if (_i != null) {
      int i = _i;  // ERROR
    }
  }
}
```

**Mensagem:**

```plaintext
'_i' refers to a field. It couldn't be promoted because field promotion is only available in Dart 3.2 and above.
```

**Solução:**

Certifique-se de que sua biblioteca não está usando uma [versão de linguagem][language version] anterior à 3.2.
Verifique o topo do seu arquivo em busca de um comentário `// @dart=version` desatualizado,
ou seu `pubspec.yaml` em busca de um [limite inferior de constraint SDK][SDK constraint lower-bound] desatualizado.

[`pubspec.yaml`]: /tools/pub/pubspec
[SDK constraint lower-bound]: /tools/pub/pubspec#sdk-constraints

## Apenas variáveis locais podem ser promovidas (antes do Dart 3.2) {:#property}

**A causa:**
Você está tentando promover uma propriedade,
mas apenas variáveis locais podem ser promovidas em versões Dart anteriores à 3.2,
e você está usando uma versão anterior à 3.2.

**Exemplo:**

```dart tag=bad
class C {
  int? i;
  void f() {
    if (i == null) return;
    print(i.isEven);       // ERROR
  }
}
```

**Mensagem:**

```plaintext
'i' refers to a property so it couldn't be promoted.
```

**Solução:**

Se você está usando Dart 3.1 ou anterior, [atualize para 3.2 ou posterior][upgrade].

Se você precisa continuar usando uma versão mais antiga,
leia [Outras causas e soluções alternativas](#other-causes-and-workarounds)

[upgrade]: /get-dart

## Outras causas e soluções alternativas

Os exemplos restantes nesta página documentam razões para falhas de promoção
não relacionadas a inconsistências de versão,
tanto para falhas de campo quanto de variável local, com exemplos e soluções alternativas.

Em geral, as correções usuais para falhas de promoção
são uma ou mais das seguintes:

* Atribuir o valor da propriedade a uma variável local com
  o tipo não-nullable que você precisa.
* Adicionar uma verificação explícita de null (por exemplo, `i == null`).
* Usar `!` ou `as` como uma [verificação redundante](#redundant-check)
  se você tem certeza de que uma expressão não pode ser `null`.

Aqui está um exemplo de criação de uma variável local
(que pode ser nomeada `i`)
que contém o valor de `i`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (property-copy)" replace="/final.*/[!$&!]/g"?>
```dart tag=good
class C {
  int? i;
  void f() {
    [!final i = this.i;!]
    if (i == null) return;
    print(i.isEven);
  }
}
```

Este exemplo apresenta um campo de instância,
mas poderia usar em vez disso um getter de instância, um campo ou getter estático,
uma variável ou getter de nível superior, ou [`this`](#this).

:::tip
Ao criar uma variável local para conter o valor de um campo,
**torne a variável `final`**.
Dessa forma, você não pode acidentalmente atualizar a variável local
quando pretende atualizar o campo.
:::

E aqui está um exemplo de uso de `i!`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (property-bang)" replace="/!/[!!!]/g"?>
```dart tag=good
print(i[!!!].isEven);
```


<a id="redundant-check" aria-hidden="true"></a>

:::note
Você pode contornar todos esses exemplos de não-promoção adicionando
uma _verificação redundante_—código que confirma uma
condição que já foi verificada.
Se a promoção que está falhando é uma verificação de null, use `!`;
se é uma verificação de tipo, você pode usar `as`.

Verificações redundantes são uma solução fácil, mas propensa a erros,
para falhas de promoção de tipo.
Como elas sobrepõem o compilador,
podem levar a erros de uma forma que outras soluções não levam.

Cabe a você decidir se faz o trabalho extra para fazer os tipos promoverem
(dando-lhe confiança de que o código está correto)
ou fazer uma verificação redundante
(que pode introduzir um bug se seu raciocínio estiver errado).
:::


### Não é possível promover `this` {:#this}

**A causa:**
Você está tentando promover `this`,
mas a promoção de tipo para `this` ainda não é suportada.

Um cenário comum de promoção de `this` é ao escrever [métodos de extensão][extension methods].
Se o [tipo `on`][`on` type] do método de extensão é um tipo nullable,
você gostaria de fazer uma verificação de null para ver se `this` é `null`:

**Exemplo:**

```dart tag=bad
extension on int? {
  int get valueOrZero {
    return this == null ? 0 : this; // ERROR
  }
}
```

**Mensagem:**

```plaintext
`this` can't be promoted.
```

**Solução:**

Crie uma variável local para conter o valor de `this`,
então execute a verificação de null.

<?code-excerpt "non_promotion/lib/non_promotion.dart (this)" replace="/final.*/[!$&!]/g"?>
```dart tag=good
extension on int? {
  int get valueOrZero {
    [!final self = this;!]
    return self == null ? 0 : self;
  }
}
```

[extension methods]: /language/extension-methods
[`on` type]: /language/extension-methods#implementing-extension-methods

### Apenas campos privados podem ser promovidos {:#private}

**A causa:**
Você está tentando promover um campo, mas o campo não é privado.

É possível que outras bibliotecas em seu programa
sobrescrevam campos públicos com um getter. Como
[getters podem não retornar um valor estável](#not-field),
e o compilador não pode saber o que outras bibliotecas estão fazendo,
campos não privados não podem ser promovidos.

**Exemplo:**

```dart tag=bad
class Example {
  final int? value;
  Example(this.value);
}

void test(Example x) {
  if (x.value != null) {
    print(x.value + 1); // ERROR
  }
}
```

**Mensagem:**

```plaintext
'value' refers to a public property so it couldn't be promoted.
```

**Solução:**

Tornar o campo privado permite que o compilador tenha certeza de que nenhuma biblioteca externa
poderia possivelmente sobrescrever seu valor, então é seguro promover.

<?code-excerpt "non_promotion/lib/non_promotion.dart (private)" replace="/_val/_value/g; /_value;/[!_value!];/g; /PrivateFieldExample/Example/g;"?>
```dart tag=good
class Example {
  final int? [!_value!];
  Example(this._value);
}

void test(Example x) {
  if (x._value != null) {
    print(x._value + 1);
  }
}
```

### Apenas campos final podem ser promovidos {:#final}

**A causa:**
Você está tentando promover um campo, mas o campo não é final.

Para o compilador, campos não-final poderiam, em princípio,
ser modificados a qualquer momento entre o momento
em que são testados e o momento em que são usados.
Então não é seguro para o compilador promover um tipo nullable não-final
para um tipo não-nullable.

**Exemplo:**

```dart tag=bad
class Example {
  int? _mutablePrivateField;
  Example(this._mutablePrivateField);

  void f() {
    if (_mutablePrivateField != null) {
      int i = _mutablePrivateField; // ERROR
    }
  }
}
```

**Mensagem:**

```plaintext
'_mutablePrivateField' refers to a non-final field so it couldn't be promoted.
```

**Solução:**

Torne o campo `final`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (final)" replace="/final/[!$&!]/g; /FinalExample/Example/g;"?>
```dart tag=good
class Example {
  [!final!] int? _immutablePrivateField;
  Example(this._immutablePrivateField);

  void f() {
    if (_immutablePrivateField != null) {
      int i = _immutablePrivateField; // OK
    }
  }
}
```

### Getters não podem ser promovidos {:#not-field}

**A causa:** Você está tentando promover um getter,
mas apenas *campos* de instância podem ser promovidos, não getters de instância.

O compilador não tem como garantir que
um getter retorne o mesmo resultado toda vez.
Como sua estabilidade não pode ser confirmada,
getters não são seguros para promover.

**Exemplo:**

```dart tag=bad
import 'dart:math';

abstract class Example {
  int? get _value => Random().nextBool() ? 123 : null;
}

void f(Example x) {
  if (x._value != null) {
    print(x._value.isEven); // ERROR
  }
}
```

**Mensagem:**

```plaintext
'_value' refers to a getter so it couldn't be promoted.
```

**Solução:**

Atribua o getter a uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (not-field)" plaster="" replace="/final.*/[!$&!]/g; /NotFieldExample/Example/g;"?>
```dart tag=good
import 'dart:math';

abstract class Example {
  int? get _value => Random().nextBool() ? 123 : null;
}

void f(Example x) {
  [!final value = x._value;!]
  if (value != null) {
    print(value.isEven); // OK
  }
}
```

:::note
A análise de fluxo considera getters `abstract` estáveis o suficiente para
permitir promoção de tipo, desde que não haja declarações conflitantes.
:::

### Campos external não podem ser promovidos {:#external}

**A causa:**
Você está tentando promover um campo, mas o campo está marcado como `external`.

Campos external não promovem porque são essencialmente getters externos;
sua implementação é código de fora do Dart,
então não há garantia para o compilador de que um campo external
retornará o mesmo valor cada vez que for chamado.

**Exemplo:**

```dart tag=bad
class Example {
  external final int? _externalField;

  void f() {
    if (_externalField != null) {
      print(_externalField.isEven); // ERROR
    }
  }
}
```

**Mensagem:**

```plaintext
'_externalField' refers to an external field so it couldn't be promoted.
```

**Solução:**

Atribua o valor do campo external a uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (external)" replace="/final i =.*/[!$&!]/g; /ExternalExample/Example/g;"?>
```dart tag=good
class Example {
  external final int? _externalField;

  void f() {
    [!final i = _externalField;!]
    if (i != null) {
      print(i.isEven); // OK
    }
  }
}
```

### Conflito com getter em outro lugar da biblioteca {:#getter-name}

**A causa:**
Você está tentando promover um campo,
mas outra classe na mesma biblioteca contém
um getter concreto com o mesmo nome.

**Exemplo:**

```dart tag=bad
import 'dart:math';

class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? get _overridden => Random().nextBool() ? 1 : null;
}

void testParity(Example x) {
  if (x._overridden != null) {
    print(x._overridden.isEven); // ERROR
  }
}
```

**Mensagem:**

```plaintext
'_overriden' couldn't be promoted because there is a conflicting getter in class 'Override'.
```

**Solução**:

Se o getter e o campo estão relacionados e precisam compartilhar seu nome
(como quando um deles sobrescreve o outro, como no exemplo acima),
então você pode habilitar a promoção de tipo atribuindo o valor a uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (conflicting-getter)" plaster="" replace="/final i =.*/[!$&!]/g; /GetterExample/Example/g;"?>
```dart tag=good
import 'dart:math';

class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? get _overridden => Random().nextBool() ? 1 : null;
}

void testParity(Example x) {
  [!final i = x._overridden;!]
  if (i != null) {
    print(i.isEven); // OK
  }
}
```

#### Nota sobre classes não relacionadas

Note que no exemplo acima está claro
por que não é seguro promover o campo `_overridden`:
porque há uma relação de sobrescrita entre o campo e o getter.
No entanto, um getter conflitante impedirá a promoção de campo
mesmo se as classes não estiverem relacionadas. Por exemplo:

```dart tag=bad
import 'dart:math';

class Example {
  final int? _i;
  Example(this._i);
}

class Unrelated {
  int? get _i => Random().nextBool() ? 1 : null;
}

void f(Example x) {
  if (x._i != null) {
    int i = x._i; // ERROR
  }
}
```

Outra biblioteca pode conter uma classe que combina as duas classes não relacionadas
juntas na mesma hierarquia de classes,
o que faria com que a referência na função `f` a `x._i` seja
despachada para `Unrelated._i`. Por exemplo:

```dart tag=bad
class Surprise extends Unrelated implements Example {}

void main() {
  f(Surprise());
}
```

**Solução:**

Se o campo e a entidade conflitante são verdadeiramente não relacionados,
você pode contornar o problema dando-lhes nomes diferentes:

<?code-excerpt "non_promotion/lib/non_promotion.dart (unrelated)" replace="/get _j/[!$&!]/g; /UnrelatedExample/Example/g; /f2/f/g;"?>
```dart tag=good
class Example {
  final int? _i;
  Example(this._i);
}

class Unrelated {
  int? [!get _j!] => Random().nextBool() ? 1 : null;
}

void f(Example x) {
  if (x._i != null) {
    int i = x._i; // OK
  }
}
```

### Conflito com campo não promotável em outro lugar da biblioteca {:#field-name}

**A causa:**
Você está tentando promover um campo, mas outra classe na mesma biblioteca
contém um campo com o mesmo nome que não é promotável
(por qualquer uma das outras razões listadas nesta página).

**Exemplo:**

```dart tag=bad
class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? _overridden;
}

void f(Example x) {
  if (x._overridden != null) {
    print(x._overridden.isEven); // ERROR
  }
}
```

Este exemplo falha porque em tempo de execução, `x` pode realmente ser uma
instância de `Override`, então a promoção não seria sólida.

**Mensagem:**

```plaintext
'overridden' couldn't be promoted because there is a conflicting non-promotable field in class 'Override'.
```

**Solução:**

Se os campos estão realmente relacionados e precisam compartilhar um nome, então
você pode habilitar a promoção de tipo atribuindo o valor a uma
variável local final para promover:

<?code-excerpt "non_promotion/lib/non_promotion.dart (conflicting-field)" replace="/final i =.*/[!$&!]/g; /FieldExample/Example/g; /f3/f/g; /Override2/Override/g;"?>
```dart tag=good
class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? _overridden;
}

void f(Example x) {
  [!final i = x._overridden;!]
  if (i != null) {
    print(i.isEven); // OK
  }
}
```

Se os campos não estão relacionados, então renomeie um dos campos, para que
eles não entrem em conflito.
Leia a [Nota sobre classes não relacionadas](#note-about-unrelated-classes). 


### Conflito com forwarder `noSuchMethod` implícito {:#nosuchmethod}

**A causa:**
Você está tentando promover um campo que é privado e final,
mas outra classe na mesma biblioteca contém um
[forwarder `noSuchMethod` implícito][nosuchmethod]
com o mesmo nome do campo.

Isso não é sólido porque não há garantia de que `noSuchMethod`
retornará um valor estável de uma invocação para a próxima.

**Exemplo:**

```dart tag=bad
import 'package:mockito/mockito.dart';

class Example {
  final int? _i;
  Example(this._i);
}

class MockExample extends Mock implements Example {}

void f(Example x) {
  if (x._i != null) {
    int i = x._i; // ERROR
  }
}
```

Neste exemplo, `_i` não pode ser promovido porque pode
resolver para o forwarder `noSuchMethod` implícito não sólido (também chamado `_i`) que
o compilador gera dentro de `MockExample`.

O compilador cria esta implementação implícita de `_i` porque
`MockExample` promete suportar um getter para `_i` quando implementa
`Example` em sua declaração, mas não cumpre essa promessa.
Então, a implementação indefinida do getter é tratada pela
[definição `noSuchMethod` de `Mock`][`Mock`'s `noSuchMethod` definition], que
cria um forwarder `noSuchMethod` implícito com o mesmo nome.

A falha também pode ocorrer entre campos em
[classes não relacionadas](#note-about-unrelated-classes).

**Mensagem:**

```plaintext
'_i' couldn't be promoted because there is a conflicting noSuchMethod forwarder in class 'MockExample'.
```

**Solução:**

Defina o getter em questão para que `noSuchMethod` não precise
tratar implicitamente sua implementação:

<?code-excerpt "non_promotion/lib/non_promotion.dart (mock)" plaster="" replace="/late.*/[!$&!]/g; /MockingExample/Example/g; /f4/f/g;"?>
```dart tag=good
import 'package:mockito/mockito.dart';

class Example {
  final int? _i;
  Example(this._i);
}

class MockExample extends Mock implements Example {
  @override
  [!late final int? _i;!]
}

void f(Example x) {
  if (x._i != null) {
    int i = x._i; // OK
  }
}
```

O getter é declarado `late` para ser consistente com
como mocks são geralmente usados; não é necessário
declarar o getter `late` para resolver esta falha de promoção de tipo em
cenários que não envolvem mocks.

:::note
O exemplo acima usa [mocks]({{site.pub-pkg}}/mockito) simplesmente porque
`Mock` já contém uma definição `noSuchMethod`,
então não precisamos definir uma arbitrária
e podemos manter o código de exemplo curto.

Não esperamos que problemas como este surjam com muita frequência na prática com mocks,
porque geralmente mocks são declarados
em uma biblioteca diferente da classe que estão mockando.
Quando as classes em questão são declaradas em bibliotecas diferentes,
nomes privados não são encaminhados para `noSuchMethod`
(porque isso violaria as expectativas de privacidade),
então ainda é seguro promover o campo.
:::

[nosuchmethod]: /language/extend#nosuchmethod
[`Mock`'s `noSuchMethod` definition]: {{site.pub-api}}/mockito/latest/mockito/Mock/noSuchMethod.html

### Possivelmente escrito após promoção {:#write}

**A causa:**
Você está tentando promover uma variável que pode ter sido
escrita desde que foi promovida.

**Exemplo:**

```dart tag=bad
void f(bool b, int? i, int? j) {
  if (i == null) return;
  if (b) {
    i = j;           // (1)
  }
  if (!b) {
    print(i.isEven); // (2) ERROR
  }
}
```

**Solução**:

Neste exemplo, quando a análise de fluxo atinge (1),
ela rebaixa `i` de `int` não-nullable de volta para `int?` nullable.
Um humano pode dizer que o acesso em (2) é seguro
porque não há caminho de código que inclua ambos (1) e (2), mas
a análise de fluxo não é inteligente o suficiente para ver isso,
porque ela não rastreia correlações entre
condições em instruções `if` separadas.

Você pode corrigir o problema combinando as duas instruções `if`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (write-combine-ifs)" replace="/else/[!$&!]/g"?>
```dart tag=good
void f(bool b, int? i, int? j) {
  if (i == null) return;
  if (b) {
    i = j;
  } [!else!] {
    print(i.isEven);
  }
}
```

Em casos de fluxo de controle em linha reta como estes (sem loops),
a análise de fluxo leva em conta o lado direito da atribuição
ao decidir se deve rebaixar.
Como resultado, outra maneira de corrigir este código é
mudar o tipo de `j` para `int`.

<?code-excerpt "non_promotion/lib/non_promotion.dart (write-change-type)" replace="/int j/[!$&!]/g"?>
```dart tag=good
void f(bool b, int? i, [!int j!]) {
  if (i == null) return;
  if (b) {
    i = j;
  }
  if (!b) {
    print(i.isEven);
  }
}
```

### Possivelmente escrito em uma iteração de loop anterior {:#loop-or-switch}

**A causa:**
Você está tentando promover algo que
pode ter sido escrito em uma iteração anterior de um loop,
e então a promoção foi invalidada.

**Exemplo:**

```dart tag=bad
void f(Link? p) {
  if (p != null) return;
  while (true) {    // (1)
    print(p.value); // (2) ERROR
    var next = p.next;
    if (next == null) break;
    p = next;       // (3)
  }
}
```

Quando a análise de fluxo atinge (1),
ela olha adiante e vê a escrita em `p` em (3).
Mas porque está olhando adiante,
ainda não descobriu o tipo do lado direito da atribuição,
então não sabe se é seguro reter a promoção.
Para ser segura, ela invalida a promoção.

**Solução**:

Você pode corrigir este problema movendo a verificação de null para o topo do loop:

<?code-excerpt "non_promotion/lib/non_promotion.dart (loop)" replace="/p != null/[!$&!]/g"?>
```dart tag=good
void f(Link? p) {
  while ([!p != null!]) {
    print(p.value);
    p = p.next;
  }
}
```

Esta situação também pode surgir em instruções `switch` se
um bloco `case` tiver um rótulo,
porque você pode usar instruções `switch` rotuladas para construir loops:

```dart tag=bad
void f(int i, int? j, int? k) {
  if (j == null) return;
  switch (i) {
    label:
    case 0:
      print(j.isEven); // ERROR
      j = k;
      continue label;
  }
}
```

Novamente, você pode corrigir o problema movendo a verificação de null para o topo do loop:

<?code-excerpt "non_promotion/lib/non_promotion.dart (switch-loop)" replace="/if .*/[!$&!]/g"?>
```dart tag=good
void f(int i, int? j, int? k) {
  switch (i) {
    label:
    case 0:
      [!if (j == null) return;!]
      print(j.isEven);
      j = k;
      continue label;
  }
}
```

### Em catch após possível escrita em try {:#catch}

**A causa:**
A variável pode ter sido escrita em um bloco `try`,
e a execução agora está em um bloco `catch`.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  if (i == null) return;
  try {
    i = j;                 // (1)
    // ... Additional code ...
    if (i == null) return; // (2)
    // ... Additional code ...
  } catch (e) {
    print(i.isEven);       // (3) ERROR
  }
}
```

Neste caso, a análise de fluxo não considera `i.isEven` (3) seguro,
porque ela não tem como saber quando no bloco `try`
a exceção pode ter ocorrido,
então ela assume conservadoramente que pode ter acontecido entre (1) e (2),
quando `i` era potencialmente `null`.

Situações semelhantes podem ocorrer entre blocos `try` e `finally`, e
entre blocos `catch` e `finally`.
Por causa de um artefato histórico de como a implementação foi feita,
essas situações `try`/`catch`/`finally` não levam em conta
o lado direito da atribuição,
semelhante ao que acontece em loops.

**Solução**:

Para corrigir o problema, certifique-se de que o bloco `catch` não
dependa de suposições sobre o estado de variáveis que são
alteradas dentro do bloco `try`.
Lembre-se, a exceção pode ocorrer a qualquer momento durante o bloco `try`,
possivelmente quando `i` é `null`.

A solução mais segura é adicionar uma verificação de null dentro do bloco `catch`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-null-check)" replace="/if.*/[!$&!]/g;/(} else {|  \/\/ H.*)/[!$&!]/g;/  }/  [!}!]/g"?>
```dart tag=good
try {
  // ···
} catch (e) {
  [!if (i != null) {!]
    print(i.isEven); // (3) OK due to the null check in the line above.
  [!} else {!]
  [!  // Handle the case where i is null.!]
  [!}!]
}
```

Ou, se você tem certeza de que uma exceção não pode ocorrer enquanto `i` é `null`,
apenas use o operador `!`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-bang)" replace="/i!/i[!!!]/g"?>
```dart
try {
  // ···
} catch (e) {
  print(i[!!!].isEven); // (3) OK because of the `!`.
}
```

### Incompatibilidade de subtipo

**A causa:**
Você está tentando promover para um tipo que não é um subtipo do
tipo promovido atual da variável
(ou não era um subtipo no momento da tentativa de promoção).

**Exemplo:**

```dart tag=bad
void f(Object o) {
  if (o is Comparable /* (1) */ ) {
    if (o is Pattern /* (2) */ ) {
      print(o.matchAsPrefix('foo')); // (3) ERROR
    }
  }
}
```

Neste exemplo, `o` é promovido para `Comparable` em (1), mas
não é promovido para `Pattern` em (2),
porque `Pattern` não é um subtipo de `Comparable`.
(A justificativa é que se promovesse,
então você não seria capaz de usar métodos em `Comparable`.)
Note que só porque `Pattern` não é um subtipo de `Comparable`
não significa que o código em (3) está morto;
`o` pode ter um tipo—como `String`—que
implementa tanto `Comparable` quanto `Pattern`.

**Solução**:

Uma solução possível é criar uma nova variável local para que
a variável original seja promovida para `Comparable`, e
a nova variável seja promovida para `Pattern`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-variable)" replace="/Object o2.*/[!$&!]/g;/(o2)(\.| is)/[!$1!]$2/g"?>
```dart
void f(Object o) {
  if (o is Comparable /* (1) */ ) {
    [!Object o2 = o;!]
    if ([!o2!] is Pattern /* (2) */ ) {
      print(
        [!o2!].matchAsPrefix('foo'),
      ); // (3) OK; o2 was promoted to `Pattern`.
    }
  }
}
```

No entanto, alguém que editar o código mais tarde pode ser tentado a
mudar `Object o2` para `var o2`.
Essa mudança dá a `o2` um tipo de `Comparable`,
o que traz de volta o problema do objeto não ser promotável para `Pattern`.

Uma verificação de tipo redundante pode ser uma solução melhor:

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-redundant)" replace="/\(o as Pattern\)/[!$&!]/g"?>
```dart tag=good
void f(Object o) {
  if (o is Comparable /* (1) */ ) {
    if (o is Pattern /* (2) */ ) {
      print([!(o as Pattern)!].matchAsPrefix('foo')); // (3) OK
    }
  }
}
```

Outra solução que às vezes funciona é quando você pode usar um tipo mais preciso.
Se a linha 3 se preocupa apenas com strings,
então você pode usar `String` em sua verificação de tipo.
Como `String` é um subtipo de `Comparable`, a promoção funciona:

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-string)" replace="/is String/is [!String!]/g"?>
```dart tag=good
void f(Object o) {
  if (o is Comparable /* (1) */ ) {
    if (o is [!String!] /* (2) */ ) {
      print(o.matchAsPrefix('foo')); // (3) OK
    }
  }
}
```


### Escrita capturada por uma função local {:#captured-local}

**A causa:**
A variável foi capturada para escrita por
uma função local ou expressão de função.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i.isEven);       // (2) ERROR
}
```

A análise de fluxo raciocina que assim que a definição de `foo` é alcançada,
ela pode ser chamada a qualquer momento,
portanto não é mais seguro promover `i` de forma alguma.
Assim como com loops, esta despromoção acontece independentemente do
tipo do lado direito da atribuição.

**Solução**:

Às vezes é possível reestruturar a lógica para que
a promoção esteja antes da captura de escrita:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-reorder)" replace="/(  )((var foo|  i = j|\}\;|\/\/ ... Use foo).*)/$1[!$2!]/g"?>
```dart tag=good
void f(int? i, int? j) {
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i.isEven); // (2) OK
  [!var foo = () {!]
  [!  i = j;!]
  [!};!]
  [!// ... Use foo ...!]
}
```

Outra opção é criar uma variável local, para que não seja capturada para escrita:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-copy)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!$1!]$2/g"?>
```dart tag=good
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  [!var i2 = i;!]
  if ([!i2!] == null) return; // (1)
  // ... Additional code ...
  print([!i2!].isEven); // (2) OK because `i2` isn't write captured.
}
```

Ou você pode fazer uma verificação redundante:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-bang)" replace="/i!/i[!!!]/g"?>
```dart
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i[!!!].isEven); // (2) OK due to `!` check.
}
```


### Escrita fora do closure ou expressão de função atual {:#write-outer}

**A causa:**
A variável é escrita fora de um closure ou expressão de função,
e o local de promoção de tipo está
dentro do closure ou expressão de função.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  if (i == null) return;
  var foo = () {
    print(i.isEven); // (1) ERROR
  };
  i = j;             // (2)
}
```

A análise de fluxo raciocina que não há como determinar
quando `foo` pode ser chamado,
então pode ser chamado após a atribuição em (2),
e assim a promoção pode não ser mais válida.
Assim como com loops, esta despromoção acontece independentemente do tipo do
lado direito da atribuição.

**Solução**:

Uma solução é criar uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var)" replace="/var i2.*/[!$&!]/g;/i2\./[!i2!]./g"?>
```dart tag=good
void f(int? i, int? j) {
  if (i == null) return;
  [!var i2 = i;!]
  var foo = () {
    print([!i2!].isEven); // (1) OK because `i2` isn't changed later.
  };
  i = j; // (2)
}
```

**Exemplo:**

Um caso particularmente desagradável se parece com isto:

```dart tag=bad
void f(int? i) {
  i ??= 0;
  var foo = () {
    print(i.isEven); // ERROR
  };
}
```

Neste caso, um humano pode ver que a promoção é segura porque
a única escrita em `i` usa um valor não-null e
acontece antes de `foo` ser criado.
Mas [a análise de fluxo não é tão inteligente][1536].

[1536]: {{site.repo.dart.lang}}/issues/1536

**Solução**:

Novamente, uma solução é criar uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var2)" replace="/var j.*/[!$&!]/g;/j\./[!j!]./g"?>
```dart tag=good
void f(int? i) {
  [!var j = i ?? 0;!]
  var foo = () {
    print([!j!].isEven); // OK
  };
}
```

Esta solução funciona porque `j` é inferido como tendo um tipo não-nullable (`int`)
devido ao seu valor inicial (`i ?? 0`).
Como `j` tem um tipo não-nullable,
seja ou não atribuído posteriormente,
`j` nunca pode ter um valor não-null.


### Escrita capturada fora do closure ou expressão de função atual {:#captured-outer}

**A causa:**
A variável que você está tentando promover está capturada para escrita
fora de um closure ou expressão de função,
mas este uso da variável está dentro do closure ou expressão de função
que está tentando promovê-la.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  var foo = () {
    if (i == null) return;
    print(i.isEven); // ERROR
  };
  var bar = () {
    i = j;
  };
}
```

A análise de fluxo raciocina que não há como saber
em que ordem `foo` e `bar` podem ser executados;
na verdade, `bar` pode até ser executado no meio da execução de `foo`
(devido a `foo` chamar algo que chama `bar`).
Então não é seguro promover `i` de forma alguma dentro de `foo`.

**Solução**:

A melhor solução é provavelmente criar uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-write-capture)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!i2!]$2/g"?>
```dart tag=good
void f(int? i, int? j) {
  var foo = () {
    [!var i2 = i;!]
    if ([!i2!] == null) return;
    print([!i2!].isEven); // OK because i2 is local to this closure.
  };
  var bar = () {
    i = j;
  };
}
```

[language version]: /resources/language/evolution#language-versioning
