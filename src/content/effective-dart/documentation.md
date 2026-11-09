---
ia-translate: true
title: "Dart Efetivo: Documentação"
breadcrumb: Documentation
description: Comentários e documentação claros e úteis.
nextpage:
  url: /effective-dart/usage
  title: Uso
prevpage:
  url: /effective-dart/style
  title: Estilo
---

<?code-excerpt path-base="misc/lib/effective_dart"?>

É fácil pensar que seu código é óbvio hoje sem perceber o quanto você
depende do contexto que já está na sua cabeça. Pessoas novas no seu código, e
até mesmo o seu eu futuro esquecido, não terão esse contexto. Um comentário conciso e preciso
leva apenas alguns segundos para escrever, mas pode economizar horas de tempo para uma dessas pessoas.

Todos sabemos que o código deve ser autodocumentado e nem todos os comentários são úteis.
Mas a realidade é que a maioria de nós não escreve tantos comentários quanto deveria.
É como exercício: tecnicamente você *pode* fazer demais, mas é muito mais
provável que esteja fazendo de menos. Tente se esforçar mais.

## Comentários {:#comments}

As dicas a seguir se aplicam a comentários que você não quer incluir na
documentação gerada.

### FAÇA formatar comentários como frases {:#do-format-comments-like-sentences}

<?code-excerpt "docs_good.dart (comments-like-sentences)"?>
```dart tag=good
// Not if anything comes before it.
if (_chunks.isNotEmpty) return false;
```

Escreva a primeira palavra com maiúscula, a menos que seja um identificador sensível a maiúsculas e minúsculas. Termine com um
ponto final (ou "!" ou "?", suponho). Isso vale para todos os comentários: comentários de documentação,
comentários inline, até mesmo TODOs. Mesmo que seja um fragmento de frase.

### NÃO usar comentários de bloco para documentação {:#dont-use-block-comments-for-documentation}

<?code-excerpt "docs_good.dart (block-comments)"?>
```dart tag=good
void greet(String name) {
  // Assume we have a valid name.
  print('Hi, $name!');
}
```

<?code-excerpt "docs_bad.dart (block-comments)"?>
```dart tag=bad
void greet(String name) {
  /* Assume we have a valid name. */
  print('Hi, $name!');
}
```

Você pode usar um comentário de bloco (`/* ... */`) para comentar temporariamente uma seção
de código, mas todos os outros comentários devem usar `//`.

## Comentários de documentação {:#doc-comments}

Os comentários de documentação são especialmente úteis porque o [`dart doc`][] os analisa
e gera [belas páginas de documentação][docs] a partir deles.
Um comentário de documentação é qualquer comentário que aparece antes de uma declaração
e usa a sintaxe especial `///` que o `dart doc` procura.

[`dart doc`]: /tools/dart-doc
[docs]: {{site.dart-api}}

### FAÇA usar comentários de documentação `///` para documentar membros e tipos {:#do-use-doc-comments-to-document-members-and-types}

{% render 'linter-rule-mention.md', rules:'slash_for_doc_comments' %}

Usar um comentário de documentação em vez de um comentário comum permite
que o [`dart doc`][] o encontre
e gere documentação para ele.

<?code-excerpt "docs_good.dart (use-doc-comments)"?>
```dart tag=good
/// The number of characters in this chunk when unsplit.
int get length => ...
```

<?code-excerpt "docs_good.dart (use-doc-comments)" replace="/^\///g"?>
```dart tag=bad
// The number of characters in this chunk when unsplit.
int get length => ...
```

Por razões históricas, o `dart doc` suporta duas sintaxes de comentários de documentação: `///`
("estilo C#") e `/** ... */` ("estilo JavaDoc"). Preferimos `///` porque é
mais compacto. `/**` e `*/` adicionam duas linhas sem conteúdo a um comentário de documentação
multilinha. A sintaxe `///` também é mais fácil de ler em algumas situações, como
quando um comentário de documentação contém uma lista com marcadores que usa `*` para marcar os itens.

Se você encontrar código que ainda usa o estilo JavaDoc, considere limpá-lo.

### PREFIRA escrever comentários de documentação para APIs públicas {:#prefer-writing-doc-comments-for-public-apis}

{% render 'linter-rule-mention.md', rules:'public_member_api_docs' %}

Você não precisa documentar cada biblioteca, variável de nível superior, tipo e
membro, mas deve documentar a maioria deles.

### CONSIDERE escrever um comentário de documentação no nível da biblioteca {:#consider-writing-a-library-level-doc-comment}

