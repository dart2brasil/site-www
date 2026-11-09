---
ia-translate: true
title: "Uma introdução à imutabilidade com Dart"
description: "É impossível negar que imutabilidade é um assunto em alta na programação, especialmente na programação front-end. Bibliotecas como Immutable.js e…"
publishDate: 2017-04-24
author: matanlurey
category: other
layout: blog
---


É impossível negar que [imutabilidade](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=0ahUKEwiM4_LAjLzTAhWDKGMKHbnICLYQFggmMAE&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FImmutable_object&usg=AFQjCNEkdj3g887nk6kENS9SYN-2xsqXpw&sig2=hZqSkCh5MKP-OX2w8YyjvQ) é um assunto em alta na programação, especialmente na programação front-end. Bibliotecas como [Immutable.js](https://facebook.github.io/immutable-js/) e outros conceitos, como fluxo de dados unidirecional, defendem que é mais fácil raciocinar sobre os dados quando eles não mudam por baixo de você:
> Em programação orientada a objetos e funcional, um objeto **imutável** (objeto não modificável) é um objeto cujo estado não pode ser modificado depois de criado. Isso contrasta com um objeto mutável (objeto modificável), que pode ser modificado depois de criado.

E o Dart? Temos alguns conceitos nativos que se prestam bem à imutabilidade e a objetos imutáveis, a começar pelo modificador *const* e pelo construtor *const*. Não confunda com o *const* do ES6, que é apenas um binding imutável:

```javascript
// Define USER as a constant and give it an initial value.
const USER = { name: 'Joe'; }

// This will throw an error.
USER = {};

// But this will not.
USER.name = 'Jill';

```

Em Dart, *const* é ao mesmo tempo um binding imutável *e* um objeto imutável:

```dart
main() {
  const user = const {'name': 'Joe'};
  
  // Static error: "Constant variables cannot be assigned a value".
  user = {};
  
  // Runtime error: "Unsupported operation: Cannot modify unmodifiable Map".
  user['name'] = 'Jill';
}

```

Todos os literais (*Null, String, int, double, num, bool, Map, List, Symbol*) podem ser *const*, e é possível criar tipos de usuário com um construtor *const*:

```dart
class User {
  final String name;
  
  const User(this.name);
}

main() {
  const user = const User('Joe');
}

```

Recapitulando: instâncias *const* são bindings imutáveis, têm a imutabilidade profunda *garantida* no nível da linguagem e também são *canonicalizadas* em tempo de compilação, ou seja, duas instâncias quaisquer são consideradas equivalentes e são representadas por uma única instância durante a execução. Por exemplo, o código a seguir é bem barato, já que aloca uma única instância em tempo de execução:

```dart
class User {
  final String name;
  final List<String> cars;
  
  User(this.name, {this.cars});
}

main() {
  for (var i = 0; i < 100; i++) {
    const users = const {
      'Matan': const User(
        'Matan Lurey',
        cars: const [
          'Truck',
          'Jeep',
          'GoKart',
        ],
      ),
    };
  }
}

```

Quer saber mais? [Leia o tour da linguagem Dart sobre final e const](https://www.dartlang.org/guides/language/language-tour#final-and-const).

## Mais verificação estática com package:meta {:#further-static-checking-with-package-meta}

Claro que *const* é um pouco restritivo, pois você precisa conseguir criar a classe em tempo de compilação. Não daria, por exemplo, para ler um banco de dados e criar objetos *const* em tempo de execução. Recentemente introduzimos a anotação "immutable" com o [package:meta](https://pub.dartlang.org/packages/meta):

```dart
import 'package:meta/meta.dart';

// Error: This class inherits from a class marked as @immutable, and therefore 
// should be immutable (all instance fields must be final).
@immutable
class User {
  String name;
}

```

Você pode usar essa anotação para ajudar a garantir que os desenvolvedores mantenham suas classes profundamente imutáveis. Ela não será canonicalizada como *const*, mas ainda assim pode ajudar bastante os desenvolvedores.

Espero que esta tenha sido uma boa introdução à imutabilidade. Me conte nos comentários ou no twitter se quiser saber mais sobre Dart ou imutabilidade.
