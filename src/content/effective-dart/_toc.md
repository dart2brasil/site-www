{% comment %}
ia-translate: true
Este arquivo é gerado a partir dos outros arquivos neste diretório.
Para re-gerá-lo, por favor execute o seguinte comando a partir da raiz
do projeto:

```
./dash_site effective-dart
```
{% endcomment %}
    
<div class='effective_dart--summary_column'>

### Estilo


**Identificadores**

*   <a href='/effective-dart/style#do-name-types-using-uppercamelcase'>USAR <code>UpperCamelCase</code> para nomear tipos.</a>
*   <a href='/effective-dart/style#do-name-extensions-using-uppercamelcase'>USAR <code>UpperCamelCase</code> para nomear extensões.</a>
*   <a href='/effective-dart/style#do-name-packages-and-file-system-entities-using-lowercase-with-underscores'>USAR <code>lowercase_with_underscores</code> para nomear pacotes, diretórios e arquivos de código-fonte.</a>
*   <a href='/effective-dart/style#do-name-import-prefixes-using-lowercase_with_underscores'>USAR <code>lowercase_with_underscores</code> para nomear prefixos de importação.</a>
*   <a href='/effective-dart/style#do-name-other-identifiers-using-lowercamelcase'>USAR <code>lowerCamelCase</code> para nomear outros identificadores.</a>
*   <a href='/effective-dart/style#prefer-using-lowercamelcase-for-constant-names'>PREFERIR usar <code>lowerCamelCase</code> para nomes de constantes.</a>
*   <a href='/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words'>USAR maiúsculas em acrônimos e abreviações com mais de duas letras como palavras.</a>
*   <a href='/effective-dart/style#prefer-using-_-__-etc-for-unused-callback-parameters'>PREFERIR usar <code>_</code>, <code>__</code>, etc. para parâmetros de *callback* não utilizados.</a>
*   <a href='/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private'>NÃO usar um sublinhado inicial para identificadores que não são privados.</a>
*   <a href='/effective-dart/style#dont-use-prefix-letters'>NÃO usar letras de prefixo.</a>
*   <a href='/effective-dart/style#dont-explicitly-name-libraries'>NÃO nomear bibliotecas explicitamente.</a>

**Ordenação**

*   <a href='/effective-dart/style#do-place-dart-imports-before-other-imports'>COLOCAR as importações <code>dart:</code> antes das outras importações.</a>
*   <a href='/effective-dart/style#do-place-package-imports-before-relative-imports'>COLOCAR as importações <code>package:</code> antes das importações relativas.</a>
*   <a href='/effective-dart/style#do-specify-exports-in-a-separate-section-after-all-imports'>ESPECIFICAR exportações em uma seção separada após todas as importações.</a>
*   <a href='/effective-dart/style#do-sort-sections-alphabetically'>CLASSIFICAR as seções alfabeticamente.</a>

**Formatação**

*   <a href='/effective-dart/style#do-format-your-code-using-dart-format'>FORMATAR seu código usando <code>dart format</code>.</a>
*   <a href='/effective-dart/style#consider-changing-your-code-to-make-it-more-formatter-friendly'>CONSIDERAR alterar seu código para torná-lo mais amigável ao formatador.</a>
*   <a href='/effective-dart/style#avoid-lines-longer-than-80-characters'>EVITAR linhas com mais de 80 caracteres.</a>
*   <a href='/effective-dart/style#do-use-curly-braces-for-all-flow-control-statements'>USAR chaves para todas as declarações de controle de fluxo.</a>

</div>
<div class='effective_dart--summary_column'>


### Documentação


**Comentários**

*   <a href='/effective-dart/documentation#do-format-comments-like-sentences'>FORMATAR comentários como frases.</a>
*   <a href='/effective-dart/documentation#dont-use-block-comments-for-documentation'>NÃO usar comentários em bloco para documentação.</a>

**Comentários de documentação**

