---
ia-translate: true
title: "Dart Eficaz: Documentação"
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
se baseia no contexto que já está em sua mente. Pessoas novas em seu código, e
até mesmo seu eu futuro esquecido não terão esse contexto. Um comentário conciso e preciso
leva apenas alguns segundos para ser escrito, mas pode economizar a uma dessas pessoas
horas de trabalho.

Todos nós sabemos que o código deve ser autoexplicativo e nem todos os comentários são úteis.
Mas a realidade é que a maioria de nós não escreve tantos comentários quantos deveríamos.
É como exercício físico: tecnicamente você *pode* fazer muito, mas é muito mais
provável que você esteja fazendo muito pouco. Tente aumentar a frequência.

## Comentários {:#comments}

As dicas a seguir se aplicam a comentários que você não deseja incluir na
documentação gerada.

### FAÇA: formate os comentários como frases {:#do-format-comments-like-sentences}

<?code-excerpt "docs_good.dart (comments-like-sentences)"?>
```dart tag=good
// Não se houver algo antes.
if (_chunks.isNotEmpty) return false;
```

Use maiúscula na primeira palavra, a menos que seja um identificador sensível a maiúsculas. Termine com um
ponto (ou "!" ou "?", imagino). Isso é válido para todos os comentários: comentários de documentação,
coisas em linha, até mesmo TODOs. Mesmo que seja um fragmento de frase.

### NÃO FAÇA: use comentários de bloco para documentação {:#dont-use-block-comments-for-documentation}

<?code-excerpt "docs_good.dart (block-comments)"?>
```dart tag=good
void greet(String name) {
  // Suponha que temos um nome válido.
  print('Hi, $name!');
}
```

<?code-excerpt "docs_bad.dart (block-comments)"?>
```dart tag=bad
void greet(String name) {
  /* Suponha que temos um nome válido. */
  print('Hi, $name!');
}
```

Você pode usar um comentário de bloco (`/* ... */`) para comentar temporariamente uma seção
de código, mas todos os outros comentários devem usar `//`.

## Comentários de Documentação {:#doc-comments}

Comentários de documentação são especialmente úteis porque o [`dart doc`][] os analisa
e gera [páginas de documentação bonitas][docs] a partir deles.
Um comentário de documentação é qualquer comentário que aparece antes de uma declaração
e usa a sintaxe especial `///` que o `dart doc` procura.

[`dart doc`]: /tools/dart-doc
[docs]: {{site.dart-api}}

### FAÇA: use comentários `///` para documentar membros e tipos {:#do-use-doc-comments-to-document-members-and-types}

{% render 'linter-rule-mention.md', rules:'slash_for_doc_comments' %}

Usar um comentário de documentação em vez de um comentário regular permite que
o [`dart doc`][] o encontre
e gere a documentação para ele.

<?code-excerpt "docs_good.dart (use-doc-comments)"?>
```dart tag=good
/// O número de caracteres neste bloco quando não dividido.
int get length => ...
```

<?code-excerpt "docs_good.dart (use-doc-comments)" replace="/^\///g"?>
```dart tag=bad
// O número de caracteres neste bloco quando não dividido.
int get length => ...
```

Por motivos históricos, o `dart doc` suporta duas sintaxes de comentários de documentação: `///`
("estilo C#") e `/** ... */` ("estilo JavaDoc"). Preferimos `///` porque é
mais compacto. `/**` e `*/` adicionam duas linhas sem conteúdo a um comentário de documentação de várias linhas. A sintaxe `///` também é mais fácil de ler em algumas situações, como
quando um comentário de documentação contém uma lista com marcadores que usa `*` para marcar os itens da lista.

Se você encontrar código que ainda usa o estilo JavaDoc, considere limpá-lo.

### PREFIRA: escrever comentários de documentação para APIs públicas {:#prefer-writing-doc-comments-for-public-apis}

{% render 'linter-rule-mention.md', rules:'public_member_api_docs' %}

Você não precisa documentar todas as bibliotecas, variáveis de nível superior, tipos e
membros, mas deve documentar a maioria deles.

### CONSIDERE: escrever um comentário de documentação de nível de biblioteca {:#consider-writing-a-library-level-doc-comment}

