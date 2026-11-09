---
ia-translate: true
title: "3 padrões legais do Dart"
description: "Experimente estes três padrões úteis de programação em Dart no seu próximo app Flutter."
publishDate: 2020-05-20
author: JoseAlba
image: images/0alx_hKg5fP3b1b22.webp
category: other
layout: blog
---


*Sobre o autor: Jose se formou recentemente na universidade e agora trabalha no [Material](https://material.io), um design system que ajuda equipes a criar experiências digitais de alta qualidade. A equipe do Jose mantém a [biblioteca material](https://api.flutter.dev/flutter/material/material-library.html) do Flutter.*

Com o framework Flutter, você usa a linguagem de programação Dart para criar aplicações bonitas. Com o tempo, aprendi padrões úteis do Dart que me ajudaram a ser um desenvolvedor Flutter melhor. Aqui estão três que recomendo que você experimente no seu próximo aplicativo:

* Atribuir um valor condicionalmente: `boolean ? widget : widget`

* Mesclar widgets em uma coleção: `for ()...[]`

* Invocar imediatamente uma função anônima: `() {} ()`

Este artigo mostra como usar cada padrão, terminando com um Pen incorporado onde você pode brincar com o código.

<DashImage src="images/0alx_hKg5fP3b1b22.webp" alt="Uma tela dividida mostrando, à direita, a UI de um app de cardápio de restaurante e, à esquerda, o código Dart que a produz." caption="Esta captura de tela mostra o código que vou discutir e a UI que ele produz." />


## Atribuindo um valor condicionalmente {:#conditionally-assigning-a-value}

O [operador de atribuição condicional](https://dart.dev/guides/language/language-tour#conditional-expressions), `?:` (também conhecido como [operador ternário](https://en.wikipedia.org/wiki/%3F:)), exige uma expressão condicional e duas expressões de valor. Esse padrão é útil quando seu widget depende de um valor booleano. Em vez de modularizar a operação em um método separado, você pode usar o operador ternário para executar o código inline. Já usei essa técnica incontáveis vezes.

No exemplo a seguir, o título do `AppBar` depende de um valor booleano. (Neste caso, o valor depende do booleano `isVegetarian`.) Se o valor for verdadeiro, o texto do título é definido como o primeiro valor (“Vegetarian Food”); caso contrário, é o segundo valor (“Non-Vegetarian Food”).

```
appBar: AppBar(
  title: Text(Random().nextBool() 
      ? 'Vegetarian Food' 
      : 'Non-Vegetarian Food'),
),
```


## Mesclando widgets em uma coleção {:#merging-widgets-into-a-collection}

Esse padrão, `for () ...[]`, usa o operador spread (`...`) para mesclar uma lista de widgets em uma coleção existente. Eu uso sempre que trabalho com uma lista de widgets, geralmente com a propriedade `children`. O exemplo a seguir usa essa técnica para criar uma lista de widgets:

```
children: [
  Container(),
  for (final food in foods) ...[
    if (isVegetarian == food.isVegetarian)
      ListTile(title: Text(food.name)),
    SizedBox(height: 50.0),
  ],
],
```


Neste exemplo, `foods` é uma lista de objetos `Food`, definida assim:

```
List<Food> foods = [
  Food(name: 'apple', isVegetarian: true),
  Food(name: 'nuts', isVegetarian: true),
  Food(name: 'eggs', isVegetarian: true),
  Food(name: 'chicken', isVegetarian: false),
];

class Food {
  Food({
    this.name,
    this.isVegetarian,
  });

  String name;
  bool isVegetarian;
}
```


O padrão `for () ...[]` é prático sempre que você precisa adicionar vários widgets (como os widgets `ListTile` do exemplo, se `isVegetarian` for verdadeiro) várias vezes (3 vezes, no exemplo) em uma lista de widgets.

Como o operador spread (`...`) é relativamente novo no Dart, certifique-se de que seu arquivo `pubspec.yaml` especifica um Dart SDK 2.3.0 ou superior:

```
environment:
  sdk: ">=2.3.0 < 3.0.0"
```


Para saber mais sobre [operadores de coleção](https://dart.dev/guides/language/language-tour#collection-operators) e [operadores spread](https://dart.dev/guides/language/language-tour#spread-operator), leia o [tour pela linguagem Dart](https://dart.dev/guides/language/language-tour).

## Invocando imediatamente uma função anônima {:#immediately-invoking-an-anonymous-function}

O terceiro padrão, `() {} ()`, é o equivalente em Dart de uma *expressão de função invocada imediatamente ([IIFE](https://en.wikipedia.org/wiki/Immediately_invoked_function_expression)).* Esse padrão prático permite definir uma função anônima e executá-la imediatamente. Achei esse padrão extremamente útil ao trabalhar com um widget que pode ter várias saídas. Em vez de ter operadores ternários aninhados ou modularizar uma chamada simples, o código fica disponível inline. O exemplo a seguir mostra esse padrão, com uma função anônima que contém uma instrução `switch`.

```
color: () {
  switch (getRandomElement(foods).name) {
    case 'apple':
      return Colors.green;
    case 'nuts':
      return Colors.brown;
    case 'eggs':
      return Colors.yellow;
    default:
      return Colors.transparent;
  }
}(),
```


## Conclusão {:#conclusion}

Você pode usar o CodePen para brincar com código Flutter. Aqui está um Pen com todo o código deste artigo:

<iframe src="https://codepen.io/JoseAlba/embed/mdeKexM" width="800" height="600" frameborder="0" allowfullscreen></iframe>


Aqui está outro exemplo do CodePen, só com cores:

<iframe src="https://codepen.io/JoseAlba/embed/eYpgpzY" width="800" height="600" frameborder="0" allowfullscreen></iframe>


Espero que esses três padrões do Dart deem a você mais liberdade ao desenvolver aplicações Flutter. Se você tiver outras técnicas favoritas, compartilhe nos comentários!

*Para saber mais sobre o Jose, visite-o no [GitHub](https://github.com/JoseAlba), no [LinkedIn](https://www.linkedin.com/in/josealba1996/), no [YouTube](https://www.youtube.com/channel/UCOdKA_On0oPe1tz02z1QfxA?view_as=subscriber) ou no [Instagram](https://www.instagram.com/jose.alba/).*
