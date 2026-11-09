---
ia-translate: true
title: "Anunciando o Dart 3.5 e uma atualização sobre o roadmap do Dart"
description: "Chegou a hora de mais uma das nossas versões trimestrais do SDK do Dart. Temos melhorias de interoperabilidade, novos recursos no nosso gerenciador de pacotes do pub.dev…"
publishDate: 2024-08-06
author: mit-mit
image: images/1PVj9TIzP50I00tavJqAg_Q.webp
category: releases
layout: blog
---


Chegou a hora de mais uma das nossas versões trimestrais do SDK do Dart. Temos melhorias de interoperabilidade, novos recursos no nosso gerenciador de pacotes do pub.dev e, além disso, tornamos estáveis e na versão 1.0 as nossas novas APIs de integração com a web.

Grande parte do nosso tempo foi dedicada a esforços maiores, que levam vários trimestres, então também trazemos uma atualização sobre o nosso roadmap do Dart, com detalhes sobre o que esperamos avançar nos próximos trimestres.

<DashImage src="images/1PVj9TIzP50I00tavJqAg_Q.webp" alt="Banner de lançamento do Dart 3.5 com o logo do Dart e um ícone de alvo." caption="Imagem de lançamento do Dart 3.5." />


## Novas capacidades no Dart 3.5 {:#new-capabilities-in-dart-3-5}

