---
ia-translate: true
title: "Apresentando o Dart 3 alpha"
description: "Conheça a versão mais produtiva, portátil e acessível do Dart até hoje. Já disponível para testes e experimentação antecipados."
publishDate: 2023-01-25
author: mit-mit
image: images/0evGHZJd_7cahb08X.webp
category: announcements
layout: blog
---


Em dezembro, demos um vislumbre do futuro com nosso primeiro post sobre o Dart 3. Hoje, ao vivo do evento para desenvolvedores [Flutter Forward](https://flutter.dev/events/flutter-forward), em Nairóbi, no Quênia, compartilhamos a visão mais ampla para a próxima grande versão do Dart e nossa primeira versão de prévia, o **Dart 3 alpha**.

<DashImage src="images/0evGHZJd_7cahb08X.webp" alt="Banner de lançamento do Dart 3 alpha com o logo do Dart." />


Nossa missão para o Dart é criar a melhor linguagem de programação para construir apps de alta qualidade em qualquer plataforma. O Dart é **acessível**: fácil de aprender, evita complexidade desnecessária e é internamente consistente. O Dart é **produtivo**: desenvolvedores de apps vivem sob pressão constante para entregar apps com requisitos que mudam o tempo todo, em menos tempo, sem abrir mão da qualidade e do acabamento. Por isso, construímos o Dart com um foco profundo em permitir desenvolvimento rápido, iteração veloz e alta qualidade. E o Dart é **portátil**, abrangendo o maior conjunto de plataformas, para que você possa implantar apps nos dispositivos de hoje e de amanhã.

Trabalhamos para estabelecer essas qualidades ao longo de muitos anos. Com o Dart 3, pretendemos dar mais um grande passo, refinando e expandindo a acessibilidade, a produtividade e a portabilidade de maneiras significativas.

O Dart 3 é uma nova versão *major*. Em parte para sinalizar o grande avanço em funcionalidades, e em parte porque é uma *versão com quebras de compatibilidade* em termos de versionamento semântico: estamos mudando o sistema de tipos para suportar *somente* **null safety sound** (no Dart 2.12 e posteriores, isso era *opcional*) e fizemos as mudanças incompatíveis correspondentes nas bibliotecas principais do Dart. Vamos aos detalhes!

## Melhorias de produtividade no Dart 3 {:#dart-3-productivity-enhancements}

### Uma linguagem Dart mais expressiva: records, patterns e controles de acesso {:#a-more-expressive-dart-language-records-patterns-and-access-controls}

Evoluímos a linguagem Dart em um ritmo acelerado nos últimos anos, [adicionando 23 novos recursos](https://dart.dev/guides/language/evolution) desde a 2.0. No Dart 3, esperamos adicionar dois grandes recursos novos, records e patterns, com o objetivo de tornar o trabalho com dados estruturados mais produtivo.

Records permitem criar, de forma eficiente e concisa, valores compostos anônimos a partir de quaisquer dados existentes, sem a sobrecarga conceitual de precisar declarar uma classe para guardar os valores. Com records, você pode criar facilmente novas estruturas de dados que combinam dados existentes. Por exemplo, para retornar um par de valores:

```dart
(double x, double y) geoLocation(String name) {
  if (name == 'Nairobi') {
    return (-1.2921, 36.8219);
  } else {
    ...
  }
}
```

Enquanto records permitem combinar dados, patterns podem desestruturar dados compostos em seus constituintes. Por exemplo, para desestruturar o valor de retorno de `geoLocation` acima (um record formado por um par de ints) em duas variáveis `int` individuais, `lat` e `long`, você pode usar uma declaração de pattern assim:

```dart
void main(List<String> arguments) {
  final (lat, long) = geoLocation('Nairobi');
  print('Current location: $lat, $long');
}
```

Patterns são totalmente seguros em relação a tipos e são verificados durante o desenvolvimento.

Você também pode fazer pattern matching com o tipo dos valores, por exemplo, a partir de uma hierarquia de classes. Um `switch` pode usar patterns que correspondem ao tipo e aos campos individuais de cada tipo, como no corpo de `calculateArea` aqui:

```dart
sealed class Shape {
}

class Square implements Shape {
  final double length;
  Square(this.length);
  
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => math.pi * r * r
};
```

No geral, estamos adicionando uma grande seleção de patterns que, combinados, tornam o Dart muito mais expressivo para dados estruturados.

Junto com os patterns, também estamos adicionando [controles de capacidade](https://github.com/dart-lang/language/blob/master/accepted/future-releases/class-modifiers/feature-specification.md) às classes, por meio de vários novos modificadores:

* **`interface class`**: não pode ser estendida.

* **`base class`**: desabilita a interface implícita, então não pode ser implementada.

* **`final class`**: não pode ser estendida, implementada nem usada como mixin (fora da biblioteca atual).

* **`sealed class`**: igual a abstract + final, e o tipo é considerado a raiz de uma família de tipos selada para verificação de exaustividade. Como exemplo, tome a hierarquia de classes `Shape` acima. Em statements switch sobre o tipo `Shape` (como na função `calculateArea`), o analyzer vai disparar erros se o switch não tratar todos os subtipos possíveis do tipo selado.

* **`mixin class`:** uma classe que pode ser usada como mixin.

Cada novo recurso adiciona complexidade à linguagem. Para garantir que o Dart continue acessível, as classes continuam totalmente permissivas por padrão, como hoje, com a pequena exceção de que classes destinadas a serem usadas como mixins agora devem usar a palavra-chave `mixin`.

### Integração produtiva com a plataforma por meio de interop direta com bibliotecas da plataforma {:#productive-platform-integration-via-direct-platform-library-interop}

Estamos trabalhando para expandir a interoperabilidade da linguagem Dart para **chamar bibliotecas da plataforma diretamente a partir do Dart**. Nas plataformas Apple, estamos construindo sobre nosso trabalho com [FFI para interoperabilidade com C](https://dart.dev/guides/libraries/c-interop), que permite chamar, a partir do Dart, qualquer módulo C que siga a convenção de chamada do C. Até agora, isso dava suporte a linguagens como C, Go e Rust. Agora, estamos adicionando suporte a Swift e Objective-C em [iOS/macOS](https://dart.dev/guides/libraries/objective-c-interop). No Android, você pode chamar bibliotecas Jetpack escritas em Kotlin e bibliotecas Android escritas em Java, usando FFI e a Java Native Interface (JNI) do Android.

Com a ajuda de novas ferramentas, o Dart pode criar automaticamente bindings que têm uma interface em Dart e, por trás dela, código de interop entre linguagens baseado nos arquivos de header/interface do código original em C/ObjC/Swift/Java/Kotlin. Para uma demonstração de como usar isso para chamar a [Core Motion API](https://developer.apple.com/documentation/coremotion) da Apple e a [HealthConnect API](https://developer.android.com/guide/health-and-fitness/health-connect) do Android, confira [o app de exemplo](https://github.com/flutter/samples/blob/main/experimental/pedometer/README.md).

Esses novos mecanismos de interop são atualmente experimentais, mas esperamos que atinjam pelo menos qualidade beta no Dart 3.0 estável. Feedbacks são bem-vindos nos rastreadores de issues para [Java/Kotlin](https://github.com/dart-lang/jnigen) ou [C/ObjectiveC/Swift](https://github.com/dart-lang/ffigen). Por fim, também estamos trabalhando em uma interop melhorada entre Dart e JavaScript; teremos mais novidades sobre isso em um futuro post no blog.

## Avanços em portabilidade {:#portability-advancements}

O Dart já oferece suporte a uma ampla gama de plataformas-alvo com nossos compiladores nativos e para web. Na web, atualmente compilamos para JavaScript. Em dispositivos nativos, oferecemos suporte às arquiteturas Intel de 32 e 64 bits e ARM de 32 e 64 bits. Há vários dispositivos e padrões emergentes com os quais estamos trabalhando para adicionar suporte, para garantir que o Dart esteja pronto para os dispositivos do futuro.

Para a web, estamos trabalhando no suporte a [WebAssembly](https://webassembly.org/) (Wasm), que vem amadurecendo como um formato de instruções binárias neutro em relação à plataforma, em [todos os navegadores modernos](https://caniuse.com/wasm). Nossa esperança é que o Wasm permita que apps web em Dart iniciem tão rápido quanto apps nativos.

Outra arquitetura de plataforma que vem despertando interesse é a [RISC-V](https://en.wikipedia.org/wiki/RISC-V), um conjunto de instruções (ISA) aberto, projetado para uso amplo. A equipe do Android apresentou recentemente uma palestra sobre [o trabalho deles para suportar RISC-V](https://www.youtube.com/watch?v=70O_RmTWP58), e achamos que isso terá ampla aplicabilidade também em dispositivos embarcados. O suporte a RISC-V está disponível para prévia no Dart 3 alpha.

Por fim, estamos expandindo nosso suporte atual a dispositivos ARM para abranger também o suporte a ARM64 no Windows.

## Mudanças incompatíveis do Dart 3 {:#dart-3-breaking-changes}

Com os novos recursos do Dart 3 apresentados, vamos às mudanças incompatíveis que estamos fazendo em nome de um Dart mais consistente e acessível.

### Sistema de tipos do Dart 3: null safety 100% sound {:#dart-3-type-system-100-sound-null-safety}

Introduzimos a null safety sound no [Dart 2.12](/blog/announcing-dart-2-12) em 2021. Em um sistema de tipos sound, você pode confiar nos tipos, o que significa que uma variável *nunca* é nula quando os tipos dizem que ela não é. Isso aumenta a produtividade ao detectar problemas durante o desenvolvimento, e não em produção, e permite que os compiladores do Dart gerem [código menor e mais otimizado](/blog/dart-and-the-performance-benefits-of-sound-types). Como [discutimos em dezembro](/blog/the-road-to-dart-3-a-fully-sound-null-safe-language), o Dart é único ao introduzir null safety 100% sound em uma linguagem já existente.

Desde o Dart 2.12, a null safety era uma opção de configuração que podia estar *ligada* ou *desligada*. **No Dart 3, todo o código roda com a null safety sound *ligada***. Não é mais possível rodar apps sem null safety nem em modo misto com null safety parcial.

Sabemos que descontinuar a execução sem null safety pode trazer problemas para apps e pacotes existentes. No entanto, sentimos que agora é o momento certo para avançar com essa mudança. Ter um único sistema de tipos, em que a null safety está sempre ligada, reduz a sobrecarga e a complexidade. Sempre que os desenvolvedores lerem um trecho de código do Dart 3, podem ter certeza de que todas as variáveis são não nulas por padrão. Do lado da implementação, os compiladores e runtimes do Dart podem focar em suportar uma única forma de executar código Dart, o que reduz o custo e a complexidade de adicionar novos recursos.

O ecossistema do Dart demonstrou forte dedicação e disposição para migrar o código existente para a null safety. Até hoje,

* 100% dos 250 principais pacotes do pub.dev suportam null safety

* 98% dos 1000 principais pacotes do pub.dev suportam null safety

* Apenas 14% das sessões de `flutter run` ainda rodam sem null safety

Obrigado ao ecossistema pelo esforço de migração!

### Limpeza das bibliotecas principais e da linguagem do Dart 3 {:#cleanup-of-dart-3-core-libraries-and-language}

Conforme a linguagem Dart e o sistema de tipos evoluíram, várias APIs das nossas bibliotecas principais ficaram redundantes ou subótimas. Para garantir que o Dart continue acessível, fizemos uma série de mudanças incompatíveis para remover APIs desnecessárias. Para detalhes, veja as issues no GitHub, [#34233](https://github.com/dart-lang/sdk/issues/34233) e [#49529](https://github.com/dart-lang/sdk/issues/49529). Também removemos uma sintaxe histórica para valores padrão de parâmetros ([#2357](https://github.com/dart-lang/language/issues/2357)).

Com o Dart 3 alpha concluído, nossa atenção agora se volta para o Dart 3 beta. Lá, esperamos refinar ainda mais as bibliotecas principais do Dart, adicionando várias novas APIs. Você pode dar sua opinião sobre isso na [issue de feedback](https://github.com/dart-lang/sdk/issues/49928).

### Preparando seu código para o Dart 3 estável {:#preparing-your-code-for-dart-3-stable}

Em geral, acreditamos que a maior parte do código que já migrou para usar null safety, com o Dart 2.12 ou posterior, vai funcionar com o Dart 3. No entanto, um pequeno subconjunto de pacotes e apps pode ser afetado pelas mudanças incompatíveis discutidas acima. Então, para dar tempo para você se preparar para a versão estável do Dart 3, que chega ainda este ano, não planejamos mais nenhuma mudança incompatível na linguagem e nas bibliotecas principais após o Dart 3 alpha.

Para aproveitar o código que já migrou para usar null safety, implementamos compatibilidade retroativa no Dart 3, que permite que pacotes migrados sejam resolvidos com `pub get` no Dart 3, apesar de terem uma restrição de versão do SDK como `&gt;=2.12 &lt;3.0.0`, desde que não dependam de outras APIs descontinuadas das bibliotecas principais ou de recursos da linguagem. Para mais detalhes, incluindo como testar com um [Dart 3 alpha SDK](https://dart.dev/get-dart/archive#dart-3-alpha) instalado localmente, veja nossa [documentação sobre null safety no Dart 3](https://dart.dev/null-safety#dart-3-and-null-safety).

Para os pacotes publicados no repositório [pub.dev](https://pub.dev/), executamos a análise com o Dart 3 alpha e marcamos com a tag **“Dart 3 ready”** os que passaram. Isso indica que o pacote provavelmente vai funcionar com o Dart 3 quando ele for lançado na versão estável, ainda este ano.

<DashImage src="images/0dB-NsWj2y3JljZZh.webp" alt="Um selo “Dart 3 ready” exibido em uma página de pacote." />


### Limpeza das ferramentas do Dart 3 {:#dart-3-tools-cleanup}

Antes do Dart 3, fizemos [várias mudanças](https://github.com/dart-lang/sdk/issues/46100) para reunir todas as nossas ferramentas de desenvolvimento de terminal em uma única ferramenta unificada, o `dart`, o que tornou o Dart muito mais acessível para novos desenvolvedores. Estamos planejando [mudanças adicionais nas ferramentas](https://github.com/dart-lang/sdk/issues/50707) nos próximos meses, para fazer mais limpeza. Esperamos que essas mudanças não sejam muito disruptivas, mas alguma quebra pequena deve ser esperada nas ferramentas no Dart 3 beta.

## Próximos passos {:#next-steps}

O Dart 3 alpha [já está disponível hoje](https://dart.dev/get-dart/archive#dart-3-alpha) no canal dev do Dart e no canal master do Flutter. Convidamos você a experimentar, seja para testar os novos recursos da linguagem, como records e patterns, seja para experimentar nossa nova interop de acesso direto a plataformas, ou para testar seus apps e pacotes quanto à [compatibilidade com o Dart 3](https://dart.dev/null-safety#dart-3-and-null-safety).

Continuaremos refinando o Dart 3 nos próximos meses e esperamos ter uma versão estável completa do Dart 3 ainda este ano. Observe que a maioria dos recursos ainda está em desenvolvimento e, portanto, sujeita a mudanças até a versão estável. Até lá, divirta-se com o seu código Dart!
