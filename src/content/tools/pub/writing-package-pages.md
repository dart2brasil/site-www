---
title: Writing package pages
description: Learn how to write a good package page.
ia-translate: true
---

<style>
  .screenshot, .screenshot-narrow {
    border-style: solid;
    border-width: 1px;
    border-color: var(--site-outline);
    margin: 0 20px;
    padding: 10px;
    width: 90%;
  }

  .screenshot-narrow {
    max-width: 400px;
  }
</style>

As diretrizes nesta página podem ajudá-lo a criar boas páginas de pacotes no pub.dev.
Especificamente, esta página tem dicas para
escrever um melhor README de pacote,
que fornece o conteúdo marcado como **README (this document)**
na seguinte captura de tela:

<img 
  src="/assets/img/libraries/package-page-sections.png"
  alt="package page contains sections like package layout, flutter favorite, package scoring, verified publishers, pubspec file" 
  class="screenshot diagram-wrap">

Para detalhes sobre outras partes da página do pacote,
siga estes links:

1. [Package layout ](/tools/pub/package-layout)
2. [Flutter Favorite]({{site.flutter-docs}}/development/packages-and-plugins/favorites)
3. [Package scoring]({{site.pub}}/help/scoring)
4. [Verified publishers](/tools/pub/verified-publishers)
5. [Pubspec file](/tools/pub/pubspec)


## Escrever um bom README é importante

As pessoas que encontram seu pacote no pub.dev provavelmente
escanearão rapidamente o README ao decidir se devem experimentar seu pacote.
Um bom README chama a atenção do leitor e
mostra que seu pacote vale a pena experimentar.

:::note
O README do pacote é usado de várias maneiras.
Por exemplo, seu conteúdo aparece não apenas na página do pacote no pub.dev,
mas também na documentação de referência da API produzida pelo [`dart doc`][].
:::

Embora esta página apresente o README do pacote [`in_app_purchase`][],
o seu pode não precisar ser tão grande ou detalhado.
Se o seu pacote for simples e não tiver interface de usuário associada,
seu README pode se parecer mais com o do pacote [`yaml`][]. 


## Sete dicas para um bom README

Aqui estão algumas sugestões para criar um README
que funcione bem no pub.dev:

