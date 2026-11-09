---
ia-translate: true
title: Escrevendo páginas de pacotes
description: Aprenda a escrever uma boa página de pacote.
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

As diretrizes desta página podem ajudar você a criar boas páginas de pacotes no pub.dev.
Especificamente, esta página traz dicas para
escrever um README de pacote melhor,
que fornece o conteúdo marcado como **README (este documento)**
na captura de tela a seguir:

<img 
  src="/assets/img/libraries/package-page-sections.png"
  alt="package page contains sections like package layout, flutter favorite, package scoring, verified publishers, pubspec file" 
  class="screenshot diagram-wrap">

Para detalhes sobre as outras partes da página do pacote,
siga estes links:

1. [Layout do pacote ](/tools/pub/package-layout)
2. [Flutter Favorite]({{site.flutter-docs}}/development/packages-and-plugins/favorites)
3. [Pontuação do pacote]({{site.pub}}/help/scoring)
4. [Publishers verificados](/tools/pub/verified-publishers)
5. [Arquivo pubspec](/tools/pub/pubspec)


## Escrever um bom README é importante {:#writing-a-good-readme-is-important}

As pessoas que encontram seu pacote no pub.dev provavelmente vão
dar uma olhada rápida no README ao decidir se vão experimentar seu pacote.
Um bom README prende a atenção do leitor e
mostra que o seu pacote vale a pena ser experimentado.

:::note
O README do pacote é usado de várias formas.
Por exemplo, o conteúdo dele aparece não só na página do pacote no pub.dev,
mas também na documentação de referência da API gerada pelo [`dart doc`][].
:::

Embora esta página use o README do pacote [`in_app_purchase`][`in_app_purchase`] como exemplo,
o seu pode não precisar ser tão grande ou detalhado.
Se o seu pacote for simples e não tiver UI associada,
o README dele pode se parecer mais com o do pacote [`yaml`][`yaml`]. 


## Sete dicas para um bom README {:#seven-tips-for-good-readme}

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

De acordo com a nossa pesquisa com usuários,
quem usa pacotes gasta apenas alguns segundos para
ler a descrição do pacote e decidir se
vai ler o restante do README.
Por isso, descreva de forma concisa o que o pacote faz ou alcança,
de relance.
Dedique um tempo para criar uma descrição curta e objetiva, que
ajude o usuário a tomar decisões.

:::tip
Não escreva o nome do pacote de novo no topo.
Ele já está visível na interface do pub.dev.
:::

Aqui estão alguns exemplos de boas descrições:

*   `A Flutter plugin for showing rainbows.`
*   `Use machine learning to categorize bird sounds.`

Informações importantes, como o status do projeto ou restrições,
também devem ficar perto do topo.
Por exemplo:

*   `Does not work on iOS versions below 10.3.`

Aqui está uma captura de tela da página do pacote [`in_app_purchase`][`in_app_purchase`],
que começa com uma breve explicação do pacote e um alerta:

<img 
  src="/assets/img/libraries/package-page-description.png"
  alt="description of the package in_app_purchase" 
  class="screenshot">

Os [selos][Badges] costumam ficar perto do topo do README,
acima ou abaixo da descrição curta. 


### 2. Inclua conteúdo visual {:#tip2}

Se a página do seu pacote for um bloco de texto sem nenhum conteúdo visual,
os usuários podem achá-la intimidadora e parar de ler.
Imagens são especialmente importantes se o seu pacote oferece suporte a UI,
mas também são úteis para explicar conceitos importantes.
De qualquer forma, o conteúdo visual pode ajudar os usuários
a se sentirem confiantes para usar o pacote.

Coloque conteúdo visual, como imagens estáticas, GIFs animados e
vídeos (como arquivos MOV ou MP4),
perto do início do README,
onde os usuários provavelmente vão vê-los.

:::tip
Prefira GIFs animados e vídeos para conteúdo relacionado a UI,
porque a maioria das UIs não é estática,
e a animação transmite mais informações sobre o comportamento da UI.
:::

As capturas de tela a seguir mostram como
adicionar conteúdo visual deixou a página do pacote `in_app_purchase` informativa à primeira vista.
(A imagem _antes_ está à esquerda; a _depois_, à direita.)

<img 
  src="/assets/img/libraries/package-page-example-iap.png"
  alt="in_app_purchase readme without and with images" 
  class="screenshot">

:::tip
Ao adicionar conteúdo visual,
use URLs absolutas para os arquivos
para que as imagens apareçam de forma confiável,
independentemente de onde o README for publicado.
Um lugar para hospedar suas imagens é o próprio repositório,
como faz o `in_app_purchase`.
:::


