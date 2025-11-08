---
title: "Effective Dart: Design"
breadcrumb: Design
description: Design consistent, usable libraries.
prevpage:
  url: /effective-dart/usage
  title: Usage
ia-translate: true
---
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Aqui estão algumas diretrizes para escrever APIs consistentes e utilizáveis para bibliotecas.

## Names

Nomenclatura é uma parte importante de escrever código legível e fácil de manter.
As seguintes melhores práticas podem ajudá-lo a alcançar esse objetivo.

### FAÇA use termos consistentemente

Use o mesmo nome para a mesma coisa, em todo o seu código. Se um precedente
já existe fora da sua API que os usuários provavelmente conhecem, siga esse
precedente.

```dart tag=good
pageCount         // A field.
updatePageCount() // Consistent with pageCount.
toSomething()     // Consistent with Iterable's toList().
asSomething()     // Consistent with List's asMap().
Point             // A familiar concept.
```

```dart tag=bad
renumberPages()      // Confusingly different from pageCount.
convertToSomething() // Inconsistent with toX() precedent.
wrappedAsSomething() // Inconsistent with asX() precedent.
Cartesian            // Unfamiliar to most users.
```

O objetivo é aproveitar o que o usuário já sabe. Isso inclui
seu conhecimento do próprio domínio do problema, as convenções das bibliotecas
principais, e outras partes da sua própria API. Ao construir em cima disso, você
reduz a quantidade de novo conhecimento que eles precisam adquirir antes que possam ser
produtivos.


### EVITE abreviações

A menos que a abreviação seja mais comum do que o termo completo, não
abrevie. Se você abreviar, [capitalize corretamente][caps].

[caps]: /effective-dart/style#identifiers

```dart tag=good
pageCount
buildRectangles
IOStream
HttpRequest
```

```dart tag=bad
numPages    // "Num" is an abbreviation of "number (of)".
buildRects
InputOutputStream
HypertextTransferProtocolRequest
```


### PREFIRA colocar o substantivo mais descritivo por último

A última palavra deve ser a mais descritiva do que a coisa é. Você pode
prefixá-la com outras palavras, como adjetivos, para descrever ainda mais a coisa.

```dart tag=good
pageCount             // A count (of pages).
ConversionSink        // A sink for doing conversions.
ChunkedConversionSink // A ConversionSink that's chunked.
CssFontFaceRule       // A rule for font faces in CSS.
```

```dart tag=bad
numPages                  // Not a collection of pages.
CanvasRenderingContext2D  // Not a "2D".
RuleFontFaceCss           // Not a CSS.
```


### CONSIDERE fazer o código ler como uma sentença

Quando em dúvida sobre nomenclatura, escreva algum código que use sua API, e tente ler
como uma sentença.

<?code-excerpt "design_good.dart (code-like-prose)"?>
```dart tag=good
// "If errors is empty..."
if (errors.isEmpty) {
  // ...
}

// "Hey, subscription, cancel!"
subscription.cancel();

// "Get the monsters where the monster has claws."
monsters.where((monster) => monster.hasClaws);
```

<?code-excerpt "design_bad.dart (code-like-prose)" replace="/ as bool//g"?>
```dart tag=bad
// Telling errors to empty itself, or asking if it is?
if (errors.empty) {
  // ...
}

// Toggle what? To what?
subscription.toggle();

// Filter the monsters with claws *out* or include *only* those?
monsters.filter((monster) => monster.hasClaws);
```

É útil experimentar sua API e ver como ela "lê" quando usada em código, mas
você pode ir longe demais. Não é útil adicionar artigos e outras partes do discurso
para forçar seus nomes a *literalmente* lerem como uma sentença gramaticalmente correta.

<?code-excerpt "design_bad.dart (code-like-prose-overdone)"?>
```dart tag=bad
if (theCollectionOfErrors.isEmpty) {
  // ...
}

monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
```


### PREFIRA uma frase substantiva para uma propriedade ou variável não-booleana

O foco do leitor está em *o que* a propriedade é. Se o usuário se importa mais sobre
*como* uma propriedade é determinada, então provavelmente deveria ser um método com um
nome de frase verbal.

```dart tag=good
list.length
context.lineWidth
quest.rampagingSwampBeast
```

```dart tag=bad
list.deleteItems
```


### PREFIRA uma frase verbal não-imperativa para uma propriedade ou variável booleana

Nomes booleanos são frequentemente usados como condições em fluxo de controle, então você quer um nome
que leia bem lá. Compare:

```dart
if (window.closeable) ...  // Adjective.
if (window.canClose) ...   // Verb.
```

Bons nomes tendem a começar com um de alguns tipos de verbos:

*   uma forma de "to be" (ser/estar): `isEnabled`, `wasShown`, `willFire`. Estes são, de longe,
    os mais comuns.

*   um [verbo auxiliar][auxiliary verb]: `hasElements`, `canClose`,
    `shouldConsume`, `mustSave`.

*   um verbo ativo: `ignoresInput`, `wroteFile`. Estes são raros porque geralmente são
    ambíguos. `loggedResult` é um nome ruim porque pode significar
    "se um resultado foi registrado ou não" ou "o resultado que foi registrado".
    Da mesma forma, `closingConnection` pode ser "se a conexão está fechando"
    ou "a conexão que está fechando". Verbos ativos são permitidos quando o nome
    pode *apenas* ser lido como um predicado.

[auxiliary verb]: https://en.wikipedia.org/wiki/Auxiliary_verb

O que separa todas essas frases verbais de nomes de métodos é que elas não são
*imperativas*. Um nome booleano nunca deve soar como um comando para dizer ao
objeto para fazer algo, porque acessar uma propriedade não muda o objeto.
(Se a propriedade *realmente* modifica o objeto de forma significativa, deve ser um
método.)

```dart tag=good
isEmpty
hasElements
canClose
closesWindow
canShowPopup
hasShownPopup
```

```dart tag=bad
empty         // Adjective or verb?
withElements  // Sounds like it might hold elements.
closeable     // Sounds like an interface.
              // "canClose" reads better as a sentence.
closingWindow // Returns a bool or a window?
showPopup     // Sounds like it shows the popup.
```


### CONSIDERE omitir o verbo para um *parâmetro* booleano nomeado

Isso refina a regra anterior. Para parâmetros nomeados que são booleanos, o nome
é frequentemente tão claro sem o verbo, e o código lê melhor no local da
chamada.

<?code-excerpt "design_good.dart (omit-verb-for-bool-param)"?>
```dart tag=good
Isolate.spawn(entryPoint, message, paused: false);
var copy = List.from(elements, growable: true);
var regExp = RegExp(pattern, caseSensitive: false);
```


### PREFIRA o nome "positivo" para uma propriedade ou variável booleana

A maioria dos nomes booleanos tem formas conceitualmente "positivas" e "negativas" onde a
primeira parece o conceito fundamental e a última é sua
negação—"aberto" e "fechado", "habilitado" e "desabilitado", etc. Frequentemente o
último nome literalmente tem um prefixo que nega o primeiro: "visível" e
"*in*-visível", "conectado" e "*des*-conectado", "zero" e "*não*-zero".

Ao escolher qual dos dois casos que `true` representa—e assim
qual caso a propriedade é nomeada—prefira o positivo ou mais
fundamental. Membros booleanos são frequentemente aninhados dentro de expressões lógicas,
incluindo operadores de negação. Se sua propriedade em si lê como uma negação,
é mais difícil para o leitor mentalmente realizar a dupla negação e
entender o que o código significa.

<?code-excerpt "design_good.dart (positive)"?>
```dart tag=good
if (socket.isConnected && database.hasData) {
  socket.write(database.read());
}
```

<?code-excerpt "design_bad.dart (positive)"?>
```dart tag=bad
if (!socket.isDisconnected && !database.isEmpty) {
  socket.write(database.read());
}
```

Para algumas propriedades, não há forma positiva óbvia. Um documento que foi
descarregado no disco é "salvo" ou "*não*-alterado"? Um documento que *não* foi
descarregado é "*não*-salvo" ou "alterado"? Em casos ambíguos, incline-se para a escolha
que é menos provável de ser negada pelos usuários ou tem o nome mais curto.

**Exceção:** Com algumas propriedades, a forma negativa é o que os usuários
esmagadoramente precisam usar. Escolher o caso positivo os forçaria a
negar a propriedade com `!` em todos os lugares. Em vez disso, pode ser melhor usar o
caso negativo para essa propriedade.


### PREFIRA uma frase verbal imperativa para uma função ou método cujo principal propósito é um efeito colateral

Membros chamáveis podem retornar um resultado ao chamador e realizar outro trabalho ou
efeitos colaterais. Em uma linguagem imperativa como Dart, membros são frequentemente chamados
principalmente por seu efeito colateral: eles podem mudar o estado interno de um objeto,
produzir alguma saída, ou conversar com o mundo exterior.

Esses tipos de membros devem ser nomeados usando uma frase verbal imperativa que
clarifica o trabalho que o membro realiza.

<?code-excerpt "design_good.dart (verb-for-func-with-side-effect)"?>
```dart tag=good
list.add('element');
queue.removeFirst();
window.refresh();
```

Dessa forma, uma invocação lê como um comando para fazer esse trabalho.


### PREFIRA uma frase substantiva ou frase verbal não-imperativa para uma função ou método se retornar um valor é seu propósito principal