1. [Coloque uma descrição curta no topo](#tip1)
2. [Inclua conteúdo visual](#tip2)
3. [Use listas para apresentar informações importantes](#tip3)
4. [Inclua exemplos de uso](#tip4)
5. [Use formatação de código Dart](#tip5)
6. [Mencione termos relacionados](#tip6)
7. [Diga aos usuários para onde ir em seguida](#tip7)


### 1. Coloque uma descrição curta no topo {:#tip1}

De acordo com nossa pesquisa com usuários,
os usuários de pacotes gastam apenas alguns segundos para
ler a descrição do pacote e decidir se devem
ler o resto do README.
Portanto, você deve descrever de forma concisa o que o pacote faz ou alcança,
de relance.
Gaste algum tempo para criar uma descrição curta e simples e
ajude o usuário a tomar decisões.

:::tip
Não escreva o nome do pacote novamente no topo.
Ele já está visível na interface do pub.dev.
:::

Aqui estão alguns exemplos de boas descrições:

*   `A Flutter plugin for showing rainbows.`
*   `Use machine learning to categorize bird sounds.`

Informações importantes, como status do projeto ou restrições,
também devem estar próximas ao topo.
Por exemplo:

*   `Does not work on iOS versions below 10.3.`

Aqui está uma captura de tela da página do pacote [`in_app_purchase`][],
que começa com uma breve explicação do pacote e uma advertência:

<img 
  src="/assets/img/libraries/package-page-description.png"
  alt="description of the package in_app_purchase" 
  class="screenshot">

[Badges][] geralmente ficam próximos ao topo do README,
acima ou abaixo da descrição curta.


### 2. Inclua conteúdo visual {:#tip2}

Se a página do seu pacote for uma parede de texto sem conteúdo visual,
os usuários podem achá-la intimidadora e parar de ler.
Imagens são especialmente importantes se seu pacote suporta interface de usuário,
mas também são úteis para explicar conceitos importantes.
De qualquer forma, o conteúdo visual pode ajudar os usuários
a se sentirem confiantes sobre o uso do pacote.

Coloque conteúdo visual, como imagens estáticas, GIFs animados e
vídeos (como arquivos MOV ou MP4)
perto do início do README,
onde os usuários provavelmente os verão.

:::tip
Prefira GIFs animados e vídeos para conteúdo relacionado a interface de usuário,
porque a maioria das interfaces não é estática,
e a animação transmite mais informações sobre o comportamento da interface.
:::

As capturas de tela abaixo mostram como
adicionar conteúdo visual fez a página do pacote `in_app_purchase` parecer informativa à primeira vista.
(A imagem _antes_ está à esquerda; _depois_ está à direita.)

<img 
  src="/assets/img/libraries/package-page-example-iap.png"
  alt="in_app_purchase readme without and with images" 
  class="screenshot">

:::tip
Ao adicionar conteúdo visual,
use URLs absolutas para os arquivos
para fazer as imagens aparecerem de forma confiável,
não importa onde o README seja publicado.
Um lugar para hospedar suas imagens é no próprio repositório,
como `in_app_purchase` faz.
:::


### 3. Use listas para apresentar informações importantes {:#tip3}

Listas podem chamar a atenção para informações importantes no seu README.
Você pode usar listas para o seguinte:

*   [Recursos-chave do pacote](#list1)
*   [Parâmetros, atributos ou propriedades](#list2)
*   [Requisitos incomuns](#list3)
*   [Funcionalidade que está fora do escopo do seu pacote](#list4)
*   [Um resumo do conteúdo de uma página ou de uma seção dentro de uma página
    (como esta lista)](#list5)

Geralmente, as listas são com marcadores, como a lista acima.
Outra opção é usar uma tabela,
como a tabela de suporte de plataforma na próxima seção.


#### Recursos-chave do pacote {:#list1}

Primeiro, liste claramente o que seu pacote pode fazer.
Alguns usuários podem estar procurando por um recurso muito específico.
Ajude esses usuários a descobrir se seu pacote atende às necessidades deles.

A seguinte captura de tela mostra como o README do `in_app_purchase`
apresenta os recursos do pacote:

<img 
  src="/assets/img/libraries/package-page-features-list.png"
  alt="list of features of the package in_app_purchase" 
  class="screenshot">

A próxima captura de tela mostra uma tabela do README do `just_audio`
que lista os recursos do pacote e o suporte de plataforma:

<img
  src="/assets/img/libraries/package-page-features-table.png"
  alt="list of features of the package just_audio in a table format"
  class="screenshot-narrow">


#### Parâmetros, atributos ou propriedades {:#list2}

Considere listar parâmetros, atributos ou propriedades para referência rápida.
(Lembre-se, o conteúdo do README do pacote aparece na
documentação de referência da API, bem como na página do pacote.)

Por exemplo, o pacote `url_launcher` tem uma tabela de esquemas de URL suportados:

<img
  src="/assets/img/libraries/package-page-list-property.png"
  alt="list of supported schemes of the package url_launcher"
  class="screenshot">

Vincular a funções ou classes específicas
na documentação de referência da API também pode ser útil.
Veja o pacote [async]({{site.pub-pkg}}/async) para um exemplo.


#### Requisitos incomuns {:#list3}

Se seu pacote precisa de uma configuração específica, além do que todos os pacotes requerem,
liste as instruções de configuração no README.

Por exemplo, a seguinte captura de tela para o pacote `google_maps_flutter`
mostra instruções sobre como começar com o Google Maps Platform:

<img
  src="/assets/img/libraries/package-page-list-requirements.png"
  alt="additional instructions to use google_maps_flutter"
  class="screenshot">


#### Funcionalidade que está fora do escopo do seu pacote {:#list4}

Para ajudar os usuários a saber se seu pacote pode ajudá-los,
liste os recursos que os usuários podem esperar,
mas que seu pacote _não_ suporta.

Aqui estão alguns exemplos de quando
você pode querer listar funcionalidades fora do escopo:

* Se o seu pacote de botões é focado apenas em botões de texto
  e não em botões de ícone,
  deixe isso claro no README.
* Se o seu pacote suporta apenas certas versões do Android,
  diga isso no README.


#### Conteúdo {:#list5}

Os usuários acham mais fácil navegar em uma página ou seção
quando ela tem um índice.
Se uma seção no seu README for muito longa,
considere listar as subseções claramente no início da seção.

Por exemplo, a seção "Usage" do README do `in_app_purchase`
tem muitos exemplos.
O seguinte índice ajuda os usuários a entender quais exemplos existem,
e ir para o código que lhes interessa:

<img 
  src="/assets/img/libraries/package-page-list-subsections.png" 
  alt="content of the usage section of the package in_app_purchase" 
  class="screenshot">


### 4. Inclua exemplos de uso {:#tip4}

Se seu pacote parecer promissor, os usuários podem querer testar seu pacote.
Inclua uma seção "Get started" ou "Usage" que tenha
pelo menos um exemplo de código que os usuários possam entender facilmente—e,
idealmente, que eles possam copiar e colar em seu projeto.
É ainda melhor se você puder fornecer mais exemplos com mais detalhes
para ajudar os usuários a entender seu pacote.

Lembre-se de que nem todos os usuários falam inglês, mas todos falam Dart!
Bons exemplos de código podem ir longe.
Considere adicionar exemplos mais completos
no diretório `example` do seu pacote,
que o pub.dev pode usar para preencher uma aba **Examples**.
Para detalhes, veja [Examples][] em
[package layout conventions][].

[Examples]: /tools/pub/package-layout#examples
[package layout conventions]: /tools/pub/package-layout

A seguinte captura de tela mostra um dos vários exemplos no README do
pacote `in_app_purchase`:

<img 
  src="/assets/img/libraries/package-page-usage-example.png"
  alt="sample code of the package in_app_purchase" 
  class="screenshot">

### 5. Use formatação de código Dart {:#tip5}

Ao adicionar exemplos de código,
use três crases mais `dart` (<code>&#96;&#96;&#96;dart</code>) em vez de
três crases (<code>&#96;&#96;&#96;</code>).
Como os seguintes exemplos mostram,
adicionar `dart` diz ao pub.dev para usar o destaque de sintaxe Dart:

<table width="100%">
<tr>
<th> <b>Formatted with just <code>&#96;&#96;&#96;</code></b> </th>
<th> <b>Formatted with <code>&#96;&#96;&#96;dart</code></b> </th>
</tr>
<tr>
<td>

```plaintext
final like = 'this';
```

</td>
<td>

```dart
final like = 'this';
```

</td>
</tr>
</table>


### 6. Mencione termos relacionados {:#tip6}

Um estudo recente de UX descobriu que
muitos usuários usam o recurso de pesquisa dentro da página
(`Control+F` ou `Command+F`)
para procurar o recurso que estão procurando.
Portanto, certifique-se de mencionar termos importantes no README,
para que os usuários possam encontrá-los.

Por exemplo, os usuários podem querer saber se o pacote `in_app_purchase`
suporta assinatura no aplicativo.
Um usuário que procura pela palavra-chave _subscription_
pode abandonar a página se a página não usar esse termo.

<img
  src="/assets/img/libraries/package-page-terms.png"
  alt="the keyword is highlighted when users search for it within the page"
  class="screenshot">

Depois de mencionar todos os termos que as pessoas podem procurar,
seja consistente sobre os termos que você usa.
Se necessário, defina claramente os termos.

Por exemplo, o pacote [`in_app_purchase`][] define
_underlying store_ no início:

<img
  src="/assets/img/libraries/package-page-terms-definition.png"
  alt="the meaning of underlying store"
  class="screenshot">

O resto da página usa esse termo de forma consistente:

<img
  src="/assets/img/libraries/package-page-terms-consistent.png"
  alt="The term underlying store is used consistently across the page"
  class="screenshot">


### 7. Diga aos usuários para onde ir em seguida {:#tip7}

Ajude seus usuários a descobrir mais sobre o pacote.
Aqui estão algumas sugestões sobre o que dizer aos usuários potenciais:

* Onde aprender mais sobre o pacote.
  Você pode vincular a um artigo no Medium ou a um vídeo no YouTube.
* Onde obter ajuda sobre o uso do pacote.
  As possibilidades incluem um rastreador de problemas, uma sala de chat ou um endereço de e-mail.
* O que você está planejando fazer com o pacote.
  Um roteiro—seja no README ou em uma página externa—pode
  ajudar os usuários a saber se o recurso que precisam está chegando em breve.
* Como contribuir com código para o pacote.

A seguinte captura de tela mostra a parte do README do `in_app_purchase`
que tem informações para potenciais contribuidores:

<img 
  src="/assets/img/libraries/package-page-contribute.png"
  alt="how to contribute to in_app_purchase" 
  class="screenshot">


## Aprenda mais sobre como escrever um bom README

Sugerimos sete dicas para um bom README nesta documentação.
Você pode aprender mais sobre recomendações comuns para documentação de desenvolvedores
no [Google Developer Documentation Style Guide][style-guide].
Algumas dicas adicionais incluem:

*   Forneça texto alternativo para imagens.
*   Seja sucinto. Não diga por favor.
*   Mantenha o comprimento da linha &lt;= 80 caracteres.
*   Formate o código corretamente (como `dart format` faria).

Para aprender mais sobre boas práticas de README,
veja estes recursos:

[README Checklist][]
: Uma lista de verificação para escrever um README que
  ajuda os leitores a se sentirem confiantes sobre seu projeto.

[Awesome README][]
: Uma lista com curadoria e anotações de ótimos READMEs.

[Make a README][]
: Uma introdução aos READMEs,
  com um modelo e sugestões para um bom README.

[How to write a great README for your GitHub project][]
: Elementos-chave de um bom README e um modelo.

As sugestões nesta página e em outras podem não funcionar para todos os pacotes.
Seja criativo!
Coloque-se no lugar dos usuários e
imagine o que o leitor pode querer ler e saber.
Você é a única pessoa que pode fornecer as informações que o leitor precisa.

[Awesome README]: https://github.com/matiassingers/awesome-readme
[Badges]: https://github.com/badges/shields#readme
[`dart doc`]: /tools/dart-doc
[How to write a great README for your GitHub project]: https://dbader.org/blog/write-a-great-readme-for-your-github-project
[`in_app_purchase`]: {{site.pub-pkg}}/in_app_purchase
[in its repo]: https://github.com/flutter/plugins/tree/master/packages/in_app_purchase/in_app_purchase/doc
[Make a README]: https://www.makeareadme.com
[README Checklist]: https://github.com/ddbeck/readme-checklist/blob/main/checklist.md
[style-guide]: https://developers.google.com/style/highlights
[`yaml`]: {{site.pub-pkg}}/yaml 
