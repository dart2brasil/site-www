---
ia-translate: true
title: Aplicativos de linha de comando e servidor
shortTitle: Aplicativos CLI e servidor
description: Tudo relacionado a aplicativos de linha de comando e de servidor.
showToc: false
---

Esta página aponta para ferramentas e documentação
que podem ajudar você a desenvolver aplicativos de linha de comando e de servidor.

## Ferramentas {:#tools}

[DartPad](/tools/dartpad)
: Útil tanto para iniciantes quanto para especialistas,
  o DartPad permite experimentar recursos da linguagem e as APIs dart:*.

  :::note
  O DartPad **não** oferece suporte a bibliotecas da VM, como `dart:io`,
  nem à importação de bibliotecas de pacotes
  além dos [pacotes atualmente suportados][currently supported packages].
  :::

[Dart SDK](/tools/sdk)
: [Instale o Dart SDK](/get-dart) para obter as bibliotecas principais do Dart
  e as [ferramentas](/tools).

[currently supported packages]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

## Arquiteturas e frameworks de servidor {:#frameworks}

O Dart oferece suporte a várias arquiteturas de backend, dependendo dos
requisitos da sua aplicação:

| Arquitetura / framework | Melhor para | Principais vantagens | Dados e persistência |
| :--- | :--- | :--- | :--- |
| **[Cloud Functions for Firebase][firebase-docs]** | APIs HTTP sem servidor e APIs chamáveis, backends para aplicativos Flutter | Código compartilhado com Flutter, zero gerenciamento de servidor, inicializações a frio rápidas com AOT | Cloud Firestore e Cloud Storage via [`firebase_admin_sdk`][] |
| **[Serverpod](https://serverpod.dev)** | Aplicações full-stack, backends para aplicativos Flutter | Autenticação, armazenamento de arquivos, funções de servidor e geração de código integrados | Bancos PostgreSQL e Redis (ORM e migrations integrados) |
| **[Dart Frog](https://dart-frog.dev/)** | APIs REST rápidas, microsserviços modulares | Roteamento minimalista, injeção de dependências, construído sobre o Shelf | Independente de banco de dados |
| **[Shelf][`shelf`]** | Servidores web personalizados, middleware componível | Primitiva leve, arquitetura modular | Independente de banco de dados |

{:.table .table-striped}

Para criar aplicações full-stack com IA, fluxos do lado do servidor e fluxos de trabalho agênticos,
use o [Genkit Dart][] ou pesquise no site do pub.dev outros [pacotes de IA][ai-pkgs].

Para mais ferramentas e plugins de IDE, veja a página [Ferramentas](/tools).
Para opções adicionais, veja [pacotes #server no pub.dev][server-pkgs].

[Genkit Dart]: https://genkit.dev/docs/dart/get-started/
[ai-pkgs]: {{site.pub-pkg}}?q=topic%3Aai
[server-pkgs]: {{site.pub-pkg}}?q=topic%3Aserver

## Criando backends sem servidor com Cloud Functions for Firebase {:#building-serverless-backends-with-cloud-functions-for-firebase}

Escreva Cloud Functions for Firebase em Dart para habilitar o desenvolvimento full-stack,
reutilizar código entre o cliente e o backend e responder a gatilhos do Firebase.
As Cloud Functions em Dart são compiladas antecipadamente (AOT) para binários nativos que são implantados
diretamente na infraestrutura do Google Cloud, oferecendo inicializações a frio rápidas
com pouco consumo de memória.

Para começar, veja a
[documentação de Cloud Functions for Firebase][firebase-docs].

[Pacote Firebase Functions]({{site.pub-pkg}}/firebase_functions)
: O pacote principal para escrever funções e APIs de backend em Dart.

[Pacote Firebase Admin SDK]({{site.pub-pkg}}/firebase_admin_sdk)
: Acesse os serviços do Firebase com segurança a partir de servidores de backend ou Cloud Functions.
  Use-o para gerenciar dados, enviar notificações ou verificar tokens de autenticação.

[Repositório do Firebase Functions for Dart][firebase-repo]
: Repositório no GitHub com guias de início rápido, exemplos e código-fonte.

[firebase-docs]: https://firebase.google.com/docs/functions/start-dart
[firebase-repo]: https://github.com/firebase/firebase-functions-dart

### Compartilhando código entre aplicativos Flutter e backends Dart {:#sharing-code-between-flutter-apps-and-dart-backends}

Quando você usa Dart tanto no cliente Flutter quanto no backend do Firebase, pode
organizar seu workspace em um monorepo ou em uma estrutura com vários pacotes e um
pacote compartilhado:

```text
my_project/
├── packages/
│   ├── app/           # Flutter frontend application
│   ├── functions/     # Cloud Functions for Firebase in Dart
│   └── shared/        # Shared models, DTOs, and validation logic
```

Ao colocar classes de dados, lógica de serialização JSON e regras de validação em
`package:shared`, qualquer mudança nos seus modelos de dados se propaga para o cliente
e para o servidor, mantendo o frontend e o backend sincronizados.

## Exemplos {:#samples}

[Um servidor HTTP simples em Dart][simple-sample]
: * Usa o pacote [`shelf`][].
  * Também usa os pacotes [`shelf_router`][] e [`shelf_static`][].
  * Pode ser implantado no Cloud Run.

[Um servidor HTTP em Dart que usa o Cloud Firestore][cloud-sample]
: * Usa o Cloud Firestore com o pacote [`firebase_admin_sdk`][].
  * Pode ser implantado no Cloud Run.

[simple-sample]: {{site.repo.dart.samples}}/tree/main/server/simple
[cloud-sample]: {{site.repo.dart.samples}}/tree/main/server/google_apis
[`firebase_admin_sdk`]: {{site.pub-pkg}}/firebase_admin_sdk
[`shelf`]: {{site.pub-pkg}}/shelf
[`shelf_router`]: {{site.pub-pkg}}/shelf_router
[`shelf_static`]: {{site.pub-pkg}}/shelf_static

## Mais recursos {:#more-resources}

[API do Dart]({{site.dart-api}})
: Referência da API das bibliotecas dart:*.

[Documentação de `dart:io`](/libraries/dart-io)
: Mostra como usar os principais recursos da biblioteca dart:io.
  Você pode usar a biblioteca dart:io em scripts de linha de comando, servidores e
  não web [aplicativos Flutter.]({{site.flutter}})

[Usando o Google Cloud][Using Google Cloud]
: Guias e documentação sobre os produtos do Google Cloud
  que servidores Dart podem usar, como o Cloud Run.

[Usando as APIs do Google][Using Google APIs]
: Recursos para ajudar você a usar as APIs de cliente do Firebase e do Google em um aplicativo Dart.

[Using Google Cloud]: /server/google-cloud
[Using Google APIs]: /resources/google-apis