Outros membros chamáveis têm poucos efeitos colaterais mas retornam um resultado útil ao
chamador. Se o membro não precisa de parâmetros para fazer isso, geralmente deveria ser um
getter. Mas às vezes uma "propriedade" lógica precisa de alguns parâmetros. Por exemplo,
`elementAt()` retorna um pedaço de dados de uma coleção, mas precisa de um
parâmetro para saber *qual* pedaço de dados retornar.

Isso significa que o membro é *sintaticamente* um método, mas *conceitualmente* é uma
propriedade, e deve ser nomeado como tal usando uma frase que descreve *o que* o
membro retorna.

<?code-excerpt "design_good.dart (noun-for-func-returning-value)"?>
```dart tag=good
var element = list.elementAt(3);
var first = list.firstWhere(test);
var char = string.codeUnitAt(4);
```

Esta diretriz é deliberadamente mais suave do que a anterior. Às vezes um método
não tem efeitos colaterais mas ainda é mais simples nomear com uma frase verbal como
`list.take()` ou `string.split()`.


### CONSIDERE uma frase verbal imperativa para uma função ou método se você quer chamar atenção para o trabalho que realiza

Quando um membro produz um resultado sem quaisquer efeitos colaterais, geralmente deveria ser um
getter ou um método com um nome de frase substantiva descrevendo o resultado que retorna.
No entanto, às vezes o trabalho necessário para produzir esse resultado é importante. Pode
ser propenso a falhas em tempo de execução, ou usar recursos pesados como rede ou
I/O de arquivo. Em casos como este, onde você quer que o chamador pense sobre o trabalho
que o membro está fazendo, dê ao membro um nome de frase verbal que descreve esse
trabalho.

<?code-excerpt "design_good.dart (verb-for-func-with-work)"?>
```dart tag=good
var table = database.downloadData();
var packageVersions = packageGraph.solveConstraints();
```

Note, porém, que esta diretriz é mais suave do que as duas anteriores. O trabalho que uma
operação realiza é frequentemente um detalhe de implementação que não é relevante para o
chamador, e os limites de desempenho e robustez mudam ao longo do tempo. Na maioria das
vezes, nomeie seus membros baseado em *o que* eles fazem para o chamador, não *como* eles
fazem.


### EVITE iniciar um nome de método com `get`

Na maioria dos casos, o método deveria ser um getter com `get` removido do nome.
Por exemplo, em vez de um método chamado `getBreakfastOrder()`, defina um getter
chamado `breakfastOrder`.

Mesmo se o membro realmente precisa ser um método porque aceita argumentos ou
de outra forma não é um bom ajuste para um getter, você ainda deve evitar `get`. Como as
diretrizes anteriores afirmam, ou:

* Simplesmente remova `get` e [use um nome de frase substantiva][noun] como `breakfastOrder()`
  se o chamador se importa principalmente sobre o valor que o método retorna.

* [Use um nome de frase verbal][verb] se o chamador se importa sobre o trabalho sendo feito,
  mas escolha um verbo que descreve mais precisamente o trabalho do que `get`, como
  `create`, `download`, `fetch`, `calculate`, `request`, `aggregate`, etc.

[noun]: #prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose

[verb]: #consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs


### PREFIRA nomear um método `to___()` se ele copia o estado do objeto para um novo objeto

{% render 'linter-rule-mention.md', rules:'use_to_and_as_if_applicable' %}

Um método de *conversão* é aquele que retorna um novo objeto contendo uma cópia de
quase todo o estado do receptor mas geralmente em alguma forma ou
representação diferente. As bibliotecas principais têm uma convenção de que esses métodos são
nomeados começando com `to` seguido pelo tipo de resultado.

Se você definir um método de conversão, é útil seguir essa convenção.

<?code-excerpt "design_good.dart (to-misc)"?>
```dart tag=good
list.toSet();
stackTrace.toString();
dateTime.toLocal();
```

### PREFIRA nomear um método `as___()` se ele retorna uma representação diferente apoiada pelo objeto original

{% render 'linter-rule-mention.md', rules:'use_to_and_as_if_applicable' %}

Métodos de conversão são "instantâneos". O objeto resultante tem sua própria cópia do
estado do objeto original. Existem outros métodos similares a conversão que retornam
*visualizações*—eles fornecem um novo objeto, mas esse objeto se refere de volta ao
original. Mudanças posteriores no objeto original são refletidas na visualização.

A convenção da biblioteca principal para você seguir é `as___()`.

<?code-excerpt "design_good.dart (as-misc)"?>
```dart tag=good
var map = table.asMap();
var list = bytes.asFloat32List();
var future = subscription.asFuture();
```


### EVITE descrever os parâmetros no nome da função ou método

O usuário verá o argumento no local da chamada, então geralmente não ajuda
a legibilidade também se referir a ele no próprio nome.

<?code-excerpt "design_good.dart (avoid-desc-param-in-func)"?>
```dart tag=good
list.add(element);
map.remove(key);
```

```dart tag=bad
list.addElement(element)
map.removeKey(key)
```

No entanto, pode ser útil mencionar um parâmetro para desambiguá-lo de outros
métodos com nomes similares que aceitam tipos diferentes:

<?code-excerpt "design_good.dart (desc-param-in-func-ok)"?>
```dart tag=good
map.containsKey(key);
map.containsValue(value);
```


### FAÇA siga as convenções mnemônicas existentes ao nomear parâmetros de tipo

Nomes de uma única letra não são exatamente esclarecedores, mas quase todos os tipos genéricos
os usam. Felizmente, eles os usam principalmente de uma forma consistente e mnemônica.
As convenções são:

*   `E` para o tipo de **elemento** em uma coleção:

    <?code-excerpt "design_good.dart (type-parameter-e)" replace="/\n\n/\n/g"?>
    ```dart tag=good
    class IterableBase<E> {}
    class List<E> {}
    class HashSet<E> {}
    class RedBlackTree<E> {}
    ```

*   `K` e `V` para os tipos de **chave** e **valor** em uma coleção
    associativa:

    <?code-excerpt "design_good.dart (type-parameter-k-v)" replace="/\n\n/\n/g"?>
    ```dart tag=good
    class Map<K, V> {}
    class Multimap<K, V> {}
    class MapEntry<K, V> {}
    ```

*   `R` para um tipo usado como tipo de **retorno** de uma função ou dos
    métodos de uma classe. Isso não é comum, mas aparece em typedefs às vezes e em classes
    que implementam o padrão visitor:

    <?code-excerpt "design_good.dart (type-parameter-r)"?>
    ```dart tag=good
    abstract class ExpressionVisitor<R> {
      R visitBinary(BinaryExpression node);
      R visitLiteral(LiteralExpression node);
      R visitUnary(UnaryExpression node);
    }
    ```

*   Caso contrário, use `T`, `S`, e `U` para genéricos que têm um único parâmetro de tipo
    e onde o tipo envolvente torna seu significado óbvio. Existem
    múltiplas letras aqui para permitir aninhamento sem sombrear um
    nome envolvente. Por exemplo:

    <?code-excerpt "design_good.dart (type-parameter-t)"?>
    ```dart tag=good
    class Future<T> {
      Future<S> then<S>(FutureOr<S> onValue(T value)) => ...
    }
    ```

    Aqui, o método genérico `then<S>()` usa `S` para evitar sombrear o `T`
    em `Future<T>`.

Se nenhum dos casos acima for um bom ajuste, então outro nome mnemônico de uma única letra
ou um nome descritivo está bom:

<?code-excerpt "design_good.dart (type-parameter-graph)"?>
```dart tag=good
class Graph<N, E> {
  final List<N> nodes = [];
  final List<E> edges = [];
}

class Graph<Node, Edge> {
  final List<Node> nodes = [];
  final List<Edge> edges = [];
}
```

Na prática, as convenções existentes cobrem a maioria dos parâmetros de tipo.

## Libraries

Um caractere de sublinhado inicial ( `_` ) indica que um membro é privado à sua
biblioteca. Isso não é mera convenção, mas está embutido na própria linguagem.

### PREFIRA tornar declarações privadas

Uma declaração pública em uma biblioteca—seja de nível superior ou em uma classe—é
um sinal de que outras bibliotecas podem e devem acessar esse membro. Também é um
compromisso da parte da sua biblioteca de suportar isso e se comportar adequadamente quando isso
acontece.

Se isso não é o que você pretende, adicione o pequeno `_` e seja feliz. Interfaces públicas estreitas
são mais fáceis para você manter e mais fáceis para os usuários aprenderem. Como um
bônus agradável, o analisador lhe dirá sobre declarações privadas não usadas para que você
possa deletar código morto. Ele não pode fazer isso se o membro é público porque não
sabe se algum código fora de sua visão está usando.


### CONSIDERE declarar múltiplas classes na mesma biblioteca

Algumas linguagens, como Java, amarram a organização de arquivos à organização de
classes—cada arquivo pode definir apenas uma única classe de nível superior. Dart não
tem essa limitação. Bibliotecas são entidades distintas separadas de classes.
É perfeitamente válido para uma única biblioteca conter múltiplas classes, variáveis de nível superior,
e funções se todas pertencem logicamente juntas.

Colocar múltiplas classes juntas em uma biblioteca pode habilitar alguns padrões
úteis. Como a privacidade em Dart funciona no nível da biblioteca, não no nível da classe,
esta é uma forma de definir classes "amigas" como você poderia fazer em C++. Toda classe
declarada na mesma biblioteca pode acessar membros privados uma da outra, mas código
fora dessa biblioteca não pode.