*   <a href='/effective-dart/documentation#do-use-doc-comments-to-document-members-and-types'>USAR comentários de documentação <code>///</code> para documentar membros e tipos.</a>
*   <a href='/effective-dart/documentation#prefer-writing-doc-comments-for-public-apis'>PREFERIR escrever comentários de documentação para APIs públicas.</a>
*   <a href='/effective-dart/documentation#consider-writing-a-library-level-doc-comment'>CONSIDERAR escrever um comentário de documentação no nível da biblioteca.</a>
*   <a href='/effective-dart/documentation#consider-writing-doc-comments-for-private-apis'>CONSIDERAR escrever comentários de documentação para APIs privadas.</a>
*   <a href='/effective-dart/documentation#do-start-doc-comments-with-a-single-sentence-summary'>COMEÇAR comentários de documentação com um resumo de uma única frase.</a>
*   <a href='/effective-dart/documentation#do-separate-the-first-sentence-of-a-doc-comment-into-its-own-paragraph'>SEPARAR a primeira frase de um comentário de documentação em seu próprio parágrafo.</a>
*   <a href='/effective-dart/documentation#avoid-redundancy-with-the-surrounding-context'>EVITAR redundância com o contexto circundante.</a>
*   <a href='/effective-dart/documentation#prefer-starting-function-or-method-comments-with-third-person-verbs'>PREFERIR iniciar comentários de função ou método com verbos na terceira pessoa.</a>
*   <a href='/effective-dart/documentation#prefer-starting-a-non-boolean-variable-or-property-comment-with-a-noun-phrase'>PREFERIR iniciar um comentário de variável ou propriedade não booleana com uma frase substantiva.</a>
*   <a href='/effective-dart/documentation#prefer-starting-a-boolean-variable-or-property-comment-with-whether-followed-by-a-noun-or-gerund-phrase'>PREFERIR iniciar um comentário de variável ou propriedade booleana com "Se" seguido por um substantivo ou frase gerundial.</a>
*   <a href='/effective-dart/documentation#dont-write-documentation-for-both-the-getter-and-setter-of-a-property'>NÃO escrever documentação para o *getter* e o *setter* de uma propriedade.</a>
*   <a href='/effective-dart/documentation#prefer-starting-library-or-type-comments-with-noun-phrases'>PREFERIR iniciar comentários de biblioteca ou tipo com frases substantivas.</a>
*   <a href='/effective-dart/documentation#consider-including-code-samples-in-doc-comments'>CONSIDERAR incluir exemplos de código em comentários de documentação.</a>
*   <a href='/effective-dart/documentation#do-use-square-brackets-in-doc-comments-to-refer-to-in-scope-identifiers'>USAR colchetes em comentários de documentação para se referir a identificadores dentro do escopo.</a>
*   <a href='/effective-dart/documentation#do-use-prose-to-explain-parameters-return-values-and-exceptions'>USAR prosa para explicar parâmetros, valores de retorno e exceções.</a>
*   <a href='/effective-dart/documentation#do-put-doc-comments-before-metadata-annotations'>COLOCAR comentários de documentação antes das anotações de metadados.</a>

**Markdown**

*   <a href='/effective-dart/documentation#avoid-using-markdown-excessively'>EVITAR usar markdown em excesso.</a>
*   <a href='/effective-dart/documentation#avoid-using-html-for-formatting'>EVITAR usar HTML para formatação.</a>
*   <a href='/effective-dart/documentation#prefer-backtick-fences-for-code-blocks'>PREFERIR delimitadores de crase para blocos de código.</a>

**Escrita**

*   <a href='/effective-dart/documentation#prefer-brevity'>PREFERIR brevidade.</a>
*   <a href='/effective-dart/documentation#avoid-abbreviations-and-acronyms-unless-they-are-obvious'>EVITAR abreviações e acrônimos, a menos que sejam óbvios.</a>
*   <a href='/effective-dart/documentation#prefer-using-this-instead-of-the-to-refer-to-a-members-instance'>PREFERIR usar "este" em vez de "o" para se referir à instância de um membro.</a>

</div>
<div style='clear:both'></div>
<div class='effective_dart--summary_column'>


### Uso


**Bibliotecas**

*   <a href='/effective-dart/usage#do-use-strings-in-part-of-directives'>USAR strings em diretivas <code>part of</code>.</a>
*   <a href='/effective-dart/usage#dont-import-libraries-that-are-inside-the-src-directory-of-another-package'>NÃO importar bibliotecas que estão dentro do diretório <code>src</code> de outro pacote.</a>
*   <a href='/effective-dart/usage#dont-allow-an-import-path-to-reach-into-or-out-of-lib'>NÃO permitir que um caminho de importação alcance dentro ou fora de <code>lib</code>.</a>
*   <a href='/effective-dart/usage#prefer-relative-import-paths'>PREFERIR caminhos de importação relativos.</a>

**Nulo**

