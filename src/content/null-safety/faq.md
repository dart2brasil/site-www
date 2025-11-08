---
ia-translate: true
title: "Null safety: Perguntas frequentes"
description: FAQs para ajudá-lo a migrar seu código Dart para null safety
shortTitle: FAQ (null safety)
---

Esta página reúne algumas perguntas comuns que ouvimos sobre [null safety](/null-safety)
com base na experiência de migrar código interno do Google.

## Quais mudanças de runtime devo estar ciente para usuários de código migrado?

A maioria dos efeitos da migração não afeta imediatamente os usuários de código migrado:

-   Verificações estáticas de null safety para usuários só se aplicam quando eles migram seu
    código.
-   Verificações completas de null safety acontecem quando todo o código é migrado e o modo sound
    é ativado.

Duas exceções das quais estar ciente são:

-   O operador `!` é uma verificação de null em runtime em todos os modos, para todos os usuários. Então,
    ao migrar, certifique-se de adicionar `!` apenas onde é um erro para um
    `null` fluir para aquele local, mesmo que o código chamador ainda não tenha migrado.
-   Verificações de runtime associadas à keyword `late` se aplicam em todos os modos, para
    todos os usuários. Marque um campo como `late` apenas se você tiver certeza de que ele sempre é inicializado
    antes de ser usado.

## E se um valor for `null` apenas em testes?

Se um valor é `null` apenas em testes, o código pode ser melhorado marcando-o como
non-nullable e fazendo os testes passarem valores non-null.

## Como o `@required` se compara à nova keyword `required`?

A anotação `@required` marca argumentos nomeados que devem ser passados; caso contrário,
o analisador reporta uma dica.

Com null safety, um argumento nomeado com um tipo non-nullable deve ter um
valor padrão ou ser marcado com a nova keyword `required`. Caso contrário, não
faria sentido ser non-nullable, porque seria padronizado para `null` quando
não passado.

Quando código null safe é chamado de código legado, a keyword `required` é tratada
exatamente como a anotação `@required`: a falha em fornecer o argumento causará
uma dica do analisador.

Quando código null safe é chamado de código null safe, falhar em fornecer um
argumento `required` é um erro.

O que isso significa para a migração? Tenha cuidado ao adicionar `required` onde não
havia `@required` antes. Quaisquer chamadores que não passem o argumento recém-obrigatório
não compilarão mais. Em vez disso, você pode adicionar um padrão ou tornar o tipo do argumento
nullable.

## Como devo migrar campos non-nullable que deveriam ser `final`, mas não são?

Alguns cálculos podem ser movidos para o inicializador estático. Em vez de:

```dart tag=bad
// Initialized without values
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
// Initialized with values
final ListQueue _context = ListQueue<dynamic>();
final Float32List _buffer = Float32List.fromList([0.0, 0.0]);
final dynamic _readObject;

Vec2D(Map<String, dynamic> object) : _readObject = object['container'];
```

No entanto, se um campo é inicializado fazendo cálculo no construtor, então
ele não pode ser `final`. Com null safety, você descobrirá que isso também torna mais difícil
ser non-nullable; se for inicializado tarde demais, então é `null` até ser
inicializado, e deve ser nullable. Felizmente, você tem opções:

-   Transforme o construtor em uma factory, e então faça-a delegar para um construtor real
    que inicializa todos os campos diretamente. Um nome comum para tal
    construtor privado é apenas um sublinhado: `_`. Então, o campo pode ser
    `final` e non-nullable. Esta refatoração pode ser feita *antes* da
    migração para null safety.
-   Ou, marque o campo como `late final`. Isso garante que ele seja inicializado exatamente
    uma vez. Ele deve ser inicializado antes de poder ser lido.

## Como devo migrar uma classe `built_value`?

Getters que foram anotados com `@nullable` devem ter tipos nullable; então
remova todas as anotações `@nullable`. Por exemplo:

```dart
@nullable
int get count;
```

torna-se

```dart
int? get count; //  Variable initialized with ?
```

Getters que *não* foram marcados com `@nullable` *não* devem ter tipos nullable,
mesmo que a ferramenta de migração os sugira. Adicione dicas `!` conforme necessário e então execute novamente a
análise.

## Como devo migrar uma factory que pode retornar `null`?

_Prefira factories que não retornam null._ Vimos código que pretendia
lançar uma exceção devido a entrada inválida, mas acabou retornando null.

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
      // Move the readIndex forward for the binary reader.
      return BlockReader(data);
    } else if (data is Map) {
      return JSONBlockReader(data);
    } else {
      throw ArgumentError('Unexpected type for data');
    }
  }
