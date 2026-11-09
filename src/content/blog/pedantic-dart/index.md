---
ia-translate: true
title: "Dart pedântico"
description: "No package:pedantic do Dart, estamos reunindo aos poucos uma lista de lints precisamente corretos que você pode aplicar ao seu código Dart."
publishDate: 2019-05-22
author: davidmorgan
image: images/1QCajckOeBhRaLzi0RoFqig.webp
category: other
layout: blog
---


<DashImage src="images/1QCajckOeBhRaLzi0RoFqig.webp" alt="The Dart logo." />


O [Flutter](https://flutter.dev/) e o [Flutter Web](https://flutter.dev/web) estão gerando bastante buzz, e merecidamente; eles estão empurrando os limites do desenvolvimento de UI. O Flutter é escrito em Dart, e o Dart acaba de [ganhar uma série de recursos](/blog/making-dart-a-better-language-for-ui) sob o lema “UI as Code”, que vão trazer alegria ao dia de todo desenvolvedor Flutter. São tempos empolgantes.

Mas, espere! Nem tudo deve andar rápido. Às vezes vale a pena ser meticuloso, exigente, detalhista, minucioso ou — ouso dizer — *pedante*. Então, lá no [package:pedantic](https://github.com/dart-lang/pedantic) do Dart, estamos reunindo aos poucos uma lista de *lints precisamente corretos* que você pode aplicar ao seu código.

Claro que, para verificar lints, você precisa de um linter. O [linter do Dart](https://github.com/dart-lang/linter) está integrado ao [analyzer do Dart](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer), o que significa que seus 146 lints (no momento em que escrevo) estão disponíveis em todo lugar onde você quiser: na linha de comando, no seu presubmit e na sua IDE. Como desenvolvedor Dart (ou Flutter), você tem centenas de lints à disposição; o único problema é decidir *quais* lints ativar.

Esse é um problema mais difícil do que parece. Se tudo o que você quer é usar os lints recomendados pelo package:pedantic, não precisa ler o resto: basta [seguir estas instruções](https://dart.dev/guides/language/analysis-options#default-google-rules-pedantic).

Ainda está comigo? Ótimo. Agora, vamos entender por que você não pode simplesmente ativar todos os 146 lints e começar a programar. Começaremos pelas razões mais simples e avançaremos. Depois veremos exatamente como um lint é avaliado para inclusão no package:pedantic, passaremos por um exemplo de lint que foi especialmente difícil de impor, e terminaremos com algumas dicas de como você pode se envolver.

## Lints obsoletos {:#obsolete-lints}

Alguns lints já não fazem mais sentido. Um exemplo é o [super_goes_last](https://dart-lang.github.io/linter/lints/super_goes_last.html), que exige que `super` seja colocado por último se aparecer em uma lista de inicializadores. Ele era tão útil que, com o Dart 2, virou requisito da própria linguagem, então o lint não é mais necessário.

```
// super_goes_last; now included in Dart 2, no need for a lint.
View(Style style, List children)
    : super(style), // LINT
      _children = children {
```


## Lints contraindicados {:#contraindicated-lints}

Alguns lints não são realmente destinados ao uso público. Em particular, vários lints criados para uso dentro do próprio SDK do Flutter contradizem diretamente o [guia de estilo do Dart](https://dart.dev/guides/language/effective-dart). Um exemplo é o [always_specify_types](https://dart-lang.github.io/linter/lints/always_specify_types.html); especificar tipos em excesso faz você perder os benefícios da inferência de tipos. O guia de estilo [explica com cuidado](https://dart.dev/guides/language/effective-dart/design#types) como encontrar um bom equilíbrio entre anotações de tipo e inferência de tipos.

```
// always_specify_types; do not use; breaks with recommended style!
var foo = 10; // LINT
final bar = new Bar(); // LINT
const quux = 20; // LINT
```


## Lints caros {:#expensive-lints}

Avaliar lints envolve computação arbitrária sobre uma estrutura de dados complexa — o seu código-fonte. Como saber se eles não vão deixar você mais lento? Claro que todo esforço é feito ao adicionar lints para mantê-los eficientes; mas surpresas acontecem. O lint [library_prefixes](https://dart-lang.github.io/linter/lints/library_prefixes.html) teve um bug de performance que só aparecia em casos muito obscuros; agora corrigido, claro.

```
// library_prefixes; performance issue was fixed, now good to go!
import 'dart:math' as Math; // LINT
import 'dart:json' as JSON; // LINT
import 'package:js/js.dart' as JS; // LINT
```


## Lints redundantes {:#redundant-lints}

A maioria dos lints é extremamente rápida de calcular, mas não é totalmente de graça. Então, um lint precisa se justificar; precisa oferecer valor suficiente. Por exemplo, rejeitamos o lint [empty_statements](https://dart-lang.github.io/linter/lints/empty_statements.html) sob o argumento de que usar o `dartfmt` torna as instruções vazias fáceis de identificar. É improvável que elas sejam escritas por engano, e por isso o lint é redundante.

```
// empty_statements; considered redundant with dartfmt.
if (complicated.expression.foo()) ; // LINT
```


## Lints afobados {:#overeager-lints}

Alguns lints não são precisos o bastante para serem impostos. Por exemplo, omitir os tipos de variáveis locais em Dart é [um bom estilo](https://dart.dev/guides/language/effective-dart/design#avoid-type-annotating-initialized-local-variables), mas só *na maioria das vezes*. É uma recomendação, não uma regra rígida. Isso torna o lint correspondente, [omit_local_variable_types](https://dart-lang.github.io/linter/lints/omit_local_variable_types.html), rigoroso demais para ser imposto em todo lugar.

```
// omit_local_variable_types; too strict. Local variable types
// are good style where they improve readability.
void myMethod() {
  MyType bar = expression.methodCall().otherMethodCall(); // LINT
}
```


## Lints opinativos {:#opinionated-lints}

Alguns lints empurram o código em uma direção que não está *errada*, mas que é incomum. Um exemplo é o [prefer_final_locals](https://dart-lang.github.io/linter/lints/prefer_final_locals.html), que exige que variáveis locais sejam declaradas, quando possível, como `final`. Esse é um estilo que alguns desenvolvedores preferem, mas não é o que *a maioria* dos desenvolvedores Dart prefere, e por isso, por padrão, o lint deve ficar desligado.

```
// prefer_final_locals; inconsistent with common style.
void myMethod() {
  var label = 'foo'; // LINT 
}
```


## Avaliando todos os lints {:#evaluating-all-the-lints}

Pode parecer que, mesmo levando tudo isso em conta, alguém com bom conhecimento de Dart deveria conseguir sentar com a lista dos 146 lints disponíveis e produzir uma lista de lints recomendados sem muita dificuldade.

Mas não é isso que encontramos; é uma tarefa grande demais. Assim como cada lint pode fazer avaliação arbitrária no seu código, decidir se um lint específico é ao mesmo tempo correto e útil acaba sendo quase arbitrariamente difícil.

Uma boa forma de abordar uma pergunta difícil é buscar dados concretos. Então, ao considerar cada lint, primeiro medimos sua performance e reunimos informações sobre todas as violações desse lint presentes atualmente no código Dart interno do Google.

Esses números nos dão um bom ponto de partida para a discussão.

Se, por exemplo, todo o código Dart do Google contiver apenas cinco violações de um lint, então cada uma delas precisa ser um bug sério; caso contrário, é improvável que o lint esteja se justificando. O lint [recursive_getters](https://dart-lang.github.io/linter/lints/recursive_getters.html) foi um raro exemplo de lint que capturou um número muito pequeno de problemas sérios; um getter que chama a si mesmo é um estouro de pilha esperando para acontecer.

```
// recursive_getters; definitely not what you meant to write!
int get field => field; // LINT
```


Se, por outro lado, encontrarmos muitas violações do lint, a questão se inverte: o lint vai mudar o que muitos desenvolvedores estão fazendo, então temos certeza de que é uma melhoria, tanto no geral quanto em cada caso individual? Se o lint piorar um número pequeno de casos, podemos justificar isso? Ou, talvez, podemos melhorar o lint?

O lint [unrelated_type_equality_checks](https://dart-lang.github.io/linter/lints/unrelated_type_equality_checks.html) é um bom exemplo. Esse lint exige que, antes de você poder comparar dois objetos, eles tenham tipos estáticos compatíveis. Assim, você não pode verificar se `3` e `foo` são iguais; presume-se que, como um é um `int` e o outro é uma `String`, a pergunta nem faz sentido.

```
// unrelated_type_equality_checks; or, don't ask stupid questions!
void someFunction() {
  var x = '1';
  if (x == 1) print('surprise!'); // LINT
}
```


Isso soa bem, mas não está correto por dois motivos.

Ele falha em teoria por causa de `implements`; um objeto pode ser de mais de um tipo, então dois objetos que aparentam, estaticamente, não ter relação podem acabar, em tempo de execução, implementando o mesmo tipo, e ser perfeitamente válidos para comparação.

```
// unrelated_type_equality_checks; objects _can_ hold surprises.
void checkForSurprise(Foo foo, Bar bar) {
  if (foo == bar) print('surprise!'); // LINT
}

abstract class Foo {}
abstract class Bar {}
class Baz implements Foo, Bar {}

void main() {
  var baz = Baz();
  checkForSurprise(baz, baz);
}
```


Ele falha na prática porque o `operator==` fica a cargo de cada autor de classe implementar, e nada os obriga a seguir o seu contrato. Descobrimos, em particular, que `Int64` e `Int32`, do `package:fixnum`, permitem comparações com `int`, mas somente quando o `int` está do lado direito do `==`.

Assim, os dados mostraram três resultados para o lint: muitos achados corretos (bugs capturados), um pequeno número de achados incorretos causados por tipos em tempo de execução compatíveis quando os tipos estáticos não eram, e um número relativamente grande de achados incorretos causados por `Int64` sendo comparado com `int`.

O que fizemos? Melhoramos o lint: agora ele conhece `Int64` (e `Int32`) e permite compará-los com `int`, como você fazia antes. Isso deixou um número muito pequeno de falsos positivos causados por tipos estáticos incompletos; esses optamos por refatorar, usando casts quando necessário, para que cumpram o lint.

Com essas mudanças, conseguimos chegar a um consenso para que o unrelated_type_equality_checks fosse imposto.

Quando dizemos “nós”, neste caso, queremos dizer “o conjunto de todos os desenvolvedores do Google que se importam com lints do Dart”. Qualquer pessoa no Google que escreva Dart pode participar desse processo, e muitas pessoas participam, então recebemos bastante contribuição — principalmente quando um lint é controverso!

Quando há consenso sobre um lint, o próximo passo é que a pessoa que propôs a imposição do lint limpe todo o código Dart interno do Google para que ele passe no lint. Às vezes aprendemos algo novo nesse processo; se deixamos passar algo que tornaria a limpeza uma mudança incompatível ou difícil, a limpeza normalmente é pausada. No momento, temos lints suficientes em andamento para que possamos simplesmente pular esses casos e voltar a eles depois.

Uma vez que um lint é limpo com sucesso em todos os lugares, ele passa a ser imposto no presubmit, impedindo novas violações no código interno do Google, e é publicado na próxima versão do `package:pedantic`.

O lint [unawaited_futures](https://dart-lang.github.io/linter/lints/unawaited_futures.html) foi um caso ainda mais difícil. Esse lint trata do que costumava ser uma queixa muito comum entre desenvolvedores: esquecer de dar `await` em um `Future`, causando comportamento imprevisível em tempo de execução e testes instáveis.

```
// unawaited_futures; catching accidentally asynchronous behaviour.

Future<void> doSomething() => ...;
Future<void> doSomethingElse() => ...;

void main() async {
  doSomething(); // LINT
  doSomethingElse(); // LINT
}
```


Mas o lint é problemático porque *sabemos* que há casos em que você *quer* iniciar um `Future` e continuar sem esperar que ele seja concluído. Um exemplo é o log: normalmente é aceitável saber que o log será concluído em algum momento, sem precisar esperar por ele.

O lint oferecia um valor enorme, mas não poderia, de forma alguma, ser tornado correto. Discutimos por muito tempo qual seria o melhor caminho. Lints do Dart podem ser ignorados escrevendo `// ignore: &lt;lint_name&gt;` na linha anterior, então impor um lint nunca é *de fato* bloqueante para os desenvolvedores. Mas realmente não queríamos ensinar os desenvolvedores a escrever `ignore`; a maioria dos lints que impomos *são* sempre corretos e nunca deveriam ser ignorados.

Essa discussão, na verdade, levou à criação do `package:pedantic` em primeiro lugar. Queríamos fornecer a forma canônica de dizer: “eu sei do lint unawaited_futures, e ele não se aplica aqui”. Esse é agora o método `unawaited` do `package:pedantic`. Depois de publicá-lo, atualizamos a mensagem e a documentação do lint unawaited_futures para apontar para `unawaited`, e agora estamos num lugar que esperamos ser razoavelmente bom: temos um lint que às vezes você precisa desligar, e uma forma canônica e legível de fazer isso.

```
// unawaited_futures; say `unawaited` if that's what you wanted.

Future<void> doSomething() => ...;
Future<void> doSomethingElse() => ...;

void main() async {
  unawaited(doSomething());
  unawaited(doSomethingElse());
}
```


Isso foi suficiente para chegar a um consenso sobre a imposição do lint unawaited_futures.

## Passo a passo rumo a um linting perfeito para Dart {:#step-by-step-towards-perfect-dart-linting}

E assim o processo continua. Agora temos 25 lints ativados e oito lints explicitamente desativados, então ainda não chegamos nem a um quarto dos 146 lints disponíveis. Claro que as pessoas continuam adicionando novos lints — o design do linter torna isso fácil —, então é um alvo em movimento.

Eu adoraria poder agitar uma varinha mágica e fornecer a lista perfeita de lints; espero que este artigo tenha explicado por que isso não é possível, e que estamos trabalhando nisso.

Por fim, se já existem lints que você gostaria de ver ativados mais cedo do que tarde, você é bem-vindo a usar o [issue tracker](https://github.com/dart-lang/pedantic/issues) do `pedantic` para deixar isso claro; levamos as issues em conta ao decidir o que tratar em seguida. Infelizmente, como o código interno do Google é fundamental para decidir quais lints ativar, não podemos tornar todo o processo transparente, mas buscamos ser o mais abertos possível nas nossas discussões no GitHub. Em particular, podemos dar feedback, na medida do possível, sobre o que é provável que entre no package:pedantic e quando.

Se você tiver interesse em contribuir com novos lints ou melhorar os existentes, participe no GitHub!
