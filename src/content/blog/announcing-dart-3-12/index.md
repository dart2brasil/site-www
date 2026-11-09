---
ia-translate: true
title: "Anunciando o Dart 3.12"
description: "Impulsionando a produtividade dos desenvolvedores no Google I/O 2026"
publishDate: 2026-05-20
author: conooi
image: images/dart-3-12-cover.webp
category: releases
layout: blog
---

<DashImage src="images/dart-3-12-cover.webp" alt="Dart 3.12 release banner with the Dart logo and a bullseye icon." caption="Announcing Dart 3.12" />

Neste ano, no Google I/O 2026, as equipes do Flutter e do Dart celebram um tema poderoso: em todo lugar, no dia a dia, construído por todos, para todos.

O Dart 3.12 dá vida a esse tema. Estamos tornando a linguagem mais acessível e produtiva. Primitivas novas e concisas, como parâmetros nomeados privados, junto com suporte experimental a construtores primários, tornam o código do dia a dia mais limpo. Mas não paramos no nível da sintaxe. Recursos novos como o Agentic Hot Reload e a chegada do Genkit ao ecossistema Dart garantem que você possa construir apps de alta performance, prontos para IA e agênticos, que alcançam usuários em qualquer lugar. Isso vale tanto se você programa sozinho quanto se faz pair programming com um agente de IA.

