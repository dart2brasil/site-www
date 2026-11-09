---
ia-translate: true
title: "StageXL 1.0"
description: "Um motor de renderização 2D rápido para HTML5 e Dart."
publishDate: 2016-12-03
author: bp74
image: images/1oPIKFEq7-9ndX53muruOsQ.webp
category: other
layout: blog
---


<DashImage src="images/1oPIKFEq7-9ndX53muruOsQ.webp" alt="StageXL 1.0 release artwork." />


Depois de mais de 4 anos em desenvolvimento, disponível desde as primeiras versões beta do Dart, temos o orgulho de anunciar o lançamento do StageXL 1.0. O [StageXL](http://www.stagexl.org/) é um motor de renderização 2D rápido e universal para jogos e aplicações na web. Este artigo fala sobre as funcionalidades e aplicações mais importantes desta biblioteca.

## Apoiando-se em gigantes: Adobe Flash {:#standing-on-the-shoulders-of-giants-adobe-flash}

Já faz alguns anos que ficou claro que o Adobe Flash seria substituído pelos recursos do HTML5. Plataformas de streaming de vídeo substituíram seus players em Flash por players em HTML5, e a rede de anúncios AdWords do Google baniu todos os anúncios de display baseados em Flash recentemente. O último grande reduto de aplicações Flash na web são os jogos. Mesmo hoje, a maioria dos jogos no Facebook é feita com Flash.

No passado, desenvolvedores de jogos não tinham outra escolha a não ser usar Flash para jogos. Os recursos do DOM não eram adequados para jogos e, mesmo depois da introdução do elemento canvas, você ainda tinha que lidar com problemas de performance, problemas de compatibilidade e, por último, mas não menos importante, o JavaScript (uma linguagem nascida do inferno, se você perguntar a certos desenvolvedores de Flash/ActionScript). As coisas melhoraram com a chegada de bibliotecas como [CreateJS](http://www.createjs.com/) ou [PixiJS](http://www.pixijs.com/), que oferecem uma API e uma experiência de desenvolvimento parecidas com as do Flash. Além disso, o surgimento de linguagens como [TypeScript](https://www.typescriptlang.org/), [Haxe](https://haxe.org/) ou [CoffeeScript](http://coffeescript.org/) diminuiu a dor.

Como ex-desenvolvedor de jogos em Flash/ActionScript, eu vivi todas as coisas mencionadas acima na pele. Mas, assim que tive contato com as primeiras versões do Dart, ficou claro que ele era um sucessor digno do ActionScript. O Dart tem aparência e sensação muito parecidas com as do ActionScript e, ao mesmo tempo, é uma linguagem muito mais moderna, que evita uma sintaxe inchada. Mas o Flash é muito mais do que a linguagem. O Flash oferece um motor de renderização baseado em árvore de exibição, um motor de som, gráficos vetoriais, renderização de texto e muito mais. Essa foi a base do StageXL: esta nova biblioteca deveria oferecer os recursos do Flash em combinação com Dart e HTML5. Os desenvolvedores deveriam conseguir usar Dart e StageXL para escrever seus jogos da mesma forma que faziam com Flash antes. Para facilitar ainda mais, a API do StageXL é quase idêntica à do Flash.

Desenvolvedores de Flash devem se sentir familiarizados com código do StageXL como este:

```
**Sprite** createContainer(**BitmapData** bitmapData) {
  var bitmap = new **Bitmap**(bitmapData);
  var sprite = new **Sprite**();
  bitmap.**x** = -bitmapData.**width** / 2;
  bitmap.**y** = -bitmapData.**height** / 2;
  sprite.**addChild**(bitmap);
  sprite.**alpha** = 0.5;
  return sprite;
}
```


[**StageXL - Comparação de ActionScript com Dart**
*Vindo do ActionScript, aprender Dart é fácil. As duas linguagens são baseadas em classes, com herança simples e orientadas a objetos…*www.stagexl.org](http://www.stagexl.org/docs/actionscript-dart.html)

## StageXL em poucas palavras {:#stagexl-in-a-nutshell}

A API do StageXL cobre uma ampla gama de funcionalidades. O objetivo principal da biblioteca é ser um motor de renderização rápido e fácil de usar, mas você precisa de mais do que isso para escrever um jogo ou aplicação.

**Gráficos:** uma árvore de exibição é construída a partir de nós que estendem a classe base abstrata DisplayObject. A posição de um nó na árvore define se o objeto de exibição fica na frente ou atrás de outro objeto. Para criar ramificações na árvore, uma segunda classe base abstrata, chamada DisplayObjectContainer, é usada. Você pode construir objetos de exibição customizados estendendo uma dessas duas classes base, ou usar uma das classes prontas, como Sprite, Bitmap, TextField ou Shape. Todas essas classes são [iguais às do Flash](http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7e26.html), e conceitos semelhantes são usados em outros motores de renderização também.

**Interação:** a classe EventDispatcher oferece a capacidade de disparar eventos e de registrar listeners para determinados eventos. Todos os objetos de exibição estendem a classe EventDispatcher e, portanto, são capazes de disparar eventos. Esses eventos podem ser eventos customizados disparados pela lógica do seu jogo, ou eventos de interação com mouse, toque e teclado disparados pelo runtime do StageXL. Como todos os objetos de exibição vivem dentro da árvore de exibição, um evento se propaga por todos os nós, do nó raiz até o nó alvo e de volta (fases de captura, alvo e bubbling de um evento).

**Áudio:** todo jogo precisa de efeitos sonoros adequados. O StageXL fornece a infraestrutura para carregar e tocar amostras de áudio sem muito trabalho. A classe Sound representa uma amostra de áudio carregada na memória. Chamar o método play da classe Sound começa a tocar a amostra e retorna uma instância da classe SoundChannel, para ter controle sobre a reprodução. Você pode tocar várias instâncias do mesmo Sound simultaneamente, por exemplo, para tocar várias instâncias de um som de explosão.

**Recursos:** o StageXL facilita o carregamento de imagens, arquivos de áudio e outros recursos do servidor. Como carregar esses arquivos é uma operação assíncrona, uma API baseada em Future é oferecida. Carregar uma imagem é tão simples quanto aguardar a conclusão do Future retornado pelo método BitmapData.load. O mesmo vale para o Future retornado pelos métodos Sound.load ou TextureAtlas.load. Para tornar ainda mais conveniente o carregamento de muitos recursos diferentes de uma só vez, pode-se usar a classe ResourceManager. Essa classe carrega todos os recursos especificados e oferece acesso fácil a eles assim que o processo de carregamento termina. O ResourceManager pode ser visto como o substituto dos recursos embutidos do Flash.

**Animação:** o StageXL também contém um framework de animações chamado Juggler. O framework Juggler foi introduzido pelo motor de renderização [Starling](http://gamua.com/starling/), bem conhecido entre desenvolvedores de Flash. O Juggler é usado para controlar os chamados Animatables, com base no tempo que passou entre dois quadros de renderização. Um desses Animatables é a classe Tween, usada para animar a posição, a rotação, a escala ou a translucidez de qualquer objeto de exibição. O Juggler também oferece Streams baseados em tempo para controlar valores na lógica do seu jogo. Mais detalhes podem ser encontrados na [documentação do Juggler](http://www.stagexl.org/docs/wiki-articles.html?article=juggler).

## Por trás dos bastidores do StageXL {:#stagexl-behind-the-scenes}

O motor de renderização do StageXL é construído sobre WebGL, para o melhor desempenho e flexibilidade. Claro que o desenvolvedor não precisa saber nada sobre WebGL para usar o StageXL. Ainda assim, vale notar que os objetos de exibição são renderizados por programas de shader WebGL, seja usando um shader padrão, seja um shader mais avançado para efeitos de filtro, como BlurFilter, DropShadowFilter, ColorMatrixFilter e outros. Em casos de uso mais avançados, os desenvolvedores podem usar filtros customizados implementando seu próprio código de shader WebGL.

Para obter a melhor performance de renderização possível, é essencial usar os chamados texture atlases. Todos os seus assets de imagem são combinados em uma grande imagem que é enviada para a memória da GPU. Por isso, o StageXL oferece suporte aos formatos mais comuns de texture atlas já de fábrica. Use seu gerador de texture atlas favorito (recomendamos muito o [TexturePacker](https://www.codeandweb.com/texturepacker)) para gerar o texture atlas, e o resto é tratado internamente pelo StageXL. Como um bônus especial, o StageXL oferece suporte a recursos avançados de texture atlas, como [malhas de sprite poligonais](https://www.codeandweb.com/texturepacker/tutorials/cocos2d-x-performance-optimization) e o algoritmo de empacotamento poligonal.

O motor de som do StageXL é construído sobre a WebAudio API. Assim como no caso do WebGL, o desenvolvedor não precisa conhecer nada dessa API. Para tocar amostras de áudio, basta usar as classes Sound e SoundChannel, que fazem todo o trabalho pesado para você. Um problema comum ao tocar áudio em diferentes navegadores é a falta de suporte a certos codecs de áudio. Você provavelmente codifica suas amostras de áudio como arquivos mp3, mas não há garantia de que o mp3 seja suportado em todas as plataformas. O mesmo vale se você codificar suas amostras em qualquer outro formato de arquivo. O StageXL resolve esse problema carregando automaticamente o formato de áudio correto, com base nos recursos do navegador.

Outros motores de renderização 2D para JavaScript frequentemente afirmam ser os mais rápidos e flexíveis. Claro que essa afirmação depende muito do benchmark ou do caso de uso, e é muito difícil de verificar. Durante o design e o desenvolvimento do StageXL, comparamos constantemente sua performance e flexibilidade com outros motores. No fim, os dois fatores de qualidade igualam ou até superam os de outros motores que se dizem os melhores. Uma das grandes vantagens do StageXL nesse aspecto é o uso da linguagem Dart. A linguagem não só permite um design de API muito limpo, como também tem um compilador excepcional para JavaScript, que otimiza certos padrões de um jeito que, na prática, você não conseguiria implementar à mão em JavaScript. O JavaScript compilado não precisa ser bonito, só precisa rodar rápido. O compilador faz inlining de funções, eliminação de código morto, constant folding, inferência de tipos e outras otimizações. O compilador também sabe como o JavaScript precisa ser para rodar rápido nas engines JavaScript modernas. Isso é muito diferente de linguagens como TypeScript, em que o código não é compilado para JavaScript, mas apenas transpilado. Por último, mas não menos importante, você não precisará mudar uma única linha de código para compilar para ES5 e ES6 JavaScript nativo.

[**StageXL BunnyMark**
*Renderize o máximo de coelhos possível!*www.stagexl.org](http://www.stagexl.org/example/benchmark/bunny_mark/?v=2)

## StageXL continua {:#stagexl-to-be-continued}

Levou mais de 4 anos para chegar à versão 1.0 do StageXL. O motivo de tanto tempo é que sempre há algo a melhorar ou a acrescentar, e você nunca acha que o projeto está concluído. Isso vale também para a versão 1.0, e novas funcionalidades serão adicionadas regularmente no futuro. O feedback da comunidade é muito valioso, e pedidos de funcionalidades são sempre bem-vindos — relatórios de bugs também, até certo ponto ;)

Provavelmente a maior funcionalidade no horizonte é o suporte ao [Flutter](https://flutter.io/). Você poderia escrever jogos para celular em Dart e StageXL para Android e iOS. As primeiras versões do Flutter parecem muito promissoras, mas, infelizmente, a plataforma ainda não expõe as APIs OpenGL de que você precisa para construir o StageXL sobre ela. Vamos acompanhar o desenvolvimento e torcer para que não demore muito até vermos o StageXL em dispositivos móveis.

[**Flutter: a melhor experiência de desenvolvimento mobile?**
*Desenvolver para mobile ficou muito mais divertido com o fluxo de trabalho de desenvolvedor ao vivo do Flutter. No centro desse novo fluxo de trabalho…*news.dartlang.org](http://news.dartlang.org/2016/11/flutter-best-mobile-development.html)

## Bibliotecas de extensão {:#extension-libraries}

A biblioteca StageXL oferece tudo o que você precisa para renderizar gráficos, tocar áudio, carregar arquivos de recursos, fazer animações e muito mais. Mas há outras funcionalidades de que você pode precisar para o seu jogo ou aplicação. Por isso, o StageXL pode ser estendido com funcionalidades mais especializadas, disponíveis em pacotes extras. As extensões a seguir estão disponíveis no GitHub e também no [Pub](https://pub.dartlang.org/).

**[StageXL_Spine](https://github.com/bp74/StageXL_Spine):** o [Spine](http://esotericsoftware.com/) é dedicado à animação esquelética 2D, oferecendo um fluxo de trabalho eficiente tanto para criar animações incríveis quanto para integrá-las aos seus jogos. O Spine oferece inúmeras ferramentas para moldar e refinar suas animações 2D. Dobre e deforme imagens com skinning de malha/pesos, ajuste o tempo com o dopesheet, visualize o movimento com ghosting, posicione seus personagens com cinemática inversa, crie efeitos pseudo 3D e muito mais. ([demo](http://www.stagexl.org/show/spine/raptor/example.html))

**[StageXL_DragonBones](https://github.com/bp74/StageXL_DragonBones):** o [DragonBones](http://dragonbones.com/) é uma solução open source de animação de esqueleto 2D, muito popular entre desenvolvedores de Flash e Starling. O editor está disponível para Mac e Windows e não exige o Adobe Flash. O DragonBones pode não ter tantos recursos quanto o Spine, mas oferece funcionalidades suficientes para a maioria dos casos de uso. ([demo](http://www.stagexl.org/show/dragonbones/dragon_new/example.html))

**[StageXL_GAF](https://github.com/bp74/StageXL_GAF):** o [GAF](http://www.gafmedia.com/) significa Generic Animation Format. O GAF foi projetado para armazenar animações do Flash em um formato aberto e multiplataforma, para reprodução posterior. O GAF permite que artistas e animadores usem o Adobe Flash para criar animações complexas e usem essas animações no StageXL sem costuras. ([demo](http://www.stagexl.org/show/gaf/skeleton/example.html))

**[StageXL_BitmapFont](https://github.com/bp74/StageXL_BitmapFont):** [fontes bitmap](http://kvazars.com/littera/) são criadas com ferramentas especializadas ou até desenhadas no Photoshop, para renderizar textos com aparência sofisticada. Os glifos são armazenados em uma textura, para renderizar textos com muita eficiência em tempo de execução. A biblioteca de fontes bitmap do StageXL também oferece recursos como [campos de distância](http://www.stagexl.org/show/bitmapfont/distance_field/example.html), para bordas nítidas ao escalar ou rotacionar o texto. ([demo](http://www.stagexl.org/show/bitmapfont/texture_atlas/example.html))

<DashImage src="images/1mImI5oveZ9ohWbaxmFXarg.webp" alt="Spine animations rendered with StageXL." caption="Spine animations rendered with StageXL ([demo](http://www.stagexl.org/show/spine/texture-atlas/example.html))" />


## **Links** {:#links}

**StageXL:**
[StageXL no GitHub](https://github.com/bp74/StageXL)
[Exemplos do StageXL no GitHub](https://github.com/bp74/StageXL_Samples)
[Referência da API do StageXL](http://www.stagexl.org/docs/api/stagexl/stagexl-library.html)
[Fórum do StageXL](https://groups.google.com/forum/#!forum/stagexl)

**Runtimes:**
[Runtime do StageXL Spine](https://github.com/bp74/StageXL_Spine)
[Runtime do StageXL DragonBones
Runtime do StageXL GAF](https://github.com/bp74/StageXL_GAF)
[Fontes bitmap do StageXL](https://github.com/bp74/StageXL_BitmapFont)

**Jogos:**
[Memory](http://www.stagexl.org/example/game/memory) ([código-fonte](http://www.stagexl.org/example/game/memory/))
[Escape (portado do Flash)](http://www.stagexl.org/example/game/escape) ([código-fonte](https://github.com/bp74/StageXL_Samples/tree/master/example/game/escape))
[Supersonic (portado do Flash)](http://www.stagexl.org/example/game/supersonic) ([código-fonte](https://github.com/bp74/StageXL_Samples/tree/master/example/game/supersonic))

**Benchmarks:**
[Bunny Mark](http://www.stagexl.org/example/benchmark/bunny_mark)
[Starling](http://www.stagexl.org/example/benchmark/starling/)

**Projetos da comunidade:**
[Conversor de Flash/ActionScript para StageXL/Dart](https://github.com/blockforest/stagexl-converter-pubglobal)
[Framework Rockdot (UI e mais)](https://github.com/blockforest/rockdot-framework)
