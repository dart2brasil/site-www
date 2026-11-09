---
ia-translate: true
title: "Anunciando o Genkit Dart: crie apps full-stack com IA usando Dart e Flutter"
description: "Anunciando o lançamento em prévia do Genkit Dart, um framework open source de IA para criar apps full-stack com IA para qualquer plataforma."
publishDate: 2026-03-10
author: chrisraygill
image: images/1haDapHjWrIlyQsYO-zLlLQ.webp
category: announcements
layout: blog
---


As comunidades Dart e Flutter sempre ultrapassaram os limites do que é possível em diferentes telas. Vocês mostraram que construir aplicações multiplataforma de alta qualidade não exige abrir mão da experiência do desenvolvedor. Agora, levamos a mesma filosofia de "escreva uma vez, rode em qualquer lugar" para recursos e aplicações com IA.

Estamos muito animados em anunciar o lançamento em prévia do [**Genkit Dart**](https://genkit.dev/docs/dart/get-started/), um framework open source de IA para desenvolvedores Dart e Flutter. Já disponível para TypeScript, Go e Python, o Genkit agora permite que você crie **aplicações full-stack de alta qualidade, com IA, para qualquer plataforma**.

<DashImage src="images/1haDapHjWrIlyQsYO-zLlLQ.webp" alt="Arte do anúncio da prévia do Genkit Dart." caption="Anunciando o Genkit Dart (prévia)" />


## Por que escolher o Genkit Dart?

O Genkit Dart oferece as seguintes capacidades:

* **API independente de modelo:** oferece suporte aos modelos do Google, Anthropic, OpenAI e modelos compatíveis com a API da OpenAI logo de cara. Você nunca fica preso a um único provedor.

* **Segurança de tipos:** usa o sistema de tipos forte do Dart com o pacote [`schemantic`](https://pub.dev/packages/schemantic) para gerar dados fortemente tipados e criar flows de IA com segurança de tipos.

* **Execute o código em qualquer lugar:** escreva sua lógica de IA uma vez e execute-a como um serviço de backend ou diretamente dentro do seu app Flutter.

* **UI de desenvolvedor:** inclui uma UI web em localhost, onde você pode testar prompts, visualizar traces e depurar seus flows.

* **Kit completo de IA:** oferece tudo o que você precisa para criar recursos de IA de alta qualidade, incluindo saída estruturada, ferramentas, flows de múltiplas etapas, observabilidade e muito mais.

## API independente de modelo {:#model-agnostic-api}

O Genkit foi projetado para oferecer suporte a qualquer provedor de LLM, com suporte pronto para uso ao Google, Anthropic, OpenAI e modelos compatíveis com a API da OpenAI nesta versão. Isso permite trocar de provedor com mudanças mínimas no código.

```dart
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';

void main() async {
  // Initialize Genkit with plugins
  final ai = Genkit(plugins: [
    googleAI(),
    anthropic(),
  ]);

  // Call Google Gemini
  final geminiResponse = await ai.generate(
    model: googleAI.gemini('gemini-3.1-pro-preview'),
    prompt: 'Hello from Gemini',
  );

  // Call Anthropic Claude
  final claudeResponse = await ai.generate(
    model: anthropic.model('claude-opus-4.6'),
    prompt: 'Hello from Claude',
  );
}
```


## Flows de IA com segurança de tipos {:#type-safe-ai-flows}

O Genkit permite envolver sua lógica de IA em funções testáveis, observáveis e implantáveis, chamadas **flows**.

Aqui está um exemplo de um flow de Planejador de Viagens com esquemas de entrada e saída fortemente tipados, com chamada de ferramentas:

```dart
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:schemantic/schemantic.dart';

part 'travel_flow.g.dart';

// Define flow input schema with schemantic
@Schema()
abstract class $TripRequest {
  String get destination;
  int get days;
}

// Define tool input schema
@Schema()
abstract class $WeatherRequest {
  @Field(description: 'The city name')
  String get city;
}

void main() async {
  // Initialize Genkit and register the Google AI plugin
  final ai = Genkit(plugins: [googleAI()]);

  // Define a tool the model can invoke to fetch live data
  ai.defineTool(
    name: 'fetchWeather',
    description: 'Retrieves the current weather forecast for a given city',
    inputSchema: WeatherRequest.$schema,
    fn: (request, _) async => request.city.toLowerCase() == 'seattle' ? 'Rainy' : 'Sunny', 
  );

  // Construct a strongly-typed, observable flow
  final tripPlannerFlow = ai.defineFlow(
    name: 'planTrip',
    inputSchema: TripRequest.$schema,
    outputSchema: .string(),
    fn: (request, _) async {
      // Generate content using the model and tool
      final response = await ai.generate(
        model: googleAI.gemini('gemini-3.1-pro-preview'),
        prompt: 'Build a ${request.days}-day travel itinerary for ${request.destination}. '
                'Make sure to check the weather forecast first to suggest appropriate activities.',
        toolNames: ['fetchWeather'],
      );
      
      return response.text;
    },
  );

  // Run the flow
  final itinerary = await tripPlannerFlow(
    TripRequest(destination: 'Seattle', days: 3)
  );
  print(itinerary);
}
```


Quando estiver pronto, você pode expor facilmente seu flow como uma API usando o pacote `genkit_shelf` e implantá-lo em qualquer plataforma que suporte Dart.

```dart
import 'package:genkit_shelf/genkit_shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  // ... initialize Genkit and define tripPlannerFlow ...

  final router = Router()
    ..post(
      '/api/planTrip',
      shelfHandler(tripPlannerFlow),
    );

  await io.serve(router.call, 'localhost', 8080);
}
```


## Execute em qualquer lugar onde o Dart rode {:#run-anywhere-dart-runs}

A maior parte da lógica de IA complexa roda em um servidor. No entanto, como o Dart funciona tanto no frontend quanto no backend, o Genkit permite mover facilmente o seu código de IA entre o servidor e o app Flutter.

Aqui estão algumas formas de construir com o Genkit Dart:

### 1. Inteiramente no Flutter para prototipagem {:#1-entirely-in-flutter-for-prototyping}

Você pode escrever toda a sua lógica do Genkit, incluindo as chamadas aos modelos, diretamente no seu app Flutter. Isso é ótimo para protótipos ou apps em que os usuários fornecem as próprias chaves de API e os prompts não são privados.
> **Aviso:** nunca publique um app com a sua chave de API embutida no código-fonte, pois ela pode ser extraída e usada por outras pessoas.

### 2. Chame flows de backend a partir do Flutter {:#2-call-backend-flows-from-flutter}

Quando seus prompts são sensíveis ou sua lógica de IA é complexa, você pode mover o flow inteiro para o seu backend. Seu app Flutter pode então chamar esse flow definindo-o como uma "ação remota". Como o backend e o frontend são ambos em Dart, eles podem compartilhar os mesmos esquemas para segurança de tipos de ponta a ponta.

Aqui está um exemplo mostrando como chamar o flow de backend do Planejador de Viagens que definimos antes, a partir do seu app Flutter:

```dart
import 'package:genkit/client.dart';
import 'package:my_shared_models/models.dart'; // Shared schema

final tripPlannerFlow = defineRemoteAction(
  url: 'https://your-server.com/api/planTrip',
  inputSchema: TripRequest.$schema,
  outputSchema: .string(),
);

final itinerary = await tripPlannerFlow(
  input: TripRequest(destination: 'Tokyo', days: 5),
);
```


### 3. No Flutter com modelos remotos {:#3-in-flutter-with-remote-models}

Para proteger suas chaves de API enquanto mantém a lógica central de IA no seu app Flutter, você pode criar um pequeno backend com Genkit que faz de proxy das requisições para o provedor do modelo, com lógica de autorização personalizada. Os modelos expostos por esse backend são **modelos remotos**.

```dart
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_shelf/genkit_shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;

// Backend securely proxies requests to the model
void main() async {
  final geminiApi = googleAI();
  final targetModel = geminiApi.model('gemini-3.1-flash-lite-preview');
  final router = Router()
    ..post(
      '/api/gemini-model',
      shelfHandler(
        targetModel,
        // Insert custom authorization logic here
        contextProvider: (req) async => {'customAuth': true}, 
      ),
    );
  await io.serve(router.call, 'localhost', 8080);
}
```


No seu app Flutter, use o modelo remoto em vez de um plugin de modelo direto, passando os cabeçalhos que o seu servidor precisar. Isso evita expor suas chaves de API e dá mais controle sobre a autorização das requisições.

```dart
import 'package:genkit/genkit.dart';

// Flutter app communicates with the proxy server
final ai = Genkit();
final secureModel = ai.defineRemoteModel(
  name: 'secureModel',
  url: 'https://api.yourdomain.com/api/gemini-model',
  headers: (context) => {'Authorization': 'Bearer ${fetchSessionToken()}'}, 
);
final response = await ai.generate(model: secureModel, prompt: 'Write me a poem.');
```


## Ferramentas poderosas para o desenvolvimento de IA {:#powerful-tools-for-ai-development}

Criar aplicações de IA de alta qualidade exige testes minuciosos e iteração contínua para obter resultados confiáveis. Para ajudar nisso, o Genkit oferece uma poderosa UI de desenvolvedor local.

Você pode iniciar a UI de desenvolvedor junto com o seu código executando o seu app com a CLI do Genkit:

```bash
genkit start -- dart run bin/server.dart
```


Veja aqui como fica testar uma versão mais avançada do nosso flow de Planejador de Viagens na UI de desenvolvedor:

<DashImage src="images/1xFu0Liex2708NAi02DsTTg.webp" alt="UI de desenvolvedor do Genkit executando um flow." caption="A UI de desenvolvedor do Genkit executando um flow" />


## Assistência de codificação com IA {:#ai-coding-assistance}

Para a melhor experiência usando o Genkit Dart com ferramentas de código com IA, como Antigravity, Gemini CLI ou Claude Code, instale a **skill de agente do Genkit Dart**. Ela dá ao seu assistente de IA o conhecimento para escrever e depurar os seus recursos de IA com precisão.

Adicione a skill ao seu projeto:

```bash
npx skills add genkit-ai/skills
```


## Saiba mais {:#learn-more}

Esta versão é uma **prévia inicial**. Queremos trabalhar com desenvolvedores Dart e Flutter para melhorar o framework. Você pode encontrar hoje os pacotes principais e os plugins de provedores no [pub.dev](https://pub.dev/packages/genkit).

* **Comece:** leia nosso [guia de início rápido](https://genkit.dev/docs/dart/get-started/).

* **Entre na comunidade:** participe do nosso [servidor no Discord](https://discord.gg/qXt5zzQKpc) para tirar dúvidas e conversar com a equipe.

* **Fique por dentro:** siga-nos no [X](https://x.com/genkitframework) e no [LinkedIn](https://www.linkedin.com/company/genkit).

* **Dê feedback:** abra uma issue no nosso [repositório do GitHub](https://github.com/genkit-ai/genkit-dart) para relatar bugs ou pedir recursos.

Mal podemos esperar para ver o que você vai construir com o Genkit Dart!
