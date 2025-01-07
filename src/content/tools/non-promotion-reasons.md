---
ia-translate: true
title: Corrigindo falhas de type promotion
description: >-
  Soluções para casos em que você sabe mais sobre o
  tipo de um campo do que o Dart consegue determinar.
---

[Type promotion][Type promotion] (promoção de tipo) ocorre quando a análise de fluxo pode confirmar de forma segura que
uma variável com um [nullable type][nullable type] (tipo anulável) é *não nula* e
que não mudará a partir desse ponto.
Muitas circunstâncias podem enfraquecer a segurança de um tipo,
fazendo com que a type promotion falhe.

Esta página lista as razões pelas quais ocorrem falhas de type promotion,
com dicas sobre como corrigi-las.
Para saber mais sobre análise de fluxo e type promotion,
confira a página [Understanding null safety][Understanding null safety] (Entendendo a segurança nula).

[Type promotion]: /null-safety/understanding-null-safety#type-promotion-on-null-checks
[nullable type]: /null-safety/understanding-null-safety#non-nullable-and-nullable-types
[Understanding null safety]: /null-safety/understanding-null-safety

## Versão de linguagem não suportada para promoção de campo {:#language-version}

**A causa:**
Você está tentando promover um campo, mas a promoção de campo é versionada pela linguagem,
e seu código está definido para uma versão de linguagem anterior a 3.2.

Se você já estiver usando uma versão do SDK >= Dart 3.2,
seu código ainda pode ser explicitamente direcionado para uma [versão de linguagem][language version] anterior.
Isso pode acontecer porque:

* Seu [`pubspec.yaml`][`pubspec.yaml`] declara uma restrição de SDK com um
  limite inferior abaixo de 3.2, ou
* Você tem um comentário `// @dart=version` na parte superior do arquivo,
  onde `version` é inferior a 3.2.

**Exemplo:**

```dart tag=bad
// @dart=3.1

class C {
  final int? _i;
  C(this._i);

  void f() {
    if (_i != null) {
      int i = _i;  // ERRO
    }
  }
}
```

**Mensagem:**

```plaintext
'_i' refere-se a um campo. Não pôde ser promovido porque a promoção de campo só está disponível no Dart 3.2 e superior.
```

**Solução:**

Certifique-se de que sua biblioteca não esteja usando uma [versão de linguagem][language version] anterior a 3.2.
Verifique a parte superior do seu arquivo em busca de um comentário `// @dart=version` desatualizado,
ou seu `pubspec.yaml` em busca de um [limite inferior de restrição de SDK][limite inferior de restrição de SDK] desatualizado.

[`pubspec.yaml`]: /tools/pub/pubspec
[limite inferior de restrição de SDK]: /tools/pub/pubspec#sdk-constraints

## Apenas variáveis locais podem ser promovidas (antes do Dart 3.2) {:#property}

**A causa:**
Você está tentando promover uma propriedade,
mas apenas variáveis locais podem ser promovidas em versões do Dart anteriores a 3.2,
e você está usando uma versão anterior a 3.2.

**Exemplo:**

```dart tag=bad
class C {
  int? i;
  void f() {
    if (i == null) return;
    print(i.isEven);       // ERRO
  }
}
```

**Mensagem:**

```plaintext
'i' refere-se a uma propriedade, portanto, não pôde ser promovida.
```

**Solução:**

Se você estiver usando o Dart 3.1 ou anterior, [atualize para 3.2 ou posterior][upgrade].

