---
ia-translate: true
title: Numbers in Dart
breadcrumb: Numbers
description: >-
  Learn how Dart numbers are slightly different on the web,
  when that might matter, and how you might adjust your code.
---

<!-- ia-translate: true -->

Aplicações Dart frequentemente têm como alvo múltiplas plataformas.
Por exemplo, uma aplicação Flutter pode ter como alvo iOS, Android e a web.
O código pode ser o mesmo,
desde que a aplicação não dependa de bibliotecas específicas da plataforma
ou use números de uma forma que é dependente da plataforma.

Esta página tem detalhes sobre as diferenças
entre implementações de números nativas e web,
e como escrever código para que essas diferenças não importem.

:::secondary Number implementations in Dart and other languages
Dart sempre permitiu representações específicas da plataforma
e semântica para números, por razões de
performance, tamanho de código e interoperabilidade com a plataforma.

De forma similar, em C/C++ o tipo `int` comumente usado para valores inteiros é
específico da plataforma para melhor mapear para a arquitetura de máquina nativa
(16-, 32- ou 64-bit).
Em Java, os tipos `float` e `double` para valores fracionários
foram originalmente projetados para seguir estritamente o IEEE 754 em todas as plataformas,
mas essa restrição foi afrouxada quase imediatamente por razões de eficiência
(`strictfp` é necessário para coerência exata).
:::


## Dart number representation

No Dart, todos os números são parte da hierarquia de tipo comum `Object`,
e existem dois tipos numéricos concretos e visíveis ao usuário:
`int`, representando valores inteiros, e `double`, representando valores fracionários.

<img
  src="/assets/img/number-class-hierarchy.svg"
  alt="Object is the parent of num, which is the parent of int and double">

Dependendo da plataforma,
esses tipos numéricos têm implementações diferentes e ocultas.
Em particular, Dart tem dois tipos muito diferentes de alvos para os quais compila:

* **Native:** Na maioria das vezes, um processador móvel ou desktop de 64 bits.
* **Web:** JavaScript como o motor de execução principal.

A tabela a seguir mostra como os números Dart são geralmente implementados:

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Representation</th>
      <th>Native <code>int</code></th>
      <th>Native <code>double</code></th>
      <th>Web <code>int</code></th>
      <th>Web <code>double</code></th>
    </tr>
    <tr>
      <td><a href="https://en.wikipedia.org/wiki/Two%27s_complement">
        64-bit signed two's complement</a>
      </td>
      <td>✅</td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>
        <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format">64-bit floating point</a>
      </td>
      <td></td>
      <td>✅</td>
      <td>✅</td>
      <td>✅</td>
    </tr>
  </table>
</div>

Para alvos nativos, você pode assumir que
`int` mapeia para uma representação inteira com sinal de 64 bits e
`double` mapeia para uma representação de ponto flutuante IEEE de 64 bits
que corresponde ao processador subjacente.

Mas na web, onde Dart compila para e interopera com JavaScript,
existe uma única representação numérica:
um valor de ponto flutuante de precisão dupla de 64 bits.
Por eficiência, Dart mapeia tanto `int` quanto `double` para essa representação única.
A hierarquia de tipo visível permanece a mesma,
mas os tipos de implementação ocultos subjacentes são
diferentes e entrelaçados.

A figura a seguir ilustra os tipos específicos da plataforma (em azul)
para alvos nativos e web.
Como a figura mostra,
o tipo concreto para `int` em nativo implementa apenas a interface `int`.
No entanto, o tipo concreto para `int` na web implementa
tanto `int` quanto `double`.

<img
  src="/assets/img/number-platform-specific.svg"
  alt="Implementation classes vary by platform; for JavaScript, the class that implements int also implements double">


:::note
Dart representa `int` e `double` de
algumas maneiras diferentes por eficiência,
mas essas classes de implementação (em azul, acima) estão ocultas.
Em geral, você pode ignorar os tipos específicos da plataforma,
e pensar em `int` e `double` como tipos concretos.
:::

Um `int` na web é representado como
um valor de ponto flutuante de precisão dupla sem parte fracionária.
Na prática, isso funciona muito bem:
ponto flutuante de precisão dupla fornece 53 bits de precisão inteira.
No entanto, valores `int` são sempre também valores `double`,
o que pode levar a algumas surpresas.


