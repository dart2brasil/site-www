---
ia-translate: true
title: "Anunciando o Genkit Dart 1.0: crie apps agênticos prontos para produção com Dart e Flutter"
description: >-
  Anunciando a versão estável 1.0 do Genkit Dart, um framework open source
  para criar apps agênticos e recursos de IA prontos para produção em Dart.
publishDate: 2026-10-08
author: chrisraygill
image: images/banner.webp
category: announcements
layout: blog
---

<DashImage src="images/banner.webp" alt="Anunciando o Genkit Dart 1.0" />

Dart e Flutter permitem criar apps de alta qualidade para celular, web e desktop
a partir de uma única base de código. Com o [Genkit Dart](https://genkit.dev/docs/dart/get-started/),
você leva essa mesma produtividade para apps full-stack e agênticos.

Hoje, anunciamos o **Genkit Dart 1.0**, a primeira versão estável, pronta para
produção, do framework open source do Google para criar recursos de IA e agentes
em Dart.
Desde o nosso [lançamento de prévia](/blog/announcing-genkit-dart-build-full-stack-ai-apps-with-dart-and-flutter)
no início deste ano, o feedback da comunidade Dart e Flutter nos ajudou a
refinar as APIs centrais e a expandir o conjunto de ferramentas para cargas de
trabalho em produção.

Publicamos o [passo a passo completo e as análises detalhadas do código](https://flutter.dev/blog/announcing-genkit-dart-1-0)
no blog do Flutter.

Para começar agora mesmo, adicione o `genkit` ao seu projeto Dart ou Flutter:

```shell
dart pub add genkit
```

Você também pode instalar a skill de agente para dar a assistentes de código com IA,
como Antigravity, Claude Code e Codex, conhecimento atualizado sobre as APIs do Genkit Dart:

```shell
npx skills add genkit-ai/skills
```

## Destaques do Genkit Dart 1.0 {:#highlights-in-genkit-dart-1-0}

O Genkit Dart 1.0 traz uma interface de modelo unificada, segurança de tipos de
ponta a ponta e primitivas agênticas para qualquer ambiente Dart, seja você
construindo serviços de backend, ferramentas de CLI ou apps Flutter full-stack:

* **Uma API para vários provedores de modelos:** troque entre Google Gemini, Anthropic
  Claude, OpenAI e modelos compatíveis com a OpenAI sem reescrever a lógica
  da sua aplicação.
* **Segurança de tipos de ponta a ponta com `schemantic`:** defina seus esquemas de
  dados uma única vez em Dart usando o [`schemantic`](https://pub.dev/packages/schemantic) para gerar
  saídas estruturadas dos modelos, envolver a lógica de IA em **flows** observáveis e
  compartilhar tipos entre o seu servidor Dart e o cliente.
* **Implantação flexível entre cliente e servidor:** execute flows em um servidor
  Dart com `GenkitRouter`, invoque-os a partir de um cliente usando `defineRemoteAction`, ou
  mantenha a sua lógica de IA no cliente enquanto roteia as requisições ao modelo
  por um backend seguro com `defineRemoteModel`.
* **Interrupções de ferramentas com human-in-the-loop:** pause a execução de uma ferramenta
  dentro de `defineTool` retornando `.interrupt(...)` quando uma ação exigir a
  confirmação do usuário, e então retome a geração de onde parou.
* **Middleware de geração componível:** anexe middleware pronto de
  [`genkit_middleware`](https://pub.dev/packages/genkit_middleware) (incluindo
  novas tentativas automáticas, carregamento dinâmico de `SKILL.md` e regras de
  aprovação de ferramentas) ou escreva middleware personalizado com `defineGenerateMiddleware`.
* **Gerenciamento de prompts com Dotprompt:** mantenha templates de prompt,
  configuração de modelo e esquemas juntos em arquivos `.prompt` com o
  [Dotprompt](https://genkit.dev/docs/dart/dotprompt/).
* **UI de desenvolvedor local e OpenTelemetry:** teste flows e inspecione os traces
  de execução localmente com `genkit start`, e exporte os traces e métricas de
  produção com o [`genkit_otel`](https://pub.dev/packages/genkit_otel).
* **Agentes com estado e A2UI, em caráter experimental:** experimente agentes persistentes
  de múltiplos turnos (`defineAgent` e `remoteAgent` em `package:genkit/experimental.dart`)
  e transmita superfícies de UI nativa interativas com o
  [`genkit_a2ui`](https://pub.dev/packages/genkit_a2ui).

```dart
@Schema()
abstract class $TripRequest {
  String get destination;
  int get days;
}
// ...plus an Itinerary schema for the result.

final ai = Genkit(plugins: [googleAI()]);

final planTrip = ai.defineFlow(
  name: 'planTrip',
  inputSchema: TripRequest.$schema,
  outputSchema: Itinerary.$schema,
  fn: (request, _) async {
    final response = await ai.generate(
      model: googleAI.gemini('gemini-flash-latest'),
      prompt: 'Plan a ${request.days}-day trip to ${request.destination}.',
      outputSchema: Itinerary.$schema,
    );
    return response.output!;
  },
);

await (GenkitRouter()..addAction(planTrip)).serve(port: 8080); // POST /planTrip
```

## Leia o anúncio completo {:#read-the-full-announcement}

Para exemplos de código completos cobrindo geração com múltiplos modelos, ações e
modelos remotos, interrupções de ferramentas, middleware, Dotprompt, OpenTelemetry, agentes
com estado e UI generativa com A2UI, leia o **[anúncio completo do Genkit Dart 1.0](https://flutter.dev/blog/announcing-genkit-dart-1-0)**
no blog do Flutter.

* **Comece:** siga o [guia de início rápido](https://genkit.dev/docs/dart/get-started/) e confira
  o [`genkit` no pub.dev](https://pub.dev/packages/genkit).
* **Explore os exemplos:** navegue pelos [apps de exemplo no GitHub](https://github.com/genkit-ai/genkit-dart/tree/main/testapps).
* **Entre na comunidade:** converse com a equipe no
  [Discord](https://discord.gg/qXt5zzQKpc) e abra issues no
  [repositório `genkit-dart` no GitHub](https://github.com/genkit-ai/genkit-dart).
