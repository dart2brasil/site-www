---
ia-translate: true
title: Versionamento de pacotes
description: "Como a ferramenta de gerenciamento de pacotes do Dart, pub, lida com o versionamento de pacotes."
---

O [gerenciador de pacotes pub][pub] ajuda você a trabalhar com versionamento.
Este guia explica um pouco sobre a história do versionamento e a abordagem do
pub em relação a ele.

Considere isso como informação avançada.
Para aprender _por que_ o pub foi projetado da maneira que foi, continue lendo.
Se você quer _usar_ o pub, consulte os [outros documentos][pub].

O desenvolvimento de software moderno, especialmente o desenvolvimento web,
depende muito da reutilização de muito código existente. Isso inclui código que
_você_ escreveu no passado, mas também código de terceiros, tudo, desde grandes
frameworks até pequenas bibliotecas de utilitárias. Não é incomum que um
aplicativo dependa de dezenas de pacotes e bibliotecas diferentes.

É difícil subestimar o quão poderoso isso é. Quando você vê histórias de
pequenas startups da web construindo um site em algumas semanas que atrai
milhões de usuários, a única razão pela qual eles podem conseguir isso é porque
a comunidade de código aberto preparou um banquete de software a seus pés.

Mas isso não sai de graça: há um desafio para a reutilização de código,
especialmente a reutilização de código que você não mantém. Quando seu aplicativo
usa código que está sendo desenvolvido por outras pessoas, o que acontece quando
elas o alteram? Elas não querem quebrar seu aplicativo, e você certamente
também não quer. Resolvemos este problema por meio do _versionamento_.

## Um nome e um número {:#a-name-and-a-number}

Quando você depende de algum código externo,
você não diz apenas "Meu aplicativo usa `widgets`". Você diz, "Meu aplicativo
usa `widgets 2.0.5`". Essa combinação de nome e número de versão identifica
de forma única um bloco de código _imutável_. As pessoas que atualizam `widgets`
podem fazer todas as alterações que quiserem, mas prometem não tocar em nenhuma
versão já lançada. Elas podem lançar `2.0.6` ou `3.0.0` e isso não afetará você
em nada porque a versão que você usa permanece inalterada.

Quando você _quiser_ obter essas alterações, você sempre pode direcionar seu
aplicativo para uma versão mais recente de `widgets` e não precisa se coordenar
com esses desenvolvedores para fazer isso. No entanto, isso não resolve totalmente o problema.

Os números de versão discutidos neste guia podem ser diferentes
do número de versão definido no nome do arquivo do pacote.
Eles podem incluir `-0` ou `-beta`.
Essas notações não afetam a resolução de dependência.

## Resolvendo dependências compartilhadas {:#resolving-shared-dependencies}

Depender de versões específicas funciona bem quando o seu _grafo_ de
dependência é realmente apenas uma _árvore_ de dependência. Se seu aplicativo
depende de vários pacotes e essas coisas, por sua vez, têm suas próprias
dependências e assim por diante, tudo isso funciona bem, desde que nenhuma dessas dependências se _sobreponha_.

Considere o seguinte exemplo:

<img src="/assets/img/tools/pub/PubConstraintsDiagram.png" alt="grafo de dependência">

Assim, seu aplicativo usa `widgets` e `templates`, e _ambos_ usam
`collection` (coleção). Isso é chamado de **dependência compartilhada**. Agora,
o que acontece quando `widgets` quer usar `collection 2.3.5` e `templates`
quer `collection 2.3.7`? E se eles não concordarem com uma versão?

### Bibliotecas não compartilhadas (a abordagem npm) {:#unshared-libraries-the-npm-approach}

Uma opção é simplesmente deixar o aplicativo usar ambas as
versões de `collection`. Ele terá duas cópias da biblioteca em versões
diferentes e `widgets` e `templates` receberão cada uma a que desejam.

Isso é o que o [npm][npm] faz para node.js. Funcionaria para o Dart? Considere este
cenário:

 1. `collection` define alguma classe `Dictionary` (Dicionário).
 2. `widgets` obtém uma instância dela de sua cópia de `collection` (`2.3.5`).
    Em seguida, ela a passa para `my_app`.
 3. `my_app` envia o dicionário para `templates`.
 4. Isso, por sua vez, envia para *sua* versão de `collection` (`2.3.7`).
 5. O método que a recebe possui uma anotação de tipo `Dictionary` para esse objeto.

