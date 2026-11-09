---
ia-translate: true
title: Construtores primários
description: >-
  Crie classes de forma concisa declarando parâmetros e campos
  no cabeçalho da classe.
prevpage:
  url: /language/constructors
  title: Constructors
nextpage:
  url: /language/methods
  title: Methods
---

:::version-note
Construtores primários requerem uma [language version][] de pelo menos 3.13.
:::

## Visão geral {:#overview}

Construtores primários oferecem uma forma concisa de declarar os campos de uma classe
e seu construtor principal em uma única linha.
Eles reduzem o boilerplate de declarar campos, receber parâmetros
e atribuí-los no corpo do construtor.
Essa forma abreviada muda como você escreve a declaração,
mas não muda o comportamento em tempo de execução.

### Antes e depois {:#before-and-after}

Considere esta classe tradicional com dois campos e um construtor:

<?code-excerpt "language/lib/primary_constructors/point.dart (point)"?>
```dart
// Current syntax.
class Point {
  int x;
  int y;

  Point(this.x, this.y);
}
```

Usar um construtor primário torna a mesma classe muito mais concisa:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-primary)" replace="/PointPrimary/Point/g"?>
```dart
// Using a primary constructor.
class Point(var int x, var int y);
```

Declarar um parâmetro no construtor primário com `var` ou `final`
induz implicitamente uma variável de instância para esse parâmetro.

Quaisquer outros construtores declarados dentro do corpo da classe são
chamados de **construtores no corpo** (in-body constructors).

Para garantir que o construtor primário seja executado em toda nova instância,
uma classe, mixin class ou enum com construtor primário
não pode ter nenhum outro construtor generativo no corpo que não seja de redirecionamento.

:::note
Se você quiser declarar construtores tradicionais no corpo da classe
de forma mais concisa, sem repetir o nome da classe, confira
[Sintaxe concisa de construtor][Concise constructor syntax].
:::

[Concise constructor syntax]: /language/constructors#concise-constructor-syntax

## Declarações de campo em parâmetros {:#field-declarations-in-parameters}

Parâmetros em construtores primários com o modificador `var` ou `final`,
chamados de **parâmetros declarantes**, induzem implicitamente um campo.

Se você omitir o modificador, o parâmetro não cria um campo.
Ele se comporta exatamente como um parâmetro em um construtor tradicional.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (declaring-parameters)"?>
```dart
// Declares both fields x and y.
class Point(var int x, var int y);

// Doesn't declare a field.
class User(String name);
```

Para extension types, o construtor primário deve ter exatamente um parâmetro.
Esse parâmetro é sempre um parâmetro declarante, mesmo que você omita o modificador.

Mixin classes só podem ter um construtor primário
sem parâmetros, corpo ou lista de inicializadores.