Se você precisar continuar usando uma versão mais antiga,
leia [Outras causas e soluções alternativas](#other-causes-and-workarounds)

[upgrade]: /get-dart

## Outras causas e soluções alternativas {:#other-causes-and-workarounds}

Os exemplos restantes nesta página documentam as razões para falhas de promoção
não relacionadas a inconsistências de versão,
tanto para falhas de campo quanto de variáveis locais, com exemplos e soluções alternativas.

Em geral, as soluções usuais para falhas de promoção
são uma ou mais das seguintes:

* Atribua o valor da propriedade a uma variável local com
  o tipo não anulável que você precisa.
* Adicione uma verificação nula explícita (por exemplo, `i == null`).
* Use `!` ou `as` como uma [verificação redundante](#redundant-check)
  se você tiver certeza de que uma expressão não pode ser `null`.

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
mas ele poderia, em vez disso, usar um getter de instância, um campo ou getter estático,
uma variável ou getter de nível superior ou [`this`](#this).

:::tip
Ao criar uma variável local para armazenar o valor de um campo,
**faça a variável `final`**.
Dessa forma, você não pode atualizar acidentalmente a variável local
quando você pretende atualizar o campo.
:::

E aqui está um exemplo de uso de `i!`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (property-bang)" replace="/!/[!!!]/g"?>
```dart tag=good
print(i[!!!].isEven);
```


<a id="redundant-check" aria-hidden="true"></a>

:::note
Você pode contornar todos esses exemplos de não promoção adicionando
uma _verificação redundante_—código que confirma uma
condição que já foi verificada.
Se a promoção que está falhando for uma verificação nula, use `!`;
se for uma verificação de tipo, você pode usar `as`.

Verificações redundantes são uma solução fácil, mas propensa a erros
para falhas de type promotion.
Como elas substituem o compilador,
elas podem levar a erros de uma forma que outras soluções não levam.

Cabe a você decidir se faz o trabalho extra para que os tipos sejam promovidos
(dando-lhe confiança de que o código está correto)
ou se faz uma verificação redundante
(o que pode introduzir um bug se seu raciocínio estiver errado).
:::


### Não é possível promover `this` {:#this}

**A causa:**
Você está tentando promover `this`,
mas a type promotion para `this` ainda não é suportada.

Um cenário comum de promoção de `this` é ao escrever [extension methods][extension methods] (métodos de extensão).
Se o [`on` type][`on` type] (tipo `on`) do método de extensão for um tipo anulável,
você gostaria de fazer uma verificação nula para ver se `this` é `null`:

**Exemplo:**

```dart tag=bad
extension on int? {
  int get valueOrZero {
    return this == null ? 0 : this; // ERRO
  }
}
```

**Mensagem:**

```plaintext
`this` não pode ser promovido.
```

**Solução:**

Crie uma variável local para armazenar o valor de `this`,
então realize a verificação nula.

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
substituam campos públicos por um getter. Porque
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
    print(x.value + 1); // ERRO
  }
}
```

**Mensagem:**

```plaintext
'value' refere-se a uma propriedade pública, portanto, não pôde ser promovida.
```

**Solução:**

Tornar o campo privado permite que o compilador tenha certeza de que nenhuma biblioteca externa
poderia substituir seu valor, então é seguro promover.

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

### Apenas campos finais podem ser promovidos {:#final}

**A causa:**
Você está tentando promover um campo, mas o campo não é final.

Para o compilador, campos não finais poderiam, em princípio,
ser modificados a qualquer momento entre o momento
em que são testados e o momento em que são usados.
Portanto, não é seguro para o compilador promover um tipo anulável não final
para um tipo não anulável.

**Exemplo:**

```dart tag=bad
class Example {
  int? _mutablePrivateField;
  Example(this._mutablePrivateField);

  void f() {
    if (_mutablePrivateField != null) {
      int i = _mutablePrivateField; // ERRO
    }
  }
}
```

**Mensagem:**

```plaintext
'_mutablePrivateField' refere-se a um campo não final, portanto, não pôde ser promovido.
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
um getter retorne o mesmo resultado sempre.
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
    print(x._value.isEven); // ERRO
  }
}
```

**Mensagem:**

```plaintext
'_value' refere-se a um getter, portanto, não pôde ser promovido.
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
permitir a type promotion, desde que não haja declarações conflitantes.
:::

### Campos externos não podem ser promovidos {:#external}

**A causa:**
Você está tentando promover um campo, mas o campo está marcado como `external`.

Campos externos não são promovidos porque são essencialmente getters externos;
sua implementação é código de fora do Dart,
portanto, não há garantia para o compilador de que um campo externo
retornará o mesmo valor cada vez que for chamado.

**Exemplo:**

```dart tag=bad
class Example {
  external final int? _externalField;

  void f() {
    if (_externalField != null) {
      print(_externalField.isEven); // ERRO
    }
  }
}
```

**Mensagem:**

```plaintext
'_externalField' refere-se a um campo externo, portanto, não pôde ser promovido.
```

**Solução:**

Atribua o valor do campo externo a uma variável local:

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

### Conflito com getter em outro lugar na biblioteca {:#getter-name}

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
    print(x._overridden.isEven); // ERRO
  }
}
```

**Mensagem:**

```plaintext
'_overriden' não pôde ser promovido porque há um getter conflitante na classe 'Override'.
```

**Solução**:

Se o getter e o campo estiverem relacionados e precisarem compartilhar seu nome
(como quando um deles substitui o outro, como no exemplo acima),
então você pode habilitar a type promotion atribuindo o valor a uma variável local:

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

#### Observação sobre classes não relacionadas {:#note-about-unrelated-classes}

Observe que no exemplo acima está claro
por que não é seguro promover o campo `_overridden`:
porque há uma relação de substituição entre o campo e o getter.
No entanto, um getter conflitante impedirá a promoção de campo
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
    int i = x._i; // ERRO
  }
}
```