No que diz respeito ao Dart, `collection 2.3.5` e `collection 2.3.7` são
bibliotecas totalmente não relacionadas. Se você pegar uma instância da classe
`Dictionary` de uma e passá-la para um método na outra, esse é um tipo
`Dictionary` completamente diferente. Isso significa que não corresponderá a
uma anotação de tipo `Dictionary` na biblioteca receptora. Ops.

Por causa disso (e por causa das dores de cabeça de tentar depurar um aplicativo
que tem várias versões de coisas com o mesmo nome), decidimos que o modelo do npm
não é uma boa opção.

### Bloqueio de versão (a abordagem sem saída) {:#version-lock-the-dead-end-approach}

Em vez disso, quando você depende de um pacote, seu aplicativo usa apenas uma
única cópia desse pacote. Quando você tem uma dependência compartilhada, tudo
o que depende dela precisa concordar com qual versão usar. Se não concordarem,
você receberá um erro.

No entanto, isso não resolve realmente o seu problema. Quando você _recebe_ esse
erro, precisa ser capaz de resolvê-lo. Então, digamos que você se colocou nessa
situação no exemplo anterior. Você deseja usar `widgets` e `templates`, mas
eles estão usando versões diferentes de `collection`. O que você faz?

A resposta é tentar atualizar um deles. `templates` quer `collection 2.3.7`.
Existe uma versão mais recente de `widgets` que você pode atualizar que funcione
com essa versão?

Em muitos casos, a resposta será "não". Veja pela perspectiva das pessoas que
estão desenvolvendo `widgets`. Elas querem lançar uma nova versão com novas
alterações em _seu_ código e querem que o máximo de pessoas possível possa
atualizar para ela. Se elas mantiverem sua versão _atual_ de `collection`,
qualquer pessoa que estiver usando a versão atual de `widgets` também poderá
inserir esta nova.

Se elas atualizassem _sua_ dependência em `collection`, então todos que
atualizassem `widgets` teriam que fazer o mesmo, _quer queiram ou não_. Isso é
doloroso, então você acaba com um desincentivo para atualizar as dependências.
Isso é chamado de **bloqueio de versão**: todos querem avançar suas dependências,
mas ninguém pode dar o primeiro passo porque força todos os outros a fazerem o
mesmo também.

### Restrições de versão (a abordagem Dart) {:#version-constraints-the-dart-approach}

Para resolver o bloqueio de versão, afrouxamos as restrições que os pacotes
impõem às suas dependências. Se `widgets` e `templates` puderem ambos indicar
um _intervalo_ de versões para `collection` com as quais funcionam, isso nos
dará espaço suficiente para avançar nossas dependências para versões mais
recentes. Contanto que haja sobreposição em seus intervalos, ainda podemos
encontrar uma única versão que os deixe felizes.

Este é o modelo que o [bundler][bundler] segue e também é o modelo do pub. Quando você
adiciona uma dependência em seu pubspec, você pode especificar um _intervalo_ de
versões que você pode aceitar.
Se o pubspec para `widgets` fosse assim:

```yaml
dependencies:
  collection: '>=2.3.5 <2.4.0'
```

Você poderia escolher a versão `2.3.7` para `collection`.
Uma única versão concreta satisfaria as restrições para
ambos os pacotes `widgets` e `templates`.

## Versões semânticas {:#semantic-versions}

Quando você adiciona uma dependência ao seu pacote, às vezes você deseja
especificar um intervalo de versões para permitir. Como você sabe qual intervalo
escolher? Você precisa ser compatível com o futuro, então, idealmente, o
intervalo abrange versões futuras que ainda não foram lançadas. Mas como você
sabe se seu pacote funcionará com uma nova versão que ainda nem existe?

Para resolver isso, você precisa concordar com o que um número de versão
_significa_. Imagine que os desenvolvedores de um pacote do qual você depende
digam: "Se fizermos alguma alteração incompatível com versões anteriores,
prometemos incrementar o número da versão principal". Se você confiar neles,
então, se você souber que seu pacote funciona com `2.3.5` deles, você pode
confiar que ele funcionará até `3.0.0`.
Você pode definir seu intervalo como:

```yaml
dependencies:
  collection: ^2.3.5
```

