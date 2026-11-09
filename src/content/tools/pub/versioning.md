---
ia-translate: true
title: Versionamento de pacotes
description: >-
  Como o pub, a ferramenta de gerenciamento de pacotes do Dart, lida com o versionamento dos pacotes.
---

O [gerenciador de pacotes pub][pub] ajuda você a trabalhar com versionamento.
Este guia explica um pouco da história do versionamento e a
abordagem do pub para isso.

Considere isto como informação avançada.
Para entender _por que_ o pub foi projetado da forma como foi, continue lendo.
Se você quer _usar_ o pub, consulte a [outra documentação][pub].

O desenvolvimento de software moderno, especialmente o desenvolvimento web, depende muito do
reuso de um grande volume de código existente. Isso inclui o código que _você_ escreveu no
passado, mas também código de terceiros, desde grandes frameworks até pequenas
bibliotecas utilitárias. Não é incomum que um aplicativo dependa de
dezenas de pacotes e bibliotecas diferentes.

É difícil exagerar o poder disso. Quando você vê histórias de pequenas
startups web que criam um site em poucas semanas e que atinge milhões de usuários, o
único motivo de conseguirem isso é que a comunidade open source
colocou um banquete de software à disposição delas.

Mas isso não vem de graça: existe um desafio para o
reuso de código, especialmente quando você reutiliza código que não mantém. Quando seu app usa código
desenvolvido por outras pessoas, o que acontece quando elas mudam esse código?
Elas não querem quebrar o seu app, e você definitivamente também não quer.
Resolvemos esse problema com _versionamento_.

## Um nome e um número {:#a-name-and-a-number}

Quando você depende de algum pedaço de código externo,
você não diz apenas "Meu app usa `widgets`". Você diz "Meu app usa
`widgets 2.0.5`". Essa combinação de nome e número de versão identifica de forma única
um pedaço de código _imutável_. As pessoas que atualizam `widgets` podem
fazer todas as mudanças que quiserem, mas se comprometem a não tocar em nenhuma
versão já lançada. Elas podem lançar `2.0.6` ou `3.0.0` e isso não afetará você
em nada, porque a versão que você usa continua inalterada.

Quando você _quer_ receber essas mudanças, sempre pode apontar seu app para uma
versão mais nova de `widgets`, e não precisa coordenar com esses
desenvolvedores para fazer isso. No entanto, isso não resolve o problema por completo.

Os números de versão discutidos neste guia podem ser diferentes do
número de versão definido no nome do arquivo do pacote.
Eles podem incluir `-0` ou `-beta`.
Essas notações não afetam a resolução de dependências.

## Resolvendo dependências compartilhadas {:#resolving-shared-dependencies}

Depender de versões específicas funciona bem quando o seu
_grafo_ de dependências é, na prática, apenas uma _árvore_ de dependências. Se o seu app depende de vários
pacotes, e esses pacotes por sua vez têm suas próprias dependências e assim por diante, tudo
funciona bem enquanto nenhuma dessas dependências _se sobrepõe_.

Considere o exemplo a seguir:

<img src="/assets/img/tools/pub/PubConstraintsDiagram.png" alt="grafo de dependências">

Então o seu app usa `widgets` e `templates`, e _ambos_ usam
`collection`. Isso é chamado de **dependência compartilhada**. Agora, o que acontece quando
`widgets` quer usar `collection 2.3.5` e `templates` quer
`collection 2.3.7`? E se eles não concordarem em uma versão?

### Bibliotecas não compartilhadas (a abordagem do npm) {:#unshared-libraries-the-npm-approach}

Uma opção é deixar o app usar as duas
versões de `collection`. Ele terá duas cópias da biblioteca em versões diferentes, e
`widgets` e `templates` vão cada um pegar a que quer.