Ao contrário de linguagens como Java, onde a classe é a única unidade de organização do programa, em Dart, uma biblioteca é em si uma entidade com a qual os usuários trabalham diretamente, importam e consideram. Isso torna a diretiva `library` um ótimo
lugar para documentação que apresenta ao leitor os principais conceitos e
funcionalidades fornecidas dentro. Considere incluir:

* Um resumo de uma única frase sobre a finalidade da biblioteca.
* Explicações da terminologia usada em toda a biblioteca.
* Algumas amostras de código completas que orientam o uso da API.
* Links para as classes e funções mais importantes ou mais usadas.
* Links para referências externas sobre o domínio com o qual a biblioteca está relacionada.

Para documentar uma biblioteca, coloque um comentário de documentação antes
da diretiva `library` e quaisquer anotações que possam estar anexadas
no início do arquivo.

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// Uma biblioteca de teste realmente ótima.
@TestOn('browser')
library;
```

### CONSIDERE: escrever comentários de documentação para APIs privadas {:#consider-writing-doc-comments-for-private-apis}

Comentários de documentação não são apenas para consumidores externos da API pública da sua biblioteca.
Eles também podem ser úteis para entender membros privados que são chamados de
outras partes da biblioteca.

### FAÇA: inicie comentários de documentação com um resumo de uma única frase {:#do-start-doc-comments-with-a-single-sentence-summary}

Comece seu comentário de documentação com uma breve descrição centrada no usuário, terminando com um
ponto. Um fragmento de frase geralmente é suficiente. Forneça contexto suficiente para
o leitor se orientar e decidir se deve continuar lendo ou procurar
em outro lugar a solução para seu problema.

<?code-excerpt "docs_good.dart (first-sentence)"?>
```dart tag=good
/// Exclui o arquivo em [path] do sistema de arquivos.
void delete(String path) {
  ...
}
```

<?code-excerpt "docs_bad.dart (first-sentence)"?>
```dart tag=bad
/// Dependendo do estado do sistema de arquivos e das permissões do usuário,
/// certas operações podem ou não ser possíveis. Se não houver nenhum arquivo em
/// [path] ou se não for possível acessá-lo, esta função lança [IOError]
/// ou [PermissionError], respectivamente. Caso contrário, isso exclui o arquivo.
void delete(String path) {
  ...
}
```

### FAÇA: separe a primeira frase de um comentário de documentação em seu próprio parágrafo {:#do-separate-the-first-sentence-of-a-doc-comment-into-its-own-paragraph}

Adicione uma linha em branco após a primeira frase para separá-la em seu próprio
parágrafo. Se mais de uma frase de explicação for útil, coloque o
restante em parágrafos posteriores.

Isso ajuda você a escrever uma primeira frase concisa que resume a documentação.
Além disso, ferramentas como `dart doc` usam o primeiro parágrafo como um breve resumo em locais
como listas de classes e membros.

<?code-excerpt "docs_good.dart (first-sentence-a-paragraph)"?>
```dart tag=good
/// Exclui o arquivo em [path].
///
/// Lança um [IOError] se o arquivo não for encontrado. Lança um
/// [PermissionError] se o arquivo estiver presente, mas não puder ser excluído.
void delete(String path) {
  ...
}
```

<?code-excerpt "docs_bad.dart (first-sentence-a-paragraph)"?>
```dart tag=bad
/// Exclui o arquivo em [path]. Lança um [IOError] se o arquivo não puder
/// ser encontrado. Lança um [PermissionError] se o arquivo estiver presente, mas não puder
/// ser excluído.
void delete(String path) {
  ...
}
```

### EVITE: redundância com o contexto ao redor {:#avoid-redundancy-with-the-surrounding-context}

O leitor do comentário de documentação de uma classe pode ver claramente o nome da classe, quais
interfaces ela implementa, etc. Ao ler a documentação de um membro, a assinatura está
ali, e a classe encapsuladora é óbvia. Nada disso precisa ser
escrito no comentário de documentação. Em vez disso, concentre-se em explicar o que o leitor
*não* sabe.

<?code-excerpt "docs_good.dart (redundant)"?>
```dart tag=good
class RadioButtonWidget extends Widget {
  /// Define a dica de ferramenta para [lines], que deve ter sido quebrado em palavras usando
  /// a fonte atual.
  void tooltip(List<String> lines) {
    ...
  }
}
```

<?code-excerpt "docs_bad.dart (redundant)"?>
```dart tag=bad
class RadioButtonWidget extends Widget {
  /// Define a dica de ferramenta para este widget de botão de rádio para a lista de strings em
  /// [lines].
  void tooltip(List<String> lines) {
    ...
  }
}
```

Se você realmente não tem nada interessante a dizer
que não pode ser inferido da própria declaração,
então omita o comentário de documentação.
É melhor não dizer nada
do que perder o tempo do leitor dizendo a ele algo que ele já sabe.


### PREFIRA: iniciar comentários de função ou método com verbos na terceira pessoa {:#prefer-starting-function-or-method-comments-with-third-person-verbs}

O comentário de documentação deve focar no que o código *faz*.

<?code-excerpt "docs_good.dart (third-person)"?>
```dart tag=good
/// Retorna `true` se todos os elementos satisfazem o [predicate].
bool all(bool predicate(T element)) => ...

