---
ia-translate: true
title: "Effective Dart: Design"
description: Design consistente, bibliotecas utilizáveis.
prevpage:
  url: /effective-dart/usage
  title: Uso
---
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

Aqui estão algumas diretrizes para escrever APIs consistentes e utilizáveis para bibliotecas.

## Nomes {:#names}

A nomeação é uma parte importante da escrita de código legível e fácil de manter. As seguintes melhores práticas podem ajudar você a atingir esse objetivo.

### USE termos de forma consistente {:#do-use-terms-consistently}

Use o mesmo nome para a mesma coisa em todo o seu código. Se já existe um precedente
fora de sua API que os usuários provavelmente conhecem, siga esse
precedente.

```dart tag=good
pageCount         // Um campo.
updatePageCount() // Consistente com pageCount.
toSomething()     // Consistente com toList() de Iterable.
asSomething()     // Consistente com asMap() de List.
Point             // Um conceito familiar.
```

```dart tag=bad
renumberPages()      // Confusamente diferente de pageCount.
convertToSomething() // Inconsistente com o precedente toX().
wrappedAsSomething() // Inconsistente com o precedente asX().
Cartesian            // Desconhecido para a maioria dos usuários.
```

O objetivo é aproveitar o que o usuário já sabe. Isso inclui
o conhecimento do domínio do problema em si, as convenções das bibliotecas
centrais e outras partes de sua própria API. Ao construir em cima disso, você
reduz a quantidade de novo conhecimento que eles têm que adquirir antes que possam ser
produtivos.


### EVITE abreviações {:#avoid-abbreviations}

A menos que a abreviação seja mais comum que o termo não abreviado, não
abrevie. Se você abreviar, [capitalize corretamente][caps].

[caps]: /effective-dart/style#identifiers

```dart tag=good
pageCount
buildRectangles
IOStream
HttpRequest
```

```dart tag=bad
numPages    // "Num" é uma abreviação de "number (of)".
buildRects
InputOutputStream
HypertextTransferProtocolRequest
```


### PREFIRA colocar o substantivo mais descritivo por último {:#prefer-putting-the-most-descriptive-noun-last}

A última palavra deve ser a mais descritiva do que a coisa é. Você pode
prefixá-la com outras palavras, como adjetivos, para descrever ainda mais a coisa.

```dart tag=good
pageCount             // Uma contagem (de páginas).
ConversionSink        // Um coletor (sink) para fazer conversões.
ChunkedConversionSink // Um ConversionSink que é agrupado.
CssFontFaceRule       // Uma regra para fontes (font faces) em CSS.
```

```dart tag=bad
numPages                  // Não é uma coleção de páginas.
CanvasRenderingContext2D  // Não é um "2D".
RuleFontFaceCss           // Não é um CSS.
```


### CONSIDERE fazer o código ser lido como uma sentença {:#consider-making-the-code-read-like-a-sentence}

Em caso de dúvida sobre a nomeação, escreva um código que use sua API e tente lê-lo
como uma sentença.

<?code-excerpt "design_good.dart (code-like-prose)"?>
```dart tag=good
// "If errors is empty..."
if (errors.isEmpty) ...

// "Hey, subscription, cancel!"
subscription.cancel();

// "Get the monsters where the monster has claws."
monsters.where((monster) => monster.hasClaws);
```

<?code-excerpt "design_bad.dart (code-like-prose)" replace="/ as bool//g"?>
```dart tag=bad
// Telling errors to empty itself, or asking if it is?
if (errors.empty) ...

// Toggle what? To what?
subscription.toggle();

// Filter the monsters with claws *out* or include *only* those?
monsters.filter((monster) => monster.hasClaws);
```

É útil experimentar sua API e ver como ela "lê" quando usada no código, mas
você pode ir longe demais. Não é útil adicionar artigos e outras partes do discurso
para forçar seus nomes a *literalmente* serem lidos como uma frase gramaticalmente correta.

<?code-excerpt "design_bad.dart (code-like-prose-overdone)"?>
```dart tag=bad
if (theCollectionOfErrors.isEmpty) ...

monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
```


### PREFIRA uma frase substantiva para uma propriedade ou variável não booleana {:#prefer-a-noun-phrase-for-a-non-boolean-property-or-variable}

O foco do leitor está no *que* a propriedade é. Se o usuário se preocupa mais com
*como* uma propriedade é determinada, então ela provavelmente deve ser um método com um
nome de frase verbal.

```dart tag=good
list.length
context.lineWidth
quest.rampagingSwampBeast
```

```dart tag=bad
list.deleteItems
```


### PREFIRA uma frase verbal não imperativa para uma propriedade ou variável booleana {:#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable}

Nomes booleanos são frequentemente usados como condições no fluxo de controle, então você quer um nome
que seja lido bem ali. Compare:

```dart
if (window.closeable) ...  // Adjetivo.
if (window.canClose) ...   // Verbo.
```

Bons nomes tendem a começar com um de alguns tipos de verbos:

*   uma forma de "ser": `isEnabled` (está habilitado), `wasShown` (foi mostrado), `willFire` (irá disparar). Estes são, de longe,
    os mais comuns.

*   um [verbo auxiliar][auxiliary verb]: `hasElements` (possui elementos), `canClose` (pode fechar),
    `shouldConsume` (deve consumir), `mustSave` (deve salvar).

*   um verbo ativo: `ignoresInput` (ignora entrada), `wroteFile` (escreveu arquivo). Estes são raros porque são
    geralmente ambíguos. `loggedResult` (resultado registrado) é um nome ruim porque poderia significar
    "se um resultado foi registrado ou não" ou "o resultado que foi registrado".
    Da mesma forma, `closingConnection` (fechando conexão) poderia ser "se a conexão está fechando"
    ou "a conexão que está fechando". Verbos ativos são permitidos quando o nome
    pode *apenas* ser lido como um predicado.

[auxiliary verb]: https://en.wikipedia.org/wiki/Auxiliary_verb

