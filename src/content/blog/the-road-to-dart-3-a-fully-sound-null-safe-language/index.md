---
ia-translate: true
title: "O caminho para o Dart 3: uma linguagem com sound null safety completo"
description: "Preparando a próxima grande versão, na qual o Dart passa a suportar apenas sound null safety"
publishDate: 2022-12-08
author: mit-mit
image: images/05XfWLgEBx4iJvuqA.webp
category: other
layout: blog
---


Nos últimos quatro anos, evoluímos o Dart para uma linguagem rápida, portável e moderna. Nossa próxima versão, o Dart 3, completa a jornada até uma **linguagem com sound null safety completo**. Como último passo dessa jornada, estamos removendo vários artefatos históricos da linguagem Dart e do SDK, incluindo **a remoção do suporte à execução sem sound null safety**. Isso torna o Dart mais fácil de aprender e nos permite evoluir o SDK do Dart para suportar novos recursos com mais rapidez. Para conhecer as principais mudanças no Dart 3 e como preparar da melhor forma seus apps e pacotes, continue lendo!

<DashImage src="images/05XfWLgEBx4iJvuqA.webp" alt="Uma estrada sinuosa representando o caminho para o Dart 3." caption="O caminho para o Dart 3. *(Foto de [Niklas Ohlrogge](https://unsplash.com/@ohlrogge?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) no [Unsplash](https://unsplash.com/s/photos/road-denmark?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText))*" />


## Por que sound null safety? {:#why-sound-null-safety}

