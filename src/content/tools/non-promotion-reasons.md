---
ia-translate: true
title: Como corrigir falhas de promoção de tipo
description: >-
  Soluções para os casos em que você sabe mais sobre o tipo de um
  campo do que o Dart consegue determinar.
---

A [promoção de tipo][Type promotion] ocorre quando a análise de fluxo pode confirmar,
de forma consistente, que uma variável do tipo `T` na verdade se refere a um objeto de um subtipo
`S` de `T`. A variável é então promovida a `S`.
Como caso especial, a variável pode ter um [tipo nullable][nullable type], e a
análise de fluxo pode confirmar que ela é *not null*. Nesse caso, a variável é
promovida ao tipo non-nullable correspondente.
Muitas circunstâncias podem enfraquecer a solidez de um tipo,
fazendo com que a promoção de tipo falhe.

Esta página lista os motivos pelos quais as falhas de promoção de tipo ocorrem,
com dicas de como corrigi-las.
Para saber mais sobre análise de fluxo e promoção de tipo,
confira a página [Entendendo null safety][Understanding null safety].

[Type promotion]: /null-safety/understanding-null-safety#type-promotion-on-null-checks
[nullable type]: /null-safety/understanding-null-safety#non-nullable-and-nullable-types
[Understanding null safety]: /null-safety/understanding-null-safety

## Versão de linguagem não suportada para promoção de campo {:#language-version}

**A causa:**
Você está tentando promover um campo, mas a promoção de campo depende da versão da linguagem,
e seu código está configurado para uma versão da linguagem anterior à 3.2.

Se você já estiver usando um SDK na versão >= Dart 3.2,
seu código ainda pode estar explicitamente direcionado a uma [versão da linguagem][language version] anterior.
Isso pode acontecer porque:

* O seu [`pubspec.yaml`][] declara uma restrição de SDK cujo limite
  inferior está abaixo de 3.2, ou
* Você tem um comentário `// @dart=version` no topo do arquivo,
  em que `version` é inferior a 3.2.

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

Garanta que sua biblioteca não está usando uma [versão da linguagem][language version] anterior à 3.2.
Verifique no topo do arquivo se há um comentário `// @dart=version` desatualizado,
ou no seu `pubspec.yaml` se há um [limite inferior de restrição de SDK][SDK constraint lower-bound] desatualizado.

[`pubspec.yaml`]: /tools/pub/pubspec
[SDK constraint lower-bound]: /tools/pub/pubspec#sdk-constraints

## Somente variáveis locais podem ser promovidas (antes do Dart 3.2) {:#property}

**A causa:**
Você está tentando promover uma propriedade,
mas somente variáveis locais podem ser promovidas nas versões do Dart anteriores à 3.2,
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

Se você estiver usando o Dart 3.1 ou anterior, [atualize para a versão 3.2 ou posterior][upgrade].