:::warning Novas restrições de modificadores de parâmetro
Como `final` e `var` em parâmetros agora são reservados para
parâmetros declarantes em construtores primários,
você não pode usá-los em parâmetros de outras declarações.
Para exemplos de código e orientações de migração, veja
[Restrições de modificadores de parâmetro](#parameter-modifier-restrictions).
:::

<a id="primary-initializer-scope" aria-hidden="true"></a>

## Escopos de construtor primário {:#primary-constructor-scopes}

Quando você usa um construtor primário,
os parâmetros que você declara no cabeçalho da classe ficam
disponíveis em diferentes partes da declaração da classe.
O Dart gerencia a visibilidade deles usando dois escopos distintos:

*   **Escopo de inicializador primário**:
    Aplica-se aos inicializadores de campos não-late no corpo da classe e
    à lista de inicializadores do construtor primário (após `this :`).
    Nesse escopo, um nome de parâmetro como `x` se refere
    diretamente ao parâmetro do construtor.
*   **Escopo de parâmetro primário**:
    Aplica-se ao bloco do corpo do construtor primário (dentro de `{ ... }`).
    Nesse escopo, o nome de um parâmetro declarante
    se refere à _variável de instância induzida_ (campo),
    enquanto o nome de um parâmetro não declarante ainda
    se refere ao parâmetro do construtor.

O escopo de inicializador primário torna os parâmetros do cabeçalho
diretamente disponíveis para inicializar campos não-late,
o que elimina a necessidade de uma lista de inicializadores separada.
Funciona exatamente como se você estivesse inicializando
variáveis na lista de inicializadores de um construtor tradicional:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (initializer-scope)"?>
```dart
class DeltaPoint(final int x, int delta) {
  // Accesses 'x' and 'delta' parameters directly!
  final int y = x + delta;
}
```

O escopo de parâmetro primário garante que
quaisquer atualizações nas variáveis de instância sejam
refletidas corretamente no corpo do construtor,
enquanto os inicializadores continuam tendo acesso aos parâmetros originais.
O exemplo a seguir mostra como o
mesmo nome `x` é resolvido de forma diferente em cada escopo:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (scoping-shadowing)"?>
```dart
class ScopingDemo(var String x, String suffix) {
  // In a non-late field initializer, 'x' refers to the parameter 'x'.
  final String fieldAtDeclaration = x;
  final String fieldInInitializer;

  // In the initializer list, 'x' refers to the parameter 'x'.
  this : fieldInInitializer = x {
    // Inside the body, 'x' refers to the induced instance variable,
    // so assigning to it updates the field.
    x = x.toUpperCase();
    // 'suffix' induces no field, so it still refers to the parameter.
    print('$x$suffix');
  }
}
```

Esse comportamento consistente torna a refatoração entre
construtores tradicionais e primários mais simples e segura.

## Adicionar corpos de construtor {:#add-constructor-bodies}

Para validar entradas ou realizar inicializações complexas,
você pode adicionar um corpo ao construtor primário dentro da definição da classe.
Esse corpo usa a keyword `this` seguida de um bloco:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (constructor-bodies)" replace="/PointWithBody/Point/g"?>
```dart
class Point(var int x, var int y) {
  this : assert(x >= 0 && y >= 0) {
    print('Point initialized at ($x, $y)');
  }
}
```

O bloco pode especificar uma lista de inicializadores após `this` e/ou um corpo de função.
Para fornecer apenas uma lista de inicializadores,
termine-a com um ponto e vírgula, como em `this : assert(x >= 0);`.
Você também pode anotar o bloco com metadados,
como em `@metadata this;`.

## Inicializar campos privados {:#initialize-private-fields}

Para inicializar um campo privado usando um parâmetro nomeado,
em um construtor tradicional você precisa escrever a atribuição manual como boilerplate:

<?code-excerpt "language/lib/primary_constructors/private_named_parameters.dart (private-named-old)" replace="/UserOld/User/g"?>
```dart
// Variant not using a private named parameter.
class User({required String name}) {
  String _name = name;
}
```

Com construtores primários e o recurso de parâmetros nomeados privados,
você pode declarar o campo privado diretamente no cabeçalho do construtor.
Quando você usa um nome privado (com underscore inicial) para um parâmetro nomeado,
o compilador torna o nome do parâmetro público para quem chama,
removendo o underscore:

<?code-excerpt "language/lib/primary_constructors/private_named_parameters.dart (private-named-new)" replace="/UserNew/User/g"?>
```dart
// Variant using a private named parameter.
class User({required var String _name});
```

Nos dois casos, quem chama usa o nome público `name`
no ponto de chamada: `User(name: 'John Doe')`.

## Corpos vazios {:#empty-bodies}

O corpo vazio de uma classe, mixin class, extension ou extension type (`{}`)
pode ser substituído por um ponto e vírgula (`;`).
Isso vale em geral para essas declarações,
mas é especialmente útil quando se usa um construtor primário para
manter toda a declaração em uma única linha.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (empty-bodies)" replace="/EmptyBodyPoint/Point/g"?>
```dart
class Point(var int x, var int y);
```

## Construtores primários constantes {:#constant-primary-constructors}

Assim como os construtores tradicionais,
um construtor primário pode ser constante
se a classe e seus campos permitirem.
Para declarar um construtor primário constante,
coloque o modificador `const` antes do nome da classe no cabeçalho:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (const-constructor)"?>
```dart
class const ConstPoint(final int x, final int y) {
  final int z;
  // A constant primary constructor can have an initializer list,
  // but can't have a body block.
  this : z = x + y;
}
```

Construtores primários constantes têm estas restrições importantes:

*   **Sem bloco de corpo**:
    Ter um corpo `{ ... }` é um erro em tempo de compilação, mesmo que esteja vazio.
    Um construtor primário constante só pode usar
    uma lista de inicializadores seguida de um ponto e vírgula.
*   **Campos final definitivamente inicializados**:
    Assim como em qualquer classe com construtor generativo const,
    toda variável de instância deve ser `final`, não pode ser `late`
    e deve ser definitivamente inicializada por um parâmetro declarante,
    um inicializador de campo ou a lista de inicializadores do construtor primário.
*   **Inicializadores [potencialmente constantes][potentially constant]**:
    As expressões de inicialização de cada variável de instância
    devem ser potencialmente constantes.
    Isso inclui inicializadores de campo e
    expressões na lista de inicializadores do construtor primário.

## Construtores primários nomeados {:#named-primary-constructors}

Você também pode declarar um construtor primário como um
**construtor nomeado**, acrescentando um ponto (`.`) e
um nome após o nome da classe no cabeçalho:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-named)" replace="/PointNamed/Point/g"?>
```dart
// A named primary constructor.
class Point.custom(var int x, var int y);
```

Um padrão comum é definir um
construtor primário privado (como `Point._`) que
restringe a instanciação direta e
obriga quem chama a usar métodos factory ou outros construtores:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-private)" replace="/PointPrivate/Point/g"?>
```dart
// A private named primary constructor.
class Point._(var int x, var int y);
```

## Super parameters {:#super-parameters}

Super parameters funcionam exatamente como em construtores tradicionais,
permitindo repassar parâmetros para o construtor da superclasse:

