---
ia-translate: true
title: Usando o Google Cloud
short-title: Google Cloud
description: "Seu aplicativo Dart pode usar muitos serviços do Google Cloud: Firebase, Google Cloud Platform e mais."
---

Servidores Dart podem usar muitos
[produtos do Google Cloud](https://cloud.google.com/products),
frequentemente com a ajuda do Docker pré-empacotado
[Imagens Oficiais para Dart](https://hub.docker.com/_/dart).
Para informações sobre como criar servidores HTTP com Dart, veja a
página [Escrever servidores HTTP](/tutorials/server/httpserver).

Para informações sobre outras APIs do Google (incluindo Firebase)
que você pode querer usar a partir do código Dart,
veja a página [APIs do Google](/resources/google-apis).

## Soluções recomendadas {:#recommended-solutions}

Para executar Dart na nuvem, recomendamos usar soluções de computação serverless (sem servidor).

### Cloud Run {:#cloud-run}

Você pode usar o suporte flexível a containers do Cloud Run,
combinado com as imagens Docker do Dart, para executar código Dart no lado do servidor.
Criar APIs escaláveis e de alto desempenho e aplicativos orientados a eventos
são bons casos de uso para a plataforma serverless do Cloud Run,
que libera os desenvolvedores do gerenciamento de infraestrutura.

Exemplos de servidores Dart implementados para serem executados no Cloud Run estão
[no dart-lang/samples/repo][server examples].

Para mais informações sobre como usar o Cloud Run, veja a documentação para
[construir e implantar um serviço em outras linguagens][cr].

### Functions Framework para Dart {:#functions-framework-for-dart}

O Functions Framework (estrutura de funções) é uma estrutura FaaS (Função como Serviço)
que facilita a escrita de funções Dart
em vez de aplicativos de servidor para lidar com requisições web.
Usando a estrutura, você pode criar funções que lidam com requisições HTTP
e [CloudEvents][CloudEvents] e implantá-las no Google Cloud.

O [Dart Functions Framework][Dart Functions Framework] é um projeto com suporte da comunidade.

Para mais informações, veja [o README][functions docs].

## Outras soluções {:#other-solutions}

Dependendo das suas necessidades, você também pode considerar executar Dart nas
seguintes plataformas de computação do Google Cloud.

### Compute Engine {:#compute-engine}

Para executar código Dart no Compute Engine,
use o suporte do Compute Engine para executar containers,
combinado com as imagens Docker do Dart.

Para mais informações, veja a documentação do Compute Engine para
[usar containers de software][ce].

### Kubernetes {:#kubernetes}

Para executar Dart em clusters de instâncias do Compute Engine,
use o Google Kubernetes Engine (GKE).

Para mais informações, veja a [visão geral do GKE][GKE overview].

### App Engine {:#app-engine}

O suporte do [App Engine][App Engine] para Dart está incompleto e requer o
[ambiente flexível do App Engine][App Engine flexible environment], que não
[escala automaticamente para zero instâncias][scale to zero], então recomendamos
o **Cloud Run** para novos códigos Dart do lado do servidor.
Se você _quiser_ usar o App Engine, considere usar o pacote [`appengine`][`appengine` package].


[App Engine]: https://cloud.google.com/appengine
[App Engine flexible environment]: https://cloud.google.com/appengine/docs/flexible
[scale to zero]: https://cloud.google.com/run/docs/about-instance-autoscaling
[`appengine` package]: {{site.pub-pkg}}/appengine
[ce]: https://cloud.google.com/compute/docs/containers
[cr]: https://cloud.google.com/run/docs/quickstarts/build-and-deploy/other
[server examples]: {{site.repo.dart.org}}/samples/tree/main/server
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
[Dart Functions Framework]: {{site.pub-pkg}}/functions_framework
[CloudEvents]: https://cloudevents.io/
[functions docs]: https://github.com/GoogleCloudPlatform/functions-framework-dart/blob/main/docs/README.md