:::note
Este exemplo usa a _sintaxe do acento circunflexo_ para expressar um intervalo
de versões. A string `^2.3.5` significa "o intervalo de todas as versões de
2.3.5 a 3.0.0, não incluindo 3.0.0." Para saber mais, consulte a seção [sintaxe
do acento circunflexo][caret-syntax].
:::

Para que isso funcione, então, precisamos chegar a esse conjunto de promessas.
Felizmente, outras pessoas inteligentes fizeram o trabalho de descobrir tudo isso
e o chamaram de _[versionamento semântico][semver]_.

Isso descreve o formato de um número de versão e as diferenças de comportamento
exatas da API quando você incrementa para um número de versão posterior. O pub
exige que as versões sejam formatadas dessa forma e, para se dar bem com a
comunidade do pub, seu pacote deve seguir a semântica que ele especifica. Você
deve presumir que os pacotes dos quais você depende também o seguem. (E se você
descobrir que não seguem, avise seus autores!)

Embora o versionamento semântico não prometa nenhuma compatibilidade entre
versões anteriores a `1.0.0`, a convenção da comunidade Dart é tratar essas
versões semanticamente também. A interpretação de cada número é apenas
deslocada uma casa para baixo: ir de `0.1.2` para `0.2.0` indica uma alteração
que quebra a compatibilidade com versões anteriores, ir para `0.1.3` indica um
novo recurso e ir para `0.1.2+1` indica uma alteração que não afeta a API
pública. Para simplificar, evite usar `+` depois que a versão atingir `1.0.0`.

Agora temos quase todas as peças de que precisamos para lidar com o
versionamento e a evolução da API. Vamos ver como eles funcionam juntos e o que o pub faz.

## Resolvendo restrições {:#constraint-solving}

Quando você define seu pacote, você lista suas [dependências
imediatas][immediate-dep]. Esses são pacotes que seu pacote usa.
Para cada um desses pacotes,
você especifica o intervalo de versões que seu pacote permite.
Cada um desses pacotes dependentes pode então ter suas próprias dependências.
Eles são chamados de [dependências transitivas][transitive-dep]. O pub percorre
esses e constrói todo o grafo de dependência para seu aplicativo.

Para cada pacote no grafo, o pub analisa tudo o que depende dele. Ele reúne
todas as suas restrições de versão e tenta resolvê-las simultaneamente.
Basicamente, ele cruza seus intervalos. Então, o pub analisa as versões reais
que foram lançadas para esse pacote e seleciona a mais recente que atende a
todas essas restrições.

Por exemplo, digamos que nosso grafo de dependência contenha `collection` e três
pacotes dependam dele. Suas restrições de versão são:

```plaintext
>=1.7.0
^1.4.0
<1.9.0
```

Os desenvolvedores de `collection` lançaram estas versões dele:

```plaintext
1.7.0
1.7.1
1.8.0
1.8.1
1.8.2
1.9.0
```

O maior número de versão que se encaixa em todos esses intervalos é `1.8.2`,
então o pub escolhe esse. Isso significa que seu aplicativo _e todos os pacotes
que seu aplicativo usa_ usarão `collection 1.8.2`.

## Contexto de restrição {:#constraint-context}

O fato de que selecionar uma versão de pacote leva em consideração _todos_ os
pacotes que dependem dele tem uma consequência importante: _a versão específica
que será selecionada para um pacote é uma propriedade global do aplicativo que
usa esse pacote._

O exemplo a seguir mostra o que isso significa. Digamos que temos dois aplicativos.
Aqui estão seus pubspecs:

```yaml
name: my_app
dependencies:
  widgets:
```

```yaml
name: other_app
dependencies:
  widgets:
  collection: '<1.5.0'
```

Ambos dependem de `widgets`, cujo pubspec é:

```yaml
name: widgets
dependencies:
  collection: '>=1.0.0 <2.0.0'
```

O pacote `other_app` depende diretamente do próprio `collection`. A parte
interessante é que ele tem uma restrição de versão diferente nele do que
`widgets` tem.

Isso significa que você não pode simplesmente olhar para o pacote `widgets`
isoladamente para descobrir qual versão de `collection` ele usará. Isso
depende do contexto. Em `my_app`, `widgets` usará `collection 1.9.9`. Mas em
`other_app`, `widgets` ficará sobrecarregado com `collection 1.4.9` por causa
da _outra_ restrição que `otherapp` impõe a ele.

