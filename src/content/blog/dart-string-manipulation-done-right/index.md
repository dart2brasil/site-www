---
ia-translate: true
title: "Manipulação de strings em Dart feita do jeito certo 👉"
description: "Seu app usa emojis ou suporta vários idiomas? O Dart acaba de introduzir uma nova forma de lidar com eles com segurança na manipulação de strings."
publishDate: 2020-06-30
author: taodong
image: images/1H_-SP7V6x1cQpGM_6DUReg.webp
category: deep-dive
layout: blog
---


Como muitas outras linguagens de programação criadas antes de os emojis começarem a dominar nossas comunicações diárias e antes do crescimento do suporte a vários idiomas em apps comerciais, o Dart representa uma string como [uma sequência de unidades de código UTF-16](https://api.dart.dev/stable/2.8.4/dart-core/String-class.html). A codificação funcionava bem na maioria dos casos, até que a maior internacionalização e a introdução de emojis, que acompanham qualquer idioma, fizeram os problemas inerentes à codificação virarem problema de todo mundo.

Considere este exemplo:

<DashImage src="images/1H_-SP7V6x1cQpGM_6DUReg.webp" alt="Diagram showing how the string 'Hello 👋' is mapped to UTF-16 code units." />


Na string “Hello👋”, cada caractere perceptível pelo usuário é mapeado para uma única unidade de código, exceto o emoji de mão acenando 👋. Uma consequência imediata desse mapeamento é a confusão sobre o tamanho dessa string. A linha de código a seguir vai imprimir 6 ou 7?

```
print('Hello👋'.length);
```


Para o usuário, há claramente 6 caracteres nessa string, a menos que você seja filosófico. Mas a API de `String` do Dart vai dizer que o [`length`](https://api.dart.dev/stable/dart-core/String/length.html) é 7, ou, para ser preciso, 7 unidades de código UTF-16. Essa diferença tem todo tipo de consequência, porque muitas tarefas de manipulação de texto usam índices de caractere com a API de `String`. Por exemplo, `"Hello👋"[5]` não retorna o emoji 👋. Em vez disso, retorna um caractere malformado que representa a primeira unidade de código do emoji.

A boa notícia é que o Dart ganhou um novo pacote chamado [*characters*](https://pub.dev/packages/characters), que opera sobre caracteres perceptíveis pelo usuário em vez de unidades de código UTF-16. No entanto, você, como programador Dart, precisa saber quando usar o pacote `characters`. Nossa pesquisa indica que até programadores Dart experientes podem deixar passar esses problemas com facilidade ao ler código de manipulação de texto. Neste artigo, eu passo por alguns cenários comuns em que você precisa prestar atenção extra e considerar usar o pacote `characters` em vez da `String` do Dart.

## Cenários a observar {:#scenarios-to-watch-out-for}

Nesta seção, vou passar por alguns cenários comuns de manipulação de texto, explicar por que usar a API de `String` do Dart pode causar problemas nesses cenários e mostrar como usar o pacote `characters` para resultados mais confiáveis. Os casos de uso abaixo presumem, em geral, que estamos lidando com strings digitadas por usuários humanos, que podem incluir emojis ou caracteres de um idioma que o desenvolvedor do app não espera.

### Cenário 1: contar caracteres em uma string {:#scenario-1-counting-characters-in-a-string}

Suponha que você esteja escrevendo uma função que verifica se o texto digitado pelo usuário ultrapassou um número específico de caracteres. A função retorna um número positivo de caracteres restantes se o limite não foi atingido, ou um número negativo de caracteres extras se o limite foi ultrapassado.

Isso é bem direto de fazer usando a API de `String`:

```dart
// Implementation using the String API, 
// which counts the number of UTF-16 code units
// instead of user-perceivable characters.
int remainingCapacity(String input, int limit) {
  var length = input.length;
  return limit - length;
}

```

No entanto, o teste a seguir revela o problema desse código:

```dart
test('remainingCapacity', (){
  var limit = 140;
  input = 'Laughter 😀 is the sensation of feeling good all over and showing it principally in one place.';
  expect(remainingCapacity(input, limit), equals(47));
});
```

Estes são os resultados dos testes:

```
Expected: <47>
  Actual: <46>
```


Podemos reescrever essa função usando o pacote `characters`, que fornece um método de extensão conveniente sobre `String`, para produzir o número correto de caracteres da seguinte forma:

```dart
int checkMaxLength(String input, int limit) {
  var length = input.characters.length;
  return limit - length;
}
```

### Cenário 2: extrair uma substring {:#scenario-2-extracting-a-substring}

Neste cenário, queremos implementar uma função que apaga o último caractere de uma string e retorna o resultado como uma nova string. Vamos supor que essa string venha de uma entrada do usuário.

Essa função é fácil de implementar usando o método `substring` de `String`, assim:

```dart
String skipLastChar(String text) {
  return text.substring(0, max(0, text.length - 1));
}
```

No entanto, um bom teste com emoji pode quebrar o código rapidamente:

```dart
test('skipLastChar(text)', () {
  var string = 'Hi 🇩🇰';
  expect(skipLastChar(string), equals('Hi '));
});
```

Estes são os resultados dos testes:

```
Expected: ‘Hi ’
  Actual: ‘Hi 🇩???’
    Which: is different. Both strings start the same, but the actual value also has the following trailing characters: 🇩???
```


O pacote `characters` resolve esse caso com facilidade, pois oferece métodos de alto nível como [`skipLast(int count)`](https://pub.dev/documentation/characters/latest/characters/Characters/skipLast.html)*.* Podemos reescrever esse trecho assim:

```dart
String skipLastChar(String text) {
  return text.characters.skipLast(1).toString();
}
```

### Cenário 3: dividir uma string em um emoji {:#scenario-3-splitting-a-string-on-an-emoji}

No terceiro cenário, queremos dividir uma string em um emoji específico. Aqui está uma função que faz isso usando o método split de `String`:

```dart
List splitEmojiSeparatedWords(String text, String separator) {
  return text.split(separator);
}
```

Será que funciona? Provavelmente funciona bem em 99% das vezes, mas o teste abaixo ilustra um exemplo em que o código acima produz resultados bem surpreendentes.

```dart
test('splitEmojiSeparatedWords(String text, String separator)', () {
   var text = 'abc👨‍👩‍👧‍👦👧abc👧abc👧abc';
   var separator = '👧';
   List<String> expected = ['abc👨‍👩‍👧‍👦', 'abc', 'abc', 'abc'];
   expect(td.splitEmojiSeparatedWords(text, separator), equals(expected));
});
```

Estes são os resultados dos testes:

```
Expected: ['abc👨‍👩‍👧‍👦', 'abc', 'abc', 'abc']
  Actual: ['abc👨‍👩‍','‍👦', 'abc', 'abc', 'abc']
    Which: was 'abc👨‍👩‍' instead of 'abc👨‍👩‍👧‍👦' at location [0]
```


Então, por que 👨‍👩‍👧‍👦 virou dois emojis 👨‍👩 quando a string foi dividida? Isso acontece porque 👨‍👩‍👧‍👦 é na verdade formado por quatro emojis diferentes: 👨👩👧👦. Quando a string foi dividida em 👧, “abc👨‍👩‍👧‍👦” foi separada em duas partes: “abc👨‍👩” e “‍👦”.

Você pode evitar esse problema usando o método [`split`](https://pub.dev/documentation/characters/latest/characters/Characters/split.html) da classe `Characters`, como mostra o código a seguir:

```dart
List<String> splitEmojiSeparatedWords(String text, String separator) {
  // Split returns an iterable, which we need to convert to a list.
  return [...text.characters.split(separator.characters)]; 
}
```

### Cenário 4: acessar um caractere específico pelo seu índice {:#scenario-4-accessing-a-specific-character-by-its-index}

Na manipulação de texto, é comum acessar um caractere específico pelo seu índice (isto é, sua posição) na string. Por exemplo, o trecho mostra uma função que retorna as iniciais do primeiro nome e do sobrenome digitados pelo usuário em dois campos de texto separados:

```dart
String createInitials(String firstName, String lastName) {
    return firstName[0].toUpperCase() + lastName[0].toUpperCase();
}
```

Mas, como demonstramos no início do artigo, usar o índice em uma string baseada em UTF-16 pode ser arriscado. Vamos verificar a correção do código acima com o caso de teste abaixo:

```dart
test("createInitials(firstName, lastname)", () {
    var firstName = 'étienne';
    var lastname = 'bézout';
    expect(td.createInitials(firstName, lastname), equals('ÉB'));
});
```

Estes são os resultados dos testes:

```
Expected: ‘ÉB’
  Actual: ‘EB’
    Which: is different.
```


Por que o teste falhou? Porque a letra “É” pode ser uma combinação de “E” com o acento. Você pode usar o pacote `characters` para evitar esse problema facilmente:

```dart
String createInitials(String firstName, String lastName) {
  return '${firstName.characters.first}${lastName.characters.first}';
}
```

## Exercício: omitindo o estouro de texto {:#exercise-omitting-text-overflow}

Agora, aqui vai um desafio para você. Neste cenário, o app precisa exibir uma lista de mensagens, uma por linha. Você foi convidado a revisar código que implementa uma função que exibe o estouro de texto como reticências quando o tamanho da mensagem excede o limite de caracteres informado.

```dart
String textOverflowEllipsis(String text, int limit) {
  if (text.length > limit) {
    return text.substring(0, limit - 3) + '…';
  } else {
    return text;
  }
}
```

Você consegue criar um teste que revele um possível problema nesse trecho de código? Como você o reescreveria usando o pacote `characters`? A resposta está no fim deste artigo.

## Mitigações e uma possível solução de longo prazo {:#mitigations-and-possible-long-term-solution}

Não é razoável esperar que os usuários do Dart fiquem em alerta máximo para os tipos de armadilhas descritos acima. Por exemplo, em um experimento que realizamos, 53,7% dos usuários do Dart não conseguiram detectar o problema ilustrado no primeiro cenário (contar caracteres), mesmo tendo recebido duas páginas de informação sobre o pacote `characters` e sobre o problema que ele foi projetado para resolver apenas alguns minutos antes. Por isso, estamos adotando uma abordagem em duas etapas para ajudar os desenvolvedores a escolher a API mais adequada para suas necessidades de manipulação de texto.

No curto prazo, estamos introduzindo um conjunto de mitigações no framework Flutter e no analisador do Dart para tornar o pacote `characters` mais fácil de descobrir e de usar na programação de UI em Dart. Isso envolve algumas etapas:

1. Usar o pacote `characters` na implementação interna do widget `TextField`. Veja [este PR](https://github.com/flutter/flutter/pull/53381) e [este documento de design](https://docs.google.com/document/d/1OOFW0PEZf0orBl445YXJ3nfjyKOqZdmeQ6KU3glUh7s/edit) para mais detalhes.

1. Expor a API do pacote `characters` por meio do framework Flutter. Quando isso estiver pronto, os usuários do Flutter terão mais chances de descobrir a API pela extensão [`String.characters`](https://pub.dev/documentation/characters/latest/characters/StringCharacters.html), que aparece ao usar o autocomplete em `String`. O andamento desse trabalho é acompanhado nesta issue: [https://github.com/flutter/flutter/issues/55593](https://github.com/flutter/flutter/issues/55593).

1. Atualizar a documentação da API e os exemplos de código do framework Flutter para sugerir o uso da classe [`Characters`](https://pub.dev/documentation/characters/latest/characters/Characters-class.html) quando for apropriado, como no callback de [`TextField.onChanged`](https://api.flutter.dev/flutter/material/TextField/onChanged.html). Esse trabalho é acompanhado em [https://github.com/flutter/flutter/issues/55598](https://github.com/flutter/flutter/issues/55598), com detalhes relevantes [neste documento](https://docs.google.com/document/d/18SxWeHpds4modnvo997vIOiq01EspeFgsNvPa5ey88w/edit#heading=h.1isiu2jji0ae).

1. Fazer o analisador do Dart sugerir a conversão de um objeto `String` para um objeto `Characters` ao completar automaticamente um template de callback para tratar texto digitado pelo usuário. Por exemplo, a IDE poderia preencher tudo no trecho abaixo depois que o usuário completar automaticamente `onChanged`. Esse trabalho é acompanhado em [https://github.com/dart-lang/sdk/issues/41677](https://github.com/dart-lang/sdk/issues/41677).

```dart
TextField(
  onChanged: (String value) {
  // Converting String to Characters to handle emojis 
  // and non-English characters more robustly.
  var myText = value.characters;      
  }
)
```

Essas mitigações podem ajudar, mas se limitam a manipulações de string feitas no contexto de um projeto Flutter. Precisamos medir cuidadosamente a eficácia delas quando estiverem disponíveis. Uma solução mais completa, no nível da linguagem Dart, provavelmente vai exigir a migração de pelo menos parte do código existente, embora algumas opções (por exemplo, [static extension types](https://github.com/dart-lang/language/issues/42)) *possam* tornar as mudanças incompatíveis gerenciáveis. Ainda é preciso fazer mais investigação técnica para entender completamente os trade-offs.

## Como você pode ajudar {:#how-you-can-help}

Por favor, ajude a divulgar como corrigir problemas com strings usando o pacote `characters`:

* Procure instâncias de uso de `String.length` ou `String.substring` no seu próprio código. Se a string puder ter vindo de uma entrada do usuário, tente reescrever o código com o pacote `characters`.

* Compartilhe este post com outras pessoas da comunidade Dart.

* Tente atualizar [respostas existentes sobre manipulação de texto em Dart](https://stackoverflow.com/search?q=%5Bdart%5D+or+%5BFlutter%5D+String) no StackOverflow. Se as respostas aceitas deixaram de lado essa limitação da API de `String`, lembre as pessoas do risco.

* Comente nas issues do GitHub listadas acima para nos contar o que você pensa.

Agora, bom código 😉!

## Agradecimentos {:#acknowledgments}

Obrigado a [Kathy Walrath](https://medium.com/@kathyw_39223), [Lasse Nielsen](https://medium.com/@lrhn) e [Michael Thomson](https://medium.com/@mit.mit) por revisarem este artigo. Também gostaria de agradecer aos desenvolvedores que participaram da nossa pesquisa com usuários. A participação deles ajudou as equipes do Dart e do Flutter a entender melhor o desafio de lidar com essa limitação da API de `String` do Dart.

— — —

PS: Aqui está a solução do exercício:

```dart
// Prerequisite: add the characters package as a dependency in your pubspec.yaml.
import 'package:characters/characters.dart';

void main(List<String> arguments) {
  print(textOverflowEllipsis('😸cats', 10));
  print(textOverflowEllipsis('🦏rhinoceroses', 10));
}

// This function converts text overflow to an ellipsis
// when the text's length exceeds the given character limit.
String textOverflowEllipsis(String text, int limit) {
  var myChars = text.characters;
  if (myChars.length > limit) {
    return '${myChars.take(limit - 1)}…';
  } else {
    return text;
  }
}
```