Outra biblioteca pode conter uma classe que combina as duas classes não relacionadas
na mesma hierarquia de classes,
o que faria com que a referência na função `f` a `x._i` fosse
despachada para `Unrelated._i`. Por exemplo:

```dart tag=bad
class Surprise extends Unrelated implements Example {}

void main() {
  f(Surprise());
}
```

**Solução:**

Se o campo e a entidade conflitante não estiverem realmente relacionados,
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

### Conflito com campo não promovível em outro lugar na biblioteca {:#field-name}

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
    print(x._overridden.isEven); // ERRO
  }
}
```

Este exemplo falha porque em tempo de execução, `x` pode realmente ser uma
instância de `Override`, então a promoção não seria segura.

**Mensagem:**

```plaintext
'overridden' não pôde ser promovido porque há um campo não promovível conflitante na classe 'Override'.
```

**Solução:**

Se os campos estiverem realmente relacionados e precisarem compartilhar um nome,
você pode habilitar a type promotion atribuindo o valor a uma
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

Se os campos não estiverem relacionados, renomeie um dos campos, para
que não entrem em conflito.
Leia a [Observação sobre classes não relacionadas](#note-about-unrelated-classes).


### Conflito com encaminhador `noSuchMethod` implícito {:#nosuchmethod}

**A causa:**
Você está tentando promover um campo que é privado e final,
mas outra classe na mesma biblioteca contém um
[encaminhador `noSuchMethod` implícito][nosuchmethod]
com o mesmo nome do campo.

Isso não é seguro porque não há garantia de que `noSuchMethod`
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
    int i = x._i; // ERRO
  }
}
```

Neste exemplo, `_i` não pode ser promovido porque poderia
ser resolvido para o encaminhador `noSuchMethod` implícito não seguro (também chamado `_i`) que
o compilador gera dentro de `MockExample`.

O compilador cria essa implementação implícita de `_i` porque
`MockExample` promete oferecer suporte a um getter para `_i` quando implementa
`Example` em sua declaração, mas não cumpre essa promessa.
Portanto, a implementação do getter indefinido é tratada por
[`Mock`'s `noSuchMethod` definition][`Mock`'s `noSuchMethod` definition](definição `noSuchMethod` do `Mock`), que
cria um encaminhador `noSuchMethod` implícito com o mesmo nome.

A falha também pode ocorrer entre campos em
[classes não relacionadas](#note-about-unrelated-classes).

**Mensagem:**

```plaintext
'_i' não pôde ser promovido porque há um encaminhador noSuchMethod conflitante na classe 'MockExample'.
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
como os mocks são geralmente usados; não é necessário
declarar o getter `late` para resolver essa falha de type promotion em
cenários que não envolvem mocks.

:::note
O exemplo acima usa [mocks]({{site.pub-pkg}}/mockito) simplesmente porque
`Mock` já contém uma definição `noSuchMethod`,
então não precisamos definir uma arbitrária
e podemos manter o código de exemplo curto.

Não esperamos que problemas como este surjam com muita frequência na prática com mocks,
porque geralmente os mocks são declarados
em uma biblioteca diferente da classe que eles estão imitando.
Quando as classes em questão são declaradas em bibliotecas diferentes,
nomes privados não são encaminhados para `noSuchMethod`
(porque isso violaria as expectativas de privacidade),
portanto, ainda é seguro promover o campo.
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
    print(i.isEven); // (2) ERRO
  }
}
```

**Solução**:

Neste exemplo, quando a análise de fluxo atinge (1),
ela rebaixa `i` de `int` não anulável de volta para `int?` anulável.
Um humano pode dizer que o acesso em (2) é seguro
porque não há caminho de código que inclua (1) e (2), mas
a análise de fluxo não é inteligente o suficiente para ver isso,
porque não rastreia as correlações entre
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
a análise de fluxo leva em consideração o lado direito da atribuição
ao decidir se deve rebaixar.
Como resultado, outra maneira de corrigir este código é
alterar o tipo de `j` para `int`.

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
e assim a promoção foi invalidada.

**Exemplo:**

```dart tag=bad
void f(Link? p) {
  if (p != null) return;
  while (true) {    // (1)
    print(p.value); // (2) ERRO
    var next = p.next;
    if (next == null) break;
    p = next;       // (3)
  }
}
```

Quando a análise de fluxo atinge (1),
ela olha para frente e vê a escrita em `p` em (3).
Mas como está olhando para frente,
ainda não descobriu o tipo do lado direito da atribuição,
então não sabe se é seguro reter a promoção.
Para ser seguro, invalida a promoção.

**Solução**:

Você pode corrigir este problema movendo a verificação nula para o topo do loop:

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
      print(j.isEven); // ERRO
      j = k;
      continue label;
  }
}
```

Novamente, você pode corrigir o problema movendo a verificação nula para o topo do loop:

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
    // ... Código adicional ...
    if (i == null) return; // (2)
    // ... Código adicional ...
  } catch (e) {
    print(i.isEven);       // (3) ERRO
  }
}
```

