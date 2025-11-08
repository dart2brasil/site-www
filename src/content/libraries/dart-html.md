---
ia-translate: true
title: dart:html
description: Aprenda sobre as principais funcionalidades da biblioteca dart:html do Dart.
prevpage:
  url: /libraries/dart-io
  title: dart:io
---

:::warning
A biblioteca `dart:html` está deprecated.
Em vez disso, use [`dart:js_interop`][] e [`package:web`][].
:::

Use a biblioteca [dart:html][] para programar o navegador, manipular objetos e
elementos no DOM, e acessar APIs HTML5. DOM significa *Document Object
Model*, que descreve a hierarquia de uma página HTML.

Outros usos comuns de dart:html são manipular estilos (*CSS*), obter
dados usando requisições HTTP, e trocar dados usando
[WebSockets](#sending-and-receiving-real-time-data-with-websockets).
HTML5 (e dart:html) possui muitas
APIs adicionais que esta seção não cobre. Apenas aplicações web podem usar
dart:html, não aplicações de linha de comando.

:::note
Para aplicações maiores ou se você já tem uma aplicação Flutter,
considere usar [Flutter para web.]({{site.flutter}}/web)
:::

Para usar a biblioteca HTML em sua aplicação web, importe dart:html:

<?code-excerpt "html/lib/html.dart (import)"?>
```dart
import 'dart:html';
```

[`dart:js_interop`]: /interop/js-interop
[`package:web`]: {{site.pub-pkg}}/web
[Migrate to package:web]: /interop/js-interop/package-web

## Manipulando o DOM

Para usar o DOM, você precisa conhecer sobre *windows*, *documents*,
*elements*, e *nodes*.

Um objeto [Window][] representa
a janela real do navegador web. Cada Window possui um objeto Document,
que aponta para o documento que está carregado atualmente. O objeto Window
também possui acessores para várias APIs como IndexedDB (para armazenar dados),
requestAnimationFrame (para animações), e mais. Em navegadores com abas,
cada aba possui seu próprio objeto Window.

Com o objeto [Document][], você pode criar e manipular objetos [Element][]
dentro do documento. Note que o próprio documento é um elemento e pode ser
manipulado.

O DOM modela uma árvore de
[Nodes.][Nodes] Esses nodes são frequentemente
elementos, mas também podem ser atributos, texto, comentários, e outros tipos
do DOM. Exceto pelo node raiz, que não possui pai, cada node no
DOM possui um pai e pode ter muitos filhos.

### Encontrando elementos

Para manipular um elemento, você primeiro precisa de um objeto que o represente.
Você pode obter este objeto usando uma consulta.

Encontre um ou mais elementos usando as funções de nível superior
`querySelector()` e `querySelectorAll()`.
Você pode consultar por ID, classe, tag, nome, ou qualquer combinação destes.
O [guia de Especificação de Seletores CSS](https://www.w3.org/TR/css3-selectors/)
define os formatos dos seletores, como usar um prefixo \# para especificar IDs
e um ponto (.) para classes.

A função `querySelector()` retorna o primeiro elemento que corresponde
ao seletor, enquanto `querySelectorAll()` retorna uma coleção de elementos
que correspondem ao seletor.

<?code-excerpt "html/lib/html.dart (query-selector)"?>
```dart
// Find an element by id (an-id).
Element idElement = querySelector('#an-id')!;

// Find an element by class (a-class).
Element classElement = querySelector('.a-class')!;

// Find all elements by tag (<div>).
List<Element> divElements = querySelectorAll('div');

// Find all text inputs.
List<Element> textInputElements = querySelectorAll('input[type="text"]');

// Find all elements with the CSS class 'class'
// inside of a <p> that is inside an element with
// the ID 'id'.
List<Element> specialParagraphElements = querySelectorAll('#id p.class');
```

### Manipulando elementos

Você pode usar propriedades para mudar o estado de um elemento. Node e seu
subtipo Element definem as propriedades que todos os elementos possuem. Por
exemplo, todos os elementos possuem as propriedades `classes`, `hidden`, `id`, `style`, e
`title` que você pode usar para definir o estado. Subclasses de Element
definem propriedades adicionais, como a propriedade `href` de
[AnchorElement.][AnchorElement]

Considere este exemplo de especificar um elemento âncora em HTML:

<?code-excerpt "html/test/html_test.dart (anchor-html)" replace="/.*'(.*?)'.*/$1/g"?>
```html
<a id="example" href="/another/example">link text</a>
```

Esta tag `<a>` especifica um elemento com um atributo `href` e um node
de texto (acessível via propriedade `text`) que contém a string
"link text". Para mudar a URL para a qual o link aponta, você pode usar
a propriedade `href` de AnchorElement:

<?code-excerpt "html/test/html_test.dart (href)" plaster="none"?>
```dart
var anchor = querySelector('#example') as AnchorElement;
anchor.href = 'https://dart.dev';
```

Frequentemente você precisa definir propriedades em múltiplos elementos. Por exemplo, o
código a seguir define a propriedade `hidden` de todos os elementos que possuem uma
classe "mac", "win", ou "linux". Definir a propriedade `hidden` como true
tem o mesmo efeito que adicionar `display: none` ao CSS.

<?code-excerpt "html/test/html_test.dart (os-html)" replace="/.*? = '''|''';$//g"?>
```html
<!-- In HTML: -->
<p>
  <span class="linux">Words for Linux</span>
  <span class="macos">Words for Mac</span>
  <span class="windows">Words for Windows</span>
</p>
```

<?code-excerpt "html/test/html_test.dart (os)"?>
```dart
// In Dart:
const osList = ['macos', 'windows', 'linux'];
final userOs = determineUserOs();

// For each possible OS...
for (final os in osList) {
  // Matches user OS?
  bool shouldShow = (os == userOs);

  // Find all elements with class=os. For example, if
  // os == 'windows', call querySelectorAll('.windows')
  // to find all elements with the class "windows".
  // Note that '.$os' uses string interpolation.
  for (final elem in querySelectorAll('.$os')) {
    elem.hidden = !shouldShow; // Show or hide.
  }
}
```

Quando a propriedade correta não está disponível ou conveniente, você pode usar
a propriedade `attributes` de Element. Esta propriedade é um
`Map<String, String>`, onde as chaves são nomes de atributos. Para uma lista de
nomes de atributos e seus significados, veja a [página de Atributos do MDN.](https://developer.mozilla.org/docs/Web/HTML/Attributes) Aqui está um
exemplo de definir o valor de um atributo:

<?code-excerpt "html/lib/html.dart (attributes)"?>
```dart
elem.attributes['someAttribute'] = 'someValue';
```

### Criando elementos

Você pode adicionar a páginas HTML existentes criando novos elementos e
anexando-os ao DOM. Aqui está um exemplo de criar um elemento
parágrafo (\<p\>):

<?code-excerpt "html/lib/html.dart (creating-elements)"?>
```dart
var elem = ParagraphElement();
elem.text = 'Creating is easy!';
```

Você também pode criar um elemento analisando texto HTML. Quaisquer elementos filhos
também são analisados e criados.

<?code-excerpt "html/lib/html.dart (creating-from-html)"?>
```dart
var elem2 = Element.html('<p>Creating <em>is</em> easy!</p>');
```

Note que `elem2` é um `ParagraphElement` no exemplo anterior.

Anexe o elemento recém-criado ao documento atribuindo um pai
ao elemento. Você pode adicionar um elemento aos filhos de qualquer elemento existente.
No exemplo a seguir, `body` é um elemento, e seus elementos filhos
são acessíveis (como `List<Element>`) a partir da propriedade `children`.

<?code-excerpt "html/lib/html.dart (body-children-add)"?>
```dart
document.body!.children.add(elem2);
```

### Adicionando, substituindo e removendo nodes

Lembre-se que elementos são apenas um tipo de node. Você pode encontrar todos os
filhos de um node usando a propriedade `nodes` de Node, que retorna uma
`List<Node>` (em oposição a `children`, que omite nodes não-Element).
Uma vez que você tem esta lista, pode usar os métodos e
operadores usuais de List para manipular os filhos do node.

Para adicionar um node como o último filho de seu pai, use o método `add()` de List:

<?code-excerpt "html/lib/html.dart (nodes-add)"?>
```dart
querySelector('#inputs')!.nodes.add(elem);
```

Para substituir um node, use o método `replaceWith()` de Node:

<?code-excerpt "html/lib/html.dart (replace-with)"?>
```dart
querySelector('#status')!.replaceWith(elem);
```

Para remover um node, use o método `remove()` de Node:

<?code-excerpt "html/lib/html.dart (remove)"?>
```dart
// Find a node by ID, and remove it from the DOM if it is found.
querySelector('#expendable')?.remove();
```

### Manipulando estilos CSS

CSS, ou *cascading style sheets*, define os estilos de apresentação de elementos
DOM. Você pode mudar a aparência de um elemento anexando atributos de ID
e classe a ele.

Cada elemento possui um campo `classes`, que é uma lista. Adicione e remova classes
CSS simplesmente adicionando e removendo strings desta coleção. Por
exemplo, o exemplo a seguir adiciona a classe `warning` a um elemento:

<?code-excerpt "html/lib/html.dart (classes-add)"?>
```dart
var elem = querySelector('#message')!;
elem.classes.add('warning');
```

É frequentemente muito eficiente encontrar um elemento por ID. Você pode dinamicamente
definir um ID de elemento com a propriedade `id`:

<?code-excerpt "html/lib/html.dart (set-id)"?>
```dart
var message = DivElement();
message.id = 'message2';
message.text = 'Please subscribe to the Dart mailing list.';
```

Você pode reduzir o texto redundante neste exemplo usando cascatas de método:

<?code-excerpt "html/lib/html.dart (elem-set-cascade)"?>
```dart
var message = DivElement()
  ..id = 'message2'
  ..text = 'Please subscribe to the Dart mailing list.';
```

Embora usar IDs e classes para associar um elemento a um conjunto de estilos
seja a melhor prática, às vezes você quer anexar um estilo específico diretamente
ao elemento:

<?code-excerpt "html/lib/html.dart (set-style)"?>
```dart
message.style
  ..fontWeight = 'bold'
  ..fontSize = '3em';
```

### Tratando eventos

Para responder a eventos externos como cliques, mudanças de foco, e
seleções, adicione um event listener. Você pode adicionar um event listener a qualquer
elemento na página. Despacho e propagação de eventos é um assunto
complicado; [pesquise os
detalhes](https://www.w3.org/TR/DOM-Level-3-Events/#dom-event-architecture)
se você é novo em programação web.

Adicione um event handler usando
<code><em>element</em>.on<em>Event</em>.listen(<em>function</em>)</code>,
onde <code><em>Event</em></code> é o nome do evento
e <code><em>function</em></code> é o event handler.

Por exemplo, aqui está como você pode tratar cliques em um botão:

<?code-excerpt "html/lib/html.dart (on-click)"?>
```dart
// Find a button by ID and add an event handler.
querySelector('#submitInfo')!.onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
```

Eventos podem se propagar para cima e para baixo na árvore DOM. Para descobrir qual
elemento originalmente disparou o evento, use `e.target`:

<?code-excerpt "html/lib/html.dart (target)"?>
```dart
document.body!.onClick.listen((e) {
  final clickedElem = e.target;
  // ...
});
```

Para ver todos os eventos para os quais você pode registrar um event listener, procure
por propriedades "onEventType" na documentação da API para [Element][] e suas
subclasses. Alguns eventos comuns incluem:

-   change
-   blur
-   keyDown
-   keyUp
-   mouseDown
-   mouseUp


## Usando recursos HTTP com HttpRequest

Você deve evitar usar `dart:html` diretamente para fazer requisições HTTP.
A classe [`HttpRequest`][] em `dart:html` é dependente de plataforma
e vinculada a uma única implementação.
Em vez disso, use uma biblioteca de nível superior como
[`package:http`]({{site.pub-pkg}}/http).

O tutorial [Fetch data from the internet][]
explica como fazer requisições HTTP
usando `package:http`.

## Enviando e recebendo dados em tempo real com WebSockets

Um WebSocket permite que sua aplicação web troque dados com um servidor
interativamente—sem necessidade de polling. Um servidor cria o WebSocket e
escuta requisições em uma URL que começa com **ws://**—por exemplo,
ws://127.0.0.1:1337/ws. Os dados transmitidos através de um WebSocket podem ser uma
string ou um blob. Frequentemente, os dados são uma string formatada em JSON.

Para usar um WebSocket em sua aplicação web, primeiro crie um objeto [WebSocket][], passando
a URL do WebSocket como argumento:

{% comment %}
Code inspired by:
https://github.com/dart-lang/dart-samples/blob/master/html5/web/websockets/basics/websocket_sample.dart

Once tests are written for the samples, consider getting code excerpts from
the websocket sample app.
{% endcomment %}

<?code-excerpt "html/test/html_test.dart (WebSocket)"?>
```dart
var ws = WebSocket('ws://echo.websocket.org');
```

### Enviando dados

Para enviar dados string no WebSocket, use o método `send()`:

<?code-excerpt "html/test/html_test.dart (send)"?>
```dart
ws.send('Hello from Dart!');
```

### Recebendo dados

Para receber dados no WebSocket, registre um listener para eventos de mensagem:

<?code-excerpt "html/test/html_test.dart (onMessage)" plaster="none"?>
```dart
ws.onMessage.listen((MessageEvent e) {
  print('Received message: ${e.data}');
});
```

O event handler de mensagem recebe um objeto [MessageEvent][].
O campo `data` deste objeto possui os dados do servidor.

### Tratando eventos WebSocket

Sua aplicação pode tratar os seguintes eventos de WebSocket: open, close, error,
e (como mostrado anteriormente) message. Aqui está um exemplo de um método que
cria um objeto WebSocket e registra handlers para eventos open, close,
error, e message:

<?code-excerpt "html/test/html_test.dart (initWebSocket)" plaster="none"?>
```dart
void initWebSocket([int retrySeconds = 1]) {
  var reconnectScheduled = false;

  print('Connecting to websocket');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      Timer(
        Duration(seconds: retrySeconds),
        () => initWebSocket(retrySeconds * 2),
      );
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    print('Connected');
    ws.send('Hello from Dart!');
  });

  ws.onClose.listen((e) {
    print('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    print('Error connecting to ws');
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
    print('Received message: ${e.data}');
  });
}
```


## Mais informações

Esta seção mal arranhou a superfície do uso da biblioteca dart:html.
Para mais informações, veja a documentação de
[dart:html.][dart:html]
Dart possui bibliotecas adicionais para APIs web mais especializadas, como
[web audio,][web audio] [IndexedDB,][IndexedDB] e [WebGL.][WebGL]

Para mais informações sobre bibliotecas web do Dart, veja a
[visão geral de bibliotecas web.][web library overview]

[AnchorElement]: {{site.dart-api}}/dart-html/AnchorElement-class.html
[dart:html]: {{site.dart-api}}/dart-html/dart-html-library.html
[Fetch data from the internet]: /tutorials/server/fetch-data
[Document]: {{site.dart-api}}/dart-html/Document-class.html
[Element]: {{site.dart-api}}/dart-html/Element-class.html
[`HttpRequest`]: {{site.dart-api}}/dart-html/HttpRequest-class.html
[IndexedDB]: {{site.dart-api}}/dart-indexed_db/dart-indexed_db-library.html
[MessageEvent]: {{site.dart-api}}/dart-html/MessageEvent-class.html
[Nodes]: {{site.dart-api}}/dart-html/Node-class.html
[web audio]: {{site.dart-api}}/dart-web_audio/dart-web_audio-library.html
[WebGL]: {{site.dart-api}}/dart-web_gl/dart-web_gl-library.html
[WebSocket]: {{site.dart-api}}/dart-html/WebSocket-class.html
[web library overview]: /web/libraries
[Window]: {{site.dart-api}}/dart-html/Window-class.html