/// Inicia o cronômetro se ainda não estiver funcionando.
void start() {
  ...
}
```

### PREFIRA: iniciar um comentário de variável ou propriedade não booleana com uma frase nominal {:#prefer-starting-a-non-boolean-variable-or-property-comment-with-a-noun-phrase}

O comentário de documentação deve enfatizar o que a propriedade *é*. Isso é válido mesmo para
getters que podem fazer cálculos ou outros trabalhos. O que o chamador se importa é
o *resultado* desse trabalho, não o trabalho em si.

<?code-excerpt "docs_good.dart (noun-phrases-for-non-boolean-var-etc)"?>
```dart tag=good
/// O dia atual da semana, onde `0` é domingo.
int weekday;

/// O número de botões marcados na página.
int get checkedCount => ...
```

### PREFIRA: iniciar um comentário de variável ou propriedade booleana com "Se" seguido de uma frase nominal ou gerundiva {:#prefer-starting-a-boolean-variable-or-property-comment-with-whether-followed-by-a-noun-or-gerund-phrase}

O comentário de documentação deve esclarecer os estados que esta variável representa.
Isso é válido mesmo para getters que podem fazer cálculos ou outros trabalhos.
O que o chamador se importa é o *resultado* desse trabalho, não o trabalho em si.

<?code-excerpt "docs_good.dart (noun-phrases-for-boolean-var-etc)"?>
```dart tag=good
/// Se a modal está atualmente sendo exibida para o usuário.
bool isVisible;

/// Se a modal deve confirmar a intenção do usuário na navegação.
bool get shouldConfirm => ...

/// Se redimensionar a janela do navegador atual também redimensionará a modal.
bool get canResize => ...
```

:::note
Esta diretriz intencionalmente não inclui o uso de "Se ou não". Em muitos
casos, o uso de "ou não" com "se" é supérfluo e pode ser omitido,
especialmente quando usado neste contexto.
:::

### NÃO FAÇA: escreva documentação para o getter e o setter de uma propriedade {:#dont-write-documentation-for-both-the-getter-and-setter-of-a-property}

Se uma propriedade tiver um getter e um setter, crie um comentário de documentação para
apenas um deles. `dart doc` trata o getter e o setter como um único campo,
e se tanto o getter quanto o setter tiverem comentários de documentação, então
`dart doc` descarta o comentário de documentação do setter.

<?code-excerpt "docs_good.dart (getter-and-setter)"?>
```dart tag=good
/// O nível de pH da água na piscina.
///
/// Varia de 0 a 14, representando ácido a básico, com 7 sendo neutro.
int get phLevel => ...
set phLevel(int level) => ...
```

<?code-excerpt "docs_bad.dart (getter-and-setter)"?>
```dart tag=bad
/// A profundidade da água na piscina, em metros.
int get waterDepth => ...

