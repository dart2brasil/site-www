---
ia-translate: true
title: "Dart 2.17: produtividade e integração"
description: "Recursos de linguagem. Ferramentas de produtividade. Integração de plataforma mais profunda e mais ampla."
publishDate: 2022-05-11
author: mit-mit
image: images/1eJKM-4rFprGXyxNd5w2m-Q.webp
category: releases
layout: blog
---


Hoje, no [Google I/O](https://io.google/2022/products/flutter/), anunciamos um novo Dart SDK, versão 2.17. Esta versão se apoia nos nossos temas centrais de liderança em produtividade e portabilidade de plataforma. Ela traz novos recursos de linguagem: enums com suporte a membros, encaminhamento de parâmetros melhorado para superclasses e mais flexibilidade para parâmetros nomeados. Melhoramos as ferramentas com uma nova versão principal do `package:lints`, nosso suporte de ferramentas para verificar o código Dart contra as nossas melhores práticas, e uma atualização ampla da documentação da API das bibliotecas principais, com muitos exemplos de código. Para uma integração de plataforma melhor, temos novos templates para usar `dart:ffi` (interoperabilidade nativa com C) em plugins do Flutter, suporte experimental para processadores RISC-V e suporte para assinar executáveis do macOS e do Windows.

<DashImage src="images/1eJKM-4rFprGXyxNd5w2m-Q.webp" alt="Um gráfico estilizado com o texto 'Dart 2.17', representando a nova versão." />


## Novos recursos de linguagem para mais produtividade {:#new-language-features-for-improved-productivity}

Evoluímos constantemente a linguagem Dart para deixar você mais produtivo, tanto adicionando novos recursos quanto melhorando os existentes. O Dart 2.17 traz um suporte novo e importante para membros em enums, refina como você pode usar argumentos nomeados em construtores e torna o código para encaminhar parâmetros às superclasses muito menos verboso e repetitivo.

### Enums aprimorados com membros {:#enhanced-enums-with-members}

Enums são ótimos para representar um conjunto discreto de estados. Por exemplo, podemos modelar a água como `enum Water { frozen, lukewarm, boiling }`. Mas e se quisermos adicionar alguns métodos ao `enum`, por exemplo, para converter cada um dos estados em uma temperatura e permitir converter o `enum` para uma `String`? Talvez pudéssemos usar métodos de extensão para adicionar um método `waterToTemp()`, mas teríamos que tomar cuidado para mantê-lo sincronizado com o `enum`. Para a conversão para `String`, preferiríamos sobrescrever `toString()`, mas isso não era suportado.

Com o Dart 2.17, agora temos suporte geral a membros em enums. Isso significa que podemos adicionar campos que guardam estado, construtores que definem esse estado, métodos com funcionalidade e até sobrescrever membros existentes. Muitos de vocês pediam essa capacidade; ela foi a [terceira issue mais votada](https://github.com/dart-lang/language/issues?q=is%3Aissue+sort%3Areactions-%2B1-desc+) no rastreador da linguagem.

Para o nosso exemplo da água, podemos adicionar um campo `int` com a temperatura e um construtor padrão que recebe um `int`:

```
enum Water {
…
  final int tempInFahrenheit;
  const Water(this.tempInFahrenheit);
}
```


Para garantir que o construtor seja chamado quando o `enum` for criado, precisamos invocá-lo para cada valor do `enum`:

```
enum Water {
  frozen(32),
  lukewarm(100),
  boiling(212);
…
}
```


Para suportar a conversão para `String`, basta sobrescrever `toString`, que os `enums` herdam de `Object`:

```
[@override](http://twitter.com/override)
String toString() => "The $name water is $tempInFahrenheit F.";
```


E com isso você tem um `enum` completo, que pode ser instanciado facilmente e no qual você pode invocar métodos:

```
void main() {
  print(Water.frozen); // Prints “The frozen water is 32 F.”
}
```


Um exemplo completo dessas duas abordagens é ilustrado abaixo; achamos a versão do Dart 2.17 muito mais fácil de ler e manter.

<DashImage src="images/0hGKUdu4DT9v2IZGj.webp" alt="Trechos de código comparando enums antes e depois do Dart 2.17, mostrando melhor legibilidade." />


### Inicializadores de super {:#super-initializers}

Quando você tem uma hierarquia de herança de classes, um padrão comum é passar alguns parâmetros do construtor para o construtor da superclasse. Para isso, a subclasse precisa 1) listar cada parâmetro no próprio construtor, e 2) invocar o construtor da superclasse com esses parâmetros. Isso leva a código repetitivo: muita repetição, o que deixa o código mais difícil de ler e mais trabalhoso de manter.

