---
ia-translate: true
title: "Dart 3.1 e uma retrospectiva sobre programação em estilo funcional no Dart 3"
description: "Pattern matching e switches exaustivos se unem para criar modelos de dados em estilo funcional que se integram naturalmente ao núcleo orientado a objetos do Dart…"
publishDate: 2023-08-16
author: mbelanger
image: images/1IWd8aRO__OzDkJVsjfoe2A.webp
category: releases
layout: blog
---


### Pattern matching e switches exaustivos se unem para criar modelos de dados em estilo funcional que se integram naturalmente ao núcleo orientado a objetos do Dart {:#pattern-matching-and-exhaustive-switches-come-together-to-enable-functional-style-data-models-that-blend-seamlessly-with-darts-object-oriented-core}

<DashImage src="images/1IWd8aRO__OzDkJVsjfoe2A.webp" alt="Um diff de uma refatoração em Dart 3 usando recursos de estilo funcional no código-fonte interno do Dart." caption="Diff de uma refatoração em Dart 3 usando recursos de estilo funcional dentro da base de código interna do Dart" />


*Hoje estamos lançando o Dart 3.1, nossa primeira versão estável desde o grande lançamento do [Dart 3.0](/blog/announcing-dart-3), em maio. O Dart 3.1 traz algumas atualizações menores e alguns ajustes de API para usar melhor os modificadores de classe introduzidos na 3.0 (sobre os quais você pode ler mais no [changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#310)). Mas, principalmente, dedicamos nosso tempo aos novos itens do roteiro, que esperamos ver chegando às versões beta e estável nas próximas versões. Fique de olho para saber mais sobre isso no futuro!*

*Então, no lugar de um post tradicional de lançamento, vamos revisitar um subconjunto dos principais recursos do Dart 3 para falar sobre como eles podem mudar completamente, e em alguns casos melhorar muito, a forma como você escreve e estrutura seu código Dart.*

## Como você modela dados? {:#how-do-you-model-data}

Linguagens orientadas a objetos (OO) e funcionais diferem em muitos aspectos, mas é discutível que *como cada paradigma modela dados* seja a característica definidora que os separa. Especificamente, a questão de modelar diferentes variações de dados relacionados e as operações sobre essas variantes.

Mas *“como devo modelar estes dados?”* geralmente não é algo em que pensamos conscientemente quando começamos um novo projeto. Tendemos a seguir o paradigma de modelagem de dados comum ao tipo de linguagem que estamos usando, em vez do contrário, que seria escolher a linguagem com base no modelo que faz mais sentido para os nossos dados.

Se você usa uma linguagem OO, vai modelar dados com hierarquias de classes e operações sobre os subtipos. Se você usa certas linguagens funcionais, o equivalente ao modelo de hierarquia de classes é o modelo de [tipo de dado algébrico](https://en.wikipedia.org/wiki/Algebraic_data_type), cujo equivalente a operar sobre subtipos é fazer switch sobre eles com [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching).

<DashImage src="images/1mA116alArq7XKrm_PSCjyw.webp" alt="Uma comparação simplificada lado a lado do modelo de hierarquia de classes orientado a objetos e do modelo funcional de tipos algébricos de dados." caption="Comparação simplificada lado a lado do modelo de hierarquia de classes orientado a objetos e do modelo funcional de tipos algébricos de dados" />


O Dart é uma linguagem orientada a objetos, mas vem incorporando recursos funcionais de forma constante ao longo do tempo, permitindo uma abordagem multiparadigma para modelagem de dados. Mais recentemente, o Dart 3 adicionou [pattern matching](https://dart.dev/language/patterns), novas funcionalidades no [switch](https://dart.dev/language/patterns#switch-statements-and-expressions) e [tipos selados](https://dart.dev/language/class-modifiers#sealed). Esses recursos tornam possível implementar tipos algébricos de dados em Dart, permitindo escrever código em estilo funcional sem deixar de aproveitar ao máximo as capacidades do núcleo orientado a objetos do Dart.

Linguagens multiparadigma como o Dart dão a você as ferramentas e a oportunidade de escolher como projetar qualquer coisa, desde uma única expressão até hierarquias inteiras de classes. Você pode considerar qual modelo faz mais sentido para o seu projeto, ou até apenas pela sua preferência pessoal. Para ajudar você a tomar a melhor decisão, este artigo resume a estrutura e os pontos fortes de cada paradigma separadamente e, em seguida, ensina como usar os novos recursos do Dart 3 para refatorar alguns designs clássicos orientados a objetos que mais se beneficiam de ser escritos em estilo funcional.

### Abordagem orientada a objetos {:#object-oriented-approach}

Quando você tem operações específicas para diferentes tipos de dados, a forma padrão de organização em linguagens OO é criar um método em uma classe base e um conjunto de subclasses que sobrescrevem a classe base para definir seu comportamento único. Cada subclasse tem seus dados e operações juntos, em um só lugar, dentro da sua declaração.

Veja este exemplo (pseudocódigo de alto nível) de modelagem de receitas. Faz sentido ter objetos de receita, unindo ingredientes e passos à receita. A classe base de receita provavelmente teria algumas funções para os métodos de preparo que cada receita sobrescreve com seus requisitos próprios:


Hierarquias de classes com métodos de instância facilitam adicionar novas subclasses sem precisar tocar em nenhum código existente. Isso funciona perfeitamente para alguns domínios, como o Flutter, em que há inúmeros widgets que estendem a classe `Widget`. Cada widget pode estender e sobrescrever de forma única qualquer comportamento necessário, diretamente dentro da sua definição. Você *definitivamente* não precisa saber como cada subtipo de widget define seus métodos para adicionar comportamento especializado aos seus próprios widgets.

### Abordagem funcional (tipos algébricos de dados) {:#functional-approach-algebraic-data-types}

Você pode pensar na arquitetura em estilo funcional como o inverso da arquitetura OO. Em vez de ter todo o código de *um tipo em um lugar* (métodos de instância OO nas declarações das subclasses), você tem todo o código de *uma operação em um lugar* (switch funcional sobre os tipos para definir o comportamento).

Isso levanta a pergunta: quando *faz* sentido saber como cada subtipo de uma hierarquia define uma operação? Pode ser por alguns motivos:

* Quando adicionar, manter e entender variantes do comportamento de uma mesma operação entre os tipos é mais fácil de fazer quando todas estão lado a lado no código.

* Quando você não pode modificar as subclasses, mas quer definir um novo comportamento específico para cada uma delas.

* Quando as variações do comportamento de uma operação para diferentes tipos estão mais relacionadas entre si do que aos tipos sobre os quais elas operam*.*

Às vezes é óbvio, mas na maioria das vezes é só uma mudança de perspectiva. Pense de novo no exemplo da receita. Do ponto de vista, digamos, de um manual de forno, faria muito mais sentido agrupar as instruções de assar em um só lugar para cada receita:


Neste exemplo, a estrutura do programa está focada na operação `bake`. Quaisquer tipos sobre os quais `bake` opera são simplesmente diferentes saídas possíveis da mesma função; `bake` é independente dos tipos sobre os quais opera.

Este é o **modelo de tipos algébricos de dados** (chamado de “algébrico” em referência à teoria dos conjuntos da matemática). É o modelo central de organização das linguagens funcionais, da mesma forma que as hierarquias de classes são centrais nas linguagens OO. Os tipos algébricos de dados separam comportamento de dados agrupando o comportamento de todos os tipos por operação.

E agora é possível implementar de forma coesa tipos algébricos de dados com o Dart 3!

## Modelando tipos algébricos de dados orientados a objetos {:#modeling-object-oriented-algebraic-data-types}

Linguagens funcionais geralmente implementam [tipos algébricos de dados](https://en.wikipedia.org/wiki/Algebraic_data_type) fazendo pattern matching sobre os casos de um [tipo soma](https://en.wikipedia.org/wiki/Tagged_union) para atribuir um comportamento a cada variante. O Dart 3 alcança o mesmo resultado com [pattern matching](https://dart.dev/language/patterns#switch-statements-and-expressions) nos casos de switch e aproveita o fato de que a herança de subtipos da OO já modela naturalmente tipos soma. Isso nos permite implementar [tipos algébricos de dados verdadeiramente multiparadigma](https://dart.dev/language/patterns#algebraic-data-types) usando objetos que se integram ao Dart de forma transparente.

As seções a seguir mostram como projetar modelos de tipos algébricos de dados em Dart, ao lado de exemplos de antes do Dart 3 da mesma funcionalidade.

* Primeiro, vamos explicar como agrupar as variantes de uma operação baseadas em tipo, fazendo switch sobre [padrões de objeto](https://dart.dev/language/pattern-types#object).

* Depois, vamos dar um passo atrás e ver como arquitetar as próprias subclasses com o novo modificador de classe [sealed](https://dart.dev/language/class-modifiers#sealed), para garantir que o switch defina o comportamento para [todos os subtipos possíveis que o objeto pode assumir](https://dart.dev/language/branches#exhaustiveness-checking).

### Agrupando comportamentos entre tipos {:#grouping-behaviors-across-types}

Partes individuais da linguagem Dart (como statements, classes e literais) têm, cada uma, suas próprias definições em hierarquias de classes, mas todas estão sujeitas a operações de vários sistemas (como operações de parser, formatador e compilador). Imagine como seria confusa a implementação da linguagem se toda função que se aplicasse a cada elemento da linguagem tivesse que ser definida dentro das declarações desses elementos! Ficaria mais ou menos assim:


O código interno do Dart já tende naturalmente à abordagem funcional, separando funções das definições de tipo por esse motivo. Pegue a biblioteca [`annotation_verifier`](https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/lib/src/error/annotation_verifier.dart) do analyzer do Dart. Ela contém funções que definem o comportamento de anotações (como `@override` ou `@deprecated`) dependendo da parte do código à qual a anotação está associada (por exemplo, como `@override` afeta uma classe em oposição a um campo).

Mas atribuir comportamento por tipo não é tão simples quanto a decisão de separar esse comportamento, para início de conversa. A forma padrão de definir comportamentos por tipo usa instruções `if-else` encadeadas, que você vê muito no verificador de anotações. Veja a seguinte função de verificação escrita sem usar nenhum recurso do Dart 3. Ela verifica o comportamento da anotação `@visibleOutsideTemplate`, [recém-contribuída](https://github.com/dart-lang/sdk/commit/4079a47cc4fb8f88e2dd9b7faff3bd587931a379), que desativa os efeitos em cascata de outra anotação, `@visibleForTemplate`:


A função usa instruções `if-else` encadeadas e elaboradas, testando se o avô da anotação é um certo tipo de declaração (`ClassDeclaration`, `EnumDeclaration` ou `MixinDeclaration`) e, então, definindo seu comportamento com base no tipo.

Com o Dart 3, você pode usar padrões de objeto nos casos de switch para refatorar essa estrutura de forma significativa, deixando-a mais declarativa, mais curta e mais fácil de ler. E o autor original [fez exatamente isso](https://github.com/dart-lang/sdk/blob/4079a47cc4fb8f88e2dd9b7faff3bd587931a379/pkg/analyzer/lib/src/error/annotation_verifier.dart#L417-L426)! 16 linhas de instruções `if-else` encadeadas foram reduzidas a um switch de 7 linhas:


Cada caso aqui é um [padrão de objeto](https://dart.dev/language/pattern-types#object) que faz match com o tipo estático de `grandparent`. Em vez de escrever `if (object is Type && object.property != null)`, cada caso verifica se o padrão do objeto combina com o padrão `Type(propertyOfType)`. Além disso, quando um objeto combina com um padrão de objeto, ele exige implicitamente que não seja `null`, então não há necessidade de uma verificação explícita de null!

Padrões de objeto também podem conter [padrões de variável](https://dart.dev/language/pattern-types#variable) aninhados, que permitem extrair (ou [*desestruturar*](https://dart.dev/language/patterns#destructuring)) valores de propriedades de um objeto na mesma linha de código em que você está fazendo o match. A sintaxe `(:var metadata)` significa apenas “faça o match e declare uma nova variável com o mesmo nome deste getter”. É assim que a variável `metadata` entra no escopo do último loop `for`. Bem conciso!

Repare que o loop `for` agora é comum a todos os casos. A propriedade `declaredElement` de cada tipo é, na verdade, um subtipo diferente de outro tipo, `InterfaceElement` (que pode ser `classElement`, `enumElement` ou `mixinElement`). Assim, a instrução `if-else` encadeada de antes do Dart 3 iterava sobre `metadata` separadamente em cada cláusula `if`, para garantir que `final annotation` fosse seguro em relação a tipos para cada um dos tipos possíveis de `metadata`.

Agora, a estrutura refatorada usa padrões de objeto profundamente aninhados em cada caso, para fazer upcast de `metadata` para o seu supertipo, `InterfaceElement`. Isso torna um único loop `for` compartilhado, iterando sobre `metadata`, seguro em relação a tipos em todos os casos.

<DashImage src="images/1qYQb8DZyeJDFD-VKEb4P6Q.webp" alt="Sintaxe anotada de padrões do Dart, mostrando um padrão de objeto, um padrão de objeto aninhado, um upcast e um padrão de variável." caption="Representação anotada da sintaxe de padrões de objeto e de variável profundamente aninhados" />


Fazer switch sobre padrões de objeto é importante para a implementação de tipos algébricos de dados do Dart por causa da capacidade de testar subtipos de forma concisa e desestruturar valores. Um bom efeito colateral são as garantias simultâneas que podem ser dadas por uma única linha de código. Para reforçar, cada padrão de caso nesta refatoração está verificando simultaneamente:

* O objeto é um dos tipos `ClassDeclaration`, `EnumDeclaration` ou `MixinDeclaration`.

* O objeto tem a propriedade `declaredElement`.

* `declaredElement` tem a propriedade `metadata`.

* `metadata` é do tipo `InterfaceElement`.

* Nenhum dos objetos ou propriedades em questão é `null`.

Este é o exemplo perfeito de como o Dart 3 implementa padrões de forma tão completa, levando em conta tantas nuances das linguagens OO, e de como isso torna os tipos algébricos de dados orientados a objetos uma opção de design realista no Dart.

Testes de tipo sobre padrões de objeto são ótimos para separar comportamento de tipos. Mas falta um recurso da herança de subtipos da OO: o compilador avisar você se declarar um novo subtipo sem definir o comportamento de um dos métodos abstratos do seu supertipo. Como o modelo de tipos algébricos de dados do Dart pode oferecer as mesmas garantias de segurança quando não estamos mais lidando com métodos de instância nas declarações de tipo? A resposta é a *verificação de exaustividade*.

### Verificação de exaustividade {:#exhaustiveness-checking}

As implementações de tipos algébricos de dados nas linguagens funcionais usam tipos soma enumeráveis, o que significa que o compilador sempre conhece todas as variações possíveis do tipo sobre o qual se faz o switch. Assim, o compilador pode avisar se o seu switch está faltando um caso e, portanto, que alguns valores podem passar por esse switch sem serem tratados.

Isso é chamado de [verificação de exaustividade](https://dart.dev/language/branches#exhaustiveness-checking). Tecnicamente, ela sempre existiu no Dart para tipos enumeráveis, como enums e booleanos. Esses tipos têm um conjunto de valores possíveis que não pode mudar, e, se você faz switch sobre eles, o compilador sabe quando você deixou um de fora e avisa. Usar uma cláusula `default` é outra forma de pseudoexaustividade. Como `default` casa com todos os casos que não foram explicitamente tratados, ele faz o compilador considerar o switch exaustivo sem saber se todos os tipos potenciais estão realmente tratados.

Como mencionado, queríamos usar subtipos em vez de tipos soma para a versão do Dart da modelagem de tipos algébricos de dados. Mas, como as classes no Dart podem ser estendidas a partir de qualquer biblioteca, seria impossível para o compilador enumerar de forma exaustiva os subtipos de uma classe, já que ele não pode saber se há subclasses declaradas em bibliotecas externas.

Para contornar isso e completar a implementação de tipos algébricos de dados do Dart, adicionamos o [modificador de classe `sealed`](https://dart.dev/language/class-modifiers#sealed) no Dart 3. Uma classe `sealed` não pode ser estendida nem implementada a partir de nenhuma biblioteca além da sua própria ([o arquivo que contém sua definição](https://dart.dev/language/libraries)). Isso garante que o compilador sempre conheça todos os subtipos possíveis, tornando-os totalmente enumeráveis.

Aqui está um exemplo de uma refatoração real que entrou no SDK do Dart como parte da versão 3.1: [selar `FileSystemEvent`](https://github.com/dart-lang/sdk/commit/c3e815bc7ad488eddf00344ab4106485a9d1ba32#diff-e98c6de423bf7e0b5b961cd10efed50330004229243aa87c18ad6314fef054b0L879-R879) para que seus subtipos possam ser alvo de um switch exaustivo. Prepare-se, refatorações são difíceis…


Brincadeira, essa não foi nada difícil! Deve-se notar, porém, que selar uma hierarquia de classes existente é uma mudança que quebra compatibilidade. Código voltado para versões mais antigas do Dart não vai conseguir implementar nem estender a classe, então sempre verifique as dependências e avise os usuários que possam estar criando subtipos das suas classes em outros lugares.

Selar `FileSystemEvent` permite que os eventos produzidos por `FileSystemEntity.watch`, que correspondem aos subtipos de `FileSystemEvent`, sejam alvo de um switch exaustivo. É comum escutar esse stream de eventos e usar instruções [`if-else` encadeadas](https://github.com/dart-lang/sdk/issues/52273) para determinar uma ação com base no tipo dos eventos que ocorrem.

Mas selar a classe base não permite apenas fazer switch sobre padrões de objeto, como no exemplo `_checkVisibleOutsideTemplate` da seção anterior. Também garante que, ao fazer isso, você esteja tratando todos os valores possíveis que possam surgir para aquele tipo, sem precisar de um caso `default`:


Se algum novo subtipo que estende `FileSystemEvent` fosse adicionado, talvez `FileSystemSyncEvent`, por exemplo, o compilador saberia disso, porque ele só poderia ser adicionado à [mesma biblioteca](https://github.com/dart-lang/sdk/blob/main/sdk/lib/io/file_system_entity.dart) de `FileSystemEvent`. Como a hierarquia de classes é selada, o compilador exige que qualquer switch sobre as suas instâncias seja exaustivo e vai gerar [um erro](https://dart.dev/tools/diagnostic-messages#non_exhaustive_switch_expression) para alertar o usuário (quem escreveu o switch, não o dono da biblioteca) sobre casos não tratados:

```bash
The type 'FileSystemEvent' is not exhaustively matched by the switch cases since it doesn't match 'FileSystemSyncEvent'
```


Combinar classes seladas e switches sobre padrões de objeto possibilita um estilo completo de arquitetura de programa com tipos algébricos de dados orientados a objetos no Dart.

### Recursos funcionais extras {:#bonus-functional-features}

O exemplo de switch exaustivo acima inclui ainda mais recursos funcionais do Dart 3 do que apenas os que facilitam os tipos algébricos de dados.

Repare que o switch está à direita do `return` da função `_fileListener`: essa é a nova [switch expression](https://dart.dev/language/branches#switch-expressions) do Dart 3. A ênfase geral em expressões e funções é um elemento central das linguagens funcionais. O Dart 3 criou switch expressions que podem produzir um valor e aparecer em qualquer lugar onde uma expressão é permitida.

E o que a `_fileListener` está retornando no exemplo anterior, afinal? É um [record](https://dart.dev/language/records), outro novo recurso do Dart 3 também relacionado à programação funcional. Records permitem retornar vários valores heterogêneos de uma função, ampliando a utilidade das funções no Dart e nos afastando da dependência de classes personalizadas (que seriam a única outra forma de retornar vários valores de tipos diferentes sem perder os tipos no processo).

## Resumo {:#summary}

Você pode modelar tipos algébricos de dados no Dart:

* Escrevendo uma função que faz switch *sobre* uma instância de uma classe selada, e *sobre* seus subtipos,

* E definindo as variações no comportamento de cada subtipo nos casos do switch.

Fazer switch sobre padrões de objeto permite manter todas as operações juntas de forma sucinta, e a verificação de exaustividade garante que o compilador avise você se estiver faltando a definição de comportamento para algum tipo. E tudo isso se apoia nas classes orientadas a objetos que o Dart já usa.

O melhor de tudo é que você não precisa escolher entre estilo orientado a objetos ou funcional; os dois paradigmas se combinam, e você pode usar o estilo que melhor se encaixa na operação que está definindo.

Você pode tornar hierarquias de classes existentes mais funcionais com pequenas modificações e até misturar o uso de métodos de instância com tipos algébricos de dados na mesma hierarquia de classes. Seja para fazer sentido acoplar um comportamento de perto a um tipo, seja para agrupar comportamentos de tipos diferentes em uma só função, você pode usar o estilo que faz mais sentido.

Esperamos que esta introdução desperte seu interesse pela programação funcional e por experimentar os novos recursos do Dart 3. Quem sabe não veremos em breve o primeiro programa Dart totalmente em estilo funcional de um de vocês!

### Recursos {:#resources}

*Para saber mais sobre programação funcional no Dart e em torno dele, confira estes recursos:*

* A documentação oficial do Dart sobre [patterns](https://dart.dev/language/patterns) e [verificação de exaustividade](https://dart.dev/language/branches#exhaustiveness-checking).

* O [codelab de patterns e records](https://codelabs.developers.google.com/codelabs/dart-patterns-records#0) sobre refatoração de código Flutter com Dart 3.

* Esta [palestra da comunidade](https://www.droidcon.com/2023/08/07/the-joy-of-functional-programming-in-dart/) no FlutterCon sobre programação funcional no Dart.

* Este [post de blog](https://journal.stuffwithstuff.com/2023/08/04/representing-heterogeneous-data/) sobre modelagem de dados heterogêneos, do blog pessoal de Bob Nystrom (que escreveu [o design dos patterns no Dart](https://github.com/dart-lang/language/blob/main/accepted/3.0/patterns/feature-specification.md)!).