*   <a href='/effective-dart/usage#dont-explicitly-initialize-variables-to-null'>NÃO inicializar variáveis explicitamente como <code>null</code>.</a>
*   <a href='/effective-dart/usage#dont-use-an-explicit-default-value-of-null'>NÃO usar um valor padrão explícito de <code>null</code>.</a>
*   <a href='/effective-dart/usage#dont-use-true-or-false-in-equality-operations'>NÃO usar <code>true</code> ou <code>false</code> em operações de igualdade.</a>
*   <a href='/effective-dart/usage#avoid-late-variables-if-you-need-to-check-whether-they-are-initialized'>EVITAR variáveis <code>late</code> se precisar verificar se elas foram inicializadas.</a>
*   <a href='/effective-dart/usage#consider-type-promotion-or-null-check-patterns-for-using-nullable-types'>CONSIDERAR a promoção de tipo ou padrões de verificação de nulo para usar tipos anuláveis.</a>

**Strings**

*   <a href='/effective-dart/usage#do-use-adjacent-strings-to-concatenate-string-literals'>USAR strings adjacentes para concatenar literais de string.</a>
*   <a href='/effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values'>PREFERIR usar interpolação para compor strings e valores.</a>
*   <a href='/effective-dart/usage#avoid-using-curly-braces-in-interpolation-when-not-needed'>EVITAR usar chaves na interpolação quando não for necessário.</a>

**Coleções**

*   <a href='/effective-dart/usage#do-use-collection-literals-when-possible'>USAR literais de coleção sempre que possível.</a>
*   <a href='/effective-dart/usage#dont-use-length-to-see-if-a-collection-is-empty'>NÃO usar <code>.length</code> para ver se uma coleção está vazia.</a>
*   <a href='/effective-dart/usage#avoid-using-iterable-foreach-with-a-function-literal'>EVITAR usar <code>Iterable.forEach()</code> com um literal de função.</a>
*   <a href='/effective-dart/usage#dont-use-list-from-unless-you-intend-to-change-the-type-of-the-result'>NÃO usar <code>List.from()</code> a menos que você pretenda alterar o tipo do resultado.</a>
*   <a href='/effective-dart/usage#do-use-wheretype-to-filter-a-collection-by-type'>USAR <code>whereType()</code> para filtrar uma coleção por tipo.</a>
*   <a href='/effective-dart/usage#dont-use-cast-when-a-nearby-operation-will-do'>NÃO usar <code>cast()</code> quando uma operação próxima já resolver.</a>
*  <a href='/effective-dart/usage#avoid-using-cast'>EVITAR usar <code>cast()</code>.</a>

**Funções**

*   <a href='/effective-dart/usage#do-use-a-function-declaration-to-bind-a-function-to-a-name'>USAR uma declaração de função para vincular uma função a um nome.</a>
*   <a href='/effective-dart/usage#dont-create-a-lambda-when-a-tear-off-will-do'>NÃO criar um *lambda* quando um *tear-off* resolver.</a>

**Variáveis**

*   <a href='/effective-dart/usage#do-follow-a-consistent-rule-for-var-and-final-on-local-variables'>SEGUIR uma regra consistente para <code>var</code> e <code>final</code> em variáveis locais.</a>
*   <a href='/effective-dart/usage#avoid-storing-what-you-can-calculate'>EVITAR armazenar o que você pode calcular.</a>

**Membros**

*   <a href='/effective-dart/usage#dont-wrap-a-field-in-a-getter-and-setter-unnecessarily'>NÃO envolver um campo em um *getter* e *setter* desnecessariamente.</a>
*   <a href='/effective-dart/usage#prefer-using-a-final-field-to-make-a-read-only-property'>PREFERIR usar um campo <code>final</code> para criar uma propriedade somente leitura.</a>
*   <a href='/effective-dart/usage#consider-using-for-simple-members'>CONSIDERAR usar <code>=&gt;</code> para membros simples.</a>
*   <a href='/effective-dart/usage#dont-use-this-when-not-needed-to-avoid-shadowing'>NÃO usar <code>this.</code>, exceto para redirecionar para um construtor nomeado ou para evitar sombreamento.</a>
*   <a href='/effective-dart/usage#do-initialize-fields-at-their-declaration-when-possible'>INICIALIZAR campos em sua declaração quando possível.</a>

**Construtores**