O que separa todas essas frases verbais de nomes de métodos é que elas não são
*imperativas*. Um nome booleano nunca deve soar como um comando para dizer ao
objeto para fazer algo, porque acessar uma propriedade não muda o objeto.
(Se a propriedade *modificar* o objeto de forma significativa, ela deve ser um
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
empty         // Adjetivo ou verbo?
withElements  // Soa como se pudesse conter elementos.
closeable     // Soa como uma interface.
              // "canClose" lê melhor como uma sentença.
closingWindow // Retorna um bool ou uma janela?
showPopup     // Soa como se mostra o popup.
```


### CONSIDERE omitir o verbo para um *parâmetro* booleano nomeado {:#consider-omitting-the-verb-for-a-named-boolean-parameter}

Isso refina a regra anterior. Para parâmetros nomeados que são booleanos, o nome
é frequentemente tão claro sem o verbo, e o código lê melhor no
local de chamada.

<?code-excerpt "design_good.dart (omit-verb-for-bool-param)"?>
```dart tag=good
Isolate.spawn(entryPoint, message, paused: false);
var copy = List.from(elements, growable: true);
var regExp = RegExp(pattern, caseSensitive: false);
```


### PREFIRA o nome "positivo" para uma propriedade ou variável booleana {:#prefer-the-positive-name-for-a-boolean-property-or-variable}

A maioria dos nomes booleanos tem formas conceitualmente "positivas" e "negativas" onde
a primeira parece ser o conceito fundamental e a última é sua
negação — "aberto" e "fechado", "habilitado" e "desabilitado", etc. Muitas vezes, a
última nome literalmente tem um prefixo que nega a primeira: "visível" e
"*in*-visível", "conectado" e "*des*-conectado", "zero" e "*não*-zero".

Ao escolher qual dos dois casos que `true` representa — e, portanto,
para qual caso a propriedade é nomeada — prefira o positivo ou mais
fundamental. Membros booleanos são frequentemente aninhados dentro de expressões lógicas,
incluindo operadores de negação. Se sua própria propriedade é lida como uma negação,
é mais difícil para o leitor realizar mentalmente a dupla negação e
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
descarregado para o disco é "salvo" ou "*não*-alterado"? Um documento que *não* foi
descarregado é "*não*-salvo" ou "alterado"? Em casos ambíguos, incline-se para a escolha
que tem menos probabilidade de ser negada pelos usuários ou que tem o nome mais curto.

**Exceção:** Com algumas propriedades, a forma negativa é o que os usuários
precisam usar esmagadoramente. Escolher o caso positivo os forçaria a
negar a propriedade com `!` em todos os lugares. Em vez disso, pode ser melhor usar o
caso negativo para essa propriedade.


### PREFIRA uma frase verbal imperativa para uma função ou método cujo principal objetivo seja um efeito colateral {:#prefer-an-imperative-verb-phrase-for-a-function-or-method-whose-main-purpose-is-a-side-effect}

Membros invocáveis podem retornar um resultado para o chamador e executar outros trabalhos ou
efeitos colaterais. Em uma linguagem imperativa como Dart, os membros são frequentemente chamados
principalmente por seu efeito colateral: eles podem alterar o estado interno de um objeto,
produzir alguma saída ou se comunicar com o mundo exterior.

Esses tipos de membros devem ser nomeados usando uma frase verbal imperativa que
esclarece o trabalho que o membro executa.

<?code-excerpt "design_good.dart (verb-for-func-with-side-effect)"?>
```dart tag=good
list.add('element');
queue.removeFirst();
window.refresh();
```

Dessa forma, uma invocação é lida como um comando para fazer esse trabalho.


### PREFIRA uma frase substantiva ou frase verbal não imperativa para uma função ou método se retornar um valor for seu objetivo principal {:#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose}

Outros membros invocáveis têm poucos efeitos colaterais, mas retornam um resultado útil para o
chamador. Se o membro não precisa de parâmetros para fazer isso, geralmente deve ser um
getter (acessador). Mas às vezes uma "propriedade" lógica precisa de alguns parâmetros. Por exemplo,
`elementAt()` retorna um pedaço de dados de uma coleção, mas precisa de um
parâmetro para saber *qual* pedaço de dados retornar.

Isso significa que o membro é *sintaticamente* um método, mas *conceitualmente* é uma
propriedade, e deve ser nomeado como tal usando uma frase que descreva *o que* o
membro retorna.

<?code-excerpt "design_good.dart (noun-for-func-returning-value)"?>
```dart tag=good
var element = list.elementAt(3);
var first = list.firstWhere(test);
var char = string.codeUnitAt(4);
```

Esta diretriz é deliberadamente mais suave do que a anterior. Às vezes, um método
não tem efeitos colaterais, mas ainda é mais simples de nomear com uma frase verbal como
`list.take()` ou `string.split()`.


### CONSIDERE uma frase verbal imperativa para uma função ou método se você quiser chamar a atenção para o trabalho que ele realiza {:#consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs}

Quando um membro produz um resultado sem quaisquer efeitos colaterais, geralmente deve ser um
getter (acessador) ou um método com um nome de frase substantiva descrevendo o resultado que ele retorna.
No entanto, às vezes o trabalho necessário para produzir esse resultado é importante. Pode
ser propenso a falhas de tempo de execução ou usar recursos pesados, como rede ou
E/S de arquivo. Em casos como este, onde você quer que o chamador pense sobre o trabalho
o membro está fazendo, dê ao membro um nome de frase verbal que descreva esse
trabalho.

<?code-excerpt "design_good.dart (verb-for-func-with-work)"?>
```dart tag=good
var table = database.downloadData();
var packageVersions = packageGraph.solveConstraints();
```

Observe, no entanto, que esta diretriz é mais suave do que as duas anteriores. O trabalho que uma
operação realiza é muitas vezes um detalhe de implementação que não é relevante para o
chamador, e os limites de desempenho e robustez mudam com o tempo. Na maioria das
vezes, nomeie seus membros com base em *o que* eles fazem para o chamador, não em *como*
eles fazem isso.


### EVITE começar o nome de um método com `get` {:#avoid-starting-a-method-name-with-get}

Na maioria dos casos, o método deve ser um getter (acessador) com `get` removido do nome.
Por exemplo, em vez de um método chamado `getBreakfastOrder()`, defina um getter (acessador)
chamado `breakfastOrder`.

Mesmo que o membro precise ser um método porque recebe argumentos ou
de outra forma não é adequado para um getter (acessador), você ainda deve evitar `get`. Como
as diretrizes anteriores afirmam, ou:

* Simplesmente descarte `get` e [use um nome de frase substantiva][noun] como `breakfastOrder()`
se o chamador se importar principalmente com o valor que o método retorna.

* [Use um nome de frase verbal][verb] se o chamador se importar com o trabalho que está sendo feito,
mas escolha um verbo que descreva o trabalho com mais precisão do que `get`, como
`create`, `download`, `fetch`, `calculate`, `request`, `aggregate`, etc.

[noun]: #prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose

[verb]: #consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs


### PREFIRA nomear um método `to___()` se ele copiar o estado do objeto para um novo objeto {:#prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object}

{% render 'linter-rule-mention.md', rules:'use_to_and_as_if_applicable' %}

Um método de *conversão* é aquele que retorna um novo objeto contendo uma cópia de
quase todo o estado do receptor, mas geralmente de alguma forma ou representação diferente.
As bibliotecas principais têm uma convenção de que esses métodos são
nomeados começando com `to`, seguido pelo tipo de resultado.

Se você definir um método de conversão, é útil seguir essa convenção.

<?code-excerpt "design_good.dart (to-misc)"?>
```dart tag=good
list.toSet();
stackTrace.toString();
dateTime.toLocal();
```

### PREFIRA nomear um método `as___()` se ele retornar uma representação diferente com suporte do objeto original {:#prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object}

{% render 'linter-rule-mention.md', rules:'use_to_and_as_if_applicable' %}

Métodos de conversão são "instantâneos". O objeto resultante tem sua própria cópia do
estado do objeto original. Existem outros métodos semelhantes a conversão que retornam
*visualizações* — eles fornecem um novo objeto, mas esse objeto se refere de volta ao
original. Alterações posteriores no objeto original são refletidas na visualização.

A convenção da biblioteca principal para você seguir é `as___()`.

<?code-excerpt "design_good.dart (as-misc)"?>
```dart tag=good
var map = table.asMap();
var list = bytes.asFloat32List();
var future = subscription.asFuture();
```


### EVITE descrever os parâmetros no nome da função ou do método {:#avoid-describing-the-parameters-in-the-functions-or-methods-name}

O usuário verá o argumento no local da chamada, portanto, geralmente não ajuda a
legibilidade também se referir a ele no próprio nome.

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
métodos com nomes semelhantes que recebem tipos diferentes:

<?code-excerpt "design_good.dart (desc-param-in-func-ok)"?>
```dart tag=good
map.containsKey(key);
map.containsValue(value);
```


### SIGA as convenções mnemônicas existentes ao nomear parâmetros de tipo {:#do-follow-existing-mnemonic-conventions-when-naming-type-parameters}

Nomes de uma única letra não são exatamente esclarecedores, mas quase todos os tipos genéricos
os usam. Felizmente, eles os usam principalmente de forma consistente e mnemônica.
As convenções são:

*   `E` para o tipo de **elemento** em uma coleção:

    <?code-excerpt "design_good.dart (type-parameter-e)" replace="/\n\n/\n/g"?>
    ```dart tag=good
    class IterableBase<E> {}
    class List<E> {}
    class HashSet<E> {}
    class RedBlackTree<E> {}
    ```

*   `K` e `V` para os tipos de **chave** e **valor** em uma associação
    coleção:

    <?code-excerpt "design_good.dart (type-parameter-k-v)" replace="/\n\n/\n/g"?>
    ```dart tag=good
    class Map<K, V> {}
    class Multimap<K, V> {}
    class MapEntry<K, V> {}
    ```

*   `R` para um tipo usado como o tipo de **retorno** de uma função ou um
    métodos da classe. Isso não é comum, mas aparece às vezes em typedefs e em classes
    que implementam o padrão visitor:

    <?code-excerpt "design_good.dart (type-parameter-r)"?>
    ```dart tag=good
    abstract class ExpressionVisitor<R> {
      R visitBinary(BinaryExpression node);
      R visitLiteral(LiteralExpression node);
      R visitUnary(UnaryExpression node);
    }
    ```

*   Caso contrário, use `T`, `S` e `U` para genéricos que têm um único tipo
    parâmetro e onde o tipo circundante torna seu significado óbvio. Lá
    são várias letras aqui para permitir o aninhamento sem sombrear um nome circundante.
    Por exemplo:

    <?code-excerpt "design_good.dart (type-parameter-t)"?>
    ```dart tag=good
    class Future<T> {
      Future<S> then<S>(FutureOr<S> onValue(T value)) => ...
    }
    ```

    Aqui, o método genérico `then<S>()` usa `S` para evitar sombrear o `T`
    em `Future<T>`.

Se nenhum dos casos acima for adequado, então outro nome mnemônico de uma única letra
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

## Bibliotecas {:#libraries}

Um caractere de sublinhado inicial ( `_` ) indica que um membro é privado para sua
biblioteca. Esta não é uma mera convenção, mas está integrada na própria linguagem.

### PREFIRA tornar as declarações privadas {:#prefer-making-declarations-private}

Uma declaração pública em uma biblioteca — seja de nível superior ou em uma classe — é
um sinal de que outras bibliotecas podem e devem acessar esse membro. É também um
compromisso por parte de sua biblioteca de suportar isso e se comportar adequadamente quando
isso acontece.

Se não é isso que você pretende, adicione o pequeno `_` e seja feliz. Interfaces
públicas restritas são mais fáceis para você manter e mais fáceis para os usuários aprenderem.
Como um bônus agradável, o analisador informará sobre declarações privadas não utilizadas para que você
possa excluir código morto. Ele não pode fazer isso se o membro for público porque
não sabe se algum código fora de sua visualização está usando-o.


### CONSIDERE declarar várias classes na mesma biblioteca {:#consider-declaring-multiple-classes-in-the-same-library}

Algumas linguagens, como Java, vinculam a organização de arquivos à organização de
classes — cada arquivo pode definir apenas uma única classe de nível superior. Dart não
tem essa limitação. Bibliotecas são entidades distintas separadas das classes.
É perfeitamente bom que uma única biblioteca contenha várias classes, nível superior
variáveis e funções se todas elas logicamente pertencem juntas.

Colocar várias classes juntas em uma biblioteca pode ativar alguns padrões úteis.
Como a privacidade em Dart funciona no nível da biblioteca, não no nível da classe,
esta é uma maneira de definir classes "amigas" como você pode em C++. Cada classe
declarada na mesma biblioteca pode acessar os membros privados um do outro, mas código
fora dessa biblioteca não pode.

Claro, esta diretriz não significa que você *deve* colocar todas as suas classes em
uma enorme biblioteca monolítica, apenas que você tem permissão para colocar mais de uma
classe em uma única biblioteca.


## Classes e mixins {:#classes-and-mixins}

Dart é uma linguagem orientada a objetos "pura" no sentido de que todos os objetos são instâncias de
classes. Mas Dart não exige que todo o código seja definido dentro de uma
classe — você pode definir variáveis, constantes e funções de nível superior como
você pode em uma linguagem procedural ou funcional.

### EVITE definir uma classe abstrata de um membro quando uma função simples for suficiente {:#avoid-defining-a-one-member-abstract-class-when-a-simple-function-will-do}

{% render 'linter-rule-mention.md', rules:'one_member_abstracts' %}

Ao contrário de Java, Dart tem funções de primeira classe, closures (fechamentos) e uma sintaxe leve e agradável
para usá-los. Se tudo o que você precisa é algo como um callback (retorno de chamada), apenas use um
função. Se você está definindo uma classe e ela tem apenas um único membro abstrato
com um nome sem sentido como `call` ou `invoke`, há uma boa chance de que você
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


### EVITE definir uma classe que contenha apenas membros estáticos {:#avoid-defining-a-class-that-contains-only-static-members}

{% render 'linter-rule-mention.md', rules:'avoid_classes_with_only_static_members' %}

Em Java e C#, toda definição *deve* estar dentro de uma classe, por isso é comum ver
"classes" que existem apenas como um lugar para armazenar membros estáticos. Outras classes são
usadas como namespaces — uma maneira de dar um prefixo compartilhado a um monte de membros para
relacioná-los uns aos outros ou evitar uma colisão de nomes.

Dart tem funções, variáveis e constantes de nível superior, então você não *precisa* de uma
classe apenas para definir algo. Se o que você quer é um namespace, uma biblioteca é uma
melhor opção. As bibliotecas suportam prefixos de importação e combinadores mostrar/ocultar. Esses
são ferramentas poderosas que permitem que o consumidor de seu código lide com colisões de nomes em
a maneira que funciona melhor para *eles*.

Se uma função ou variável não está logicamente ligada a uma classe, coloque-a na parte superior
nível. Se você está preocupado com colisões de nomes, dê a ele um nome mais preciso ou
mova-o para uma biblioteca separada que pode ser importada com um prefixo.

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
instanciado é um cheiro de código.

No entanto, esta não é uma regra rígida. Por exemplo, com constantes e tipos semelhantes a enum,
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


### EVITE estender uma classe que não se destina a ser subclassificada {:#avoid-extending-a-class-that-isnt-intended-to-be-subclassed}

Se um construtor for alterado de um construtor gerador para um factory (fábrica)
construtor, qualquer construtor de subclasse que chame esse construtor será interrompido.
Além disso, se uma classe mudar quais de seus próprios métodos ela invoca em `this`, isso
pode quebrar subclasses que substituem esses métodos e esperam que eles sejam chamados
em certos pontos.

Ambos significam que uma classe precisa ser deliberada sobre se ela
quer ou não permitir subclassificação. Isso pode ser comunicado em um comentário doc, ou por
dando à classe um nome óbvio como `IterableBase`. Se o autor da classe
não fizer isso, é melhor assumir que você *não* deve estender a classe.
Caso contrário, alterações posteriores podem quebrar seu código.


### DOCUMENTA se sua classe suporta ser estendida {:#do-document-if-your-class-supports-being-extended}

Este é o corolário da regra acima. Se você quiser permitir subclasses de sua
classe, declare isso. Sufixe o nome da classe com `Base` ou mencione-o no
comentário doc da classe.


### EVITE implementar uma classe que não se destina a ser uma interface {:#avoid-implementing-a-class-that-isnt-intended-to-be-an-interface}

Interfaces implícitas são uma ferramenta poderosa em Dart para evitar ter que repetir o
contrato de uma classe quando ele pode ser trivialmente inferido das assinaturas de um
implementação desse contrato.

Mas implementar a interface de uma classe é um acoplamento muito forte com essa classe. Isto
significa que virtualmente *qualquer* mudança na classe cuja interface você está implementando
irá quebrar sua implementação. Por exemplo, adicionar um novo membro a uma classe é
geralmente uma mudança segura e não interruptiva. Mas se você está implementando a classe
interface, agora sua classe tem um erro estático porque não possui uma implementação
desse novo método.

Mantenedores de biblioteca precisam da capacidade de evoluir classes existentes sem quebrar
usuários. Se você trata cada classe como se ela expusesse uma interface que os usuários são livres
para implementar, então mudar essas classes se torna muito difícil. Aquilo
dificuldade, por sua vez, significa que as bibliotecas nas quais você confia são mais lentas para crescer e se adaptar
às novas necessidades.

Para dar aos autores das classes que você usa mais liberdade, evite implementar
interfaces implícitas, exceto para classes que são claramente destinadas a serem
implementadas. Caso contrário, você pode introduzir um acoplamento que o autor não
pretende, e eles podem quebrar seu código sem perceber.

### DOCUMENTA se sua classe suporta ser usada como uma interface {:#do-document-if-your-class-supports-being-used-as-an-interface}

Se sua classe puder ser usada como uma interface, mencione isso no
comentário doc da classe.


<a id="do-use-mixin-to-define-a-mixin-type"></a>
<a id="avoid-mixing-in-a-class-that-isnt-intended-to-be-a-mixin"></a>
### PREFIRA definir um `mixin` puro ou `class` puro em vez de um `mixin class` {:#prefer-defining-a-pure-mixin-or-pure-class-to-a-mixin-class}

{% render 'linter-rule-mention.md', rules:'prefer_mixin' %}

Dart anteriormente (versão da linguagem [2.12](/resources/language/evolution#dart-2-12)
a [2.19](/resources/language/evolution#dart-2-19)) permitia qualquer classe que
atendesse a certas restrições (sem construtor não padrão, sem superclasse, etc.)
a serem misturadas em outras classes.
Isso era confuso porque o autor da classe
pode não ter pretendido que fosse misturado.

Dart 3.0.0 agora exige que qualquer tipo destinado a ser misturado em outras classes,
bem como tratado como uma classe normal, deve ser explicitamente declarado como tal com
a declaração `mixin class`.

Tipos que precisam ser um mixin e uma classe devem ser um caso raro, no entanto.
A declaração `mixin class` destina-se principalmente a ajudar a migrar classes pre-3.0.0
sendo usado como mixins para uma declaração mais explícita. Novo código deve claramente
definir o comportamento e a intenção de suas declarações usando apenas `mixin` puro
ou declarações `class` puras e evite a ambiguidade de classes mixin.

Leia [Migrating classes as mixins](/language/class-modifiers-for-apis#migrating-classes-as-mixins)
para mais orientação sobre as declarações `mixin` e `mixin class`.

## Construtores {:#constructors}

Os construtores Dart são criados declarando uma função com o mesmo nome da
classe e, opcionalmente, um identificador adicional. Os últimos são chamados de *construtores
nomeados*.


### CONSIDERE tornar seu construtor `const` se a classe o suportar {:#consider-making-your-constructor-const-if-the-class-supports-it}

Se você tem uma classe onde todos os campos são finais e o construtor não
faz nada além de inicializá-los, você pode tornar esse construtor `const`. Isso permite
que os usuários criem instâncias de sua classe em lugares onde as constantes são
necessárias — dentro de outras constantes maiores, casos switch, valores de parâmetros
padrão, etc.

Se você não o torna explicitamente `const`, eles não podem fazer isso.

Observe, no entanto, que um construtor `const` é um compromisso em sua API pública. Se
você alterar posteriormente o construtor para não-`const`, ele irá quebrar os usuários que
o chamam em expressões constantes. Se você não quer se comprometer com isso, não
o torne `const`. Na prática, construtores `const` são mais úteis para tipos simples,
imutáveis ​​semelhantes a valores.


## Membros {:#members}

Um membro pertence a um objeto e pode ser métodos ou variáveis ​​de instância.

### PREFIRA tornar os campos e as variáveis ​​de nível superior `final` {:#prefer-making-fields-and-top-level-variables-final}

{% render 'linter-rule-mention.md', rules:'prefer_final_fields' %}

O estado que não é *mutável* — que não muda com o tempo — é
mais fácil para os programadores raciocinarem sobre. Classes e bibliotecas que minimizam a
quantidade de estado mutável com o qual eles trabalham tendem a ser mais fáceis de manter.
Claro, muitas vezes é útil ter dados mutáveis. Mas, se você não precisa,
seu padrão deve ser tornar os campos e as variáveis de nível superior `final` quando você
pode.

Às vezes, um campo de instância não muda depois de ser inicializado, mas
não pode ser inicializado até depois que a instância é construída. Por exemplo,
pode ser necessário referenciar `this` ou algum outro campo na instância. Em casos
como esse, considere tornar o campo `late final` (tardio final). Quando você
faz isso, também pode ser capaz de [inicializar o campo em sua declaração][init at decl].

[init at decl]: /effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible

### FAÇA usar getters para operações que conceitualmente acessam propriedades {:#do-use-getters-for-operations-that-conceptually-access-properties}

Decidir quando um membro deve ser um getter (acessador) versus um método é uma
parte sutil, porém importante, de um bom design de API, portanto, esta diretriz
muito longa. A cultura de algumas outras linguagens evita os getters. Eles só os
usam quando a operação é quase exatamente como um campo — faz uma pequena
quantidade de cálculo no estado que reside inteiramente no objeto. Qualquer
coisa mais complexa ou pesada do que isso recebe `()` após o nome para sinalizar
"cálculo acontecendo aqui!" porque um nome sem nada depois de um `.` significa "campo".

Dart *não* é assim. Em Dart, *todos* os nomes com ponto são invocações de membros
que podem fazer cálculos. Campos são especiais — são getters cuja implementação é
fornecida pela linguagem. Em outras palavras, getters não são "campos
particularmente lentos" em Dart; campos são "getters particularmente rápidos".

Mesmo assim, escolher um getter em vez de um método envia um sinal importante
para o chamador. O sinal, em resumo, é que a operação é "como um campo". A
operação, pelo menos em princípio, *poderia* ser implementada usando um campo,
tanto quanto o chamador sabe. Isso implica:

*   **A operação não recebe nenhum argumento e retorna um resultado.**

*   **O chamador se importa principalmente com o resultado.** Se você quer que o
    chamador se preocupe com *como* a operação produz seu resultado mais do que
    com o resultado sendo produzido, então dê à operação um nome de verbo que
    descreva o trabalho e faça dela um método.

    Isso *não* significa que a operação tenha que ser particularmente rápida
    para ser um getter. `IterableBase.length` é `O(n)`, e isso está OK. Não há
    problema que um getter faça um cálculo significativo. Mas se ele fizer uma
    quantidade *surpreendente* de trabalho, você pode querer chamar a atenção
    para isso, transformando-o em um método cujo nome seja um verbo que descreva o que ele faz.

    ```dart tag=bad
    connection.nextIncomingMessage; // Faz E/S de rede.
    expression.normalForm; // Pode ser exponencial para calcular.
    ```

*   **A operação não tem efeitos colaterais visíveis para o usuário.** Acessar
    um campo real não altera o objeto nem qualquer outro estado no programa. Ele
    não produz saída, não grava arquivos, etc. Um getter também não deve fazer
    essas coisas.

    A parte "visível para o usuário" é importante. Não há problema em getters
    modificarem o estado oculto ou produzirem efeitos colaterais fora da banda.
    Getters podem calcular e armazenar seu resultado preguiçosamente (lazy),
    escrever em um cache, registrar coisas, etc. Contanto que o chamador não se *importe* com o efeito colateral, provavelmente está tudo bem.

    ```dart tag=bad
    stdout.newline; // Produz saída.
    list.clear; // Modifica o objeto.
    ```

*   **A operação é *idempotente*.** "Idempotente" é uma palavra estranha que,
    neste contexto, basicamente significa que chamar a operação várias vezes
    produz o mesmo resultado a cada vez, a menos que algum estado seja
    explicitamente modificado entre essas chamadas. (Obviamente,
    `list.length` produz resultados diferentes se você adicionar um elemento à lista entre as chamadas.)

    "Mesmo resultado" aqui não significa que um getter deve literalmente
    produzir um objeto idêntico em chamadas sucessivas. Exigir isso forçaria
    muitos getters a terem caching frágil, o que anula todo o propósito de usar
    um getter. É comum, e perfeitamente aceitável, que um getter retorne um novo
    future ou lista cada vez que você o chama. A parte importante é que o
    future seja concluído com o mesmo valor e que a lista contenha os mesmos elementos.

    Em outras palavras, o valor do resultado deve ser o mesmo *nos aspectos
    com os quais o chamador se importa*.

    ```dart tag=bad
    DateTime.now; // Novo resultado a cada vez.
    ```

*   **O objeto resultante não expõe todo o estado do objeto original.** Um campo
    expõe apenas uma parte de um objeto. Se sua operação retornar um resultado
    que expõe todo o estado do objeto original, é provável que seja melhor como
    um método [`to___()`][to] ou [`as___()`][as].

[to]: #prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object
[as]: #prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object

Se tudo acima descreve sua operação, deve ser um getter. Parece que poucos
membros sobreviveriam a esse desafio, mas surpreendentemente muitos sobrevivem.
Muitas operações apenas fazem algum cálculo em algum estado e a maioria delas
pode e deve ser getters.

```dart tag=good
rectangle.area;
collection.isEmpty;
button.canShow;
dataSet.minimumValue;
```


### USE setters para operações que conceitualmente alteram propriedades {:#do-use-setters-for-operations-that-conceptually-change-properties}

{% render 'linter-rule-mention.md', rules:'use_setters_to_change_properties' %}

Decidir entre um setter (modificador) versus um método é semelhante a decidir
entre um getter versus um método. Em ambos os casos, a operação deve ser "como um campo".

Para um setter, "como um campo" significa:

*   **A operação recebe um único argumento e não produz um valor de
    resultado.**

*   **A operação altera algum estado no objeto.**

*   **A operação é idempotente.** Chamar o mesmo setter duas vezes com o mesmo
    valor não deve fazer nada na segunda vez no que diz respeito ao chamador.
    Internamente, talvez você tenha alguma invalidação de cache ou registro
    acontecendo. Tudo bem. Mas, da perspectiva do chamador, parece que a segunda
    chamada não faz nada.

```dart tag=good
rectangle.width = 3;
button.visible = false;
```


### NÃO defina um setter sem um getter correspondente {:#dont-define-a-setter-without-a-corresponding-getter}

{% render 'linter-rule-mention.md', rules:'avoid_setters_without_getters' %}

Os usuários pensam em getters e setters como propriedades visíveis de um
objeto. Uma propriedade "dropbox" que pode ser escrita, mas não vista, é
confusa e confunde sua intuição sobre como as propriedades funcionam. Por
exemplo, um setter sem um getter significa que você pode usar `=` para modificá-lo, mas não `+=`.

Esta diretriz *não* significa que você deve adicionar um getter apenas para
permitir o setter que deseja adicionar. Os objetos geralmente não devem expor
mais estado do que o necessário. Se você tem alguma parte do estado de um
objeto que pode ser modificada, mas não exposta da mesma forma, use um método em vez disso.


### EVITE usar testes de tipo em tempo de execução para simular sobrecarga {:#avoid-using-runtime-type-tests-to-fake-overloading}

É comum que uma API suporte operações semelhantes em diferentes tipos de
parâmetros. Para enfatizar a semelhança, algumas linguagens oferecem suporte à
*sobrecarga*, que permite definir vários métodos
que têm o mesmo nome, mas listas
de parâmetros diferentes. Em tempo de compilação,
o compilador analisa os tipos
de argumento reais para determinar qual método chamar.

Dart não tem sobrecarga. Você pode definir uma API que se parece com sobrecarga
definindo um único método e, em seguida, usando testes de tipo `is` dentro do
corpo para analisar os tipos em tempo de execução dos argumentos e realizar o
comportamento apropriado. No entanto,
simular sobrecarga dessa forma transforma
uma seleção de método em *tempo de compilação* em uma escolha que acontece em
*tempo de execução*.

Se os chamadores geralmente sabem qual tipo eles têm e qual operação
específica desejam, é melhor definir métodos separados com nomes diferentes para
permitir que os chamadores selecionem a operação correta.
Isso oferece melhor
verificação estática de tipos e desempenho mais rápido, pois evita quaisquer
testes de tipo em tempo de execução.

No entanto, se os usuários podem ter um objeto de um tipo desconhecido e *querem*
que a API use internamente `is` para escolher a operação correta, então um único
método onde o parâmetro é um supertipo de todos os tipos suportados pode ser
razoável.


### EVITE campos públicos `late final` sem inicializadores {:#avoid-public-late-final-fields-without-initializers}

Ao contrário de outros campos `final`, um campo `late final` sem um
inicializador *define* um setter. Se esse campo for público, o setter é
público. Isso raramente é o que você quer. Os campos são geralmente marcados
como `late` para que possam ser inicializados *internamente* em algum momento da
vida útil da instância, geralmente dentro do corpo do construtor.

A menos que você *queira* que os usuários chamem o setter, é melhor escolher uma
das seguintes soluções:

*   Não use `late`.
*   Use um construtor de fábrica para calcular os valores do campo `final`.
*   Use `late`, mas inicialize o campo `late` em sua declaração.
*   Use `late`, mas torne o campo `late` privado e defina um getter público para ele.


### EVITE retornar `Future` (Futuro), `Stream` (Fluxo) e tipos de coleção anuláveis {:#avoid-returning-nullable-future-stream-and-collection-types}

Quando uma API retorna um tipo de container, ela tem duas maneiras de indicar a
ausência de dados: pode retornar um container vazio ou pode retornar `null`.
Os usuários geralmente presumem e preferem que você use um container vazio para
indicar "sem dados". Dessa forma, eles têm um objeto real no qual podem chamar métodos como `isEmpty`.

Para indicar que sua API não tem dados para fornecer, prefira retornar uma
coleção vazia, um futuro não anulável de um tipo anulável ou um fluxo que não
emita nenhum valor.

**Exceção:** Se retornar `null` *significa algo diferente* de produzir um
container vazio, pode fazer sentido usar um tipo anulável.


### EVITE retornar `this` de métodos apenas para habilitar uma interface fluente {:#avoid-returning-this-from-methods-just-to-enable-a-fluent-interface}

{% render 'linter-rule-mention.md', rules:'avoid_returning_this' %}

Cascades de método são uma solução melhor para encadear chamadas de método.

<?code-excerpt "design_good.dart (cascades)"?>
```dart tag=good
var buffer = StringBuffer()
  ..write('one')
  ..write('two')
  ..write('three');
```

<?code-excerpt "design_bad.dart (cascades)"?>
```dart tag=bad
var buffer = StringBuffer()
    .write('one')
    .write('two')
    .write('three');
```


## Tipos {:#types}

Quando você escreve um tipo em seu programa, você restringe os tipos de valores
que fluem para diferentes partes do seu código. Os tipos podem aparecer em dois
tipos de lugares: *anotações de tipo* em declarações e argumentos de tipo para
*invocações genéricas*.

Anotações de tipo são o que você normalmente pensa quando pensa em "tipos
estáticos". Você pode anotar o tipo de uma variável, parâmetro, campo ou tipo de
retorno. No exemplo a seguir, `bool` e `String` são anotações de tipo. Elas se
ligam à estrutura declarativa estática do código e não são "executadas" em tempo de execução.

<?code-excerpt "design_good.dart (annotate-declaration)"?>
```dart
bool isEmpty(String parameter) {
  bool result = parameter.isEmpty;
  return result;
}
```

Uma invocação genérica é um literal de coleção, uma chamada para o construtor
de uma classe genérica ou uma invocação de um método genérico. No próximo
exemplo, `num` e `int` são argumentos de tipo em invocações genéricas. Mesmo que
sejam tipos, são entidades de primeira classe que são concretizadas e passadas
para a invocação em tempo de execução.

<?code-excerpt "design_good.dart (annotate-invocation)"?>
```dart
var lists = <num>[1, 2];
lists.addAll(List<num>.filled(3, 4));
lists.cast<int>();
```

Enfatizamos a parte "invocação genérica" aqui, porque argumentos de tipo
*também* podem aparecer em anotações de tipo:

<?code-excerpt "design_good.dart (annotate-type-arg)"?>
```dart
List<int> ints = [1, 2];
```

Aqui, `int` é um argumento de tipo, mas aparece dentro de uma anotação de
tipo, não de uma invocação genérica. Normalmente, você não precisa se preocupar
com essa distinção, mas em alguns lugares, temos orientações diferentes para
quando um tipo é usado em uma invocação genérica em oposição a uma anotação de tipo.

#### Inferência de tipo {:#type-inference}

Anotações de tipo são opcionais em Dart. Se você omitir uma, o Dart tentará
inferir um tipo com base no contexto próximo. Às vezes, ele não tem
informações suficientes para inferir um tipo completo. Quando isso acontece, o
Dart às vezes relata um erro, mas geralmente preenche silenciosamente todas as
partes ausentes com `dynamic`. O `dynamic` implícito leva a um código que
*parece* inferido e seguro, mas na verdade desativa a verificação de tipo
completamente. As regras abaixo evitam isso exigindo tipos quando a inferência
falha.

O fato de que Dart tem inferência de tipo e um tipo `dynamic` leva a alguma
confusão sobre o que significa dizer que o código é "sem tipo". Isso significa
que o código é digitado dinamicamente ou que você não *escreveu* o tipo? Para
evitar essa confusão, evitamos dizer "sem tipo" e, em vez disso, usamos a seguinte terminologia:

*   Se o código for *anotado com tipo*, o tipo foi explicitamente escrito no
    código.

*   Se o código for *inferido*, nenhuma anotação de tipo foi escrita e o Dart
    descobriu com sucesso o tipo por conta própria. A inferência pode falhar,
    caso em que as diretrizes não consideram isso inferido.

*   Se o código for *dinâmico*, seu tipo estático é o tipo especial `dynamic`.
    O código pode ser explicitamente anotado como `dynamic` ou pode ser inferido.

Em outras palavras, se algum código é anotado ou inferido é ortogonal a se ele
é `dynamic` ou algum outro tipo.

A inferência é uma ferramenta poderosa para poupar o esforço de escrever e ler
tipos que são óbvios ou desinteressantes. Ela mantém a atenção do leitor focada
no comportamento do próprio código. Tipos explícitos também são uma parte
fundamental de um código robusto e sustentável. Eles definem a forma estática de
uma API e criam limites para documentar e aplicar quais tipos de valores podem
atingir diferentes partes do programa.

Claro, a inferência não é mágica. Às vezes, a inferência é bem-sucedida e
seleciona um tipo, mas não é o tipo que você deseja. O caso comum é inferir um
tipo excessivamente preciso do inicializador de uma variável quando você pretende
atribuir valores de outros tipos à variável mais tarde. Nesses casos, você deve
escrever o tipo explicitamente.

As diretrizes aqui atingem o melhor equilíbrio que encontramos entre brevidade e
controle, flexibilidade e segurança. Existem diretrizes específicas para cobrir
todos os vários casos, mas o resumo geral é:

*   Anote quando a inferência não tiver contexto suficiente, mesmo quando
    `dynamic` for o tipo que você deseja.

*   Não anote locais e invocações genéricas, a menos que seja necessário.

*   Prefira anotar variáveis e campos de nível superior, a menos que o
    inicializador deixe o tipo óbvio.


### USE anotação de tipo em variáveis sem inicializadores {:#do-type-annotate-variables-without-initializers}

{% render 'linter-rule-mention.md', rules:'prefer_typing_uninitialized_variables' %}

O tipo de uma variável — de nível superior, local, campo estático ou campo de
instância — pode geralmente ser inferido de seu inicializador. No entanto, se
não houver inicializador, a inferência falha.

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


### USE anotação de tipo em campos e variáveis de nível superior se o tipo não for óbvio {:#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious}

{% render 'linter-rule-mention.md', rules:'type_annotate_public_apis' %}

Anotações de tipo são documentação importante de como uma biblioteca deve ser
usada. Elas formam limites entre regiões de um programa para isolar a origem de
um erro de tipo. Considere:

<?code-excerpt "design_bad.dart (type_annotate_public_apis)"?>
```dart tag=bad
install(id, destination) => ...
```

Aqui, não está claro o que é `id`. Uma string? E o que é `destination`? Uma
string ou um objeto `File`? Este método é síncrono ou assíncrono? Isto é mais claro:

<?code-excerpt "design_good.dart (type_annotate_public_apis)"?>
```dart tag=good
Future<bool> install(PackageId id, String destination) => ...
```

Em alguns casos, porém, o tipo é tão óbvio que escrevê-lo é inútil:

<?code-excerpt "design_good.dart (inferred)"?>
```dart tag=good
const screenWidth = 640; // Inferred as int.
```

"Óbvio" não é definido precisamente, mas todos esses são bons candidatos:

*   Literais.
*   Invocações de construtor.
*   Referências a outras constantes que são explicitamente tipadas.
*   Expressões simples em números e strings.
*   Métodos de fábrica como `int.parse()`, `Future.wait()`, etc., com os quais
    se espera que os leitores estejam familiarizados.

Se você acha que a expressão inicializadora — seja ela qual for — é
suficientemente clara, você pode omitir a anotação. Mas se você acha que anotar
ajuda a tornar o código mais claro, adicione uma.

Em caso de dúvida, adicione uma anotação de tipo. Mesmo quando um tipo é óbvio,
você ainda pode querer anotar explicitamente. Se o tipo inferido depende de
valores ou declarações de outras bibliotecas, você pode querer anotar o tipo de
*sua* declaração para que uma alteração nessa outra biblioteca não altere
silenciosamente o tipo de sua própria API sem que você perceba.

Esta regra se aplica a declarações públicas e privadas. Assim como as
anotações de tipo em APIs ajudam os *usuários* do seu código, os tipos em
membros privados ajudam os *mantenedores*.


### NÃO anote tipos de variáveis locais inicializadas de forma redundante {:#dont-redundantly-type-annotate-initialized-local-variables}

{% render 'linter-rule-mention.md', rules:'omit_local_variable_types' %}

Variáveis locais, especialmente no código moderno, onde as funções tendem a ser
pequenas, têm muito pouco escopo. Omitir o tipo concentra a atenção do leitor no
*nome* mais importante da variável e em seu valor inicializado.

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

Às vezes, o tipo inferido não é o tipo que você deseja que a variável tenha. Por
exemplo, você pode pretender atribuir valores de outros tipos mais tarde. Nesse
caso, anote a variável com o tipo desejado.

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


### USE anotação de tipos de retorno em declarações de função {:#do-annotate-return-types-on-function-declarations}

Dart geralmente não infere o tipo de retorno de uma declaração de função de seu
corpo, ao contrário de algumas outras linguagens. Isso significa que você deve
escrever uma anotação de tipo para o tipo de retorno você mesmo.

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

Observe que esta diretriz se aplica apenas a declarações de função *não
locais*: métodos e getters de nível superior, estáticos e de instância. Funções
locais e expressões de função anônimas inferem um tipo de retorno de seu corpo.
Na verdade, a sintaxe de função anônima nem mesmo permite uma anotação de tipo de retorno.


### USE anotação de tipos de parâmetro em declarações de função {:#do-annotate-parameter-types-on-function-declarations}

A lista de parâmetros de uma função determina seu limite para o mundo exterior.
Anotar os tipos de parâmetro torna esse limite bem definido. Observe que, embora
os valores de parâmetro padrão pareçam inicializadores de variável, o Dart não
infere o tipo de um parâmetro opcional de seu valor padrão.

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

**Exceção:** Expressões de função e parâmetros formais de inicialização têm
convenções de anotação de tipo diferentes, conforme descrito nas duas diretrizes a seguir.


### NÃO anote tipos de parâmetro inferidos em expressões de função {:#dont-annotate-inferred-parameter-types-on-function-expressions}

{% render 'linter-rule-mention.md', rules:'avoid_types_on_closure_parameters' %}

Funções anônimas são quase sempre passadas imediatamente para um método que
recebe um *callback* (retorno de chamada) de algum tipo. Quando uma expressão de
função é criada em um contexto tipado, o Dart tenta inferir os tipos de
parâmetro da função com base no tipo esperado. Por exemplo, quando você passa
uma expressão de função para `Iterable.map()`, o tipo de parâmetro de sua função
é inferido com base no tipo de retorno de chamada que `map()`
espera:

<?code-excerpt "design_good.dart (func-expr-no-param-type)"?>
```dart tag=good
var names = people.map((person) => person.name);
```

<?code-excerpt "design_bad.dart (func-expr-no-param-type)"?>
```dart tag=bad
var names = people.map((Person person) => person.name);
```

Se a linguagem conseguir inferir o tipo que você deseja para um parâmetro em uma
expressão de função, não anote. Em casos raros, o contexto circundante não é
preciso o suficiente para fornecer um tipo para um ou mais parâmetros da função.
Nesses casos, pode ser necessário anotar. (Se a função não for usada
imediatamente, geralmente é melhor
[transformá-la em uma declaração nomeada][named local]).

[named local]: usage#do-use-a-function-declaration-to-bind-a-function-to-a-name

### NÃO anote tipos de parâmetros formais de inicialização {:#dont-type-annotate-initializing-formals}

{% render 'linter-rule-mention.md', rules:'type_init_formals' %}

Se um parâmetro de construtor estiver usando `this.` para inicializar um campo,
ou `super.` para encaminhar um super parâmetro,
o tipo do parâmetro é inferido
para ter o mesmo tipo que o campo
ou parâmetro super-construtor, respectivamente.

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


### USE escrever argumentos de tipo em invocações genéricas que não são inferidas {:#do-write-type-arguments-on-generic-invocations-that-arent-inferred}

O Dart é bastante inteligente em inferir argumentos de tipo em invocações
genéricas. Ele analisa o tipo esperado onde a expressão ocorre e os tipos de
valores sendo passados para a invocação. No entanto, às vezes isso não é
suficiente para determinar totalmente um argumento de tipo. Nesse caso, escreva
toda a lista de argumentos de tipo explicitamente.

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

Às vezes, a invocação ocorre como inicializador de uma declaração de variável.
Se a variável *não* for local, então, em vez de escrever a lista de argumentos
de tipo na própria invocação, você pode colocar uma anotação de tipo na declaração:

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

Anotar a variável também aborda esta diretriz porque agora os argumentos de tipo
*são* inferidos.


### NÃO escreva argumentos de tipo em invocações genéricas que são inferidas {:#dont-write-type-arguments-on-generic-invocations-that-are-inferred}

Este é o inverso da regra anterior. Se a lista de argumentos de tipo de uma
invocação *é* inferida corretamente com os tipos que você deseja, omita os
tipos e deixe o Dart fazer o trabalho para você.

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

Aqui, a anotação de tipo no campo fornece um contexto circundante para inferir
o argumento de tipo da chamada do construtor no inicializador.

<?code-excerpt "design_good.dart (explicit)"?>
```dart tag=good
var items = Future.value([1, 2, 3]);
```

<?code-excerpt "design_bad.dart (explicit)"?>
```dart tag=bad
var items = Future<List<int>>.value(<int>[1, 2, 3]);
```

Aqui, os tipos da coleção e da instância podem ser inferidos de baixo para cima
de seus elementos e argumentos.


### EVITE escrever tipos genéricos incompletos {:#avoid-writing-incomplete-generic-types}

O objetivo de escrever uma anotação de tipo ou argumento de tipo é definir um
tipo completo. No entanto, se você escrever o nome de um tipo genérico, mas
omitir seus argumentos de tipo, você não especificou totalmente o tipo. Em Java,
eles são chamados de "tipos raw" (brutos). Por exemplo:

<?code-excerpt "design_bad.dart (incomplete-generic)" replace="/List|Map/[!$&!]/g"?>
```dart tag=bad
[!List!] numbers = [1, 2, 3];
var completer = Completer<[!Map!]>();
```

Aqui, `numbers` tem uma anotação de tipo, mas a anotação não fornece um
argumento de tipo para a `List` genérica. Da mesma forma, o argumento de tipo
`Map` para `Completer` não está totalmente especificado. Em casos como este, o
Dart *não* tentará "preencher" o resto do tipo para você usando o contexto
circundante. Em vez disso, ele preenche silenciosamente todos os argumentos de
tipo ausentes com `dynamic` (ou o limite, se a classe tiver um). Raramente é isso que você quer.

Em vez disso, se você estiver escrevendo um tipo genérico em uma anotação de
tipo ou como um argumento de tipo dentro de alguma invocação, certifique-se de escrever um tipo completo:

<?code-excerpt "design_good.dart (incomplete-generic)"?>
```dart tag=good
List<num> numbers = [1, 2, 3];
var completer = Completer<Map<String, int>>();
```


### USE anotar com `dynamic` em vez de deixar a inferência falhar {:#do-annotate-with-dynamic-instead-of-letting-inference-fail}

Quando a inferência não preenche um tipo, ela geralmente assume como padrão
`dynamic`. Se `dynamic` é o tipo que você quer, esta é tecnicamente a maneira
mais concisa de obtê-lo. No entanto, não é a maneira mais *clara*. Um leitor
casual de seu código que vê que uma anotação está faltando não tem como saber se
você pretendia que fosse `dynamic`, esperava que a inferência preenchesse algum
outro tipo ou simplesmente se esqueceu de escrever a anotação.

Quando `dynamic` é o tipo que você deseja, escreva isso explicitamente para
deixar sua intenção clara e destacar que este código tem menos segurança estática.

<?code-excerpt "design_good.dart (prefer-dynamic)"?>
```dart tag=good
dynamic mergeJson(dynamic original, dynamic changes) => ...
```

<?code-excerpt "design_bad.dart (prefer-dynamic)"?>
```dart tag=bad
mergeJson(original, changes) => ...
```

Observe que não há problema em omitir o tipo quando o Dart infere *com sucesso* `dynamic`.

<?code-excerpt "design_good.dart (infer-dynamic)"?>
```dart tag=good
Map<String, dynamic> readJson() => ...

void printUsers() {
  var json = readJson();
  var users = json['users'];
  print(users);
}
```

Aqui, Dart infere `Map<String, dynamic>` para `json` e, a partir disso, infere
`dynamic` para `users`. Não há problema em deixar `users` sem uma anotação de
tipo. A distinção é um pouco sutil. Não há problema em permitir que a inferência
*propague* `dynamic` por meio de seu código a partir de uma anotação de tipo
`dynamic` em outro lugar, mas você não quer que ele injete uma anotação de tipo
`dynamic` em um lugar onde seu código não especificou uma.

:::note
Com o forte sistema de tipos e inferência de tipos do Dart, os usuários esperam
que o Dart se comporte como uma linguagem estaticamente tipada inferida. Com
esse modelo mental,
é uma surpresa desagradável descobrir que uma região de
código perdeu silenciosamente toda a segurança
e o desempenho dos tipos estáticos.
:::

**Exceção**: Anotações de tipo em parâmetros não utilizados (`_`) podem ser
omitidas.
### PREFIRA assinaturas em anotações de tipo de função {:#prefer-signatures-in-function-type-annotations}

O identificador `Function` sozinho, sem nenhum tipo de retorno ou assinatura de
parâmetro, refere-se ao tipo especial [Function][Function]. Este tipo é apenas
marginalmente mais útil do que usar `dynamic`. Se você for usar anotações,
prefira um tipo de função completo que inclua os parâmetros e o tipo de retorno
da função.

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

**Exceção:** Às vezes, você quer um tipo que represente a união de múltiplos
tipos de função diferentes. Por exemplo, você pode aceitar uma função que recebe
um parâmetro ou uma função que recebe dois. Como não temos tipos de união, não
há como tipar isso precisamente e você normalmente teria que usar `dynamic`.
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


### NÃO especifique um tipo de retorno para um setter {:#dont-specify-a-return-type-for-a-setter}

{% render 'linter-rule-mention.md', rules:'avoid_return_types_on_setters' %}

Setters sempre retornam `void` em Dart. Escrever a palavra é inútil.

<?code-excerpt "design_bad.dart (avoid_return_types_on_setters)"?>
```dart tag=bad
void set foo(Foo value) { ... }
```

<?code-excerpt "design_good.dart (avoid_return_types_on_setters)"?>
```dart tag=good
set foo(Foo value) { ... }
```


### NÃO use a sintaxe legada de `typedef` {:#dont-use-the-legacy-typedef-syntax}

{% render 'linter-rule-mention.md', rules:'prefer_generic_function_type_aliases' %}

Dart tem duas notações para definir um `typedef` nomeado para um tipo de função.
A sintaxe original parece com:

<?code-excerpt "design_bad.dart (old-typedef)"?>
```dart tag=bad
typedef int Comparison<T>(T a, T b);
```

Essa sintaxe tem alguns problemas:

* Não há como atribuir um nome a um tipo de função *genérico*. No exemplo
  acima, o próprio `typedef` é genérico. Se você referenciar `Comparison` em
  seu código, sem um argumento de tipo, você implicitamente obterá o tipo de
  função `int Function(dynamic, dynamic)`, *não* `int Function<T>(T, T)`.
  Isso não acontece na prática com frequência, mas importa em certos casos específicos.

* Um único identificador em um parâmetro é interpretado como o *nome* do
  parâmetro, não seu *tipo*. Dado:

    <?code-excerpt "design_bad.dart (typedef-param)"?>
    ```dart tag=bad
    typedef bool TestNumber(num);
    ```

    A maioria dos usuários espera que isso seja um tipo de função que recebe um
    `num` e retorna `bool`. Na verdade, é um tipo de função que recebe *qualquer*
    objeto (`dynamic`) e retorna `bool`. O *nome* do parâmetro (que não é usado
    para nada, exceto documentação no `typedef`) é "num". Essa tem sido uma
    fonte de erros de longa data em Dart.

A nova sintaxe se parece com isso:

<?code-excerpt "design_good.dart (new-typedef)"?>
```dart tag=good
typedef Comparison<T> = int Function(T, T);
```

Se você quiser incluir o nome de um parâmetro, você também pode fazer isso:

<?code-excerpt "design_good.dart (new-typedef-param-name)"?>
```dart tag=good
typedef Comparison<T> = int Function(T a, T b);
```

A nova sintaxe pode expressar qualquer coisa que a sintaxe antiga poderia
expressar e mais, e não tem a falha propensa a erros onde um único identificador
é tratado como o nome do parâmetro em vez de seu tipo. A mesma sintaxe de tipo
de função após o `=` no `typedef` também é permitida em qualquer lugar onde uma
anotação de tipo pode aparecer, nos dando uma única forma consistente de escrever tipos de função em qualquer lugar em um programa.

A sintaxe antiga de `typedef` ainda é suportada para evitar quebrar o código
existente, mas está obsoleta.


### PREFIRA tipos de função inline em vez de typedefs {:#prefer-inline-function-types-over-typedefs}

{% render 'linter-rule-mention.md', rules:'avoid_private_typedef_functions' %}

Em Dart, se você quiser usar um tipo de função para um campo, variável ou
argumento de tipo genérico, você pode definir um `typedef` para o tipo de
função. No entanto, Dart suporta uma sintaxe de tipo de função inline que
pode ser usada em qualquer lugar onde uma anotação de tipo é permitida:

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

Ainda pode valer a pena definir um `typedef` se o tipo de função for
particularmente longo ou usado com frequência. Mas, na maioria dos casos, os
usuários querem ver qual é o tipo de função realmente onde ele é usado, e a
sintaxe do tipo de função oferece essa clareza.


### PREFIRA usar a sintaxe de tipo de função para parâmetros {:#prefer-using-function-type-syntax-for-parameters}

{% render 'linter-rule-mention.md', rules:'use_function_type_syntax_for_parameters' %}

Dart tem uma sintaxe especial ao definir um parâmetro cujo tipo é uma função.
Parecido com C, você envolve o nome do parâmetro com o tipo de retorno da função
e a assinatura do parâmetro:

<?code-excerpt "design_bad.dart (function-type-param)"?>
```dart
Iterable<T> where(bool predicate(T element)) => ...
```

Antes de Dart adicionar a sintaxe de tipo de função, esta era a única maneira de
dar a um parâmetro um tipo de função sem definir um `typedef`. Agora que Dart tem
uma notação geral para tipos de função, você também pode usá-la para parâmetros
com tipo de função:

<?code-excerpt "design_good.dart (function-type-param)"?>
```dart tag=good
Iterable<T> where(bool Function(T) predicate) => ...
```

A nova sintaxe é um pouco mais verbosa, mas é consistente com outros locais
onde você deve usar a nova sintaxe.


### EVITE usar `dynamic` a menos que você queira desativar a verificação estática {:#avoid-using-dynamic-unless-you-want-to-disable-static-checking}

Algumas operações funcionam com qualquer objeto possível. Por exemplo, um método
`log()` poderia receber qualquer objeto e chamar `toString()` nele. Dois tipos
em Dart permitem todos os valores: `Object?` e `dynamic`. No entanto, eles
transmitem coisas diferentes. Se você simplesmente quer declarar que permite
todos os objetos, use `Object?`. Se você quiser permitir todos os objetos *exceto* `null`, então use `Object`.

O tipo `dynamic` não apenas aceita todos os objetos, mas também permite todas as
*operações*. Qualquer acesso a um membro em um valor do tipo `dynamic` é
permitido em tempo de compilação, mas pode falhar e lançar uma exceção em tempo
de execução. Se você quer exatamente esse dispatch dinâmico arriscado, mas
flexível, então `dynamic` é o tipo certo para usar.

Caso contrário, prefira usar `Object?` ou `Object`.
Confie nas verificações
`is` e na promoção de tipo para garantir que o tipo de tempo de execução do
valor suporte o membro que você deseja acessar antes de acessá-lo.

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
`dynamic`, especialmente dentro de um tipo genérico. Por exemplo, objetos JSON
têm o tipo `Map<String, dynamic>` e seu código precisará aceitar esse mesmo
tipo. Mesmo assim, ao usar um valor de uma dessas APIs, geralmente é uma boa
ideia convertê-lo para um tipo mais preciso antes de acessar os membros.


### USE `Future<void>` como o tipo de retorno de membros assíncronos que não produzem valores {:#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values}

Quando você tem uma função síncrona que não retorna um valor, você usa `void`
como o tipo de retorno. O equivalente assíncrono para um método que não produz
um valor, mas que o chamador pode precisar esperar (await), é `Future<void>`.

Você pode ver um código que usa `Future` ou `Future<Null>` em vez disso porque
versões mais antigas de Dart não permitiam `void` como um argumento de tipo.
Agora que permite, você deve usá-lo. Fazer isso corresponde mais diretamente a
como você tiparia uma função síncrona semelhante e oferece melhor verificação
de erros para chamadores e no corpo da função.

Para funções assíncronas que não retornam um valor útil e onde nenhum chamador
precisa aguardar o trabalho assíncrono ou lidar com uma falha assíncrona, use um
tipo de retorno de `void`.


### EVITE usar `FutureOr<T>` como um tipo de retorno {:#avoid-using-futureort-as-a-return-type}

Se um método aceita um `FutureOr<int>`, ele é [generoso no que ele
aceita][postel]. Os usuários podem chamar o método com um `int` ou um
`Future<int>`, então eles não precisam embrulhar um `int` em `Future` que você
vai desembrulhar de qualquer maneira.

[postel]: https://en.wikipedia.org/wiki/Robustness_principle

Se você *retornar* um `FutureOr<int>`, os usuários precisam verificar se eles
recebem um `int` ou um `Future<int>` antes que eles possam fazer qualquer coisa
útil. (Ou eles simplesmente usarão `await` no valor, efetivamente sempre
tratando-o como um `Future`.) Apenas retorne um `Future<int>`, é mais limpo. É
mais fácil para os usuários entenderem que uma função é sempre assíncrona ou
sempre síncrona, mas uma função que pode ser qualquer uma é difícil de usar corretamente.

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

A formulação mais precisa desta diretriz é *usar `FutureOr<T>` apenas em
posições [contravariantes][contravariant].* Os parâmetros são contravariantes e os tipos de
retorno são covariantes. Em tipos de função aninhados, isso é invertido — se
você tem um parâmetro cujo tipo é ele mesmo uma função, então o tipo de retorno
do callback agora está em posição contravariante e os parâmetros do callback
são covariantes. Isso significa que está tudo bem para o tipo de *callback* retornar `FutureOr<T>`:

[contravariant]: https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)

<?code-excerpt "design_good.dart (future-or-contra)" replace="/FutureOr.S./[!$&!]/g"?>
```dart tag=good
Stream<S> asyncMap<T, S>(
    Iterable<T> iterable, [!FutureOr<S>!] Function(T) callback) async* {
  for (final element in iterable) {
    yield await callback(element);
  }
}
```


## Parâmetros {:#parameters}

Em Dart, parâmetros opcionais podem ser posicionais ou nomeados, mas não ambos.


### EVITE parâmetros booleanos posicionais {:#avoid-positional-boolean-parameters}

{% render 'linter-rule-mention.md', rules:'avoid_positional_boolean_parameters' %}

Ao contrário de outros tipos, os booleanos geralmente são usados em forma literal.
Valores como números geralmente são envolvidos em constantes nomeadas, mas
normalmente passamos `true` e `false` diretamente. Isso pode tornar os locais de
chamada ilegíveis se não estiver claro o que o booleano representa:

```dart tag=bad
new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
```

Em vez disso, prefira usar argumentos nomeados, construtores nomeados ou
constantes nomeadas para esclarecer o que a chamada está fazendo.

<?code-excerpt "design_good.dart (avoid-positional-bool-param)"?>
```dart tag=good
Task.oneShot();
Task.repeating();
ListBox(scroll: true, showScrollbars: true);
Button(ButtonState.enabled);
```

Note que isso não se aplica a setters, onde o nome deixa claro o que o valor
representa:

```dart tag=good
listBox.canScroll = true;
button.isEnabled = false;
```


### EVITE parâmetros posicionais opcionais se o usuário quiser omitir parâmetros anteriores {:#avoid-optional-positional-parameters-if-the-user-may-want-to-omit-earlier-parameters}

Os parâmetros posicionais opcionais devem ter uma progressão lógica de forma que
os parâmetros anteriores sejam passados com mais frequência do que os posteriores.
Os usuários quase nunca devem precisar passar explicitamente um "buraco" para
omitir um argumento posicional anterior para passar um posterior. É melhor usar argumentos nomeados para isso.

<?code-excerpt "design_good.dart (omit-optional-positional)"?>
```dart tag=good
String.fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]);