Vários membros da comunidade Dart ajudaram a tornar isso possível. O usuário do GitHub @roy-sianez abriu uma [issue na linguagem](https://github.com/dart-lang/language/issues/1855) sobre isso há cerca de meio ano, sugerindo algo parecido com o que o usuário do GitHub [@apps](http://twitter.com/apps)-transround [havia sugerido antes](https://github.com/dart-lang/language/issues/493#issuecomment-879624528): que talvez pudéssemos resolver isso introduzindo uma nova construção para expressar que um parâmetro foi especificado na superclasse. Achamos essa ideia excelente, então ela foi adicionada ao Dart 2.17. Como você pode ver no exemplo a seguir, isso é especialmente relevante para o código de widgets do Flutter. De fato, quando aplicamos o novo recurso ao framework do Flutter, vimos uma redução total de [quase duas mil linhas de código](https://github.com/flutter/flutter/pull/100905/files)!

<DashImage src="images/0ypTj-6zzDBoqnpRL.webp" alt="Uma comparação de código demonstrando a nova sintaxe de parâmetros de construtor de super no Dart 2.17." />


### Argumentos nomeados em qualquer posição {:#named-args-everywhere}

Por último, refinamos como os argumentos nomeados funcionam quando você invoca um método. Antes, eles tinham que aparecer por último na lista de argumentos do método. Isso era incômodo em casos em que você preferiria colocar um argumento posicional por último para deixar o código mais legível. Por exemplo, veja a seguinte invocação do construtor `List&lt;T&gt;.generate`: antes, o argumento `growable` tinha que ficar por último, o que facilitava passar despercebido abaixo do grande argumento posicional que contém o próprio gerador. Agora você pode ordenar os argumentos como preferir, colocando os argumentos nomeados pequenos primeiro e o gerador por último.

<DashImage src="images/0gMf1J56vEgV96z1l.webp" alt="Um trecho de código mostrando argumentos nomeados em qualquer posição da lista de argumentos no Dart 2.17." />


Para mais exemplos desses três recursos em ação, veja nossos exemplos atualizados para [enums](https://github.com/dart-lang/samples/blob/master/enhanced_enums/lib/members.dart), [inicializadores de super](https://github.com/dart-lang/samples/blob/master/parameters/lib/super_initalizer.dart) e [parâmetros nomeados](https://github.com/dart-lang/samples/blob/master/parameters/lib/named_parameters.dart).

## Ferramentas de produtividade {:#productivity-tools}

Continuando o tema de produtividade, temos várias melhorias nas nossas ferramentas principais.

No Dart 2.14, introduzimos o `package:lints`, que funciona com o analyzer do Dart para ajudar você a escrever código Dart que previne erros e usa um estilo canônico, o que possibilita revisões de código mais eficientes. Desde então, várias novas lints foram disponibilizadas no analyzer, que avaliamos com cuidado e, a partir delas, selecionamos [dez novas lints](https://github.com/dart-lang/lints/blob/main/CHANGELOG.md#200) para todo código Dart, e [duas novas lints](https://github.com/flutter/packages/blob/master/packages/flutter_lints/CHANGELOG.md#200) específicas para código Flutter. Elas incluem lints para garantir que seus imports estejam incluídos no arquivo pubspec, evitar o uso incorreto de verificações de null em parâmetros de tipo e garantir um estilo consistente para as propriedades de filhos. Você pode atualizar para as novas lints com um comando simples:

* Para pacotes Dart:
`dart pub upgrade —-major-versions lints`

* Para pacotes Flutter:
`flutter pub upgrade —-major-versions flutter_lints`

SecureSockets são comumente usados para habilitar sockets TCP protegidos com TLS e SSL. Antes do Dart 2.17, depurar esses sockets durante o desenvolvimento era complicado, pois não havia como inspecionar o tráfego de dados seguro. Agora adicionamos suporte para especificar um arquivo `keyLog`. Quando ele é especificado, uma linha de texto no [NSS Key Log Format](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format) é adicionada ao arquivo sempre que novas chaves TLS são trocadas com o servidor. Isso permite que ferramentas de análise de tráfego de rede (como o [Wireshark](https://gitlab.com/wireshark/wireshark/-/wikis/TLS#tls-decryption)) descriptografem o conteúdo enviado pelo socket. Para detalhes, veja a documentação da API de [`SecureSocket.connect()`](https://api.dart.dev/stable/2.17.0/dart-io/SecureSocket/connect.html).

A documentação da API gerada pela ferramenta `dart doc` é um recurso essencial para a maioria dos desenvolvedores Dart que estão aprendendo APIs novas. Embora as nossas [APIs das bibliotecas principais](https://dart.dev/guides/libraries) já tivessem descrições textuais ricas há muito tempo, muitos desenvolvedores nos disseram que preferem aprender APIs lendo código de exemplo que usa a API. Com o Dart 2.17, refizemos por completo todas as bibliotecas principais, adicionando código de exemplo às 200 páginas mais visualizadas, que agora têm exemplos de código abrangentes. Como exemplo, compare a documentação do dart:convert no [Dart 2.16](https://api.dart.dev/stable/2.16.2/dart-convert/dart-convert-library.html) com a página atualizada no [Dart 2.17](https://api.dart.dev/stable/2.17.0/dart-convert/dart-convert-library.html); esperamos que isso deixe a documentação muito mais fácil de consumir.

Ganhos de produtividade vêm não só quando adicionamos novos recursos à plataforma, mas também quando limpamos nossa base e removemos recursos que não são mais usados. Isso ajuda a manter a superfície da linguagem pequena, o que é essencial principalmente para novos desenvolvedores. Nesse sentido, removemos [231 linhas de código descontinuado](https://dart-review.googlesource.com/c/sdk/+/236840) da biblioteca `dart:io`. Se você ainda usa essas APIs descontinuadas, pode atualizar para as substitutas com o [`dart fix`](https://dart.dev/tools/dart-fix). Também continuamos o esforço de remover [ferramentas de linha de comando do Dart descontinuadas](https://github.com/dart-lang/sdk/issues/46100), desta vez removendo a ferramenta `dartdoc` (use `dart doc` no lugar) e a ferramenta `pub` (use `dart pub` ou `flutter pub`).

## Ampliando a integração e o suporte a plataformas {:#broadening-our-platform-integration-and-support}

Um segundo tema central é a integração e o suporte a plataformas. Dart é uma linguagem verdadeiramente multiplataforma. Embora já suportemos uma [ampla gama de plataformas](https://dart.dev/overview#platform), estamos sempre evoluindo para garantir que você consiga integrar profundamente cada plataforma suportada, e também para dar suporte a plataformas emergentes.

O Dart FFI, nosso mecanismo central de [interoperabilidade com código C/nativo](https://dart.dev/guides/libraries/c-interop), é uma forma popular de integrar código Dart com código nativo já existente. No Flutter, isso pode ser uma ótima maneira de criar [plugins](https://docs.flutter.dev/development/packages-and-plugins/developing-packages) que usam APIs nativas da plataforma hospedeira (como as APIs win32 do Windows). No Dart 2.17 e no Flutter 3, adicionamos templates à ferramenta `flutter` para que agora você consiga criar facilmente plugins FFI com uma API Dart apoiada por chamadas de `dart:ffi` para código nativo. Para detalhes, veja a página atualizada [desenvolvendo pacotes e plugins](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#dart-only-platform-implementations) no flutter.dev.

Para permitir o uso de FFI em plataformas que têm tipos específicos da sua ABI ([application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface)), o FFI agora suporta tipos específicos de ABI. Por exemplo, agora você pode usar [`Long`](https://api.dart.dev/stable/2.17.0/dart-ffi/Long-class.html) (`long` em C) para representar corretamente um inteiro longo com um tamanho específico da ABI, que pode ter 32 ou 64 bits, dependendo da arquitetura da CPU. Para a lista completa de tipos suportados, veja a lista de “Implementers’’ na página da API de [`AbiSpecificInteger`](https://api.dart.dev/stable/2.17.0/dart-ffi/AbiSpecificInteger-class.html).

Ao integrar profundamente com plataformas nativas usando o Dart FFI, às vezes você precisa alinhar a liberação de memória ou de outros recursos (portas, arquivos e assim por diante) alocados pelo Dart e pelo código nativo. Historicamente, isso era muito difícil, já que o Dart é uma linguagem com coleta de lixo, que cuida automaticamente da liberação. O Dart 2.17 resolve isso introduzindo o conceito de Finalizer, que inclui uma interface marcadora `Finalizable` para “marcar” objetos que não devem ser finalizados ou descartados cedo demais, e uma classe `NativeFinalizer` que pode ser anexada a um objeto Dart para fornecer um callback executado quando o objeto está prestes a ser coletado pelo garbage collector. Juntos, eles permitem executar código de limpeza tanto no código nativo quanto no Dart. Para detalhes, veja a descrição e o exemplo na documentação da API de [`NativeFinalizer`](https://api.dart.dev/stable/2.17.0/dart-ffi/NativeFinalizer-class.html), ou a documentação de [`WeakReferences`](https://api.dart.dev/stable/2.17.0/dart-core/WeakReference-class.html) e [`Finalizer`](https://api.dart.dev/stable/2.17.0/dart-core/Finalizer-class.html), que oferecem suporte semelhante em código Dart comum.

Nosso suporte à compilação de Dart para código nativo é um facilitador central para que apps Flutter tenham ótimo desempenho na inicialização e renderização rápida. Um segundo caso de uso é a capacidade de compilar Dart em executáveis com [`dart compile`](https://dart.dev/tools/dart-compile). Esses executáveis podem rodar sozinhos em qualquer máquina, sem precisar que o Dart SDK esteja instalado. Outra nova capacidade do Dart 2.17 é o suporte à [assinatura de executáveis](https://dart.dev/tools/dart-compile#exe), o que possibilita a implantação no Windows e no macOS, onde a assinatura costuma ser exigida.

Também continuamos ampliando o conjunto de plataformas suportadas, mantendo-nos na vanguarda das novas plataformas emergentes. [RISC-V](https://riscv.org/about/) é um novo conjunto de instruções inovador para processadores. A RISC-V International, uma organização global sem fins lucrativos, é dona da especificação RISC-V, tornando o conjunto de instruções livre e aberto. Esta ainda é uma plataforma emergente, mas estamos animados com o potencial dela, então nossa versão Linux `2.17.0–266.1.beta` (ou posterior, do nosso [canal beta](https://dart.dev/get-dart/archive#beta-channel)) inclui suporte experimental a ela. Adoraríamos ouvir seu feedback, então, por favor, [abra uma issue](https://github.com/dart-lang/sdk/issues) ou [poste](https://groups.google.com/a/dartlang.org/g/misc) sobre a sua experiência!

## Comece com o Dart 2.17! {:#get-started-with-dart-2-17}

Esperamos que o lançamento de hoje do Dart 2.17 empolgue você, aumente sua produtividade e permita ainda mais integração de plataforma para os seus apps. Para começar, você pode baixar diretamente a versão [Dart 2.17](https://dart.dev/get-dart), ou obtê-la incorporada ao SDK do [Flutter 3](https://docs.flutter.dev/get-started/install) lançado hoje.

Também convidamos você a conferir [o novo conteúdo](https://io.google/2022/products/flutter/) que disponibilizamos para o Google I/O!
