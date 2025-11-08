---
ia-translate: true
title: Perguntas frequentes sobre Dart
shortTitle: FAQ
description: Você tem perguntas sobre Dart, nós temos respostas.
---

{% assign pdf = '<i style="vertical-align: text-top" class="material-symbols">picture_as_pdf</i>' %}
{% assign site-repo = site.repo.this %}
{% assign sdk-repo = site.repo.dart.sdk %}
{% assign lang-repo = site.repo.dart.lang %}
{% assign ecma-pdf = 'https://ecma-international.org/wp-content/uploads' %}

Esta página reúne algumas das principais perguntas da comunidade.

## Geral

### P. Existe uma especificação para Dart?

Sim. [ECMA-408][ecma408] cobre a Especificação da Linguagem de Programação Dart.

Cinco versões foram publicadas.
A versão em andamento mais recente cobre até Dart 2.13-dev.

| Edição                | Publicada         | Aprovada      | Cobre até versão |
|-----------------------|-------------------|---------------|------------------|
| [6ª][6th-ed] {{pdf}}  | 24 de janeiro de 2024  |          | 2.13-dev         |
| [5ª][5th-ed] {{pdf}}  | 9 de abril de 2021     |          | 2.10             |
| [4ª][4th-ed] {{pdf}}  | 19 de agosto de 2015   | Dezembro 2015 | 1.11            |
| [3ª][3rd-ed] {{pdf}}  | 15 de abril de 2015    | Junho 2015    | 1.9             |
| [2ª][2nd-ed] {{pdf}}  | 21 de novembro de 2014 | Dezembro 2014 | 1.6             |
| [1ª][1st-ed] {{pdf}}  | 27 de março de 2014    | Junho 2014    | 1.3             |

{:.table .table-striped}

Para saber mais sobre a especificação, revise
a página [especificação da linguagem Dart](/resources/language/spec).

### P. Como vocês recebem feedback sobre mudanças no Dart?

A equipe ouve feedback, lê [issues][SDK issues]
e revisa patches de contribuidores.
Um contribuidor com um bom histórico pode receber
permissão de escrita no repositório.
Engenheiros do Google também trabalham no repositório público, fazendo mudanças visíveis.
O projeto recebeu muitos patches externos
e recebe bem committers distribuídos.

[ecma408]: https://ecma-international.org/publications-and-standards/standards/ecma-408/
[1st-ed]: {{ecma-pdf}}/ECMA-408_1st_edition_june_2014.pdf
[2nd-ed]: {{ecma-pdf}}/ECMA-408_2nd_edition_december_2014.pdf
[3rd-ed]: {{ecma-pdf}}/ECMA-408_3rd_edition_june_2015.pdf
[4th-ed]: {{ecma-pdf}}/ECMA-408_4th_edition_december_2015.pdf
[5th-ed]: /resources/language/spec/versions/DartLangSpec-v2.10.pdf
[6th-ed]: {{site.url}}/to/spec-draft

---

## Linguagem

### P. Dart não é muito parecido com Java?

Dart tem algumas semelhanças com Java.
Para revisar exemplos breves com sintaxe familiar,
revise os exemplos de código na [Introduction to Dart](/language).

### P. Como Dart se relaciona com Go?

O Google iniciou os projetos de linguagem Dart e Go.
Esses projetos independentes têm objetivos diferentes.
Como resultado, eles fazem escolhas diferentes.
As linguagens têm naturezas muito diferentes,
mas os membros das equipes aprendem com o trabalho uns dos outros.

### P. Por que Dart não é mais parecido com Haskell / Smalltalk / Python / Scala / outra linguagem?

Várias razões que dependem da linguagem de comparação.

**Linguagens que diferem de JavaScript**
: Dart deve compilar para JavaScript eficiente.
Linguagens fonte que diferem muito de JavaScript podem gerar código
de saída complexo para emular o comportamento da linguagem fonte.
Isso pode fazer com que o desempenho varie de maneiras não óbvias para o programador.

