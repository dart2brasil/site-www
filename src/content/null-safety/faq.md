---
title: "Null safety: Frequently asked questions"
description: FAQs to help you migrate your Dart code to null safety
shortTitle: FAQ (null safety)
---

Esta página reúne algumas perguntas comuns que ouvimos sobre [null safety](/null-safety) (segurança nula)
com base na experiência de migração do código interno do Google.

## Quais mudanças de tempo de execução (runtime) devo estar ciente para usuários de código migrado? {:#what-runtime-changes-should-i-be-aware-of-for-users-of-migrated-code}

A maioria dos efeitos da migração não afeta imediatamente os usuários do código
migrado:

-   As verificações estáticas de null safety para usuários se aplicam primeiro quando eles migram seu
    código.
-   As verificações completas de null safety acontecem quando todo o código é migrado e o modo
    sound (sólido) é ativado.

Duas exceções a serem observadas são:

-   O operador `!` é uma verificação de nulo em tempo de execução (runtime) em todos os modos,
    para todos os usuários. Portanto, ao migrar, certifique-se de adicionar `!` apenas onde for um erro para um
    `null` fluir para esse local, mesmo que o código de chamada ainda não
    tenha migrado.
-   Verificações de tempo de execução (runtime) associadas à palavra-chave `late` aplicam-se em todos os modos, para
    todos os usuários. Marque um campo como `late` apenas se tiver certeza de que ele sempre será inicializado
    antes de ser usado.

## E se um valor for `null` apenas nos testes? {:#what-if-a-value-is-only-null-in-tests}

Se um valor for `null` apenas nos testes, o código poderá ser aprimorado marcando-o
como não anulável e fazendo com que os testes passem valores não nulos.

## Como `@required` se compara à nova palavra-chave `required`? {:#how-does-required-compare-to-the-new-required-keyword}

A anotação `@required` marca argumentos nomeados que devem ser passados; caso contrário,
o analisador relata uma dica.

Com null safety, um argumento nomeado com um tipo não anulável deve ter um
valor padrão ou ser marcado com a nova palavra-chave `required` (requerido). Caso contrário, não faria
sentido que fosse não anulável, porque ele teria como padrão `null` quando
não fosse passado.

Quando o código null safe é chamado de código legado, a palavra-chave `required` é tratada
exatamente como a anotação `@required`: a falha ao fornecer o argumento causará
uma dica do analisador.

Quando o código null safe é chamado a partir de código null safe, a falha ao fornecer um
argumento `required` é um erro.

O que isso significa para a migração? Tenha cuidado ao adicionar `required` onde não
havia `@required` antes. Quaisquer chamadores que não passarem o argumento recém-requerido
não serão mais compilados. Em vez disso, você pode adicionar um valor padrão ou tornar o argumento
o tipo anulável.

## Como devo migrar campos não anuláveis que deveriam ser `final`, mas não são? {:#how-should-i-migrate-non-nullable-fields-that-should-be-final-but-arent}

Alguns cálculos podem ser movidos para o inicializador estático. Em vez de:

```dart tag=bad
// Inicializado sem valores
ListQueue _context;
Float32List _buffer;
dynamic _readObject;

Vec2D(Map<String, dynamic> object) {
  _buffer = Float32List.fromList([0.0, 0.0]);
  _readObject = object['container'];
  _context = ListQueue<dynamic>();
}
```

você pode fazer:

```dart tag=good
// Inicializado com valores
final ListQueue _context = ListQueue<dynamic>();
final Float32List _buffer = Float32List.fromList([0.0, 0.0]);
final dynamic _readObject;

Vec2D(Map<String, dynamic> object) : _readObject = object['container'];
```

No entanto, se um campo for inicializado por meio de cálculo no construtor, então
ele não pode ser `final`. Com null safety, você descobrirá que isso também torna mais difícil
que ele seja não anulável; se for inicializado muito tarde, ele será `null` até que seja
inicializado e deve ser anulável. Felizmente, você tem opções:

-   Transforme o construtor em uma factory (fábrica), depois faça com que ele delegue a um construtor real
    que inicializa todos os campos diretamente. Um nome comum para esse
    construtor privado é apenas um sublinhado: `_`. Então, o campo pode ser
    `final` e não anulável. Essa refatoração pode ser feita *antes* da
    migração para null safety.
-   Ou, marque o campo como `late final`. Isso garante que ele seja inicializado exatamente
    uma vez. Ele deve ser inicializado antes que possa ser lido.

