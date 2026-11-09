---
ia-translate: true
title: "Anunciando o Dart 2: otimizado para o desenvolvimento client-side"
description: "Hoje anunciamos o Dart 2, uma reformulação da linguagem otimizada de forma única para o desenvolvimento client-side, na web e no mobile."
publishDate: 2018-02-22
author: asandholm
image: images/1E9T7YsI_ZU8gk4CewQg_QA.webp
category: releases
layout: blog
---


<DashImage src="images/1E9T7YsI_ZU8gk4CewQg_QA.webp" alt="A plush version of Dash, the blue mascot of Dart and Flutter. She has a long, brown beak and a tag attached that says 'Dart'." />


Hoje anunciamos o [Dart 2](http://dartlang.org), uma reformulação da linguagem para concretizar nossa visão do Dart: uma linguagem otimizada de forma única para o desenvolvimento client-side, na web e no mobile.

Com o Dart 2, fortalecemos e simplificamos muito o sistema de tipos, limpamos a sintaxe e reconstruímos boa parte da cadeia de ferramentas do desenvolvedor do zero, para tornar o desenvolvimento mobile e web mais agradável e produtivo. O Dart 2 também incorpora lições aprendidas com os primeiros adotantes da linguagem, incluindo o [Flutter](http://flutter.io), o [AdWords](https://news.dartlang.org/2016/03/the-new-adwords-ui-uses-dart-we-asked.html) e o [AdSense](https://news.dartlang.org/2016/10/google-adsense-angular-dart.html), além de milhares de melhorias, grandes e pequenas, em resposta ao feedback dos clientes.

## Os princípios fundamentais do Dart {:#darts-core-tenets}

Antes de falarmos mais sobre os avanços do Dart 2, vale identificar por que acreditamos que o Dart está bem posicionado para as necessidades de desenvolvedores client-side.

Além dos atributos necessários para uma linguagem moderna de propósito geral, o desenvolvimento client-side se beneficia de uma linguagem que seja:

* **Produtiva.** A sintaxe precisa ser clara e concisa, as ferramentas simples, e os ciclos de desenvolvimento quase instantâneos e no próprio dispositivo.

* **Rápida.** O desempenho e o tempo de inicialização em tempo de execução precisam ser ótimos e previsíveis, mesmo em dispositivos móveis pequenos.

* **Portátil.** Desenvolvedores client-side precisam pensar em três plataformas hoje: iOS, Android e Web. A linguagem precisa funcionar bem em todas elas.

* **Acessível.** A linguagem não pode se afastar muito do familiar se quiser continuar relevante para milhões de desenvolvedores.

* **Reativa.** Um estilo de programação reativo deve ser suportado pela linguagem.

O Dart já foi usado para lançar muitas aplicações de alta qualidade e missão crítica na web, no iOS e no Android, no Google e em outros lugares, e é uma ótima opção para desenvolvimento mobile e web:

* O Dart aumenta a velocidade do desenvolvedor porque tem uma sintaxe clara e sucinta e consegue rodar em uma VM com um compilador JIT. Isso permite o [hot reload com estado](https://flutter.io/hot-reload/) durante o desenvolvimento mobile, resultando em ciclos de desenvolvimento super rápidos, em que você pode editar o código, compilar e substituí-lo no app em execução no dispositivo.

* Com sua capacidade de compilar eficientemente para código nativo antecipadamente (AOT), o Dart oferece alto desempenho previsível e inicialização rápida em dispositivos móveis.

* O Dart suporta compilação para código nativo (ARM, x86 etc.) para desempenho rápido em dispositivos móveis, além de transpilação para JavaScript eficiente na web.

* O Dart é acessível para muitos desenvolvedores que já existem, graças a seus aspectos orientados a objetos sem surpresas e a uma sintaxe que — segundo nossos usuários — permite que qualquer desenvolvedor de C++, C#, Objective-C ou Java seja produtivo em questão de dias.

* O Dart funciona bem com programação reativa, com suas bibliotecas core testadas em batalha, incluindo streams e futures; ele também tem um excelente suporte para gerenciar objetos de vida curta por meio de seu coletor de lixo geracional rápido.

## Dart 2: melhor desenvolvimento client-side {:#dart-2-better-client-side-development}

No Dart 2, demos mais passos para consolidar o Dart como uma ótima linguagem para o desenvolvimento client-side. Em particular, adicionamos vários recursos novos, incluindo tipagem forte e uma forma melhor de definir a UI como código.

### Tipagem forte e sólida {:#strong-sound-typing}

As equipes por trás do AdWords e do AdSense construíram algumas das aplicações web mais avançadas e de maior porte do Google com Dart, para gerenciar os anúncios que geram uma grande parcela da receita do Google. Ao trabalhar de perto com essas equipes, identificamos uma grande oportunidade de fortalecer o sistema de tipos do Dart. Isso ajuda os desenvolvedores Dart a encontrar bugs mais cedo no processo de desenvolvimento, escalar melhor para apps construídos por equipes grandes e aumentar a qualidade geral do código.

Isso não é algo exclusivo, claro. No ecossistema web como um todo, há uma tendência crescente de adicionar anotações de tipo ao JavaScript. Por exemplo, [TypeScript](https://www.typescriptlang.org/) e [Flow](https://flow.org/) estendem o JavaScript com anotações e inferência de tipos para melhorar a capacidade de analisar o código.

No pequeno exemplo abaixo, a inferência de tipos do Dart 2 ajuda a descobrir um erro um tanto sutil e, como resultado, ajuda a melhorar a qualidade geral do código.

```dart
void main() {
  List<int> prices = ['99', '27', '10000', '20000000'];
  
  // Sort in place from smallest to largest
  prices.sort();
  
  print('Lowest price is ${prices[0]}!');
}
```

O que esse código faz? Você poderia razoavelmente esperar que ele imprimisse ‘27’. Mas sem o sistema de tipos sólido do Dart 2 habilitado, ele imprime ‘10000’, porque esse valor é, por acaso, o menor elemento da lista de strings quando ordenada lexicograficamente. Com o Dart 2, no entanto, esse código vai gerar um erro de tipo.

### UI como código {:#ui-as-code}

Ao criar a UI, ter que alternar entre uma linguagem de marcação de UI separada e a linguagem de programação em que você escreve seu app costuma gerar frustração. Estamos nos esforçando para fazer da definição de UI como código uma experiência agradável, para reduzir drasticamente a necessidade dessa troca de contexto. O Dart 2 introduz o `new` e o `const` opcionais. Esse recurso, muito pedido, é muito valioso por si só e também define a direção para [outras coisas que virão](https://github.com/dart-lang/sdk/issues/27678). Por exemplo, com o `new` e o `const` opcionais, podemos simplificar a definição de um widget de UI para que ele não use nenhuma palavra-chave.

```dart
// Before Dart 2
Widget build(BuildContext context) {
  return new Container(
    height: 56.0,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: new BoxDecoration(color: Colors.blue[500]),
    child: new Row(
      ...
    ),
  );
}

// After Dart 2
Widget build(BuildContext context) =>
  Container(
    height: 56.0,
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(color: Colors.blue[500]),
    child: Row(
      ...
    ),
  );
```

## Usos client-side do Dart {:#client-side-uses-of-dart}

### Mobile {:#mobile}

Um dos usos mais importantes do Dart é o [Flutter](http://flutter.io), o novo framework de UI mobile do Google para criar interfaces nativas de alta qualidade para iOS e Android. O [app oficial](https://developers.googleblog.com/2017/08/hamilton-app-takes-stage.html) do famoso musical [Hamilton](https://hamiltonmusical.com) é um exemplo do que o Flutter está permitindo que desenvolvedores construam em tempo recorde. O Flutter usa um estilo de programação reativo e controla toda a UI pixel a pixel. Para o Flutter, o Dart atende em termos de facilidade de aprendizado, programação reativa, grande velocidade de desenvolvimento e um runtime de alto desempenho com um coletor de lixo rápido.

### Web {:#web}

O Dart é uma plataforma comprovada para aplicações web de missão crítica. Ele tem bibliotecas específicas para a web, como o `dart:html`, além de um [framework web](https://webdev.dartlang.org/) completo baseado em Dart. Equipes que usam Dart para desenvolvimento web ficaram entusiasmadas com as melhorias na velocidade de desenvolvimento. Como explica Manish Gupta, VP de Engenharia do Google AdWords:
> O front-end do AdWords é grande e complexo, e é **crítico para a maior parte da receita do Google.**
> Escolhemos o Dart pela ótima combinação de **desempenho e previsibilidade, facilidade de aprendizado, um sistema de tipos sólido e suporte à web e ao mobile.**
> Nossos engenheiros são **duas a três vezes mais produtivos** do que antes, e estamos felizes por termos feito a troca.

## Olhando para frente {:#moving-forward}

Com o Flutter e o Dart, os desenvolvedores finalmente têm a oportunidade de escrever apps de qualidade de produção para Android, iOS e web, sem concessões, usando uma base de código compartilhada. Como resultado, os membros da equipe podem transitar com fluidez entre plataformas e ajudar uns aos outros, por exemplo, em revisões de código. Até agora, vimos equipes como o [AdWords Express](https://www.youtube.com/watch?v=PLHln7wHgPE) e o [AppTree](https://www.youtube.com/watch?v=GpLb2XvKv20) compartilhando entre 50% e 70% do código entre mobile e web.

O Dart é um [projeto open source](https://github.com/dart-lang) e um [padrão ECMA](https://www.ecma-international.org/publications/standards/Ecma-408.htm) aberto. Damos boas-vindas a contribuições tanto para o [projeto core do Dart](http://github.org/dart-lang/sdk/) quanto para o ecossistema de [pacotes para Dart](http://pub.dartlang.org), que não para de crescer.

Você pode testar o Dart 2 no [Flutter](https://github.com/flutter/flutter/wiki/Trying-the-preview-of-Dart-2-in-Flutter) e no [SDK do Dart](http://dartlang.org/install) pela linha de comando. Para o SDK do Dart, baixe o último pré-lançamento do Dart 2 pelo canal dev e lembre-se de rodar seu código com a flag `--preview-dart-2`. Também convidamos você a participar da nossa comunidade no [gitter](https://gitter.im/dart-lang/home).

Com as melhorias anunciadas hoje, o Dart 2 é uma linguagem produtiva, limpa e testada em batalha, que resolve os desafios do desenvolvimento moderno de apps. Ele já é adorado por alguns dos desenvolvedores mais exigentes do planeta, e esperamos que você também o adore.
