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

É fácil achar que seu código é óbvio hoje sem perceber o quanto você
depende do contexto que já está na sua cabeça. Pessoas novas no seu código,
e até mesmo seu eu futuro esquecido não terão esse contexto. Um comentário
conciso e preciso leva apenas alguns segundos para escrever, mas pode economizar
horas de tempo para uma dessas pessoas.

Todos sabemos que o código deve ser autoexplicativo e nem todos os comentários
são úteis. Mas a realidade é que a maioria de nós não escreve tantos comentários
quanto deveríamos. É como exercício: tecnicamente você *pode* fazer demais, mas é
muito mais provável que você esteja fazendo muito pouco. Tente aumentar o ritmo.

## Comentários

As dicas a seguir se aplicam a comentários que você não deseja incluir na
documentação gerada.

### FAÇA comentários como frases

<?code-excerpt "docs_good.dart (comments-like-sentences)"?>
```dart tag=good
// Não se algo vier antes dele.
if (_chunks.isNotEmpty) return false;
```

Use maiúscula na primeira palavra, a menos que seja um identificador
sensível a maiúsculas e minúsculas. Termine com um ponto final (ou "!" ou "?",
eu suponho). Isso vale para todos os comentários: comentários de documentação,
coisas inline, até mesmo TODOs. Mesmo que seja um fragmento de frase.

### NÃO use comentários de bloco para documentação

<?code-excerpt "docs_good.dart (block-comments)"?>
```dart tag=good
void greet(String name) {
  // Suponha que temos um nome válido.
  print('Oi, $name!');
}
```

<?code-excerpt "docs_bad.dart (block-comments)"?>
```dart tag=bad
void greet(String name) {
  /* Suponha que temos um nome válido. */
  print('Oi, $name!');
}
```

Você pode usar um comentário de bloco (`/* ... */`) para comentar temporariamente
uma seção de código, mas todos os outros comentários devem usar `//`.

## Comentários de documentação

Comentários de documentação são especialmente úteis porque o [`dart doc`][] os
analisa e gera [belas páginas de documentação][docs] a partir deles. Um
comentário de documentação é qualquer comentário que aparece antes de uma
declaração e usa a sintaxe especial `///` que o `dart doc` procura.

[`dart doc`]: /tools/dart-doc
[docs]: {{site.dart-api}}

### FAÇA uso de comentários de documentação `///` para documentar membros e tipos

{% render 'linter-rule-mention.md', rules:'slash_for_doc_comments' %}

Usar um comentário de documentação em vez de um comentário regular permite
que o [`dart doc`][] o encontre e gere documentação para ele.

<?code-excerpt "docs_good.dart (use-doc-comments)"?>
```dart tag=good
/// O número de caracteres neste pedaço quando não dividido.
int get length => ...
```

<?code-excerpt "docs_good.dart (use-doc-comments)" replace="/^\///g"?>
```dart tag=bad
// O número de caracteres neste pedaço quando não dividido.
int get length => ...
```

Por razões históricas, o `dart doc` suporta duas sintaxes de comentários de
documentação: `///` ("estilo C#") e `/** ... */` ("estilo JavaDoc"). Preferimos
`///` porque é mais compacto. `/**` e `*/` adicionam duas linhas sem conteúdo a
um comentário de documentação multilinha. A sintaxe `///` também é mais fácil
de ler em algumas situações, como quando um comentário de documentação contém
uma lista com marcadores que usa `*` para marcar os itens da lista.

Se você se deparar com um código que ainda usa o estilo JavaDoc, considere limpá-lo.

### PREFIRA escrever comentários de documentação para APIs públicas

{% render 'linter-rule-mention.md', rules:'public_member_api_docs' %}

Você não precisa documentar todas as bibliotecas, variáveis de nível superior,
tipos e membros, mas deve documentar a maioria deles.

### CONSIDERE escrever um comentário de documentação em nível de biblioteca

Ao contrário de linguagens como Java, onde a classe é a única unidade de
organização do programa, em Dart, uma biblioteca é em si uma entidade com a qual
os usuários trabalham diretamente, importam e pensam. Isso torna a diretiva
`library` um ótimo lugar para documentação que apresenta ao leitor os principais
conceitos e funcionalidades fornecidas nela. Considere incluir:

* Um resumo de uma frase sobre para que serve a biblioteca.
* Explicações da terminologia usada em toda a biblioteca.
* Alguns exemplos de código completos que percorrem o uso da API.
* Links para as classes e funções mais importantes ou mais usadas.
* Links para referências externas sobre o domínio com o qual a biblioteca se
  preocupa.

