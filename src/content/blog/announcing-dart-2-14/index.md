---
ia-translate: true
title: "Anunciando o Dart 2.14"
description: "Suporte ao Apple Silicon e mais produtividade com lints padrão, ferramentas melhores e novos recursos de linguagem"
publishDate: 2021-09-08
author: mit-mit
image: images/1qlsMfajTUkBw1APUpjcCZg.webp
category: releases
layout: blog
---


Hoje lançamos a versão 2.14 do SDK do Dart, a próxima etapa da nossa jornada contínua para criar a melhor plataforma para construir aplicações, por meio de uma combinação única de portabilidade, produtividade e robustez. Desta vez, temos um suporte melhor ao Apple Silicon e uma série de melhorias de produtividade, como os lints padrão, que capturam erros enquanto você escreve o código por meio da análise de estilo, uma ferramenta pub mais rápida, uma formatação melhor de código com cascades e alguns pequenos recursos de linguagem.

<DashImage src="images/1qlsMfajTUkBw1APUpjcCZg.webp" alt="Dart 2.14 release banner highlighting Apple Silicon, shared lints, better tools, and language updates." />


## Suporte ao Apple Silicon no SDK do Dart {:#apple-silicon-support-in-the-dart-sdk}

Desde que a Apple anunciou seus novos processadores [Apple Silicon](https://support.apple.com/en-us/HT211814) no fim de 2020, trabalhamos na atualização do SDK do Dart para adicionar suporte à execução nativa nos novos processadores. As mudanças necessárias estão disponíveis no canal dev há um tempo, no canal beta no último mês e, a partir do Dart 2.14.1, já estão no canal stable do Dart. Ao [baixar](https://dart.dev/get-dart) um SDK para macOS, escolha a opção ARM64. Observe que o SDK do Dart incluído no SDK do Flutter ainda não tem essas melhorias.

O suporte inclui tanto a execução do próprio SDK/VM do Dart no Apple Silicon quanto a compilação de executáveis (com o [`dart compile`](https://dart.dev/tools/dart-compile#exe)) que rodam no Apple Silicon. As ferramentas de linha de comando do Dart agora iniciam muito mais rápido, já que usam o suporte nativo ao Apple Silicon.

## Lints padrão compartilhados entre Dart e Flutter {:#standard-lints-shared-for-dart-and-flutter}

Desenvolvedores costumam preferir que o código siga um certo estilo. Muitas dessas regras não são apenas preferências estilísticas (como a conhecida discussão sobre tabs versus espaços), mas cobrem estilos de código que provavelmente levam a erros ou introduzem bugs. Como exemplo, o guia de estilo do Dart exige o uso de chaves em todas as estruturas de controle de fluxo, como os blocos if-else. Isso evita o clássico problema do [dangling else](https://en.wikipedia.org/wiki/Dangling_else), em que há ambiguidade sobre como interpretar vários blocos if-else aninhados. Outro exemplo é a inferência de tipos. Embora seja adequado usar inferência de tipos ao declarar variáveis com valores iniciais, é importante especificar o tipo ao [declarar variáveis não inicializadas](https://dart-lang.github.io/linter/lints/prefer_typing_uninitialized_variables.html), para garantir a segurança de tipos.

Uma opção para impor um bom estilo de código é ter alguma forma de verificação humana, muitas vezes por meio de revisão de código. No entanto, costuma ser muito mais eficaz impor as regras por meio de análise estática que roda enquanto você escreve o código.

No Dart, essa análise estática é altamente [configurável](https://dart.dev/guides/language/analysis-options), e temos [centenas de regras de estilo](https://dart.dev/tools/linter-rules) (também conhecidas como *lints*). Com tantas opções, pode ser um pouco avassalador escolher quais regras ativar. A equipe do Dart mantém um [guia de estilo do Dart](https://dart.dev/guides/language/effective-dart/style), que descreve o que acreditamos ser a melhor forma de escrever e estilizar código Dart, mas, historicamente, não tínhamos um conjunto oficial de regras de linter que correspondesse ao guia de estilo.

Muitos desenvolvedores, assim como o motor de [pontuação](https://pub.dev/help/scoring) do site pub.dev, usavam o conjunto de regras de lint [pedantic](https://github.com/google/pedantic). No entanto, o pedantic tem origem no guia de estilo interno do Google para Dart, que, por razões históricas, difere do guia de estilo geral do Dart. Além disso, o framework Flutter nunca usou o conjunto pedantic e, em vez disso, tinha seu próprio conjunto canônico de regras.

Isso pode soar um pouco bagunçado, e de fato era. Mas, com os lançamentos de hoje, temos o prazer de anunciar um conjunto totalmente novo de coleções de lints que implementam o guia de estilo, e que os SDKs do Dart e do Flutter foram atualizados para usar esses conjuntos de regras por padrão em novos projetos. Os conjuntos de regras são:

* [`package:lints/core.yaml`:](https://github.com/dart-lang/lints/blob/main/lib/core.yaml) ****As principais regras do guia de estilo do Dart que acreditamos que todo código Dart deve seguir. O motor de pontuação do pub.dev foi atualizado para usar estas regras em vez do pedantic.

* [`package:lints/recommended.yaml`](https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml)**:** As regras core, mais regras recomendadas adicionais. Este conjunto é recomendado para todo código Dart em geral.

* [`package:flutter_lints/flutter.yaml`](https://github.com/flutter/packages/blob/master/packages/flutter_lints/lib/flutter.yaml): As regras core e recomendadas, mais regras recomendadas adicionais específicas do Flutter. Este conjunto é recomendado para todo código Flutter.

Se você tem projetos existentes, recomendamos fortemente que faça a atualização para esses novos conjuntos de regras. Migrar do pedantic leva [apenas alguns passos](https://github.com/dart-lang/lints#migrating-from-packagepedantic).

## Formatador do Dart e cascades {:#dart-formatter-and-cascades}

Fizemos várias otimizações na forma como o formatador do Dart formata código com [cascades](https://dart.dev/guides/language/language-tour#cascade-notation). Antes, o formatador, em alguns casos, produzia uma formatação confusa. Por exemplo, em que objeto o `doIt()` é chamado neste exemplo?

```
var result = errorState ? foo : bad..doIt();
```


Pode parecer que ele é sempre chamado em `bad`, mas, na verdade, a cascade se aplica a toda a expressão `?`, então a cascade é chamada no resultado dessa expressão, e não apenas na cláusula falsa. O novo formatador deixa isso claro:

```
var result = errorState ? foo : bad
  ..doIt();
```


Outras mudanças dizem respeito a como linhas com várias cascades são formatadas e a quanto as cascades, em geral, são indentadas. Também aumentamos muito a velocidade de formatação de código que contém cascades; no código Dart gerado para [protocol buffers](https://developers.google.com/protocol-buffers/docs/reference/dart-generated), estamos vendo uma melhoria de até 10x na velocidade de formatação.

Para todos os detalhes, veja a [issue de acompanhamento](https://github.com/dart-lang/dart_style/pull/1033).

## Suporte do pub para ignorar arquivos {:#pub-support-for-ignoring-files}

Atualmente, ao [publicar](https://dart.dev/tools/pub/publishing) um pacote no repositório da comunidade [pub.dev](https://pub.dev), o pub pega todos os arquivos dessa pasta, com algumas exceções, ignorando arquivos ocultos (aqueles que começam com ponto: `.`) e os arquivos listados no `.gitignore`. Vários desenvolvedores pediram a capacidade de controlar quais arquivos são ignorados além da lista do `.gitignore`. Por exemplo, você pode ter algumas ferramentas internas de desenvolvimento em uma pasta `tool/` que usa para *manter* o seu pacote, mas que não são relevantes para quem *usa* o seu pacote.

O comando pub atualizado no Dart 2.14 oferece suporte a um novo arquivo `.pubignore`, em que você pode listar os arquivos que não quer enviar ao pub.dev. Esse arquivo usa o mesmo formato dos arquivos `.gitignore`. Para detalhes, veja a [documentação de publicação de pacotes](https://dart.dev/tools/pub/publishing#what-files-are-published).

## Desempenho do pub e do `dart test` {:#pub-and-dart-test-performance}

Embora o pub seja talvez mais usado para gerenciar dependências de código, ele também tem uma segunda utilidade importante: alimentar ferramentas. Um exemplo é a ferramenta de testes do Dart, exposta pelo comando `dart test`. Esse comando é basicamente um wrapper de `command pub run test:test`, que executa o entrypoint `test` do [`package:test`](https://github.com/dart-lang/test/blob/master/pkgs/test/bin/test.dart). Antes de invocar esse entrypoint, o pub primeiro compila-o para código nativo, que pode rodar mais rápido.

Antes do Dart 2.14, qualquer mudança no pubspec (incluindo as não relacionadas ao `package:test`) invalidava essa build do test, e você via um monte de saída como esta, contendo "Precompiling executable":

```
$ dart test
Precompiling executable... (11.6s)
Precompiled test:test.
00:01 +1: All tests passed!
```


No Dart 2.14, o pub é muito mais inteligente sobre quando invalidar a etapa de build, então a build acontece apenas quando a versão muda. Além disso, melhoramos a forma como realizamos essa etapa de build usando paralelização, então a etapa em si termina muito mais rápido. Vimos que ela levou metade do tempo em alguns pacotes que testamos.

## Novos recursos de linguagem {:#new-language-features}

O Dart 2.14 também traz vários pequenos recursos de linguagem. Desta vez, focamos em melhorias mais específicas, talvez de utilidade mais restrita, mas que habilitam casos de uso mais especializados que antes não eram suportados.

Primeiro, adicionamos um novo operador de [triplo deslocamento](https://github.com/dart-lang/language/issues/120) (`&gt;&gt;&gt;`). Ele é semelhante ao operador de deslocamento existente (`&gt;&gt;`), mas, enquanto `&gt;&gt;` faz um deslocamento aritmético, `&gt;&gt;&gt;` faz um deslocamento lógico, ou sem sinal, em que bits zero são deslocados para o bit mais significativo, independentemente de o número deslocado ser positivo ou negativo.

Também removemos uma antiga restrição sobre argumentos de tipo, que impedia o uso de tipos de função genéricos como argumento de tipo. Todos os exemplos a seguir eram inválidos antes do 2.14, mas agora são permitidos:

```
late List<T Function<T>(T)> idFunctions;
var callback = [<T>(T value) => value];
late S Function<S extends T Function<T>(T)>(S) f;
```


Por fim, fizemos um pequeno ajuste nos tipos de anotações. (Anotações como [`@Deprecated`](https://api.dart.dev/stable/2.13.4/dart-core/Deprecated-class.html) são comumente usadas em código Dart para capturar metadados.) Antes, as anotações não podiam receber argumentos de tipo, então código como `@TypeHelper&lt;int&gt;(42, "The meaning")` não era permitido. Essa restrição foi removida.

## Mudanças em pacotes e na biblioteca core {:#package-and-core-library-changes}

Fizemos várias melhorias em pacotes e bibliotecas core do Dart, incluindo:

* `dart:core`: adicionados os métodos estáticos `hash`, `hashAll` e `hashAllUnordered` à classe `Object`. Eles podem ser usados para combinar os códigos hash de vários objetos de forma consistente ([exemplo de hashAll](https://api.dart.dev/stable/2.14.0/dart-core/Object/hashAll.html)).

* `dart:core`: a classe nativa `DateTime` agora lida melhor com o horário local em torno de mudanças de horário de verão que não são exatamente de uma hora. Por exemplo, a Ilha Lord Howe, na Austrália, que usa um deslocamento de 30 minutos.

* [`package:ffi`](https://pub.dev/packages/ffi): adicionado suporte ao gerenciamento de memória usando um alocador de [arena](https://pub.dev/documentation/ffi/latest/ffi/Arena-class.html) ([exemplo](https://github.com/dart-lang/sdk/blob/master/samples/ffi/resource_management/arena_sample.dart)). Arenas são uma forma de [gerenciamento de memória baseado em regiões](https://en.wikipedia.org/wiki/Region-based_memory_management), em que os recursos são liberados automaticamente quando a arena/região é encerrada.

* [`package:ffigen`](https://pub.dev/packages/ffigen): agora suporta a geração de typedefs do Dart a partir de typedefs do C.

## Mudanças incompatíveis {:#breaking-changes}

O Dart 2.14 também traz várias mudanças incompatíveis menores, [anunciadas anteriormente](https://github.com/dart-lang/sdk/blob/master/docs/process/breaking-changes.md). Espera-se que essas mudanças afetem apenas alguns casos de uso especializados.

### [#46545](https://github.com/dart-lang/sdk/issues/46545): Remoção do suporte ao ECMAScript5 {:#46545-removal-of-support-for-ecmascript5}

[Todos os navegadores modernos](https://caniuse.com/es6) suportam as versões recentes do ECMAScript, então, dois anos atrás, [anunciamos](https://groups.google.com/a/dartlang.org/g/announce/c/x7eDinVT6fM/m/ZSFl2a9tEAAJ?pli=1) um plano para depreciar o suporte ao ECMAScript 5 (ES5). Isso nos permite aproveitar as melhorias do ECMAScript mais recente e gerar saídas menores. No Dart 2.14, esse trabalho está concluído, e os compiladores Dart para web não suportam mais o ES5. Como resultado, navegadores mais antigos, como o IE11, não são mais suportados.

### [#46100](https://github.com/dart-lang/sdk/issues/46100): Depreciação do stagehand, dartfmt e dart2native {:#46100-deprecation-of-stagehand-dartfmt-and-dart2native}

No [post do Dart 2.10](/blog/announcing-dart-2-10), de outubro de 2020, anunciamos o nosso trabalho para combinar todas as ferramentas de linha de comando do Dart em uma única ferramenta `dart` combinada (semelhante à ferramenta `flutter`). Como parte dessa evolução, o Dart 2.14 depreciou os comandos `dartfmt` e `dart2native` e descontinuou o `stagehand`. Todas essas ferramentas têm substitutos equivalentes na [ferramenta `dart` unificada](https://dart.dev/tools/dart-tool).

### [#45451](https://github.com/dart-lang/sdk/issues/45451): Depreciação das Native Extensions da VM {:#45451-deprecation-of-vm-native-extensions}

Depreciamos as Native Extensions da VM do Dart, nosso mecanismo mais antigo para chamar código nativo a partir do código Dart. O [FFI](https://dart.dev/guides/libraries/c-interop) (foreign function interface) do Dart é o nosso mecanismo atual para esse caso de uso, e estamos [evoluindo](/blog/announcing-dart-2-13) ativamente para torná-lo ainda mais poderoso e fácil de usar.

## Atualização sobre o null safety {:#null-safety-update}

Lançamos o sound null safety em março, na versão [Dart 2.12](/blog/announcing-dart-2-12). O null safety é a mais recente grande funcionalidade de produtividade do Dart, criada para ajudar você a evitar erros de null, uma classe de bugs que costuma ser difícil de identificar.

Desde a nossa última atualização, vimos um ótimo progresso nas migrações de pacotes e aplicações existentes para aproveitar os benefícios de verificação sólida do null safety. Para os pacotes do pub.dev, 100% dos 250 pacotes mais populares já suportam null safety, e 94% dos 1000 primeiros também suportam. Isso significa que mais desenvolvedores podem executar suas aplicações com o [sound null safety](https://dart.dev/null-safety/unsound-null-safety#sound-and-unsound-null-safety) completo. Os dados de análise mostram que 56% das sessões de `flutter run` são executadas com solidez total. Obrigado a todos os desenvolvedores do ecossistema pelo trabalho de migração!

## Disponibilidade do 2.14 e o impulso contínuo {:#2-14-availability-and-continued-momentum}

O SDK do Dart aprimorado, com as mudanças acima, está disponível hoje nos SDKs Dart 2.14.1 e [Flutter 2.5]({{site.flutter-blog}}/whats-new-in-flutter-2-5). Esperamos que você goste das novas melhorias e recursos.

Também aproveitamos a oportunidade para agradecer à incrível comunidade Dart. Como comprovado por várias atualizações recentes em pesquisas sobre linguagens de programação, o impulso do Dart é forte. O respeitado [ranking da RedMonk](https://redmonk.com/sogrady/2021/08/05/language-rankings-6-21/) menciona *"a notável ascensão do Dart"* e coloca o Dart entre as 20 primeiras pela primeira vez. A abrangente [Pesquisa de Desenvolvedores 2021 do StackOverflow](https://insights.stackoverflow.com/survey/2021#technology-most-loved-dreaded-and-wanted) também foi um prazer de ler: o Dart foi apontado como a 7ª linguagem de programação mais amada pelos desenvolvedores. Estamos muito satisfeitos em ver a plataforma Dart continuar crescendo e ganhando força.