**Linguagens que compilam para código nativo**
: Dart prioriza compilação eficiente para código de máquina.
  Portanto, compartilha alguns aspectos com outras linguagens compiladas.

**Linguagens consideradas "mais dinâmicas" que Dart**
: Dart escolhe trocar parte dessa modificação arbitrária em tempo de execução
  para alcançar melhor desempenho e ferramentas mais produtivas.

### P. Por que a sintaxe do Dart não é mais empolgante?

Alguns recursos sintáticos agradáveis existem, como os argumentos de construtor `this.` e `=>`
para funções de uma linha.
Dart escolhe _familiaridade_ em vez de _empolgação_.

### P. Dart tem capacidades de reflection?

**Servidores e scripts de linha de comando**
: Sim, Dart suporta reflection através da [API mirrors][dart-mirror].

**Apps web ou Flutter**
: Não, Dart não suporta escrita em [apps web ou Flutter][Flutter no mirrors].

### P. Dart pode adicionar um recurso de linguagem que eu quero?

Versões futuras podem incluir um recurso que você deseja.
Alguns recursos não se encaixam na natureza da linguagem.
Alguns não funcionam bem com outros recursos.
Simplicidade é o presente mais importante a dar aos programadores futuros.

Para verificar se alguém já solicitou seu pedido,
revise o [language funnel][lang-funnel] e a
[lista de issues de linguagem][lang-issues].

* Se um issue existir, adicione seu joinha.
* Se um issue não existir, solicite um [novo issue][new-issue].

  Faça um argumento ponderado para seu recurso.
  Adicione evidências ao seu argumento. Inclua código de exemplo com e sem seu
  recurso ou uma base de código considerável.

Para saber mais, consulte o [processo de evolução da linguagem][lang-process].

Não se surpreenda se a equipe da linguagem Dart recusar seu pedido.
Remover um recurso de linguagem inflige mais dor do que adicionar um.
A equipe da linguagem Dart adiciona os recursos mais óbvios primeiro,
e revisita o próximo nível depois.

A comunidade solicitará mais recursos do que qualquer linguagem única
pode atender sem fazer uma bagunça total.
A equipe da linguagem Dart aprecia sugestões e evidências.
Essa apreciação deve se tornar aparente através de escolhas de design cuidadosas
e comunicação justa sobre elas.

---

## Tipagem

### P. Dart usa tipagem estática?

Sim, Dart usa tipagem estática. Para saber mais, consulte o [sistema de tipos do Dart][].

Combinando verificações estáticas e em tempo de execução, Dart tem um sistema de tipos sound.
Isso garante que uma expressão de um tipo não possa produzir um valor
de outro tipo.

Se você precisar da flexibilidade de uma tipagem dinâmica,
pode anotar qualquer variável com `dynamic`.
Este tipo `dynamic` é estático, mas pode conter qualquer tipo em _tempo de execução_.
Isso remove muitos benefícios de uma linguagem type-safe dessa variável.

### P. Por que os generics são covariantes?

Generics covariantes se encaixam em uma intuição comum que os programadores têm, e muito frequentemente
essa intuição está correta, como no uso comum "somente leitura" de um generic.
Embora essa intuição nem sempre esteja correta, Dart erra no lado da
conveniência ao ter generics covariantes.

A única outra variância padrão razoável seria invariância. Embora ter
apenas generics invariantes definitivamente preveniria mais erros, também
impediria muitos programas válidos ou exigiria conversão toda vez que você tivesse uma lista
de "maçãs", e alguém apenas quisesse "frutas".

Estamos familiarizados com uma variedade de maneiras que as linguagens tentam marcar ou inferir
variância. Sentimos que sistemas de inferência de variância adicionam muita complexidade
para seu benefício no Dart.

Novamente, estamos tentando ser pragmáticos, e achamos que o resultado é razoável.

---