## Differences in behavior

A maioria dos cálculos aritméticos de inteiros e doubles
tem essencialmente o mesmo comportamento.
No entanto, há diferenças importantes—particularmente
quando seu código tem expectativas rígidas sobre
precisão, formatação de strings ou tipos de tempo de execução subjacentes.

Quando os resultados aritméticos diferem, como descrito nesta seção,
o comportamento é **específico da plataforma**
e **sujeito a mudanças**.

:::note
Qualquer comportamento específico da plataforma que esta página descreve pode mudar para ser
menos surpreendente, mais consistente ou mais performático.
:::


### Precision

A tabela a seguir demonstra como algumas expressões numéricas
diferem devido à precisão.
Aqui, `math` representa a biblioteca `dart:math`,
e `math.pow(2, 53)` é 2<sup>53</sup>.

Na web, inteiros perdem precisão após 53 bits.
Em particular, 2<sup>53</sup> e 2<sup>53</sup>+1
mapeiam para o mesmo valor devido ao truncamento.
Em nativo, esses valores ainda podem ser diferenciados
porque números nativos têm 64 bits—63 bits para o valor e 1 para o sinal.

O efeito do overflow é visível
ao comparar 2<sup>63</sup>-1 a 2<sup>63</sup>.
Em nativo, o último causa overflow para -2<sup>63</sup>,
como esperado para aritmética de complemento de dois.
Na web, esses valores não causam overflow
porque são representados de forma diferente;
são aproximações devido à perda de precisão.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>math.pow(2, 53) - 1</code></td>
      <td><code>9007199254740991</code></td>
      <td><code>9007199254740991</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 53)</code></td>
      <td><code>9007199254740992</code></td>
      <td><code>9007199254740992</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 53) + 1</code></td>
      <td><code>9007199254740993</code></td>
      <td><code>9007199254740992</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 62)</code></td>
      <td><code>4611686018427387904</code></td>
      <td><code>4611686018427388000</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 63) - 1</code></td>
      <td><code>9223372036854775807</code></td>
      <td><code>9223372036854776000</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 63)</code></td>
      <td><code>-9223372036854775808</code></td>
      <td><code>9223372036854776000</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 64)</code></td>
      <td><code>0</code></td>
      <td><code>18446744073709552000</code></td>
    </tr>
  </table>
</div>

### Identity

Em plataformas nativas, `double` e `int` são tipos distintos:
nenhum valor pode ser tanto um `double` quanto um `int` ao mesmo tempo.
Na web, isso não é verdade.
Devido a essa diferença,
identidade pode diferir entre plataformas,
embora igualdade (`==`) não.

A tabela a seguir mostra algumas expressões que usam igualdade e identidade.
As expressões de igualdade são as mesmas em nativo e web;
as expressões de identidade geralmente são diferentes.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>1.0 == 1</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>identical(1.0, 1)</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>0.0 == -0.0</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>identical(0.0, -0.0)</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>double.nan == double.nan</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>identical(double.nan, double.nan)</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>double.infinity == double.infinity</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>identical(double.infinity, double.infinity)</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
  </table>
</div>

### Types and type checking

Na web, o tipo `int` subjacente é como um subtipo de `double`:
é um valor de precisão dupla sem uma parte fracionária.
De fato, uma verificação de tipo na web do tipo `x is int`
retorna true se `x` for um número (`double`) com
uma parte fracionária de valor zero.

Como resultado, o seguinte é verdadeiro na web:

* Todos os números Dart (valores do tipo `num`) são `double`.
* Um número Dart pode ser tanto um `double` quanto um `int` ao mesmo tempo.

Esses fatos afetam verificações `is` e propriedades `runtimeType`.
Um efeito colateral é que `double.infinity` é interpretado como um `int`.
Como este é um comportamento específico da plataforma,
pode mudar no futuro.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>1 is int</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>1 is double</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>1.0 is int</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>1.0 is double</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>(0.5 + 0.5) is int</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>(0.5 + 0.5) is double</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>3.14 is int</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>3.14 is double</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>double.infinity is int</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>double.nan is int</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>1.0.runtimeType</code></td>
      <td><code>double</code></td>
      <td><code>int</code></td>
    </tr>
    <tr>
      <td><code>1.runtimeType</code></td>
      <td><code>int</code></td>
      <td><code>int</code></td>
    </tr>
    <tr>
      <td><code>1.5.runtimeType</code></td>
      <td><code>double</code></td>
      <td><code>double</code></td>
    </tr>
  </table>