### 3. Use listas para apresentar informações importantes {:#tip3}

Listas podem chamar a atenção para informações importantes no seu README.
Você pode usar listas para o seguinte:

*   [Principais recursos do pacote](#list1)
*   [Parâmetros, atributos ou propriedades](#list2)
*   [Requisitos incomuns](#list3)
*   [Funcionalidades fora do escopo do seu pacote](#list4)
*   [Um resumo do conteúdo de uma página ou de uma seção dentro dela
    (como esta lista)](#list5)

Normalmente, as listas são com marcadores, como a lista acima.
Outra opção é usar uma tabela,
como a tabela de suporte a plataformas na próxima seção.


#### Principais recursos do pacote {:#list1}

Primeiro, liste claramente o que o seu pacote consegue fazer.
Alguns usuários podem estar procurando um recurso bem específico.
Ajude esses usuários a descobrir se o seu pacote atende às necessidades deles.

A captura de tela a seguir mostra como o README do `in_app_purchase`
apresenta os recursos do pacote:

<img 
  src="/assets/img/libraries/package-page-features-list.png"
  alt="list of features of the package in_app_purchase" 
  class="screenshot">

A próxima captura de tela mostra uma tabela do README do `just_audio`
que lista os recursos do pacote e o suporte a plataformas:

<img 
  src="/assets/img/libraries/package-page-features-table.png"
  alt="list of features of the package just_audio in a table format" 
  class="screenshot-narrow">


#### Parâmetros, atributos ou propriedades {:#list2}

Considere listar parâmetros, atributos ou propriedades para consulta rápida.
(Lembre-se de que o conteúdo do README do pacote aparece na
documentação de referência da API, além da página do pacote.)

Por exemplo, o pacote `url_launcher` tem uma tabela com os esquemas de URL suportados:

<img 
  src="/assets/img/libraries/package-page-list-property.png"
  alt="list of supported schemes of the package url_launcher" 
  class="screenshot">

Criar links para funções ou classes específicas
na documentação de referência da API também pode ser útil.
Veja o pacote [async]({{site.pub-pkg}}/async) como exemplo.


#### Requisitos incomuns {:#list3}

Se o seu pacote precisa de uma configuração específica, além do que todos os pacotes exigem,
liste as instruções de configuração no README.

Por exemplo, a captura de tela a seguir do pacote `google_maps_flutter`
mostra instruções para começar com o Google Maps Platform:

<img 
  src="/assets/img/libraries/package-page-list-requirements.png" 
  alt="additional instructions to use google_maps_flutter" 
  class="screenshot">


#### Funcionalidades fora do escopo do seu pacote {:#list4}

Para ajudar os usuários a saber se o seu pacote pode ajudá-los,
liste os recursos que os usuários podem esperar,
mas que o seu pacote _não_ oferece suporte.

Aqui estão alguns exemplos de quando
você pode querer listar funcionalidades fora do escopo:

* Se o seu pacote de botões foca apenas em botões de texto
  e não em botões com ícones,
  deixe isso claro no README.
* Se o seu pacote oferece suporte apenas a certas versões do Android,
  diga isso no README.


#### Sumário {:#list5}

Os usuários acham mais fácil navegar por uma página ou seção
quando ela tem um sumário.
Se uma seção do seu README for muito longa,
considere listar claramente as subseções no início da seção. 

Por exemplo, a seção "Usage" do README do `in_app_purchase`
tem muitos exemplos.
O sumário a seguir ajuda os usuários a entender quais exemplos existem
e a ir direto ao código que lhes interessa:

<img 
  src="/assets/img/libraries/package-page-list-subsections.png" 
  alt="content of the usage section of the package in_app_purchase" 
  class="screenshot">


### 4. Inclua exemplos de uso {:#tip4}

Se o seu pacote parecer promissor, os usuários podem querer testá-lo.
Inclua uma seção "Get started" ou "Usage" com pelo menos um exemplo de código que
os usuários consigam entender facilmente e, idealmente,
copiar e colar no projeto deles.
É ainda melhor se você puder fornecer mais exemplos, com mais detalhes,
para ajudar os usuários a entender o seu pacote. 

Lembre-se de que nem todos os usuários falam inglês, mas todos falam Dart!
Bons exemplos de código fazem muita diferença.
Considere adicionar exemplos mais completos
no diretório `example` do seu pacote,
que o pub.dev pode usar para preencher uma aba **Examples**.
Para detalhes, consulte [Exemplos][Examples] em
as [convenções de layout de pacote][package layout conventions].

[Examples]: /tools/pub/package-layout#examples
[package layout conventions]: /tools/pub/package-layout

A captura de tela a seguir mostra um dos vários exemplos do README do
pacote `in_app_purchase`:

<img 
  src="/assets/img/libraries/package-page-usage-example.png"
  alt="sample code of the package in_app_purchase" 
  class="screenshot">

### 5. Use formatação de código Dart {:#tip5}

Ao adicionar exemplos de código,
use três crases seguidas mais `dart` (<code>&#96;&#96;&#96;dart</code>) em vez de
apenas três crases (<code>&#96;&#96;&#96;</code>).
Como mostram os exemplos a seguir,
adicionar `dart` faz o pub.dev usar o realce de sintaxe do Dart:

<table width="100%">
<tr>
<th> <b>Formatado apenas com <code>&#96;&#96;&#96;</code></b> </th>
<th> <b>Formatado com <code>&#96;&#96;&#96;dart</code></b> </th>
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
muitos usuários usam o recurso de busca dentro da página
(<kbd class="special-key">Cmd/Ctrl</kbd>+<kbd>F</kbd>)
para procurar o recurso que estão buscando.
Por isso, certifique-se de mencionar os termos importantes no README,
para que os usuários consigam encontrá-los. 

Por exemplo, os usuários podem querer saber se o pacote `in_app_purchase`
oferece suporte a assinaturas dentro do app.
Um usuário que pesquisa a palavra-chave _subscription_
pode abandonar a página se ela não usar esse termo.

<img 
  src="/assets/img/libraries/package-page-terms.png"
  alt="the keyword is highlighted when users search for it within the page" 
  class="screenshot">

Depois de mencionar todos os termos que as pessoas podem pesquisar,
mantenha a consistência nos termos que você usa.
Se necessário, defina os termos com clareza.

Por exemplo, o pacote [`in_app_purchase`][`in_app_purchase`] define
_underlying store_ logo no início:

<img 
  src="/assets/img/libraries/package-page-terms-definition.png"
  alt="the meaning of underlying store" 
  class="screenshot">

O restante da página usa esse termo de forma consistente:

<img 
  src="/assets/img/libraries/package-page-terms-consistent.png"
  alt="The term underlying store is used consistently across the page" 
  class="screenshot">


### 7. Diga aos usuários para onde ir em seguida {:#tip7}

Ajude seus usuários a descobrir mais sobre o pacote.
Aqui estão algumas sugestões do que dizer a possíveis usuários:

* Onde aprender mais sobre o pacote.
  Você pode linkar para um artigo no Medium ou para um vídeo no YouTube.
* Onde obter ajuda para usar o pacote.
  As possibilidades incluem um rastreador de issues, uma sala de chat ou um endereço de e-mail.
* O que você planeja fazer com o pacote.
  Um roadmap, seja no README ou em uma página externa, pode
  ajudar os usuários a saber se o recurso de que precisam está chegando em breve.
* Como contribuir com código para o pacote.

A captura de tela a seguir mostra a parte do README do `in_app_purchase`
que traz informações para possíveis contribuidores:

<img 
  src="/assets/img/libraries/package-page-contribute.png"
  alt="how to contribute to in_app_purchase" 
  class="screenshot">


## Saiba mais sobre como escrever um bom README {:#learn-more-about-good-readme-authoring}

Sugerimos sete dicas para um bom README nesta documentação.
Você pode saber mais sobre recomendações comuns para documentação de desenvolvedores
no [Google Developer Documentation Style Guide][style-guide].
Algumas dicas adicionais incluem:  

*   Forneça texto alternativo (alt) para as imagens.
*   Seja sucinto. Não diga "por favor".
*   Mantenha o comprimento da linha &lt;= 80 caracteres.
*   Formate o código corretamente (como o `dart format` faria).

Para saber mais sobre boas práticas de README,
veja estes recursos:

[Checklist de README][README Checklist]
: Um checklist para escrever um README que
  faz o leitor se sentir confiante em relação ao seu projeto.

[Awesome README][Awesome README]
: Uma lista curada e anotada de ótimos READMEs.

[Make a README][Make a README]
: Uma introdução aos READMEs,
  com um modelo e sugestões para um bom README.

[Como escrever um ótimo README para o seu projeto no GitHub][How to write a great README for your GitHub project]
: Elementos-chave de um bom README, e um modelo.

As sugestões desta página e de outras podem não funcionar para todos os pacotes.
Seja criativo!
Coloque-se no lugar dos usuários e
imagine o que o leitor pode querer ler e saber.
Você é a única pessoa que pode fornecer as informações de que o leitor precisa.

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