*   <a href='/effective-dart/usage#do-use-initializing-formals-when-possible'>USAR *initializing formals* quando possível.</a>
*   <a href='/effective-dart/usage#dont-use-late-when-a-constructor-initializer-list-will-do'>NÃO usar <code>late</code> quando uma lista de inicialização de construtor resolver.</a>
*   <a href='/effective-dart/usage#do-use-instead-of-for-empty-constructor-bodies'>USAR <code>;</code> em vez de <code>{}</code> para corpos de construtores vazios.</a>
*   <a href='/effective-dart/usage#dont-use-new'>NÃO usar <code>new</code>.</a>
*   <a href='/effective-dart/usage#dont-use-const-redundantly'>NÃO usar <code>const</code> redundantemente.</a>

**Tratamento de Erros**

*   <a href='/effective-dart/usage#avoid-catches-without-on-clauses'>EVITAR *catches* sem cláusulas <code>on</code>.</a>
*   <a href='/effective-dart/usage#dont-discard-errors-from-catches-without-on-clauses'>NÃO descartar erros de *catches* sem cláusulas <code>on</code>.</a>
*   <a href='/effective-dart/usage#do-throw-objects-that-implement-error-only-for-programmatic-errors'>GERAR objetos que implementam <code>Error</code> apenas para erros programáticos.</a>
*   <a href='/effective-dart/usage#dont-explicitly-catch-error-or-types-that-implement-it'>NÃO capturar explicitamente <code>Error</code> ou tipos que o implementam.</a>
*   <a href='/effective-dart/usage#do-use-rethrow-to-rethrow-a-caught-exception'>USAR <code>rethrow</code> para gerar novamente uma exceção capturada.</a>

**Assincronia**

*   <a href='/effective-dart/usage#prefer-asyncawait-over-using-raw-futures'>PREFERIR async/await em vez de usar *futures* brutos.</a>
*   <a href='/effective-dart/usage#dont-use-async-when-it-has-no-useful-effect'>NÃO usar <code>async</code> quando não tiver efeito útil.</a>
*   <a href='/effective-dart/usage#consider-using-higher-order-methods-to-transform-a-stream'>CONSIDERAR usar métodos de ordem superior para transformar um *stream*.</a>
*   <a href='/effective-dart/usage#avoid-using-completer-directly'>EVITAR usar <code>Completer</code> diretamente.</a>
*   <a href='/effective-dart/usage#do-test-for-futuret-when-disambiguating-a-futureort-whose-type-argument-could-be-object'>TESTAR <code>Future&lt;T&gt;</code> ao desambiguar um <code>FutureOr&lt;T&gt;</code> cujo argumento de tipo pode ser <code>Object</code>.</a>

</div>
<div class='effective_dart--summary_column'>


### Design


**Nomes**

*   <a href='/effective-dart/design#do-use-terms-consistently'>USAR termos de forma consistente.</a>
*   <a href='/effective-dart/design#avoid-abbreviations'>EVITAR abreviações.</a>
*   <a href='/effective-dart/design#prefer-putting-the-most-descriptive-noun-last'>PREFERIR colocar o substantivo mais descritivo por último.</a>
*   <a href='/effective-dart/design#consider-making-the-code-read-like-a-sentence'>CONSIDERAR fazer o código ser lido como uma frase.</a>
*   <a href='/effective-dart/design#prefer-a-noun-phrase-for-a-non-boolean-property-or-variable'>PREFERIR uma frase substantiva para uma propriedade ou variável não booleana.</a>
*   <a href='/effective-dart/design#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable'>PREFERIR uma frase verbal não imperativa para uma propriedade ou variável booleana.</a>
*   <a href='/effective-dart/design#consider-omitting-the-verb-for-a-named-boolean-parameter'>CONSIDERAR omitir o verbo para um *parâmetro* booleano nomeado.</a>
*   <a href='/effective-dart/design#prefer-the-positive-name-for-a-boolean-property-or-variable'>PREFERIR o nome "positivo" para uma propriedade ou variável booleana.</a>
*   <a href='/effective-dart/design#prefer-an-imperative-verb-phrase-for-a-function-or-method-whose-main-purpose-is-a-side-effect'>PREFERIR uma frase verbal imperativa para uma função ou método cujo objetivo principal seja um efeito colateral.</a>
*   <a href='/effective-dart/design#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose'>PREFERIR uma frase substantiva ou frase verbal não imperativa para uma função ou método se retornar um valor for seu objetivo principal.</a>
*   <a href='/effective-dart/design#consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs'>CONSIDERAR uma frase verbal imperativa para uma função ou método se você quiser chamar a atenção para o trabalho que ele realiza.</a>
*   <a href='/effective-dart/design#avoid-starting-a-method-name-with-get'>EVITAR iniciar um nome de método com <code>get</code>.</a>
*   <a href='/effective-dart/design#prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object'>PREFERIR nomear um método <code>to___()</code> se ele copiar o estado do objeto para um novo objeto.</a>
*   <a href='/effective-dart/design#prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object'>PREFERIR nomear um método <code>as___()</code> se ele retornar uma representação diferente com o apoio do objeto original.</a>
*   <a href='/effective-dart/design#avoid-describing-the-parameters-in-the-functions-or-methods-name'>EVITAR descrever os parâmetros no nome da função ou do método.</a>
*   <a href='/effective-dart/design#do-follow-existing-mnemonic-conventions-when-naming-type-parameters'>SEGUIR as convenções mnemônicas existentes ao nomear parâmetros de tipo.</a>