```


Se a intenção da factory era realmente retornar null, então você pode transformá-la
em um método estático para que seja permitido retornar `null`.

## Como devo migrar um `assert(x != null)` que agora aparece como desnecessário?

O assert será desnecessário quando tudo estiver totalmente migrado, mas por enquanto ele
*é* necessário se você realmente quiser manter a verificação. Opções:

-   Decida que o assert não é realmente necessário e remova-o. Esta é uma
    mudança de comportamento quando asserts estão habilitados.
-   Decida que o assert pode ser verificado sempre e transforme-o em
    `ArgumentError.checkNotNull`. Esta é uma mudança de comportamento quando asserts não
    estão habilitados.
-   Mantenha o comportamento exatamente como está: adicione `// ignore:
    unnecessary_null_comparison` para contornar o aviso.

## Como devo migrar uma verificação de null em runtime que agora aparece como desnecessária?

O compilador sinaliza uma verificação explícita de null em runtime como uma comparação desnecessária
se você tornar `arg` non-nullable.

```dart
if (arg == null) throw ArgumentError(...)`
```

Você deve incluir esta verificação se o programa for de versão mista.
Até que tudo esteja totalmente migrado e o código mude para executar
com sound null safety, `arg` pode ser definido como `null`.

A maneira mais simples de preservar o comportamento é transformar a verificação em
[`ArgumentError.checkNotNull`]({{site.dart-api}}/dart-core/ArgumentError/checkNotNull.html).

O mesmo se aplica a algumas verificações de tipo em runtime. Se `arg`
tem tipo estático `String`, então `if (arg is! String)` está na verdade verificando
se `arg` é `null`. Pode parecer que migrar para null safety significa que `arg`
nunca pode ser `null`, mas pode ser `null` em unsound null safety. Então, para preservar
o comportamento, a verificação de null deve permanecer.

## O método `Iterable.firstWhere` não aceita mais `orElse: () => null`.

Importe `package:collection` e use o método de extensão `firstWhereOrNull`
em vez de `firstWhere`.

## Como lidar com atributos que têm setters?

Diferente da sugestão `late final` acima, esses atributos não podem ser marcados como
final. Frequentemente, atributos configuráveis também não têm valores iniciais, pois eles
são esperados para serem definidos em algum momento posterior.

Nesses casos, você tem duas opções:

-   Defina um valor inicial. Muitas vezes, a omissão de um valor inicial é
    por engano e não deliberada.
-   Se você tiver _certeza_ de que o atributo precisa ser definido antes de ser acessado, marque-o
    como `late`.

    AVISO: A keyword `late` adiciona uma verificação de runtime. Se algum usuário chamar `get`
    antes de `set`, eles receberão um erro em runtime.

## Como sinalizo que o valor de retorno de um Map é non-nullable?

O
[operador de busca]({{site.dart-api}}/dart-core/Map/operator_get.html)
em Map (`[]`) por padrão retorna um tipo nullable. Não há como sinalizar para
a linguagem que o valor é garantido estar lá.

Neste caso, você deve usar o operador de asserção not-null (`!`) para
converter o valor de volta para `V`:

```dart
return blockTypes[key]!;
```

Que lançará se o map retornar null. Se você quiser tratamento explícito para esse caso:

```dart
var result = blockTypes[key];
if (result != null) return result;
// Handle the null case here, e.g. throw with explanation.
```

## Por que o tipo genérico no meu List/Map é nullable?

Normalmente é um code smell acabar com código nullable como este:

```dart tag=bad
List<Foo?> fooList; // fooList can contain null values
```

Isso implica que `fooList` pode conter valores null. Isso pode acontecer se você estiver
inicializando a lista com comprimento e preenchendo-a através de um loop.

Se você está simplesmente inicializando a lista com o mesmo valor, você deve usar
o construtor
[`filled`]({{site.dart-api}}/dart-core/List/List.filled.html).

```dart tag=bad
_jellyCounts = List<int?>(jellyMax + 1);
for (var i = 0; i <= jellyMax; i++) {
  _jellyCounts[i] = 0; // List initialized with the same value
}
```

```dart tag=good
_jellyCounts = List<int>.filled(jellyMax + 1, 0); // List initialized with filled constructor
```

Se você está definindo os elementos da lista via índice, ou está populando
cada elemento da lista com um valor distinto, você deve usar a
sintaxe de literal de lista para construir a lista.

```dart tag=bad
_jellyPoints = List<Vec2D?>(jellyMax + 1);
for (var i = 0; i <= jellyMax; i++) {
  _jellyPoints[i] = Vec2D(); // Each list element is a distinct Vec2D
}
```

```dart tag=good
_jellyPoints = [
  for (var i = 0; i <= jellyMax; i++)
    Vec2D() // Each list element is a distinct Vec2D
];
```

Para gerar uma lista de comprimento fixo,
use o construtor [`List.generate`][]
com o parâmetro `growable` definido como `false`:

```dart
_jellyPoints = List.generate(jellyMax, (_) => Vec2D(), growable: false);
```

[`List.generate`]: {{site.dart-api}}/dart-core/List/List.generate.html

{% comment %}
  Would preferably suggest a language syntax here,
  which is being suggested in https://github.com/dart-lang/language/issues/2477.
{% endcomment %}

## O que aconteceu com o construtor List padrão?

Você pode encontrar este erro:

```plaintext
The default 'List' constructor isn't available when null safety is enabled. #default_list_constructor
```

O construtor de lista padrão preenche a lista com `null`, o que é um problema.