É por isso que cada aplicativo obtém seu próprio arquivo `package_config.json`: A versão concreta selecionada para cada pacote depende de todo o grafo de
dependência do aplicativo que o contém.

## Resolvendo restrições para dependências exportadas {:#constraint-solving-for-exported-dependencies}

Os autores de pacotes devem definir as restrições de pacotes com cuidado.
Considere o seguinte cenário:

<img src="/assets/img/tools/pub/PubExportedConstraints.png" alt="grafo de dependência">

O pacote `bookshelf` depende de `widgets`.
O pacote `widgets`, atualmente em 1.2.0, exporta
`collection` através de `export 'package:collection/collection.dart'`, e está
em 2.4.0. Os arquivos pubspec são os seguintes:

```yaml
name: bookshelf
dependencies:
  widgets: ^1.2.0
```

```yaml
name: widgets
dependencies:
  collection: ^2.4.0
```

O pacote `collection` é então atualizado para 2.5.0.
A versão 2.5.0 de `collection` inclui um novo método chamado `sortBackwards()`.
`bookshelf` pode chamar `sortBackwards()`,
porque faz parte da API exposta por `widgets`,
apesar de `bookshelf` ter apenas uma dependência transitiva em `collection`.

Como `widgets` tem uma API que não se reflete em seu número de versão,
o aplicativo que usa o pacote `bookshelf` e chama `sortBackwards()` pode travar.

Exportar uma API faz com que essa API seja tratada como se fosse definida no
próprio pacote, mas ela não pode aumentar o número da versão quando a API
adiciona recursos. Isso significa que `bookshelf` não tem como declarar que
precisa de uma versão de `widgets` que suporte `sortBackwards()`.

Por este motivo, ao lidar com pacotes exportados,
recomenda-se que o autor do pacote mantenha um limite mais restrito
nos limites superiores e inferiores de uma dependência.
Neste caso, o intervalo para o pacote `widgets` deve ser restrito:

```yaml
name: bookshelf
dependencies:
  widgets: '>=1.2.0 <1.3.0'
```

```yaml
name: widgets
dependencies:
  collection: '>=2.4.0 <2.5.0'
```

Isso se traduz em um limite inferior de 1.2.0 para `widgets`
e 2.4.0 para `collection`.
Quando alguém lança a versão 2.5.0 de `collection`,
o pub atualiza `widgets` para 1.3.0 e também atualiza as restrições
correspondentes.

Usar esta convenção garante que os usuários tenham a versão correta de
ambos os pacotes, mesmo que um não seja uma dependência direta.

## Lockfiles {:#lockfiles}

Então, depois que o pub resolveu as restrições de versão do seu aplicativo, o
que acontece? O resultado final é uma lista completa de todos os pacotes dos
quais seu aplicativo depende direta ou indiretamente e a melhor versão desse
pacote que funcionará com as restrições do seu aplicativo.

Para cada pacote, o pub pega essa informação,
calcula um [hash de conteúdo][content hash] a partir dela e grava ambos em um _[lockfile][lockfile]_
no diretório do seu aplicativo chamado `pubspec.lock`. Quando o pub cria o arquivo
`.dart_tool/package_config.json` para seu aplicativo, ele usa o lockfile para saber a quais versões de cada pacote se referir. (E se você estiver curioso para ver quais versões ele selecionou, você pode ler o lockfile para descobrir.)

A próxima coisa importante que o pub faz é que ele _para de tocar no lockfile_.
Depois que você obtém um lockfile para seu aplicativo, o pub não o tocará até
que você o diga. Isso é importante. Isso significa que você não começará
espontaneamente a usar novas versões de pacotes aleatórios em seu aplicativo
sem ter a intenção de fazê-lo. Depois que seu aplicativo é bloqueado, ele
permanece bloqueado até que você o diga manualmente para atualizar o lockfile.

Se seu pacote for para um aplicativo, você _verifica seu lockfile em seu
sistema de controle de origem!_ Dessa forma, todos em sua equipe estarão usando
as mesmas versões exatas de cada dependência ao construir seu aplicativo. Você
também usará isso ao implantar seu aplicativo para garantir que seus servidores de produção estejam usando os mesmos pacotes exatos com os quais você está desenvolvendo.

## Quando as coisas dão errado {:#when-things-go-wrong}