**Bibliotecas**

*   <a href='/effective-dart/design#prefer-making-declarations-private'>PREFERIR tornar as declarações privadas.</a>
*   <a href='/effective-dart/design#consider-declaring-multiple-classes-in-the-same-library'>CONSIDERAR declarar várias classes na mesma biblioteca.</a>

**Classes e mixins**

*   <a href='/effective-dart/design#avoid-defining-a-one-member-abstract-class-when-a-simple-function-will-do'>EVITAR definir uma classe abstrata de um membro quando uma função simples resolver.</a>
*   <a href='/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members'>EVITAR definir uma classe que contenha apenas membros estáticos.</a>
*   <a href='/effective-dart/design#avoid-extending-a-class-that-isnt-intended-to-be-subclassed'>EVITAR estender uma classe que não se destina a ser subclassificada.</a>
*   <a href='/effective-dart/design#do-document-if-your-class-supports-being-extended'>DOCUMENTAR se sua classe oferece suporte à extensão.</a>
*   <a href='/effective-dart/design#avoid-implementing-a-class-that-isnt-intended-to-be-an-interface'>EVITAR implementar uma classe que não se destina a ser uma interface.</a>
*   <a href='/effective-dart/design#do-document-if-your-class-supports-being-used-as-an-interface'>DOCUMENTAR se sua classe oferece suporte a ser usada como uma interface.</a>
*   <a href='/effective-dart/design#prefer-defining-a-pure-mixin-or-pure-class-to-a-mixin-class'>PREFERIR definir um <code>mixin</code> puro ou <code>class</code> puro para um <code>mixin class</code>.</a>

**Construtores**

*   <a href='/effective-dart/design#consider-making-your-constructor-const-if-the-class-supports-it'>CONSIDERAR tornar seu construtor <code>const</code> se a classe o suportar.</a>

**Membros**

*   <a href='/effective-dart/design#prefer-making-fields-and-top-level-variables-final'>PREFERIR tornar os campos e as variáveis de nível superior <code>final</code>.</a>
*   <a href='/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties'>USAR *getters* para operações que acessam conceitualmente propriedades.</a>
*   <a href='/effective-dart/design#do-use-setters-for-operations-that-conceptually-change-properties'>USAR *setters* para operações que alteram conceitualmente propriedades.</a>
*   <a href='/effective-dart/design#dont-define-a-setter-without-a-corresponding-getter'>NÃO definir um *setter* sem um *getter* correspondente.</a>
*   <a href='/effective-dart/design#avoid-using-runtime-type-tests-to-fake-overloading'>EVITAR usar testes de tipo em tempo de execução para simular sobrecarga.</a>
*   <a href='/effective-dart/design#avoid-public-late-final-fields-without-initializers'>EVITAR campos públicos <code>late final</code> sem inicializadores.</a>
*   <a href='/effective-dart/design#avoid-returning-nullable-future-stream-and-collection-types'>EVITAR retornar tipos anuláveis <code>Future</code>, <code>Stream</code> e de coleção.</a>
*   <a href='/effective-dart/design#avoid-returning-this-from-methods-just-to-enable-a-fluent-interface'>EVITAR retornar <code>this</code> de métodos apenas para habilitar uma interface fluente.</a>

**Tipos**

