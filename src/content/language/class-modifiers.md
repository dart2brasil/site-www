---
ia-translate: true
title: Modificadores de classe
description: >-
  Palavras-chave modificadoras para declarações de classe para controlar o acesso a
  bibliotecas externas.
prevpage:
  url: /language/callable-objects
  title: Objetos invocáveis
nextpage:
  url: /language/class-modifiers-for-apis
  title: Modificadores de classe para mantenedores de API
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>

:::version-note
Modificadores de classe, além de `abstract`, exigem uma
[versão de linguagem][language version] de pelo menos 3.0.
:::

Modificadores de classe controlam como uma classe ou mixin pode ser usado, tanto
[de dentro de sua própria biblioteca](#abstract), quanto
de fora da biblioteca onde ele é definido.

Palavras-chave modificadoras vêm antes de uma declaração de classe ou mixin.
Por exemplo, escrever `abstract class` define uma classe abstrata.
O conjunto completo de modificadores que podem aparecer antes de uma declaração de classe incluem:

- `abstract`
- `base`
- `final`
- `interface`
- `sealed`
- [`mixin`][class, mixin, or mixin class]

Apenas o modificador `base` pode aparecer antes de uma declaração de mixin.
Os modificadores não se aplicam a outras declarações como
`enum`, `typedef`, `extension` ou `extension type`.

Ao decidir se deve usar modificadores de classe, considere os usos pretendidos
da classe e quais comportamentos a classe precisa ser capaz de confiar.

:::note
Se você mantém uma biblioteca, leia a página
[Modificadores de classe para mantenedores de API](/language/class-modifiers-for-apis)
para obter orientação sobre como navegar nessas mudanças para suas bibliotecas.
:::

## Sem modificador

Para permitir permissão irrestrita para construir ou criar subtipos de qualquer
biblioteca, use uma declaração `class` ou `mixin` sem um modificador. Por padrão, você pode:

- [Construir][Construct] novas instâncias de uma classe.
- [Estender][Extend] uma classe para criar um novo subtipo.
- [Implementar][Implement] uma classe ou interface de mixin.
- [Mix in][mixin] um mixin ou classe mixin.

## `abstract`

Para definir uma classe que não exige uma implementação completa e concreta
de toda a sua interface, use o modificador `abstract`.

Classes abstratas não podem ser construídas de nenhuma biblioteca, seja ela própria ou
uma biblioteca externa. Classes abstratas geralmente têm [métodos abstratos][abstract methods].

<?code-excerpt "language/lib/class_modifiers/ex1/a.dart"?>
```dart title="a.dart"
abstract class Vehicle {
  void moveForward(int meters);
}
```

<?code-excerpt "language/lib/class_modifiers/ex1/b.dart (abstract-usages)"?>
```dart title="b.dart"
import 'a.dart';

// Erro: Não pode ser construído.
Vehicle myVehicle = Vehicle();

// Pode ser estendida.
class Car extends Vehicle {
  int passengers = 4;

  @override
  void moveForward(int meters) {
    // ...
  }
}

// Pode ser implementada.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
```

Se você quiser que sua classe abstrata pareça instanciável,
defina um [construtor de fábrica][factory constructor].

## `base`

Para forçar a herança da implementação de uma classe ou mixin,
use o modificador `base`.
Uma classe base não permite implementação fora de sua própria biblioteca.
Isso garante:

- O construtor da classe base é chamado sempre que
  uma instância de um subtipo da classe é criada.
- Todos os membros privados implementados existem em subtipos.
- Um novo membro implementado em uma classe `base` não quebra subtipos,
  já que todos os subtipos herdam o novo membro.
  - Isso é verdade, a menos que o subtipo já declare um membro com
    o mesmo nome e uma assinatura incompatível.

Você deve marcar qualquer classe que implemente ou estenda uma classe base como
`base`, `final` ou `sealed`. Isso impede que bibliotecas externas quebrem
as garantias da classe base.

<?code-excerpt "language/lib/class_modifiers/ex2/a.dart"?>
```dart title="a.dart"
base class Vehicle {
  void moveForward(int meters) {
    // ...
  }
}
```

<?code-excerpt "language/lib/class_modifiers/ex2/b.dart"?>
```dart title="b.dart"
import 'a.dart';

// Pode ser construída.
Vehicle myVehicle = Vehicle();

// Pode ser extendida.
base class Car extends Vehicle {
  int passengers = 4;
  // ...
}

// ERRO: Não pode ser implementada.
base class MockVehicle implements Vehicle {
  @override
  void moveForward() {
    // ...
  }
}
```

## `interface`

Para definir uma interface, use o modificador `interface`.
Bibliotecas fora da própria biblioteca de definição da interface podem
implementar a interface, mas não estendê-la.
Isso garante:

- Quando um dos métodos de instância da classe chama
  outro método de instância em `this`, ele sempre
  invocará uma implementação conhecida do método da mesma biblioteca.
- Outras bibliotecas não podem substituir métodos que a interface
  próprios métodos da classe podem chamar posteriormente de maneiras inesperadas.
  Isso reduz o [problema da classe base frágil][fragile base class problem].

<?code-excerpt "language/lib/class_modifiers/ex3/a.dart"?>
```dart title="a.dart"
interface class Vehicle {
  void moveForward(int meters) {
    // ...
  }
}
```

<?code-excerpt "language/lib/class_modifiers/ex3/b.dart"?>
```dart title="b.dart"
import 'a.dart';

// Pode ser construída.
Vehicle myVehicle = Vehicle();

// ERRO: Não pode ser herdada.
class Car extends Vehicle {
  int passengers = 4;
  // ...
}

// Pode ser implementada.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
```

### `abstract interface`

O uso mais comum para o modificador `interface` é definir uma interface pura.
[Combine](#combining-modifiers) os modificadores `interface` e [`abstract`](#abstract)
para uma `abstract interface class`.

Como uma classe `interface`, outras bibliotecas podem
implementar, mas não pode herdar, uma interface pura.
Como uma classe `abstract`, uma interface pura pode ter membros abstratos.

## `final`

Para fechar a hierarquia de tipos, use o modificador `final`.
Isso impede a criação de subtipos de uma classe fora da biblioteca atual.
Impedir a herança e a implementação impede totalmente a criação de subtipos.
Isso garante:

- Você pode adicionar alterações incrementais à API com segurança.
- Você pode chamar métodos de instância sabendo que eles não foram
  substituídos em uma subclasse de terceiros.

Classes finais podem ser estendidas ou implementadas dentro da mesma biblioteca.
O modificador `final` abrange os efeitos de `base` e,
portanto, quaisquer subclasses também devem ser marcadas como `base`, `final` ou `sealed`.

<?code-excerpt "language/lib/class_modifiers/ex4/a.dart"?>
```dart title="a.dart"
final class Vehicle {
  void moveForward(int meters) {
    // ...
  }
}
```

<?code-excerpt "language/lib/class_modifiers/ex4/b.dart"?>
```dart title="b.dart"
import 'a.dart';

// Pode ser construída.
Vehicle myVehicle = Vehicle();

// ERRO: Não pode ser herdada.
class Car extends Vehicle {
  int passengers = 4;
  // ...
}

class MockVehicle implements Vehicle {
  // ERRO: Não pode ser implementada.
  @override
  void moveForward(int meters) {
    // ...
  }
}
```

## `sealed`

Para criar um conjunto conhecido e enumerável de subtipos, use o modificador `sealed`.
Isso permite que você crie um switch sobre esses subtipos que
é estaticamente garantido como [_exaustivo_][exhaustive].

O modificador `sealed` impede que uma classe seja estendida ou
implementada fora de sua própria biblioteca. Classes sealed são implicitamente
[abstratas](#abstract).

- Elas não podem ser construídas.
- Elas podem ter [construtores de fábrica](/language/constructors#factory-constructors).
- Elas podem definir construtores para suas subclasses usarem.

Subclasses de classes sealed, no entanto, não são implicitamente abstratas.

O compilador está ciente de quaisquer possíveis subtipos diretos
porque eles só podem existir na mesma biblioteca.
Isso permite que o compilador o alerte quando um switch não
lida exaustivamente com todos os subtipos possíveis em seus casos:

<?code-excerpt "language/lib/class_modifiers/ex5/sealed.dart"?>
```dart
sealed class Vehicle {}

class Car extends Vehicle {}

class Truck implements Vehicle {}

class Bicycle extends Vehicle {}

// ERRO: Não pode ser instanciada.
Vehicle myVehicle = Vehicle();

// Subclasses podem ser instanciadas.
Vehicle myCar = Car();

String getVehicleSound(Vehicle vehicle) {
  // ERRO: O switch está perdendo o subtipo Bicycle ou um caso padrão.
  return switch (vehicle) {
    Car() => 'vroom',
    Truck() => 'VROOOOMM',
  };
}
```

Se você não quiser [switching exaustivo][exhaustive],
ou quiser poder adicionar subtipos posteriormente sem quebrar a API,
use o modificador [`final`](#final). Para uma comparação mais aprofundada,
leia [`sealed` versus `final`](/language/class-modifiers-for-apis#sealed-versus-final).

## Combinando modificadores

Você pode combinar alguns modificadores para restrições em camadas.
Uma declaração de classe pode ser, em ordem:

1. (Opcional) `abstract`, descrevendo se a classe pode
   conter membros abstratos e impede a instanciação.
2. (Opcional) Um de `base`, `interface`, `final` ou `sealed`, descrevendo
   restrições em outras bibliotecas que criam subtipos da classe.
3. (Opcional) `mixin`, descrevendo se a declaração pode ser incluída.
4. A própria palavra-chave `class`.

Você não pode combinar alguns modificadores porque eles são
contraditórios, redundantes ou mutuamente exclusivos:

* `abstract` com `sealed`. Uma classe [sealed](#sealed) é
  implicitamente [abstrata](#abstract).
* `interface`, `final` ou `sealed` com `mixin`. Esses modificadores de acesso
  impedem o [mix in][mixin].

Para obter mais orientações sobre como os modificadores de classe podem ser combinados,
confira a [Referência de modificadores de classe][Class modifiers reference].

[Class modifiers reference]: /language/modifier-reference

[language version]: /resources/language/evolution#language-versioning
[class, mixin, or mixin class]: /language/mixins#class-mixin-or-mixin-class
[mixin]: /language/mixins
[fragile base class problem]: https://en.wikipedia.org/wiki/Fragile_base_class
[`noSuchMethod`]: /language/extend#nosuchmethod
[construct]: /language/constructors
[extend]: /language/extend
[implement]: /language/classes#implicit-interfaces
[factory constructor]: /language/constructors#factory-constructors
[exhaustive]: /language/branches#exhaustiveness-checking
[abstract methods]: /language/methods#abstract-methods
[syntax specification]: {{site.repo.dart.lang}}/blob/main/accepted/3.0/class-modifiers/feature-specification.md#syntax