## Como devo migrar uma classe `built_value`? {:#how-should-i-migrate-a-built-value-class}

Getters que foram anotados com `@nullable` devem, em vez disso, ter tipos anuláveis; então
remova todas as anotações `@nullable`. Por exemplo:

```dart
@nullable
int get count;
```

torna-se

```dart
int? get count; //  Variável inicializada com ?
```

Getters que *não* foram marcados com `@nullable` *não* devem ter tipos anuláveis,
mesmo que a ferramenta de migração os sugira. Adicione as dicas `!` conforme necessário e execute novamente o
a análise.

## Como devo migrar uma factory que pode retornar `null`? {:#how-should-i-migrate-a-factory-that-can-return-null}

_Prefira factories que não retornem nulo._ Vimos código que pretendia
lançar uma exceção devido a entrada inválida, mas acabou retornando nulo.

Em vez de:

```dart tag=bad
  factory StreamReader(dynamic data) {
    StreamReader reader;
    if (data is ByteData) {
      reader = BlockReader(data);
    } else if (data is Map) {
      reader = JSONBlockReader(data);
    }
    return reader;
  }
```

Faça:

```dart tag=good
  factory StreamReader(dynamic data) {
    if (data is ByteData) {
      // Move o readIndex para frente para o leitor binário.
      return BlockReader(data);
    } else if (data is Map) {
      return JSONBlockReader(data);
    } else {
      throw ArgumentError('Tipo inesperado para data');
    }
  }
```


Se a intenção da factory era realmente retornar nulo, você pode transformá-la
em um método estático para que seja permitido retornar `null`.

## Como devo migrar um `assert(x != null)` que agora aparece como desnecessário? {:#how-should-i-migrate-an-assert-x-null-that-now-shows-as-unnecessary}

O assert será desnecessário quando tudo estiver totalmente migrado, mas por enquanto
*é* necessário se você realmente quiser manter a verificação. Opções:

-   Decida que o assert não é realmente necessário e remova-o. Esta é uma
    mudança no comportamento quando os asserts estão habilitados.
-   Decida que o assert pode ser verificado sempre e transforme-o em
    `ArgumentError.checkNotNull`. Esta é uma mudança no comportamento quando os asserts não são
    habilitados.
-   Mantenha o comportamento exatamente como está: adicione `// ignore:
    unnecessary_null_comparison` para ignorar o aviso.

## Como devo migrar uma verificação de nulo em tempo de execução (runtime) que agora aparece como desnecessária? {:#how-should-i-migrate-a-runtime-null-check-that-now-shows-as-unnecessary}

O compilador sinaliza uma verificação de nulo explícita em tempo de execução (runtime) como uma
comparação desnecessária se você tornar `arg` não anulável.

