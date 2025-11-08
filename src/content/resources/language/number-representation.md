---
ia-translate: true
title: Numbers in Dart
breadcrumb: Numbers
description: "Aprenda como os números em Dart são ligeiramente diferentes na web, quando isso pode importar e como você pode ajustar seu código."
---

Aplicativos Dart geralmente têm como alvo múltiplas plataformas.
Por exemplo, um aplicativo Flutter pode ter como alvo iOS, Android e a web.
O código pode ser o mesmo,
contanto que o aplicativo não dependa de bibliotecas específicas da plataforma
ou use números de forma dependente da plataforma.

Esta página contém detalhes sobre as diferenças
entre implementações de números nativas e na web,
e como escrever código para que essas diferenças não importem.

:::secondary Implementações de números em Dart e outras linguagens
Dart sempre permitiu representações específicas da plataforma
e semântica para números, por motivos de
desempenho, tamanho do código e interoperabilidade da plataforma.

Da mesma forma, em C/C++ o tipo `int` comumente usado para valores inteiros é
específico da plataforma para melhor mapear para a arquitetura nativa da máquina
(16, 32 ou 64 bits).
Em Java, os tipos `float` e `double` para valores fracionários
foram originalmente projetados para seguir estritamente o IEEE 754 em todas as plataformas,
mas essa restrição foi relaxada quase imediatamente por razões de eficiência
(`strictfp` é necessário para coerência exata).
:::


## Representação de números em Dart {:#dart-number-representation}

Em Dart, todos os números fazem parte da hierarquia de tipo `Object` comum,
e existem dois tipos numéricos concretos e visíveis ao usuário:
`int`, representando valores inteiros, e `double`, representando valores fracionários.

<img
  src="/assets/img/number-class-hierarchy.svg"
  alt="Object é o pai de num, que é o pai de int e double">

Dependendo da plataforma,
esses tipos numéricos têm diferentes implementações ocultas.
Em particular, Dart tem dois tipos muito diferentes de alvos para os quais ele compila:

* **Nativo:** Mais frequentemente, um processador móvel ou de desktop de 64 bits.
* **Web:** JavaScript como o mecanismo de execução primário.

A tabela a seguir mostra como os números Dart são geralmente implementados:

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Representação</th>
      <th><code>int</code> Nativo</th>
      <th><code>double</code> Nativo</th>
      <th><code>int</code> Web</th>
      <th><code>double</code> Web</th>
    </tr>
    <tr>
      <td><a href="https://en.wikipedia.org/wiki/Two%27s_complement">
        Complemento de dois de 64 bits com sinal</a>
      </td>
      <td>✅</td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>
        <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format">Ponto flutuante de precisão dupla de 64 bits</a>
      </td>
      <td></td>
      <td>✅</td>
      <td>✅</td>
      <td>✅</td>
    </tr>
  </table>
</div>

Para alvos nativos, você pode assumir que
`int` mapeia para uma representação de inteiro de 64 bits com sinal e
`double` mapeia para uma representação de ponto flutuante IEEE de 64 bits
que corresponde ao processador.

Mas na web, onde Dart compila e interopera com JavaScript,
existe uma única representação numérica:
um valor de ponto flutuante de precisão dupla de 64 bits.
Para eficiência, Dart mapeia `int` e `double` para esta única representação.
A hierarquia de tipo visível permanece a mesma,
mas os tipos de implementação ocultos são
diferentes e interligados.

A figura a seguir ilustra os tipos específicos da plataforma (em azul)
para alvos nativos e web.
Como a figura mostra,
o tipo concreto para `int` no nativo implementa apenas a interface `int`.
No entanto, o tipo concreto para `int` na web implementa
tanto `int` quanto `double`.

<img
  src="/assets/img/number-platform-specific.svg"
  alt="Classes de implementação variam por plataforma; para JavaScript, a classe que implementa int também implementa double">


:::note
Dart representa `int` e `double` em
algumas maneiras diferentes para eficiência,
mas essas classes de implementação (em azul, acima) são ocultas.
Em geral, você pode ignorar os tipos específicos da plataforma,
e pensar em `int` e `double` como tipos concretos.
:::

Um `int` na web é representado como
um valor de ponto flutuante de precisão dupla sem parte fracionária.
Na prática, isso funciona muito bem:
ponto flutuante de precisão dupla fornece 53 bits de precisão inteira.
No entanto, valores `int` são sempre também valores `double`,
o que pode levar a algumas surpresas.


## Diferenças no comportamento {:#differences-in-behavior}

A maioria das operações aritméticas com inteiros e double
tem essencialmente o mesmo comportamento.
Existem, no entanto, diferenças importantes — particularmente
quando seu código tem expectativas rigorosas sobre
precisão, formatação de string ou tipos de tempo de execução.

Quando os resultados aritméticos diferem, conforme descrito nesta seção,
o comportamento é **específico da plataforma**
e **sujeito a alterações**.

:::note
Qualquer comportamento específico da plataforma que esta página descreve pode mudar para ser
menos surpreendente, mais consistente ou mais eficiente.
:::


### Precisão {:#precision}