Mude para `List.filled(length, default)` em vez disso.

## Estou usando `package:ffi` e recebo uma falha com `Dart_CObject_kUnsupported` quando migro. O que aconteceu?

Listas enviadas via ffi só podem ser `List<dynamic>`, não `List<Object>` ou
`List<Object?>`. Se você não alterou um tipo de lista explicitamente em sua migração,
um tipo ainda pode ter mudado devido a mudanças na inferência de tipos que acontecem
quando você habilita null safety.

A solução é criar explicitamente tais listas como `List<dynamic>`.

## Por que a ferramenta de migração adiciona comentários ao meu código? {:#migration-comments}

A ferramenta de migração adiciona comentários `/* == false */` ou `/* == true */` quando vê
condições que sempre serão falsas ou verdadeiras ao executar em modo sound.
Comentários como esses podem indicar que a migração automática está incorreta e
precisa de intervenção humana. Por exemplo:

```dart
if (registry.viewFactory(viewDescriptor.id) == null /* == false */)
```

Nesses casos, a ferramenta de migração não pode distinguir situações de codificação defensiva
e situações onde um valor null é realmente esperado. Então a ferramenta diz o que
ela sabe ("parece que essa condição sempre será falsa!") e deixa você
decidir o que fazer.

## O que devo saber sobre compilar para JavaScript e null safety?

Null safety traz muitos benefícios como redução de tamanho de código e melhor
desempenho de aplicativo. Tais benefícios aparecem mais quando compilados para alvos
nativos como Flutter e AOT. Trabalho anterior no compilador web de produção
havia introduzido otimizações similares ao que null safety
depois introduziu. Isso pode fazer com que os ganhos resultantes para aplicativos web de produção
pareçam menores do que seus alvos nativos.

Algumas notas que vale destacar:

* O compilador JavaScript de produção gera asserções not-null `!`.
  Você pode não notá-las ao comparar a saída do compilador
  antes e depois de adicionar asserções not-null.
  Isso porque o compilador já
  gerava verificações de null em programas que não eram null safe.

* O compilador gera essas asserções not-null independentemente da
  soundness de null safety ou nível de otimização. Na verdade, o compilador
  não remove `!` ao usar `-O3` ou `--omit-implicit-checks`.

* O compilador JavaScript de produção pode remover verificações de null desnecessárias.
  Isso acontece porque as otimizações que o compilador web de produção
  fez antes do null safety removiam essas verificações quando sabia
  que o valor não era null.

* Por padrão, o compilador geraria verificações de subtipo de parâmetro.
  Essas verificações de runtime garantem que chamadas virtuais covariantes tenham
  argumentos apropriados. O compilador pula essas verificações com a
  opção `--omit-implicit-checks`. Usar essa opção pode gerar aplicativos
  com comportamento inesperado se o código incluir tipos inválidos.
  Para evitar surpresas, continue fornecendo forte cobertura de testes para
  seu código. Em particular, o compilador otimiza código com base
  no fato de que as entradas devem estar em conformidade com a declaração de tipo. Se
  o código fornecer argumentos de tipo inválido, essas otimizações
  estariam erradas e o programa poderia se comportar mal. Isso era verdade para
  tipos inconsistentes antes, e é verdade com nullabilities inconsistentes
  agora com sound null-safety.

* Você pode notar que o compilador JavaScript de desenvolvimento e a Dart
  VM têm mensagens de erro especiais para verificações de null, mas para manter
  aplicativos pequenos, o compilador JavaScript de produção não tem.

* Você pode ver erros indicando que `.toString` não é encontrado em `null`.
  Isso não é um bug. O compilador sempre codificou algumas verificações de null
  dessa maneira. Ou seja, o compilador representa algumas verificações de null
  de forma compacta fazendo um acesso não protegido de uma propriedade do
  receptor. Então, em vez de `if (a == null) throw`, ele gera
  `a.toString`. O método `toString` é definido em JavaScript Object
  e é uma maneira rápida de verificar que um objeto não é null.

  Se a primeira ação após uma verificação de null é uma ação que falha
  quando o valor é null, o compilador pode remover a verificação de null e
  deixar a ação causar o erro.

  Por exemplo, uma expressão Dart `print(a!.foo());` pode se transformar diretamente
  em:

  ```js
    P.print(a.foo$0());
  ```

  Isso porque a chamada `a.foo$()` falhará se `a` for null.
  Se o compilador inlinear `foo`, ele preservará a verificação de null.
  Então, por exemplo, se `foo` fosse `int foo() => 1;` o compilador poderia
  gerar:

  ```js
    a.toString;
    P.print(1);
  ```

  Se o método inlineado primeiro acessasse um campo no receptor, como
  `int foo() => this.x + 1;`, então o compilador de produção pode remover
  a verificação de null redundante `a.toString`, como chamadas não inlineadas, e
  gerar:

  ```js
    P.print(a.x + 1);
  ```

## Recursos

*   [DartPad com Null Safety]({{site.dartpad}})
*   [Sound null safety](/null-safety)