Muitas linguagens de programação modernas oferecem null safety (também conhecido como [void safety](https://en.wikipedia.org/wiki/Void_safety)). Isso evita problemas de desreferenciamento de null, que Tony Hoare chamou de "o erro de um bilhão de dólares": *“Isso causou inúmeros erros, vulnerabilidades e travamentos de sistemas, que provavelmente custaram um bilhão de dólares em prejuízos e danos nos últimos quarenta anos”* ([*Hoare 2009*](https://web.archive.org/web/20090119110704/http://qconlondon.com/london-2009/presentation/Null+References%3A+The+Billion+Dollar+Mistake)). Para resolver isso, linguagens como Swift, C# e Kotlin oferecem um sistema de tipos no qual você pode declarar variáveis como *não nulas* (que nunca podem conter o valor null) ou *nuláveis* (que podem conter um valor ou null). Esse sistema de tipos pode ser combinado com análise estática para detectar qualquer atribuição de null a variáveis não nulas. O suporte a null safety na linguagem Dart usa um modelo semelhante, tornando as variáveis não nulas por padrão e permitindo null apenas quando declarado explicitamente.

Indo um passo além, **o Dart introduz *sound null safety* em uma linguagem já existente**. Um sistema sólido garante que uma variável não nula *nunca* contenha o valor null. Durante o planejamento inicial do null safety do Dart, [exploramos](https://github.com/dart-lang/language/blob/master/accepted/2.12/nnbd/roadmap.md) esse tema e as escolhas que outras linguagens haviam feito. O design do Swift já incluía solidez desde o início. O TypeScript não é sólido por natureza, já que seu sistema de tipos subjacente permite tratar qualquer objeto como qualquer tipo estático. Como você pode ver [neste exemplo em TypeScript](https://www.typescriptlang.org/play?#code/MYGwhgzhAECyCeAVeAHApgHkQPmgbwChpoA3MEAVzWgC5pEBuI6YAewDsIAXAJwuC6seACgD6ZStTqIAlPi4ALAJYQAdBKrQAvNHHkqDAL4FjBAGYV2ApR2hgAJvYCC7eIqXsA5hgCi2YWA8PGDwdE5BIb7YADTQaCBoALZo7Fx0PnKExMSBwfCqKBQQCsLxSSlcMkymZDykAIx0CMjoGOwUiQBGaHUAPtDtICC4OuxoAO5wSKhowgAsAExVBLWkC9oNTGycrAmqIKyewgAGAMSNDdAq0AAkeCT16vpohrEk69d370+ShscyBAISjM0GEDx+mgAhKMKENMswAPQI6AAETQoEC1AAHnYYOwOABaQbgToJWKdChcaDjajAMDsaDcJRDXEQJSeBnE6CCK5pZjfDTUGFDJjEVY4ujtLo9DbgwUMYjMbYQXZofaHE6nBaSwlcnEqOh3LF-AGmJHQJzQEAqKmsEH49hE2EgaAASVSahWgWgiXgABkbWEIvA2h1ujwRtAANr1WILWKLAC6TAI5qcjjsA2dqgt7HsmYdTulPBzAAUeB4qYpqDw0BBYVxVAQHM5XO4vMJfQHuLFicsWy43MovBgAPKdABW6K4-i7NtiACJEMoYNd8VS0CQUgWwz0F8tlar1UcF6cAMx0a3cK4QGgL2Jz7jLIA), podemos atribuir um valor null a uma variável não nula. Por motivos de ergonomia e para evitar a migração de todo o código existente, o C# tem várias [exceções](https://devblogs.microsoft.com/dotnet/nullable-reference-types-in-csharp/#avoiding-dereferencing-of-nulls) às suas verificações de null. O Kotlin tem algumas [exceções](https://kotlinlang.org/docs/null-safety.html#nullable-types-and-non-null-types) não sólidas, em parte por causa do objetivo de interoperar com Java. Como você pode ver neste exemplo em Kotlin, [tipos genéricos](https://play.kotlinlang.org/embed?short=yOc5EY5E8&theme=darcula) podem fazer valores null chegarem a uma lista declarada para conter elementos não nulos.

Para o Dart, escolhemos o caminho do sound null safety. Isso envolveu um compromisso. Em alguns casos, tornou a migração para null safety um pouco mais cara, mas resulta em um sistema de tipos sólido, com confiança total nas anotações de tipo não nulo. Podemos fazer [otimizações](/blog/dart-and-the-performance-benefits-of-sound-types) nos nossos compiladores e runtimes com base no aspecto de nulabilidade do sistema de tipos. *Sabemos* exatamente quando uma variável não é null. Achamos que esse foi o conjunto certo de compromissos para o Dart.

## No Dart 3, todo o código Dart usará sound null safety {:#in-dart-3-all-dart-code-will-use-sound-null-safety}

*Issue de acompanhamento: [SDK #49530](https://github.com/dart-lang/sdk/issues/49530).*

Já faz três anos desde que introduzimos o null safety na linguagem Dart, no [Dart 2.12](https://dart.dev/guides/language/evolution#dart-212). Como mencionado na seção anterior, reconhecemos o impacto necessário para migrar pacotes e apps Dart existentes. Para ajudar na migração, o Dart tem permitido executar o código dos seus apps de três maneiras. Ele pode rodar sem null safety, em um modo misto com null safety parcial, ou com sound null safety completo. O sound null safety completo acontece quando 100% do código, incluindo todas as dependências, foi migrado. Isso deu aos desenvolvedores Dart tempo para migrar o código existente aos poucos. Porém, ter suporte a vários modos adicionou overhead e complexidade.

Primeiro, os desenvolvedores Dart precisam conhecer os três modos. Sempre que você lê um trecho de código Dart, precisa verificar a [versão da linguagem](https://dart.dev/language/versioning) para ver se os tipos são não nulos por padrão, nuláveis por padrão ou alguma combinação dos dois.

Segundo, oferecer suporte aos três modos nos nossos compiladores e runtimes torna a evolução do SDK do Dart mais lenta. Esse suporte aumenta o custo e a complexidade de adicionar novos recursos.

No Dart 3, o sound null safety será, como [mencionado](/blog/dart-2-18-objective-c-swift-interop) e [anunciado](https://groups.google.com/a/dartlang.org/g/announce/c/P3UygvbXPgY) anteriormente, o [único modo suportado](https://github.com/dart-lang/sdk/issues/49530). Arquivos pubspec com uma restrição de SDK cujo limite inferior seja menor que 2.12 vão **parar de resolver** no Dart 3 e versões posteriores. Qualquer código-fonte que contenha marcadores de linguagem falhará se você definir a restrição para uma versão menor que 2.12 (por exemplo, `// @dart=2.9`).

Com base na nossa telemetria, acreditamos que cerca de 85% de todas as execuções de `flutter run` usam sound null safety atualmente. Se você tem apps ou pacotes nos 15% restantes, por favor [migre](https://dart.dev/null-safety/migration-guide) antes do lançamento do Dart 3, que esperamos que aconteça por volta de meados de 2023.

Entendemos que a migração de grandes bases de código pode levar algum tempo. Acreditamos que você vai achar a migração compensadora. A BMW migrou recentemente o app principal MyBMW, [um app muito grande](https://www.press.bmwgroup.com/global/article/detail/T0328610EN/the-my-bmw-app:-new-features-and-tech-insights-for-march-2021?language=en), criado por uma equipe de cerca de 300 desenvolvedores:

*“Embora a migração para null safety certamente não tenha sido fácil para uma base de código de grande escala como a do app MyBMW, as ferramentas do Google nos ajudaram muito no processo de migração. Depois de concluir a migração, temos o prazer de contar com uma base de código menos propensa a erros.”, Christian Schmid, BMW AG*

Para saber mais sobre migração, veja o vídeo a seguir ou confira o [guia de migração](https://dart.dev/null-safety/migration-guide).

<YoutubeEmbed id="eBr5tlumwlg" title="Como migrar pacotes Dart para null safety" fullwidth="true"/>


## Mudanças incompatíveis na linguagem e na API {:#breaking-language-and-api-changes}

Junto com a mudança de null safety, estamos fazendo algumas outras mudanças para remover artefatos históricos da linguagem Dart e das APIs da biblioteca principal. Essas mudanças incluem a remoção de APIs descontinuadas da biblioteca principal ([#49529](https://github.com/dart-lang/sdk/issues/49529)), a remoção de uma sintaxe histórica para valores padrão de parâmetros ([#2357](https://github.com/dart-lang/language/issues/2357)) e a exigência de que os tear-offs sejam explícitos ([#2399](https://github.com/dart-lang/language/issues/2399)).

Acreditamos que essas mudanças têm baixo impacto em código migrado para usar null safety. Quando lançarmos o primeiro build alpha do Dart 3, você poderá testar rapidamente se alguma dessas mudanças menores e incompatíveis se aplica aos seus pacotes ou apps.

## Novos recursos e capacidades do Dart 3 {:#new-dart-3-features-and-capabilities}

O Dart 3 também deve trazer uma série de novas capacidades, incluindo melhor interoperabilidade com outras linguagens de programação e novos recursos da linguagem. Vamos falar muito mais sobre esse tema no nosso próximo grande evento, o [Flutter Forward](https://flutter.dev/events/flutter-forward), em 25 de janeiro de 2023.

Vamos dar uma prévia de um recurso da linguagem, chamado ***patterns***. Patterns tornam a linguagem Dart muito mais expressiva, adicionam suporte a dados mais estruturados e permitem um estilo mais funcional, com tipos algébricos de dados.

O código a seguir mostra um exemplo de uma função que retorna múltiplos valores, combinado com a capacidade de *desestruturar* esses valores em variáveis individuais:

```dart
// A function which returns a record -- in this case a pair of two doubles:
(double x, double y) getLocation(String name) {
  if (name == 'Aarhus') {
    return (56.1629, 10.2039);
  } else {
    ...
  }
}

// Deconstructing the returned record back into individual variables:
void main(List<String> arguments) {
  final (lat, long) = getLocation('Aarhus');
  print('Current location: $lat, $long');
}

// You can also define a hierarchy of classes, and then pattern match on those:
sealed class Shape {
  double calculateArea();
}

class Square implements Shape {
  final double length;
  Square(this.length);
  double calculateArea() => length * length;
}

class Circle implements Shape {
  final double radius;
  ...
}

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => math.pi * r * r
};

```

Vamos compartilhar muitos outros detalhes sobre esse novo recurso no início do próximo ano. Para ver uma prévia, você pode consultar a [especificação da linguagem](https://github.com/dart-lang/language/blob/master/accepted/future-releases/0546-patterns/feature-specification.md).

## Além do Dart 3 {:#beyond-dart-3}

Trabalhamos em uma infinidade de possíveis novos recursos em paralelo, passando da ideação para a experimentação e, depois, para um possível lançamento. Como consequência, parte do trabalho atual será concluída depois do Dart 3.

Primeiro, como [mencionamos no ano passado](/blog/experimenting-with-dart-and-wasm), estamos trabalhando no suporte à compilação de código Dart para WebAssembly (**Wasm**). O Wasm permite que apps Flutter Web rodem como código nativo completo nos navegadores. Este é um trabalho grande, que exige mais do que atualizar os compiladores do Dart. Ele requer colaboração com o W3C e com os fabricantes de navegadores para adicionar suporte a linguagens com coleta de lixo no Wasm, por meio da extensão [WasmGC](https://github.com/WebAssembly/gc/blob/master/proposals/gc/Charter.md).

Segundo, estamos trabalhando em **macros**. Elas possibilitam a [metaprogramação estática](https://github.com/dart-lang/language/blob/master/working/macros/feature-specification.md). Esse mecanismo poderoso permite que um trecho de código (uma macro) modifique e estenda o código-fonte de um programa durante a compilação do programa. Por exemplo, isso pode reduzir o código repetitivo necessário para desserializar JSON ou criar classes de dados.

Você pode esperar esses recursos, e outros igualmente interessantes, depois do Dart 3.

## O caminho para o Dart 3 {:#the-road-to-dart-3}

Como mencionado nas seções anteriores, se você ainda não migrou para sound null safety, esse é o primeiro passo. Recomendamos que você faça isso agora!

Em seguida, o Dart 3 será lançado em uma série de marcos. Nossas expectativas atuais giram em torno destas datas:

* **Por volta de janeiro/fevereiro de 2023**: lançamento do alpha do Dart 3. Ele se concentra em permitir testes iniciais de compatibilidade com o Dart 3. Esperamos que você consiga executar a análise estática (`dart analyze` / `flutter analyze`). Nosso objetivo é que qualquer app ou pacote que passe na análise estática com o alpha do Dart 3 seja compatível com o Dart 3 estável.

* **Por volta de março/abril de 2023**: lançamento do beta do Dart 3. Esta versão apresenta os novos recursos do Dart 3. Você pode usá-la para experimentar esses recursos e enviar feedback sobre issues ou sugestões de melhorias.

* **Por volta de meados de 2023**: lançamento estável do Dart 3. O sound null safety se torna o único modo suportado.

## Resumo {:#summary}

A versão Dart 3 está prevista para ser lançada por volta de meados de 2023. Ela conterá várias mudanças incompatíveis, principalmente a descontinuação da execução sem sound null safety. Esperamos ter um build alpha do Dart 3 pronto por volta de janeiro ou fevereiro de 2023, que você poderá usar para testes de compatibilidade com o Dart 3.

Para preparar seus apps:

* Conclua quaisquer [migrações de null safety](https://dart.dev/null-safety/migration-guide) pendentes

* Verifique se o seu código não usa nenhuma API descontinuada

* Execute o [`dart fix`](https://dart.dev/tools/dart-fix).

O Dart 3 também terá vários novos recursos poderosos, como os patterns. Esperamos ter um beta do Dart 3 na primavera que demonstre todas as novas funcionalidades.
