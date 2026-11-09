---
ia-translate: true
title: "Mensagens de diagnóstico do Dart"
description: "Entendendo as mensagens de erro e aviso do analisador do Dart"
publishDate: 2021-11-11
author: bwilkerson
image: images/1kUNsHzJZkZNRysNJmbNTdw.webp
category: deep-dive
layout: blog
---


Você já viu uma mensagem de erro e se perguntou o que ela significa e o que deve fazer a respeito? Pode haver mais informações disponíveis para ajudar a responder essas perguntas do que você imagina.

Vamos pegar um exemplo bastante comum. Há um problema no código a seguir:

<DashImage src="images/1KDUXUtf0E8hb0kZBeIUdSA.webp" alt="Um trecho de código Dart mostrando um erro de compilação para um uso não verificado de um valor anulável." />


No IntelliJ IDEA, a mensagem aparece na visualização Dart Analysis:

<DashImage src="images/1mjwyDt_bsYpTZBPwLbFhwg.webp" alt="Visualização Dart Analysis no IntelliJ IDEA exibindo a mensagem de diagnóstico de uso não verificado de valor anulável." />


No Visual Studio Code, a mensagem de problema aparece no painel Problems:

<DashImage src="images/1XTJeTrWGGKzxfQv41qVfug.webp" alt="Captura de tela do painel Problems no Visual Studio Code com a mensagem de problema." />


Parece estranho que haja um problema, já que acabamos de verificar que `values` não é `null` na linha acima.

A mensagem nos diz o que está errado, mas não ajuda de fato a entender por que a verificação não foi suficiente nem como responder ao erro. Essa informação extra está disponível; só não é necessariamente óbvio onde encontrá-la. O restante deste artigo mostra como localizar essa informação extra na saída do [IntelliJ IDEA](https://www.jetbrains.com/idea/), do [Visual Studio Code](https://code.visualstudio.com/) e da ferramenta de linha de comando `dart analyze`.

### IntelliJ IDEA

Se você passar o mouse sobre o texto destacado, pode obter mais informações:

<DashImage src="images/1m2K6XXsAfB7gK0oBPGNwag.webp" alt="Captura de tela mostrando o texto ao passar o mouse sobre a mensagem de diagnóstico, com informações de contexto e de correção." />


O texto ao passar o mouse inclui a mensagem que vimos acima (que chamamos de *mensagem de problema*), mas também inclui outras informações úteis:

* Um link para a [documentação externa sobre o diagnóstico](https://dart.dev/tools/diagnostic-messages#unchecked_use_of_nullable_value)

* Uma *mensagem de contexto* que explica por que a comparação com `null` não foi suficiente para promover o tipo da propriedade para não anulável

* Uma *mensagem de correção* que descreve algumas das coisas que você pode fazer para corrigir o código

A mensagem de contexto inclui a URL de documentação adicional relacionada à promoção de tipo e informa a linha e o arquivo onde o campo é definido. Infelizmente, você não consegue navegar até a localização do contexto a partir do texto ao passar o mouse, mas consegue fazer isso a partir da visualização Dart Analysis.

Embora a visualização Dart Analysis exiba apenas a mensagem de problema, dar um duplo clique na mensagem leva você ao texto com o sublinhado vermelho ondulado onde o problema está sendo reportado. Para outros recursos úteis, abra o menu de contexto:

<DashImage src="images/1KUQaTyshPTkO9eF0Rdxe2w.webp" alt="Menu de contexto da IDE mostrando as opções Jump to Source e Open Documentation." />


Com o menu de contexto, você pode navegar até o local onde o diagnóstico foi reportado (usando **Jump to Source**, que funciona como um duplo clique na mensagem de problema) ou até a declaração de `values` (usando o item de menu identificado pela mensagem de contexto). Selecionar **Open Documentation** abre a documentação externa sobre o diagnóstico.

### Visual Studio Code

No Visual Studio Code há duas formas de ver a informação extra. A primeira é expandir a entrada no painel Problems:

<DashImage src="images/1qsXBZQMBgk6W5WaUBOQ_bA.webp" alt="Captura de tela mostrando uma entrada expandida no painel Problems, com as mensagens de contexto e de correção." />


A primeira linha é a mensagem que vimos antes (que chamamos de *mensagem de problema*). Dar um duplo clique na primeira ou na segunda linha leva você ao texto com o sublinhado vermelho ondulado onde está o problema.

A segunda linha é uma *mensagem de correção* que descreve algumas das coisas que você pode fazer para corrigir o código. Ela também contém um link, identificado pelo ID do diagnóstico, que abre a [documentação externa sobre o diagnóstico](https://dart.dev/tools/diagnostic-messages#unchecked_use_of_nullable_value).

A terceira linha é uma *mensagem de contexto* que explica por que a comparação com `null` não foi suficiente para promover o tipo para não anulável. Dar um duplo clique na mensagem de contexto leva você à declaração de `values`. A mensagem de contexto inclui a URL de documentação adicional relacionada à promoção de tipo.

Você também pode ver essas informações passando o mouse sobre o texto destacado, o que abre o texto de ajuda:

<DashImage src="images/1kUNsHzJZkZNRysNJmbNTdw.webp" alt="Captura de tela demonstrando o texto ao passar o mouse no Visual Studio Code, revelando detalhes adicionais do problema." />


O texto ao passar o mouse contém as mesmas informações do painel Problems. Ele tem um link para a documentação externa e outro link para navegar até a declaração de `values`.

### dart analyze

O analisador de linha de comando `dart analyze` pode exibir as mesmas informações das IDEs, mas você precisa usar a flag `--verbose` para ver tudo.

<DashImage src="images/1GtSPY3IoZDeGkfkolrXO7A.webp" alt="Captura de tela do terminal demonstrando as mensagens de diagnóstico detalhadas fornecidas pelo comando dart analyze --verbose." />


### Resumo {:#summary}

Espero que este artigo ajude você a encontrar mais facilmente as informações de que precisa para entender os diagnósticos do analisador.

Se você encontrar diagnósticos que ainda são difíceis de entender, porque a mensagem não é clara, porque precisa de uma mensagem de contexto para ajudar a encontrar outros locais de código relacionados ou porque a documentação não está completa o bastante, por favor nos avise [criando uma issue no dart-lang/sdk](https://github.com/dart-lang/sdk/issues/new). Estamos sempre interessados em melhorar as ferramentas.
