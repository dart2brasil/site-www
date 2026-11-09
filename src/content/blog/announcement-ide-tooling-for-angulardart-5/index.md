---
ia-translate: true
title: "Anúncio: ferramentas de IDE para o AngularDart 5"
description: "Dart é uma linguagem estaticamente tipada que conhecemos e adoramos, e o Dart 2 será ainda mais rigoroso com tipos. É por isso que ele é uma ótima…"
publishDate: 2018-03-27
author: mfairhurst
image: images/1_8_-jlg2S62p_a8plKAtgg.webp
category: announcements
layout: blog
---


<DashImage src="images/1ZrNw6Wd0ZqQibsfXS8Gsng.webp" alt="IDE mostrando um template HTML do AngularDart com diagnósticos." />


Dart é uma linguagem estaticamente tipada que conhecemos e adoramos, e o Dart 2 será ainda mais rigoroso com tipos. É por isso que ele é uma plataforma tão boa para o framework Angular, em que os componentes são, em sua maioria, ligados estaticamente nos templates para criar UIs com bom desempenho.

Então, para melhorar ainda mais essa experiência de desenvolvimento produtiva e segura, estamos anunciando novas ferramentas de IDE que preservam essa segurança de tipos dentro dos seus templates! Elas dão suporte ao AngularDart 5 e funcionam direto no IntelliJ/WebStorm. Também dá para configurá-las para funcionar no VSCode, no vim e em outros editores.

Se você já está convencido, pode pular direto para a [configuração](#how-to-use), ou acompanhar um tour pelo que a nova integração com a IDE oferece!

## Erros {:#errors}

O novo plugin de análise encontra para você muitos erros de tipo dentro dos seus templates. As expressões são validadas em relação às diretivas que você usa, aos inputs que elas contêm e às referências que você vincula (`#foo`, `let item of`, …).

Aqui está um membro com erro de digitação, para você não ter que bancar o corretor ortográfico humano!

<DashImage src="images/0Ia1RMoPF9nmaAsIJ.webp" alt="Diagnóstico de template para o getter length digitado errado em uma IDE." />


E tipos incompatíveis em um input de componente também deixam de ser um problema.

<DashImage src="images/0LJKT0LftQFRjuKaN.webp" alt="IDE mostrando um erro de tipos incompatíveis em um input de componente." />


Também podemos mostrar erros relacionados aos tipos da variável `$event`,

<DashImage src="images/04UKHl3KVHtpV6Ysx.webp" alt="Diagnóstico de KeyboardEvent para uma propriedade de evento digitada errado em uma IDE." />


E verificamos o conteúdo que você transclui dentro das suas diretivas. Esse é um exemplo em que pegamos não só erros de tipo, mas também código morto.

<DashImage src="images/02nWPvm2BGmt1SGMZ.webp" alt="IDE mostrando um erro para conteúdo transcluído dentro de uma diretiva." />


E a lista continua! Pegamos uma série de outros tipos de erro, tanto nos templates quanto nas definições de componentes.

Além de serem destacados no editor, todos os erros são listados no painel Dart Analysis.

<DashImage src="images/1u34uyVu2qy_7p1xfxHFnCA.webp" alt="O painel Dart Analysis em uma IDE mostrando 2 erros e 5 avisos, incluindo 'Expected element decorator after whitespace'." />


## Autocompletar {:#autocomplete}

Não paramos na validação! Embora boa parte do trabalho tenha sido deixar nossa análise com bom desempenho e totalmente consistente com o compilador, boa parte do valor vem de usar esse estado resolvido do template para trazer a você a praticidade do autocompletar normal do Dart nos seus templates:

<DashImage src="images/1Qh5P6t4ccwezdMLWjAWw9Q.webp" alt="IDE mostrando autocompletar de métodos de lista em um template." />


Mas conseguimos completar mais do que membros normais do Dart. Que tal inputs, outputs e tags HTML?

Tags? Feito.

<DashImage src="images/1d3wuZHY5Ja52fe00u2jgSQ.webp" alt="IDE mostrando autocompletar de tags HTML." />


Atributos? Feito.

<DashImage src="images/1UlT5D-O_rajaFS_MCyHWsA.webp" alt="IDE mostrando autocompletar de atributos HTML, como bindings de title e eventos abort, em um template." />


Estrelas? Feito.

<DashImage src="images/13QMba2E4BETXmoi-5bG6gQ.webp" alt="IDE mostrando autocompletar de diretivas estruturais do AngularDart, como ngFor e ngIf, em um template." />


Atributos dentro das estrelas? Feito.

<DashImage src="images/1Ep9sEzWfe9Kife8HyMjvKw.webp" alt="Uma IDE mostrando autocompletar de inputs de template como 'template:' e 'trackBy:'." />


Ponto extra: sugestões de tags *com* atributos dentro de transclusões de componentes!

<DashImage src="images/1_8_-jlg2S62p_a8plKAtgg.webp" alt="IDE mostrando sugestões de tags com atributos dentro de transclusões de componentes." />


*Transclusão é um tema famoso por ser avançado no angular, então, se você acha que sabe exatamente o que estamos sugerindo, dê um tapinha nas próprias costas por conhecer muito bem o AngularDart.*

Basta dizer que as APIs de componentes ficam muito mais fáceis de acompanhar com o nosso plugin!

## Navegação {:#navigation}

O suporte aqui varia bem mais de um editor para outro, mas no IntelliJ você pode clicar em partes das expressões Dart para navegar. Em outros editores, talvez você consiga navegar por ainda mais entidades, como tags e inputs/outputs.

<DashImage src="images/1ceQlGeSCVnfOJqtHEITljQ.webp" alt="IDE mostrando a navegação de expressões de template até as definições relevantes." />


## Como usar {:#how-to-use}

Verifique se você está usando uma versão beta do AngularDart 5 e o Dart 2.0.0-dev.31 ou mais recente.

Basta adicionar isto ao seu arquivo [analysis_options.yaml](https://www.dartlang.org/guides/language/analysis-options#the-analysis-options-file):

```
analyzer:
  plugins:
    - angular
```


E reinicie a IDE. Observe que o plugin pode levar alguns segundos para iniciar. Primeiro ele precisa baixar os fontes e as dependências para você, e a primeira análise será mais lenta que as seguintes.

Você também pode experimentar no nosso [projeto de demonstração do plugin do analyzer](https://github.com/MichaelRFairhurst/dartconf-angular-plugin-lightning-demo).

Se você usa o IntelliJ, isso deve ser tudo. Outros editores podem não rodar nosso plugin em HTML sem um trabalho extra; o VSCode, por exemplo, exige [uma flag](https://github.com/Dart-Code/Dart-Code/issues/396#issuecomment-366058798).

## Feedback e mais {:#feedback-more}

O código-fonte dos nossos plugins fica [no Github](https://github.com/dart-lang/angular_analyzer_plugin), onde há mais informações sobre o que é suportado e onde você pode abrir issues se tiver dúvidas ou encontrar algum bug.

As novas ferramentas de IDE farão parte da próxima versão estável do AngularDart (v5). Estamos muito animados em oferecer uma produtividade ainda maior enquanto você escreve seus web apps Angular!