Ao contrário de linguagens como Java, onde a classe é a única unidade de organização
do programa, no Dart uma biblioteca é uma entidade com a qual os usuários trabalham
diretamente, importam e pensam a respeito. Isso faz da diretiva `library` um ótimo
lugar para documentação que apresenta ao leitor os principais conceitos e
funcionalidades fornecidas. Considere incluir:

* Um resumo de uma frase sobre para que serve a biblioteca.
* Explicações da terminologia usada em toda a biblioteca.
* Alguns exemplos de código completos que mostram como usar a API.
* Links para as classes e funções mais importantes ou mais usadas.
* Links para referências externas sobre o domínio com o qual a biblioteca trabalha.

Para documentar uma biblioteca, coloque um comentário de documentação antes
da diretiva `library` e de quaisquer anotações que possam estar anexadas
no início do arquivo.

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// A really great test library.
@TestOn('browser')
library;
```

### CONSIDERE escrever comentários de documentação para APIs privadas {:#consider-writing-doc-comments-for-private-apis}

Os comentários de documentação não são apenas para consumidores externos da API pública da sua biblioteca.
Eles também podem ser úteis para entender membros privados que são chamados de
outras partes da biblioteca.

### FAÇA começar comentários de documentação com um resumo de uma frase {:#do-start-doc-comments-with-a-single-sentence-summary}

Comece o seu comentário de documentação com uma breve descrição centrada no usuário, terminando com um
ponto final. Um fragmento de frase geralmente é suficiente. Forneça apenas o contexto necessário para
o leitor se situar e decidir se deve continuar lendo ou procurar
em outro lugar a solução para o problema dele.

<?code-excerpt "docs_good.dart (first-sentence)"?>
```dart tag=good
/// Deletes the file at [path] from the file system.
void delete(String path) {
  ...
}
```

<?code-excerpt "docs_bad.dart (first-sentence)"?>
```dart tag=bad
/// Depending on the state of the file system and the user's permissions,
/// certain operations may or may not be possible. If there is no file at
/// [path] or it can't be accessed, this function throws either [IOError]
/// or [PermissionError], respectively. Otherwise, this deletes the file.
void delete(String path) {
  ...
}
```

### FAÇA separar a primeira frase de um comentário de documentação em seu próprio parágrafo {:#do-separate-the-first-sentence-of-a-doc-comment-into-its-own-paragraph}

Adicione uma linha em branco após a primeira frase para separá-la em seu próprio
parágrafo. Se mais de uma frase de explicação for útil, coloque o
resto em parágrafos seguintes.

Isso ajuda você a escrever uma primeira frase concisa que resume a documentação.
Além disso, ferramentas como o `dart doc` usam o primeiro parágrafo como um resumo curto em lugares
como listas de classes e membros.

<?code-excerpt "docs_good.dart (first-sentence-a-paragraph)"?>
```dart tag=good
/// Deletes the file at [path].
///
/// Throws an [IOError] if the file could not be found. Throws a
/// [PermissionError] if the file is present but could not be deleted.
void delete(String path) {
  ...
}
```

<?code-excerpt "docs_bad.dart (first-sentence-a-paragraph)"?>
```dart tag=bad
/// Deletes the file at [path]. Throws an [IOError] if the file could not
/// be found. Throws a [PermissionError] if the file is present but could
/// not be deleted.
void delete(String path) {
  ...
}
```

### EVITE redundância com o contexto ao redor {:#avoid-redundancy-with-the-surrounding-context}

O leitor do comentário de documentação de uma classe pode ver claramente o nome da classe, quais
interfaces ela implementa, etc. Ao ler a documentação de um membro, a assinatura está
bem ali, e a classe que o envolve é óbvia. Nada disso precisa ser
explicado no comentário de documentação. Em vez disso, concentre-se em explicar o que o leitor
*não* sabe ainda.

<?code-excerpt "docs_good.dart (redundant)"?>
```dart tag=good
class RadioButtonWidget extends Widget {
  /// Sets the tooltip to [lines].
  ///
  /// The lines should be word wrapped using the current font.
  void tooltip(List<String> lines) {
    ...
  }
}
```

<?code-excerpt "docs_bad.dart (redundant)"?>
```dart tag=bad
class RadioButtonWidget extends Widget {
  /// Sets the tooltip for this radio button widget to the list of strings in
  /// [lines].
  void tooltip(List<String> lines) {
    ...
  }
}
```

Adicione comentários de documentação apenas quando eles fornecerem contexto, ressalvas ou detalhes de uso
que não são imediatamente óbvios pelo contexto ao redor.

<a id="prefer-starting-function-or-method-comments-with-third-person-verbs" aria-hidden="true"></a>

### PREFIRA começar comentários de funções ou métodos com verbos na terceira pessoa se o propósito principal for um efeito colateral {:#prefer-starting-comments-of-a-function-or-method-with-third-person-verbs-if-its-main-purpose-is-a-side-effect}

O comentário de documentação deve focar no que o código *faz*.

<?code-excerpt "docs_good.dart (third-person)"?>
```dart tag=good
/// Connects to the server and fetches the query results.
Stream<QueryResult> fetchResults(Query query) => ...