Então, [atualize o Dart](https://dart.dev/get-dart) ou rode [`flutter upgrade`](https://docs.flutter.dev/install/upgrade) e acompanhe para explorar os novos recursos do Dart 3.12. Mas lembre-se: um Dart mais poderoso é só metade da história. Quando você quiser ver como esses recursos se traduzem em uma UI bonita, confira o post [O que há de novo no Flutter]({{site.flutter-blog}}/whats-new-in-flutter-3-44).

## Atualizações da linguagem {:#language-updates}

### Parâmetros nomeados privados {:#private-named-parameters}

Os initializing formals do Dart, que usam a sintaxe de construtor `this.`, são incrivelmente práticos. Eles mapeiam um parâmetro do construtor diretamente para um campo da classe. Isso elimina a necessidade de escrever código repetitivo.

Mas havia um porém. Os initializing formals tinham dificuldade ao combinar parâmetros nomeados com campos privados. Antes do Dart 3.12, a linguagem não permitia que um parâmetro nomeado começasse com um underscore:

```dart
class Hummingbird {
  final String _petName;
  final int _wingbeatsPerSecond;

  // Compile error! Can't have private named parameter. :(
  Hummingbird({required this._petName, required this._wingbeatsPerSecond});
}
```

Em vez disso, você tinha que escrever uma lista de inicialização explícita:

```dart
class Hummingbird {
  final String _petName;
  final int _wingbeatsPerSecond;

  Hummingbird({required String petName, required int wingbeatsPerSecond})
    : _petName = petName,
      _wingbeatsPerSecond = wingbeatsPerSecond;
}
```

Isso era trabalhoso. Tudo que a lista de inicialização faz é remover o `_`. Ela adicionava código repetitivo desnecessário a classes simples.

No Dart 3.12, a linguagem pode fazer isso por você. Agora o Dart permite escrever initializing formals nomeados e privados:

```dart
class Hummingbird {
  final String _petName;
  final int _wingbeatsPerSecond;

  // OK with "Private Named Parameters"! :D
  Hummingbird({required this._petName, required this._wingbeatsPerSecond});
}
```

Esse código se comporta exatamente como o exemplo anterior. Os campos inicializados são privados, mas os parâmetros do construtor e os nomes de argumento escritos na chamada têm os nomes públicos correspondentes:

```dart
void main() {
  print(Hummingbird(petName: 'Dash', wingbeatsPerSecond: 75));
}
```

**Saiba mais**: [documentação de parâmetros nomeados privados](https://dart.dev/language/constructors#private-named-parameters)

### Construtores primários (fase experimental) {:#primary-constructors}

Estamos animados em oferecer uma primeira visão de um dos recursos de sintaxe mais pedidos no Dart. Os construtores primários representam um grande avanço em concisão de classes. Eles eliminam a necessidade de repetir nomes e tipos de campos no corpo da classe e nas listas de parâmetros.

Normalmente, até uma classe simples com dois campos exige várias linhas de código repetitivo:

```dart
class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}
```

Os construtores primários mudam isso por completo. Agora você pode substituir o código repetitivo por uma única linha, declarando os parâmetros diretamente no cabeçalho da classe.

```dart
class Point(final int x, final int y);
```

O recurso vai além. Ele introduz uma sintaxe mais curta para declarar construtores dentro do corpo da classe, usando as palavras-chave `new` ou `factory`. Também permite que classes com corpo vazio terminem com um simples ponto e vírgula:

```dart
class Pet {
  String name;

  new() : name = 'Fluffy';
  new withName(this.name);
}

class Dog extends Pet;
```

Os construtores primários estão sendo lançados como uma prévia experimental no Dart 3.12. Como esta é uma mudança fundamental na forma como as classes Dart são definidas, o seu feedback real é crucial. Você pode habilitar o recurso usando a flag `primary-constructors` [flag](https://dart.dev/tools/experiment-flags) ao rodar seu projeto:

```console
dart run --enable-experiment=primary-constructors bin/main.dart
```

Se você encontrar algum problema ou tiver feedback sobre o design, abra uma issue no [repositório do SDK do Dart](https://github.com/dart-lang/sdk) (e sinta-se à vontade para marcar `@kallentu`). Estamos ansiosos para ouvir o que você pensa!

**Saiba mais**: [documentação de construtores primários](https://dart.dev/language/primary-constructors)

## Atualizações do ecossistema {:#ecosystem-updates}

### Prévia do Genkit Dart {:#genkit-dart}

Estamos animados em anunciar o lançamento em prévia do Genkit Dart, um framework open source para criar apps Dart e Flutter full-stack, com IA e agênticos, em qualquer plataforma. Ele oferece tudo o que você precisa para apps de IA prontos para uso:

* **API agnóstica de modelo:** Oferece suporte a modelos do Google, Anthropic, OpenAI e modelos compatíveis com a OpenAI.
* **Segurança de tipos:** Combina o sistema de tipos forte do Dart com o pacote `schematic` para geração de dados e flows fortemente tipados.
* **Roda em qualquer lugar:** Escreva a lógica de IA uma vez e rode-a em um serviço de backend ou diretamente dentro do seu app Flutter.
* **UI para desenvolvedores:** Inclui uma interface web local para testar prompts, visualizar traces e depurar workflows.
* **Primitivas centrais de IA:** Suporte integrado a saída estruturada, chamada de ferramentas e flows com várias etapas.

Chame vários modelos em apenas algumas linhas de código:

```dart
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';

void main() async {
  final ai = Genkit(plugins: [googleAI(), anthropic()]);

  // Call a Gemini model from Google.
  final geminiResponse = await ai.generate(
    model: googleAI.gemini('gemini-flash-latest'),
    prompt: 'Hello from Gemini',
  );

  // Call a Claude model from Anthropic.
  final claudeResponse = await ai.generate(
    model: anthropic.model('claude-opus-4.6'),
    prompt: 'Hello from Claude',
  );
}
```

Converse com a equipe do Genkit no [Discord](https://discord.gg/qXt5zzQKpc) e reporte problemas no [GitHub](https://github.com/genkit-ai/genkit-dart).

**Saiba mais**: [Primeiros passos com o Genkit para Dart](https://genkit.dev/docs/dart/get-started/)

### Cloud Functions for Firebase e suporte experimental ao Dart {:#cloud-functions}

Também estamos muito animados em destacar o recente anúncio do suporte experimental ao Dart no Cloud Functions for Firebase. Por anos, estender um app Flutter para a nuvem significava trocar de contexto para outras linguagens de backend e duplicar estruturas de dados.

Agora, você pode construir uma aplicação Dart full-stack de verdade. Usando o padrão “Shared Package”, você pode compartilhar seus modelos de dados, regras de validação e lógica de negócios diretamente entre o frontend e o backend, eliminando completamente o “Double-Doc Tax”.

Graças à compilação AOT (Ahead-of-Time) do Dart, suas funções serverless se beneficiam de cold starts incrivelmente rápidos, oferecendo escalabilidade instantânea e desempenho sem a complicação de Dockerfiles ou configuração de containers.

**Saiba mais**: [post do blog sobre Dart e Firebase](https://dart.dev/blog/flutter-missing-link-why-full-stack-dart-changes-everything).

## Atualizações de ferramentas {:#tooling-updates}

### Hot reload agêntico {:#agentic-hot-reload}

Ouvimos da nossa comunidade que vocês querem que os agentes de codificação com IA funcionem sem atrito com Dart e Flutter. Por isso estamos lançando o Agentic Hot Reload para apps Dart e Flutter, um novo recurso criado para manter você e seu agente de codificação no fluxo. Usando o servidor MCP do Dart, seu agente de codificação agora pode fazer hot reload automaticamente, eliminando a fricção de ter que encontrar e copiar manualmente as URIs de conexão do Dart Tooling Daemon (DTD).

Nos bastidores, o Dart Tooling Daemon expõe automaticamente os detalhes de conexão por meio de um comando de CLI executado pelo servidor MCP, permitindo que seu agente de codificação descubra e se conecte instantaneamente ao app em execução no seu workspace.

Sem nenhuma configuração, essa integração simplifica seu fluxo de trabalho diário. Você pode simplesmente pedir ao seu agente de codificação para corrigir um bug, alterar um widget de UI ou diagnosticar um crash. O agente vai modificar seu código de forma autônoma, buscar diagnósticos de runtime ao vivo e fazer hot reload do app em tempo real.

<DashImage src="images/agentic-hot-reload.webp" caption="Agentic hot reload powered by the Dart MCP server." alt="An animation demonstrating the Dart MCP server hot reloading a Flutter star counter app after the Gemini CLI changes the theme and star animation. The split-screen setup shows the driving macOS terminal on the left and the resulting Android emulator on the right." />

### Diagnósticos de desempenho do servidor de análise {:#analysis-server-performance-diagnostics}

Para criar as melhores ferramentas para todos, queremos entender o desempenho do Dart Analysis Server (DAS) exatamente como você o experimenta na sua máquina. Para isso, introduzimos o novo comando `dart info record-performance`.

Desenvolvedores que enfrentam tempos de análise lentos ou completion que não responde podem usar esse comando para capturar traces de execução e dados de profiling de CPU dos processos DAS ativos na máquina. Incluir esses traces quando você abrir issues no GitHub dá à nossa equipe os dados reais exatos necessários para diagnosticar e resolver gargalos de desempenho complexos. Ao compartilhar seus traces, você ajuda diretamente a tornar o Dart mais rápido e confiável para todos os desenvolvedores.

## Atualizações do pub {:#pub-updates}

### Suporte nativo a Git LFS no `pub` {:#git-lfs-support}

Usar pacotes com arquivos grandes agora é mais simples do que nunca. A partir do Dart 3.12, o `dart pub` oferece suporte nativo a dependências git com Git Large File Storage (LFS).

Você não precisa de nenhuma configuração personalizada no seu arquivo `pubspec.yaml`. Desde que o `git lfs` esteja instalado na sua máquina, o cliente pub cuida de tudo automaticamente:

```yaml
dependencies:
  kittens:
    git: https://github.com/munificent/kittens.git
```

Essa é uma grande melhoria para equipes que versionam arquivos de mídia grandes, modelos de dados ou binários diretamente dentro dos seus repositórios git.

## Para encerrar {:#wrap-up}

O Dart 3.12 representa um grande marco na remoção de atritos para desenvolvedores. De adições concisas de sintaxe a fluxos de trabalho agênticos com IA integrados e um ecossistema de IA mais forte, esta versão foi feita para apoiar você. Cada recurso foi pensado para tornar seu desenvolvimento do dia a dia limpo e eficiente.

Estamos ansiosos para ver o que você vai construir com esses novos recursos. Esperamos que você [atualize o Dart](https://dart.dev/get-dart) ou [atualize o Flutter](https://docs.flutter.dev/install/upgrade) hoje para experimentar essas atualizações. Se você estiver testando nossos recursos experimentais, como os construtores primários, compartilhe seu feedback. Juntos, vamos continuar construindo uma linguagem que traz alegria de programar para todos, todos os dias e em qualquer lugar.

**Saiba mais**: [changelog do SDK do Dart](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3120)