Nesse caso, a análise de fluxo não considera `i.isEven` (3) seguro,
porque não tem como saber quando no bloco `try`
a exceção pode ter ocorrido,
então assume de forma conservadora que pode ter acontecido entre (1) e (2),
quando `i` era potencialmente `null`.

Situações semelhantes podem ocorrer entre blocos `try` e `finally` e
entre blocos `catch` e `finally`.
Por causa de um artefato histórico de como a implementação foi feita,
essas situações `try`/`catch`/`finally` não levam em consideração
o lado direito da atribuição,
semelhante ao que acontece em loops.

**Solução**:

Para corrigir o problema, certifique-se de que o bloco `catch` não dependa
de suposições sobre o estado das variáveis que
são alteradas dentro do bloco `try`.
Lembre-se, a exceção pode ocorrer a qualquer momento durante o bloco `try`,
possivelmente quando `i` for `null`.

A solução mais segura é adicionar uma verificação nula dentro do bloco `catch`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-null-check)" replace="/if.*/[!$&!]/g;/(} else {|  \/\/ H.*)/[!$&!]/g;/  }/  [!}!]/g"?>
```dart tag=good
try {
  // ···
} catch (e) {
  [!if (i != null) {!]
    print(i.isEven); // (3) OK devido à verificação nula na linha acima.
  [!} else {!]
  [!  // Lide com o caso em que i é nulo.!]
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
  print(i[!!!].isEven); // (3) OK por causa do `!`.
}
```

### Incompatibilidade de subtipo {:#subtype-mismatch}

**A causa:**
Você está tentando promover para um tipo que não é um subtipo do
tipo promovido atual da variável
(ou não era um subtipo no momento da tentativa de promoção).

**Exemplo:**

```dart tag=bad
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is Pattern /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) ERRO
    }
  }
}
```

Neste exemplo, `o` é promovido para `Comparable` em (1), mas
não é promovido para `Pattern` em (2),
porque `Pattern` não é um subtipo de `Comparable`.
(A justificativa é que se fosse promovido,
você não seria capaz de usar métodos em `Comparable`.)
Observe que só porque `Pattern` não é um subtipo de `Comparable`
não significa que o código em (3) esteja morto;
`o` pode ter um tipo—como `String`—que
implementa tanto `Comparable` quanto `Pattern`.

**Solução**:

Uma possível solução é criar uma nova variável local para que
a variável original seja promovida para `Comparable`, e
a nova variável seja promovida para `Pattern`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-variable)" replace="/Object o2.*/[!$&!]/g;/(o2)(\.| is)/[!$1!]$2/g"?>
```dart
void f(Object o) {
  if (o is Comparable /* (1) */) {
    [!Object o2 = o;!]
    if ([!o2!] is Pattern /* (2) */) {
      print(
          [!o2!].matchAsPrefix('foo')); // (3) OK; o2 foi promovido para `Pattern`.
    }
  }
}
```

No entanto, alguém que edite o código mais tarde pode ser tentado a
alterar `Object o2` para `var o2`.
Essa alteração dá a `o2` um tipo de `Comparable`,
o que traz de volta o problema de o objeto não ser promovível para `Pattern`.

Uma verificação de tipo redundante pode ser uma solução melhor:

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-redundant)" replace="/\(o as Pattern\)/[!$&!]/g"?>
```dart tag=good
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is Pattern /* (2) */) {
      print([!(o as Pattern)!].matchAsPrefix('foo')); // (3) OK
    }
  }
}
```

Outra solução que às vezes funciona é quando você pode usar um tipo mais preciso.
Se a linha 3 se importa apenas com strings,
você pode usar `String` em sua verificação de tipo.
Como `String` é um subtipo de `Comparable`, a promoção funciona:

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-string)" replace="/is String/is [!String!]/g"?>
```dart tag=good
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is [!String!] /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) OK
    }
  }
}
```