É isso que o [npm][] faz para o node.js. Funcionaria para o Dart? Considere este
cenário:

 1. `collection` define alguma classe `Dictionary`.
 2. `widgets` recebe uma instância dela da sua cópia de `collection` (`2.3.5`).
    Em seguida, passa essa instância para cima, para `my_app`.
 3. `my_app` envia o dicionário para `templates`.
 4. Este, por sua vez, o envia para _a sua_ versão de `collection` (`2.3.7`).
 5. O método que o recebe tem uma anotação de tipo `Dictionary` para esse objeto.

Para o Dart, `collection 2.3.5` e `collection 2.3.7` são
bibliotecas totalmente não relacionadas. Se você pega uma instância da classe `Dictionary`
de uma delas e a passa para um método da outra, isso é um tipo `Dictionary` completamente diferente.
Isso significa que ela não vai corresponder à anotação de tipo `Dictionary`
da biblioteca que a recebe. Opa.

Por causa disso (e das dores de cabeça de tentar depurar um app que
tem várias versões de coisas com o mesmo nome), decidimos que o modelo do npm
não é uma boa opção.

### Trava de versão (a abordagem sem saída) {:#version-lock-the-dead-end-approach}

Em vez disso, quando você depende de um pacote, o seu app usa apenas uma única cópia
desse pacote. Quando há uma dependência compartilhada, tudo o que depende dela
precisa concordar sobre qual versão usar. Se não concordar, você recebe um erro.

Isso, na verdade, não resolve o seu problema. Quando você _recebe_ esse erro,
precisa ser capaz de resolvê-lo. Então, digamos que você tenha se metido
nessa situação no exemplo anterior. Você quer usar `widgets` e
`templates`, mas eles usam versões diferentes de `collection`. O que você faz?

A resposta é tentar atualizar um deles. `templates` quer
`collection 2.3.7`. Existe uma versão mais recente de `widgets` para a qual você pode atualizar
que funcione com essa versão?

Em muitos casos, a resposta será "não". Olhe pela perspectiva das
pessoas que desenvolvem `widgets`. Elas querem lançar uma nova versão com novas mudanças
no _código delas_, e querem que o maior número possível de pessoas consiga atualizar para ela.
Se elas se mantiverem na versão _atual_ de `collection`, então qualquer pessoa que
usa a versão atual de `widgets` também poderá trocar por essa nova.

Se elas atualizassem a _própria_ dependência de `collection`, então todos que
atualizassem `widgets` também precisariam fazer isso, _quer quisessem ou não_.
Isso é doloroso, então você acaba com um desincentivo a atualizar dependências.
Isso se chama **trava de versão**:
todo mundo quer avançar com suas dependências,
mas ninguém consegue dar o primeiro passo, porque isso obriga todos os outros a fazer o mesmo.

### Restrições de versão (a abordagem do Dart) {:#version-constraints-the-dart-approach}

Para resolver a trava de versão, relaxamos as restrições que os pacotes impõem sobre
suas dependências. Se `widgets` e `templates` puderem indicar um _intervalo_ de
versões de `collection` com as quais funcionam, isso nos dá espaço suficiente para avançar
nossas dependências para versões mais novas. Enquanto houver sobreposição entre
seus intervalos, ainda conseguimos encontrar uma única versão que satisfaça os dois.

Esse é o modelo que o [bundler][] segue,
e também é o modelo do pub. Quando você adiciona uma dependência no seu pubspec,
pode especificar um _intervalo_ de versões que você aceita.
Se o pubspec de `widgets` fosse assim:

```yaml
dependencies:
  collection: '>=2.3.5 <2.4.0'
```

Você poderia escolher a versão `2.3.7` para `collection`.
Uma única versão concreta satisfaria as restrições tanto
do pacote `widgets` quanto do pacote `templates`.

## Versões semânticas {:#semantic-versions}

Quando você adiciona uma dependência ao seu pacote, às vezes vai querer especificar um
intervalo de versões a permitir. Como saber qual intervalo escolher? Você precisa ser
compatível com versões futuras, então, idealmente, o intervalo abrange versões futuras que
ainda não foram lançadas. Mas como saber que o seu pacote vai funcionar
com uma versão nova que nem existe ainda?