Para documentar uma biblioteca, coloque um comentário de documentação antes
da diretiva `library` e quaisquer anotações que possam ser anexadas
no início do arquivo.

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// Uma biblioteca de testes muito boa.
@TestOn('browser')
library;
```

### CONSIDERE escrever comentários de documentação para APIs privadas

Comentários de documentação não são apenas para consumidores externos da API
pública da sua biblioteca. Eles também podem ser úteis para entender membros
privados que são chamados de outras partes da biblioteca.

### FAÇA comentários de documentação começarem com um resumo de uma única frase

Comece seu comentário de documentação com uma descrição breve e centrada no
usuário, terminando com um ponto final. Um fragmento de frase geralmente é
suficiente. Forneça apenas contexto suficiente para o leitor se orientar e
decidir se deve continuar lendo ou procurar em outro lugar a solução para seu
problema.

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
/// certas operações podem ou não ser possíveis. Se não houver um arquivo em
/// [path] ou ele não puder ser acessado, esta função lança [IOError]
/// ou [PermissionError], respectivamente. Caso contrário, isso exclui o arquivo.
void delete(String path) {
  ...
}
```

### FAÇA a primeira frase de um comentário de documentação em um parágrafo próprio

Adicione uma linha em branco após a primeira frase para dividi-la em seu próprio
parágrafo. Se mais de uma frase de explicação for útil, coloque o resto em
parágrafos posteriores.

Isso ajuda você a escrever uma primeira frase concisa que resume a
documentação. Além disso, ferramentas como `dart doc` usam o primeiro parágrafo
como um breve resumo em locais como listas de classes e membros.

<?code-excerpt "docs_good.dart (first-sentence-a-paragraph)"?>
```dart tag=good
/// Exclui o arquivo em [path].
///
/// Lança um [IOError] se o arquivo não puder ser encontrado. Lança um
/// [PermissionError] se o arquivo estiver presente, mas não puder ser excluído.
void delete(String path) {
  ...
}
```

<?code-excerpt "docs_bad.dart (first-sentence-a-paragraph)"?>
```dart tag=bad
/// Exclui o arquivo em [path]. Lança um [IOError] se o arquivo não puder
/// ser encontrado. Lança um [PermissionError] se o arquivo estiver presente, mas
/// não puder ser excluído.
void delete(String path) {
  ...
}
```

### EVITE redundância com o contexto circundante

O leitor do comentário de documentação de uma classe pode ver claramente o nome
da classe, quais interfaces ela implementa, etc. Ao ler a documentação de um
membro, a assinatura está ali e a classe envolvente é óbvia. Nada disso precisa
ser explicado no comentário de documentação. Em vez disso, concentre-se em
explicar o que o leitor *não* sabe.

<?code-excerpt "docs_good.dart (redundant)"?>
```dart tag=good
class RadioButtonWidget extends Widget {
  /// Define o texto de ajuda para [lines], que deve ter sido ajustado
  /// usando a fonte atual.
  void tooltip(List<String> lines) {
    ...
  }
}
```

<?code-excerpt "docs_bad.dart (redundant)"?>
```dart tag=bad
class RadioButtonWidget extends Widget {
  /// Define o texto de ajuda para este widget de botão de rádio para a lista
  /// de strings em [lines].
  void tooltip(List<String> lines) {
    ...
  }
}
```

Se você realmente não tem nada interessante a dizer
que não possa ser inferido da própria declaração,
então omita o comentário de documentação.
É melhor não dizer nada
do que desperdiçar o tempo de um leitor dizendo algo que ele já sabe.

### PREFIRA começar comentários de função ou método com verbos na terceira pessoa

O comentário de documentação deve se concentrar no que o código *faz*.

<?code-excerpt "docs_good.dart (third-person)"?>
```dart tag=good
/// Retorna `true` se cada elemento satisfaz o [predicate].
bool all(bool predicate(T element)) => ...

/// Inicia o cronômetro se ainda não estiver em execução.
void start() {
  ...
}
```

### PREFIRA iniciar um comentário de variável ou propriedade não booleana com uma frase substantiva

O comentário de documentação deve enfatizar o que a propriedade *é*. Isso vale
até para getters que podem fazer cálculos ou outros trabalhos. O que interessa
ao chamador é o *resultado* desse trabalho, não o trabalho em si.

<?code-excerpt "docs_good.dart (noun-phrases-for-non-boolean-var-etc)"?>
```dart tag=good
/// O dia atual da semana, onde `0` é domingo.
int weekday;

/// O número de botões marcados na página.
int get checkedCount => ...
```

### PREFIRA começar um comentário de variável ou propriedade booleana com "Se" seguido por um substantivo ou frase gerundiva

O comentário de documentação deve esclarecer os estados que esta variável
representa. Isso vale até para getters que podem fazer cálculos ou outros
trabalhos. O que interessa ao chamador é o *resultado* desse trabalho, não o
trabalho em si.