/// Starts the stopwatch if not already running.
void start() => ...
```

### PREFIRA começar o comentário de uma variável ou propriedade não booleana com um sintagma nominal {:#prefer-starting-a-non-boolean-variable-or-property-comment-with-a-noun-phrase}

O comentário de documentação deve enfatizar o que a propriedade *é*. Isso vale mesmo para
getters que fazem cálculos ou outro trabalho. O que quem chama se importa é com
o *resultado* desse trabalho, não com o trabalho em si.

<?code-excerpt "docs_good.dart (noun-phrases-for-non-boolean-var-etc)"?>
```dart tag=good
/// The current day of the week, where `0` is Sunday.
int weekday;

/// The number of checked buttons on the page.
int get checkedCount => ...
```

### PREFIRA começar o comentário de uma variável ou propriedade booleana com "Whether" seguido de um sintagma nominal ou gerundial {:#prefer-starting-a-boolean-variable-or-property-comment-with-whether-followed-by-a-noun-or-gerund-phrase}

O comentário de documentação deve esclarecer os estados que esta variável representa.
Isso vale mesmo para getters que fazem cálculos ou outro trabalho.
O que quem chama se importa é com o *resultado* desse trabalho, não com o trabalho em si.

<?code-excerpt "docs_good.dart (noun-phrases-for-boolean-var-etc)"?>
```dart tag=good
/// Whether the modal is currently displayed to the user.
bool isVisible;

/// Whether the modal should confirm the user's intent on navigation.
bool get shouldConfirm => ...

/// Whether resizing the current browser window will also resize the modal.
bool get canResize => ...
```

:::note
Esta diretriz intencionalmente não inclui o uso de "Whether or not". Em muitos
casos, o uso de "or not" com "whether" é supérfluo e pode ser omitido,
especialmente quando usado neste contexto.
:::

### PREFIRA um sintagma nominal ou verbal não imperativo para uma função ou método se retornar um valor for seu propósito principal {:#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose}

Se um método é *sintaticamente* um método, mas *conceitualmente* é uma propriedade,
e portanto é [nomeado com um sintagma nominal ou verbal não imperativo][parameterized_property_name],
ele também deve ser documentado como tal.
Use um sintagma nominal para tais funções não booleanas, e
um sintagma começando com "Whether" para tais funções booleanas,
assim como para uma propriedade ou variável sintática.

<?code-excerpt "docs_good.dart (noun-for-func-returning-value)"?>
```dart tag=good
/// The [index]th element of this iterable in iteration order.
E elementAt(int index);

/// Whether this iterable contains an element equal to [element].
bool contains(Object? element);
```

:::note
Esta diretriz deve ser aplicada com base em se a declaração é
conceitualmente vista como uma propriedade.

Às vezes, um método não tem efeitos colaterais e pode
conceitualmente ser visto como uma propriedade, mas ainda é
mais simples nomeá-lo com um verbo, como `list.take()`.
Nesse caso, ainda assim deve-se usar um sintagma nominal para documentá-lo.
_Por exemplo, `Iterable.take` pode ser descrito como
"Os primeiros \[count\] elementos de ..."._
:::

[parameterized_property_name]: design#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose

### NÃO escrever documentação para o getter e o setter de uma propriedade {:#dont-write-documentation-for-both-the-getter-and-setter-of-a-property}

Se uma propriedade tem tanto um getter quanto um setter, crie um comentário de documentação para
apenas um deles. O `dart doc` trata o getter e o setter como um único campo,
e se tanto o getter quanto o setter tiverem comentários de documentação, então
o `dart doc` descarta o comentário de documentação do setter.

<?code-excerpt "docs_good.dart (getter-and-setter)"?>
```dart tag=good
/// The pH level of the water in the pool.
///
/// Ranges from 0-14, representing acidic to basic, with 7 being neutral.
int get phLevel => ...
set phLevel(int level) => ...
```

<?code-excerpt "docs_bad.dart (getter-and-setter)"?>
```dart tag=bad
/// The depth of the water in the pool, in meters.
int get waterDepth => ...