Para resolver isso, é preciso concordar sobre o que um número de versão _significa_.
Imagine que os desenvolvedores de um pacote do qual você depende digam:
"Se fizermos qualquer mudança incompatível com versões anteriores,
então prometemos incrementar o número da versão principal (major)."
Se você confiar neles, então, se souber que o seu pacote funciona com a `2.3.5` deles,
pode contar com o funcionamento até a `3.0.0`.
Você pode definir o seu intervalo assim:

```yaml
dependencies:
  collection: ^2.3.5
```

:::note
Este exemplo usa a _sintaxe caret_ para expressar um intervalo de versões.
A string `^2.3.5` significa "o intervalo de todas as versões de 2.3.5 até 3.0.0,
sem incluir 3.0.0."
Para saber mais, consulte a seção [sintaxe caret][caret-syntax].
:::

Para que isso funcione, precisamos definir esse conjunto de promessas.
Felizmente, outras pessoas inteligentes já fizeram o trabalho de descobrir tudo isso e
o chamaram de _[versionamento semântico][semver]_.

Ele descreve o formato de um número de versão e as diferenças exatas de comportamento da API
quando você incrementa para um número de versão posterior. O pub exige que as versões
sigam esse formato e, para se dar bem com a comunidade do pub, o seu pacote
deve seguir a semântica que ele especifica. Você deve presumir que os pacotes
dos quais depende também a seguem. (E se descobrir que não seguem, avise os
autores!)

Embora o versionamento semântico não prometa nenhuma compatibilidade entre versões
anteriores à `1.0.0`, a convenção da comunidade Dart é tratar essas versões
semanticamente também. A interpretação de cada número é apenas deslocada uma posição para baixo:
ir de `0.1.2` para `0.2.0` indica uma mudança incompatível, ir para
`0.1.3` indica um novo recurso, e ir para `0.1.2+1` indica uma mudança que
não afeta a API pública.
Por simplicidade, evite usar `+` depois que a versão chegar à `1.0.0`.

Agora temos quase todas as peças de que precisamos para lidar com o versionamento e a
evolução da API. Vamos ver como elas se encaixam e o que o pub faz.

## Resolução de restrições {:#constraint-solving}

Quando você define o seu pacote, lista suas
[dependências imediatas][immediate-dep].
São os pacotes que o seu pacote usa.
Para cada um desses pacotes, você especifica o intervalo de versões que o seu pacote aceita.
Cada um desses pacotes dependentes pode então ter as próprias dependências.
Elas são chamadas de [dependências transitivas][transitive-dep].
O pub percorre essas dependências e constrói o grafo de dependências completo do seu app.

Para cada pacote do grafo, o pub observa tudo o que depende dele.
Ele reúne todas as restrições de versão desses pacotes e
tenta resolvê-las simultaneamente. Basicamente, ele faz a interseção dos intervalos.
Depois, o pub olha as versões reais que foram lançadas para esse
pacote e seleciona a mais recente que atenda a todas essas restrições.

Por exemplo, digamos que o nosso grafo de dependências contenha `collection`, e três
pacotes dependam dele. As restrições de versão deles são:

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

O maior número de versão que cabe em todos esses intervalos é `1.8.2`, então o pub
escolhe essa. Isso significa que o seu app _e todos os pacotes que o seu app usa_ vão
usar `collection 1.8.2`.

## Contexto das restrições {:#constraint-context}

O fato de a seleção de uma versão de pacote levar em conta _todos_ os pacotes
que dependem dele tem uma consequência importante: _a versão específica que
será selecionada para um pacote é uma propriedade global do app que usa esse
pacote._

O exemplo a seguir mostra o que isso significa. Digamos que temos
dois apps. Estes são os seus pubspecs:

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

Os dois dependem de `widgets`, cujo pubspec é:

```yaml
name: widgets
dependencies:
  collection: '>=1.0.0 <2.0.0'
```

O pacote `other_app` depende diretamente de `collection`. O
ponto interessante é que ele, por acaso, tem uma restrição de versão diferente
sobre ele do que `widgets` tem.

