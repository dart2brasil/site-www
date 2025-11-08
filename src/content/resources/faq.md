---
title: Dart FAQ
shortTitle: FAQ
description: You have questions about Dart, we have answers.
---

{% assign pdf = '<i style="vertical-align: text-top" class="material-symbols">picture_as_pdf</i>' %}
{% assign site-repo = site.repo.this %}
{% assign sdk-repo = site.repo.dart.sdk %}
{% assign lang-repo = site.repo.dart.lang %}
{% assign ecma-pdf = 'https://ecma-international.org/wp-content/uploads' %}

Esta página reúne algumas das principais perguntas da comunidade.

## Geral {:#general}

### P. Existe uma especificação para Dart? {:#q-is-there-a-specification-for-dart}

Yes. [ECMA-408][ecma408] covers the Dart Programming Language Specification.

Cinco versões foram publicadas.
A versão mais recente em andamento cobre até o Dart 2.13-dev.

| Edição               | Publicado         | Aprovado      | Cobre até a versão |
|-----------------------|-------------------|---------------|-------------------|
| [6ª][6th-ed] {{pdf}} | 24 de janeiro de 2024  |               | 2.13-dev          |
| [5ª][5th-ed] {{pdf}} | 9 de abril de 2021     |               | 2.10              |
| [4ª][4th-ed] {{pdf}} | 19 de agosto de 2015   | Dezembro de 2015 | 1.11              |
| [3ª][3rd-ed] {{pdf}} | 15 de abril de 2015    | Junho de 2015     | 1.9               |
| [2ª][2nd-ed] {{pdf}} | 21 de novembro de 2014 | Dezembro de 2014 | 1.6               |
| [1ª][1st-ed] {{pdf}} | 27 de março de 2014    | Junho de 2014     | 1.3               |

{:.table .table-striped}

Para saber mais sobre a especificação, revise a página
[especificação da linguagem Dart](/resources/language/spec).

### P. Como vocês recebem feedback sobre as mudanças no Dart? {:#q-how-are-you-taking-input-on-changes-to-dart}

A equipe ouve o feedback, lê [issues][SDK issues] (relatos de problemas)
e revisa patches (correções) de colaboradores.
Um colaborador com um bom histórico pode receber permissão de escrita no repositório.
Engenheiros do Google também trabalham no repositório público,
tornando as mudanças visíveis.
O projeto recebeu muitos patches externos e
recebe committers (desenvolvedores que enviam alterações) distribuídos.

[ecma408]: https://ecma-international.org/publications-and-standards/standards/ecma-408/
[1st-ed]: {{ecma-pdf}}/ECMA-408_1st_edition_june_2014.pdf
[2nd-ed]: {{ecma-pdf}}/ECMA-408_2nd_edition_december_2014.pdf
[3rd-ed]: {{ecma-pdf}}/ECMA-408_3rd_edition_june_2015.pdf
[4th-ed]: {{ecma-pdf}}/ECMA-408_4th_edition_december_2015.pdf
[5th-ed]: /resources/language/spec/versions/DartLangSpec-v2.10.pdf
[6th-ed]: {{site.url}}/to/spec-draft

---

## Linguagem {:#language}

### P. Dart não é muito parecido com Java? {:#q-isnt-dart-a-lot-like-java}

Dart tem algumas semelhanças com Java.
Para revisar exemplos breves com sintaxe familiar,
revise as amostras de código na [Introdução ao Dart](/language).

### P. Como Dart se relaciona com Go? {:#q-how-does-dart-relate-to-go}

O Google iniciou os projetos de linguagem Dart e Go.
Esses projetos independentes têm objetivos diferentes.
Como resultado, eles fazem escolhas diferentes.
As linguagens têm naturezas muito diferentes,
mas os membros da equipe aprendem com o trabalho uns dos outros.

### P. Por que Dart não é mais parecido com Haskell / Smalltalk / Python / Scala / outra linguagem? {:#q-why-isnt-dart-more-like-haskell-smalltalk-python-scala-other-language}

Várias razões que dependem da linguagem de comparação.