<?code-excerpt "language/lib/primary_constructors/super_parameters.dart (super-parameters)"?>
```dart
class Person(final String name, final int age);

class Employee(super.name, super.age, final String role) extends Person;
```

Isso reduz o boilerplate em estruturas de classes hierárquicas,
eliminando a necessidade de escrever manualmente listas de inicializadores
ou duplicar declarações de parâmetros.

## Construtores primários em enums {:#enum-primary-constructors}

Você pode usar construtores primários para declarar
[enums aprimorados][enhanced enums] de forma muito mais concisa.

Ao usar um construtor primário,
você pode definir os campos do enum e seu construtor em uma única linha,
eliminando o boilerplate habitual de
declarar campos, parâmetros e inicializá-los:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (enums)"?>
```dart
enum Color(final String hex) {
  red('#FF0000'),
  green('#00FF00'),
  blue('#0000FF'),
}
```

Construtores primários em enums são **implicitamente constantes**.
Embora você possa opcionalmente escrever o modificador `const` antes do nome do enum
(como em `enum const Color`), isso é redundante e pode ser omitido.

[enhanced enums]: /language/enums#declaring-enhanced-enums

## Restrições e mudanças que quebram compatibilidade {:#constraints-and-breaking-changes}

Tenha em mente estas restrições e possíveis erros
ao usar construtores primários:

*   **Parâmetros declarantes não podem ser `late` ou `external`**:
    Os modificadores `late` e `external` não são permitidos
    em parâmetros no cabeçalho do construtor primário.
    Para usar esses modificadores, declare os campos no corpo da classe, como de costume.
*   **Colisões de nome**:
    Declarar um parâmetro no construtor primário
    com o mesmo nome de um método ou de outro campo no corpo da classe
    resulta em um erro em tempo de compilação.
*   **Sem atribuições a parâmetros do construtor primário**:
    Parâmetros do construtor primário são somente leitura
    dentro do escopo de inicializador primário.
    Atribuir a eles (como com `x = 5` ou `x++`) em um inicializador de campo ou
    na lista de inicializadores do construtor primário é um erro em tempo de compilação.
*   **Dupla inicialização**:
    Você não pode inicializar uma variável de instância tanto
    em sua declaração quanto na lista de inicializadores do construtor primário
    (ou como parâmetro formal de inicialização), mesmo que o campo seja mutável.
    Fazer isso resulta em erro em tempo de compilação.
*   **Restrições da parte de corpo**:
    *   Uma parte de corpo do construtor primário (o bloco `this`) não pode
        usar os modificadores `async`, `async*` ou `sync*`, e
        não pode usar a sintaxe de corpo com seta (`=>`).
    *   Você não pode escrever um bloco `this` se o cabeçalho da classe
        não declarar um construtor primário.
    *   Uma classe pode ter no máximo uma parte de corpo de construtor primário.
*   **Construtores primários de mixin class devem ser triviais**:
    Uma mixin class só pode declarar um construtor primário se não tiver
    parâmetros, lista de inicializadores nem corpo.
*   **Parâmetros covariant**:
    Você só pode usar o modificador `covariant` em um parâmetro de
    construtor primário se ele for um parâmetro declarante mutável (usa o modificador `var`).
*   **Caso especial do método `factory`**:
    Se você tiver um método chamado `factory` sem tipo de retorno
    (por exemplo, `factory() {}`),
    o compilador o interpreta como um construtor factory conciso.
    Garanta que esses métodos tenham um tipo de retorno explícito
    (por exemplo, `void factory() {}`) para evitar esse conflito.

### Restrições de modificadores de parâmetro {:#parameter-modifier-restrictions}

Os modificadores de parâmetro `final` e `var` são reservados exclusivamente para
parâmetros declarantes em construtores primários.
Usar `final` ou `var` em parâmetros formais de qualquer outra declaração
(como funções de nível superior, métodos, closures e construtores no corpo)
produz um erro em tempo de compilação (`extraneous_modifier`).

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (declaring-parameters-error)" replace="/PointFinal/Point/g; /printValue\(/printValue(final /g"?>
```dart
// Valid: Primary constructor declaring parameter.
class Point(final int x, final int y);

// Compile-time error (extraneous_modifier):
void printValue(final int x) => print(x);
```

Para corrigir esse erro, remova o modificador ou execute [`dart fix`][].
Para impor parâmetros imutáveis como escolha de estilo,
use a regra de lint [`parameter_assignments`][].

Se você estiver usando uma [versão da linguagem][language version] 3.12 ou anterior,
pode habilitar as regras de lint [`avoid_final_parameters`][] e
[`var_with_no_type_annotation`][] para encontrar e
remover esses modificadores proativamente, antes de atualizar para o Dart 3.13.

[`avoid_final_parameters`]: /tools/linter-rules/avoid_final_parameters
[`dart fix`]: /tools/dart-fix
[language version]: /language/versioning
[`parameter_assignments`]: /tools/linter-rules/parameter_assignments
[potentially constant]: /resources/glossary#potentially-constant
[`var_with_no_type_annotation`]: /tools/linter-rules/var_with_no_type_annotation
