---
ia-translate: true
title: Escrevendo páginas de pacotes
description: Aprenda como escrever uma boa página de pacote.
---

<style>
  .screenshot, .screenshot-narrow {
    border-style: solid;
    border-width: 1px;
    border-color: lightgray;
    margin: 0px 20px;
    padding: 10px;
    width: 90%;
  }

  .screenshot-narrow {
    max-width: 400px;
  }
</style>

As diretrizes nesta página podem ajudar você a criar boas páginas de pacotes no pub.dev.
Especificamente, esta página tem dicas para
escrever um README melhor para o pacote,
que fornece o conteúdo marcado como **README (este documento)**
na seguinte captura de tela:

<img
  src="/assets/img/libraries/package-page-sections.png"
  alt="página de pacote contém seções como layout do pacote, Flutter favorito, pontuação do pacote, editores verificados, arquivo pubspec"
  class="screenshot">

Para detalhes sobre outras partes da página do pacote,
siga estes links:

1.  [Layout do pacote](/tools/pub/package-layout)
2.  [Flutter Favorito]({{site.flutter-docs}}/development/packages-and-plugins/favorites)
3.  [Pontuação do pacote]({{site.pub}}/help/scoring)
4.  [Editores verificados](/tools/pub/verified-publishers)
5.  [Arquivo Pubspec](/tools/pub/pubspec)


## Escrever um bom README é importante {:#writing-a-good-readme-is-important}

Pessoas que encontram seu pacote no pub.dev provavelmente
irão escanear rapidamente o README ao decidir se devem experimentar seu pacote.
Um bom README chama a atenção do leitor e
mostra que seu pacote vale a pena ser experimentado.

:::note
O README do pacote é usado de várias maneiras.
Por exemplo, seu conteúdo aparece não apenas na página do pacote no pub.dev,
mas também na documentação de referência da API produzida por [`dart doc`][].
:::

Embora esta página apresente o README do pacote [`in_app_purchase`][],
o seu pode não precisar ser tão grande ou detalhado.
Se seu pacote for simples e não tiver nenhuma UI (interface do usuário) associada,
seu README pode se parecer mais com o do pacote [`yaml`][].


## Sete dicas para um bom README {:#seven-tips-for-good-readme}

Aqui estão algumas sugestões para criar um README
que funcione bem no pub.dev:

