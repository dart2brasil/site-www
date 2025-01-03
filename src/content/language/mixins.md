---
ia-translate: true
title: Mixins
description: Aprenda como adicionar funcionalidades a uma classe em Dart.
prevpage:
  url: /language/extend
  title: Estender uma classe
nextpage:
  url: /language/enums
  title: Enums
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Mixins são uma forma de definir código que pode ser reutilizado em múltiplas hierarquias de classes.
Eles são projetados para fornecer implementações de membros em massa.

Para usar um mixin, use a palavra-chave `with` seguida por um ou mais nomes de
mixin. O exemplo a seguir mostra duas classes que usam (ou são subclasses de)
mixins:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (musician-and-maestro)" replace="/(with.*) \{/[!$1!] {/g"?>
```dart
class Musician extends Performer [!with Musical!] {
  // ···
}

class Maestro extends Person [!with Musical, Aggressive, Demented!] {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```

Para definir um mixin, use a declaração `mixin`.
No caso raro em que você precise definir um mixin _e_ uma classe, você pode usar
a declaração [`mixin class`](#class-mixin-or-mixin-class).

Mixins e mixin classes não podem ter uma cláusula `extends` e não devem
declarar nenhum construtor gerador.

Por exemplo:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (musical)"?>
```dart
mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

## Especifique membros que um mixin pode chamar em si mesmo {:#specify-members-a-mixin-can-call-on-itself}

Às vezes, um mixin depende de ser capaz de invocar um método ou acessar campos,
mas não pode definir esses membros por si mesmo (porque mixins não podem usar
parâmetros de construtor para instanciar seus próprios campos).

As seções a seguir cobrem diferentes estratégias para garantir que qualquer subclasse
de um mixin defina quaisquer membros dos quais o comportamento do mixin dependa.

### Defina membros abstratos no mixin {:#define-abstract-members-in-the-mixin}

Declarar um método abstrato em um mixin força qualquer tipo que usa
o mixin a definir o método abstrato do qual seu comportamento depende.

```dart
mixin Musician {
  void playInstrument(String instrumentName); // Método abstrato.

  void playPiano() {
    playInstrument('Piano');
  }
  void playFlute() {
    playInstrument('Flute');
  }
}

class Virtuoso with Musician {

  @override
  void playInstrument(String instrumentName) { // Subclasse deve definir.
    print('Plays the $instrumentName beautifully');
  }
}
```

#### Acesse o estado na subclasse do mixin {:#access-state-in-the-mixin-s-subclass}

Declarar membros abstratos também permite acessar o estado na subclasse
de um mixin, chamando getters que são definidos como abstratos no mixin:

```dart
/// Pode ser aplicado a qualquer tipo com uma propriedade [name] e fornece uma
/// implementação de [hashCode] e operador `==` em termos dela.
mixin NameIdentity {
  String get name;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(other) => other is NameIdentity && name == other.name;
}

class Person with NameIdentity {
  final String name;

  Person(this.name);
}
```

### Implemente uma interface {:#implement-an-interface}

Semelhante a declarar o mixin abstrato, colocar uma cláusula `implements` no
mixin, sem realmente implementar a interface, também garantirá que quaisquer dependências
de membro sejam definidas para o mixin.

```dart
abstract interface class Tuner {
  void tuneInstrument();
}

mixin Guitarist implements Tuner {
  void playSong() {
    tuneInstrument();

    print('Strums guitar majestically.');
  }
}

class PunkRocker with Guitarist {

  @override
  void tuneInstrument() {
    print("Don't bother, being out of tune is punk rock.");
  }
}
```

### Use a cláusula `on` para declarar uma superclasse {:#use-the-on-clause-to-declare-a-superclass}

A cláusula `on` existe para definir o tipo contra o qual as chamadas `super` são resolvidas.
Portanto, você só deve usá-la se precisar ter uma chamada `super` dentro de um mixin.

A cláusula `on` força qualquer classe que usa um mixin a também ser uma subclasse
do tipo na cláusula `on`.
Se o mixin depende de membros na superclasse,
isso garante que esses membros estejam disponíveis onde o mixin é usado:

```dart
class Musician {
  musicianMethod() {
    print('Playing music!');
  }
}

mixin MusicalPerformer [!on Musician!] {
  performerMethod() {
    print('Performing music!');
    super.musicianMethod();
  }
}

class SingerDancer extends Musician with MusicalPerformer { }

main() {
  SingerDancer().performerMethod();
}
```

Neste exemplo, apenas as classes que estendem ou implementam a classe `Musician`
podem usar o mixin `MusicalPerformer`. Como `SingerDancer` estende `Musician`,
`SingerDancer` pode incluir `MusicalPerformer`.

## `class`, `mixin` ou `mixin class`? {:#class-mixin-or-mixin-class}

:::version-note
A declaração `mixin class` requer uma [versão de linguagem][] de pelo menos 3.0.
:::

Uma declaração `mixin` define um mixin. Uma declaração `class` define uma [classe][].
Uma declaração `mixin class` define uma classe que pode ser usada tanto como uma classe regular
quanto como um mixin, com o mesmo nome e o mesmo tipo.

```dart
mixin class Musician {
  // ...
}

class Novice with Musician { // Usa Musician como um mixin
  // ...
}

class Novice extends Musician { // Usa Musician como uma classe
  // ...
}
```

Quaisquer restrições que se aplicam a classes ou mixins também se aplicam a mixin classes:

- Mixins não podem ter cláusulas `extends` ou `with`, portanto, nem uma `mixin class`.
- Classes não podem ter uma cláusula `on`, portanto, nem uma `mixin class`.

[language version]: /resources/language/evolution#language-versioning
[class]: /language/classes
[class modifiers]: /language/class-modifiers
