---
ia-translate: true
title: "Tornando um app web em Dart disponível offline: 3 linhas de código"
description: "Você já tentou carregar um aplicativo web (talvez um jogo ou um conversor de medidas) e não conseguiu usá-lo porque a rede estava fora…"
publishDate: 2017-03-28
author: isoos
image: images/1GsjtYvVghuA63qhhRdyfPQ.webp
category: other
layout: blog
---


Você já tentou carregar um aplicativo web (talvez um jogo ou um conversor de medidas) e não conseguiu usá-lo porque a rede estava fora? Essa é uma experiência horrível, mas, felizmente, temos a tecnologia para deixar esses apps disponíveis para os nossos usuários.

Para a maioria dos apps e jogos, isso pode ser feito com 3 linhas de código Dart e 1 comando no terminal. Neste artigo curto, vou guiar você pelos passos e garantir que você sempre consiga jogar o [Pop, Pop, Win!](https://isoos.github.io/offline_pop_pop_win/)

<DashImage src="images/1GsjtYvVghuA63qhhRdyfPQ.webp" alt="Tabuleiro do jogo Pop, Pop, Win! com peças numeradas, balões, cinco bombas restantes e um cronômetro de 24,5 segundos." caption="[Pop, Pop, Win!](https://dart-lang.github.io/sample-pop_pop_win/) — uma [implementação de Campo Minado](https://github.com/dart-lang/sample-pop_pop_win) em Dart" />


## Service workers {:#service-workers}

Um service worker é um arquivo JavaScript que roda em segundo plano. Ele pode controlar a página web ou o site ao qual está associado, interceptando e modificando requisições de navegação e de recursos, e armazenando recursos em cache de forma bem granular.

É uma tecnologia web não intrusiva: service workers podem melhorar a experiência do usuário se o navegador [oferecer suporte a eles](http://caniuse.com/#feat=serviceworkers), mas o site continua funcionando sem eles (com o comportamento padrão da web). Essa propriedade é útil porque permite criar **progressive web apps (PWA)**, nos quais você oferece recursos mais avançados para a maioria dos usuários sem deixar os demais de fora.

Como uma thread de processamento em segundo plano, um service worker pode ajudar com:

* modo offline (buscando recursos do cache enquanto a rede está fora)

* estratégias de cache (para respostas quase instantâneas do cache, que podem ser atualizadas depois com conteúdo novo)

* notificações push (como em um app mobile)

* mensagens (se o aplicativo estiver aberto em várias abas)

O recurso importante para a nossa experiência de jogo offline é este: queremos jogar Pop, Pop, Win! e não encontrar este dinossauro:

<DashImage src="images/1cufcmiyxW8k4ku1-Y_zsvg.webp" alt="O jogo do dinossauro offline do Chrome indicando que não há conexão com a internet." caption="Curiosidade: você pode jogar com esse dinossauro pressionando a seta para cima." />


## Progressive web app com Dart {:#progressive-web-app-with-dart}

Dar suporte ao modo offline exige, aproximadamente, o seguinte:

1. Determinar quais recursos colocar no cache para uso offline.

1. Criar um service worker que prepare um cache desses recursos.

1. Registrar o service worker, para que as requisições seguintes possam ser atendidas pelo cache offline (caso a rede esteja fora).

1. No service worker, pré-popular o cache offline com as URLs e também tratar a requisição de fetch adequadamente, seja pelo cache, seja pela rede.

1. Garantir que o service worker detecte mudanças no app ou nos recursos estáticos e coloque a nova versão no cache.

Embora a lista acima possa soar um pouco assustadora, temos o pacote [pwa](https://pub.dartlang.org/packages/pwa) no Dart, que faz a maior parte do trabalho por nós, oferecendo uma API de alto nível e automatizando a maioria das tarefas.

### Mudanças na sua aplicação {:#changes-in-your-application}

Importe o pacote `pwa` no seu `pubspec.yaml`:

```
dependencies:
  pwa: ^0.1.2
```


Depois de executar `pub get`, adicione o client ao seu `web/main.dart`:

```
import ‘package:pwa/client.dart’ as pwa;

main() {
  // register PWA ServiceWorker for offline caching.
  new pwa.Client();

}
```


O código acima trata o item 3 da lista anterior, registrando o service worker (que criaremos no passo seguinte). Por enquanto, não usamos a instância do Client para mais nada, mas, à medida que o pacote `pwa` ganhar novos recursos, ela pode ser útil para outros fins.

### Aplicação web progressiva gerada automaticamente {:#automatically-generated-progressive-web-application}

O pacote `pwa` oferece geração de código que cuida dos itens 1–2 e 4–5 da lista acima. Para garantir o uso adequado do cache (tanto preenchendo quanto invalidando o cache), siga este fluxo de trabalho:

1. Compile seu app web com todos os recursos estáticos em `build/web`:
`pub build`

1. Execute o gerador de código do `pwa` para escanear (ou escanear novamente) seus recursos offline:
`pub run pwa`

1. Compile o projeto novamente, porque o seu novo arquivo `pwa.dart` precisa ser compilado:
`pub build`

Essas etapas produzem um arquivo chamado `lib/pwa/offline_urls.g.dart`, que contém a lista de URLs offline a serem armazenadas em cache. A extensão `.g.dart` indica que o arquivo é gerado e pode ser sobrescrito automaticamente pela ferramenta de geração de código do `pwa`.

Na primeira execução, esse fluxo gera o arquivo `web/pwa.dart`, que contém o seu service worker com padrões razoáveis. Você pode modificar esse arquivo (para personalizar as URLs offline ou usar as APIs de alto nível, por exemplo), porque o gerador de código não vai alterá-lo nem sobrescrevê-lo novamente.

## Ressalvas {:#caveats}

Embora o Dartium seja ótimo para a maior parte do desenvolvimento web, no momento ele é difícil de usar com service workers. Recomendamos usar o Chrome ou o Firefox.

Invalidação de cache é um dos problemas mais difíceis da ciência da computação. A [Web Cache API](https://developer.mozilla.org/en-US/docs/Web/API/Cache) subjacente oferece algumas garantias, e a biblioteca `pwa` se esforça bastante para lidar com os casos extremos de forma elegante, mas não trate o cache como armazenamento confiável para nada realmente importante. Use o cache quando ele estiver disponível e falhe de forma elegante quando não estiver.

## Experimente {:#try-it-out}

Agora você pode fazer o deploy da nova versão da sua aplicação. Ou experimente o [jogo Pop, Pop, Win! offline](https://isoos.github.io/offline_pop_pop_win/).

Depois de abrir o jogo e jogar uma rodada, desligue o wi-fi ou tire o cabo de rede e recarregue a página (ou digite a URL novamente). Se estiver usando Chrome ou Firefox, seu jogo deve continuar funcionando. Boa sorte, divirta-se!