<?code-excerpt "docs_good.dart (noun-phrases-for-boolean-var-etc)"?>
```dart tag=good
/// Se o modal está atualmente exibido para o usuário.
bool isVisible;

/// Se o modal deve confirmar a intenção do usuário na navegação.
bool get shouldConfirm => ...

/// Se redimensionar a janela atual do navegador também redimensionará o modal.
bool get canResize => ...
```

:::note
Esta diretriz intencionalmente não inclui o uso de "Se ou não". Em muitos
casos, o uso de "ou não" com "se" é supérfluo e pode ser omitido,
principalmente quando usado neste contexto.
:::

### NÃO escreva documentação para o getter e setter de uma propriedade

Se uma propriedade tiver um getter e um setter, crie um comentário de
documentação para apenas um deles. `dart doc` trata o getter e o setter como
um único campo e, se tanto o getter quanto o setter tiverem comentários de
documentação, o `dart doc` descarta o comentário de documentação do setter.

<?code-excerpt "docs_good.dart (getter-and-setter)"?>
```dart tag=good
/// O nível de pH da água na piscina.
///
/// Varia de 0-14, representando ácido a básico, com 7 sendo neutro.
int get phLevel => ...
set phLevel(int level) => ...
```

<?code-excerpt "docs_bad.dart (getter-and-setter)"?>
```dart tag=bad
/// A profundidade da água na piscina, em metros.
int get waterDepth => ...

/// Atualiza a profundidade da água para um total de [meters] em altura.
set waterDepth(int meters) => ...
```

### PREFIRA iniciar comentários de biblioteca ou tipo com frases substantivas

Os comentários de documentação para classes geralmente são a documentação mais
importante do seu programa. Eles descrevem os invariantes do tipo, estabelecem
a terminologia que ele usa e fornecem contexto para os outros comentários de
documentação para os membros da classe. Um pequeno esforço extra aqui pode
tornar todos os outros membros mais simples de documentar.

<?code-excerpt "docs_good.dart (noun-phrases-for-type-or-lib)"?>
```dart tag=good
/// Um pedaço de texto de saída não divisível terminado por uma nova linha
/// rígida ou suave.
///
/// ...
class Chunk { ... }
```

### CONSIDERE incluir exemplos de código em comentários de documentação

<?code-excerpt "docs_good.dart (code-sample)"?>
````dart tag=good
/// Retorna o menor de dois números.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
````

Os humanos são ótimos em generalizar a partir de exemplos, então até mesmo um
único exemplo de código torna uma API mais fácil de aprender.

### FAÇA uso de colchetes em comentários de documentação para se referir a identificadores no escopo

{% render 'linter-rule-mention.md', rules:'comment_references' %}

Se você envolver coisas como nomes de variáveis, métodos ou tipos em colchetes,
o `dart doc` procurará o nome e o vinculará à documentação da API relevante.
Parênteses são opcionais,
mas podem deixar mais claro quando você está se referindo a um método ou
construtor.

<?code-excerpt "docs_good.dart (identifiers)"?>
```dart tag=good
/// Lança um [StateError] se ...
/// semelhante a [anotherMethod()], mas ...
```

Para vincular a um membro de uma classe específica, use o nome da classe e o
nome do membro, separados por um ponto:

<?code-excerpt "docs_good.dart (member)"?>
```dart tag=good
/// Semelhante a [Duration.inDays], mas lida com dias fracionários.
```

A sintaxe de ponto também pode ser usada para se referir a construtores nomeados.
Para o construtor não nomeado, use `.new` após o nome da classe:

<?code-excerpt "docs_good.dart (ctor)"?>
```dart tag=good
/// Para criar um ponto, chame [Point.new] ou use [Point.polar] para ...
```

### FAÇA uso de texto para explicar parâmetros, valores de retorno e exceções

Outras linguagens usam tags e seções detalhadas para descrever quais são os
parâmetros e retornos de um método.

<?code-excerpt "docs_bad.dart (no-annotations)"?>
```dart tag=bad
/// Define um sinalizador com o nome e a abreviação fornecidos.
///
/// @param name O nome do sinalizador.
/// @param abbr A abreviação do sinalizador.
/// @returns O novo sinalizador.
/// @throws ArgumentError Se já houver uma opção com
///     o nome ou abreviação fornecidos.
Flag addFlag(String name, String abbr) => ...
```

A convenção em Dart é integrar isso na descrição do método e destacar os
parâmetros usando colchetes.

<?code-excerpt "docs_good.dart (no-annotations)"?>
```dart tag=good
/// Define um sinalizador.
///
/// Lança um [ArgumentError] se já houver uma opção chamada [name] ou
/// já houver uma opção usando a abreviação [abbr]. Retorna o novo sinalizador.
Flag addFlag(String name, String abbr) => ...
```

