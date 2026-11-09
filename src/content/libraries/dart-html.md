---
ia-translate: true
title: dart:html
description: Conheça os principais recursos da biblioteca dart:html do Dart.
prevpage:
  url: /libraries/dart-io
  title: dart:io
---

:::warning
A biblioteca `dart:html` está descontinuada.
Você não pode usá-la em builds de `dart compile wasm` nem
ao compilar com a flag `--no-deprecated-js-interop`.
Em vez disso, use [`dart:js_interop`][] e [`package:web`][].
Para migrar o código existente,
veja [Migre para `package:web`][Migrate to package:web].
:::

Use a biblioteca [dart:html][] para programar o navegador, manipular objetos e
elementos no DOM e acessar as APIs do HTML5. DOM significa *Document Object
Model*, que descreve a hierarquia de uma página HTML.

Outros usos comuns do dart:html são manipular estilos (*CSS*), obter
dados por meio de requisições HTTP e trocar dados usando
[WebSockets](#sending-and-receiving-real-time-data-with-websockets).
O HTML5 (e o dart:html) tem muitas
APIs adicionais que esta seção não cobre. Somente aplicações web podem usar
dart:html, não aplicações de linha de comando.

:::note
Para aplicações maiores ou se você já tem uma aplicação Flutter,
considere usar o [Flutter para web.]({{site.flutter}}/web)
:::

Para usar a biblioteca HTML na sua aplicação web, importe o dart:html:

<?code-excerpt "html/lib/html.dart (import)"?>
```dart
import 'dart:html';
```

[`dart:js_interop`]: /interop/js-interop
[`package:web`]: {{site.pub-pkg}}/web
[Migrate to package:web]: /interop/js-interop/package-web

## Manipulando o DOM {:#manipulating-the-dom}

Para usar o DOM, você precisa conhecer *janelas*, *documentos*,
*elementos* e *nós*.

Um objeto [Window][] representa
a janela real do navegador. Cada Window tem um objeto Document,
que aponta para o documento atualmente carregado. O objeto Window
também oferece acesso a várias APIs, como IndexedDB (para armazenar dados),
requestAnimationFrame (para animações) e outras. Em navegadores com abas,
cada aba tem seu próprio objeto Window.

Com o objeto [Document][], você pode criar e manipular objetos [Element][]
dentro do documento. Observe que o próprio documento é um elemento e também
pode ser manipulado.

O DOM modela uma árvore de
[Nós.][Nodes] Esses nós costumam ser
elementos, mas também podem ser atributos, texto, comentários e outros tipos
do DOM. Exceto pelo nó raiz, que não tem pai, cada nó no
DOM tem um pai e pode ter muitos filhos.

### Encontrando elementos {:#finding-elements}

Para manipular um elemento, primeiro você precisa de um objeto que o represente.
Você pode obter esse objeto usando uma consulta.

Encontre um ou mais elementos usando as funções de nível superior
`querySelector()` e `querySelectorAll()`.
Você pode consultar por ID, classe, tag, nome ou qualquer combinação desses.
O [guia da especificação de seletores CSS](https://www.w3.org/TR/css3-selectors/)
define os formatos dos seletores, como usar um prefixo \# para IDs
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

### Manipulando elementos {:#manipulating-elements}

Você pode usar propriedades para alterar o estado de um elemento. Node e seu
subtipo Element definem as propriedades que todos os elementos têm. Por
exemplo, todos os elementos têm as propriedades `classes`, `hidden`, `id`, `style` e
`title`, que você pode usar para definir o estado. Subclasses de Element
definem propriedades adicionais, como a propriedade `href` de
[AnchorElement.][AnchorElement]

Considere este exemplo de um elemento de âncora especificado em HTML:

<?code-excerpt "html/test/html_test.dart (anchor-html)" replace="/.*'(.*?)'.*/$1/g"?>
```html
<a id="example" href="/another/example">link text</a>
```

Esta tag `<a>` especifica um elemento com um atributo `href` e um nó de texto
(acessível pela propriedade `text`) que contém a string
"link text". Para alterar a URL para a qual o link aponta, você pode usar a
propriedade `href` do AnchorElement:

<?code-excerpt "html/test/html_test.dart (href)" plaster="none"?>
```dart
var anchor = querySelector('#example') as AnchorElement;
anchor.href = 'https://dart.dev';
```

Muitas vezes você precisa definir propriedades em vários elementos. Por exemplo, o
código a seguir define a propriedade `hidden` de todos os elementos que têm a
classe "mac", "win" ou "linux". Definir a propriedade `hidden` como true
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

Quando a propriedade certa não estiver disponível ou não for prática, você pode usar a
propriedade `attributes` do Element. Essa propriedade é um
`Map<String, String>`, em que as chaves são os nomes dos atributos. Para ver uma lista
de nomes de atributos e seus significados, veja a [página de Atributos do MDN.](https://developer.mozilla.org/docs/Web/HTML/Attributes)
Aqui está um exemplo de como definir o valor de um atributo:

<?code-excerpt "html/lib/html.dart (attributes)"?>
```dart
elem.attributes['someAttribute'] = 'someValue';
```

### Criando elementos {:#creating-elements}

Você pode adicionar conteúdo a páginas HTML existentes criando novos elementos e
anexando-os ao DOM. Aqui está um exemplo de criação de um elemento de parágrafo
(\<p\>):

<?code-excerpt "html/lib/html.dart (creating-elements)"?>
```dart
var elem = ParagraphElement();
elem.text = 'Creating is easy!';
```

Você também pode criar um elemento analisando texto HTML. Os elementos filhos
também são analisados e criados.

<?code-excerpt "html/lib/html.dart (creating-from-html)"?>
```dart
var elem2 = Element.html('<p>Creating <em>is</em> easy!</p>');
```

Observe que `elem2` é um `ParagraphElement` no exemplo anterior.

Anexe o elemento recém-criado ao documento atribuindo um pai
a ele. Você pode adicionar um elemento aos filhos de qualquer elemento existente.
No exemplo a seguir, `body` é um elemento, e seus elementos filhos
são acessíveis (como um `List<Element>`) pela propriedade `children`.

<?code-excerpt "html/lib/html.dart (body-children-add)"?>
```dart
document.body!.children.add(elem2);
```

### Adicionando, substituindo e removendo nós {:#adding-replacing-and-removing-nodes}

Lembre-se de que elementos são apenas um tipo de nó. Você pode encontrar todos os
filhos de um nó usando a propriedade `nodes` de Node, que retorna uma
`List<Node>` (diferente de `children`, que omite nós que não são Element).
Depois de ter essa lista, você pode usar os métodos e operadores habituais de List
para manipular os filhos do nó.

Para adicionar um nó como último filho do seu pai, use o método `add()`
de List:

<?code-excerpt "html/lib/html.dart (nodes-add)"?>
```dart
querySelector('#inputs')!.nodes.add(elem);
```

Para substituir um nó, use o método `replaceWith()` de Node:

<?code-excerpt "html/lib/html.dart (replace-with)"?>
```dart
querySelector('#status')!.replaceWith(elem);
```

Para remover um nó, use o método `remove()` de Node:

<?code-excerpt "html/lib/html.dart (remove)"?>
```dart
// Find a node by ID, and remove it from the DOM if it is found.
querySelector('#expendable')?.remove();
```

### Manipulando estilos CSS {:#manipulating-css-styles}

CSS, ou *cascading style sheets*, define os estilos de apresentação dos
elementos do DOM. Você pode alterar a aparência de um elemento atribuindo a ele
atributos de ID e classe.

Cada elemento tem um campo `classes`, que é uma lista. Adicione e remova classes
CSS simplesmente adicionando e removendo strings dessa coleção. Por
exemplo, o exemplo a seguir adiciona a classe `warning` a um elemento:

<?code-excerpt "html/lib/html.dart (classes-add)"?>
```dart
var elem = querySelector('#message')!;
elem.classes.add('warning');
```

Muitas vezes, é muito eficiente encontrar um elemento pelo ID. Você pode definir
dinamicamente o ID de um elemento com a propriedade `id`:

<?code-excerpt "html/lib/html.dart (set-id)"?>
```dart
var message = DivElement();
message.id = 'message2';
message.text = 'Please subscribe to the Dart mailing list.';
```

Você pode reduzir o texto redundante neste exemplo usando
cascatas de métodos:

<?code-excerpt "html/lib/html.dart (elem-set-cascade)"?>
```dart
var message = DivElement()
  ..id = 'message2'
  ..text = 'Please subscribe to the Dart mailing list.';
```

Embora usar IDs e classes para associar um elemento a um conjunto de estilos seja a
melhor prática, às vezes você quer aplicar um estilo específico diretamente
ao elemento:

<?code-excerpt "html/lib/html.dart (set-style)"?>
```dart
message.style
  ..fontWeight = 'bold'
  ..fontSize = '3em';
```

### Tratando eventos {:#handling-events}

Para responder a eventos externos, como cliques, mudanças de foco e
seleções, adicione um listener de evento. Você pode adicionar um listener de evento a qualquer
elemento da página. O disparo e a propagação de eventos são um assunto complicado;
[pesquise os detalhes](https://www.w3.org/TR/DOM-Level-3-Events/#dom-event-architecture)
se você está começando em programação web.

Adicione um handler de evento usando
<code><em>element</em>.on<em>Event</em>.listen(<em>function</em>)</code>,
em que <code><em>Event</em></code> é o nome do evento
e <code><em>function</em></code> é o handler do evento.

Por exemplo, veja como tratar cliques em um botão:

<?code-excerpt "html/lib/html.dart (on-click)"?>
```dart
// Find a button by ID and add an event handler.
querySelector('#submitInfo')!.onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
```

Eventos podem se propagar para cima e para baixo na árvore do DOM. Para descobrir qual
elemento originalmente disparou o evento, use `e.target`:

<?code-excerpt "html/lib/html.dart (target)"?>
```dart
document.body!.onClick.listen((e) {
  final clickedElem = e.target;
  // ...
});
```

Para ver todos os eventos para os quais você pode registrar um listener, procure
as propriedades "onEventType" na documentação da API de [Element][] e de suas
subclasses. Alguns eventos comuns incluem:

-   change
-   blur
-   keyDown
-   keyUp
-   mouseDown
-   mouseUp


## Usando recursos HTTP com HttpRequest {:#using-http-resources-with-httprequest}

Evite usar `dart:html` diretamente para fazer requisições HTTP.
A classe [`HttpRequest`][] em `dart:html` depende da plataforma
e está presa a uma única implementação.
Em vez disso, use uma biblioteca de nível mais alto, como
[`package:http`]({{site.pub-pkg}}/http).

O tutorial [Buscar dados da internet][Fetch data from the internet]
explica como fazer requisições HTTP
usando `package:http`.

## Enviando e recebendo dados em tempo real com WebSockets {:#sending-and-receiving-real-time-data-with-websockets}

Um WebSocket permite que sua aplicação web troque dados com um servidor
de forma interativa, sem necessidade de polling. Um servidor cria o WebSocket e
escuta requisições em uma URL que começa com **ws://**, por exemplo,
ws://127.0.0.1:1337/ws. Os dados transmitidos por um WebSocket podem ser uma
string ou um blob. Frequentemente, os dados são uma string formatada em JSON.

Para usar um WebSocket na sua aplicação web, primeiro crie um objeto [WebSocket][], passando
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

### Enviando dados {:#sending-data}

Para enviar dados em string pelo WebSocket, use o método `send()`:

<?code-excerpt "html/test/html_test.dart (send)"?>
```dart
ws.send('Hello from Dart!');
```

### Recebendo dados {:#receiving-data}

Para receber dados pelo WebSocket, registre um listener para eventos
de mensagem:

<?code-excerpt "html/test/html_test.dart (onMessage)" plaster="none"?>
```dart
ws.onMessage.listen((MessageEvent e) {
  print('Received message: ${e.data}');
});
```

O handler de eventos de mensagem recebe um objeto [MessageEvent][].
O campo `data` desse objeto tem os dados enviados pelo servidor.

### Tratando eventos do WebSocket {:#handling-websocket-events}

Sua aplicação pode tratar os seguintes eventos do WebSocket: open, close, error
e (como mostrado antes) message. Aqui está um exemplo de método que
cria um objeto WebSocket e registra handlers para os eventos open, close,
error e message:

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


## Mais informações {:#more-information}

Esta seção mal arranhou a superfície do uso da biblioteca dart:html. Para mais
informações, veja a documentação de
[dart:html.][dart:html]
O Dart tem bibliotecas adicionais para APIs web mais especializadas, como
[web audio,][web audio] [IndexedDB,][IndexedDB] e [WebGL.][WebGL]

Para mais informações sobre as bibliotecas web do Dart, veja a
[visão geral das bibliotecas web.][web library overview]

[AnchorElement]: {{site.dart-api}}/dart-html/AnchorElement-class.html
[dart:html]: {{site.dart-api}}/dart-html/dart-html-library.html
[Fetch data from the internet]: /server/fetch-data
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