/// Updates the water depth to a total of [meters] in height.
set waterDepth(int meters) => ...
```

### PREFIRA começar comentários de biblioteca ou de tipo com sintagmas nominais {:#prefer-starting-library-or-type-comments-with-noun-phrases}

Os comentários de documentação para classes são frequentemente a documentação mais importante do seu
programa. Eles descrevem os invariantes do tipo, estabelecem a terminologia que ele usa,
e fornecem contexto para os outros comentários de documentação dos membros da classe. Um pouco de
esforço extra aqui pode tornar todos os outros membros mais simples de documentar.

A documentação deve descrever uma *instância* do tipo.

<?code-excerpt "docs_good.dart (noun-phrases-for-type-or-lib)"?>
```dart tag=good
/// A chunk of non-breaking output text terminated by a hard or soft newline.
///
/// ...
class Chunk {
   ...
}
```

### CONSIDERE incluir exemplos de código em comentários de documentação {:#consider-including-code-samples-in-doc-comments}

<?code-excerpt "docs_good.dart (code-sample)"?>
````dart tag=good
/// The lesser of two numbers.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
````

Os humanos são ótimos em generalizar a partir de exemplos, então mesmo um único exemplo de código
torna uma API mais fácil de aprender.

### FAÇA usar colchetes em comentários de documentação para se referir a identificadores no escopo {:#do-use-square-brackets-in-doc-comments-to-refer-to-in-scope-identifiers}

{% render 'linter-rule-mention.md', rules:'comment_references' %}

Se você colocar nomes de variáveis, métodos ou tipos entre colchetes,
o `dart doc` procura o nome e cria um link para a documentação da API correspondente.
Parênteses são opcionais, mas podem
deixar claro que você está se referindo a uma função ou construtor.
Os comentários de documentação parciais a seguir ilustram alguns casos
em que essas referências podem ser úteis:

<?code-excerpt "docs_good.dart (identifiers)"?>
```dart tag=good
/// Throws a [StateError] if ...
///
/// Similar to [anotherMethod()], but ...
```

Para criar um link para um membro de uma classe específica, use o nome da classe e o nome do membro,
separados por um ponto:

<?code-excerpt "docs_good.dart (member)"?>
```dart tag=good
/// Similar to [Duration.inDays], but handles fractional days.
```

A sintaxe de ponto também pode ser usada para se referir a construtores nomeados. Para o construtor
sem nome, use `.new` após o nome da classe:

<?code-excerpt "docs_good.dart (ctor)"?>
```dart tag=good
/// To create a point, call [Point.new] or use [Point.polar] to ...
```

Para saber mais sobre as referências que
o analisador e o `dart doc` suportam em comentários de documentação,
confira [Referências de comentários de documentação][Documentation comment references].

[Documentation comment references]: /tools/doc-comments/references

### FAÇA usar texto corrido para explicar parâmetros, valores de retorno e exceções {:#do-use-prose-to-explain-parameters-return-values-and-exceptions}

Outras linguagens usam tags e seções verbosas para descrever quais são os parâmetros
e os retornos de um método.

<?code-excerpt "docs_bad.dart (no-annotations)"?>
```dart tag=bad
/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbreviation) => ...
```

A convenção no Dart é integrar isso à descrição do método
e destacar os parâmetros usando colchetes.

Considere ter seções começando com "The \[parameter\]" para descrever
parâmetros, com "Returns" para o valor retornado e "Throws" para exceções.
Erros podem ser documentados da mesma forma que exceções,
ou apenas como requisitos que devem ser satisfeitos, sem documentar o
erro exato que será lançado.

<?code-excerpt "docs_good.dart (no-annotations)"?>
```dart tag=good
/// Defines a flag with the given [name] and [abbreviation].
///
/// The [name] and [abbreviation] strings must not be empty.
///
/// Returns a new flag.
///
/// Throws a [DuplicateFlagException] if there is already an option named
/// [name] or there is already an option using the [abbreviation].
Flag addFlag(String name, String abbreviation) => ...
```

### FAÇA colocar comentários de documentação antes das anotações de metadados {:#do-put-doc-comments-before-metadata-annotations}

<?code-excerpt "docs_good.dart (doc-before-meta)"?>
```dart tag=good
/// A button that can be flipped on and off.
@Component(selector: 'toggle')
class ToggleComponent {}
```

<?code-excerpt "docs_bad.dart (doc-before-meta)" replace="/\n\n/\n/g"?>
```dart tag=bad
@Component(selector: 'toggle')
/// A button that can be flipped on and off.
class ToggleComponent {}
```

## Markdown {:#markdown}

Você pode usar a maioria das formatações [markdown][] nos seus comentários de documentação e
o `dart doc` as processará de acordo com o [pacote markdown.][markdown package.]

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package.]: {{site.pub-pkg}}/markdown

Existem vários guias por aí para apresentar o Markdown. A popularidade
universal dele é a razão pela qual o escolhemos. Aqui está apenas um exemplo rápido para dar
uma ideia do que é suportado:

<?code-excerpt "docs_good.dart (markdown)"?>
````dart
/// This is a paragraph of regular text.
///
/// This sentence has *two* _emphasized_ words (italics) and **two**
/// __strong__ ones (bold).
///
/// A blank line creates a separate paragraph. It has some `inline code`
/// delimited using backticks.
///
/// * Unordered lists.
/// * Look like ASCII bullet lists.
/// * You can also use `-` or `+`.
///
/// 1. Numbered lists.
/// 2. Are, well, numbered.
/// 1. But the values don't matter.
///
///     * You can nest lists too.
///     * They must be indented at least 4 spaces.
///     * (Well, 5 including the space after `///`.)
///
/// Code blocks are fenced in triple backticks:
///
/// ```dart
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// The code language (for syntax highlighting) defaults to Dart. You can
/// specify it by putting the name of the language after the opening backticks:
///
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
///
/// Links can be:
///
/// * https://www.just-a-bare-url.com
/// * [with the URL inline](https://google.com)
/// * [or separated out][ref link]
///
/// [ref link]: https://google.com
///
/// # A Header
///
/// ## A subheader
///
/// ### A subsubheader
///
/// #### If you need this many levels of headers, you're doing it wrong
````