O Dart 3.5 traz uma série de novas capacidades, discutidas abaixo. Há também um número menor de mudanças nas APIs da biblioteca core e cerca de 10 mudanças incompatíveis muito pequenas, detalhadas no [changelog](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#350).

## Plataforma web e interoperabilidade com JS {:#web-platform-and-js-interoperability}

No Dart 3.4 e no Flutter 3.22, introduzimos suporte à [compilação de apps web do Flutter para WebAssembly](https://docs.flutter.dev/platform-integration/web/wasm). A compilação para WebAssembly exige o uso do nosso novo [modelo de interop Dart para JS](https://dart.dev/interop/js-interop), que antes estava em prévia. A partir do Dart 3.5, ele é considerado estável e completo, e atualizamos os bindings das APIs do navegador no [package:web](https://pub.dev/packages/web) (que substitui a antiga biblioteca `dart:html`) para a versão 1.0.

Gostaríamos de incentivar todos os autores de pacotes web a [migrar para o package:web](https://dart.dev/interop/js-interop/package-web). Planejamos descontinuar as APIs antigas de interop (dart:html, dart:js, package:js etc.) na nossa próxima versão do Dart e descontinuá-las por completo mais adiante, no próximo ano. Convidamos você a dar feedback sobre esse plano na [issue de acompanhamento](https://github.com/dart-lang/sdk/issues/56358). Também planejamos atualizar a [pontuação](https://pub.dev/help/scoring) no gerenciador de pacotes pub.dev para dar pontos aos pacotes web que oferecem suporte ao novo modelo de interop.

Também adicionamos [um novo lint](https://dart.dev/tools/linter-rules/invalid_runtime_check_with_js_interop_types), que valida se o seu código usa corretamente os novos tipos de interop com JS. Recomendamos que você adicione esse lint ao seu arquivo `analysis_options.yaml` como parte da migração dos seus pacotes web.

## Interoperabilidade nativa do Dart {:#dart-native-interoperability}

Também fizemos uma série de melhorias na nossa interoperabilidade nativa, que permite chamar diretamente do Dart para C, Java, Kotlin, Objective-C e Swift.

A interop com C é viabilizada pela nossa biblioteca [FFI](https://dart.dev/interop/c-interop) (Foreign Function Interface), que suportamos há vários anos. No Dart 3.5, fizemos melhorias incrementais para permitir passar um ponteiro dos objetos `TypedData` do Dart diretamente para o FFI, evitando ter que copiar primeiro a memória do Dart para o código nativo ([detalhes](https://github.com/dart-lang/sdk/issues/44589)).

A interop com Java e Kotlin é viabilizada pelo gerador [JNIgen](https://pub.dev/packages/jnigen) (atualmente em prévia), que automatiza a criação do código de bindings para chamar do Dart para Java e Kotlin por meio da Java Native Interface ([JNI](https://developer.android.com/training/articles/perf-jni)). Melhoramos o desempenho e adicionamos suporte a exceções Java e a funções de nível superior do Kotlin. Também descontinuamos os [bindings baseados em C](https://github.com/dart-lang/native/issues/660) anteriores, já que os bindings alternativos, exclusivos do Dart, agora têm desempenho e recursos comparáveis e são muito mais fáceis de usar. Para detalhes, veja o [changelog](https://pub.dev/packages/jnigen/changelog).

A interop com Objective-C se apoia no FFI e no nosso gerador [FFIgen](https://pub.dev/packages/ffigen) (atualmente em prévia). Adicionamos suporte a protocolos do Objective-C e a tipos comuns, como `NSString`. Para um grande exemplo de pacote construído com o FFIgen, veja o [cupertino_http](https://github.com/dart-lang/http/tree/master/pkgs/cupertino_http), que interopera com a biblioteca de rede URL Loading System da Apple.

Continuaremos investindo em mais interoperabilidade (tanto na conclusão das bibliotecas mencionadas acima quanto no suporte ao Swift) nas próximas versões. Veja a seção do roadmap abaixo para os detalhes.

## Repositório de pacotes do pub.dev {:#pub-dev-package-repository}

O pub.dev é o nosso repositório de pacotes, onde a comunidade pode compartilhar e encontrar pacotes com uma grande variedade de funcionalidades. Fizemos várias melhorias aqui. Primeiro, refinamos o suporte a [**tópicos**](https://dart.dev/tools/pub/pubspec#topics): o mecanismo pelo qual os autores de pacotes marcam seus pacotes com a categoria à qual pertencem (como widget). Agora [consolidamos](https://github.com/dart-lang/pub-dev/blob/master/doc/topics.yaml) tópicos comuns que cobrem a mesma categoria, mas usam pequenas variações de redação (por exemplo, widgets e widget).

Segundo, adicionamos um novo comando `pub unpack`. Ele oferece uma forma rápida e fácil de baixar um pacote para o seu sistema de arquivos. Isso pode ser usado, por exemplo, se você quiser executar o programa de exemplo de um pacote na sua máquina local:

```bash
$ dart pub unpack path
Downloading path 1.9.0 to `./path-1.9.0`...

$ cd path-1.9.0/example/

$ dart run example.dart
Current path style: posix
Current process path: /Users/mit/tmp/path-1.9.0/example
```


Terceiro, adicionamos um novo comando `pub downgrade --tighten`. Ele pode ser usado para verificar todas as restrições de versão das dependências de um pacote. Quando executado, ele atualiza a restrição inferior para a versão mais baixa para a qual o pub conseguiu fazer a resolução.

## Atualização do roadmap do Dart {:#dart-roadmap-update}

Além dos recursos concluídos acima, também trabalhamos em várias áreas para avançar no nosso roadmap de longo prazo.

## Desempenho da IDE e do analisador em monorepos grandes {:#ide-and-analyzer-performance-for-large-monorepos}

Um "monorepo" é uma forma comum de estruturar o código-fonte de um conjunto de pacotes e apps relacionados em um único repositório, como no [repositório de pacotes](https://github.com/flutter/packages/tree/main) do Flutter. Um monorepo não se resume à conveniência de ter todo o código-fonte "próximo", mas também pode ser uma ferramenta crítica para garantir que os pacotes e apps individuais do repositório sejam mutuamente compatíveis.

Temos ouvido de desenvolvedores que trabalham em monorepos grandes um feedback consistente de que o desempenho das nossas ferramentas, especialmente do analisador, deixa a desejar. Nossa análise desses problemas sugere que a causa raiz é que acabamos carregando múltiplos contextos de análise sobrepostos para cada pacote e TODAS as suas dependências, o que leva a várias cópias da análise de cada pacote do monorepo na memória ao mesmo tempo. Acreditamos que a solução fundamental é criar uma única resolução compartilhada das versões de cada dependência nesses repositórios, e estamos trabalhando nessa capacidade por meio de um novo recurso do pub chamado [workspaces](https://github.com/dart-lang/sdk/issues/53875). Teremos muito mais a compartilhar sobre isso na nossa próxima versão do Dart, mas, por enquanto, você já pode ver como isso foi [aplicado recentemente](https://github.com/flutter/engine/pull/54157/files) ao repositório da engine do Flutter.

## Repositório de pacotes do pub.dev {:#pub-dev-package-repository}

Os usuários do repositório de pacotes pub.dev há muito tempo pedem métricas melhores sobre [quanto cada pacote é usado/baixado](https://github.com/dart-lang/pub-dev/issues/2714). Isso pode ser útil tanto para os autores de pacotes, como um sinal de quantos usuários estão se beneficiando do trabalho deles, quanto para os consumidores de pacotes, como um sinal de quais pacotes outros desenvolvedores estão usando. Ficamos felizes em compartilhar que estamos avançando bem nessa capacidade e esperamos tê-la em prévia até o final do ano.

## Interoperabilidade nativa do Dart {:#dart-native-interop}

Para a interop com Java e Kotlin via JNIgen, esperamos concluir o suporte principal e passar de experimental para uma versão estável 1.0 nos próximos dois trimestres. Para detalhes, veja o [acompanhamento do JNIgen](https://github.com/orgs/dart-lang/projects/69/). Para a interop com Objective-C, temos um objetivo semelhante; veja o [acompanhamento do Objective-C](https://github.com/orgs/dart-lang/projects/87).

Em seguida, estamos investigando a interop direta com código Swift. As primeiras experimentações são promissoras, e esperamos adicionar um suporte experimental no início do próximo ano.

## Interoperabilidade nativa e empacotamento de código-fonte nativo {:#native-interop-and-bundling-of-native-source-code}

Em muitos casos, a interop direta é usada para chamar APIs presentes no sistema operacional, o que significa que essas APIs estão sempre disponíveis nas plataformas hospedeiras. No entanto, em alguns casos, o código com o qual o Dart faz interop é *código-fonte* nativo que não está incluído diretamente na plataforma hospedeira, o que representa um desafio prático para os autores de pacotes que usam essa interop: como fazer com que esse código-fonte nativo seja empacotado e compilado sem obrigar os consumidores do pacote a executar uma série de passos manuais? Para oferecer suporte a isso, estamos explorando um [sistema de native assets](https://github.com/dart-lang/sdk/issues/50565), que poderia permitir publicar pacotes Dart que contenham código-fonte nativo, junto com um protocolo padronizado para que as ferramentas de CLI `dart` e `flutter` automatizem a compilação e o empacotamento desse código-fonte. Imaginamos que isso vai habilitar um novo conjunto de casos de uso de interoperabilidade e, ao mesmo tempo, oferecer uma experiência de uso descomplicada para os desenvolvedores que usam pacotes que dependem de código-fonte nativo.

## Linguagem Dart e macros {:#dart-language-macros}

A maior parte do tempo das equipes de linguagem e de compilador do Dart atualmente é dedicada a avançar no recurso de linguagem muito grande chamado macros, que apresentamos no [post do blog do Dart 3.4](/blog/announcing-dart-3-4). Como dissemos na época, esta é uma tarefa enorme, com potencial de causar regressões em alguns dos nossos casos de uso centrais, como o hot reload, então estamos adotando uma abordagem minuciosa e provavelmente precisaremos de vários trimestres de trabalho adicional antes de compartilhar os detalhes do próximo passo.

Além das macros, também estamos explorando, em paralelo, vários outros recursos de linguagem menores, documentados no [funil de linguagem do Dart](https://github.com/orgs/dart-lang/projects/90/views/1).

Desde o outono passado, estamos reescrevendo o formatador do Dart. O design antigo funcionou bem por muitos anos, mas, com o sucesso do Flutter, queremos migrar para [um novo estilo](https://github.com/dart-lang/dart_style/issues/1253) que funcione melhor para o tipo de código declarativo que os usuários do Flutter costumam escrever. O formatador antigo não conseguia produzir esse tipo de saída. A reescrita está quase pronta e será lançada em breve. Se quiser experimentá-la, passe a flag de experimento `tall-style` ([instruções sobre as flags](https://dart.dev/tools/experiment-flags)). Recebemos com prazer [feedback](https://github.com/dart-lang/dart_style/issues) caso você veja saídas estranhas.

## Encerramento {:#closing}

É isso por hoje. Recebemos seu feedback, tanto sobre os itens do roadmap discutidos quanto sobre os novos recursos do Dart 3.5, disponíveis em [Dart.dev](https://dart.dev/get-dart) ou incluídos no lançamento de hoje do [Flutter 3.24]({{site.flutter-blog}}/whats-new-in-flutter-3-24).