A tabela a seguir demonstra como algumas expressões numéricas
diferem devido à precisão.
Aqui, `math` representa a biblioteca `dart:math`,
e `math.pow(2, 53)` é 2<sup>53</sup>.

Na web, os inteiros perdem precisão após 53 bits.
Em particular, 2<sup>53</sup> e 2<sup>53</sup>+1
mapeiam para o mesmo valor devido ao truncamento.
No nativo, esses valores ainda podem ser diferenciados
porque os números nativos têm 64 bits — 63 bits para o valor e 1 para o sinal.

O efeito do overflow (estouro) é visível
ao comparar 2<sup>63</sup>-1 com 2<sup>63</sup>.
No nativo, o último estoura para -2<sup>63</sup>,
como esperado para a aritmética de complemento de dois.
Na web, esses valores não estouram
porque são representados de maneira diferente;
eles são aproximações devido à perda de precisão.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expressão</th>
      <th>Nativo</th>
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

### Identidade {:#identity}

Em plataformas nativas, `double` e `int` são tipos distintos:
nenhum valor pode ser um `double` e um `int` ao mesmo tempo.
Na web, isso não é verdade.
Por causa dessa diferença,
a identidade pode diferir entre plataformas,
embora a igualdade (`==`) não.

A tabela a seguir mostra algumas expressões que usam igualdade e identidade.
As expressões de igualdade são as mesmas no nativo e na web;
as expressões de identidade geralmente são diferentes.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expressão</th>
      <th>Nativo</th>
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

### Tipos e verificação de tipo {:#types-and-type-checking}

Na web, o tipo `int` (inteiro) é como um subtipo de `double` (ponto flutuante de precisão dupla):
é um valor de precisão dupla sem parte fracionária.
De fato, uma verificação de tipo na web da forma `x is int`
retorna verdadeiro se `x` for um número (`double`) com
uma parte fracionária de valor zero.

Como resultado, o seguinte é verdadeiro na web:

* Todos os números Dart (valores do tipo `num`) são `double`.
* Um número Dart pode ser um `double` e um `int` ao mesmo tempo.

Esses fatos afetam as verificações `is` e as propriedades `runtimeType`.
Um efeito colateral é que `double.infinity` é interpretado como um `int`.
Como este é um comportamento específico da plataforma,
ele pode mudar no futuro.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expressão</th>
      <th>Nativo</th>
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

### Operações bit a bit {:#bitwise-operations}

Por razões de desempenho na web,
os operadores bit a bit (`&`, `|`, `^`, `~`) e de deslocamento (`<<`,`>>`, `>>>`) em `int`
usam os equivalentes nativos do JavaScript.
Em JavaScript, os operandos são truncados para inteiros de 32 bits
que são tratados como não assinados.
Esse tratamento pode levar a resultados surpreendentes em números maiores.
Em particular, se os operandos forem negativos ou não couberem em 32 bits,
é provável que produzam resultados diferentes entre nativo e web.

A tabela a seguir mostra como as plataformas nativas e web
tratam operadores bit a bit e de deslocamento quando os operandos
são negativos ou próximos de 32 bits:

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expressão</th>
      <th>Nativo</th>
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

### Representação de string {:#string-representation}

Na web, o Dart geralmente defere para o JavaScript para converter um número em uma string
(por exemplo, para um `print`).
A tabela a seguir demonstra como
converter as expressões na primeira coluna pode levar a resultados diferentes.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expressão</th>
      <th>Nativo <code>toString()</code></th>
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

## O que você deve fazer? {:#what-should-you-do}

Normalmente, você não precisa alterar seu código numérico.
O código Dart tem sido executado em plataformas nativas e web por anos,
e as diferenças de implementação de números raramente são um problema.
Código comum e típico — como iterar por um intervalo de inteiros pequenos
e indexar uma lista — se comporta da mesma maneira.

Se você tiver testes ou afirmações que comparam resultados de strings,
escreva-os de maneira resistente à plataforma.
Por exemplo, suponha que você esteja testando o valor de expressões de string
que possuem números incorporados:

```dart
void main() {
  var count = 10.0 * 2;
  var message = "$count cows";
  if (message != "20.0 cows") throw Exception("Unexpected: $message");
}
```

O código anterior é bem-sucedido em plataformas nativas, mas gera uma exceção na web
porque `message` é `"20 cows"` (sem decimal) na web.
Como alternativa, você pode escrever a condição da seguinte forma,
para que passe em plataformas nativas e web:

```dart
if (message != "${20.0} cows") throw ...
```

Para manipulação de bits, considere operar explicitamente em blocos de 32 bits,
que são consistentes em todas as plataformas.
Para forçar uma interpretação assinada de um bloco de 32 bits,
use `int.toSigned(32)`.

Para outros casos em que a precisão importa,
considere outros tipos numéricos.
O tipo [`BigInt`][]
fornece inteiros de precisão arbitrária tanto no nativo quanto na web.
O pacote [`fixnum`][]
fornece números assinados de 64 bits estritos, mesmo na web.
Use esses tipos com cuidado, no entanto:
eles geralmente resultam em código significativamente maior e mais lento.

[`BigInt`]: {{site.dart-api}}/dart-core/BigInt-class.html
[`fixnum`]: {{site.pub-pkg}}/fixnum
