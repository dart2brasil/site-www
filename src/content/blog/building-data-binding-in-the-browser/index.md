---
ia-translate: true
title: "Criando data binding no navegador"
description: "Data binding, ou seja, atualizar a view (normalmente a UI) a partir do código da sua aplicação é provavelmente o santo graal dos frameworks web para navegador —…"
publishDate: 2017-07-04
author: matanlurey
image: images/1QUn_zBM0SBDRG4TtMBiM2A.webp
category: deep-dive
layout: blog
---


<DashImage src="images/1QUn_zBM0SBDRG4TtMBiM2A.webp" alt="A diagram showing the MVC-style data binding popularized by Angular." caption="Data binding as popularized by the Angular (MVC-style). Lots of arrows and pictures. That’s always a good sign." />


*Data binding*, ou seja, atualizar a view (normalmente a UI) a partir do código da sua aplicação, é provavelmente o *santo graal* dos frameworks web para navegador: a razão de eles existirem e a razão pela qual os [padrões web têm tentado evoluir](https://developers.google.com/web/fundamentals/getting-started/primers/customelements) para facilitar o “uso da plataforma”.

Neste post, vou analisar quatro formas de data binding e escrever uma biblioteca simples/framework descartável para cada uma delas, principalmente como uma experiência de aprendizado. Vou usar o [*Dart*](https://www.dartlang.org/), uma linguagem de alto nível em que trabalho no Google (na equipe do AngularDart), mas a *maioria* dos conceitos abaixo se aplica a JavaScript, TypeScript ou a qualquer outro sabor de *Other*Script.

Eis os quatro cavaleiros do apocalipse do data binding:

* Templating estático

* Data binding manual (ou seja, usando apenas o DOM)

* Data binding no estilo MVC (popularizado pelo Angular)

* Data binding reativo (popularizado pelo React)

Se você só se interessa pelo código, está tudo disponível no GitHub:

***Uma observação rápida**: nada aqui está otimizado, e eu fiz alguns atalhos para tornar este tutorial viável em cerca de uma hora, o que significa que não escrevi nenhum pré-processador ou gerador de código. Em vez disso, escrevi à mão o que o código gerado seria; esses arquivos terminam em “.g.dart”.*

<GitHubEmbed repo="matanlurey/building-data-binding" title="building-data-binding - Accompanying code for &quot;Building Data Binding in the Browser&quot;" image="images/0QVBz3DSv-QKuugcc.webp" />


### Templating estático {:#static-templating}

Popularizado principalmente por frameworks *do lado do servidor*, como os de PHP, Python, Ruby e afins, eles emitem HTML *estático* que é transferido e exibido (normalmente) diretamente no navegador. A maioria dos sites sem JavaScript que têm algum tipo de backend usa essa estratégia.

Então, em sua essência, você está apenas retornando HTML puro. Alguns frameworks web mais novos também permitem *renderização do lado do servidor* (ou seja, usar o mesmo código do cliente para renderizar todo ou parte do HTML no servidor), mas isso está fora do escopo deste artigo.

Como o Dart (e a maioria das *OtherScripts*, a esta altura) tem [*interpolação*](https://www.dartlang.org/guides/language/language-tour#strings), ou seja, a capacidade de avaliar e criar strings em runtime, fazer uma forma muito básica de templating estático é extremamente fácil:

```dart
void main() {
  var name = 'Matan';
  print('Hello $name!');  
}

```

Ou podemos ir um pouco além e *de fato* gerar algum HTML. Neste exemplo, vou retornar uma lista com marcadores de tudo o que eu gosto de fazer nas segundas-feiras:

```dart
void main() {
  var sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  print(
    'On Sunday: \n'
    '<ul>\n'
    '${sundays.map((i) => '  <li>$i</li>\n').join('')}'
    '</ul>\n'
  );
}

```

Isso gera:
> On Sunday: 
&lt;ul&gt;
 &lt;li&gt;sleep in&lt;/li&gt;
 &lt;li&gt;eat brunch&lt;/li&gt;
 &lt;li&gt;wash car&lt;/li&gt;
&lt;/ul&gt;

Não é exatamente a *melhor* solução de templating, mas algo assim costuma funcionar para muitos sites, e cada vez mais sou fã de usar a ferramenta *mais simples* possível para cada tarefa, aumentando a complexidade só quando você realmente precisa. Se você realmente precisar de uma micro-biblioteca, então, ok, vamos escrever uma.

O que você gostaria que uma biblioteca básica de templating estático fizesse? Provavelmente, neste caso, criar a sintaxe HTML para você, para que seja menos propensa a erros, e oferecer algumas funções auxiliares para criar tags comuns e afins. Primeiro, vamos projetar uma classe chamada *Tag*, que encapsula um único elemento HTML, e as classes *Node* e *Text*:

```dart
abstract class Node {}

class Tag implements Node {
  final String name;
  final List<Node> children;

  const Tag(this.name, {this.children: const []});

  @override
  String toString() => '<$name>${children.join('')}</$name>';
}

class Text implements Node {
  final String text;

  const Text(this.text);

  @override
  String toString() => text;
}

void main() {
  var sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  var output = new Tag(
    'ul',
    children: sundays.map(
      (i) => new Tag('li', children: [new Text(i)]),
    ).toList(),
  );
  print(output);
}

```

Isso faz, mais ou menos, o mesmo que nosso código anterior, mas implementamos algumas abstrações: uma *Tag* é um elemento HTML, que tem qualquer número de filhos, e *Text* é, bem, texto. Escrevemos mais código do que antes, mas talvez isso seja mais agradável para alguns. É trivial incluir coisas como atributos HTML, então vou pular isso por enquanto.

Pessoalmente, porém, uma coisa me incomoda: usar *toString* para gerar código de produção. Também sou fã do [padrão visitor](https://en.wikipedia.org/wiki/Visitor_pattern), que separa de forma elegante essa lógica da nossa DSL:

```dart
abstract class Visitor<T> {
  T visitNode(Node node);
  T visitTag(Tag node);
  T visitText(Text node);
}

class HtmlEmitter implements Visitor<String> {
  @override
  String visitNode(Node node) => node.accept(this);

  @override
  String visitTag(Tag node) {
    final buffer = new StringBuffer('<${node.name}>');
    buffer
      ..writeAll(node.children.map(visitNode))
      ..write('</${node.name}>');
    return buffer.toString();
  }

  @override
  String visitText(Text node) => node.text;
}

abstract class Node {
  R accept<R>(Visitor<R> visitor);
}

class Tag implements Node {
  final String name;
  final List<Node> children;

  const Tag(this.name, {this.children: const []});

  @override
  R accept<R>(Visitor<R> visitor) => visitor.visitTag(this);
}

class Text implements Node {
  final String text;

  const Text(this.text);

  @override
  R accept<R>(Visitor<R> visitor) => visitor.visitText(this);
}

void main() {
  var sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  var output = new Tag(
    'ul',
    children: sundays.map(
      (i) => new Tag('li', children: [new Text(i)]),
    ).toList(),
  );
  print(new HtmlEmitter().visitNode(output));
}

```

De novo, *mais código*. Mas agora, se eu quiser HTML indentado/formatado, ou adicionar lógica de validação, ou qualquer outra coisa, posso implementar um novo *Visitor* e não preciso alterar nenhuma das minhas outras classes. Legal!

Por fim, vamos montar um servidor HTTP muito básico usando minha nova “biblioteca”. Neste caso, vou fazer com que ele escute automaticamente na porta 8080 e emita minha lista de tarefas:

```dart
import 'dart:io';

import 'package:static_templating/static_templating.dart';

main() async {
  final sundays = const [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  final server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print('Listening to localhost:8080.');
  await for (final request in server) {
    print('Connection received. Writing TODO list...');
    final list = _createTodoList(sundays);
    final output = list.accept(new HtmlEmitter());
    request.response
      ..headers.contentType = ContentType.HTML
      ..write(output)
      ..close();
    print('Done!');
  }
}

Node _createTodoList(Iterable<String> tasks) {
  return new Tag(
    'ul',
    children: tasks.map((i) => new Tag('li', children: [new Text(i)])).toList(),
  );
}

```

*(Uma coisa de que eu gosto especialmente no Dart é que não precisei importar nenhuma biblioteca de terceiros para fazer isso, nem configurar ferramentas especiais, e a análise estática me ajudou a descobrir como definir o cabeçalho ContentType sem pesquisar nada no Google.)*

Bem chato, mas funciona! Se você quiser escrever seu próprio servidor assim, eu começaria por estes, na ordem apresentada (de novo, sou um grande fã de usar o menor número possível de bibliotecas para cada tarefa):

* [dart:io](https://www.dartlang.org/articles/dart-vm/io), a biblioteca padrão da VM (não disponível no navegador)

* [shelf](https://pub.dartlang.org/packages/shelf), uma tecnologia de servidor baseada em middleware, como o Express do NodeJS

* frameworks mais completos, como o [aqueduct](http://aqueduct.io/) ou o [angel](https://angel-dart.github.io/)

E é isso. Você pode usar técnicas semelhantes para renderizar HTML no navegador, claro, mas isso é bem monótono, e você provavelmente quer que o HTML mude quando o usuário interagir com a página.

### Data binding manual {:#manual-data-binding}

*Antes* da era dos frameworks JavaScript (quando tudo era mais uma biblioteca), era comum escrever código diretamente contra o DOM (em JavaScript “puro”) ou usar uma biblioteca como o [jQuery](https://jquery.com/) para remover as diferenças entre navegadores e facilitar tarefas comuns.

Felizmente, o [dart:html](https://webdev.dartlang.org/tutorials/low-level-html/connect-dart-html) é uma biblioteca de alto nível fornecida pelo SDK do Dart, e, mesmo em JavaScript, os navegadores modernos de hoje são completos o suficiente para não precisar de uma biblioteca para data binding simples. E se eu quiser levar minha nova “lista de tarefas de domingo” adiante, e poder marcar (excluir) os itens conforme eu os concluir?

<DashImage src="images/1ggiMuy98lvPyUWVcf-HOFA.webp" alt="TODO list application built in the tutorial." caption="The world’s greatest UI" />


Entra o data binding *manual*. Em vez de depender de qualquer framework ou biblioteca específica, vou apenas criar elementos HTML e ouvir eventos para saber quando atualizar o DOM, tudo por conta própria.

```html
<html>
  <body>
    <div id="todo-list"></div>
  </body>
  <script type="application/dart" src="main.dart"></script>
  <script src="packages/browser/dart.js"></script>
</html>

```

```dart
import 'dart:html';

main() {
  final sundays = const [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  document.querySelector('#todo-list')
    ..append(new UListElement()
      ..children.addAll(
        sundays.map(_createListItem),
      ));
}

Element _createListItem(String item) {
  final li = new LIElement();
  final button = new ButtonElement()
    ..text = 'Done'
    ..onClick.listen((_) => li.remove());
  li
    ..appendText(item)
    ..append(button);
  return li;
}

```

De novo, bem monótono. Mas, se eu estivesse mesmo fazendo um app de tarefas simples assim, não seria tão ruim. O `..` do Dart, ou as [method cascades](http://news.dartlang.org/2012/02/method-cascades-in-dart-posted-by-gilad.html), deixam isso *relativamente* conciso, e eu poderia adicionar outros comportamentos básicos com bastante facilidade.

Mais ou menos, todas as outras formas de data binding/template binding tentam fazer o que está *acima*: construir algum DOM e atualizar o DOM quando algo acontece, mas de forma (a) mais performática, (b) mais elegante, (c) mais ergonômica e/ou (d) mais modular.

## Data binding automático {:#automatic-data-binding}

Pelas especificações atuais dos navegadores, nada existe para tornar isso *mais fácil*. Alguns podem argumentar que essa é a razão pela qual os WebComponents V1 não decolaram em comparação com os frameworks existentes: os frameworks tornaram a construção e a atualização do DOM tão fáceis e/ou ergonômicas que ninguém quer voltar atrás.

Eu trabalho na equipe do AngularDart, então vou mostrar a seguir um exemplo de data binding no estilo MVC (popularizado pelo Angular, mas me disseram que o Ember é outro excelente exemplo, e tenho certeza de que existem muitos outros).

### Data binding no estilo MVC {:#mvc-style-data-binding}

A essência do MVC é a separação da lógica entre a *view* (no navegador, geralmente o DOM) e o *controller* (no navegador, geralmente o seu JavaScript). Vou deixar o *m*, ou model, de lado por enquanto.

O Angular popularizou (ou pelo menos tentou) a ideia de que você deveria conseguir escrever objetos simples e burros (PODOs), incluir a lógica que quiser, e ela “simplesmente se vincularia” a um template HTML. Considere o seguinte encapsulamento no estilo MVC da nossa lista de tarefas de domingo:

```html
<ul>
  <!--
    Invented syntax. *bind="<TYPE> <TO>".

    In this case, a for-loop bound to "items", with every individual "item".
  -->
  <li *bind="for items:item">
    <!-- Pretty much the gold-standard for string interpolation. -->
    {{item}}
    <!--
      Invented syntax. *event="<NAME>:<TO>".

      In this case, a "click" event that invokes the "onClick" method.
    -->
    <button *event="click:onClick">Done</button>
  </li>
</ul>

```

Então, o que você acha? Há algumas vantagens e desvantagens aqui:

**PROs**:

* Você consegue encapsular a maior parte, ou toda, a lógica da view em um único arquivo.

* Embora não seja padrão, isso é *bastante* legível até para quem não programa, com apenas uma espécie de “cola” que explique as adições à especificação HTML para a sua linguagem de templates.

* Você não escreveu nenhum código de verdade, então um framework com um bom pré-processador ahead-of-time pode “compilar” isso, potencialmente de forma eficiente, para chamadas de JavaScript/DOM.

**CONs**:

* Se você não compra a religião do MVC, pode não gostar deste arquivo.

* Mesmo que você tenha dominado HTML/CSS e Dart ou JavaScript, você e seus desenvolvedores precisam aprender mais uma coisa que não é nenhuma dessas.

* Você não escreveu nenhum código de verdade, então está, mais ou menos, torcendo para que os autores do framework pré-processem/compilem isso de forma eficiente, e que o resultado seja quase tão bom quanto se você tivesse escrito o data binding manualmente (*dica:* quase nunca é).

Ainda não mostrei nenhum código de “controller”, então vamos escrever uma classe simples:

```dart
class ListController {
  final List<String> items;

  ListController(this.items);

  void onClick(String item) {
    items.remove(item);
  }
}

```

Fazer isso “simplesmente funcionar” vai exigir… escrever um framework. Isto é um post de blog, então, em vez de escrever de fato um parser para a nossa linguagem de templates, um pré-processador/compilador, vamos simplesmente escrever à mão o código que um gerador criaria.

Primeiro, vamos estabelecer nosso “framework”. Vou deixá-lo simples:

```dart
import 'dart:html';

abstract class Controller {
  View get view;

  /// Invoke when something in the DOM should be changed.
  ///
  /// In a "real framework" this would collate and be more intelligent.
  void markDirty() => view.detectChanges(this);
}

abstract class View<C extends Controller> {
  /// Create the initial representation of the DOM.
  Element build();

  /// Applies data-binding for a given [controller].
  void detectChanges(C controller);
}

```

Criei duas abstrações: um *Controller*, ou uma classe que vou estender para criar minha lógica de negócio (no Angular, isso costuma ser um *componente*), e uma *View*, ou a representação do meu arquivo HTML como Dart puro (ou, depois, JavaScript).

Vamos criar primeiro o código gerado, ou “view”:

```dart
// A dart "partial library", that is, in the namespace of another library.
part of list;

class _ViewListController extends View<ListController> {
  UListElement _ul;
  List<String> _itemsLastCheck = const [];

  @override
  Element build() {
    return _ul = new UListElement();
  }

  @override
  void detectChanges(ListController controller) {
    // Not an exhaustive check. In a real framework you'd need to verify that
    // the contents of the list are the same, not just the lists are of
    // different lengths.
    if (_itemsLastCheck.length != controller.items.length) {
      _updateItems(controller);
    }
  }

  void _updateItems(ListController controller) {
    // Intentionally not efficient. In a real framework you'd want to track
    // every <li> individually to avoid blowing away big parts of the DOM and
    // rebuilding.
    _ul.children
      ..clear()
      ..addAll(controller.items.map((i) => _createLi(controller, i)));
    _itemsLastCheck = controller.items.toList();
  }

  Element _createLi(ListController controller, String item) {
    final li = new LIElement()..appendText(item);
    li.append(new ButtonElement()
      ..text = 'Done'
      ..onClick.listen((_) => controller.onClick(item)));
    return li;
  }
}

```

Fiz alguns atalhos acima: por exemplo, *items* só é atualizado quando o tamanho da lista muda, e eu não mantenho nenhum estado, então, se a lista for atualizada, eu descarto o DOM existente e crio um novo. Um framework típico (incluindo o Angular) seria bem mais inteligente nisso, mas parte deste artigo é mostrar exatamente quanto trabalho acontece nos bastidores até para o data binding mais simples.

Por fim, vamos atualizar nosso controller para usar o nosso framework:

```dart
library list;

import 'dart:html';

import 'package:mvc_data_binding/framework.dart';

// Would be generated in a typical framework.
part 'list.g.dart';

class ListController extends Controller {
  final List<String> items;

  ListController(this.items);

  void onClick(String item) {
    items.remove(item);
    markDirty();
  }

  @override
  final view = new _ViewListController();
}

```

E juntamos tudo no *main.dart*:

```html
<html>
  <body>
    <div id="todo-list"></div>
  </body>
  <script type="application/dart" src="main.dart"></script>
  <script src="packages/browser/dart.js"></script>
</html>

```

```dart
import 'dart:html';

import 'package:mvc_data_binding/list.dart';

main() {
  final sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  final container = document.querySelector('#todo-list');
  final component = new ListController(sundays);
  container.append(component.view.build());

  // Start change detection. This should be automatic in most frameworks.
  component.view.detectChanges(component);
}


```

Agora temos um framework MVC *no estilo Angular*, e imagino que levaria de algumas horas a alguns dias (ou semanas, ou meses) para criar um gerador de código que emitisse automaticamente o arquivo .g.dart para você, dependendo de quão simples ou complexo você quiser ir. Isso, porém, está fora do escopo deste artigo.

### Data binding no estilo reativo {:#reactive-style-data-binding}

A abordagem funcional ou reativa ao data binding é diferente: em vez de separar a lógica da view e a do controller, você modela sua aplicação como funções (ou classes) que recebem como entrada valores (dados) e emitem como saída uma “view” (HTML, neste caso).

Essa é a abordagem adotada pelo React, pelo Vue e até pelo [Flutter](https://flutter.io).

Considere o seguinte:

```dart
Node todoList(List<String> todos) => new Tag(
  'ul',
  children: todos.map(
    (i) => new Tag('li', children: [
      new Text(i),
      new Tag('button', children: [
        'Done',
      ], events: {
        'click': () => throw new UnimplementedError(),
      }),
    ]),
  ).toList(),
);

```

Isso não é tão diferente do que fizemos acima no *template binding estático*, exceto que as bibliotecas e frameworks modernos usam uma série de algoritmos para minimizar o impacto no DOM. Por exemplo, se você remover um único `&lt;li&gt;`, um framework típico como o *React* não reconstrói nada.

**PROs**:

* Você consegue encapsular toda a lógica do seu “componente” em um único lugar.

* Não exige nenhum pré-processamento ou compilador especial.

* Para programas escritos com o SDK do Flutter, por exemplo, [sua IDE se torna sua divindade](https://flutter.io/intellij-ide/). Autocompletar tudo, e você nunca precisa nem aprender a digitar (mais ou menos).

* Fácil de usar, e [ferramentas opcionais como o JSX](https://facebook.github.io/react/docs/introducing-jsx.html) podem deixar isso bem mais conciso.

**CONs**:

* Como antes, os puristas do MVC (e partes das equipes de DevRel de plataformas web de várias empresas) podem reclamar um pouco: agora você está colocando HTML, JavaScript e, possivelmente, CSS dentro de uma função (ou classe) JavaScript.

* Diferentemente de algo como o Angular (que também tem os seus próprios problemas), você não consegue “inspecionar” facilmente o código gerado por essa função. Ou seja, você precisa conhecer muito bem as peculiaridades do framework ao otimizar listas com milhares de itens, rolagem preguiçosa e assim por diante.

Eu prometi escrever uma biblioteca simples para um framework de data binding no estilo reativo, mas, no fim deste artigo, decidi que isso já tinha sido feito melhor pelo meu colega Yegor com o framework “Butterfly”:

<GitHubEmbed repo="yjbanov/butterfly" title="butterfly - A web framework for Dart based on Flutter's widget model" image="images/0mC9GWhN0QE2u20u0.webp" />


```dart
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:butterfly/butterfly.dart';

class App extends StatelessWidget {
  Node build() {
    return div(attrs: {'id': 'greeting'})([
      text('Hello, World!'),
      button(eventListeners: {
        EventType.click: (_) {
          print('Woohoo!');
        }
      })([
        text('Update'),
      ]),
    ]);
  }
}
```

## Então, qual é a conclusão? {:#so-what-is-the-conclusion}

Não há conclusão, então desculpe se você chegou até aqui esperando uma tabela de benchmark ou algo para justificar as 200 horas que você gastou migrando um projeto para o framework mais novo e mais badalado. Pode-se argumentar que cada abordagem tem seus pontos fortes e fracos, e tenho visto mais frameworks começarem a usar modelos híbridos em alguns pontos também.

Algumas regras práticas para levar para casa:

* **Data binding é difícil**. Lembre-se disso da próxima vez que você se perguntar por que não existe uma “biblioteca de data binding simples e leve que faça só X e Y”.

* **Sistemas de template são construídos em torno de trade-offs**. Você sacrifica ergonomia, velocidade ou complexidade. Ainda não usei um único framework que tenha sucesso completo em tudo, e meu palpite é que ninguém jamais deu conta de todos os frameworks e modelos que existem.

* Se você está construindo o seu próprio site e tem vontade de escrever um “micro” framework, **comece simples**. Faça o mínimo possível de coisas e só adicione complexidade quando ela resolver um problema *grande*. **O boilerplate em si não é ruim**; ruim é o boilerplate sujeito a erros e difícil de escrever *corretamente*.

Eu teria interesse em saber o que os leitores acharam e se gostariam que eu entrasse em mais detalhes sobre algum assunto específico. Tenham um ótimo 4 de julho!