### FAÇA colocar comentários de documentação antes das anotações de metadados

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

## Markdown

Você pode usar a maioria das formatações [markdown][] em seus comentários de
documentação e o `dart doc` as processará de acordo usando o [pacote markdown][].

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package.]: {{site.pub-pkg}}/markdown

Existem vários guias para apresentar o Markdown. Sua popularidade universal é
o motivo pelo qual o escolhemos. Aqui está apenas um exemplo rápido para dar
uma ideia do que é suportado:

<?code-excerpt "docs_good.dart (markdown)"?>
````dart
/// Este é um parágrafo de texto normal.
///
/// Esta frase tem *duas* palavras _enfatizadas_ (itálico) e **duas**
/// __fortes__ (negrito).
///
/// Uma linha em branco cria um parágrafo separado. Tem algum `código em linha`
/// delimitado usando crases.
///
/// * Listas não ordenadas.
/// * Parecem listas de marcadores ASCII.
/// * Você também pode usar `-` ou `+`.
///
/// 1. Listas numeradas.
/// 2. São, bem, numeradas.
/// 1. Mas os valores não importam.
///
///     * Você pode aninhar listas também.
///     * Elas devem ter um recuo de pelo menos 4 espaços.
///     * (Bem, 5 incluindo o espaço após `///`.)
///
/// Blocos de código são cercados por crases triplas:
///
/// ```dart
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// A linguagem de código (para realce de sintaxe) é Dart por padrão. Você pode
/// especificá-la colocando o nome da linguagem após as crases de abertura:
///
/// ```html
/// <h1>HTML é mágico!</h1>
/// ```
///
/// Links podem ser:
///
/// * https://www.just-a-bare-url.com
/// * [com a URL inline](https://google.com)
/// * [ou separados][ref link]
///
/// [ref link]: https://google.com
///
/// # Um cabeçalho
///
/// ## Um subcabeçalho
///
/// ### Um subsubcabeçalho
///
/// #### Se você precisar de tantos níveis de cabeçalhos, você está fazendo errado
````

### EVITE usar markdown em excesso

Na dúvida, formate menos. A formatação existe para iluminar seu conteúdo, não
para substituí-lo. As palavras são o que importa.

### EVITE usar HTML para formatação

Pode *ser* útil usá-lo em casos raros para coisas como tabelas, mas em quase
todos os casos, se for muito complexo para expressar em Markdown, é melhor não
expressá-lo.

### PREFIRA cercas de crase para blocos de código

O Markdown tem duas maneiras de indicar um bloco de código: recuar o código
quatro espaços em cada linha ou envolvê-lo em um par de linhas de "cerca" de
crase tripla. A primeira sintaxe é frágil quando usada em coisas como listas
Markdown, onde o recuo já é significativo ou quando o bloco de código em si
contém código recuado.

A sintaxe de crase evita esses problemas de recuo, permite indicar a linguagem
do código e é consistente com o uso de crases para código inline.

```dart tag=good
/// Você pode usar [CodeBlockExample] assim:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Sim."
/// ```
```

```dart tag=bad
/// Você pode usar [CodeBlockExample] assim:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Sim."
```

## Escrita

Pensamos em nós mesmos como programadores, mas a maioria dos caracteres em um
arquivo de origem são destinados principalmente para os humanos lerem. Inglês é
a linguagem em que codificamos para modificar o cérebro de nossos colegas de
trabalho. Como para qualquer linguagem de programação, vale a pena se esforçar
para melhorar sua proficiência.

Esta seção lista algumas diretrizes para nossa documentação. Você pode
aprender mais sobre as melhores práticas para escrita técnica, em geral, em
artigos como [Estilo de escrita técnica](https://en.wikiversity.org/wiki/Technical_writing_style).

### PREFIRA brevidade

Seja claro e preciso, mas também conciso.

### EVITE abreviações e acrônimos, a menos que sejam óbvios

Muitas pessoas não sabem o que significam "i.e.", "e.g." e "et al.". Aquele
acrônimo que você tem certeza que todos em sua área conhecem pode não ser tão
amplamente conhecido como você pensa.

### PREFIRA usar "este" em vez de "o" para se referir à instância de um membro

Ao documentar um membro de uma classe, muitas vezes você precisa se referir de
volta ao objeto no qual o membro está sendo chamado. Usar "o" pode ser ambíguo.

<?code-excerpt "docs_good.dart (this)"?>
```dart
class Box {
  /// O valor que este envolve.
  Object? _value;

  /// Verdadeiro se esta caixa contém um valor.
  bool get hasValue => _value != null;
}
```
