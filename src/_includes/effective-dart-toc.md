{% comment %}
This file is generated from the other files in this directory.
To re-generate it, please run the following command from root of
the project:

```
dart run dash_site effective-dart
```
{% endcomment %}

<div class="side-by-side"><div>

### Style


**Identificadores {:#identifiers}**

* <a href='/effective-dart/style#do-name-types-using-uppercamelcase'>FAÇA nomear tipos usando <code>UpperCamelCase</code>.</a>
* <a href='/effective-dart/style#do-name-extensions-using-uppercamelcase'>FAÇA nomear extensões usando <code>UpperCamelCase</code>.</a>
* <a href='/effective-dart/style#do-name-packages-and-file-system-entities-using-lowercase-with-underscores'>FAÇA nomear pacotes, diretórios e arquivos-fonte usando <code>lowercase_with_underscores</code>.</a>
* <a href='/effective-dart/style#do-name-import-prefixes-using-lowercase_with_underscores'>FAÇA nomear prefixos de import usando <code>lowercase_with_underscores</code>.</a>
* <a href='/effective-dart/style#do-name-other-identifiers-using-lowercamelcase'>FAÇA nomear os demais identificadores usando <code>lowerCamelCase</code>.</a>
* <a href='/effective-dart/style#prefer-using-lowercamelcase-for-constant-names'>PREFIRA usar <code>lowerCamelCase</code> para nomes de constantes.</a>
* <a href='/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words'>FAÇA escrever com maiúscula siglas e abreviações com mais de duas letras, como palavras.</a>
* <a href='/effective-dart/style#prefer-using-wildcards-for-unused-callback-parameters'>PREFIRA usar curingas para parâmetros de callback não usados.</a>
* <a href='/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private'>NÃO use underscore inicial em identificadores que não são privados.</a>
* <a href='/effective-dart/style#dont-use-prefix-letters'>NÃO use letras de prefixo.</a>
* <a href='/effective-dart/style#dont-explicitly-name-libraries'>NÃO nomeie bibliotecas explicitamente.</a>

**Ordenação {:#ordering}**

* <a href='/effective-dart/style#do-place-dart-imports-before-other-imports'>FAÇA colocar imports <code>dart:</code> antes dos outros imports.</a>
* <a href='/effective-dart/style#do-place-package-imports-before-relative-imports'>FAÇA colocar imports <code>package:</code> antes dos imports relativos.</a>
* <a href='/effective-dart/style#do-specify-exports-in-a-separate-section-after-all-imports'>FAÇA especificar exports em uma seção separada, depois de todos os imports.</a>
* <a href='/effective-dart/style#do-sort-sections-alphabetically'>FAÇA ordenar as seções em ordem alfabética.</a>

**Formatação {:#formatting}**

* <a href='/effective-dart/style#do-format-your-code-using-dart-format'>FAÇA formatar seu código usando <code>dart format</code>.</a>
* <a href='/effective-dart/style#consider-changing-your-code-to-make-it-more-formatter-friendly'>CONSIDERE mudar seu código para torná-lo mais amigável ao formatador.</a>
* <a href='/effective-dart/style#prefer-lines-80-characters-or-fewer'>PREFIRA linhas com 80 caracteres ou menos.</a>
* <a href='/effective-dart/style#do-use-curly-braces-for-all-flow-control-statements'>FAÇA usar chaves em todas as estruturas de controle de fluxo.</a>

</div>
<div>


### Documentation


**Comentários {:#comments}**

* <a href='/effective-dart/documentation#do-format-comments-like-sentences'>FAÇA formatar comentários como frases.</a>
* <a href='/effective-dart/documentation#dont-use-block-comments-for-documentation'>NÃO usar comentários de bloco para documentação.</a>

**Comentários de documentação {:#doc-comments}**

* <a href='/effective-dart/documentation#do-use-doc-comments-to-document-members-and-types'>FAÇA usar comentários de documentação <code>///</code> para documentar membros e tipos.</a>
* <a href='/effective-dart/documentation#prefer-writing-doc-comments-for-public-apis'>PREFIRA escrever comentários de documentação para APIs públicas.</a>
* <a href='/effective-dart/documentation#consider-writing-a-library-level-doc-comment'>CONSIDERE escrever um comentário de documentação no nível da biblioteca.</a>
* <a href='/effective-dart/documentation#consider-writing-doc-comments-for-private-apis'>CONSIDERE escrever comentários de documentação para APIs privadas.</a>
* <a href='/effective-dart/documentation#do-start-doc-comments-with-a-single-sentence-summary'>FAÇA começar comentários de documentação com um resumo de uma frase.</a>
* <a href='/effective-dart/documentation#do-separate-the-first-sentence-of-a-doc-comment-into-its-own-paragraph'>FAÇA separar a primeira frase de um comentário de documentação em seu próprio parágrafo.</a>
* <a href='/effective-dart/documentation#avoid-redundancy-with-the-surrounding-context'>EVITE redundância com o contexto ao redor.</a>
* <a href='/effective-dart/documentation#prefer-starting-comments-of-a-function-or-method-with-third-person-verbs-if-its-main-purpose-is-a-side-effect'>PREFIRA começar comentários de funções ou métodos com verbos na terceira pessoa se o propósito principal for um efeito colateral.</a>
* <a href='/effective-dart/documentation#prefer-starting-a-non-boolean-variable-or-property-comment-with-a-noun-phrase'>PREFIRA começar o comentário de uma variável ou propriedade não booleana com um sintagma nominal.</a>
* <a href='/effective-dart/documentation#prefer-starting-a-boolean-variable-or-property-comment-with-whether-followed-by-a-noun-or-gerund-phrase'>PREFIRA começar o comentário de uma variável ou propriedade booleana com &quot;Whether&quot; seguido de um sintagma nominal ou gerundial.</a>
* <a href='/effective-dart/documentation#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose'>PREFIRA um sintagma nominal ou verbal não imperativo para uma função ou método se retornar um valor for seu propósito principal.</a>
* <a href='/effective-dart/documentation#dont-write-documentation-for-both-the-getter-and-setter-of-a-property'>NÃO escrever documentação para o getter e o setter de uma propriedade.</a>
* <a href='/effective-dart/documentation#prefer-starting-library-or-type-comments-with-noun-phrases'>PREFIRA começar comentários de biblioteca ou de tipo com sintagmas nominais.</a>
* <a href='/effective-dart/documentation#consider-including-code-samples-in-doc-comments'>CONSIDERE incluir exemplos de código em comentários de documentação.</a>
* <a href='/effective-dart/documentation#do-use-square-brackets-in-doc-comments-to-refer-to-in-scope-identifiers'>FAÇA usar colchetes em comentários de documentação para se referir a identificadores no escopo.</a>
* <a href='/effective-dart/documentation#do-use-prose-to-explain-parameters-return-values-and-exceptions'>FAÇA usar texto corrido para explicar parâmetros, valores de retorno e exceções.</a>
* <a href='/effective-dart/documentation#do-put-doc-comments-before-metadata-annotations'>FAÇA colocar comentários de documentação antes das anotações de metadados.</a>

**Markdown {:#markdown}**

* <a href='/effective-dart/documentation#avoid-using-markdown-excessively'>EVITE usar markdown em excesso.</a>
* <a href='/effective-dart/documentation#avoid-using-html-for-formatting'>EVITE usar HTML para formatação.</a>
* <a href='/effective-dart/documentation#prefer-backtick-fences-for-code-blocks'>PREFIRA cercas de crase para blocos de código.</a>

**Escrita {:#writing}**

* <a href='/effective-dart/documentation#prefer-brevity'>PREFIRA concisão.</a>
* <a href='/effective-dart/documentation#avoid-abbreviations-and-acronyms-unless-they-are-obvious'>EVITE abreviações e siglas, a menos que sejam óbvias.</a>
* <a href='/effective-dart/documentation#prefer-using-this-instead-of-the-to-refer-to-a-members-instance'>PREFIRA usar &quot;this&quot; em vez de &quot;the&quot; para se referir à instância de um membro.</a>

</div>
<div>


### Usage


**Bibliotecas {:#libraries}**

* <a href='/effective-dart/usage#do-use-strings-in-part-of-directives'>FAÇA usar strings em diretivas <code>part of</code>.</a>
* <a href='/effective-dart/usage#dont-import-libraries-that-are-inside-the-src-directory-of-another-package'>NÃO importe bibliotecas que estão dentro do diretório <code>src</code> de outro pacote.</a>
* <a href='/effective-dart/usage#dont-allow-an-import-path-to-reach-into-or-out-of-lib'>NÃO permita que um caminho de import alcance dentro ou fora de <code>lib</code>.</a>
* <a href='/effective-dart/usage#prefer-relative-import-paths'>PREFIRA caminhos de import relativos.</a>

**Null {:#null}**

* <a href='/effective-dart/usage#dont-explicitly-initialize-variables-to-null'>NÃO inicialize variáveis explicitamente para <code>null</code>.</a>
* <a href='/effective-dart/usage#dont-use-an-explicit-default-value-of-null'>NÃO use um valor padrão explícito de <code>null</code>.</a>
* <a href='/effective-dart/usage#dont-use-true-or-false-in-equality-operations'>NÃO use <code>true</code> ou <code>false</code> em operações de igualdade.</a>
* <a href='/effective-dart/usage#avoid-late-variables-if-you-need-to-check-whether-they-are-initialized'>EVITE variáveis <code>late</code> se você precisar verificar se elas foram inicializadas.</a>
* <a href='/effective-dart/usage#consider-type-promotion-or-null-check-patterns-for-using-nullable-types'>CONSIDERE promoção de tipo ou padrões de verificação de null para usar tipos nullable.</a>

**Strings {:#strings}**

* <a href='/effective-dart/usage#do-use-adjacent-strings-to-concatenate-string-literals'>FAÇA usar strings adjacentes para concatenar literais de string.</a>
* <a href='/effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values'>PREFIRA usar interpolação para compor strings e valores.</a>
* <a href='/effective-dart/usage#avoid-using-curly-braces-in-interpolation-when-not-needed'>EVITE usar chaves na interpolação quando não forem necessárias.</a>

**Coleções {:#collections}**

* <a href='/effective-dart/usage#do-use-collection-literals-when-possible'>FAÇA usar literais de coleção sempre que possível.</a>
* <a href='/effective-dart/usage#dont-use-length-to-see-if-a-collection-is-empty'>NÃO use <code>.length</code> para verificar se uma coleção está vazia.</a>
* <a href='/effective-dart/usage#avoid-using-iterable-foreach-with-a-function-literal'>EVITE usar <code>Iterable.forEach()</code> com um literal de função.</a>
* <a href='/effective-dart/usage#dont-use-list-from-unless-you-intend-to-change-the-type-of-the-result'>NÃO use <code>List.from()</code> a menos que você pretenda mudar o tipo do resultado.</a>
* <a href='/effective-dart/usage#do-use-wheretype-to-filter-a-collection-by-type'>FAÇA usar <code>whereType()</code> para filtrar uma coleção por tipo.</a>
* <a href='/effective-dart/usage#dont-use-cast-when-a-nearby-operation-will-do'>NÃO use <code>cast()</code> quando uma operação próxima resolver.</a>
* <a href='/effective-dart/usage#avoid-using-cast'>EVITE usar <code>cast()</code>.</a>

**Funções {:#functions}**

* <a href='/effective-dart/usage#do-use-a-function-declaration-to-bind-a-function-to-a-name'>FAÇA usar uma declaração de função para vincular uma função a um nome.</a>
* <a href='/effective-dart/usage#dont-create-a-lambda-when-a-tear-off-will-do'>NÃO crie uma lambda quando um tear-off resolver.</a>

**Variáveis {:#variables}**

* <a href='/effective-dart/usage#do-follow-a-consistent-rule-for-var-and-final-on-local-variables'>FAÇA seguir uma regra consistente para <code>var</code> e <code>final</code> em variáveis locais.</a>
* <a href='/effective-dart/usage#avoid-storing-what-you-can-calculate'>EVITE armazenar o que você pode calcular.</a>

**Membros {:#members}**

* <a href='/effective-dart/usage#dont-wrap-a-field-in-a-getter-and-setter-unnecessarily'>NÃO envolva um campo em um getter e setter sem necessidade.</a>
* <a href='/effective-dart/usage#prefer-using-a-final-field-to-make-a-read-only-property'>PREFIRA usar um campo <code>final</code> para criar uma propriedade somente leitura.</a>
* <a href='/effective-dart/usage#consider-using-for-simple-members'>CONSIDERE usar <code>=&gt;</code> para membros simples.</a>
* <a href='/effective-dart/usage#dont-use-this-when-not-needed-to-avoid-shadowing'>NÃO use <code>this.</code> exceto para redirecionar a um construtor nomeado ou para evitar sombreamento.</a>
* <a href='/effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible'>FAÇA inicializar campos na sua declaração sempre que possível.</a>

**Construtores {:#constructors}**

* <a href='/effective-dart/usage#do-use-initializing-formals-when-possible'>FAÇA usar parâmetros inicializadores sempre que possível.</a>
* <a href='/effective-dart/usage#dont-use-late-when-a-constructor-initializer-list-will-do'>NÃO use <code>late</code> quando uma lista de inicializadores do construtor resolver.</a>
* <a href='/effective-dart/usage#do-use-instead-of-for-empty-constructor-bodies'>FAÇA usar <code>;</code> em vez de <code>{}</code> para corpos de construtor vazios.</a>
* <a href='/effective-dart/usage#prefer-using-concise-constructor-syntax'>PREFIRA usar a sintaxe concisa de construtores.</a>
* <a href='/effective-dart/usage#dont-use-new'>NÃO use <code>new</code>.</a>
* <a href='/effective-dart/usage#dont-use-const-redundantly'>NÃO use <code>const</code> de forma redundante.</a>

**Tratamento de erros {:#error-handling}**

* <a href='/effective-dart/usage#avoid-catches-without-on-clauses'>EVITE capturas sem cláusulas <code>on</code>.</a>
* <a href='/effective-dart/usage#dont-discard-errors-from-catches-without-on-clauses'>NÃO descarte erros em capturas sem cláusulas <code>on</code>.</a>
* <a href='/effective-dart/usage#do-throw-objects-that-implement-error-only-for-programmatic-errors'>FAÇA lançar objetos que implementam <code>Error</code> apenas para erros de programação.</a>
* <a href='/effective-dart/usage#dont-explicitly-catch-error-or-types-that-implement-it'>NÃO capture explicitamente <code>Error</code> ou tipos que o implementam.</a>
* <a href='/effective-dart/usage#do-use-rethrow-to-rethrow-a-caught-exception'>FAÇA usar <code>rethrow</code> para relançar uma exceção capturada.</a>

**Assincronia {:#asynchrony}**

* <a href='/effective-dart/usage#prefer-asyncawait-over-using-raw-futures'>PREFIRA async/await em vez de usar futures diretamente.</a>
* <a href='/effective-dart/usage#dont-use-async-when-it-has-no-useful-effect'>NÃO use <code>async</code> quando ele não tem efeito útil.</a>
* <a href='/effective-dart/usage#consider-using-higher-order-methods-to-transform-a-stream'>CONSIDERE usar métodos de ordem superior para transformar um stream.</a>
* <a href='/effective-dart/usage#avoid-using-completer-directly'>EVITE usar Completer diretamente.</a>
* <a href='/effective-dart/usage#do-test-for-futuret-when-disambiguating-a-futureort-whose-type-argument-could-be-object'>FAÇA testar <code>Future&lt;T&gt;</code> ao desambiguar um <code>FutureOr&lt;T&gt;</code> cujo argumento de tipo pode ser <code>Object</code>.</a>

</div>
<div>


### Design


**Nomes {:#names}**

* <a href='/effective-dart/design#do-use-terms-consistently'>FAÇA usar termos consistentemente.</a>
* <a href='/effective-dart/design#avoid-abbreviations'>EVITE abreviações.</a>
* <a href='/effective-dart/design#prefer-putting-the-most-descriptive-noun-last'>PREFIRA colocar o substantivo mais descritivo por último.</a>
* <a href='/effective-dart/design#consider-making-the-code-read-like-a-sentence'>CONSIDERE fazer o código ler como uma sentença.</a>
* <a href='/effective-dart/design#prefer-a-noun-phrase-for-a-non-boolean-property-or-variable'>PREFIRA uma frase substantiva para uma propriedade ou variável não-booleana.</a>
* <a href='/effective-dart/design#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable'>PREFIRA uma frase verbal não-imperativa para uma propriedade ou variável booleana.</a>
* <a href='/effective-dart/design#consider-omitting-the-verb-for-a-named-boolean-parameter'>CONSIDERE omitir o verbo para um <em>parâmetro</em> booleano nomeado.</a>
* <a href='/effective-dart/design#prefer-the-positive-name-for-a-boolean-property-or-variable'>PREFIRA o nome &quot;positivo&quot; para uma propriedade ou variável booleana.</a>
* <a href='/effective-dart/design#prefer-an-imperative-verb-phrase-for-a-function-or-method-whose-main-purpose-is-a-side-effect'>PREFIRA uma frase verbal imperativa para uma função ou método cujo principal propósito é um efeito colateral.</a>
* <a href='/effective-dart/design#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose'>PREFIRA uma frase substantiva ou frase verbal não-imperativa para uma função ou método se retornar um valor é seu propósito principal.</a>
* <a href='/effective-dart/design#consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs'>CONSIDERE uma frase verbal imperativa para uma função ou método se você quer chamar atenção para o trabalho que realiza.</a>
* <a href='/effective-dart/design#avoid-starting-a-function-or-method-name-with-get'>EVITE iniciar um nome de método com <code>get</code>.</a>
* <a href='/effective-dart/design#prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object'>PREFIRA nomear um método <code>to___()</code> se ele copia o estado do objeto para um novo objeto.</a>
* <a href='/effective-dart/design#prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object'>PREFIRA nomear um método <code>as___()</code> se ele retorna uma representação diferente apoiada pelo objeto original.</a>
* <a href='/effective-dart/design#avoid-describing-the-parameters-in-the-functions-or-methods-name'>EVITE descrever os parâmetros no nome da função ou método.</a>
* <a href='/effective-dart/design#do-follow-existing-mnemonic-conventions-when-naming-type-parameters'>FAÇA seguir as convenções mnemônicas existentes ao nomear parâmetros de tipo.</a>

**Bibliotecas {:#libraries}**

* <a href='/effective-dart/design#prefer-making-declarations-private'>PREFIRA tornar declarações privadas.</a>
* <a href='/effective-dart/design#consider-declaring-multiple-classes-in-the-same-library'>CONSIDERE declarar múltiplas classes na mesma biblioteca.</a>

**Classes e mixins {:#classes-and-mixins}**

* <a href='/effective-dart/design#avoid-defining-a-one-member-abstract-class-when-a-simple-function-will-do'>EVITE definir uma classe abstrata de um membro quando uma função simples serve.</a>
* <a href='/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members'>EVITE definir uma classe que contém apenas membros estáticos.</a>
* <a href='/effective-dart/design#avoid-extending-a-class-that-isnt-intended-to-be-subclassed'>EVITE estender uma classe que não é destinada a ser subclasse.</a>
* <a href='/effective-dart/design#do-use-class-modifiers-to-control-if-your-class-can-be-extended'>FAÇA usar modificadores de classe para controlar se sua classe pode ser estendida.</a>
* <a href='/effective-dart/design#avoid-implementing-a-class-that-isnt-intended-to-be-an-interface'>EVITE implementar uma classe que não é destinada a ser uma interface.</a>
* <a href='/effective-dart/design#do-use-class-modifiers-to-control-if-your-class-can-be-an-interface'>FAÇA usar modificadores de classe para controlar se sua classe pode ser uma interface.</a>
* <a href='/effective-dart/design#prefer-defining-a-pure-mixin-or-pure-class-to-a-mixin-class'>PREFIRA definir um <code>mixin</code> puro ou <code>class</code> pura a um <code>mixin class</code>.</a>

**Construtores {:#constructors}**

* <a href='/effective-dart/design#consider-making-your-constructor-const-if-the-class-supports-it'>CONSIDERE tornar seu construtor <code>const</code> se a classe suporta isso.</a>

**Membros {:#members}**

* <a href='/effective-dart/design#prefer-making-fields-and-top-level-variables-final'>PREFIRA tornar campos e variáveis de nível superior <code>final</code>.</a>
* <a href='/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties'>FAÇA usar getters para operações que conceitualmente acessam propriedades.</a>
* <a href='/effective-dart/design#do-use-setters-for-operations-that-conceptually-change-properties'>FAÇA usar setters para operações que conceitualmente mudam propriedades.</a>
* <a href='/effective-dart/design#dont-define-a-setter-without-a-corresponding-getter'>NÃO defina um setter sem um getter correspondente.</a>
* <a href='/effective-dart/design#avoid-using-runtime-type-tests-to-fake-overloading'>EVITE usar testes de tipo em tempo de execução para falsificar sobrecarga.</a>
* <a href='/effective-dart/design#avoid-public-late-final-fields-without-initializers'>EVITE campos <code>late final</code> públicos sem inicializadores.</a>
* <a href='/effective-dart/design#avoid-returning-nullable-future-stream-and-collection-types'>EVITE retornar tipos <code>Future</code>, <code>Stream</code>, e coleção anuláveis.</a>
* <a href='/effective-dart/design#avoid-returning-this-from-methods-just-to-enable-a-fluent-interface'>EVITE retornar <code>this</code> de métodos apenas para habilitar uma interface fluente.</a>

**Tipos {:#types}**

* <a href='/effective-dart/design#do-type-annotate-variables-without-initializers'>FAÇA anotar o tipo de variáveis sem inicializadores.</a>
* <a href='/effective-dart/design#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious'>FAÇA anotar o tipo de campos e variáveis de nível superior se o tipo não é óbvio.</a>
* <a href='/effective-dart/design#dont-redundantly-type-annotate-initialized-local-variables'>NÃO anote redundantemente o tipo de variáveis locais inicializadas.</a>
* <a href='/effective-dart/design#do-annotate-return-types-on-function-declarations'>FAÇA anotar tipos de retorno em declarações de função.</a>
* <a href='/effective-dart/design#do-annotate-parameter-types-on-function-declarations'>FAÇA anotar tipos de parâmetros em declarações de função.</a>
* <a href='/effective-dart/design#dont-annotate-inferred-parameter-types-on-function-expressions'>NÃO anote tipos de parâmetros inferidos em expressões de função.</a>
* <a href='/effective-dart/design#dont-type-annotate-initializing-formals'>NÃO anote o tipo de formals inicializadores.</a>
* <a href='/effective-dart/design#do-write-type-arguments-on-generic-invocations-that-arent-inferred'>FAÇA escrever argumentos de tipo em invocações genéricas que não são inferidas.</a>
* <a href='/effective-dart/design#dont-write-type-arguments-on-generic-invocations-that-are-inferred'>NÃO escreva argumentos de tipo em invocações genéricas que são inferidas.</a>
* <a href='/effective-dart/design#avoid-writing-incomplete-generic-types'>EVITE escrever tipos genéricos incompletos.</a>
* <a href='/effective-dart/design#do-annotate-with-dynamic-instead-of-letting-inference-fail'>FAÇA anotar com <code>dynamic</code> em vez de deixar a inferência falhar.</a>
* <a href='/effective-dart/design#prefer-signatures-in-function-type-annotations'>PREFIRA assinaturas em anotações de tipo de função.</a>
* <a href='/effective-dart/design#dont-specify-a-return-type-for-a-setter'>NÃO especifique um tipo de retorno para um setter.</a>
* <a href='/effective-dart/design#dont-use-the-legacy-typedef-syntax'>NÃO use a sintaxe typedef legada.</a>
* <a href='/effective-dart/design#prefer-inline-function-types-over-typedefs'>PREFIRA tipos de função inline a typedefs.</a>
* <a href='/effective-dart/design#prefer-using-function-type-syntax-for-parameters'>PREFIRA usar sintaxe de tipo de função para parâmetros.</a>
* <a href='/effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking'>EVITE usar <code>dynamic</code> a menos que você queira desabilitar verificação estática.</a>
* <a href='/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values'>FAÇA usar <code>Future&lt;void&gt;</code> como tipo de retorno de membros assíncronos que não produzem valores.</a>
* <a href='/effective-dart/design#avoid-using-futureort-as-a-return-type'>EVITE usar <code>FutureOr&lt;T&gt;</code> como tipo de retorno.</a>

**Parâmetros {:#parameters}**

* <a href='/effective-dart/design#avoid-positional-boolean-parameters'>EVITE parâmetros booleanos posicionais.</a>
* <a href='/effective-dart/design#avoid-optional-positional-parameters-if-the-user-may-want-to-omit-earlier-parameters'>EVITE parâmetros posicionais opcionais se o usuário pode querer omitir parâmetros anteriores.</a>
* <a href='/effective-dart/design#avoid-mandatory-parameters-that-accept-a-special-no-argument-value'>EVITE parâmetros obrigatórios que aceitam um valor especial de &quot;sem argumento&quot;.</a>
* <a href='/effective-dart/design#do-use-inclusive-start-and-exclusive-end-parameters-to-accept-a-range'>FAÇA usar parâmetros de início inclusivo e fim exclusivo para aceitar um intervalo.</a>

**Igualdade {:#equality}**

* <a href='/effective-dart/design#do-override-hashcode-if-you-override'>FAÇA sobrescrever <code>hashCode</code> se você sobrescrever <code>==</code>.</a>
* <a href='/effective-dart/design#do-make-your-operator-obey-the-mathematical-rules-of-equality'>FAÇA seu operador <code>==</code> obedecer as regras matemáticas de igualdade.</a>
* <a href='/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes'>EVITE definir igualdade personalizada para classes mutáveis.</a>
* <a href='/effective-dart/design#dont-make-the-parameter-to-nullable'>NÃO torne o parâmetro para <code>==</code> anulável.</a>

</div>
</div>
