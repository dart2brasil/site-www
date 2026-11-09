---
ia-translate: true
title: "Criando um app de chat em Dart"
description: "Depois de cobrir a fundo o básico dos pacotes “built”, agora estou pronto para elevar o nível mostrando-os em ação."
publishDate: 2016-12-14
author: davidmorgan
image: images/1pRJK2IRC697oavw5OBXkQA.webp
category: deep-dive
layout: blog
---


Escrevi este código em um dia e meio para usar como exemplo na minha [palestra na Dart Summit (vídeo)](https://www.youtube.com/watch?v=TMeJxWltoVo). Ele foi projetado para mostrar o built_value e o source_gen, mas também mostra algo sobre o Dart: dá para fazer *muita* coisa só com o SDK e os pacotes principais do [dart-lang](http://github.com/dart-lang).

<DashImage src="images/1pRJK2IRC697oavw5OBXkQA.webp" alt="Example chat app built with the built_value package running in a browser." caption="The built_value chat example in action." />


## Obtendo o código {:#getting-the-code}

Você pode ler o código [aqui](https://github.com/google/built_value.dart/tree/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example), mas vai ser mais divertido se você baixar e executar. Para isso, você vai precisar ter o [dart](https://www.dartlang.org/install) e o [git](https://git-scm.com/downloads) instalados. Depois:

```
git clone [https://github.com/google/built_value.dart.git](https://github.com/google/built_value.dart.git)
cd built_value.dart
git checkout tags/v0.4.3-article
cd chat_example
pub get

# Run these three in separate terminal windows.
pub serve
dart bin/main.dart
dart tool/watch.dart
```


Agora você pode acessar localhost:26199 no Dartium, no Chrome ou em qualquer navegador moderno. Você verá algo assim:
> Bem-vindo ao exemplo de chat do built_value. Para ajuda, digite /help.
> Você está conectado como anon9531.

Não é particularmente bonito, mas se você se conectar em mais algumas abas, vai ver que é um aplicativo de chat totalmente funcional. Ele tem login, mensagens de ausência/status e mensagens públicas e privadas.

Se você alterar o código, vai perceber que as mudanças do cliente são aplicadas imediatamente ao atualizar a página. Para mudanças no servidor, encerre e reinicie “dart bin/main.dart”.

## O que tem em um app de chat {:#whats-in-a-chat-app}

Nosso código do servidor vai precisar:

* servir HTML e CSS;

* acompanhar o estado dos usuários;

* enviar e receber mensagens.

O cliente vai precisar:

* fornecer uma UI que exiba texto e aceite entradas;

* enviar e receber mensagens.

Vamos ver isso peça por peça.

## Servindo HTML e CSS {:#serving-html-and-css}

Estou usando o [package:shelf](https://github.com/dart-lang/shelf#web-server-middleware-for-dart) do dart-lang. Para um serviço em produção, eu gostaria de pré-compilar os recursos a serem servidos, mas, por enquanto, vou focar no desenvolvimento, então HTML e CSS podem ir direto para o pub serve. Aqui está um [Cascade](https://www.dartdocs.org/documentation/shelf/0.6.7%2B2/shelf/Cascade-class.html) que faz isso:

```
var cascade = new Cascade()
  // Try sending requests to pub serve.
  .add(proxyHandler(Uri.parse(‘[http://localhost:8080’](http://localhost:8080'))))
  // If that didn't work, must be a problem with pub serve.
  .add((_) {
    print(‘Request failed. Check pub serve output for errors.’);
    return new Response.notFound(‘’);
  });
```


E um servidor:

```
await io.serve(cascade.handler, 'localhost', 26199);
```


Vamos ajustar isso um pouco mais tarde para adicionar o tratamento de mensagens.

## UI do cliente {:#client-ui}

Um cliente de chat não precisa de muita UI, e o SDK está mais do que preparado para isso. Primeiro, o campo de texto. Precisamos de [querySelector](https://api.dartlang.org/stable/1.21.0/dart-html/querySelector.html), [HtmlEscape](https://api.dartlang.org/stable/1.21.0/dart-convert/HtmlEscape-class.html) e [Window](https://api.dartlang.org/stable/1.21.0/dart-html/Window-class.html):

```
void addLocal(String text) {
  querySelector('#text').innerHtml +=
    '<div class="local">${_htmlEscape.convert(text)}</div>';
  window.scrollTo(0, document.body.scrollHeight);
}
```


E, em segundo lugar, o campo de entrada. Aqui está uma classe que transforma a entrada de texto em um [Stream&lt;String&gt;](https://api.dartlang.org/stable/1.21.0/dart-async/Stream-class.html) que qualquer um pode consumir:

```
class Input {
  final StreamController<String> _streamController =
      new StreamController<String>();

  Input() {
    final input = querySelector('#input') as InputElement;

    input.onKeyPress.listen((keyEvent) {
      if (keyEvent.keyCode == KeyCode.ENTER) {
        _streamController.add(input.value);
        input.value = '';
       }
    });
  }

  Stream<String> get keyboardInput => _streamController.stream;
}
```


Essas peças ficam sobre um [HTML](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/web/index.html) e um [CSS](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/web/main.css) mínimos. Depois, precisamos de um pouco de código para garantir que o elemento de entrada comece com o foco e o mantenha:

```
var screen = querySelector('#screen');
var text = querySelector('#text');
var input = querySelector('#input');

input.focus();

for (var element in [screen, text]) {
  element.onClick.listen((e) {
    input.focus();
  });
}
```


E é *isso*. Não há necessidade de nenhum framework. Obviamente, a UI é bem minimalista: se eu quisesse fazer mais, mudaria para o [Angular](http://angulardart.org).

## Comunicação cliente-servidor {:#client-server-communication}

Aplicativos de chat precisam conseguir enviar mensagens do servidor para o cliente, então POSTs simples não bastam. Optei por usar [WebSocket](https://api.dartlang.org/stable/1.21.0/dart-html/WebSocket-class.html)s, que fornecem canais de comunicação bidirecional persistentes.

Com o shelf, podemos simplesmente adicionar isto ao início do nosso Cascade:

```
var cascade = new Cascade()
 .add(webSocketHandler(socketReceiver))
```


Onde “socketReceiver” é uma função que aceita os [WebSocketChannel](https://www.dartdocs.org/documentation/web_socket_channel/1.0.4/web_socket_channel/WebSocketChannel-class.html)s recém-criados. O “webSocketHandler” rejeita requisições HTTP comuns, então elas continuam pelo cascade.

Conectar a partir do cliente também é simples:

```
var socket = new WebSocket('ws://${window.location.host}/ws');
socket.onMessage.listen((message) => <handle message>);
socket.send('Hello server!');
```


Claro que precisamos de um formato de transmissão; como escrevi este código para mostrar o built_value, estou, naturalmente, usando a sua [serialização](https://medium.com/@davidmorgan_14314/darts-built-value-for-serialization-f5db9d0f4159#.3nh1y6q6h). Apenas JSON puro com conversão escrita à mão seria direto, mas o objetivo de todo o built_value é que você ganhe isso de graça.

## Web Sockets e SSL {:#web-sockets-and-ssl}

Uma observação: atualmente, o exemplo usa conexões não criptografadas. Infelizmente, conexões WebSocket não criptografadas às vezes são bloqueadas por proxies mal configurados. A forma de resolver isso é migrar para criptografar o site inteiro, ou seja, usar “https” em vez de “http”. Isso dá trabalho, mas é discutivelmente uma boa ideia por [outros motivos](https://letsencrypt.org/).

## Modelo de objetos {:#object-model}

No centro do exemplo de chat há um modelo de objetos compartilhado entre o servidor e o cliente. Como estamos usando o built_value, podemos enviar essas classes pela rede. Por exemplo, esta classe é usada para enviar um chat:

```
abstract class Chat implements Command {
  String get text;
  BuiltSet<String> get targets;
}
```


A lógica de login no servidor, a lógica do cliente e a renderização no cliente são todas construídas em torno dessas classes do modelo de objetos.

## Lógica do cliente {:#client-logic}

Quando você digita algo, o código do cliente precisa identificar e tratar os possíveis comandos. Isso é uma simples questão de comparação de strings, seguida da criação e do envio das classes do modelo de objetos apropriadas. [Código completo](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/lib/client/client.dart).

Por exemplo, se você digitar algo começando com “/away”, isso é convertido em uma atualização de status:

```
_send(new Status((b) => b
  ..message = command.substring(‘/away ‘.length)
  ..type = StatusType.away));
```


## Renderização no cliente {:#client-rendering}

Todas as mensagens que o servidor pode enviar implementam esta interface:

```
abstract class Response {
  String render();
}
```


Assim, ao receber uma mensagem, o cliente simplesmente chama “render” e exibe o resultado. Por exemplo, a classe ShowChat, que pode conter mensagens públicas ou privadas:

```
class ShowChat implements Response {
  String get username;
  bool get private;
  String get text;

  @override
  String render() =>
    '$username${private ? "(private)" : ""}: $text';
}
```


Aliás, esse padrão de encapsular lógica simples de renderização dentro de classes de dados também funciona muito bem para internacionalização.

## Lógica do servidor {:#server-logic}

No servidor, mantemos o estado: o log do chat, os nomes de usuário e as senhas, e os status dos usuários. Quando uma mensagem é recebida, atualizamos o estado e enviamos mensagens conforme necessário. [Código completo](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/lib/server/server.dart).

Por exemplo, aqui “command” é uma mensagem recebida de um cliente. Se for uma mensagem de “chat”, verificamos se ela deve ser privada, isto é, se especifica destinatários, e a enviamos para todos ou apenas para os destinatários, conforme o caso.

```
if (command is Chat) {
  _chat(connection, command);
}

...

void _chat(ServerConnection connection, Chat chat) {
  if (chat.targets.isEmpty) {
    _sendToAll(new ShowChat((b) => b
      ..username = connection.username
      ..private = false
      ..text = chat.text));
  } else {
    _sendTo(
      chat.targets,
      new ShowChat((b) => b
        ..username = connection.username
        ..private = true
        ..text = chat.text));
  }
}
```


## É isso, pessoal {:#thats-all-folks}

E pronto: um servidor e um cliente de chat em 820 linhas de código. Para quem está contando, outras 1120 linhas são geradas pelo built_value, e os testes end to end ocuparam 155 linhas.

Espera, testes end to end?

Eu disse que levei um dia e meio para escrever; no meio do caminho, fiquei irritado porque, toda vez que adicionava um recurso, precisava testar manualmente para garantir que não tinha quebrado mais nada. Então dei um passo atrás, refatorei para facilitar os testes e adicionei cobertura de testes para os recursos principais.

Na próxima semana vou explicar exatamente como o exemplo de chat é testado e como é ótimo testar com Dart tanto no servidor quanto no cliente.

Editado: [próximo artigo](https://medium.com/@davidmorgan_14314/end-to-end-testing-in-one-short-second-with-dart-e699c8146fd6#.c7xfxohg4).