### Escrita capturada por uma função local {:#captured-local}

**A causa:**
A variável foi write-captured (capturada por escrita) por
uma função local ou expressão de função.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  if (i == null) return; // (1)
  // ... Código adicional ...
  print(i.isEven);       // (2) ERRO
}
```

A análise de fluxo conclui que, assim que a definição de `foo` é alcançada,
ela pode ser chamada a qualquer momento,
portanto, não é mais seguro promover `i` de forma alguma.
Assim como com loops, essa rebaixamento acontece independentemente do
tipo do lado direito da atribuição.

**Solução**:

Às vezes, é possível reestruturar a lógica para que
a promoção esteja antes da captura de escrita:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-reorder)" replace="/(  )((var foo|  i = j|\}\;|\/\/ ... Use foo).*)/$1[!$2!]/g"?>
```dart tag=good
void f(int? i, int? j) {
  if (i == null) return; // (1)
  // ... Código adicional ...
  print(i.isEven); // (2) OK
  [!var foo = () {!]
  [!  i = j;!]
  [!};!]
  [!// ... Use foo ...!]
}
```

Outra opção é criar uma variável local, para que ela não seja capturada por escrita:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-copy)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!$1!]$2/g"?>
```dart tag=good
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  [!var i2 = i;!]
  if ([!i2!] == null) return; // (1)
  // ... Código adicional ...
  print([!i2!].isEven); // (2) OK porque `i2` não é capturada por escrita.
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
  // ... Código adicional ...
  print(i[!!!].isEven); // (2) OK devido à verificação `!`.
}
```


### Escrita fora do escopo da closure ou expressão de função atual {:#write-outer}

**A causa:**
A variável é escrita fora de uma *closure* (fechamento) ou expressão de função,
e a localização da promoção de tipo está
dentro da *closure* ou expressão de função.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  if (i == null) return;
  var foo = () {
    print(i.isEven); // (1) ERRO
  };
  i = j;             // (2)
}
```

A análise de fluxo entende que não há como determinar
quando `foo` pode ser chamada,
portanto, ela pode ser chamada após a atribuição em (2),
e, assim, a promoção pode não ser mais válida.
Como nos *loops*, essa despromoção acontece independentemente do tipo do
lado direito da atribuição.

**Solução**:

Uma solução é criar uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var)" replace="/var i2.*/[!$&!]/g;/i2\./[!i2!]./g"?>
```dart tag=good
void f(int? i, int? j) {
  if (i == null) return;
  [!var i2 = i;!]
  var foo = () {
    print([!i2!].isEven); // (1) OK porque `i2` não é alterado depois.
  };
  i = j; // (2)
}
```

**Exemplo:**

Um caso particularmente complicado se parece com este:

```dart tag=bad
void f(int? i) {
  i ??= 0;
  var foo = () {
    print(i.isEven); // ERRO
  };
}
```

Neste caso, um humano pode ver que a promoção é segura porque
a única escrita em `i` usa um valor não nulo e
acontece antes que `foo` seja criada.
Mas a [análise de fluxo não é tão inteligente][1536].

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

Essa solução funciona porque `j` é inferido para ter um tipo não anulável (`int`)
devido ao seu valor inicial (`i ?? 0`).
Como `j` tem um tipo não anulável,
seja atribuído ou não mais tarde,
`j` nunca pode ter um valor não nulo.


### Captura de escrita fora da closure ou expressão de função atual {:#captured-outer}

**A causa:**
A variável que você está tentando promover é capturada para escrita
fora de uma *closure* ou expressão de função,
mas este uso da variável está dentro da *closure* ou expressão de função
que está tentando promovê-la.

**Exemplo:**

```dart tag=bad
void f(int? i, int? j) {
  var foo = () {
    if (i == null) return;
    print(i.isEven); // ERRO
  };
  var bar = () {
    i = j;
  };
}
```

A análise de fluxo entende que não há como dizer
em que ordem `foo` e `bar` podem ser executadas;
na verdade, `bar` pode até ser executada no meio da execução de `foo`
(devido a `foo` chamar algo que chama `bar`).
Portanto, não é seguro promover `i` dentro de `foo`.

**Solução**:

A melhor solução é provavelmente criar uma variável local:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-write-capture)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!i2!]$2/g"?>
```dart tag=good
void f(int? i, int? j) {
  var foo = () {
    [!var i2 = i;!]
    if ([!i2!] == null) return;
    print([!i2!].isEven); // OK porque i2 é local para esta closure.
  };
  var bar = () {
    i = j;
  };
}
```

[language version]: /resources/language/evolution#language-versioning
