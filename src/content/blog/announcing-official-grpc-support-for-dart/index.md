---
ia-translate: true
title: "Anunciando o suporte oficial a gRPC para Dart"
description: "gRPC é um framework RPC open source de alta performance. Ele oferece definições de serviço simples, é construído sobre HTTP/2 e tem suporte a…"
publishDate: 2018-03-23
author: mit-mit
category: announcements
layout: blog
---


<DashImage src="images/1tWFciSm58uLmvp8i_t3WaQ.webp" alt="O logo do gRPC." />


gRPC é um framework RPC open source de alta performance. Ele oferece definições de serviço simples, é construído sobre HTTP/2 e tem suporte a streaming bidirecional e autenticação plugável totalmente integrada. O framework gRPC suporta uma [ampla gama de linguagens](https://grpc.io/docs/), e temos o prazer de anunciar que o suporte à linguagem Dart já está disponível em beta! O suporte a gRPC no Dart funciona com o SDK do Dart, versão 1.24.3 ou superior, e atualmente oferece suporte às plataformas [Flutter](https://flutter.io/) e [VM/Server](https://www.dartlang.org/dart-vm).

## Criando um servidor e escrevendo definições de serviço gRPC {:#creating-a-server-and-writing-grpc-service-definitions}

Serviços gRPC normalmente descrevem seus endpoints e a serialização dos dados usando [Protocol Buffers](https://github.com/dart-lang/protobuf) v3. Aqui está um pequeno exemplo de definição de serviço, que define um serviço 'Greeter' com uma única rpc de mensagem 'SayHello' (o número '1' nas duas mensagens especifica o ID único do [campo da mensagem](https://developers.google.com/protocol-buffers/docs/overview)):


Depois de definir o serviço, você pode gerar automaticamente o esqueleto do servidor:

```
protoc --dart_out=grpc:generated -Iprotos protos/greeter.proto
```


Isso vai produzir uma classe GreeterServiceBase no diretório `generated`, que você então estende (subclasse) para adicionar a implementação real do serviço:


## Chamando o servidor com um cliente gRPC {:#calling-the-server-with-a-grpc-client}

Quando geramos o stub do serviço acima, o compilador `protoc` também gerou uma biblioteca cliente:


Com isso, chamar o serviço a partir da camada cliente é simples:


Ao ser executado, isso vai imprimir a seguinte saída:

```
Greeter client received: Hello, Michael!
```


## Próximos passos {:#next-steps}

Para começar com gRPC em Dart, dê uma olhada no nosso novo [QuickStart de gRPC para Dart](https://grpc.io/docs/quickstart/dart.html), que guia você na execução e na extensão do exemplo Greeter. Em seguida, confira o [tutorial de gRPC para Dart](https://grpc.io/docs/tutorials/basic/dart.html).

Se você encontrar algum problema, por favor [abra uma issue](https://github.com/grpc/grpc-dart/issues/new). Também ficaremos felizes em ouvir seu feedback sobre quaisquer mudanças ou adições que você gostaria de ver; por exemplo, recebemos vários pedidos de suporte ao [protocolo gRPC-Web](https://github.com/grpc/grpc-dart/issues/43). Uma forma concreta de dar feedback rápido é "votar" em uma issue clicando no botão de joinha 👍 do GitHub no comentário mais antigo da issue.

Estamos ansiosos para ver o que você pode construir com gRPC para Dart!