**Linguagens diferem de JavaScript**
: Dart deve ser compilado para JavaScript eficiente.
Linguagens de origem que diferem muito do JavaScript podem gerar
código de saída complexo para emular o comportamento da linguagem de origem.
Isso pode fazer com que o desempenho varie de maneiras não óbvias para o programador.

**Linguagens que compilam para código nativo**
: Dart prioriza a compilação eficiente para código de máquina.
Portanto, ele compartilha alguns aspectos com outras linguagens compiladas.

**Linguagens que são consideradas "mais dinâmicas" do que Dart**
: Dart opta por trocar parte dessa modificação arbitrária em tempo de execução
para obter melhor desempenho e ferramentas mais produtivas.

### P. Por que a sintaxe de Dart não é mais empolgante? {:#q-why-isnt-dart-syntax-more-exciting}

Alguns recursos sintáticos interessantes existem, como os argumentos do
construtor `this.` e `=>` para funções de uma linha.
Dart escolhe _familiaridade_ em vez de _excitação_.

### P. Dart tem recursos de reflection (reflexão)? {:#q-does-dart-have-reflection-capabilities}

**Servidores e scripts de linha de comando**
: Sim, Dart suporta reflection da [API mirrors][dart-mirror].

**Aplicativos web ou Flutter**
: Não, Dart não suporta gravação para [aplicativos web ou Flutter][Flutter no mirrors].

### Q. Can Dart add a language feature that I want?

Futuros lançamentos podem incluir um recurso que você deseja.
Alguns recursos não se encaixam na natureza da linguagem.
Alguns não funcionam bem com outros recursos.
Simplicidade é o presente mais importante a dar aos futuros programadores.

Para verificar se alguém registrou sua solicitação,
revise o [funil de linguagem][lang-funnel] e a
[lista de issues de linguagem][lang-issues].

* Se um issue (relato de problema) existir, adicione seu joinha.
* Se um issue não existir, solicite um [novo issue][new-issue].

  Faça um argumento ponderado para seu recurso.
  Adicione evidências ao seu argumento. Inclua um exemplo de
  código com e sem o seu recurso ou uma base de código considerável.

Para saber mais, consulte o [processo de evolução da linguagem][lang-process].

Não se surpreenda se a equipe de linguagem Dart recusar sua solicitação.
Remover um recurso de linguagem causa mais dor do que adicionar um.
A equipe de linguagem Dart adiciona os recursos mais óbvios primeiro
e revisita a próxima camada mais tarde.

A comunidade solicitará mais recursos do que qualquer linguagem
pode atender sem fazer uma bagunça total.
A equipe de linguagem Dart aprecia sugestões e evidências.
Essa apreciação deve se tornar aparente através de escolhas de design cuidadosas
e comunicação justa sobre elas.

---

## Tipagem {:#typing}

### P. Dart usa tipagem estática? {:#q-does-dart-use-static-typing}