Isso significa que você não pode olhar apenas o pacote `widgets`, isoladamente, para descobrir
qual versão de `collection` ele vai usar. Depende do
contexto. Em `my_app`, `widgets` vai usar `collection 1.9.9`. Mas
em `other_app`, `widgets` vai acabar com `collection 1.4.9` por causa da
restrição _outra_ que `other_app` impõe sobre ele.

É por isso que cada app recebe seu próprio arquivo `package_config.json`: a versão concreta selecionada para cada pacote depende de
todo o grafo de dependências do app que o contém.

## Resolução de restrições para dependências exportadas {:#constraint-solving-for-exported-dependencies}

Os autores de pacotes precisam definir as restrições de pacote com cuidado.
Considere o cenário a seguir:

<img src="/assets/img/tools/pub/PubExportedConstraints.png" alt="grafo de dependências" class="diagram-wrap">

O pacote `bookshelf` depende de `widgets`.
O pacote `widgets`, atualmente na versão 1.2.0, exporta
`collection` por meio de `export 'package:collection/collection.dart'`, e está
na versão 2.4.0. Os arquivos pubspec são os seguintes:

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
O `bookshelf` pode chamar `sortBackwards()`,
porque ela faz parte da API exposta por `widgets`,
apesar de `bookshelf` ter apenas uma dependência transitiva de `collection`.

Como `widgets` tem uma API que não é refletida em seu número de versão, o
app que usa o pacote `bookshelf` e chama `sortBackwards()`
pode travar.

Exportar uma API faz com que essa API seja tratada como se estivesse
definida no próprio pacote, mas isso não pode aumentar o número da versão quando
a API adiciona recursos. Isso significa que `bookshelf` não tem como declarar
que precisa de uma versão de `widgets` que suporte `sortBackwards()`.

Por esse motivo, ao lidar com pacotes exportados,
recomenda-se que o autor do pacote mantenha um
limite mais restrito nos limites superior e inferior de uma dependência.
Neste caso, o intervalo do pacote `widgets` deve ser reduzido:

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
e de 2.4.0 para `collection`.
Quando alguém lançar a versão 2.5.0 de `collection`,
o pub atualiza `widgets` para 1.3.0 e atualiza as restrições correspondentes
também.

Usar essa convenção garante que os usuários tenham a versão correta de
ambos os pacotes, mesmo que um deles não seja uma dependência direta.

## Lockfiles {:#lockfiles}

Então, depois que o pub resolve as restrições de versão do seu app, o que acontece? O resultado final
é uma lista completa de todos os pacotes dos quais o seu app depende, direta ou
indiretamente, e a melhor versão de cada pacote que funciona com
as restrições do seu app.

Para cada pacote, o pub pega essa informação,
calcula um [hash de conteúdo][content hash] a partir dela
e escreve ambos em um _[lockfile][lockfile]_
no diretório do seu app, chamado `pubspec.lock`. Quando o pub gera o arquivo `.dart_tool/package_config.json` do seu app, ele usa o lockfile para saber quais versões de cada pacote referenciar. (E se você tiver curiosidade de ver quais versões ele selecionou, pode ler o lockfile para descobrir.)

A próxima coisa importante que o pub faz é _parar de mexer no lockfile_. Depois que
você tem um lockfile para o seu app, o pub não o toca até que você diga para ele fazer isso.
Isso é importante. Significa que você não vai começar a usar, sem querer, novas versões
de pacotes aleatórios no seu app. Quando o seu app está travado,
ele continua travado até que você atualize manualmente o lockfile.

Se o seu pacote é para um app, você _faz o check-in do lockfile no seu sistema de controle de código-fonte!_ Assim, todos da sua equipe vão usar
exatamente as mesmas versões de cada dependência ao compilar o app. Você também
vai usar isso ao implantar o app, para garantir que os seus servidores de produção estejam usando
exatamente os mesmos pacotes com os quais você está desenvolvendo.

