---
ia-translate: true
title: "Anunciando o Dart 2.7: um Dart mais seguro e expressivo"
description: "Hoje anunciamos o lançamento estável do SDK do Dart 2.7, com novas capacidades para desenvolvedores. Foi um ano agitado para o Dart…"
publishDate: 2019-12-11
author: mit-mit
image: images/0G-I1kyYJFCTCiAUk.webp
category: releases
layout: blog
---


Hoje anunciamos o lançamento estável do SDK do Dart 2.7, com novas capacidades para desenvolvedores. Foi um ano agitado para o Dart, nossa linguagem otimizada para o client-side, voltada a apps rápidos em qualquer plataforma. Lançamos seis versões com dezenas de novos recursos. Foi muito gratificante ver a comunidade do Dart usando esses recursos, e ficamos felizes com o recente relatório do [GitHub Octoverse](https://octoverse.github.com/), que listou o Dart como a [linguagem que mais cresce](https://octoverse.github.com/#top-languages), medida pelo número de contribuidores.

O Dart 2.7 adiciona suporte a métodos de extensão, além de um novo pacote para lidar com strings que contêm caracteres especiais. Temos uma atualização sobre o null safety (tipos anuláveis e não anuláveis com segurança de tipos) e uma experiência totalmente nova de null safety no playground do DartPad. No nível do ecossistema, o pub.dev ganhou o recurso *Like*, para dar feedback sobre os pacotes de que você gosta. O Dart 2.7 está disponível hoje como download do SDK em [dart.dev](http://dart.dev), e também já vem incluído no [lançamento do Flutter 1.12](https://medium.com/@csells_18027/flutter-1-12-release-blog-22c256ba525d) de hoje.

<DashImage src="images/0G-I1kyYJFCTCiAUk.webp" alt="Dart 2.7 release banner highlighting extension methods, the characters package in preview, and the null safety preview." />


## Métodos de extensão {:#extension-methods}

O Dart 2.7 traz um recurso de linguagem muito pedido e poderoso: os **métodos de extensão**. Eles permitem adicionar novas funcionalidades a qualquer tipo, mesmo tipos que você não controla, com a concisão e a experiência de auto-complete das chamadas de método comuns.

Vejamos um pequeno exemplo: adicionar suporte a converter strings em ints e doubles. Como desenvolvedores de apps, não podemos alterar a classe `String`, porque ela é definida na biblioteca dart:core, mas com métodos de extensão podemos estendê-la! Depois de definir essa extensão, podemos chamar nosso novo método `parseInt` em uma String como se ele tivesse sido definido na própria classe String:

```
extension ParseNumbers on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}

main() {
  int i = '42'.parseInt();
  print(i);
}
```


## Métodos de extensão são estáticos {:#extension-methods-are-static}

Métodos de extensão são resolvidos e despachados estaticamente, o que significa que você não pode chamá-los em valores cujo tipo é `dynamic`. Aqui, a chamada lança uma exceção em tempo de execução:

```
dynamic d = '2';

d.parseInt();

→ Runtime exception: NoSuchMethodError
```


Métodos de extensão funcionam bem com a [inferência de tipos](https://dart.dev/guides/language/sound-dart#type-inference) do Dart, então, na variável `v` a seguir, o tipo inferido é `String`, e a extensão sobre String fica disponível:

```
var v = '1';
v.parseInt(); // Works!
```


Como métodos de extensão são resolvidos estaticamente, eles são tão rápidos quanto chamar uma função estática ou um método auxiliar, mas com uma sintaxe de invocação bem mais amigável.

## Extensões podem ter variáveis de tipo {:#extensions-can-have-type-variables}

Imagine que queremos definir uma extensão sobre `List` para obter os elementos em índices pares. Queremos que essa extensão funcione com listas de qualquer tipo, retornando uma nova lista do mesmo tipo da lista de entrada. Podemos fazer isso tornando a extensão genérica e aplicando seu parâmetro de tipo tanto ao tipo estendido quanto ao método de extensão:

```
extension FancyList<T> on List<T> {
  List<T> get evenElements {
    return <T>[for (int i = 0; i < this.length; i += 2) this[i]];
  }
}
```


## Métodos de extensão são, na verdade, membros de extensão {:#extension-methods-are-really-extension-members}

Chamamos o recurso de *métodos de extensão* porque esse é um termo familiar se você já usou o recurso equivalente em outras linguagens de programação. Mas no Dart o recurso é mais geral: ele também permite estender classes com novos getters, setters e operadores. No exemplo FancyList acima, `evenElements` é um getter. Aqui está um exemplo de um operador para deslocar strings:

```
extension ShiftString on String {
  String operator <<(int shift) {
    return this.substring(shift, this.length) + this.substring(0, shift);
  }
}
```


## Ótimos exemplos da comunidade {:#great-examples-from-the-community}

Já vimos muitos desenvolvedores da comunidade Dart experimentando métodos de extensão. Aqui estão alguns dos usos interessantes que vimos até agora.

Jeremiah Ogbomo criou o [pacote time](https://pub.dev/packages/time), que usa extensões sobre `num` (a classe base de ints e doubles) para facilitar a construção de objetos `Duration`:

```
// Create a Duration via a `minutes` extension on num.
Duration tenMinutes = 10.minutes;

// Create a Duration via an `hours` extension on num.
Duration oneHourThirtyMinutes = 1.5.hours;

// Create a DateTime using a `+` operator extension on DateTime.
final DateTime afterTenMinutes = DateTime.now() + 10.minutes;
```


Marcelo Glasberg criou um [pacote de i18n (internacionalização)](https://www.reddit.com/r/FlutterDev/comments/dm288s/dart_extensions_applied_to_i18n_you_have/) que usa métodos de extensão para simplificar a localização de strings:

```
Text('Hello'.i18n) // Displays Hello in English, Hola in Spanish, etc.
```


Simon Leier criou o [pacote dartx](https://pub.dev/packages/dartx), que contém extensões para vários tipos principais do Dart. Alguns exemplos:

```
var allButFirstAndLast = list.slice(1, -2);    // [1, 2, 3, 4]
var notBlank = ' .'.isBlank;                   // false
var file = File('some/path/testFile.dart');
print(file.name);                              // testFile.dart
print(file.nameWithoutExtension);              // testFile
```


Brian Egan está [atualizando](https://github.com/ReactiveX/rxdart/pull/368) o popular [pacote RxDart](https://pub.dev/packages/rxdart) com métodos de extensão para redefinir a API de trabalho com streams.

## Manipulação segura de substrings {:#safe-substring-handling}

A classe String padrão do Dart usa a codificação [UTF-16](https://en.wikipedia.org/wiki/UTF-16). É uma escolha comum em linguagens de programação, especialmente naquelas que oferecem suporte para rodar nativamente em dispositivos e na web.

Strings UTF-16 normalmente funcionam bem, e a codificação é transparente para o desenvolvedor. No entanto, ao manipular strings, principalmente strings digitadas pelos usuários, você pode notar uma diferença entre o que o usuário percebe como um caractere e o que está codificado como unidade de código em UTF-16. Vejamos um pequeno exemplo, extraindo os três primeiros caracteres de uma string digitada por um usuário:

```
var input = ['Resume'];
input.forEach((s) => print(s.substring(0, 3)));

$ dart main.dart
Res
```


Nenhum problema até aqui; imprimimos os três primeiros caracteres da string na nossa lista de entrada, e o resultado é `Res`. Agora vamos considerar usuários de diferentes regiões, que podem digitar strings com acentos, Hangul (escrita coreana) e até uma combinação de emojis para representar o conceito de "currículo":

```
// New longer input list:
var input = ['Resume', 'Résumé', '이력서', '💼📃', 'Currículo'];

$ dart main.dart
Res
Ré
이력서
💼�
Cur
```


Hmm, alguns funcionaram, mas o que aconteceu com os elementos `Résumé` e `💼📃`? Para `Résumé`, por que obtivemos uma string de "dois caracteres"? Para `💼📃`, o que houve com aquele ponto de interrogação estranho? Os problemas aqui estão nos [cantos obscuros do Unicode](https://eev.ee/blog/2015/09/12/dark-corners-of-unicode/). O `é` acentuado em `Résumé` é, na verdade, dois code points: um *e* e um [*acento agudo combinante*](https://unicode.org/cldr/utility/character.jsp?a=0301). E 📃, o emoji de [página com curl](https://emojipedia.org/emoji/%F0%9F%93%83/), é um único code point que, por acaso, é codificado com um par substituto `U+d83d U+dcc3`. Confuso?

Como dissemos, muitas vezes você não precisa se preocupar com caracteres e code points. Se tudo o que você faz é receber, repassar e entregar strings inteiras, a codificação interna é transparente. Mas se você precisar iterar sobre os caracteres de uma string ou manipular o conteúdo dela, pode ter problemas. A boa notícia é que o Dart 2.7 **introduz um novo pacote, [characters](https://pub.dev/packages/characters)**, para lidar com esses casos. Esse pacote oferece suporte para tratar strings como sequências de caracteres percebidos pelo usuário, também conhecidos como [clusters de grafemas](https://unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries) do Unicode. Com o pacote characters, podemos corrigir nosso código com uma pequena mudança no trecho que encurta o texto:

```
// Before:
input.forEach((s) => print(s.substring(0, 3)));

// After, using the characters package:
input.forEach((s) => print(s.characters.take(3)));
```


Primeiro criamos uma nova instância de `Characters` a partir da string em `s` (usando o prático método de extensão `.characters`). Depois usamos o engenhoso método `take()` para extrair os 3 primeiros caracteres.

Uma prévia técnica desse novo pacote está [disponível no pub.dev](https://pub.dev/packages/characters). Adoraríamos saber o que você acha desse pacote. Se encontrar algum problema, [por favor, reporte](https://github.com/dart-lang/characters/issues).

## Prévia do null safety {:#null-safety-preview}

Há alguns meses, [anunciamos nossa intenção](/blog/announcing-dart-2-5-super-charged-development#closing-thoughts) de dar suporte a **null safety** no Dart, adicionando suporte para acessar referências de objetos com segurança, sem disparar exceções de referência nula. Hoje, oferecemos uma forma de visualizar a análise estática do null safety. Vejamos um pequeno exemplo que motiva o recurso:

```
void main() {
  Person('Larry', birthday: DateTime(1973, 03, 26)).describe();
  Person('Sergey').describe();
}

class Person {
  String firstName;
  DateTime birthday;
  Person(this.firstName, {this.birthday});

  void describe() {
    print(firstName);
    int birthyear = birthday?.year;
    print('Born ${DateTime.now().year - birthyear} years ago');
  }
}
```


Se executarmos esse código, ele quebra com uma exceção de ponteiro nulo ao descrever a segunda pessoa, porque essa pessoa não tem data de nascimento definida. Cometemos um erro de programação: embora tenhamos previsto que algumas pessoas teriam datas de nascimento desconhecidas, tornando o campo `birthday` opcional no construtor e testando se ele é nulo em `birthday?.year`, esquecemos de tratar o caso em que `birthyear` é nulo.

Vamos colar esse código no nosso novo [playground de null safety](https://nullsafety.dartpad.dev), uma versão especial do DartPad que contém uma prévia técnica da parte de análise estática do recurso de null safety. Sem nem executar o código, já vemos três problemas:

<DashImage src="images/0YFTJUSwsYzsHTY4b.webp" alt="DartPad with null safety showing three diagnostics related to null." caption="DartPad with null safety showing three analysis errors related to nulls" />


Corrigindo esses erros de análise, podemos começar a aproveitar o null safety. Tente fazer as seguintes edições no playground de null safety (até chegar a [este código seguro](https://gist.github.com/mit-mit/c210bfb088545e69ba9231ee459615ba)):

1. Para declarar que birthday pode ser nulo, troque
*`DateTime birthday`* por *`DateTime? birthday`*

1. Para declarar que birthyear pode ser nulo quando birthday for nulo, troque
*`int birthyear`* por *`int? birthyear`*

1. Envolva a última chamada de print em um teste de nulo:
`*if (birthyear != null)* {…}`

Esperamos que este exemplo dê uma boa ideia da experiência que queremos oferecer com o null safety. Como mencionado, este playground é apenas uma prévia técnica inicial de parte do null safety, enquanto ele está sendo construído. Estamos trabalhando duro para concluir uma primeira versão beta do null safety no SDK do Dart. Eis o que estamos fazendo para o beta:

1. Concluir a implementação completa de referências anuláveis e não anuláveis

1. Integrar o null safety à inferência de tipos e à promoção inteligente do Dart (por exemplo, permitindo o acesso seguro a uma variável anulável depois de uma atribuição ou verificação de nulo)

1. Portar as [bibliotecas core](https://dart.dev/guides/libraries) do Dart para declarar quais tipos são anuláveis e quais não são

1. Adicionar uma ferramenta de migração, que pode automatizar a maior parte das tarefas de atualização para portar apps e pacotes Dart

Assim que esse trabalho for concluído, disponibilizaremos tudo em um SDK beta, e você poderá começar a aproveitar o recurso nos seus apps e pacotes. Também planejamos manter o playground de null safety atualizado com novos recursos à medida que forem implementados.

Embora muitos desenvolvedores certamente queiram usar o null safety assim que estiver disponível, você pode migrar quando for mais conveniente, optando pelo recurso quando estiver pronto. Bibliotecas e pacotes que ainda não aderiram ao recurso poderão depender de bibliotecas que *já aderiram*, e vice-versa.

Vamos falar mais sobre null safety nos próximos meses, incluindo conselhos mais detalhados sobre como se preparar para a transição.

## Curtindo 👍 pacotes no pub.dev {:#liking-packages-on-pubdev}

Também estreando hoje no pub.dev está o novo **recurso *Like*** para pacotes. Ele introduz um novo "sinal humano" para indicar quais pacotes você gosta. Para curtir um pacote, basta clicar no ícone de joinha ao lado das informações de detalhe do pacote:

<DashImage src="images/0xCGEGkntNxnM1XAh.webp" alt="Pub.dev package detail page with new Like-feature voting button." caption="*pub.dev package detail page with new Like-feature voting button*" />


Atualmente, não consideramos o número de curtidas no nosso modelo de pontuação geral, mas planejamos fazer isso em uma versão futura. Também planejamos uma renovação visual da nossa interface de busca geral e das páginas de listagem, que vai destacar a capacidade de um pacote de ser curtido.

## Obrigado {:#thank-you}

Em nome da equipe do Dart, gostaríamos de agradecer a você, e a toda a comunidade do Dart, pelo apoio contínuo! Continue nos dando feedback e participe das [discussões e comunidades](https://dart.dev/community) do Dart. Não seríamos um projeto open source bem-sucedido sem o apoio que recebemos da comunidade Dart.

2019 foi um ano incrivelmente empolgante para o Dart, mas não vamos parar por aqui. Temos planos ousados para 2020, incluindo lançar versões estáveis de recursos como [dart:ffi](https://dart.dev/guides/libraries/c-interop) e [null safety](https://github.com/dart-lang/language/issues/110), além de introduzir novos recursos. Convidamos você a começar a usar o Dart 2.7 hoje. Ele está disponível em [dart.dev](http://dart.dev), no lançamento do [Flutter 1.12](https://medium.com/@csells_18027/flutter-1-12-release-blog-22c256ba525d) de hoje, e no [DartPad redesenhado](/blog/a-brand-new-dartpad-dev-with-flutter-support) recentemente.