É claro que esta diretriz não significa que você *deveria* colocar todas as suas classes em
uma biblioteca monolítica enorme, apenas que você está autorizado a colocar mais de uma
classe em uma única biblioteca.


## Classes and mixins

Dart é uma linguagem "pura" orientada a objetos no sentido de que todos os objetos são instâncias de
classes. Mas Dart não requer que todo código seja definido dentro de uma
classe—você pode definir variáveis de nível superior, constantes, e funções como
você pode em uma linguagem procedural ou funcional.

### EVITE definir uma classe abstrata de um membro quando uma função simples serve

{% render 'linter-rule-mention.md', rules:'one_member_abstracts' %}

Diferente de Java, Dart tem funções de primeira classe, closures, e uma sintaxe leve agradável
para usá-las. Se tudo que você precisa é algo como um callback, apenas use uma
função. Se você está definindo uma classe e ela só tem um único membro abstrato
com um nome sem significado como `call` ou `invoke`, há uma boa chance de que você
apenas quer uma função.

<?code-excerpt "design_good.dart (one-member-abstract-class)"?>
```dart tag=good
typedef Predicate<E> = bool Function(E element);
```

<?code-excerpt "design_bad.dart (one-member-abstract-class)"?>
```dart tag=bad
abstract class Predicate<E> {
  bool test(E element);
}
```


### EVITE definir uma classe que contém apenas membros estáticos

{% render 'linter-rule-mention.md', rules:'avoid_classes_with_only_static_members' %}

Em Java e C#, toda definição *deve* estar dentro de uma classe, então é comum ver
"classes" que existem apenas como um lugar para colocar membros estáticos. Outras classes são
usadas como namespaces—uma forma de dar um prefixo compartilhado a um monte de membros para
relacioná-los uns aos outros ou evitar uma colisão de nomes.

Dart tem funções de nível superior, variáveis, e constantes, então você não *precisa* de uma
classe apenas para definir algo. Se o que você quer é um namespace, uma biblioteca é
melhor ajuste. Bibliotecas suportam prefixos de importação e combinadores show/hide. Essas
são ferramentas poderosas que permitem ao consumidor do seu código lidar com colisões de nomes da
forma que funciona melhor para *eles*.

Se uma função ou variável não está logicamente ligada a uma classe, coloque-a no nível
superior. Se você está preocupado com colisões de nomes, dê a ela um nome mais preciso ou
mova-a para uma biblioteca separada que pode ser importada com um prefixo.

<?code-excerpt "design_good.dart (class-only-static)"?>
```dart tag=good
DateTime mostRecent(List<DateTime> dates) {
  return dates.reduce((a, b) => a.isAfter(b) ? a : b);
}

const _favoriteMammal = 'weasel';
```

<?code-excerpt "design_bad.dart (class-only-static)"?>
```dart tag=bad
class DateUtils {
  static DateTime mostRecent(List<DateTime> dates) {
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

class _Favorites {
  static const mammal = 'weasel';
}
```

Em Dart idiomático, classes definem *tipos de objetos*. Um tipo que nunca é
instanciado é um code smell.

No entanto, esta não é uma regra rígida. Por exemplo, com constantes e tipos similares a enum,
pode ser natural agrupá-los em uma classe.

<?code-excerpt "design_bad.dart (class-only-static-exception)"?>
```dart tag=good
class Color {
  static const red = '#f00';
  static const green = '#0f0';
  static const blue = '#00f';
  static const black = '#000';
  static const white = '#fff';
}
```


### EVITE estender uma classe que não é destinada a ser subclasse

Se um construtor é mudado de um construtor gerativo para um construtor de fábrica,
qualquer construtor de subclasse chamando esse construtor vai quebrar.
Além disso, se uma classe muda quais dos seus próprios métodos ela invoca em `this`, isso
pode quebrar subclasses que sobrescrevem esses métodos e esperam que sejam chamados
em certos pontos.

Ambos significam que uma classe precisa ser deliberada sobre se quer ou não
permitir subclasses. Isso pode ser comunicado em um comentário de documentação, ou
dando à classe um nome óbvio como `IterableBase`. Se o autor da classe
não faz isso, é melhor assumir que você *não* deve estender a classe.
Caso contrário, mudanças posteriores podem quebrar seu código.

<a id="do-document-if-your-class-supports-being-extended" aria-hidden="true"></a>

### FAÇA use modificadores de classe para controlar se sua classe pode ser estendida

Modificadores de classe como `final`, `interface`, ou `sealed`
restringem como uma classe pode ser estendida.
Por exemplo, use `final class A {}` ou `interface class B {}` para prevenir
extensão fora da biblioteca atual.
Use esses modificadores para comunicar sua intenção, em vez de depender de documentação.

### EVITE implementar uma classe que não é destinada a ser uma interface

Interfaces implícitas são uma ferramenta poderosa em Dart para evitar ter que repetir o
contrato de uma classe quando ele pode ser trivialmente inferido das assinaturas de uma
implementação desse contrato.

Mas implementar a interface de uma classe é um acoplamento muito apertado a essa classe. Isso
significa que virtualmente *qualquer* mudança na classe cuja interface você está implementando
vai quebrar sua implementação. Por exemplo, adicionar um novo membro a uma classe é
geralmente uma mudança segura, não-quebradora. Mas se você está implementando a interface dessa classe,
agora sua classe tem um erro estático porque falta uma implementação
desse novo método.

Mantenedores de biblioteca precisam da habilidade de evoluir classes existentes sem quebrar
usuários. Se você trata toda classe como se ela expusesse uma interface que usuários são livres
para implementar, então mudar essas classes se torna muito difícil. Essa
dificuldade por sua vez significa que as bibliotecas das quais você depende são mais lentas para crescer e se adaptar
a novas necessidades.

Para dar aos autores das classes que você usa mais margem, evite implementar
interfaces implícitas exceto para classes que são claramente destinadas a serem
implementadas. Caso contrário, você pode introduzir um acoplamento que o autor não
pretende, e eles podem quebrar seu código sem perceber.

<a id="do-document-if-your-class-supports-being-used-as-an-interface" aria-hidden="true"></a>

### FAÇA use modificadores de classe para controlar se sua classe pode ser uma interface

Ao projetar uma biblioteca, use modificadores de classe como `final`, `base`, ou `sealed` para impor o uso
pretendido. Por exemplo, use `final class C {}` ou `base class D {}` para prevenir
implementação fora da biblioteca atual.
Embora seja ideal que todas as bibliotecas usem esses modificadores para impor a intenção do design,
desenvolvedores ainda podem encontrar casos onde eles não são aplicados. Nesses casos, tenha cuidado com
problemas de implementação não intencionais.

<a id="do-use-mixin-to-define-a-mixin-type" aria-hidden="true"></a>
<a id="avoid-mixing-in-a-class-that-isnt-intended-to-be-a-mixin" aria-hidden="true"></a>

### PREFIRA definir um `mixin` puro ou `class` pura a um `mixin class`

{% render 'linter-rule-mention.md', rules:'prefer_mixin' %}

