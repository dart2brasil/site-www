---
ia-translate: true
title: Usando JSON
description: Soluções Dart para ler e escrever JSON.
showBreadcrumbs: false
---

A maioria dos aplicativos mobile e web usa JSON para tarefas como
troca de dados com um servidor web.
Esta página discute o suporte Dart para _serialização_ e _desserialização_ JSON:
convertendo objetos Dart para e de JSON.


## Bibliotecas {:#bibliotecas}

As seguintes bibliotecas e pacotes são úteis em diversas plataformas Dart:

* [dart:convert](/libraries/dart-convert)<br>
  Conversores para JSON e UTF-8
  (a codificação de caracteres que o JSON requer).

* [package:json_serializable]({{site.pub-pkg}}/json_serializable)<br>
  Um pacote de geração de código fácil de usar.
  Quando você adiciona algumas anotações de metadados
  e usa o construtor fornecido por este pacote,
  o sistema de construção Dart gera código de serialização e desserialização para você.

* [package:built_value]({{site.pub-pkg}}/built_value)<br>
  Uma alternativa poderosa e com opiniões definidas ao `json_serializable`.


## Recursos Flutter {:#recursos-flutter}

[JSON e serialização]({{site.flutter-docs}}/development/data-and-backend/json)
: Mostra como aplicativos Flutter podem serializar e desserializar
  tanto com `dart:convert` quanto com `json_serializable`.


## Recursos para aplicativos web {:#recursos-para-aplicativos-web}

[Buscar dados da internet](/tutorials/server/fetch-data)
: Demonstra como usar `package:http` para recuperar dados de um servidor web.


{% comment %}
## Recursos VM {:#recursos-vm}

[Escrever servidores HTTP](/tutorials/server/httpserver)
: Apresenta como implementar clientes e servidores de linha de comando
  que trocam dados JSON.

## Outras ferramentas e recursos {:#outras-ferramentas-e-recursos}
{% endcomment %}