Se você precisar continuar usando uma versão mais antiga,
leia [Outras causas e soluções alternativas](#other-causes-and-workarounds).

[upgrade]: /get-dart

## Outras causas e soluções alternativas {:#other-causes-and-workarounds}

Os demais exemplos desta página documentam motivos de falhas de promoção
não relacionados a inconsistências de versão,
tanto para falhas em campos quanto em variáveis locais, com exemplos e soluções alternativas.

Em geral, as correções habituais para falhas de promoção
são uma ou mais das seguintes:

* Atribua o valor da propriedade a uma variável local com
  o tipo non-nullable de que você precisa.
* Adicione uma verificação explícita de null (por exemplo, `i == null`).
* Use `!` ou `as` como uma [verificação redundante](#redundant-check)
  se você tiver certeza de que uma expressão não pode ser `null`.

Aqui está um exemplo de criação de uma variável local
(que pode se chamar `i`)
que guarda o valor de `i`:

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

Este exemplo usa um campo de instância,
mas poderia usar, em vez disso, um getter de instância, um campo ou getter estático,
uma variável ou getter de nível superior, ou [`this`](#this).

:::tip
Ao criar uma variável local para guardar o valor de um campo,
**torne a variável `final`**.
Assim, você não consegue atualizar a variável local por engano
quando pretende atualizar o campo.
:::

E aqui está um exemplo usando `i!`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (property-bang)" replace="/!/[!!!]/g"?>
```dart tag=good
print(i[!!!].isEven);
```


<a id="redundant-check" aria-hidden="true"></a>

:::note
Você pode contornar todos esses exemplos de não promoção adicionando
uma _verificação redundante_: código que confirma uma
condição que já foi verificada.
Se a promoção que está falhando é uma verificação de null, use `!`;
se é uma verificação de tipo, você pode usar `as`.

Verificações redundantes são uma solução fácil, mas propensa a erros,
para falhas de promoção de tipo.
Como elas anulam o compilador,
podem levar a erros de um jeito que outras soluções não levam.

Cabe a você decidir se faz o trabalho extra para que os tipos sejam promovidos
(o que dá confiança de que o código está correto)
ou se faz uma verificação redundante
(que pode introduzir um bug se o seu raciocínio estiver errado).
:::


### Não é possível promover `this` {:#this}

**A causa:**
Você está tentando promover `this`,
mas a promoção de tipo para `this` ainda não é suportada.

Um cenário comum de promoção de `this` acontece ao escrever [métodos de extensão][extension methods].
Se o [tipo `on`][`on` type] do método de extensão for um tipo nullable,
você vai querer fazer uma verificação de null para saber se `this` é `null`:

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

Crie uma variável local para guardar o valor de `this`,
e então faça a verificação de null.

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

### Somente campos privados podem ser promovidos {:#private}

**A causa:**
Você está tentando promover um campo, mas o campo não é privado.

É possível que outras bibliotecas do seu programa
sobrescrevam campos públicos com um getter. Como
[getters podem não retornar um valor estável](#not-field),
e o compilador não pode saber o que as outras bibliotecas estão fazendo,
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
poderia sobrescrever seu valor, então é seguro promovê-lo.

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

### Somente campos final podem ser promovidos {:#final}

**A causa:**
Você está tentando promover um campo, mas o campo não é final.

Para o compilador, campos não final podem, em princípio,
ser modificados a qualquer momento entre o momento em que
são testados e o momento em que são usados.
Por isso, não é seguro para o compilador promover um tipo nullable não final
a um tipo non-nullable.

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
mas somente *campos* de instância podem ser promovidos, e não getters de instância.

O compilador não tem como garantir que
um getter retorne sempre o mesmo resultado.
Como a estabilidade dele não pode ser confirmada,
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
permitir a promoção de tipo, desde que não haja declarações conflitantes.
:::

### Campos external não podem ser promovidos {:#external}

**A causa:**
Você está tentando promover um campo, mas o campo está marcado como `external`.

Campos external não são promovidos porque, na prática, são getters externos;
a implementação deles é código de fora do Dart,
então o compilador não tem garantia de que um campo external
vai retornar o mesmo valor toda vez que for chamado.

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
'_overridden' couldn't be promoted because there is a conflicting getter in class 'Override'.
```

**Solução**:

Se o getter e o campo estiverem relacionados e precisarem compartilhar o nome
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

#### Nota sobre classes não relacionadas {:#note-about-unrelated-classes}

Observe que, no exemplo acima, é claro
por que é inseguro promover o campo `_overridden`:
existe uma relação de sobrescrita entre o campo e o getter.
No entanto, um getter conflitante impedirá a promoção do campo
mesmo que as classes não estejam relacionadas. Por exemplo:

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
na mesma hierarquia de classes,
o que faria com que a referência em `x._i`, dentro da função `f`, fosse despachada para
`Unrelated._i`. Por exemplo:

```dart tag=bad
class Surprise extends Unrelated implements Example {}

void main() {
  f(Surprise());
}
```

**Solução:**

Se o campo e a entidade conflitante realmente não estiverem relacionados,
você pode contornar o problema dando nomes diferentes a eles:

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

### Conflito com campo não promovível em outro lugar da biblioteca {:#field-name}

**A causa:**
Você está tentando promover um campo, mas outra classe na mesma biblioteca
contém um campo com o mesmo nome que não é promovível
(por qualquer um dos outros motivos listados nesta página).

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

Este exemplo falha porque, em tempo de execução, `x` pode ser de fato uma
instância de `Override`, então a promoção não seria sólida.

**Mensagem:**

```plaintext
'overridden' couldn't be promoted because there is a conflicting non-promotable field in class 'Override'.
```

**Solução:**

Se os campos realmente estiverem relacionados e precisarem compartilhar um nome, então
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

Se os campos não estiverem relacionados,
então renomeie um dos campos para que eles não entrem em conflito.
Leia a [Nota sobre classes não relacionadas](#note-about-unrelated-classes).


### Conflito com um encaminhador implícito de `noSuchMethod` {:#nosuchmethod}

**A causa:**
Você está tentando promover um campo privado e final,
mas outra classe na mesma biblioteca contém um
[encaminhador implícito de `noSuchMethod`][nosuchmethod]
com o mesmo nome do campo.

Isso não é sólido, porque não há garantia de que `noSuchMethod`
retorne um valor estável de uma invocação para a seguinte.

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

Neste exemplo, `_i` não pode ser promovido porque ele poderia
resolver para o encaminhador implícito e não sólido de `noSuchMethod` (também chamado `_i`) que
o compilador gera dentro de `MockExample`.

O compilador cria essa implementação implícita de `_i` porque
`MockExample` promete oferecer suporte a um getter para `_i` ao implementar
`Example` em sua declaração, mas não cumpre essa promessa.
Assim, a implementação do getter não definido é tratada pela
[definição de `noSuchMethod` de `Mock`][`Mock`'s `noSuchMethod` definition], que
cria um encaminhador implícito `noSuchMethod` com o mesmo nome.

A falha também pode ocorrer entre campos de
[classes não relacionadas](#note-about-unrelated-classes).

**Mensagem:**

```plaintext
'_i' couldn't be promoted because there is a conflicting noSuchMethod forwarder in class 'MockExample'.
```

**Solução:**

Defina o getter em questão de forma que `noSuchMethod` não precise
tratar implicitamente a implementação dele:

<?code-excerpt "non_promotion/lib/non_promotion.dart (mock)" plaster="none" replace="/late.*/[!$&!]/g; /MockingExample/Example/g; /f4/f/g;"?>
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

O getter é declarado como `late` para ser consistente com
a forma como os mocks costumam ser usados; não é necessário
declarar o getter como `late` para resolver essa falha de promoção de tipo em
cenários que não envolvem mocks.

:::note
O exemplo acima usa [mocks]({{site.pub-pkg}}/mockito) simplesmente porque
`Mock` já contém uma definição de `noSuchMethod`,
então não precisamos definir uma arbitrária
e podemos manter o código de exemplo curto.

Não esperamos que problemas como este apareçam com frequência na prática com mocks,
porque normalmente os mocks são declarados
em uma biblioteca diferente da classe que eles simulam.
Quando as classes em questão são declaradas em bibliotecas diferentes,
nomes privados não são encaminhados para `noSuchMethod`
(porque isso violaria as expectativas de privacidade),
então ainda é seguro promover o campo.
:::

[nosuchmethod]: /language/extend#nosuchmethod
[`Mock`'s `noSuchMethod` definition]: {{site.pub-api}}/mockito/latest/mockito/Mock/noSuchMethod.html

### Possivelmente escrito após a promoção {:#write}

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

Neste exemplo, quando a análise de fluxo chega em (1),
ela rebaixa `i` de `int` non-nullable de volta para `int?` nullable.
Uma pessoa consegue perceber que o acesso em (2) é seguro
porque não existe caminho de código que inclua tanto (1) quanto (2), mas a
análise de fluxo não é inteligente o bastante para ver isso,
porque ela não acompanha correlações entre
condições em `if` separados.

Você pode resolver o problema combinando os dois `if`:

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

Em casos de fluxo de controle linear como estes (sem loops),
a análise de fluxo considera o lado direito da atribuição
ao decidir se deve rebaixar.
Como resultado, outra forma de corrigir este código é
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

### Possivelmente escrito em uma iteração anterior do loop {:#loop-or-switch}

**A causa:**
Você está tentando promover algo que
pode ter sido escrito em uma iteração anterior de um loop,
e por isso a promoção foi invalidada.

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

Quando a análise de fluxo chega em (1),
ela olha adiante e vê a escrita em `p` em (3).
Mas, como está olhando adiante,
ainda não descobriu o tipo do lado direito da atribuição,
então não sabe se é seguro manter a promoção.
Por segurança, ela invalida a promoção.

**Solução**:

Você pode resolver este problema movendo a verificação de null para o início do loop:

<?code-excerpt "non_promotion/lib/non_promotion.dart (loop)" replace="/p != null/[!$&!]/g"?>
```dart tag=good
void f(Link? p) {
  while ([!p != null!]) {
    print(p.value);
    p = p.next;
  }
}
```

Essa situação também pode surgir em instruções `switch` se
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

Novamente, você pode resolver o problema movendo a verificação de null para o início do loop:

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

### No catch, após uma possível escrita no try {:#catch}

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

Nesse caso, a análise de fluxo não considera `i.isEven` (3) seguro,
porque não tem como saber em qual ponto do bloco `try`
a exceção pode ter ocorrido,
então ela presume de forma conservadora que isso pode ter acontecido entre (1) e (2),
quando `i` potencialmente era `null`.

Situações semelhantes podem ocorrer entre blocos `try` e `finally`, e
entre blocos `catch` e `finally`.
Por um artefato histórico de como a implementação foi feita,
essas situações de `try`/`catch`/`finally` não levam em conta
o lado direito da atribuição,
de forma semelhante ao que acontece em loops.

**Solução**:

Para corrigir o problema, garanta que o bloco `catch` não
dependa de suposições sobre o estado de variáveis que são
alteradas dentro do bloco `try`.
Lembre-se: a exceção pode ocorrer a qualquer momento durante o bloco `try`,
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

Ou, se você tiver certeza de que uma exceção não pode ocorrer enquanto `i` é `null`,
basta usar o operador `!`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-bang)" replace="/i!/i[!!!]/g"?>
```dart
try {
  // ···
} catch (e) {
  print(i[!!!].isEven); // (3) OK because of the `!`.
}
```

### Incompatibilidade de subtipo {:#subtype-mismatch}

**A causa:**
Você está tentando promover para um tipo que não é subtipo do
tipo promovido atual da variável
(ou que não era subtipo no momento da tentativa de promoção).

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

Neste exemplo, `o` é promovido a `Comparable` em (1), mas
não é promovido a `Pattern` em (2),
porque `Pattern` não é subtipo de `Comparable`.
(A justificativa é que, se ele fosse promovido,
você não conseguiria usar os métodos de `Comparable`.)
Note que o fato de `Pattern` não ser subtipo de `Comparable`
não significa que o código em (3) é inalcançável;
`o` pode ter um tipo, como `String`, que
implementa tanto `Comparable` quanto `Pattern`.

**Solução**:

Uma possível solução é criar uma nova variável local, de modo que a
variável original seja promovida a `Comparable`, e a
nova variável seja promovida a `Pattern`:

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

No entanto, quem editar o código depois pode ser tentado a
trocar `Object o2` por `var o2`.
Essa mudança dá a `o2` o tipo `Comparable`,
o que traz de volta o problema de o objeto não poder ser promovido a `Pattern`.

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
Se a linha 3 só se importa com strings,
então você pode usar `String` na sua verificação de tipo.
Como `String` é subtipo de `Comparable`, a promoção funciona:

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

A análise de fluxo conclui que, assim que a definição de `foo` é alcançada,
ela pode ser chamada a qualquer momento,
portanto não é mais seguro promover `i` de forma alguma.
Assim como nos loops, esse rebaixamento acontece independentemente do
tipo do lado direito da atribuição.

**Solução**:

Às vezes é possível reestruturar a lógica para que
a promoção venha antes da captura para escrita:

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

Outra opção é criar uma variável local, para que ela não seja capturada para escrita:

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


### Escrita fora da closure ou expressão de função atual {:#write-outer}

**A causa:**
A variável é escrita fora de uma closure ou expressão de função,
e o ponto de promoção de tipo está
dentro da closure ou expressão de função.

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

A análise de fluxo conclui que não há como determinar
quando `foo` pode ser chamada,
então ela pode ser chamada depois da atribuição em (2),
e assim a promoção pode deixar de ser válida.
Assim como nos loops, esse rebaixamento acontece independentemente do tipo do
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

Um caso particularmente complicado é este:

```dart tag=bad
void f(int? i) {
  i ??= 0;
  var foo = () {
    print(i.isEven); // ERROR
  };
}
```

Neste caso, uma pessoa consegue ver que a promoção é segura porque
a única escrita em `i` usa um valor não nulo e
acontece antes de `foo` ser criada.
Mas a [análise de fluxo não é tão inteligente assim][1536].

[1536]: {{site.repo.dart.lang}}/issues/1536

**Solução**:

De novo, uma solução é criar uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var2)" replace="/var j.*/[!$&!]/g;/j\./[!j!]./g"?>
```dart tag=good
void f(int? i) {
  [!var j = i ?? 0;!]
  var foo = () {
    print([!j!].isEven); // OK
  };
}
```

Essa solução funciona porque `j` é inferido como tendo um tipo non-nullable (`int`)
por causa do seu valor inicial (`i ?? 0`).
Como `j` tem um tipo non-nullable,
independentemente de ser atribuído depois ou não,
`j` nunca pode ter um valor não nulo.


### Escrita capturada fora da closure ou expressão de função atual {:#captured-outer}

**A causa:**
A variável que você está tentando promover é capturada para escrita
fora de uma closure ou expressão de função,
mas este uso da variável está dentro da closure ou expressão de função
que tenta promovê-la.

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

A análise de fluxo conclui que não há como saber
em que ordem `foo` e `bar` podem ser executadas;
na prática, `bar` pode até ser executada no meio da execução de `foo`
(por exemplo, se `foo` chamar algo que chama `bar`).
Então não é seguro promover `i` de forma alguma dentro de `foo`.

**Solução**:

A melhor solução provavelmente é criar uma variável local:

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

### Promoção perdida ao cruzar um `await` ou `yield` {:#suspension}

**A causa:**
A análise de fluxo descarta a promoção de tipo quando a execução é suspensa
ao cruzar uma expressão `await` ou uma instrução `yield`.

Para que essa falha de promoção ocorra,
as seguintes condições devem ser atendidas:

1. Uma função ou método contém uma escrita em uma variável local ou parâmetro.
1. Essa função contém uma função interna ou closure
   que promove a variável.
1. A função interna se suspende usando `await` ou `yield`,
   permitindo que a função externa continue a execução.
1. A função interna tenta usar a variável local novamente
   depois da suspensão.

Em versões anteriores do SDK, usar a variável local depois da suspensão
mantinha o tipo promovido.
No entanto, esse comportamento não era sólido:
enquanto a função interna está suspensa,
a função externa pode continuar executando e modificar o valor da variável.
A partir do Dart 3.13, para garantir a solidez,
a análise de fluxo descarta a promoção quando a função interna é suspensa.

**Exemplo:**

O compilador descarta uma promoção nos pontos de suspensão,
mesmo que seja claro que manter a promoção é seguro.

```dart tag=bad
import 'dart:async';

Future<void> example(String? extraInfo) async {
  extraInfo ??= 'No extra info'; // (1)
  unawaited(() async {
    log('Doing some asynchronous task...');
    log(extraInfo!);
    await longTask(); // (2)
    log('Done!');
    log(extraInfo); // (3) ERROR
  }());
}

Future<void> longTask() async {
  await Future<void>.delayed(const Duration(seconds: 10));
}

void log(String s) {
  print(s);
}
```

Neste exemplo, atribuir um valor a `extraInfo` em `(1)`
faz com que ela não seja *effectively final*.
A análise de fluxo presume de forma conservadora que
qualquer variável modificada e capturada por uma closure
pode mudar enquanto a closure está suspensa em `(2)`,
mesmo que a atribuição em `(1)` sempre aconteça antes de a closure ser executada.
Para garantir a solidez, a análise de fluxo descarta a promoção.
Como resultado, em `(3)`, `extraInfo` volta a ser `String?`,
que não é compatível com `log(String s)` e produz um erro de compilação.

**Mensagem:**

Quando essa situação ocorre, o compilador ou o analyzer emite
um erro e uma mensagem de contexto:

```plaintext
example.dart:10:9: Error: The argument type 'String?' can't be assigned to the parameter type 'String'.
    log(extraInfo);
        ^
example.dart:8:5: Context: Variable 'extraInfo' could not be promoted due to an 'await' or 'yield'.
Try checking the type of the variable after the 'await' or 'yield'.  See http://dart.dev/go/non-promo-suspension
    await longTask();
    ^
```

**Solução:**

Para corrigir esse erro de compilação,
verifique novamente o tipo non-nullable da variável, adicione uma verificação explícita de null,
ou use uma asserção de não nulo (`!`) depois do ponto de suspensão:

<?code-excerpt "non_promotion/lib/non_promotion.dart (suspension)" plaster="" replace="/(Done!'\);\n +log\()extraInfo!/$1[!extraInfo!!]/g"?>
```dart tag=good
import 'dart:async';

Future<void> example(String? extraInfo) async {
  extraInfo ??= 'No extra info';
  unawaited(() async {
    log('Doing some asynchronous task...');
    log(extraInfo!);
    await longTask();
    log('Done!');
    log([!extraInfo!!]);
  }());
}

Future<void> longTask() async {
  await Future<void>.delayed(const Duration(seconds: 10));
}

void log(String s) {
  print(s);
}
```

Alternativamente, atribua a variável a uma variável local `final`
antes da suspensão,
ou verifique novamente `extraInfo != null` depois da expressão `await`.

[language version]: /language/versioning