/// Atualiza a profundidade da água para um total de [meters] de altura.
set waterDepth(int meters) => ...
```

### PREFIRA: iniciar comentários de biblioteca ou tipo com frases nominais {:#prefer-starting-library-or-type-comments-with-noun-phrases}

Comentários de documentação para classes são frequentemente a documentação mais importante em seu
programa. Eles descrevem os invariantes do tipo, estabelecem a terminologia que ele usa
e fornecem contexto aos outros comentários de documentação para os membros da classe. Um pouco de
esforço extra aqui pode tornar todos os outros membros mais fáceis de documentar.

<?code-excerpt "docs_good.dart (noun-phrases-for-type-or-lib)"?>
```dart tag=good
/// Um bloco de texto de saída contínuo terminado por uma nova linha rígida ou suave.
///
/// ...
class Chunk { ... }
```

### CONSIDERE: incluir exemplos de código em comentários de documentação {:#consider-including-code-samples-in-doc-comments}

<?code-excerpt "docs_good.dart (code-sample)"?>
````dart tag=good
/// Retorna o menor de dois números.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
````

Os humanos são ótimos em generalizar a partir de exemplos, então até mesmo uma única amostra de código
torna uma API mais fácil de aprender.

### FAÇA: use colchetes em comentários de documentação para referir-se a identificadores em escopo {:#do-use-square-brackets-in-doc-comments-to-refer-to-in-scope-identifiers}

{% render 'linter-rule-mention.md', rules:'comment_references' %}

Se você cercar coisas como nomes de variáveis, métodos ou tipos em colchetes,
então o `dart doc` procura o nome e vincula à documentação da API relevante.
Parênteses são opcionais,
mas podem deixar mais claro quando você está se referindo a um método ou construtor.

<?code-excerpt "docs_good.dart (identifiers)"?>
```dart tag=good
/// Lança um [StateError] se ...
/// semelhante a [anotherMethod()], mas ...
```

Para vincular a um membro de uma classe específica, use o nome da classe e o nome do membro,
separados por um ponto:

<?code-excerpt "docs_good.dart (member)"?>
```dart tag=good
/// Semelhante a [Duration.inDays], mas lida com dias fracionários.
```

A sintaxe de ponto também pode ser usada para referir-se a construtores nomeados. Para o
construtor sem nome, use `.new` após o nome da classe:

<?code-excerpt "docs_good.dart (ctor)"?>
```dart tag=good
/// Para criar um ponto, chame [Point.new] ou use [Point.polar] para ...
```

### FAÇA: use prosa para explicar parâmetros, valores retornados e exceções {:#do-use-prose-to-explain-parameters-return-values-and-exceptions}

Outras linguagens usam tags e seções verbosas para descrever o que os parâmetros
e os retornos de um método são.

<?code-excerpt "docs_bad.dart (no-annotations)"?>
```dart tag=bad
/// Define uma flag com o nome e a abreviatura fornecidos.
///
/// @param name O nome da flag.
/// @param abbr A abreviatura da flag.
/// @returns A nova flag.
/// @throws ArgumentError Se já houver uma opção com
///     o nome ou a abreviatura fornecidos.
Flag addFlag(String name, String abbr) => ...
```

A convenção em Dart é integrar isso na descrição do método
e destacar os parâmetros usando colchetes.

<?code-excerpt "docs_good.dart (no-annotations)"?>
```dart tag=good
/// Define uma flag.
///
/// Lança um [ArgumentError] se já houver uma opção nomeada [name] ou
/// se já houver uma opção usando a abreviatura [abbr]. Retorna a nova flag.
Flag addFlag(String name, String abbr) => ...
```

### FAÇA: coloque comentários de documentação antes de anotações de metadados {:#do-put-doc-comments-before-metadata-annotations}

<?code-excerpt "docs_good.dart (doc-before-meta)"?>
```dart tag=good
/// Um botão que pode ser ligado e desligado.
@Component(selector: 'toggle')
class ToggleComponent {}
```

<?code-excerpt "docs_bad.dart (doc-before-meta)" replace="/\n\n/\n/g"?>
```dart tag=bad
@Component(selector: 'toggle')
/// Um botão que pode ser ligado e desligado.
class ToggleComponent {}
```


## Markdown {:#markdown}

Você pode usar a maioria da formatação [markdown][] em seus comentários de documentação e
o `dart doc` os processará de acordo usando o [pacote markdown.][]

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package.]: {{site.pub-pkg}}/markdown

Existem muitos guias por aí que já podem apresentar o Markdown. Sua
popularidade universal é por que o escolhemos. Aqui está apenas um exemplo rápido para dar a você
uma ideia do que é suportado:

<?code-excerpt "docs_good.dart (markdown)"?>
````dart
/// Este é um parágrafo de texto normal.
///
/// Esta frase tem *duas* _palavras_ enfatizadas (itálico) e **duas**
/// __palavras__ fortes (negrito).
///
/// Uma linha em branco cria um parágrafo separado. Ele tem algum `código em linha`
/// delimitado usando backticks.
///
/// * Listas não ordenadas.
/// * Se parecem com listas de marcadores ASCII.
/// * Você também pode usar `-` ou `+`.
///
/// 1. Listas numeradas.
/// 2. São, bem, numeradas.
/// 1. Mas os valores não importam.
///
///     * Você também pode aninhar listas.
///     * Elas devem ser recuadas pelo menos 4 espaços.
///     * (Bem, 5 incluindo o espaço após `///`.)
///
/// Blocos de código são delimitados por três backticks:
///
/// ```dart
/// este.código
///     .irá
///     .manter(sua, formatação);
/// ```
///
/// A linguagem do código (para destaque de sintaxe) é Dart por padrão. Você pode
/// especificá-la colocando o nome da linguagem após os backticks de abertura:
///
/// ```html
/// <h1>HTML é mágico!</h1>
/// ```
///
/// Links podem ser:
///
/// * https://www.just-a-bare-url.com
/// * [com a URL em linha](https://google.com)
/// * [ou separados][ref link]
///
/// [ref link]: https://google.com
///
/// # Um Título
///
/// ## Um subtítulo
///
/// ### Um subsubtítulo
///
/// #### Se você precisar de tantos níveis de títulos, está fazendo errado
````