## Quando as coisas dão errado {:#when-things-go-wrong}

É claro que tudo isso pressupõe que o seu grafo de dependências seja perfeito e
sem falhas. Mesmo com intervalos de versão, a resolução de restrições do pub e o
versionamento semântico, você nunca fica totalmente livre dos
perigos da versionite.

Você pode encontrar um dos seguintes problemas:

### Você pode ter restrições disjuntas {:#you-can-have-disjoint-constraints}

Digamos que o seu app use `widgets` e
`templates`, e ambos usem `collection`. Mas `widgets` pede uma versão
dela entre `1.0.0` e `2.0.0`, e `templates` quer algo
entre `3.0.0` e `4.0.0`. Esses intervalos nem se sobrepõem. Não existe
nenhuma versão possível que funcione.

### Você pode ter intervalos que não contêm uma versão lançada {:#you-can-have-ranges-that-dont-contain-a-released-version}

Digamos que, depois de juntar todas as restrições sobre uma dependência compartilhada,
você tem um intervalo estreito de `>=1.2.4 <1.2.6`. Ele não está vazio.
Se existisse uma versão `1.2.4` da dependência, estaria tudo certo.
Mas talvez eles nunca tenham lançado essa versão.
Em vez disso, passaram direto de `1.2.3` para `1.3.0`.
Você tem um intervalo sem nada dentro dele.

### Você pode ter um grafo instável {:#you-can-have-an-unstable-graph}

Esta é, de longe, a parte mais desafiadora do
processo de resolução de versões do pub. O processo foi descrito como _construir o
grafo de dependências e depois resolver todas as restrições e escolher as versões_.
Mas, na prática, não funciona assim. Como você poderia construir o grafo _inteiro_
de dependências antes de ter escolhido _nenhuma_ versão? _Os próprios pubspecs
são específicos de versão._ Versões diferentes do mesmo pacote
podem ter conjuntos diferentes de dependências.

Conforme você seleciona versões de pacotes, elas estão alterando a forma do
próprio grafo de dependências. Conforme o grafo muda, isso pode mudar as restrições,
o que pode fazer você selecionar versões diferentes, e aí você
volta direto ao início, em círculo.

Às vezes, esse processo nunca se estabiliza em uma solução estável.
Olhe para o abismo:

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

Em todos esses casos, não existe um conjunto de versões concretas que funcione para
o seu app, e, quando isso acontece, o pub reporta um erro e informa o que
está acontecendo. Ele definitivamente não vai deixar você em algum estado estranho em que
acha que as coisas podem funcionar, mas não funcionam.

## Resumo {:#summary}

Em resumo:

* Embora o reuso de código tenha vantagens,
  os pacotes precisam da capacidade de evoluir de forma independente.
* O versionamento possibilita essa independência.
  Depender de versões concretas únicas falta flexibilidade.
  Combinado com dependências compartilhadas, leva à trava de versão.
* Para lidar com a trava de versão,
  o seu pacote deve depender de um _intervalo_ de versões.
  Em seguida, o pub percorre o seu grafo de dependências e escolhe as melhores versões para você.
  Se não conseguir escolher uma versão adequada, o pub avisa você.
* Quando o seu app tem um conjunto sólido de versões para as suas dependências,
  esse conjunto é fixado em um _lockfile_.
  Isso garante que todas as máquinas que executam o seu app usem as mesmas versões
  de todas as suas dependências.

Para saber mais sobre o algoritmo de resolução de versões do pub,
consulte o artigo [PubGrub][pubgrub] no Medium.

[immediate-dep]: /resources/glossary#immediate-dependency
[transitive-dep]: /resources/glossary#transitive-dependency
[pub]: /tools/pub/packages
[npm]: https://npmjs.org/
[bundler]: https://bundler.io
[caret-syntax]: /tools/pub/dependencies#caret-syntax
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
[lockfile]: /resources/glossary#lockfile
[content hash]: /resources/glossary#pub-content-hash
[pubgrub]: https://medium.com/@nex3/pubgrub-2fb6470504f