Claro, tudo isso presume que seu grafo de dependência é perfeito e impecável.
Mesmo com intervalos de versão e a resolução de restrições do pub e o
versionamento semântico, você nunca pode ser totalmente poupado dos perigos da
versionite.

Você pode encontrar um dos seguintes problemas:

### Você pode ter restrições disjuntas {:#you-can-have-disjoint-constraints}

Digamos que seu aplicativo use `widgets`
e `templates` e ambos usam
`collection`. Mas `widgets` pede uma versão dele entre `1.0.0` e `2.0.0` e
`templates` quer algo entre `3.0.0` e `4.0.0`. Esses intervalos nem mesmo se
sobrepõem. Não há versão possível que funcionaria.

### Você pode ter intervalos que não contêm uma versão lançada {:#you-can-have-ranges-that-dont-contain-a-released-version}

Digamos que, depois de colocar todas as restrições em uma dependência
compartilhada, você tenha um intervalo estreito de `>=1.2.4 <1.2.6`. Não é um
intervalo vazio. Se houvesse uma versão `1.2.4` da dependência, você estaria
bem. Mas talvez eles nunca tenham lançado essa versão.
Em vez disso, eles foram
direto de `1.2.3` para `1.3.0`. Você tem um intervalo sem nada dentro dele.

### Você pode ter um grafo instável {:#you-can-have-an-unstable-graph}

Esta é, de longe, a parte mais desafiadora do processo de resolução de versão do
pub. O processo foi descrito como _construir o grafo de dependência e, em
seguida, resolver todas as restrições e escolher as versões_. Mas na verdade
não funciona assim. Como você poderia construir o _todo_ o grafo de
dependência antes de escolher _quaisquer_ versões? _Os próprios pubspecs são
específicos da versão._ Diferentes versões do mesmo pacote podem ter diferentes
conjuntos de dependências.

À medida que você está selecionando versões de pacotes, eles estão alterando a
forma do próprio grafo de dependência. À medida que o grafo muda, isso pode
alterar as restrições, o que pode fazer com que você selecione versões
diferentes e, em seguida, volte para o início em um círculo.

Às vezes, esse processo nunca se estabiliza em uma solução estável.
Contemple o abismo:

```yaml
name: my_app
version: 0.0.0
dependencies:
  yin: '>=1.0.0'
```

```yaml
name: yin
version: 1.0.0
dependencies:
```

```yaml
name: yin
version: 2.0.0
dependencies:
  yang: '1.0.0'
```

```yaml
name: yang
version: 1.0.0
dependencies:
  yin: '1.0.0'
```

Em todos esses casos, não há um conjunto de versões concretas que funcione para
seu aplicativo e, quando isso acontece, o pub relata um erro e informa o que
está acontecendo. Definitivamente, não o deixará em um estado estranho onde
você acha que as coisas podem funcionar, mas não funcionarão.

## Resumo {:#summary}

Em resumo:

* Embora a reutilização de código tenha vantagens,
  os pacotes exigem a capacidade de evoluir independentemente.
* O versionamento permite essa independência.
  Depender de versões concretas únicas carece de flexibilidade.
  Juntamente com dependências compartilhadas, leva ao bloqueio de versão.
* Para lidar com o bloqueio de versão,
  seu pacote deve depender de um _intervalo_ de versões.
  O pub então percorre seu grafo de dependência e escolhe as melhores versões para você.
  Se não conseguir escolher uma versão apropriada, o pub avisa você.
* Depois que seu aplicativo tem um conjunto sólido de versões para suas
  dependências, esse conjunto é fixado em um _lockfile_.
  Isso garante que todas as máquinas que executam seu aplicativo usem as mesmas
  versões de todas as suas dependências.

Para saber mais sobre o algoritmo de resolução de versão do pub, consulte o
artigo [PubGrub][pubgrub] no Medium.

[immediate-dep]: /tools/pub/glossary#immediate-dependency
[transitive-dep]: /tools/pub/glossary#transitive-dependency
[pub]: /tools/pub/packages
[npm]: https://npmjs.org/
[bundler]: https://bundler.io
[caret-syntax]: /tools/pub/dependencies#caret-syntax
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
[lockfile]: /tools/pub/glossary#lockfile
[content hash]: /tools/pub/glossary#content-hashes
[pubgrub]: https://medium.com/@nex3/pubgrub-2fb6470504f