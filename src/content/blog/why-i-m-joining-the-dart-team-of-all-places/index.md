---
ia-translate: true
title: "Por que estou entrando na equipe do Dart, de todos os lugares"
description: "Duas semanas atrás, fui transferido para a equipe do Dart. Para muita gente, foi uma mudança de carreira óbvia, mas houve quem ficasse genuinamente surpreso."
publishDate: 2016-01-07
author: filiph
image: images/19XE0rGIm0oY0GOs5onZyvQ.webp
category: other
layout: blog
---


**ATUALIZAÇÃO de maio de 2018:** Já se passaram 2 anos e este artigo ainda recebe centenas de leituras por mês. Devo observar que algumas das coisas abaixo estão desatualizadas. Por exemplo, quando digo “em breve, você vai poder escrever código Dart para apps nativos de Android e iOS” mais abaixo, isso já é [muito possível](https://flutter.io/). Então, aproveite como uma peça histórica.

<DashImage src="images/1BMKEJA3Ej-Yxa6lx7mct7A.webp" alt="Comentário em rede social de Aleš Pecha dizendo: 'Uau, espero que você não esteja montando um cavalo morto, então ;)'." caption="Uma das respostas bem-intencionadas." />


As respostas variaram de leve espanto a provocações amigáveis e negatividade total. Não os culpo: para muita gente, o Dart é um bicho estranho. Dá para encontrar muitos desenvolvedores inteligentes na internet que acreditam firmemente que o Dart não vai dar certo ou que ele já fracassou.

Eu acredito firmemente no oposto. Posso estar errado, claro, mas tenho certeza suficiente sobre o Dart para apostar minha carreira nele.

Então, aqui vão alguns motivos pelos quais acredito no futuro brilhante do Dart. Obviamente, você deve ter em mente que *sou funcionário do Google, na equipe do Dart*. Sou tão parcial quanto alguém pode ser. Se você quer uma visão de quem não trabalha no Google, tem [outras](http://astashov.github.io/blog/2015/11/18/when-dart-is-a-good-choice/) [opções](http://mattbriggs.net/blog/2014/03/10/how-i-learned-to-stop-worrying/).

## **1. O Dart é um grande negócio no Google** {:#1-dart-is-a-big-deal-at-google}

<DashImage src="images/19XE0rGIm0oY0GOs5onZyvQ.webp" alt="Meme do filme Zoolander enfatizando, com humor, que o Dart é um grande negócio." caption="Referência obrigatória ao Zoolander." />


Não posso compartilhar os números reais (ainda?), mas há muito código Dart sendo escrito no Google. Muitas linhas de código. Todos os dias.

Quase todo esse código é crítico para a missão. O Dart é usado pela equipe de produtos que gera a maior parte da receita do Google.

Além disso, o Dart recentemente entrou para um clube exclusivo, formado por um punhado de linguagens de programação, que exige um processo especial de revisão de código no Google.

Em outras palavras, o Dart vai ser um sucesso mesmo que ninguém fora do Google o use. Uma comunidade animada é, claro, uma bênção enorme para qualquer tecnologia. Acontece que, no caso do Dart, isso definitivamente não é um requisito para sobreviver neste momento.

## **2. O Dart tem uma manutenção muito ativa** {:#2-dart-is-very-actively-maintained}

O Dart está estável agora (atualmente na v1.13), mas isso não significa que o trabalho nele tenha parado ou sequer diminuído. Se você olhar para [github.com/dart-lang](https://github.com/dart-lang), vai ver 139 repositórios relacionados ao Dart mantidos pelo Google. Vamos dar uma olhada apenas no repositório principal ([sdk](https://github.com/dart-lang/sdk)).

No último mês, que incluiu as férias de Natal, o GitHub Pulse [mostra](https://github.com/dart-lang/sdk/pulse/monthly):
> # *Excluindo merges, **32** autores enviaram **408** commits para a master e 412 commits para todas as branches. Na master, 828 arquivos foram alterados, com 93.059 adições e 88.236 remoções.*

Compare esses números com os de outros projetos semelhantes, desenvolvidos em código aberto, como [Rust](https://github.com/rust-lang/rust/pulse/monthly), [Go](https://github.com/golang/go/pulse/monthly), [Scala](https://github.com/scala/scala/pulse/monthly), [TypeScript](https://github.com/Microsoft/TypeScript/pulse/monthly) ou [Ruby](https://github.com/ruby/ruby/pulse/monthly).

Não estou dizendo que a velocidade de commits seja equivalente à qualidade, nem nada do tipo. Mas ela deve dizer algo sobre o investimento, o foco e o ritmo de melhoria.

Linguagens de programação e suas bibliotecas padrão são criaturas complexas que nunca ficam prontas.

Uma fantasia popular entre programadores é que você projeta um sistema belo e elegante e então — ele simplesmente funciona. A palavra-chave aqui é: "fantasia". Sim, as tecnologias que usamos todos os dias costumam ter um design elegante, mas, *mais importante*, as melhores têm uma quantidade enorme de trabalho (e retrabalho) por trás.

E não se trata só de quantidade, claro. A equipe por trás do Dart é formada por engenheiros de software experientes do Google. Pessoas como Kasper e Lars (famosos pelo V8), Gilad (famoso pela especificação da linguagem Java) e John (famoso pelo inotify) contribuem todos os dias. E ainda há participações especiais, como Erik (famoso por C# e Rx). Na minha opinião, a qualidade dos engenheiros é o melhor indicador da qualidade da tecnologia que eles constroem.

## **3. Em breve o Dart vai rodar em qualquer lugar** {:#3-dart-will-soon-run-everywhere}

O primeiro alvo do Dart foi a web, mas desde o início ele foi projetado como uma linguagem de programação de propósito geral.

<YoutubeEmbed id="jjffmNHYHlc" title="Exemplo do Jogo da Vida de Conway em Dart, rodando em Raspberry Pi + Sense HAT" fullwidth="true"/>


* Você pode compilar Dart para JavaScript, que roda em qualquer navegador.

* Você pode escrever ferramentas de linha de comando e até servidores em Dart.

* [Em breve](http://dart-lang.github.io/fletch/), você poderá escrever código Dart para microprocessadores (pense no Raspberry Pi) e, mais interessante ainda, para microcontroladores (pense no Arduino). Isso significa que desenvolver para dispositivos realmente compactos, baratos e de baixo consumo deixa de ser um clube exclusivo de C/C++/asm.

* [Em breve](http://flutter.io/), você poderá escrever código Dart para apps nativos de Android e iOS.

## **4. O Dart é estável e consistente** {:#4-dart-is-stable-and-consistent}

Tenho notado que até os primeiros adotantes estão cansados da mudança constante nas ferramentas e bibliotecas da moda.

O Dart está evoluindo, sim, mas os projetos que você escreveu há um ou dois anos ainda usam a mesma biblioteca padrão, os mesmos recursos da linguagem e o mesmo gerenciador de pacotes e dependências.

Além disso, existem jeitos "dartísticos" de fazer as coisas: a maior parte do código Dart que vi segue o [Guia de Estilo](https://www.dartlang.org/effective-dart/) oficial, o Guia de Uso e o Guia de Design. A legibilidade é valorizada na comunidade Dart.

## **5. Programar em Dart parece certo (para mim)** {:#5-programming-in-dart-feels-right-to-me}

Ok, isso é subjetivo. Mas, convenhamos, nossas escolhas de stack de desenvolvimento geralmente são. Se puder evitar, você tende a usar o que parece certo para você. Alguns desenvolvedores adoram JavaScript, outros o odeiam, apesar de ser a mesma linguagem. O mesmo vale para Java, PHP, Ruby ou Dart.

Um grande motivo pelo qual estou perfeitamente disposto a apostar minha carreira no Dart é que não sou só eu. Há [muita gente](http://www.cnet.com/news/mixbook-sees-perfect-storm-for-googles-dart-language-q-a/) [inteligente](http://suretalent.blogspot.cz/2012/04/dart-language-in-javascript-and-delphi.html) que usa a linguagem e gosta da experiência, como [neste relato](http://simonpai.github.io/2014/09/03/quire-building-with-dart/) e [nesta discussão](https://news.ycombinator.com/item?id=8222640).

<YoutubeEmbed id="6p-Z6TXoN10" title="Notch recriando o Doom em Dart (trecho de transmissão)" fullwidth="true"/>


Por quê? O Dart não é para todo mundo, mas, para um certo tipo de desenvolvedor, ele pode ser um sopro de ar fresco.

* É familiar (nada de sintaxe esquisita), especialmente se você vem de C#, ActionScript, Java, C e afins.

* É previsível (nada de semântica bizarra).

* Ele não atrapalha o seu caminho (tipos *opcionais*, falta de solidez, GC, tudo é objeto, mirrors)…

* … mas permite escrever código robusto (*tipos* opcionais, generics opcionais, bibliotecas, pacotes, transformers).

* Facilita as coisas usuais (async/await, interpolação de strings, this.field, operadores null-aware).

* Vem com uma biblioteca padrão bem pensada.

Então é isso. Durante 2016, acho que boa parte do que descrevi acima vai começar a fazer mais sentido para mais pessoas.

Mas, pelo menos agora, você sabe por que (acho que) minha transferência para a equipe do Dart não é um completo lapso de juízo.
