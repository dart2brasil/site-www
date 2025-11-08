---
title: Mixins
description: Aprenda como adicionar funcionalidades a uma classe em Dart.
ia-translate: true
prevpage:
  url: /language/extend
  title: Extend a class
nextpage:
  url: /language/enums
  title: Enums
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Mixins são uma maneira de definir código que pode ser reutilizado em múltiplas hierarquias de classes.
Eles são destinados a fornecer implementações de membros em massa.

Para usar um mixin, use a palavra-chave `with` seguida por um ou mais nomes de mixin.
O exemplo a seguir mostra duas classes que usam (ou, são subclasses de)
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
No caso raro onde você precisa definir tanto um mixin _quanto_ uma classe, você pode usar
a [declaração `mixin class`](#class-mixin-or-mixin-class).

Mixins e mixin classes não podem ter uma cláusula `extends`,
e não devem declarar nenhum construtor gerativo.

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

## Especificar membros que um mixin pode chamar em si mesmo

Às vezes um mixin depende de ser capaz de invocar um método ou acessar campos,
mas não pode definir esses membros ele mesmo (porque mixins não podem usar parâmetros de construtor
para instanciar seus próprios campos).

As seções a seguir cobrem diferentes estratégias para garantir que qualquer subclasse
de um mixin defina quaisquer membros dos quais o comportamento do mixin depende.

### Definir membros abstratos no mixin

Declarar um método abstrato em um mixin força qualquer tipo que usa
o mixin a definir o método abstrato do qual seu comportamento depende.

```dart
mixin Musician {
  void playInstrument(String instrumentName); // Abstract method.

  void playPiano() {
    playInstrument('Piano');
  }
  void playFlute() {
    playInstrument('Flute');
  }
}

class Virtuoso with Musician {

  @override
  void playInstrument(String instrumentName) { // Subclass must define.
    print('Plays the $instrumentName beautifully');
  }
}
```

#### Acessar estado na subclasse do mixin

Declarar membros abstratos também permite que você acesse o estado na subclasse
de um mixin, chamando getters que são definidos como abstratos no mixin:

```dart
/// Can be applied to any type with a [name] property and provides an
/// implementation of [hashCode] and operator `==` in terms of it.
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

### Implementar uma interface

Similar a declarar o mixin abstrato, colocar uma cláusula `implements` no
mixin sem realmente implementar a interface também garantirá que quaisquer dependências de membros
sejam definidas para o mixin.

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

### Usar a cláusula `on` para declarar uma superclasse

A cláusula `on` existe para definir o tipo contra o qual chamadas `super` são resolvidas.
Então, você só deve usá-la se precisar ter uma chamada `super` dentro de um mixin.

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

Neste exemplo, apenas classes que estendem ou implementam a classe `Musician`
podem usar o mixin `MusicalPerformer`. Porque `SingerDancer` estende `Musician`,
`SingerDancer` pode misturar `MusicalPerformer`.

## `class`, `mixin` ou `mixin class`?

:::version-note
A declaração `mixin class` requer uma [versão de linguagem][language version] de pelo menos 3.0.
:::

Uma declaração `mixin` define um mixin. Uma declaração `class` define uma [classe][class].
Uma declaração `mixin class` define uma classe que é utilizável tanto como uma classe regular
quanto como um mixin, com o mesmo nome e o mesmo tipo.

```dart
mixin class Musician {
  // ...
}

class Novice with Musician { // Use Musician as a mixin
  // ...
}

class Novice extends Musician { // Use Musician as a class
  // ...
}
```

Quaisquer restrições que se aplicam a classes ou mixins também se aplicam a mixin classes:

- Mixins não podem ter cláusulas `extends` ou `with`, então nem uma `mixin class` pode.
- Classes não podem ter uma cláusula `on`, então nem uma `mixin class` pode.

[language version]: /resources/language/evolution#language-versioning
[class]: /language/classes
[class modifiers]: /language/class-modifiers
