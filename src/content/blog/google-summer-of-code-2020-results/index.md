---
ia-translate: true
title: "Resultados do Google Summer of Code 2020"
description: "A equipe do Dart orientou 5 estudantes desenvolvedores neste verão, como parte do GSoC 2020. Leia sobre os projetos dos estudantes."
publishDate: 2020-09-02
author: jonasfj
image: images/15VxyyQ1juWjwtTbSkwzzXA.webp
category: other
layout: blog
---


<DashImage src="images/15VxyyQ1juWjwtTbSkwzzXA.webp" alt="O logo do Google Summer of Code." />


[Google Summer of Code (GSoC)](https://summerofcode.withgoogle.com/) é um programa global focado em trazer estudantes desenvolvedores para o desenvolvimento de software open source. Os estudantes são patrocinados pelo Google para trabalhar, junto com uma organização open source que faz a mentoria, em um projeto de programação de 3 meses durante o verão.

Em [fevereiro, ficamos muito felizes em anunciar](/blog/students-join-a-dart-project-for-google-summer-of-code-2020) que a equipe do Dart seria uma organização mentora no GSoC 2020. Acabamos [orientando 5 projetos](https://summerofcode.withgoogle.com/organizations/6544944065413120/), escolhidos entre mais de 170 inscrições de estudantes de todo o mundo. Hoje estamos animados para compartilhar os resultados, conforme descritos pelos próprios estudantes que trabalharam nos projetos.

### Gerando bindings dart:ffi para interoperabilidade Dart-C com package:ffigen {:#generating-dartffi-bindings-for-dart-c-interop-with-packageffigen}

*Por Prerak Mann*

[package:ffigen](https://pub.dev/packages/ffigen) é um gerador de FFI que reduz muito o esforço de usar `dart:ffi`, gerando bindings em Dart a partir de arquivos de cabeçalho C (`.h`).

Para entender a necessidade dessa ferramenta, considere o [LibClang](https://clang.llvm.org/doxygen/group__CINDEX.html) (a interface C do Clang). A [API](https://github.com/dart-lang/ffigen/tree/master/third_party/libclang/include/clang-c) do LibClang tem cerca de 8.000 linhas de código (LOC). Se você fosse escrever à mão os [bindings em Dart para o LibClang](https://github.com/dart-lang/ffigen/blob/master/example/libclang-example/generated_bindings.dart), precisaria de quase 4.500 LOC. Com o `package:ffigen`, tudo o que você precisa fazer é passar um [pequeno arquivo de configuração YAML](https://github.com/dart-lang/ffigen/blob/master/example/libclang-example/pubspec.yaml#L14) com menos de 20 LOC e, então, gerar os bindings.

Você pode controlar quais funções C devem ser geradas e usar expressões regulares simples para renomear macros, enums e membros individuais de structs. Você também pode [gerar membros de array](https://github.com/dart-lang/ffigen#array-workaround) aninhados em structs (algo que ainda não é totalmente suportado no `dart:ffi`).

Confira [github.com/dart-lang/ffigen](https://github.com/dart-lang/ffigen) para ver a lista completa de [configurações](https://github.com/dart-lang/ffigen#configurations), [perguntas frequentes](https://github.com/dart-lang/ffigen#faq), [exemplos](https://github.com/dart-lang/ffigen/blob/master/example/) e mais.

### Aprenda testes com um novo exemplo de Flutter {:#learn-testing-with-a-new-flutter-sample}

*Por Abdullah Deshmukh*

Você usa Flutter há um tempo, mas ainda não descobriu como testar apps Flutter? Então talvez você se interesse pelo exemplo que criamos para demonstrar as melhores práticas de teste de apps Flutter. Você vai aprender a testar em Flutter de um jeito rápido e fácil.

O [exemplo](https://github.com/flutter/samples/tree/master/testing_app) mostra diferentes tipos de teste, incluindo:

* Testes de unidade

* Testes de widget

* Testes de integração

* Testes de desempenho

* Testes de gerenciamento de estado

Como bônus, também criamos um codelab sobre como testar apps Flutter. Você pode ver um relatório detalhado do trabalho feito no projeto no artigo [Aprenda testes com o novo exemplo de Flutter]({{site.flutter-blog}}/learn-testing-with-the-new-flutter-sample-gsoc20-work-product).

### Formatos de arquivo de tradução extensíveis pelo usuário {:#user-extensible-translation-file-formats}

*Por Jaime Blasco*

O pacote [intl_translation](https://pub.dev/packages/intl_translation) oferece suporte apenas ao formato de arquivo ARB, que não é muito usado fora do Dart. O pacote [intl_translation_format](https://pub.dev/packages/intl_translation_format), criado durante o GSoC 2020, se apoia no intl_translation e adiciona uma classe `TranslationFormat`, capaz de suportar formatos bem variados. Desenvolvedores podem adicionar suporte a formatos adicionais em seus próprios pacotes e, em poucas linhas, criar ferramentas de linha de comando para extração e geração que se integram às ferramentas existentes. Com elas, traduções já existentes em outros formatos, até proprietários, podem ser importadas facilmente para um projeto Dart, e novas mensagens originadas no código Dart podem ser integradas às ferramentas e aos fluxos de tradução já existentes.

Como demonstração desses recursos, os novos pacotes incluem suporte a vários formatos. Além do ARB, eles suportam **XLIFF v1.2 (iOS), XLIFF v2.0** e **JSON com mensagens ICU**. [Bibliotecas experimentais](https://github.com/jamesblasco/intl_translation_format_experiments) mostram como poderiam ser implementados o suporte a outros formatos e até traduções que podem ser atualizadas em tempo de execução.

### Platform channels em um app mobile e um plugin federado {:#platform-channels-in-a-mobile-app-and-a-federated-plugin}

*Por Ayush Bherwani*

Depois de pesquisar sobre platform channels (a API do Flutter para enviar mensagens de ida e volta entre Dart e código nativo, como Swift ou Kotlin), decidimos abordar o tema com dois exemplos diferentes. Um é uma [demo simples para Android e iOS](https://github.com/flutter/samples/tree/master/platform_channels), enquanto o outro é um [plugin federado](https://github.com/flutter/samples/tree/master/experimental/federated_plugin) que também pode ser compilado com o canal master para web e desktop. Juntos, os dois exemplos mostram não só os detalhes dos platform channels e os codecs que podem ser usados para transferir dados, mas também as APIs para plugins federados e técnicas para chamar código nativo nas APIs de web e desktop (Windows e Linux).

Se você é um desenvolvedor que quer criar um plugin ou apenas acessar uma API de plataforma, esses exemplos são um ótimo ponto de partida. Para mais informações sobre esse projeto, veja o artigo [Exemplos de platform channel]({{site.flutter-blog}}/platform-channel-examples).

### Escrevendo o package:yaml_edit para habilitar `pub add &lt;package&gt;` {:#writing-packageyaml_edit-to-enable-pub-add-ltpackagegt}

*Por Garett Tok Ern Liang*

Projetos Dart declaram dependências de pacotes em um arquivo `pubspec.yaml`. O [YAML](https://yaml.org/spec/1.2/spec.html) é ótimo porque permite escrever comentários, mas modificar YAML programaticamente é um desafio.

Para enfrentar esse desafio, escrevemos o [`package:yaml_edit`](https://pub.dev/packages/yaml_edit) para realizar, com facilidade, manipulações de string sensíveis ao contexto que preservam a formatação e os comentários. A suíte de testes do pacote tem mais de 40.000 testes, e achamos que temos uma solução bem boa funcionando. Experimente e [reporte bugs](https://github.com/google/dart-neats/issues)!

Usando o `package:yaml_edit`, adicionamos um novo subcomando `pub add &lt;package&gt;` ao `pub`, a ferramenta de gerenciamento de pacotes do Dart e do Flutter. O `pub add` busca automaticamente a versão compatível mais recente do pacote de destino e a adiciona ao `pubspec.yaml` do usuário. Para dar uma ideia do que isso significa, o `pub add &lt;package&gt;` automatiza a chatice de ter que fazer tudo o que segue:

1. Acessar `https://pub.dev/packages/<package>`

1. Escolher uma versão para adicionar ao seu pacote

1. Modificar o `pubspec.yaml`

1. Executar `pub get`

1. Repetir os passos 2 a 4 quantas vezes forem necessárias até obter uma versão compatível com as suas outras dependências

Um comando semelhante que remove dependências — `pub remove &lt;package&gt;` — também está em desenvolvimento. Fique de olho nesses dois comandos chegando ao `pub` em breve!
> Muito obrigado a todos que se inscreveram no Google Summer of Code 2020 com o Dart, aos estudantes que concluíram os projetos neste ano e aos mentores que dedicaram tempo toda semana para tornar este um verão de programação incrível. Esperamos ver muitos de vocês, estudantes, de volta como colaboradores em todo o ecossistema Dart.