*   <a href='/effective-dart/design#do-type-annotate-variables-without-initializers'>ANOTAR com tipo variáveis sem inicializadores.</a>
*   <a href='/effective-dart/design#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious'>ANOTAR com tipo campos e variáveis de nível superior se o tipo não for óbvio.</a>
*   <a href='/effective-dart/design#dont-redundantly-type-annotate-initialized-local-variables'>NÃO anotar com tipo variáveis locais inicializadas de forma redundante.</a>
*   <a href='/effective-dart/design#do-annotate-return-types-on-function-declarations'>ANOTAR os tipos de retorno em declarações de função.</a>
*   <a href='/effective-dart/design#do-annotate-parameter-types-on-function-declarations'>ANOTAR os tipos de parâmetros em declarações de função.</a>
*   <a href='/effective-dart/design#dont-annotate-inferred-parameter-types-on-function-expressions'>NÃO anotar tipos de parâmetros inferidos em expressões de função.</a>
*   <a href='/effective-dart/design#dont-type-annotate-initializing-formals'>NÃO anotar com tipo *initializing formals*.</a>
*   <a href='/effective-dart/design#do-write-type-arguments-on-generic-invocations-that-arent-inferred'>ESCREVER argumentos de tipo em invocações genéricas que não são inferidas.</a>
*   <a href='/effective-dart/design#dont-write-type-arguments-on-generic-invocations-that-are-inferred'>NÃO escrever argumentos de tipo em invocações genéricas que são inferidas.</a>
*   <a href='/effective-dart/design#avoid-writing-incomplete-generic-types'>EVITAR escrever tipos genéricos incompletos.</a>
*   <a href='/effective-dart/design#do-annotate-with-dynamic-instead-of-letting-inference-fail'>ANOTAR com <code>dynamic</code> em vez de deixar a inferência falhar.</a>
*   <a href='/effective-dart/design#prefer-signatures-in-function-type-annotations'>PREFERIR assinaturas em anotações de tipo de função.</a>
*   <a href='/effective-dart/design#dont-specify-a-return-type-for-a-setter'>NÃO especificar um tipo de retorno para um *setter*.</a>
*   <a href='/effective-dart/design#dont-use-the-legacy-typedef-syntax'>NÃO usar a sintaxe *typedef* legado.</a>
*   <a href='/effective-dart/design#prefer-inline-function-types-over-typedefs'>PREFERIR tipos de função *inline* em vez de *typedefs*.</a>
*   <a href='/effective-dart/design#prefer-using-function-type-syntax-for-parameters'>PREFERIR usar a sintaxe de tipo de função para parâmetros.</a>
*   <a href='/effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking'>EVITAR usar <code>dynamic</code>, a menos que você queira desabilitar a verificação estática.</a>
*   <a href='/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values'>USAR <code>Future&lt;void&gt;</code> como o tipo de retorno de membros assíncronos que não produzem valores.</a>
*   <a href='/effective-dart/design#avoid-using-futureort-as-a-return-type'>EVITAR usar <code>FutureOr&lt;T&gt;</code> como um tipo de retorno.</a>

**Parâmetros**

*   <a href='/effective-dart/design#avoid-positional-boolean-parameters'>EVITAR parâmetros booleanos posicionais.</a>
*   <a href='/effective-dart/design#avoid-optional-positional-parameters-if-the-user-may-want-to-omit-earlier-parameters'>EVITAR parâmetros posicionais opcionais se o usuário pode querer omitir parâmetros anteriores.</a>
*   <a href='/effective-dart/design#avoid-mandatory-parameters-that-accept-a-special-no-argument-value'>EVITAR parâmetros obrigatórios que aceitam um valor especial de "sem argumento".</a>
*   <a href='/effective-dart/design#do-use-inclusive-start-and-exclusive-end-parameters-to-accept-a-range'>USAR parâmetros de início inclusivo e fim exclusivo para aceitar um intervalo.</a>

**Igualdade**

*   <a href='/effective-dart/design#do-override-hashcode-if-you-override'>SOBRESCREVER <code>hashCode</code> se você sobrescrever <code>==</code>.</a>
*   <a href='/effective-dart/design#do-make-your-operator-obey-the-mathematical-rules-of-equality'>FAZER seu operador <code>==</code> obedecer às regras matemáticas de igualdade.</a>
*   <a href='/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes'>EVITAR definir igualdade personalizada para classes mutáveis.</a>
*   <a href='/effective-dart/design#dont-make-the-parameter-to-nullable'>NÃO tornar o parâmetro para <code>==</code> anulável.</a>

</div>
<div style='clear:both'></div>