Sim, Dart usa tipagem estática. Para saber mais, consulte o [sistema de tipos do Dart][Dart's type system].

Combinando verificações estáticas e em tempo de execução, Dart tem um sistema de tipos _sound_ (sólido).
Isso garante que uma expressão de um tipo não possa produzir um
valor de outro tipo.

Se você precisar da flexibilidade de uma tipagem dinâmica,
pode anotar qualquer variável com `dynamic`.
Este tipo `dynamic` é estático, mas pode conter qualquer tipo em _tempo de execução_.
Isso remove muitos benefícios de uma linguagem _type-safe_ (com segurança de tipos) dessa variável.

### P. Por que os genéricos são covariantes? {:#q-why-are-generics-covariant}

Genéricos covariantes se encaixam em uma intuição comum que os programadores têm, e muitas vezes
essa intuição está correta, como no uso comum "somente leitura" de um genérico.
Embora essa intuição nem sempre esteja correta, Dart está errando por excesso
de conveniência ao ter genéricos covariantes.

A única outra variância padrão razoável seria a invariância. Embora ter
apenas genéricos invariantes definitivamente impediria mais erros, também impediria
muitos programas válidos ou exigiria conversão sempre que você tivesse uma lista
de "maçãs" e alguém apenas quisesse "frutas".

Estamos familiarizados com uma variedade de maneiras pelas quais as linguagens tentam marcar ou inferir
variância. Sentimos que os sistemas de inferência de variância adicionam muita complexidade
para seu benefício em Dart.

Novamente, estamos tentando ser pragmáticos e achamos que o resultado é razoável.

---

## Uso e ferramentas {:#usage-and-tools}

### P. Dart suporta JSON? {:#q-does-dart-support-json}

Sim. Para saber mais, consulte os conversores [JSON] na biblioteca [dart:convert][dart:convert].

### P. Dart pode ser executado no servidor? {:#q-can-dart-run-on-the-server}

Sim. Para saber mais, consulte [Dart no Servidor].

### P. Como uso código de terceiros ou compartilho código? {:#q-how-do-i-use-third-party-code-or-share-code}

Pesquise pacotes no site [pub.dev][pub],
o serviço de hospedagem de pacotes para Dart e Flutter.
Use o comando [`pub`][pub-cmd] para empacotar seu código e enviá-lo para o site.

### P. Preciso usar um editor ou IDE específico para escrever código Dart? {:#q-do-i-need-to-use-a-particular-editor-or-ide-to-write-dart-code}

Não. Você pode experimentar o código Dart com o [DartPad,][DartPad] e depois
usar seu editor ou IDE favorito para desenvolvimento. Alguns IDEs completos,
como IntelliJ IDEA, WebStorm e Visual Studio Code, têm plugins Dart. Plugins
Dart de código aberto também existem para vários editores. Para mais informações, consulte as [ferramentas Dart][Dart tools].

### P. Posso construir um aplicativo Android com Dart? {:#q-can-i-build-an-android-app-with-dart}

Sim! Você pode construir um aplicativo Android usando o framework[Flutter][Flutter]
e a linguagem Dart.
Qualquer aplicativo Flutter que você escrever também funcionará no iOS, na web e em plataformas desktop.

### P. Quais são algumas implantações de produção do mundo real de Dart? {:#q-what-are-some-real-world-production-deployments-of-dart}

Google Ads, AdSense, AdMob e Google Assistant usam Dart.
Uma parte significativa da receita do Google passa por esses aplicativos.
Dentro ou fora do Google, [cada aplicativo Flutter][FlutterShowcase] usa Dart.

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

## Execução nativa {:#native-execution}

### P. Dart é single-threaded (de thread único)? {:#q-is-dart-single-threaded}

Não. Em alvos nativos, a
[API isolate do Dart][isolate] pode iniciar várias threads de execução quando necessário.
A VM do Dart usa vários núcleos de CPU para executar essas threads ao mesmo tempo.

A [arquitetura de concorrência do Dart](/language/concurrency) abstrai o
código complexo e propenso a erros de threading típico de memória compartilhada.
Isso pode explicar o equívoco de que Dart é single-threaded.

A concorrência funciona de forma diferente em aplicativos web Dart.
Para saber mais, consulte
[Dart é single-threaded na web?](#q-is-dart-single-threaded-on-the-web)

### P. Posso compilar código Dart para código nativo? {:#q-can-i-compile-dart-code-to-native-code}

Sim. Ao compilar aplicativos que visam dispositivos como desktops ou celulares,
[Dart Native](/overview#native-platform) inclui um VM Dart com um
compilador _just-in-time_ (JIT) e um
compilador _ahead-of-time_ (AOT) para produzir código nativo.

O framework [Flutter][Flutter] usa a capacidade de compilação nativa do Dart para produzir
aplicativos nativos rápidos.

### P. Posso compilar um programa Dart para execução em um terminal? {:#q-can-i-compile-a-dart-program-for-running-in-a-terminal}

Sim. Programas Dart podem ser compilados para código nativo para execução em um
Terminal macOS, prompt de comando do Windows ou shell Linux.

Consulte a documentação [dart compile][dart compile].

### P. Qual é mais rápido: código compilado AOT ou JIT? {:#q-which-is-faster-aot-or-jit-compiled-code}

Depende.
Como o Dart compila o código, produz aplicativos com diferentes características de desempenho.

* O código compilado AOT é iniciado rapidamente com desempenho de tempo de execução consistente,
  sem latência durante as primeiras execuções.

* O código compilado JIT inicia mais lentamente, mas atinge o pico de desempenho depois de ser executado
  por tempo suficiente para aplicar otimizações em tempo de execução.

---

## Execução na web {:#web-execution}

### P. Quais navegadores vocês suportam como alvos de compilação JavaScript? {:#q-what-browsers-do-you-support-as-javascript-compilation-targets}

O compilador web de _produção_ suporta as duas últimas versões principais
dos seguintes navegadores:

* Google Chrome
* Microsoft Edge
* Firefox
* Apple Safari

O compilador JavaScript de _desenvolvimento_](/tools/webdev#serve)
oferece suporte apenas ao Chrome para depuração.

### P. Dart é single-threaded na web? {:#q-is-dart-single-threaded-on-the-web}

De certa forma.
Aplicativos web Dart não podem usar _isolates_.
Para obter concorrência de código, os aplicativos web usam [web workers][web workers].
Web workers carecem da facilidade e eficiência dos _isolates_,
e têm capacidades e restrições diferentes.
Para saber mais, consulte
[Concorrência na web](/language/concurrency#concurrency-on-the-web).

[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers

### P. Qualquer código Dart válido será compilado para JavaScript? {:#q-will-any-valid-dart-code-compile-to-javascript}

Qualquer código Dart válido deve ser compilado para JavaScript.
Algumas bibliotecas são executadas apenas no servidor ou no Flutter.
Considere a biblioteca `dart:io`.
Ela fornece acesso a arquivos do sistema operacional
e diretórios com APIs não disponíveis para o navegador.

### P. Por que Dart tem duas maneiras de compilar para JavaScript? {:#q-why-does-dart-have-two-ways-to-compile-to-javascript}

Ambas as formas usam o comando `webdev`.
O comando `webdev build` produz JavaScript minificado otimizado para
produção.
O comando `webdev serve` produz JavaScript modularizado otimizado para
depuração.

Para saber mais,
consulte a [referência do compilador JavaScript do Dart](/tools/dart-compile#js)

### P. Como os números de ponto flutuante são tratados quando compilados para JavaScript? {:#q-how-are-floating-point-numbers-handled-when-compiled-to-javascript}

JavaScript tem apenas uma representação de número: um número de ponto flutuante
de dupla precisão IEEE-754. Isso significa que qualquer número - inteiro ou
de ponto flutuante - é representado como um double. JavaScript tem arrays de
dados tipados, e o mapeamento de listas tipadas nativas do Dart para arrays tipados do JavaScript é trivial.

### P. Como Dart trata inteiros ao compilar para JavaScript? {:#q-how-does-dart-handle-integers-when-compiling-to-javascript}

JavaScript armazena todos os [números como doubles][number-js].
Isso limita os inteiros a uma precisão de 53 bits
com valores variando de -2<sup>53</sup> a 2<sup>53</sup>
JavaScript pode armazenar inteiros nesse intervalo sem perda de precisão.
À medida que as VMs JavaScript manipulam a representação interna de números,
fique dentro do intervalo de inteiros pequenos (SMI).
Em JavaScript, esse intervalo fica entre -2<sup>31</sup> e 2<sup>31</sup>
(-2.147.483.647 a 2.147.483.648, incluindo 0).

### P. Como as listas tipadas são tratadas quando compiladas para JavaScript? {:#q-how-are-typed-lists-handled-when-compiled-to-javascript}

JavaScript oferece arrays tipados de 32 bits compatíveis com as listas tipadas do Dart.
Isso mapeia como `Float32List` se tornando um `Float32Array`.
O compilador JavaScript de produção não suporta inteiros de 64 bits:
`Int64List` ou `Uint64List`. Compilar código Dart com
qualquer uma dessas listas resulta em uma exceção em tempo de execução.

[number-js]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#number_type
[ppwsize]: https://work.j832.com/2012/11/excited-to-see-dart2js-minified-output.html
[dart compile]: /tools/dart-compile
[dart analyze]: /tools/dart-analyze
[webdev]: /tools/webdev
[dart-mirror]: {{site.dart-api}}/dart-mirrors/dart-mirrors-library.html
[pub-cmd]: /tools/pub/cmd