1.  [Coloque uma descrição curta no topo](#tip1)
2.  [Inclua conteúdo visual](#tip2)
3.  [Use listas para apresentar informações importantes](#tip3)
4.  [Inclua exemplos de uso](#tip4)
5.  [Use formatação de código Dart](#tip5)
6.  [Mencione termos relacionados](#tip6)
7.  [Diga aos usuários onde ir em seguida](#tip7)


### 1. Coloque uma descrição curta no topo {:#tip1}

De acordo com nossa pesquisa com usuários,
os usuários de pacotes gastam apenas alguns segundos para
ler a descrição do pacote e decidir se devem
ler o resto do README.
Assim, você deve descrever concisamente o que o pacote faz ou alcança,
de relance.
Dedique algum tempo para elaborar uma descrição curta e agradável e
ajude o usuário a tomar decisões.

:::tip
Não escreva o nome do pacote novamente no topo.
Ele já está visível na UI (interface do usuário) do pub.dev.
:::

Aqui estão alguns exemplos de boas descrições:

*   `Um plugin Flutter para exibir arco-íris.`
*   `Use aprendizado de máquina para categorizar sons de pássaros.`

Informações importantes como o status do projeto ou restrições
também devem estar próximas do topo.
Por exemplo:

*   `Não funciona em versões iOS abaixo de 10.3.`

Aqui está uma captura de tela da página do pacote [`in_app_purchase`][],
que começa com uma breve explicação do pacote e um aviso:

<img
  src="/assets/img/libraries/package-page-description.png"
  alt="descrição do pacote in_app_purchase"
  class="screenshot">

[Badges][] (selos) geralmente estão perto do topo do README,
acima ou abaixo da descrição curta.


### 2. Inclua conteúdo visual {:#tip2}

Se sua página de pacote for um mural de texto sem conteúdo visual,
os usuários podem achá-la intimidante e parar de ler.
Imagens são especialmente importantes se seu pacote suportar UI (interface do usuário),
mas elas também são úteis para explicar conceitos importantes.
De qualquer forma, o conteúdo visual pode ajudar os usuários
a se sentirem confiantes sobre o uso do pacote.

Coloque conteúdo visual como imagens estáticas, GIFs animados e
vídeos (como arquivos MOV ou MP4)
perto do início do README,
onde os usuários provavelmente os verão.

:::tip
Prefira GIFs animados e vídeos para conteúdo relacionado à UI (interface do usuário),
porque a maioria das UIs não são estáticas,
e a animação transmite mais informações sobre o comportamento da UI.
:::

As capturas de tela abaixo mostram como
a adição de conteúdo visual tornou a página do pacote `in_app_purchase` informativa à primeira vista.
(A imagem _antes_ está à esquerda; _depois_ está à direita.)

<img
  src="/assets/img/libraries/package-page-example-iap.png"
  alt="readme do in_app_purchase sem e com imagens"
  class="screenshot">

:::tip
Ao adicionar conteúdo visual,
use URLs absolutos para os arquivos
para que as imagens apareçam de forma confiável,
não importa onde o README seja publicado.
Um lugar para hospedar suas imagens é no próprio repositório,
como `in_app_purchase` faz.
:::


### 3. Use listas para apresentar informações importantes {:#tip3}

Listas podem chamar a atenção para informações importantes em seu README.
Você pode usar listas para o seguinte:

*   [Principais recursos do pacote](#list1)
*   [Parâmetros, atributos ou propriedades](#list2)
*   [Requisitos incomuns](#list3)
*   [Funcionalidade que está fora do escopo do seu pacote](#list4)
*   [Um resumo do conteúdo de uma página ou uma seção dentro de uma página
    (como esta lista)](#list5)

Normalmente, as listas são marcadas com marcadores, como a lista acima.
Outra opção é usar uma tabela,
como a tabela de suporte de plataforma na próxima seção.


#### Principais recursos do pacote {:#list1}

Primeiro, liste claramente o que seu pacote pode fazer.
Alguns usuários podem estar procurando por um recurso muito específico.
Ajude esses usuários a descobrir se seu pacote atende às suas necessidades.

A seguinte captura de tela mostra como o README do `in_app_purchase`
apresenta os recursos do pacote:

<img
  src="/assets/img/libraries/package-page-features-list.png"
  alt="lista de recursos do pacote in_app_purchase"
  class="screenshot">

A próxima captura de tela mostra uma tabela do README do `just_audio`
que lista os recursos do pacote e o suporte da plataforma:

<img
  src="/assets/img/libraries/package-page-features-table.png"
  alt="lista de recursos do pacote just_audio em formato de tabela"
  class="screenshot-narrow">


#### Parâmetros, atributos ou propriedades {:#list2}

Considere listar parâmetros, atributos ou propriedades para referência rápida.
(Lembre-se, o conteúdo do README do pacote aparece na
documentação de referência da API, bem como na página do pacote.)

Por exemplo, o pacote `url_launcher` tem uma tabela de esquemas de URL suportados:

<img
  src="/assets/img/libraries/package-page-list-property.png"
  alt="lista de esquemas suportados do pacote url_launcher"
  class="screenshot">

Fazer link para funções ou classes específicas
na documentação de referência da API também pode ser útil.
Veja o pacote [async]({{site.pub-pkg}}/async) para um exemplo.


#### Requisitos incomuns {:#list3}

Se seu pacote precisar de uma configuração específica, além do que todos os pacotes exigem,
liste as instruções de configuração no README.

Por exemplo, a seguinte captura de tela do pacote `google_maps_flutter`
mostra instruções sobre como começar a usar a plataforma Google Maps:

<img
  src="/assets/img/libraries/package-page-list-requirements.png"
  alt="instruções adicionais para usar google_maps_flutter"
  class="screenshot">


#### Funcionalidade que está fora do escopo do seu pacote {:#list4}

Para ajudar os usuários a saber se seu pacote pode ajudá-los,
liste os recursos que os usuários podem esperar,
mas que seu pacote _não_ suporta.

Aqui estão alguns exemplos de quando
você pode querer listar a funcionalidade fora do escopo:

*   Se seu pacote de botões se concentra apenas em botões de texto
    e não em botões de ícone,
    deixe isso claro no README.
*   Se seu pacote suporta apenas certas versões do Android,
    diga isso no README.


#### Conteúdo {:#list5}

Os usuários acham mais fácil navegar em uma página ou seção
quando ela tem um índice.
Se uma seção em seu README for muito longa,
considere listar as subseções claramente no início da seção.

Por exemplo, a seção "Uso" do README do `in_app_purchase`
tem muitos exemplos.
O seguinte índice ajuda os usuários a entender quais exemplos existem,
e ir para o código que lhes interessa:

<img
  src="/assets/img/libraries/package-page-list-subsections.png"
  alt="conteúdo da seção de uso do pacote in_app_purchase"
  class="screenshot">


### 4. Inclua exemplos de uso {:#tip4}

Se seu pacote parece promissor, os usuários podem querer testá-lo.
Inclua uma seção "Começar" ou "Uso" que tenha
pelo menos um exemplo de código que os usuários possam entender facilmente—e,
idealmente, que eles possam copiar e colar em seu projeto.
É ainda melhor se você puder fornecer mais exemplos com mais detalhes
para ajudar os usuários a entender seu pacote.

Lembre-se de que nem todos os usuários falam inglês, mas todos falam Dart!
Bons exemplos de código podem ajudar muito.
Considere adicionar exemplos mais completos
no diretório `example` do seu pacote,
que o pub.dev pode usar para preencher uma aba **Exemplos**.
Para detalhes, veja [Exemplos][] em
as [convenções de layout de pacote][].

[Exemplos]: /tools/pub/package-layout#examples
[convenções de layout de pacote]: /tools/pub/package-layout

A seguinte captura de tela mostra um dos vários exemplos no README para
o pacote `in_app_purchase`:

<img
  src="/assets/img/libraries/package-page-usage-example.png"
  alt="código de amostra do pacote in_app_purchase"
  class="screenshot">

### 5. Use formatação de código Dart {:#tip5}

Ao adicionar exemplos de código,
use três acentos graves mais `dart` (<code>&#96;&#96;&#96;dart</code>) em vez de
três acentos graves (<code>&#96;&#96;&#96;</code>).
Como os exemplos a seguir mostram,
adicionar `dart` diz ao pub.dev para usar o realce de sintaxe Dart:

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
muitos usuários usam o recurso de pesquisa dentro da página
(`Control+F` ou `Command+F`)
para procurar o recurso que estão procurando.
Assim, certifique-se de mencionar termos importantes no README,
para que os usuários possam encontrá-los.

Por exemplo, os usuários podem querer saber se o pacote `in_app_purchase`
suporta assinatura no aplicativo.
Um usuário que pesquisa a palavra-chave _assinatura_
pode abandonar a página se a página não usar esse termo.

<img
  src="/assets/img/libraries/package-page-terms.png"
  alt="a palavra-chave é destacada quando os usuários a pesquisam dentro da página"
  class="screenshot">

Depois de mencionar todos os termos que as pessoas podem procurar,
seja consistente sobre os termos que você usa.
Se necessário, defina claramente os termos.

Por exemplo, o pacote [`in_app_purchase`][] define
_underlying store_ (loja subjacente) no início:

<img
  src="/assets/img/libraries/package-page-terms-definition.png"
  alt="o significado de loja subjacente"
  class="screenshot">

O resto da página usa esse termo consistentemente:

<img
  src="/assets/img/libraries/package-page-terms-consistent.png"
  alt="O termo loja subjacente é usado consistentemente em toda a página"
  class="screenshot">


### 7. Diga aos usuários onde ir em seguida {:#tip7}

Ajude seus usuários a descobrir mais sobre o pacote.
Aqui estão algumas sugestões sobre o que dizer aos usuários potenciais:

*   Onde aprender mais sobre o pacote.
    Você pode vincular a um artigo no Medium ou a um vídeo no YouTube.
*   Onde obter ajuda sobre como usar o pacote.
    As possibilidades incluem um rastreador de problemas, uma sala de chat ou um endereço de e-mail.
*   O que você está planejando fazer com o pacote.
    Um roteiro—seja no README ou em uma página externa—pode
    ajudar os usuários a saber se o recurso de que precisam estará disponível em breve.
*   Como contribuir com código para o pacote.

A seguinte captura de tela mostra a parte do README do `in_app_purchase`
que tem informações para potenciais colaboradores:

<img
  src="/assets/img/libraries/package-page-contribute.png"
  alt="como contribuir para in_app_purchase"
  class="screenshot">


## Saiba mais sobre a boa autoria de READMEs {:#learn-more-about-good-readme-authoring}

Sugerimos sete dicas para um bom README nesta documentação.
Você pode aprender mais sobre recomendações comuns para documentação de desenvolvedores
no [Guia de estilo de documentação para desenvolvedores do Google][style-guide].
Algumas dicas adicionais incluem:

*   Forneça texto alternativo para imagens.
*   Seja sucinto. Não diga por favor.
*   Mantenha o comprimento da linha &lt;= 80 caracteres.
*   Formate o código corretamente (como `dart format` faria).

Para saber mais sobre boas práticas de README,
veja estes recursos:

[Lista de verificação do README][]
: Uma lista de verificação para escrever um README que
  ajuda os leitores a se sentirem confiantes sobre seu projeto.

[README Incrível][]
: Uma lista selecionada e anotada de ótimos READMEs.

[Crie um README][]
: Uma introdução aos READMEs,
  com um modelo e sugestões para um bom README.

[Como escrever um ótimo README para seu projeto GitHub][]
: Elementos principais de um bom README e um modelo.

As sugestões nesta página e em outras podem não funcionar para todos os pacotes.
Seja criativo!
Coloque-se no lugar dos usuários e
imagine o que o leitor pode querer ler e saber.
Você é a única pessoa que pode fornecer as informações de que o leitor precisa.

[README Incrível]: https://github.com/matiassingers/awesome-readme
[Badges]: https://github.com/badges/shields#readme
[`dart doc`]: /tools/dart-doc
[Como escrever um ótimo README para seu projeto GitHub]: https://dbader.org/blog/write-a-great-readme-for-your-github-project
[`in_app_purchase`]: {{site.pub-pkg}}/in_app_purchase
[in its repo]: https://github.com/flutter/plugins/tree/master/packages/in_app_purchase/in_app_purchase/doc
[Crie um README]: https://www.makeareadme.com
[Lista de verificação do README]: https://github.com/ddbeck/readme-checklist/blob/main/checklist.md
[style-guide]: https://developers.google.com/style/highlights
[`yaml`]: {{site.pub-pkg}}/yaml