DateTime(int year,
    [int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0]);

Duration(
    {int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0});
```


### EVITE parâmetros obrigatórios que aceitam um valor especial "sem argumento" {:#avoid-mandatory-parameters-that-accept-a-special-no-argument-value}

Se o usuário está logicamente omitindo um parâmetro, prefira deixá-lo realmente
omitir, tornando o parâmetro opcional em vez de forçá-lo a passar `null`, uma
string vazia ou algum outro valor especial que significa "não passou".

Omitir o parâmetro é mais conciso e ajuda a evitar bugs onde um valor sentinela
como `null` é passado acidentalmente quando o usuário pensou que estava
fornecendo um valor real.

<?code-excerpt "design_good.dart (avoid-mandatory-param)"?>
```dart tag=good
var rest = string.substring(start);
```

<?code-excerpt "design_bad.dart (avoid-mandatory-param)"?>
```dart tag=bad
var rest = string.substring(start, null);
```


### USE parâmetros de início inclusivo e fim exclusivo para aceitar um intervalo {:#do-use-inclusive-start-and-exclusive-end-parameters-to-accept-a-range}

Se você está definindo um método ou função que permite que um usuário selecione
um intervalo de elementos ou itens de alguma sequência indexada por inteiro, use
um índice inicial, que se refere ao primeiro item e um índice final (provavelmente
opcional) que é um maior que o índice do último item.

Isso é consistente com as bibliotecas principais que fazem a mesma coisa.

<?code-excerpt "../../test/effective_dart_test.dart (param-range)" replace="/expect\(//g; /, \/\*\*\// \/\//g; /\);//g"?>
```dart tag=good
[0, 1, 2, 3].sublist(1, 3) // [1, 2]
'abcd'.substring(1, 3) // 'bc'
```

É particularmente importante ser consistente aqui porque esses parâmetros
geralmente não são nomeados. Se sua API usa um comprimento em vez de um ponto
final, a diferença não será visível no local da chamada.


## Igualdade {:#equality}

Implementar um comportamento de igualdade personalizado para uma classe pode ser
complicado. Os usuários têm uma intuição profunda sobre como a igualdade
funciona que seus objetos precisam corresponder, e os tipos de coleção como
tabelas hash têm contratos sutis que esperam que os elementos sigam.

### SOBRESCREVA `hashCode` se você sobrescrever `==` {:#do-override-hashcode-if-you-override}

{% render 'linter-rule-mention.md', rules:'hash_and_equals' %}

A implementação de código hash padrão fornece um hash de *identidade*—dois
objetos geralmente só têm o mesmo código hash se forem exatamente o mesmo
objeto. Da mesma forma, o comportamento padrão para `==` é identidade.

Se você está sobrescrevendo `==`, isso implica que você pode ter objetos
diferentes que são considerados "iguais" pela sua classe. **Quaisquer dois
objetos que são iguais devem ter o mesmo código hash.** Caso contrário, mapas e
outras coleções baseadas em hash não reconhecerão que os dois objetos são equivalentes.

### FAÇA com que seu operador `==` obedeça às regras matemáticas de igualdade {:#do-make-your-operator-obey-the-mathematical-rules-of-equality}

Uma relação de equivalência deve ser:

* **Reflexiva**: `a == a` deve sempre retornar `true`.

* **Simétrica**: `a == b` deve retornar a mesma coisa que `b == a`.

* **Transitiva**: Se `a == b` e `b == c` retornarem `true`, então `a == c`
  também deve retornar.

Usuários e códigos que usam `==` esperam que todas essas leis sejam seguidas. Se
sua classe não puder obedecer a essas regras, então `==` não é o nome certo para
a operação que você está tentando expressar.

### EVITE definir igualdade personalizada para classes mutáveis {:#avoid-defining-custom-equality-for-mutable-classes}

{% render 'linter-rule-mention.md', rules:'avoid_equals_and_hash_code_on_mutable_classes' %}

Quando você define `==`, você também tem que definir `hashCode`. Ambos devem
levar em consideração os campos do objeto. Se esses campos *mudam*, isso
implica que o código hash do objeto pode mudar.

A maioria das coleções baseadas em hash não antecipa isso — elas assumem que o
código hash de um objeto será o mesmo para sempre e podem se comportar de forma
imprevisível se isso não for verdade.

### NÃO torne o parâmetro para `==` anulável {:#dont-make-the-parameter-to-nullable}

{% render 'linter-rule-mention.md', rules:'avoid_null_checks_in_equality_operators' %}

A linguagem especifica que `null` é igual apenas a si mesmo e que o método `==`
é chamado apenas se o lado direito não for `null`.

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
