---
ia-translate: true
title: Usando JSON
description: Soluções Dart para leitura e escrita de JSON.
---

A maioria dos aplicativos móveis e web usa JSON para tarefas como
troca de dados com um servidor web.
Esta página discute o suporte do Dart para _serialização_ e _desserialização_ de JSON:
converter objetos Dart de e para JSON.

## Bibliotecas

As seguintes bibliotecas e pacotes são úteis em todas as plataformas Dart:

* [dart:convert](/libraries/dart-convert)<br>
  Conversores para JSON e UTF-8
  (a codificação de caracteres que o JSON requer).

* [package:json_serializable]({{site.pub-pkg}}/json_serializable)<br>
  Um pacote de geração de código fácil de usar.
  Quando você adiciona algumas anotações de metadados
  e usa o builder fornecido por este pacote,
  o sistema de build do Dart gera o código de serialização e desserialização para você.

* [package:built_value]({{site.pub-pkg}}/built_value)<br>
  Uma alternativa poderosa e opinativa ao json_serializable.

## Recursos Flutter

[JSON e serialização]({{site.flutter-docs}}/development/data-and-backend/json)
: Mostra como aplicativos Flutter podem serializar e desserializar tanto
  com dart:convert quanto com json_serializable.

## Recursos para aplicativos Web

[Buscar dados da internet](/tutorials/server/fetch-data)
: Demonstra como usar `package:http` para recuperar dados com um servidor web.

{% comment %}
## Recursos VM

[Escrever servidores HTTP](/tutorials/server/httpserver)
: Explica como implementar clientes e servidores de linha de comando
  que trocam dados JSON.

## Outras ferramentas e recursos
{% endcomment %}