## Uso e ferramentas

### P. Dart suporta JSON?

Sim. Para saber mais, consulte os conversores [JSON] na biblioteca [dart:convert][].

### P. Dart pode rodar no servidor?

Sim. Para saber mais, consulte [Dart on the Server].

### P. Como eu uso código de terceiros, ou compartilho código?

Procure por pacotes no [site pub.dev][pub],
o serviço de hospedagem de pacotes para Dart e Flutter.
Use o [comando `pub`][pub-cmd] para empacotar seu código e fazer upload para o site.

### P. Preciso usar um editor ou IDE específico para escrever código Dart?

Não. Você pode experimentar código Dart com [DartPad,][DartPad] e depois usar seu
editor ou IDE favorito para desenvolvimento. Algumas IDEs completas como IntelliJ IDEA,
WebStorm e Visual Studio Code têm plugins Dart. Plugins Dart de código aberto
também existem para vários editores. Para mais informações, veja as [ferramentas Dart][].

### P. Posso criar um app Android com Dart?

Sim! Você pode criar um app Android usando o framework [Flutter][Flutter]
e a linguagem Dart.
Qualquer app Flutter que você escrever também funcionará em iOS, web e plataformas desktop.

### P. Quais são alguns deployments de produção do mundo real do Dart?

Google Ads, AdSense, AdMob e o Google Assistant usam Dart.
Uma porção significativa da receita do Google flui através desses apps.
Dentro ou fora do Google, [cada app Flutter][FlutterShowcase] usa Dart.