### EVITE: usar Markdown excessivamente {:#avoid-using-markdown-excessively}

Em caso de dúvida, formate menos. A formatação existe para iluminar seu conteúdo, não
substituí-lo. Palavras são o que importa.

### EVITE: usar HTML para formatação {:#avoid-using-html-for-formatting}

*Pode* ser útil usá-lo em casos raros para coisas como tabelas, mas na maioria dos
casos, se for muito complexo para expressar em Markdown, é melhor não
expressá-lo.

### PREFIRA: cercas de backticks para blocos de código {:#prefer-backtick-fences-for-code-blocks}

O Markdown tem duas maneiras de indicar um bloco de código: recuar o código quatro
espaços em cada linha ou cercá-lo em um par de linhas de "cerca" de três backticks. A sintaxe anterior é frágil quando usada dentro de coisas como listas de Markdown
onde a indentação já é significativa ou quando o próprio bloco de código contém
código recuado.

A sintaxe de backtick evita esses problemas de indentação, permite indicar a linguagem do código
e é consistente com o uso de backticks para código em linha.

```dart tag=good
/// Você pode usar [CodeBlockExample] assim:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Yes."
/// ```
```

```dart tag=bad
/// Você pode usar [CodeBlockExample] assim:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Yes."
```

## Escrita {:#writing}

Nós nos consideramos programadores, mas a maioria dos caracteres em um arquivo de origem
é destinada principalmente para os humanos lerem. O inglês é a linguagem que programamos
para modificar os cérebros de nossos colegas de trabalho. Assim como qualquer linguagem de programação, vale a pena
esforçar-se para melhorar sua proficiência.

Esta seção lista algumas diretrizes para nossa documentação. Você pode aprender mais sobre
as melhores práticas para redação técnica, em geral, a partir de artigos como
[Estilo de redação técnica](https://en.wikiversity.org/wiki/Technical_writing_style).

### PREFIRA: brevidade {:#prefer-brevity}

Seja claro e preciso, mas também conciso.

### EVITE: abreviaturas e siglas, a menos que sejam óbvias {:#avoid-abbreviations-and-acronyms-unless-they-are-obvious}

Muitas pessoas não sabem o que "i.e.", "e.g." e "et al." significam. Aquela sigla
que você tem certeza de que todos em seu campo conhecem pode não ser tão conhecida quanto você
pensa.

### PREFIRA: usar "este" em vez de "o" para referir-se à instância de um membro {:#prefer-using-this-instead-of-the-to-refer-to-a-members-instance}

Ao documentar um membro de uma classe, você geralmente precisa se referir ao
objeto em que o membro está sendo chamado. Usar "o" pode ser ambíguo.

<?code-excerpt "docs_good.dart (this)"?>
```dart
class Box {
  /// O valor que este encapsula.
  Object? _value;

  /// Verdadeiro se esta caixa contém um valor.
  bool get hasValue => _value != null;
}
```