```dart
if (arg == null) throw ArgumentError(...)`
```

Você deve incluir esta verificação se o programa for de versão mista.
Até que tudo esteja totalmente migrado e o código mude para ser executado
com sound null safety (segurança nula sólida), `arg` pode ser definido como `null`.

A maneira mais simples de preservar o comportamento é alterar a verificação para
[`ArgumentError.checkNotNull`]({{site.dart-api}}/dart-core/ArgumentError/checkNotNull.html).

O mesmo se aplica a algumas verificações de tipo de tempo de execução (runtime). Se `arg`
tiver o tipo estático `String`, então `if (arg is! String)` está realmente verificando
se `arg` é `null`. Pode parecer que a migração para null safety significa que `arg`
nunca pode ser `null`, mas poderia ser `null` em unsound null safety (segurança nula não sólida). Portanto, para preservar
o comportamento, a verificação nula deve permanecer.

## O método `Iterable.firstWhere` não aceita mais `orElse: () => null`. {:#the-iterable-firstwhere-method-no-longer-accepts-orelse-null}

Importe `package:collection` e use o método de extensão `firstWhereOrNull`
em vez de `firstWhere`.

## Como lido com atributos que possuem setters? {:#how-do-i-deal-with-attributes-that-have-setters}

Ao contrário da sugestão `late final` acima, esses atributos não podem ser marcados como
final. Frequentemente, atributos que podem ser definidos também não têm valores iniciais, pois eles
devem ser definidos em algum momento posterior.

Nesses casos, você tem duas opções:

-   Defina-o como um valor inicial. Muitas vezes, a omissão de um valor inicial é
    por engano, em vez de deliberada.
-   Se você tem *certeza* de que o atributo precisa ser definido antes de ser acessado, marque
    como `late`.

    AVISO: A palavra-chave `late` adiciona uma verificação de tempo de execução (runtime). Se algum usuário chamar `get`
    antes de `set`, ele receberá um erro em tempo de execução (runtime).

## Como sinalizo que o valor de retorno de um Map é não anulável? {:#how-do-i-signal-that-the-return-value-from-a-map-is-non-nullable}

O
[operador de pesquisa]({{site.dart-api}}/dart-core/Map/operator_get.html)
em Map (`[]`) por padrão retorna um tipo anulável. Não há como sinalizar para
a linguagem que o valor tem garantia de estar lá.

In this case, you should use the not-null assertion operator (`!`) to
cast the value back to `V`:

```dart
return blockTypes[key]!;
```

O que lançará um erro se o mapa retornar nulo. Se você quiser um tratamento explícito para esse caso:

```dart
var result = blockTypes[key];
if (result != null) return result;
// Lidar com o caso nulo aqui, por exemplo, lançar com explicação.
```

## Por que o tipo genérico na minha List/Map é anulável? {:#why-is-the-generic-type-on-my-list-map-nullable}

Normalmente, é um código com cheiro ruim acabar com código anulável como este:

```dart tag=bad
List<Foo?> fooList; // fooList pode conter valores nulos
```

Isso implica que `fooList` pode conter valores nulos. Isso pode acontecer se você estiver
inicializando a lista com um tamanho e preenchendo-a por meio de um loop.

Se você estiver simplesmente inicializando a lista com o mesmo valor,
você deve,
em vez disso, use o construtor
[`filled`]({{site.dart-api}}/dart-core/List/List.filled.html).

```dart tag=bad
_jellyCounts = List<int?>(jellyMax + 1);
for (var i = 0; i <= jellyMax; i++) {
  _jellyCounts[i] = 0; // Lista inicializada com o mesmo valor
}
```

```dart tag=good
_jellyCounts = List<int>.filled(jellyMax + 1, 0); // Lista inicializada com o construtor filled
```

Se você estiver definindo os elementos da lista por meio de um índice, ou se estiver preenchendo
cada elemento da lista com um valor distinto, você deve, em vez disso, usar
a sintaxe literal da lista para construir a lista.

```dart tag=bad
_jellyPoints = List<Vec2D?>(jellyMax + 1);
for (var i = 0; i <= jellyMax; i++) {
  _jellyPoints[i] = Vec2D(); // Cada elemento da lista é um Vec2D distinto
}
```

```dart tag=good
_jellyPoints = [
  for (var i = 0; i <= jellyMax; i++)
    Vec2D() // Cada elemento da lista é um Vec2D distinto
];
```

Para gerar uma lista de tamanho fixo,
use o construtor [`List.generate`][] com o parâmetro `growable`
definido como `false`:

```dart
_jellyPoints = List.generate(jellyMax, (_) => Vec2D(), growable: false);
```

[`List.generate`]: {{site.dart-api}}/dart-core/List/List.generate.html

{% comment %}
  Preferivelmente, sugiro uma sintaxe de linguagem aqui,
  que está sendo sugerida em https://github.com/dart-lang/language/issues/2477.
{% endcomment %}

## O que aconteceu com o construtor List padrão? {:#what-happened-to-the-default-list-constructor}

Você pode encontrar este erro:

```plaintext
O construtor 'List' padrão não está disponível quando o null safety está habilitado. #default_list_constructor
```

O construtor de lista padrão preenche a lista com `null`, o que é um problema.

Altere-o para `List.filled(length, default)` em vez disso.

## Estou usando `package:ffi` e obtenho uma falha com `Dart_CObject_kUnsupported` quando migro. O que aconteceu? {:#i-m-using-package-ffi-and-get-a-failure-with-dart-cobject-kunsupported-when-i-migrate-what-happened}

Listas enviadas via ffi só podem ser `List<dynamic>`, não `List<Object>` ou
`List<Object?>`. Se você não alterou um tipo de lista explicitamente na sua migração,
um tipo ainda pode ter mudado devido a alterações na inferência de tipo que ocorrem
quando você habilita o null safety.

A correção é criar explicitamente essas listas como `List<dynamic>`.

## Por que a ferramenta de migração adiciona comentários ao meu código? {:#migration-comments}

A ferramenta de migração adiciona comentários `/* == false */` ou `/* == true */` quando ela
vê condições que sempre serão falsas ou verdadeiras durante a execução no modo sound.
Comentários como esses podem indicar que a migração automática está incorreta e
precisa de intervenção humana. Por exemplo:

```dart
if (registry.viewFactory(viewDescriptor.id) == null /* == false */)
```

Nesses casos, a ferramenta de migração não consegue distinguir situações de codificação defensiva
e situações onde um valor nulo é realmente esperado. Então, a ferramenta diz a você o que
ela sabe ("parece que essa condição sempre será falsa!") e permite que você
decida o que fazer.

## O que devo saber sobre a compilação para JavaScript e null safety? {:#what-should-i-know-about-compiling-to-javascript-and-null-safety}

O null safety traz muitos benefícios, como tamanho de código reduzido e desempenho de aplicativo aprimorado.
Esses benefícios aparecem mais quando compilados para alvos nativos como Flutter e AOT.
O trabalho anterior no compilador web de produção havia introduzido otimizações semelhantes
ao que o null safety introduziu posteriormente. Isso pode fazer com que os ganhos resultantes
para aplicativos web de produção pareçam menores
do que seus alvos nativos.

Algumas notas que vale a pena destacar:

* The production JavaScript compiler generates `!` not-null assertions.
  You might not notice them when comparing the output of the compiler
  before and after adding not-null assertions.
  That's because the compiler already
  generated null checks in programs that weren't null safe.

* The compiler generates these not-null assertions regardless of the
  soundness of null safety or optimization level. In fact, the compiler
  doesn't remove `!` when using `-O3` or `--omit-implicit-checks`.

* O compilador JavaScript de produção pode remover verificações nulas desnecessárias.
  Isso acontece porque as otimizações que o compilador web de produção
  fez antes do null safety removeu essas verificações quando ele
  sabia que o valor não era nulo.

* Por padrão, o compilador geraria verificações de subtipo de parâmetro.
  Essas verificações em tempo de execução (runtime) garantem que as chamadas virtuais covariantes tenham
  argumentos apropriados. O compilador ignora essas verificações com a
  opção `--omit-implicit-checks`. Usar esta opção pode gerar aplicativos
  com comportamento inesperado se o código incluir tipos inválidos.
  Para evitar surpresas, continue fornecendo uma forte cobertura de teste
  para seu código. Em particular, o compilador otimiza o código com base
  no fato de que as entradas devem estar em conformidade com a declaração de tipo. Se
  o código fornecer argumentos de um tipo inválido, essas otimizações
  estariam incorretas e o programa poderia se comportar mal. Isso era verdade para
  tipos inconsistentes antes, e é verdade com inconsistências
  nulabilidades agora com sound null-safety.

* Você pode notar que o compilador JavaScript de desenvolvimento e a Dart
  VM têm mensagens de erro especiais para verificações nulas, mas para manter
  aplicativos pequenos, o compilador JavaScript de produção não.

* Você pode ver erros indicando que `.toString` não foi encontrado em `null`.
  Isso não é um bug. O compilador sempre codificou algumas verificações nulas
  dessa forma. Ou seja, o compilador representa algumas verificações nulas
  de forma compacta, fazendo um acesso não protegido de uma propriedade do
  receptor. Portanto, em vez de `if (a == null) throw`, ele gera
  `a.toString`. O método `toString` é definido em JavaScript Object
  e é uma maneira rápida de verificar se um objeto não é nulo.

  Se a primeira ação após uma verificação nula for uma ação que falha
  quando o valor é nulo, o compilador pode remover a verificação nula e
  deixar a ação causar o erro.

  Por exemplo, uma expressão Dart `print(a!.foo());` pode se transformar diretamente
  em:

  ```js
    P.print(a.foo$0());
  ```

  Isso ocorre porque a chamada `a.foo$()` falhará se `a` for nulo.
  Se o compilador embutir `foo`, ele preservará a verificação nula.
  Então, por exemplo, se `foo` fosse `int foo() => 1;` o compilador poderia
  gerar:

  ```js
    a.toString;
    P.print(1);
  ```

  Se o método embutido acessasse primeiro um campo no receptor, como
  `int foo() => this.x + 1;`, então o compilador de produção pode remover
  a verificação nula `a.toString` redundante, como chamadas não embutidas, e
  gerar:

  ```js
    P.print(a.x + 1);
  ```

## Recursos {:#resources}

*   [DartPad com Null Safety]({{site.dartpad}})
*   [Sound null safety](/null-safety) (Segurança nula sólida)