</div>

### Bitwise operations

Por razões de performance na web,
operadores bitwise (`&`, `|`, `^`, `~`) e de deslocamento (`<<`,`>>`, `>>>`) em `int`
usam os equivalentes nativos do JavaScript.
No JavaScript, os operandos são truncados para inteiros de 32 bits
que são tratados como não assinados.
Esse tratamento pode levar a resultados surpreendentes em números maiores.
Em particular, se os operandos são negativos ou não cabem em 32 bits,
é provável que produzam resultados diferentes entre nativo e web.

A tabela a seguir mostra como plataformas nativas e web
tratam operadores bitwise e de deslocamento quando os operandos
são negativos ou próximos de 32 bits:

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>-1 >> 0</code></td>
      <td><code>-1</code></td>
      <td><code>4294967295</code></td>
    </tr>
    <tr>
      <td><code>-1 ^ 2</code></td>
      <td><code>-3</code></td>
      <td><code>4294967293</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 32).toInt()</code></td>
      <td><code>4294967296</code></td>
      <td><code>4294967296</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 32).toInt() >> 1</code></td>
      <td><code>2147483648</code></td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td><code>(math.pow(2, 32).toInt()-1) >> 1</code></td>
      <td><code>2147483647</code></td>
      <td><code>2147483647</code></td>
    </tr>
  </table>
</div>

### String representation

Na web, Dart geralmente delega ao JavaScript para converter um número em uma string
(por exemplo, para um `print`).
A tabela a seguir demonstra como
converter as expressões na primeira coluna pode levar a resultados diferentes.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native <code>toString()</code></th>
      <th>Web <code>toString()</code></th>
    </tr>
    <tr>
      <td><code>1</code></td>
      <td><code>"1"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>1.0</code></td>
      <td><code>"1.0"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>(0.5 + 0.5)</code></td>
      <td><code>"1.0"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>1.5</code></td>
      <td><code>"1.5"</code></td>
      <td><code>"1.5"</code></td>
    </tr>
    <tr>
      <td><code>-0</code></td>
      <td><code>"0"</code></td>
      <td><code>"-0.0"</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 0)</code></td>
      <td><code>"1"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 80)</code></td>
      <td><code>"0"</code></td>
      <td><code>"1.2089258196146292e+24"</code></td>
    </tr>
  </table>
</div>

## What should you do?

Geralmente, você não precisa mudar seu código numérico.
Código Dart tem sido executado em plataformas nativas e web por anos,
e diferenças na implementação de números raramente são um problema.
Código comum e típico—como iterar através de um intervalo de pequenos inteiros
e indexar uma lista—se comporta da mesma forma.

Se você tem testes ou asserções que comparam resultados de strings,
escreva-os de uma maneira resiliente à plataforma.
Por exemplo, suponha que você está testando o valor de expressões de string
que têm números embutidos:

```dart
void main() {
  var count = 10.0 * 2;
  var message = "$count cows";
  if (message != "20.0 cows") throw Exception("Unexpected: $message");
}
```

O código anterior tem sucesso em plataformas nativas mas falha na web
porque `message` é `"20 cows"` (sem decimal) na web.
Como alternativa, você pode escrever a condição da seguinte forma,
para que passe tanto em plataformas nativas quanto web:

```dart
if (message != "${20.0} cows") throw ...
```

Para manipulação de bits, considere operar explicitamente em pedaços de 32 bits,
que são consistentes em todas as plataformas.
Para forçar uma interpretação assinada de um pedaço de 32 bits,
use `int.toSigned(32)`.

Para outros casos onde a precisão importa,
considere outros tipos numéricos.
O tipo [`BigInt`][]
fornece inteiros de precisão arbitrária tanto em nativo quanto em web.
O pacote [`fixnum`][]
fornece números assinados estritos de 64 bits, mesmo na web.
Use esses tipos com cuidado:
eles geralmente resultam em código significativamente maior e mais lento.

[`BigInt`]: {{site.dart-api}}/dart-core/BigInt-class.html
[`fixnum`]: {{site.pub-pkg}}/fixnum