Dart anteriormente (versão de linguagem [2.12](/resources/language/evolution#dart-2-12)
a [2.19](/resources/language/evolution#dart-2-19)) permitia que qualquer classe que
atendesse certas restrições (sem construtor não-padrão, sem superclasse, etc.)
fosse misturada em outras classes.
Isso era confuso porque o autor da classe
pode não ter pretendido que ela fosse misturada.

Dart 3.0.0 agora requer que qualquer tipo destinado a ser misturado em outras classes,
bem como tratado como uma classe normal, deve ser explicitamente declarado como tal com
a declaração `mixin class`.

Tipos que precisam ser ambos um mixin e uma classe devem ser um caso raro, no entanto.
A declaração `mixin class` é principalmente destinada a ajudar migrar classes pré-3.0.0
sendo usadas como mixins para uma declaração mais explícita. Novo código deve claramente
definir o comportamento e intenção de suas declarações usando apenas declarações `mixin` puras
ou `class` puras, e evitar a ambiguidade de mixin classes.

Leia [Migrando classes como mixins](/language/class-modifiers-for-apis#migrating-classes-as-mixins)
para mais orientação sobre declarações `mixin` e `mixin class`.

## Constructors

Construtores Dart são criados declarando uma função com o mesmo nome da
classe e, opcionalmente, um identificador adicional. Os últimos são chamados *construtores
nomeados*.


### CONSIDERE tornar seu construtor `const` se a classe suporta isso

Se você tem uma classe onde todos os campos são final, e o construtor não faz
nada além de inicializá-los, você pode tornar esse construtor `const`. Isso permite que
usuários criem instâncias da sua classe em lugares onde constantes são
necessárias—dentro de outras constantes maiores, casos de switch, valores de parâmetros padrão,
etc.

Se você não explicitamente torná-lo `const`, eles não são capazes de fazer isso.

Note, no entanto, que um construtor `const` é um compromisso em sua API pública. Se
você mais tarde mudar o construtor para não-`const`, isso vai quebrar usuários que estão
chamando-o em expressões constantes. Se você não quer se comprometer com isso, não
torne-o `const`. Na prática, construtores `const` são mais úteis para tipos
simples, imutáveis e similares a valores.


## Members

Um membro pertence a um objeto e pode ser métodos ou variáveis de instância.

### PREFIRA tornar campos e variáveis de nível superior `final`

{% render 'linter-rule-mention.md', rules:'prefer_final_fields' %}

Estado que não é *mutável*—que não muda ao longo do tempo—é
mais fácil para programadores raciocinarem. Classes e bibliotecas que minimizam a
quantidade de estado mutável com que trabalham tendem a ser mais fáceis de manter.
É claro, é frequentemente útil ter dados mutáveis. Mas, se você não precisa disso,
seu padrão deveria ser tornar campos e variáveis de nível superior `final` quando
puder.

Às vezes um campo de instância não muda depois de ter sido inicializado, mas
não pode ser inicializado até depois que a instância é construída. Por exemplo, pode
precisar referenciar `this` ou algum outro campo na instância. Em casos como
esse, considere tornar o campo `late final`. Quando você faz isso, também pode ser capaz
de [inicializar o campo em sua declaração][init at decl].

[init at decl]: /effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible

### FAÇA use getters para operações que conceitualmente acessam propriedades

Decidir quando um membro deveria ser um getter versus um método é uma parte sutil mas
importante do bom design de API, daí esta diretriz muito longa.
Culturas de algumas outras linguagens evitam getters. Elas apenas os usam quando
a operação é quase exatamente como um campo—faz uma quantidade minúscula de
cálculo em estado que vive inteiramente no objeto. Qualquer coisa mais complexa ou
pesada do que isso recebe `()` após o nome para sinalizar "computação acontecendo
aqui!" porque um nome simples após um `.` significa "campo".

Dart *não* é assim. Em Dart, *todos* os nomes com ponto são invocações de membros que
podem fazer computação. Campos são especiais—são getters cuja
implementação é fornecida pela linguagem. Em outras palavras, getters não são
"campos particularmente lentos" em Dart; campos são "getters particularmente rápidos".

Mesmo assim, escolher um getter em vez de um método envia um sinal importante ao
chamador. O sinal, grosso modo, é que a operação é "similar a campo". A
operação, pelo menos em princípio, *poderia* ser implementada usando um campo, até onde
o chamador sabe. Isso implica:

*   **A operação não aceita argumentos e retorna um resultado.**

*   **O chamador se importa principalmente com o resultado.** Se você quer que o chamador
    se preocupe sobre *como* a operação produz seu resultado mais do que com
    o resultado sendo produzido, então dê à operação um nome de verbo que descreve
    o trabalho e torne-a um método.

    Isso *não* significa que a operação tem que ser particularmente rápida para
    ser um getter. `IterableBase.length` é `O(n)`, e está OK. É válido para um
    getter fazer cálculo significativo. Mas se ele faz uma quantidade *surpreendente*
    de trabalho, você pode querer chamar a atenção deles para isso fazendo-o um método
    cujo nome é um verbo descrevendo o que ele faz.

    ```dart tag=bad
    connection.nextIncomingMessage; // Does network I/O.
    expression.normalForm; // Could be exponential to calculate.
    ```

*   **A operação não tem efeitos colaterais visíveis ao usuário.** Acessar um campo real
    não altera o objeto ou qualquer outro estado no programa. Não
    produz saída, escreve arquivos, etc. Um getter não deveria fazer essas coisas
    também.

    A parte "visível ao usuário" é importante. É válido para getters modificar estado
    oculto ou produzir efeitos colaterais fora de banda. Getters podem calcular preguiçosamente e
    armazenar seu resultado, escrever em um cache, registrar coisas, etc. Contanto que o chamador
    não se *importe* sobre o efeito colateral, provavelmente está bem.

    ```dart tag=bad
    stdout.newline; // Produces output.
    list.clear; // Modifies object.
    ```

*   **A operação é *idempotente*.** "Idempotente" é uma palavra estranha que, neste
    contexto, basicamente significa que chamar a operação múltiplas vezes produz
    o mesmo resultado cada vez, a menos que algum estado seja explicitamente modificado entre
    essas chamadas. (Obviamente, `list.length` produz resultados diferentes se você adicionar
    um elemento à lista entre chamadas.)

    "Mesmo resultado" aqui não significa que um getter deve literalmente produzir um
    objeto idêntico em chamadas sucessivas. Exigir isso forçaria muitos
    getters a terem cache frágil, o que nega todo o ponto de usar um
    getter. É comum, e perfeitamente válido, para um getter retornar um novo future
    ou lista cada vez que você o chama. A parte importante é que o future
    completa para o mesmo valor, e a lista contém os mesmos elementos.

    Em outras palavras, o valor do resultado deve ser o mesmo *nos aspectos que o
    chamador se importa.*

    ```dart tag=bad
    DateTime.now; // New result each time.
    ```

*   **O objeto resultante não expõe todo o estado do objeto original.**
    Um campo expõe apenas um pedaço de um objeto. Se sua operação retorna um
    resultado que expõe todo o estado do objeto original, provavelmente é melhor
    como um método [`to___()`][to] ou [`as___()`][as].

[to]: #prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object
[as]: #prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object

Se todos os itens acima descrevem sua operação, ela deveria ser um getter. Parece
que poucos membros sobreviveriam a esse desafio, mas surpreendentemente muitos sobrevivem. Muitas
operações apenas fazem alguma computação em algum estado e a maioria dessas podem e
deveriam ser getters.

```dart tag=good
rectangle.area;
collection.isEmpty;
button.canShow;
dataSet.minimumValue;
```


### FAÇA use setters para operações que conceitualmente mudam propriedades

{% render 'linter-rule-mention.md', rules:'use_setters_to_change_properties' %}

Decidir entre um setter versus um método é similar a decidir entre um
getter versus um método. Em ambos os casos, a operação deveria ser "similar a campo".

Para um setter, "similar a campo" significa:

*   **A operação aceita um único argumento e não produz um valor de
    resultado.**

*   **A operação muda algum estado no objeto.**

*   **A operação é idempotente.** Chamar o mesmo setter duas vezes com o mesmo
    valor não deveria fazer nada na segunda vez até onde o chamador está preocupado.
    Internamente, talvez você tenha alguma invalidação de cache ou logging acontecendo.
    Isso está bem. Mas da perspectiva do chamador, parece que a segunda
    chamada não faz nada.

```dart tag=good
rectangle.width = 3;
button.visible = false;
```


### NÃO defina um setter sem um getter correspondente

{% render 'linter-rule-mention.md', rules:'avoid_setters_without_getters' %}

Usuários pensam em getters e setters como propriedades visíveis de um objeto. Uma
propriedade "caixa de entrega" que pode ser escrita mas não vista é confusa e
confunde sua intuição sobre como propriedades funcionam. Por exemplo, um setter
sem um getter significa que você pode usar `=` para modificá-lo, mas não `+=`.

Esta diretriz *não* significa que você deveria adicionar um getter apenas para permitir o setter
que você quer adicionar. Objetos geralmente não deveriam expor mais estado do que precisam.
Se você tem algum pedaço do estado de um objeto que pode ser modificado mas não
exposto da mesma forma, use um método em vez disso.


### EVITE usar testes de tipo em tempo de execução para falsificar sobrecarga

É comum para uma API suportar operações similares
em diferentes tipos de parâmetros.
Para enfatizar a similaridade, algumas linguagens suportam *sobrecarga*,
que permite que você defina múltiplos métodos
que têm o mesmo nome mas listas de parâmetros diferentes.
Em tempo de compilação, o compilador olha os tipos de argumentos reais para determinar
qual método chamar.

Dart não tem sobrecarga.
Você pode definir uma API que parece sobrecarga
definindo um único método e então usando testes de tipo `is`
dentro do corpo para olhar os tipos em tempo de execução dos argumentos e realizar o
comportamento apropriado.
No entanto, falsificar sobrecarga dessa forma transforma uma seleção de método em *tempo de compilação*
em uma escolha que acontece em *tempo de execução*.

Se chamadores geralmente sabem qual tipo eles têm
e qual operação específica eles querem,
é melhor definir métodos separados com nomes diferentes
para permitir que chamadores selecionem a operação certa.
Isso dá melhor verificação de tipo estática e desempenho mais rápido
já que evita quaisquer testes de tipo em tempo de execução.

No entanto, se usuários podem ter um objeto de um tipo desconhecido
e *querem* que a API internamente use `is` para escolher a operação certa,
então um único método onde o parâmetro é um supertipo
de todos os tipos suportados pode ser razoável.


### EVITE campos `late final` públicos sem inicializadores

Diferente de outros campos `final`, um campo `late final` sem inicializador *realmente*
define um setter. Se esse campo é público, então o setter é público. Isso é
raramente o que você quer. Campos são geralmente marcados `late` para que possam ser
inicializados *internamente* em algum ponto no tempo de vida da instância, frequentemente dentro
do corpo do construtor.

A menos que você *realmente* queira que usuários chamem o setter, é melhor escolher uma das
seguintes soluções:

* Não use `late`.
* Use um construtor de fábrica para computar os valores dos campos `final`.
* Use `late`, mas inicialize o campo `late` em sua declaração.
* Use `late`, mas torne o campo `late` privado e defina um getter público para ele.


### EVITE retornar tipos `Future`, `Stream`, e coleção anuláveis

Quando uma API retorna um tipo contêiner, ela tem duas formas de indicar a ausência de
dados: Pode retornar um contêiner vazio ou pode retornar `null`. Usuários geralmente
assumem e preferem que você use um contêiner vazio para indicar "sem dados". Dessa
forma, eles têm um objeto real no qual podem chamar métodos como `isEmpty`.

Para indicar que sua API não tem dados para fornecer, prefira retornar uma coleção
vazia, um future não-anulável de um tipo anulável, ou um stream que não
emite quaisquer valores.

**Exceção:** Se retornar `null` *significa algo diferente* de produzir um
contêiner vazio, pode fazer sentido usar um tipo anulável.


### EVITE retornar `this` de métodos apenas para habilitar uma interface fluente

{% render 'linter-rule-mention.md', rules:'avoid_returning_this' %}

Cascatas de métodos são uma solução melhor para encadear chamadas de métodos.

<?code-excerpt "design_good.dart (cascades)"?>
```dart tag=good
var buffer =
    StringBuffer()
      ..write('one')
      ..write('two')
      ..write('three');
```

<?code-excerpt "design_bad.dart (cascades)"?>
```dart tag=bad
var buffer =
    StringBuffer()
        .write('one')
        .write('two')
        .write('three');
```


## Types

Quando você escreve um tipo em seu programa, você restringe os tipos de valores
que fluem para diferentes partes do seu código. Tipos podem aparecer em dois tipos de
lugares: *anotações de tipo* em declarações e argumentos de tipo para *invocações
genéricas*.

Anotações de tipo são o que você normalmente pensa quando pensa em "tipos
estáticos". Você pode anotar o tipo de uma variável, parâmetro, campo, ou tipo de retorno. No
exemplo a seguir, `bool` e `String` são anotações de tipo. Elas ficam penduradas na
estrutura declarativa estática do código e não são "executadas" em tempo de execução.

<?code-excerpt "design_good.dart (annotate-declaration)"?>
```dart
bool isEmpty(String parameter) {
  bool result = parameter.isEmpty;
  return result;
}
```

Uma invocação genérica é um literal de coleção, uma chamada ao construtor
de uma classe genérica, ou uma invocação de um método genérico. No próximo exemplo, `num`
e `int` são argumentos de tipo em invocações genéricas. Embora sejam tipos,
eles são entidades de primeira classe que são reificadas e passadas para a invocação em
tempo de execução.

<?code-excerpt "design_good.dart (annotate-invocation)"?>
```dart
var lists = <num>[1, 2];
lists.addAll(List<num>.filled(3, 4));
lists.cast<int>();
```

Enfatizamos a parte "invocação genérica" aqui, porque argumentos de tipo *também* podem
aparecer em anotações de tipo:

<?code-excerpt "design_good.dart (annotate-type-arg)"?>
```dart
List<int> ints = [1, 2];
```

Aqui, `int` é um argumento de tipo, mas ele aparece dentro de uma anotação de tipo, não em uma
invocação genérica. Você geralmente não precisa se preocupar com essa distinção, mas
em alguns lugares, temos orientação diferente para quando um tipo é usado em uma
invocação genérica em oposição a uma anotação de tipo.

#### Type inference

Anotações de tipo são opcionais em Dart.
Se você omitir uma, Dart tenta inferir um tipo
baseado no contexto próximo. Às vezes não tem informação suficiente para
inferir um tipo completo. Quando isso acontece, Dart às vezes reporta um erro, mas
geralmente silenciosamente preenche quaisquer partes faltantes com `dynamic`. O
`dynamic` implícito leva a código que *parece* inferido e seguro, mas na verdade desabilita
a verificação de tipo completamente. As regras abaixo evitam isso exigindo tipos quando
a inferência falha.

O fato de que Dart tem tanto inferência de tipo quanto um tipo `dynamic` leva a alguma
confusão sobre o que significa dizer que código é "sem tipo". Isso significa que o código
é dinamicamente tipado, ou que você não *escreveu* o tipo? Para evitar essa
confusão, evitamos dizer "sem tipo" e em vez disso usamos a seguinte terminologia:

*   Se o código é *anotado com tipo*, o tipo foi explicitamente escrito no
    código.

*   Se o código é *inferido*, nenhuma anotação de tipo foi escrita, e Dart
    descobriu com sucesso o tipo por conta própria. A inferência pode falhar, caso em que
    as diretrizes não consideram isso como inferido.

*   Se o código é *dynamic*, então seu tipo estático é o tipo especial `dynamic`.
    O código pode ser explicitamente anotado como `dynamic` ou pode ser inferido.

Em outras palavras, se algum código é anotado ou inferido é ortogonal a
se ele é `dynamic` ou algum outro tipo.

Inferência é uma ferramenta poderosa para poupá-lo do esforço de escrever e ler
tipos que são óbvios ou desinteressantes. Ela mantém a atenção do leitor focada
no comportamento do próprio código. Tipos explícitos também são uma parte chave de
código robusto e fácil de manter. Eles definem a forma estática de uma API e criam
limites para documentar e impor quais tipos de valores são permitidos alcançar
diferentes partes do programa.

É claro, inferência não é mágica. Às vezes a inferência tem sucesso e seleciona um
tipo, mas não é o tipo que você quer. O caso comum é inferir um tipo excessivamente
preciso do inicializador de uma variável quando você pretende atribuir valores de
outros tipos à variável mais tarde. Nesses casos, você tem que escrever o tipo
explicitamente.

As diretrizes aqui atingem o melhor equilíbrio que encontramos entre brevidade e
controle, flexibilidade e segurança. Há diretrizes específicas para cobrir todos os
vários casos, mas o resumo aproximado é:

*   Anote quando a inferência não tem contexto suficiente, mesmo quando `dynamic`
    é o tipo que você quer.

*   Não anote locais e invocações genéricas a menos que você precise.

*   Prefira anotar variáveis de nível superior e campos a menos que o inicializador
    torne o tipo óbvio.


### FAÇA anote o tipo de variáveis sem inicializadores

{% render 'linter-rule-mention.md', rules:'prefer_typing_uninitialized_variables' %}

O tipo de uma variável—de nível superior, local, campo estático, ou campo de
instância—pode frequentemente ser inferido do seu inicializador. No entanto, se não há
inicializador, a inferência falha.

<?code-excerpt "design_good.dart (uninitialized-local)"?>
```dart tag=good
List<AstNode> parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
```

<?code-excerpt "design_bad.dart (uninitialized-local)"?>
```dart tag=bad
var parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
```


### FAÇA anote o tipo de campos e variáveis de nível superior se o tipo não é óbvio

{% render 'linter-rule-mention.md', rules:'type_annotate_public_apis' %}

Anotações de tipo são documentação importante para como uma biblioteca deveria ser usada.
Elas formam limites entre regiões de um programa para isolar a fonte de um
erro de tipo. Considere:

<?code-excerpt "design_bad.dart (type_annotate_public_apis)"?>
```dart tag=bad
install(id, destination) => ...
```

Aqui, não está claro o que `id` é. Uma string? E o que é `destination`? Uma string
ou um objeto `File`? Este método é síncrono ou assíncrono? Isso é mais claro:

<?code-excerpt "design_good.dart (type_annotate_public_apis)"?>
```dart tag=good
Future<bool> install(PackageId id, String destination) => ...
```

Em alguns casos, porém, o tipo é tão óbvio que escrevê-lo é inútil:

<?code-excerpt "design_good.dart (inferred)"?>
```dart tag=good
const screenWidth = 640; // Inferred as int.
```

"Óbvio" não está precisamente definido, mas esses são todos bons candidatos:

* Literais.
* Invocações de construtor.
* Referências a outras constantes que são explicitamente tipadas.
* Expressões simples em números e strings.
* Métodos de fábrica como `int.parse()`, `Future.wait()`, etc. que leitores são
  esperados a estarem familiarizados.

Se você acha que a expressão inicializadora—seja o que for—é
suficientemente clara, então você pode omitir a anotação. Mas se você acha que
anotar ajuda a tornar o código mais claro, então adicione uma.

Na dúvida, adicione uma anotação de tipo. Mesmo quando um tipo é óbvio, você ainda pode
desejar anotar explicitamente. Se o tipo inferido depende de valores ou
declarações de outras bibliotecas, você pode querer anotar o tipo da *sua*
declaração para que uma mudança nessa outra biblioteca não mude silenciosamente o
tipo da sua própria API sem você perceber.

Esta regra se aplica tanto a declarações públicas quanto privadas. Assim como anotações de tipo
em APIs ajudam *usuários* do seu código, tipos em membros privados ajudam
*mantenedores*.


### NÃO anote redundantemente o tipo de variáveis locais inicializadas

{% render 'linter-rule-mention.md', rules:'omit_local_variable_types' %}

Variáveis locais, especialmente em código moderno onde funções tendem a ser pequenas,
têm escopo muito pequeno. Omitir o tipo foca a atenção do leitor no
*nome* mais importante da variável e seu valor inicializado.

<?code-excerpt "design_good.dart (omit-types-on-locals)"?>
```dart tag=good
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  var desserts = <List<Ingredient>>[];
  for (final recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
```

<?code-excerpt "design_bad.dart (omit-types-on-locals)"?>
```dart tag=bad
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  List<List<Ingredient>> desserts = <List<Ingredient>>[];
  for (final List<Ingredient> recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
```

Às vezes o tipo inferido não é o tipo que você quer que a variável tenha. Por
exemplo, você pode pretender atribuir valores de outros tipos mais tarde. Nesse caso,
anote a variável com o tipo que você quer.

<?code-excerpt "design_good.dart (upcast-local)" replace="/Widget result/[!Widget!] result/g"?>
```dart tag=good
Widget build(BuildContext context) {
  [!Widget!] result = Text('You won!');
  if (applyPadding) {
    result = Padding(padding: EdgeInsets.all(8.0), child: result);
  }
  return result;
}
```


### FAÇA anote tipos de retorno em declarações de função

Dart geralmente não infere o tipo de retorno de uma declaração de função do seu corpo,
diferente de algumas outras linguagens. Isso significa que você deve escrever uma anotação de tipo para
o tipo de retorno você mesmo.

<?code-excerpt "design_good.dart (annotate-return-types)"?>
```dart tag=good
String makeGreeting(String who) {
  return 'Hello, $who!';
}
```

<?code-excerpt "design_bad.dart (annotate-return-types)"?>
```dart tag=bad
makeGreeting(String who) {
  return 'Hello, $who!';
}
```

Note que esta diretriz apenas se aplica a declarações de função *não-locais*:
métodos e getters de nível superior, estáticos e de instância. Funções locais e
expressões de função anônimas inferem um tipo de retorno do seu corpo. De fato, a
sintaxe de função anônima nem mesmo permite uma anotação de tipo de retorno.


### FAÇA anote tipos de parâmetros em declarações de função

A lista de parâmetros de uma função determina seu limite para o mundo exterior.
Anotar tipos de parâmetros torna esse limite bem definido.
Note que mesmo que valores de parâmetros padrão pareçam inicializadores de variáveis,
Dart não infere o tipo de um parâmetro opcional do seu valor padrão.

<?code-excerpt "design_good.dart (annotate-parameters)"?>
```dart tag=good
void sayRepeatedly(String message, {int count = 2}) {
  for (var i = 0; i < count; i++) {
    print(message);
  }
}
```

<?code-excerpt "design_bad.dart (annotate-parameters)" replace="/\(count as num\)/count/g"?>
```dart tag=bad
void sayRepeatedly(message, {count = 2}) {
  for (var i = 0; i < count; i++) {
    print(message);
  }
}
```

**Exceção:** Expressões de função e formals inicializadores têm
convenções de anotação de tipo diferentes, como descrito nas próximas duas diretrizes.


### NÃO anote tipos de parâmetros inferidos em expressões de função

{% render 'linter-rule-mention.md', rules:'avoid_types_on_closure_parameters' %}

Funções anônimas são quase sempre imediatamente passadas para um método que aceita um
callback de algum tipo.
Quando uma expressão de função é criada em um contexto tipado,
Dart tenta inferir os tipos de parâmetros da função baseado no tipo esperado.
Por exemplo, quando você passa uma expressão de função para `Iterable.map()`, o
tipo de parâmetro da sua função é inferido baseado no tipo de callback que `map()`
espera:

<?code-excerpt "design_good.dart (func-expr-no-param-type)"?>
```dart tag=good
var names = people.map((person) => person.name);
```

<?code-excerpt "design_bad.dart (func-expr-no-param-type)"?>
```dart tag=bad
var names = people.map((Person person) => person.name);
```

Se a linguagem é capaz de inferir o tipo que você quer para um parâmetro em uma expressão
de função, então não anote. Em casos raros, o contexto
envolvente não é preciso o suficiente para fornecer um tipo para um ou mais dos
parâmetros da função. Nesses casos, você pode precisar anotar.
(Se a função não é usada imediatamente, geralmente é melhor
[torná-la uma declaração nomeada][named local].)

[named local]: usage#do-use-a-function-declaration-to-bind-a-function-to-a-name

### NÃO anote o tipo de formals inicializadores

{% render 'linter-rule-mention.md', rules:'type_init_formals' %}

Se um parâmetro de construtor está usando `this.` para inicializar um campo,
ou `super.` para encaminhar um super parâmetro,
então o tipo do parâmetro
é inferido para ter o mesmo tipo que
o campo ou parâmetro do super-construtor respectivamente.

<?code-excerpt "design_good.dart (dont-type-init-formals)"?>
```dart tag=good
class Point {
  double x, y;
  Point(this.x, this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
}
```

<?code-excerpt "design_bad.dart (dont-type-init-formals)"?>
```dart tag=bad
class Point {
  double x, y;
  Point(double this.x, double this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({Key? super.key});
}
```


### FAÇA escreva argumentos de tipo em invocações genéricas que não são inferidas

Dart é bem inteligente sobre inferir argumentos de tipo em invocações genéricas. Ele
olha o tipo esperado onde a expressão ocorre e os tipos de
valores sendo passados para a invocação. No entanto, às vezes esses não são suficientes para
determinar completamente um argumento de tipo. Nesse caso, escreva a lista inteira de argumentos de tipo
explicitamente.

<?code-excerpt "design_good.dart (non-inferred-type-args)"?>
```dart tag=good
var playerScores = <String, int>{};
final events = StreamController<Event>();
```

<?code-excerpt "design_bad.dart (non-inferred-type-args)"?>
```dart tag=bad
var playerScores = {};
final events = StreamController();
```

Às vezes a invocação ocorre como o inicializador para uma declaração de variável. Se
a variável *não* é local, então em vez de escrever a lista de argumentos de tipo na
própria invocação, você pode colocar uma anotação de tipo na declaração:

<?code-excerpt "design_good.dart (inferred-type-args)"?>
```dart tag=good
class Downloader {
  final Completer<String> response = Completer();
}
```

<?code-excerpt "design_bad.dart (inferred-type-args)"?>
```dart tag=bad
class Downloader {
  final response = Completer();
}
```

Anotar a variável também atende a esta diretriz porque agora os argumentos de tipo
*são* inferidos.


### NÃO escreva argumentos de tipo em invocações genéricas que são inferidas

Esta é a inversa da regra anterior. Se a lista de argumentos de tipo de uma invocação
*é* corretamente inferida com os tipos que você quer, então omita os tipos e deixe
Dart fazer o trabalho para você.

<?code-excerpt "design_good.dart (redundant)"?>
```dart tag=good
class Downloader {
  final Completer<String> response = Completer();
}
```

<?code-excerpt "design_bad.dart (redundant)"?>
```dart tag=bad
class Downloader {
  final Completer<String> response = Completer<String>();
}
```

Aqui, a anotação de tipo no campo fornece um contexto envolvente para inferir
o argumento de tipo da chamada do construtor no inicializador.

<?code-excerpt "design_good.dart (explicit)"?>
```dart tag=good
var items = Future.value([1, 2, 3]);
```

<?code-excerpt "design_bad.dart (explicit)"?>
```dart tag=bad
var items = Future<List<int>>.value(<int>[1, 2, 3]);
```

Aqui, os tipos da coleção e instância podem ser inferidos de baixo para cima dos
seus elementos e argumentos.


### EVITE escrever tipos genéricos incompletos

O objetivo de escrever uma anotação de tipo ou argumento de tipo é fixar um tipo
completo. No entanto, se você escreve o nome de um tipo genérico mas omite seus argumentos de tipo,
você não especificou completamente o tipo. Em Java, esses são chamados "raw
types" (tipos brutos). Por exemplo:

<?code-excerpt "design_bad.dart (incomplete-generic)" replace="/List|Map/[!$&!]/g"?>
```dart tag=bad
[!List!] numbers = [1, 2, 3];
var completer = Completer<[!Map!]>();
```

Aqui, `numbers` tem uma anotação de tipo, mas a anotação não fornece um argumento de tipo
para o `List` genérico. Da mesma forma, o argumento de tipo `Map` para `Completer`
não está completamente especificado. Em casos como este, Dart *não* vai tentar "preencher" o
resto do tipo para você usando o contexto envolvente. Em vez disso, silenciosamente
preenche quaisquer argumentos de tipo faltantes com `dynamic` (ou o limite se a
classe tiver um). Isso raramente é o que você quer.

Em vez disso, se você está escrevendo um tipo genérico seja em uma anotação de tipo ou como um argumento de tipo
dentro de alguma invocação, certifique-se de escrever um tipo completo:

<?code-excerpt "design_good.dart (incomplete-generic)"?>
```dart tag=good
List<num> numbers = [1, 2, 3];
var completer = Completer<Map<String, int>>();
```


### FAÇA anote com `dynamic` em vez de deixar a inferência falhar

Quando a inferência não preenche um tipo, geralmente padrão para `dynamic`. Se
`dynamic` é o tipo que você quer, essa é tecnicamente a forma mais tersa de obter.
No entanto, não é a forma mais *clara*. Um leitor casual do seu código que
vê que uma anotação está faltando não tem como saber se você pretendia que fosse
`dynamic`, esperava que a inferência preenchesse algum outro tipo, ou simplesmente esqueceu de
escrever a anotação.

Quando `dynamic` é o tipo que você quer, escreva isso explicitamente para tornar sua intenção
clara e destacar que este código tem menos segurança estática.

<?code-excerpt "design_good.dart (prefer-dynamic)"?>
```dart tag=good
dynamic mergeJson(dynamic original, dynamic changes) => ...
```

<?code-excerpt "design_bad.dart (prefer-dynamic)"?>
```dart tag=bad
mergeJson(original, changes) => ...
```

Note que está OK omitir o tipo quando Dart *com sucesso* infere `dynamic`.

<?code-excerpt "design_good.dart (infer-dynamic)"?>
```dart tag=good
Map<String, dynamic> readJson() => ...

void printUsers() {
  var json = readJson();
  var users = json['users'];
  print(users);
}
```

Aqui, Dart infere `Map<String, dynamic>` para `json` e então disso infere
`dynamic` para `users`. Está bem deixar `users` sem uma anotação de tipo. A
distinção é um pouco sutil. Está OK permitir que a inferência *propague*
`dynamic` através do seu código de uma anotação de tipo `dynamic` em algum lugar, mas
você não quer que ela injete uma anotação de tipo `dynamic` em um lugar onde seu
código não especificou uma.

:::note
Com o sistema de tipos forte e inferência de tipo do Dart,
usuários esperam que Dart se comporte como uma linguagem estaticamente tipada inferida.
Com esse modelo mental,
é uma surpresa desagradável descobrir que
uma região de código perdeu silenciosamente toda a
segurança e desempenho de tipos estáticos.
:::

**Exceção**: Anotações de tipo em parâmetros não usados (`_`) podem ser omitidas.

### PREFIRA assinaturas em anotações de tipo de função

O identificador `Function` por si só sem qualquer tipo de retorno ou assinatura de
parâmetro refere-se ao tipo especial [Function][]. Este tipo é apenas
marginalmente mais útil do que usar `dynamic`. Se você vai anotar, prefira
um tipo de função completo que inclua os parâmetros e tipo de retorno da
função.

[Function]: {{site.dart-api}}/dart-core/Function-class.html

<?code-excerpt "design_good.dart (avoid-function)" replace="/bool Function(\(.*?\))?/[!$&!]/g"?>
```dart tag=good
bool isValid(String value, [!bool Function(String)!] test) => ...
```

<?code-excerpt "design_bad.dart (avoid-function)" replace="/Function/[!$&!]/g"?>
```dart tag=bad
bool isValid(String value, [!Function!] test) => ...
```

[fn syntax]: #prefer-inline-function-types-over-typedefs

**Exceção:** Às vezes, você quer um tipo que representa a união de múltiplos
tipos de função diferentes. Por exemplo, você pode aceitar uma função que aceita um
parâmetro ou uma função que aceita dois. Como não temos tipos de união, não há
como tipar isso precisamente e você normalmente teria que usar `dynamic`.
`Function` é pelo menos um pouco mais útil do que isso:

<?code-excerpt "design_good.dart (function-arity)" replace="/(void )?Function(\(.*?\))?/[!$&!]/g"?>
```dart tag=good
void handleError([!void Function()!] operation, [!Function!] errorHandler) {
  try {
    operation();
  } catch (err, stack) {
    if (errorHandler is [!Function(Object)!]) {
      errorHandler(err);
    } else if (errorHandler is [!Function(Object, StackTrace)!]) {
      errorHandler(err, stack);
    } else {
      throw ArgumentError('errorHandler has wrong signature.');
    }
  }
}
```


### NÃO especifique um tipo de retorno para um setter

{% render 'linter-rule-mention.md', rules:'avoid_return_types_on_setters' %}

Setters sempre retornam `void` em Dart. Escrever a palavra é inútil.

<?code-excerpt "design_bad.dart (avoid_return_types_on_setters)"?>
```dart tag=bad
void set foo(Foo value) {
   ...
}
```

<?code-excerpt "design_good.dart (avoid_return_types_on_setters)"?>
```dart tag=good
set foo(Foo value) {
   ...
}
```


### NÃO use a sintaxe typedef legada

{% render 'linter-rule-mention.md', rules:'prefer_generic_function_type_aliases' %}

Dart tem duas notações para definir um typedef nomeado para um tipo de função. A
sintaxe original parece:

<?code-excerpt "design_bad.dart (old-typedef)"?>
```dart tag=bad
typedef int Comparison<T>(T a, T b);
```

Essa sintaxe tem alguns problemas:

*   Não há forma de atribuir um nome a um tipo de função *genérico*. No exemplo acima,
    o próprio typedef é genérico. Se você referencia `Comparison` no
    seu código, sem um argumento de tipo, você implicitamente obtém o tipo de função
    `int Function(dynamic, dynamic)`, *não* `int Function<T>(T, T)`. Isso
    não surge na prática frequentemente, mas importa em certos casos extremos.

*   Um único identificador em um parâmetro é interpretado como o *nome* do parâmetro,
    não seu *tipo*. Dado:

    <?code-excerpt "design_bad.dart (typedef-param)"?>
    ```dart tag=bad
    typedef bool TestNumber(num);
    ```

    A maioria dos usuários espera que isso seja um tipo de função que aceita um `num` e retorna
    `bool`. Na verdade é um tipo de função que aceita *qualquer* objeto (`dynamic`)
    e retorna `bool`. O *nome* do parâmetro (que não é usado para nada
    exceto documentação no typedef) é "num". Isso tem sido uma
    fonte de erros de longa data em Dart.

A nova sintaxe parece assim:

<?code-excerpt "design_good.dart (new-typedef)"?>
```dart tag=good
typedef Comparison<T> = int Function(T, T);
```

Se você quer incluir o nome de um parâmetro, você pode fazer isso também:

<?code-excerpt "design_good.dart (new-typedef-param-name)"?>
```dart tag=good
typedef Comparison<T> = int Function(T a, T b);
```

A nova sintaxe pode expressar qualquer coisa que a sintaxe antiga poderia expressar e mais, e
não tem a funcionalidade propensa a erros onde um único identificador é tratado como o
nome do parâmetro em vez de seu tipo. A mesma sintaxe de tipo de função após o
`=` no typedef também é permitida em qualquer lugar que uma anotação de tipo possa aparecer, dando
a nós uma única forma consistente de escrever tipos de função em qualquer lugar em um programa.

A sintaxe typedef antiga ainda é suportada para evitar quebrar código existente, mas
está obsoleta.


### PREFIRA tipos de função inline a typedefs

{% render 'linter-rule-mention.md', rules:'avoid_private_typedef_functions' %}

Em Dart, se você quer usar um tipo de função para um campo, variável, ou
argumento de tipo genérico, você pode definir um typedef para o tipo de função.
No entanto, Dart suporta uma sintaxe de tipo de função inline que
pode ser usada em qualquer lugar que uma anotação de tipo é permitida:

<?code-excerpt "design_good.dart (function-type)"  replace="/(bool|void) Function\(Event\)/[!$&!]/g"?>
```dart tag=good
class FilteredObservable {
  final [!bool Function(Event)!] _predicate;
  final List<[!void Function(Event)!]> _observers;

  FilteredObservable(this._predicate, this._observers);

  [!void Function(Event)!]? notify(Event event) {
    if (!_predicate(event)) return null;

    [!void Function(Event)!]? last;
    for (final observer in _observers) {
      observer(event);
      last = observer;
    }

    return last;
  }
}
```

Ainda pode valer a pena definir um typedef se o tipo de função é particularmente
longo ou frequentemente usado. Mas na maioria dos casos, usuários querem ver o que o tipo de função
realmente é exatamente onde é usado, e a sintaxe de tipo de função lhes dá
essa clareza.


### PREFIRA usar sintaxe de tipo de função para parâmetros

{% render 'linter-rule-mention.md', rules:'use_function_type_syntax_for_parameters' %}

Dart tem uma sintaxe especial ao definir um parâmetro cujo tipo é uma função.
Meio que como em C, você envolve o nome do parâmetro com o tipo de retorno da função
e assinatura de parâmetro:

<?code-excerpt "design_bad.dart (function-type-param)"?>
```dart
Iterable<T> where(bool predicate(T element)) => ...
```

Antes que Dart adicionasse sintaxe de tipo de função, esta era a única forma de dar a um
parâmetro um tipo de função sem definir um typedef. Agora que Dart tem uma
notação geral para tipos de função, você pode usá-la para parâmetros com tipo de função
também:

<?code-excerpt "design_good.dart (function-type-param)"?>
```dart tag=good
Iterable<T> where(bool Function(T) predicate) => ...
```

A nova sintaxe é um pouco mais verbosa, mas é consistente com outros locais
onde você deve usar a nova sintaxe.


### EVITE usar `dynamic` a menos que você queira desabilitar verificação estática

Algumas operações funcionam com qualquer objeto possível. Por exemplo, um método `log()`
poderia aceitar qualquer objeto e chamar `toString()` nele. Dois tipos em Dart permitem todos
os valores: `Object?` e `dynamic`. No entanto, eles transmitem coisas diferentes. Se você
simplesmente quer declarar que permite todos os objetos, use `Object?`. Se você quer
permitir todos os objetos *exceto* `null`, então use `Object`.

O tipo `dynamic` não apenas aceita todos os objetos, mas também permite todas
as *operações*. Qualquer acesso a membro em um valor de tipo `dynamic` é permitido em
tempo de compilação, mas pode falhar e lançar uma exceção em tempo de execução. Se você quer
exatamente essa despacho dinâmico arriscado mas flexível, então `dynamic` é o tipo
certo para usar.

Caso contrário, prefira usar `Object?` ou `Object`. Dependa de verificações `is` e promoção de tipo
para garantir que o tipo em tempo de execução do valor suporta o membro que você quer acessar
antes de acessá-lo.

<?code-excerpt "design_good.dart (object-vs-dynamic)"?>
```dart tag=good
/// Returns a Boolean representation for [arg], which must
/// be a String or bool.
bool convertToBool(Object arg) {
  if (arg is bool) return arg;
  if (arg is String) return arg.toLowerCase() == 'true';
  throw ArgumentError('Cannot convert $arg to a bool.');
}
```

A principal exceção a esta regra é ao trabalhar com APIs existentes que usam
`dynamic`, especialmente dentro de um tipo genérico. Por exemplo, objetos JSON têm tipo
`Map<String, dynamic>` e seu código precisará aceitar esse mesmo tipo. Mesmo
assim, ao usar um valor de uma dessas APIs, frequentemente é uma boa ideia convertê-lo
para um tipo mais preciso antes de acessar membros.


### FAÇA use `Future<void>` como tipo de retorno de membros assíncronos que não produzem valores

Quando você tem uma função síncrona que não retorna um valor, você usa `void`
como tipo de retorno. O equivalente assíncrono para um método que não
produz um valor, mas que o chamador pode precisar aguardar, é `Future<void>`.

Você pode ver código que usa `Future` ou `Future<Null>` em vez disso porque versões antigas
do Dart não permitiam `void` como argumento de tipo. Agora que permite, você
deveria usá-lo. Fazer isso corresponde mais diretamente a como você tiparia uma função
síncrona similar, e lhe dá melhor verificação de erros para chamadores e no
corpo da função.

Para funções assíncronas que não retornam um valor útil e onde nenhum
chamador precisa aguardar o trabalho assíncrono ou lidar com uma falha assíncrona,
use um tipo de retorno de `void`.


### EVITE usar `FutureOr<T>` como tipo de retorno

Se um método aceita um `FutureOr<int>`, ele é [generoso no que
aceita][postel]. Usuários podem chamar o método com um `int` ou um
`Future<int>`, então eles não precisam envolver um `int` em `Future` que você vai
desembrulhar de qualquer forma.

[postel]: https://en.wikipedia.org/wiki/Robustness_principle

Se você *retorna* um `FutureOr<int>`, usuários precisam verificar se recebem de volta um `int`
ou um `Future<int>` antes que possam fazer qualquer coisa útil. (Ou eles simplesmente vão `await`
o valor, efetivamente sempre tratando-o como um `Future`.) Apenas retorne um
`Future<int>`, é mais limpo. É mais fácil para usuários entenderem que uma função
é sempre assíncrona ou sempre síncrona, mas uma função que pode ser
ambas é difícil de usar corretamente.

<?code-excerpt "design_good.dart (future-or)"?>
```dart tag=good
Future<int> triple(FutureOr<int> value) async => (await value) * 3;
```

<?code-excerpt "design_bad.dart (future-or)"?>
```dart tag=bad
FutureOr<int> triple(FutureOr<int> value) {
  if (value is int) return value * 3;
  return value.then((v) => v * 3);
}
```

A formulação mais precisa desta diretriz é *apenas usar `FutureOr<T>` em
posições [contravariantes][contravariant]*. Parâmetros são contravariantes e tipos de retorno são
covariantes. Em tipos de função aninhados, isso é invertido—se você tem um
parâmetro cujo tipo é em si uma função, então o tipo de retorno do callback está
agora em posição contravariante e os parâmetros do callback são covariantes. Isso
significa que está OK para o tipo de um *callback* retornar `FutureOr<T>`:

[contravariant]: https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)

<?code-excerpt "design_good.dart (future-or-contra)" replace="/FutureOr.S./[!$&!]/g"?>
```dart tag=good
Stream<S> asyncMap<T, S>(
  Iterable<T> iterable,
  [!FutureOr<S>!] Function(T) callback,
) async* {
  for (final element in iterable) {
    yield await callback(element);
  }
}
```


## Parameters

Em Dart, parâmetros opcionais podem ser posicionais ou nomeados, mas não ambos.


### EVITE parâmetros booleanos posicionais

{% render 'linter-rule-mention.md', rules:'avoid_positional_boolean_parameters' %}

Diferente de outros tipos, booleanos são geralmente usados em forma literal. Valores como
números são geralmente envoltos em constantes nomeadas, mas tipicamente passamos
`true` e `false` diretamente. Isso pode tornar locais de chamada ilegíveis se não está
claro o que o booleano representa:

```dart tag=bad
new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
```

Em vez disso, prefira usar argumentos nomeados, construtores nomeados, ou constantes nomeadas
para clarificar o que a chamada está fazendo.

<?code-excerpt "design_good.dart (avoid-positional-bool-param)"?>
```dart tag=good
Task.oneShot();
Task.repeating();
ListBox(scroll: true, showScrollbars: true);
Button(ButtonState.enabled);
```

Note que isso não se aplica a setters, onde o nome torna claro o que o
valor representa:

```dart tag=good
listBox.canScroll = true;
button.isEnabled = false;
```


### EVITE parâmetros posicionais opcionais se o usuário pode querer omitir parâmetros anteriores

Parâmetros posicionais opcionais devem ter uma progressão lógica de tal forma que
parâmetros anteriores sejam passados mais frequentemente do que os posteriores. Usuários quase nunca
devem precisar passar explicitamente um "buraco" para omitir um argumento posicional anterior para
passar um posterior. É melhor usar argumentos nomeados para isso.

<?code-excerpt "design_good.dart (omit-optional-positional)"?>
```dart tag=good
String.fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]);

DateTime(
  int year, [
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
]);

Duration({
  int days = 0,
  int hours = 0,
  int minutes = 0,
  int seconds = 0,
  int milliseconds = 0,
  int microseconds = 0,
});
```


### EVITE parâmetros obrigatórios que aceitam um valor especial de "sem argumento"

Se o usuário está logicamente omitindo um parâmetro, prefira deixá-los realmente omiti-lo
tornando o parâmetro opcional em vez de forçá-los a passar `null`, uma
string vazia, ou algum outro valor especial que significa "não passou".

Omitir o parâmetro é mais conciso e ajuda a prevenir bugs onde um valor sentinela
como `null` é acidentalmente passado quando o usuário pensou que estava
fornecendo um valor real.

<?code-excerpt "design_good.dart (avoid-mandatory-param)"?>
```dart tag=good
var rest = string.substring(start);
```

<?code-excerpt "design_bad.dart (avoid-mandatory-param)"?>
```dart tag=bad
var rest = string.substring(start, null);
```


### FAÇA use parâmetros de início inclusivo e fim exclusivo para aceitar um intervalo

Se você está definindo um método ou função que permite ao usuário selecionar um intervalo de
elementos ou itens de alguma sequência indexada por inteiros, aceite um índice de início, que
se refere ao primeiro item e um índice de fim (provavelmente opcional) que é um maior
do que o índice do último item.

Isso é consistente com bibliotecas principais que fazem a mesma coisa.

<?code-excerpt "../../test/effective_dart_test.dart (param-range)" replace="/expect\(//g; /, \/\*\*\// \/\//g; /\);//g"?>
```dart tag=good
[0, 1, 2, 3].sublist(1, 3) // [1, 2]
'abcd'.substring(1, 3) // 'bc'
```

É particularmente importante ser consistente aqui porque esses parâmetros são
geralmente não nomeados. Se sua API aceita um comprimento em vez de um ponto final, a
diferença não será visível de forma alguma no local da chamada.


## Equality

Implementar comportamento de igualdade personalizado para uma classe pode ser complicado. Usuários têm intuição profunda
sobre como igualdade funciona que seus objetos precisam corresponder, e
tipos de coleção como tabelas hash têm contratos sutis que eles esperam que
elementos sigam.

### FAÇA sobrescreva `hashCode` se você sobrescrever `==`

{% render 'linter-rule-mention.md', rules:'hash_and_equals' %}

A implementação padrão de código hash fornece um hash de *identidade*—dois
objetos geralmente só têm o mesmo código hash se são exatamente o mesmo
objeto. Da mesma forma, o comportamento padrão para `==` é identidade.

Se você está sobrescrevendo `==`, isso implica que você pode ter objetos diferentes que são
considerados "iguais" pela sua classe. **Quaisquer dois objetos que são iguais devem ter o
mesmo código hash.** Caso contrário, mapas e outras coleções baseadas em hash vão falhar em
reconhecer que os dois objetos são equivalentes.

### FAÇA faça seu operador `==` obedecer as regras matemáticas de igualdade

Uma relação de equivalência deveria ser:

* **Reflexiva**: `a == a` deveria sempre retornar `true`.

* **Simétrica**: `a == b` deveria retornar a mesma coisa que `b == a`.

* **Transitiva**: Se `a == b` e `b == c` ambos retornam `true`, então `a == c`
  deveria também.

Usuários e código que usa `==` esperam que todas essas leis sejam seguidas. Se sua
classe não pode obedecer essas regras, então `==` não é o nome certo para a operação
que você está tentando expressar.

### EVITE definir igualdade personalizada para classes mutáveis

{% render 'linter-rule-mention.md', rules:'avoid_equals_and_hash_code_on_mutable_classes' %}

Quando você define `==`, você também tem que definir `hashCode`. Ambos devem
levar em conta os campos do objeto. Se esses campos *mudam* então isso
implica que o código hash do objeto pode mudar.

A maioria das coleções baseadas em hash não antecipa isso—elas assumem que o código hash de um objeto
será o mesmo para sempre e podem se comportar imprevisivelmente se isso não for
verdade.

### NÃO torne o parâmetro para `==` anulável

{% render 'linter-rule-mention.md', rules:'avoid_null_checks_in_equality_operators' %}

A linguagem especifica que `null` é igual apenas a si mesmo, e que o método `==`
é chamado apenas se o lado direito não é `null`.

<?code-excerpt "design_good.dart (eq-dont-check-for-null)" plaster="// ···"?>
```dart tag=good
class Person {
  final String name;

  // ···

  bool operator ==(Object other) => other is Person && name == other.name;
}
```

<?code-excerpt "design_bad.dart (eq-dont-check-for-null)" replace="/Object\?/[!$&!]/g" plaster="// ···"?>
```dart tag=bad
class Person {
  final String name;

  // ···

  bool operator ==([!Object?!] other) =>
      other != null && other is Person && name == other.name;
}
```

