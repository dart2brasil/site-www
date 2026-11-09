---
ia-translate: true
title: Usando JSON
description: Soluções Dart para ler e escrever JSON.
showBreadcrumbs: false
---

A maioria das aplicações móveis e web usa JSON para tarefas como
trocar dados com um servidor web.
Esta página discute o suporte do Dart para _serialização_ e _desserialização_ de JSON:
converter objetos Dart de e para JSON.


## Bibliotecas {:#libraries}

As seguintes bibliotecas e pacotes são úteis em todas as plataformas Dart:

* [dart:convert](/libraries/dart-convert)<br>
  Conversores tanto para JSON quanto para UTF-8
  (a codificação de caracteres que JSON exige).

* [package:json_serializable]({{site.pub-pkg}}/json_serializable)<br>
  Um pacote de geração de código fácil de usar.
  Quando você adiciona algumas anotações de metadados
  e usa o builder fornecido por este pacote,
  o sistema de build do Dart gera código de serialização e desserialização para você.

* [package:built_value]({{site.pub-pkg}}/built_value)<br>
  Uma alternativa poderosa e opinativa ao json_serializable.


## Recursos Flutter {:#flutter-resources}

[JSON e serialização]({{site.flutter-docs}}/development/data-and-backend/json)
: Mostra como aplicações Flutter podem serializar e desserializar tanto
  com dart:convert quanto com json_serializable.


## Recursos para aplicações web {:#web-app-resources}

[Buscar dados da internet](/server/fetch-data)
: Demonstra como usar `package:http` para buscar dados com um servidor web.
