---
ia-translate: true
title: Usando o Google Cloud
shortTitle: Google Cloud
description: >-
  Seu aplicativo Dart pode usar muitos serviços do Google Cloud:
  Firebase, Google Cloud Platform e muito mais.
---

Servidores Dart podem usar muitos
[produtos do Google Cloud](https://cloud.google.com/products),
frequentemente com a ajuda das
[Imagens Oficiais do Dart](https://hub.docker.com/_/dart) do Docker, já empacotadas.
Para começar a criar servidores HTTP com Dart,
confira alguns dos [frameworks de servidor][server-frameworks] populares.

Para informações sobre outras APIs do Google (incluindo o Firebase)
que você pode querer usar a partir do código Dart,
veja a [página de APIs do Google](/resources/google-apis).

[server-frameworks]: /server#frameworks

## Soluções recomendadas {:#recommended-solutions}

Para executar Dart na nuvem, recomendamos o uso de soluções de computação serverless.

### Cloud Run {:#cloud-run}

Você pode usar o suporte a containers flexíveis do Cloud Run,
combinado com as imagens Docker do Dart, para executar código Dart no servidor.
APIs escaláveis e de alto desempenho e aplicações orientadas a eventos
são bons casos de uso para a plataforma serverless do Cloud Run,
que libera os desenvolvedores do gerenciamento de infraestrutura.

Exemplos de servidores Dart implementados para rodar no Cloud Run estão
[no repositório dart-lang/samples][server examples].

Para mais informações sobre como usar o Cloud Run, veja a documentação sobre
[como criar e implantar um serviço em outras linguagens][cr].

### Cloud Functions para Firebase {:#cloud-functions-for-firebase}

Escreva Cloud Functions para Firebase usando Dart para habilitar o desenvolvimento full-stack,
reutilizar código entre o cliente e o backend e responder a gatilhos do Firebase.
Para começar, veja a
[documentação do Cloud Functions para Firebase][firebase-docs].

[Firebase Functions package]({{site.pub-pkg}}/firebase_functions)
: O pacote principal para escrever funções e APIs de backend em Dart.

[Firebase Admin SDK package]({{site.pub-pkg}}/firebase_admin_sdk)
: Acesse os serviços do Firebase com segurança a partir de servidores de backend ou de Cloud Functions.
  Use-o para gerenciar dados, enviar notificações ou verificar tokens de autenticação.

[Firebase Functions for Dart repository][firebase-repo]
: Repositório no GitHub com guias de início rápido, exemplos e código-fonte.

[firebase-docs]: https://firebase.google.com/docs/functions/start-dart
[firebase-repo]: https://github.com/firebase/firebase-functions-dart

### Escolhendo entre Cloud Run e Cloud Functions para Firebase {:#choosing-between-cloud-run-and-cloud-functions-for-firebase}

Ao executar Dart no servidor no Google Cloud, considere as necessidades
da sua arquitetura:

* **Escolha Cloud Functions para Firebase** se você estiver criando backends para
  aplicativos Flutter que precisam de tratamento de eventos serverless, APIs HTTP
  leves ou APIs chamáveis, ou integração estreita com Firebase Authentication e Cloud
  Firestore sem gerenciar containers.
* **Escolha Cloud Run** se você precisar de containers Docker personalizados, processos
  de longa duração, conexões WebSocket (como com o Serverpod) ou configurações
  de rede personalizadas.

## Outras soluções {:#other-solutions}

Dependendo das suas necessidades, você também pode considerar executar Dart nas
seguintes plataformas de computação do Google Cloud.

### Compute Engine {:#compute-engine}

Para executar código Dart no Compute Engine,
use o suporte do Compute Engine para executar containers,
combinado com as imagens Docker do Dart.

Para mais informações, veja a documentação do Compute Engine sobre
[como usar containers de software][ce].

### Kubernetes {:#kubernetes}

Para executar Dart em clusters de instâncias do Compute Engine,
use o Google Kubernetes Engine (GKE).

Para mais informações, veja a [visão geral do GKE][GKE overview].

### App Engine {:#app-engine}

O suporte do [App Engine][] para Dart é incompleto e exige o
[ambiente flexível do App Engine][App Engine flexible environment], que não
[escala para zero instâncias][scale to zero]. Por isso, recomendamos o **Cloud Run** para novos
códigos Dart de servidor.
Se você _quiser_ usar o App Engine, considere usar o [pacote `appengine`][`appengine` package].


[App Engine]: https://cloud.google.com/appengine
[App Engine flexible environment]: https://cloud.google.com/appengine/docs/flexible
[scale to zero]: https://cloud.google.com/run/docs/about-instance-autoscaling
[`appengine` package]: {{site.pub-pkg}}/appengine
[ce]: https://cloud.google.com/compute/docs/containers
[cr]: https://cloud.google.com/run/docs/quickstarts/build-and-deploy/other
[server examples]: {{site.repo.dart.samples}}/tree/main/server
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
[Dart Functions Framework]: {{site.pub-pkg}}/functions_framework
[CloudEvents]: https://cloudevents.io/
[functions docs]: https://github.com/GoogleCloudPlatform/functions-framework-dart/blob/main/docs/README.md