### EVITE usar markdown em excesso {:#avoid-using-markdown-excessively}

Na dúvida, formate menos. A formatação existe para iluminar seu conteúdo, não para
substituí-lo. O que importa são as palavras.

### EVITE usar HTML para formatação {:#avoid-using-html-for-formatting}

*Pode* ser útil usá-lo em casos raros, para coisas como tabelas, mas em quase
todos os casos, se for complexo demais para expressar em Markdown, é melhor não
expressá-lo.

### PREFIRA cercas de crase para blocos de código {:#prefer-backtick-fences-for-code-blocks}

Markdown tem duas maneiras de indicar um bloco de código: indentar o código em quatro
espaços em cada linha, ou cercá-lo com um par de linhas de "cerca" com três crases.
A primeira sintaxe é frágil quando usada dentro de coisas como listas Markdown,
onde a indentação já é significativa, ou quando o próprio bloco de código contém
código indentado.

A sintaxe com crases evita esses problemas de indentação, permite indicar a
linguagem do código e é consistente com o uso de crases para código inline.

```dart tag=good
/// You can use [CodeBlockExample] like this:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Yes."
/// ```
```

```dart tag=bad
/// You can use [CodeBlockExample] like this:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Yes."
```

## Escrita {:#writing}

Nós nos consideramos programadores, mas a maioria dos caracteres em um arquivo fonte
são destinados principalmente a serem lidos por humanos. Inglês é a linguagem com que programamos
para modificar a cabeça dos nossos colegas de trabalho. Como em qualquer linguagem de programação,
vale a pena se esforçar para melhorar a proficiência.

Esta seção lista algumas diretrizes para nossa documentação. Você pode aprender mais sobre
boas práticas de escrita técnica, em geral, em artigos como
[Estilo de escrita técnica](https://en.wikiversity.org/wiki/Technical_writing_style).

### PREFIRA concisão {:#prefer-brevity}

Seja claro e preciso, mas também conciso.

### EVITE abreviações e siglas, a menos que sejam óbvias {:#avoid-abbreviations-and-acronyms-unless-they-are-obvious}

Muitas pessoas não sabem o que significam "i.e.", "e.g." e "et al.". Essa sigla
que você tem certeza de que todos na sua área conhecem pode não ser tão amplamente conhecida quanto você
pensa.

### PREFIRA usar "this" em vez de "the" para se referir à instância de um membro {:#prefer-using-this-instead-of-the-to-refer-to-a-members-instance}

Ao documentar um membro de uma classe, você frequentemente precisa se referir ao
objeto no qual o membro está sendo chamado. Usar "the" pode ser ambíguo.
Prefira ter algum qualificador depois de "this"; um "this" sozinho também pode ser ambíguo.

<?code-excerpt "docs_good.dart (this)"?>
```dart
class Box {
  /// The value this box wraps.
  Object? _value;

  /// Whether this box contains a value.
  bool get hasValue => _value != null;
}
```