[dart:convert]: {{site.dart-api}}/stable/dart-convert/dart-convert-library.html
[SDK issues]: {{sdk-repo}}/issues
[lang-issues]: {{lang-repo}}/issues
[lang-funnel]: {{lang-repo}}/projects/1
[lang-process]: {{lang-repo}}/blob/main/doc/life_of_a_language_feature.md
[pub]: {{site.pub}}
[announcement]: https://blog.chromium.org/2013/11/dart-10-stable-sdk-for-structured-web.html
[lang]: /language
[JSON]: {{site.dart-api}}/dart-convert/JsonCodec-class.html
[Dart on the Server]: /server
[Dart tools]: /tools/
[DartPad]: {{site.dartpad}}
[Flutter]: {{site.flutter}}
[Dart's type system]: /language/type-system
[Flutter no mirrors]: {{site.flutter-docs}}/resources/faq#does-flutter-come-with-a-reflection--mirrors-system
[FlutterShowcase]: {{site.flutter}}/showcase
[new-issue]: {{site-repo}}/issues/new/choose
[isolate]: {{site.dart-api}}/stable/dart-isolate/dart-isolate-library.html

---

## Execução nativa

### P. Dart é single-threaded?

Não. Em alvos nativos,
a [API isolate do Dart][isolate] pode iniciar múltiplas threads de execução quando necessário.
A Dart VM usa múltiplos núcleos de CPU para executar essas threads ao mesmo tempo.

A [arquitetura de concorrência do Dart](/language/concurrency) abstrai o código complexo
e propenso a erros do threading típico de memória compartilhada.
Isso pode explicar a concepção errada de que Dart é single-threaded.

A concorrência funciona de forma diferente em apps web Dart.
Para saber mais, consulte
[Dart é single-threaded na web?](#q-is-dart-single-threaded-on-the-web)

### P. Posso compilar código Dart para código nativo?

Sim. Ao compilar apps que visam dispositivos como desktops ou móveis,
[Dart Native](/overview#native-platform)
inclui tanto uma Dart VM com um compilador just-in-time (JIT) quanto um
compilador ahead-of-time (AOT) para produzir código nativo.

O framework [Flutter][] usa a capacidade de compilação nativa do Dart para produzir
apps nativos rápidos.

### P. Posso compilar um programa Dart para rodar em um terminal?

Sim. Programas Dart podem ser compilados para código nativo para rodar em um
Terminal macOS, prompt de comando Windows ou um shell Linux.

Consulte a documentação do [dart compile][].

### P. Qual é mais rápido: código compilado AOT ou JIT?

Depende.
Como Dart compila código produz apps com diferentes características de desempenho.

* Código compilado AOT inicia rápido com desempenho de execução consistente,
  sem latência durante as primeiras execuções.

* Código compilado JIT inicia mais lentamente, mas atinge desempenho máximo depois que roda
  tempo suficiente para aplicar otimizações de tempo de execução.

---

## Execução web

### P. Quais navegadores vocês suportam como alvos de compilação JavaScript?

O compilador web de _produção_ suporta as duas últimas versões principais dos
seguintes navegadores:

* Google Chrome
* Microsoft Edge
* Firefox
* Apple Safari

O [compilador JavaScript de _desenvolvimento_](/tools/webdev#serve) apenas
suporta Chrome para depuração.

### P. Dart é single-threaded na web?

De certa forma.
Apps web Dart não podem usar isolates.
Para alcançar concorrência de código, apps web usam [web workers][].
Web workers não têm a facilidade e eficiência de isolates,
e têm diferentes capacidades e restrições.
Para saber mais, consulte
[Concurrency on the web](/language/concurrency#concurrency-on-the-web).

[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers

### P. Qualquer código Dart válido será compilado para JavaScript?

Qualquer código Dart válido deve compilar para JavaScript.
Algumas bibliotecas rodam apenas no servidor ou no Flutter.
Considere a biblioteca `dart:io`.
Ela fornece acesso a arquivos e
diretórios do sistema operacional com APIs não disponíveis para o navegador.

### P. Por que Dart tem duas formas de compilar para JavaScript?

Ambas as formas usam o comando `webdev`.
O comando `webdev build` produz JavaScript minificado otimizado para
produção.
O comando `webdev serve` produz JavaScript modularizado otimizado para
depuração.

Para saber mais,
consulte a [referência do compilador JavaScript Dart](/tools/dart-compile#js)

### P. Como números de ponto flutuante são tratados quando compilados para JavaScript?

JavaScript tem apenas uma representação de número: um número de ponto flutuante
de dupla precisão IEEE-754. Isso significa que qualquer número—inteiro ou de ponto
flutuante—é representado como um double. JavaScript tem arrays de dados tipados,
e o mapeamento de listas tipadas nativas do Dart para arrays tipados JavaScript é trivial.

### P. Como Dart lida com inteiros ao compilar para JavaScript?

JavaScript armazena todos os [números como doubles][number-js].
Isso limita inteiros a precisão de 53 bits
com valores variando de -2<sup>53</sup> a 2<sup>53</sup>
JavaScript pode armazenar inteiros neste intervalo sem perda de precisão.
Como VMs JavaScript manipulam a representação interna de números,
permaneça dentro do intervalo small integer (SMI).
Em JavaScript, esse intervalo fica entre -2<sup>31</sup> a 2<sup>31</sup>
(-2.147.483.647 a 2.147.483.648 incluindo 0).

### P. Como listas tipadas são tratadas quando compiladas para JavaScript?

JavaScript oferece arrays tipados de 32 bits compatíveis com listas tipadas do Dart.
Isso mapeia como `Float32List` se tornando um `Float32Array`.
O compilador JavaScript de produção não suporta inteiros de 64 bits:
`Int64List` ou `Uint64List`. Compilar código Dart com
qualquer uma dessas listas resulta em uma exceção de tempo de execução.

[number-js]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#number_type
[ppwsize]: https://work.j832.com/2012/11/excited-to-see-dart2js-minified-output.html
[dart compile]: /tools/dart-compile
[dart analyze]: /tools/dart-analyze
[webdev]: /tools/webdev
[dart-mirror]: {{site.dart-api}}/dart-mirrors/dart-mirrors-library.html
[pub-cmd]: /tools/pub/cmd
