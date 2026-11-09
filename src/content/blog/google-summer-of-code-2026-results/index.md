---
ia-translate: true
title: "Resultados do Google Summer of Code 2026"
description: >-
  Hoje, destacamos os projetos e os resultados dos colaboradores
  orientados pelo Dart e pelo Flutter no Google Summer of Code 2026.
publishDate: 2026-09-15
author: jonasfj
image: images/hero.webp
category: other
layout: blog
---

O programa [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC)
busca engajar novos desenvolvedores do mundo todo
no desenvolvimento de software open source.
O Google patrocina colaboradores para trabalhar,
junto com uma organização open source que faz a mentoria,
em um projeto de programação de 12 semanas durante o verão.
Nos últimos 20 anos,
mais de 20.000 colaboradores participaram do Google Summer of Code.

<DashImage src="images/hero.webp" alt="Dash de chapéu de sol relaxando em uma boia de piscina com um notebook, sob o logo do sol do Google Summer of Code." />

Neste ano, o Dart e o Flutter participaram como organização mentora
no Google Summer of Code pelo sétimo ano consecutivo.
Recebemos quase 100 propostas de projeto de possíveis participantes
de todo o mundo.
Hoje, destacamos alguns dos projetos que orientamos neste verão.
Os colaboradores descrevem seus projetos neste post.

## Adicionar suporte a WebSocket e gRPC ao painel Network do Flutter DevTools {:#add-websocket-and-grpc-support-to-flutter-devtools-network-panel}

*Por Yash Hosalli*

Ao trabalhar com sistemas em tempo real,
notei uma lacuna na experiência do desenvolvedor.
O Flutter DevTools oferece uma ótima visibilidade das requisições HTTP,
mas, assim que uma conexão WebSocket entra em funcionamento,
fica muito mais difícil ver o que realmente está acontecendo.
O fluxo de frames, o ciclo de vida da conexão e a atividade ao longo do tempo
podem rapidamente virar uma caixa-preta,
tornando a depuração em tempo real frustrante.

Muitos apps modernos dependem de WebSockets
e têm pouca ou nenhuma visibilidade para depuração.
Este projeto traz essa visibilidade que faltava
para a stack de ferramentas existente do Dart e do Flutter.
Estendi o `dart:io`, o `dart:developer` e o VM Service
para capturar dados de WebSocket leves, no nível da conexão e do frame,
seguindo a arquitetura que já estava estabelecida para o profiling de HTTP.
O objetivo era fazer a depuração de WebSocket parecer familiar,
em vez de introduzir um fluxo de profiling totalmente novo.

Os dados coletados são então exibidos diretamente no painel Network do DevTools,
onde os desenvolvedores podem inspecionar conexões, tamanhos, timestamps
e eventos de ciclo de vida conforme eles acontecem.
Isso transforma a comunicação WebSocket em algo
que os desenvolvedores realmente conseguem observar e entender.

Para saber mais, confira minha [página de acompanhamento do GSoC](https://victowolf.github.io/GSoC-Progress-Tracking/).

<DashImage src="images/devtools-websocket-overview.webp" alt="Painel Network do Flutter DevTools mostrando detalhes gerais de uma conexão WebSocket, como status, bytes e frames enviados e recebidos." />

<DashImage src="images/devtools-websocket-frames.webp" alt="Painel Network do Flutter DevTools mostrando uma tabela de frames WebSocket com timestamps, direções, eventos e tamanhos." />

<DashImage src="images/devtools-websocket-network-panel.webp" alt="Painel Network do Flutter DevTools listando requisições de rede HTTP e WebSocket." />

## Ferramenta de compatibilidade C++/C para o FFIgen {:#cc-compatibility-tool-for-ffigen}

*Por Hassnaa Mohamed Ahmed*

O principal objetivo deste projeto é estender o `package:ffigen`
para gerar automaticamente bindings Dart FFI para APIs C++.
O Dart consegue se comunicar com APIs C e compatíveis com C por meio do pacote FFI,
e o FFIgen consegue gerar automaticamente bindings Dart para essas APIs.
No entanto, o C++ introduz conceitos que o Dart FFI não representa diretamente,
como classes, construtores e destrutores, herança
e posse de objetos nativos.
Como resultado, usar bibliotecas C++ a partir do Dart exige código de cola adicional
e um tratamento cuidadoso da relação entre os objetos Dart
e os objetos C++ subjacentes.

O suporte experimental a C++ no FFIgen resolve esses desafios
ao gerar bindings Dart para classes C++
junto com o código de cola C++ necessário.
Os bindings gerados oferecem suporte a ponteiros para classes C++
e gerenciamento do tempo de vida dos objetos nativos,
permitindo que objetos Dart interajam com os objetos C++ subjacentes
preservando a semântica de posse nativa.
Isso torna possível trabalhar com classes C++ a partir do Dart
sem que os usuários precisem escrever manualmente os bindings
e a camada de gerenciamento de memória.

Exemplo de header C++:

```cpp
class Animal {
public:
  int age;
  Animal(int age);
  ~Animal();
  void speak();
  int getAge() const;
  static int getCount();
};
```

Código de cola C++ gerado:

```cpp
FFIGEN_EXPORT Animal* Animal_new(int age) {
  return new Animal(age);
}

FFIGEN_EXPORT int Animal_getAge(const Animal* self) {
  return self->getAge();
}

FFIGEN_EXPORT void Animal_delete(Animal* self) {
  delete self;
}
```

Uso do binding Dart gerado:

```dart
// Instantiate the C++ class through the generated constructor wrapper.
final animal = Animal(10);
expect(animal.getAge(), 10);

animal.speak();

// Invoke a static C++ method.
expect(Animal.getCount(), 42);

// Deterministically release the native object.
animal.dispose();
```

Essa abordagem faz a ponte entre APIs C++ orientadas a objetos
e o modelo de FFI do Dart,
mantendo os bindings gerados o mais próximos possível
da semântica da API C++ original.

Para mais detalhes, confira o [relatório do projeto GSoC 2026 no GitHub](https://github.com/Hassnaa9/GSoC-2026-Report).

## Migrar os plugins do IntelliJ para longe da biblioteca WebSocket Weberknecht {:#migrate-intellij-plugins-off-weberknecht-websocket-library}

*Por Javad Asadi*

Os plugins de Dart e Flutter do IntelliJ usavam a biblioteca Weberknecht
para se comunicar com o Dart Tooling Daemon e com o VM service.
A Weberknecht é uma biblioteca antiga e sem manutenção,
e continuar dependendo dela já não era uma escolha viável.

No GSoC 2026,
decidimos substituir essa biblioteca pelo cliente WebSocket embutido no JDK.
Ele está disponível desde o Java 11,
o que nos permite evitar mais uma dependência externa.

A migração aconteceu um serviço por vez,
primeiro no plugin de Dart e depois no plugin de Flutter.
Em cada fase,
tentei escrever testes que cobrissem o WebSocket
tanto nos caminhos felizes quanto nos casos de borda.
O objetivo era que os testes passassem antes e depois da migração.

A migração foi concluída com sucesso.
Os plugins de Dart e de Flutter agora usam o cliente WebSocket embutido no JDK
e mantêm o comportamento existente em todos os fluxos de trabalho.
Após a fase final da migração,
todas as referências à Weberknecht — incluindo suas dependências
e os arquivos JAR empacotados — foram removidas dos dois repositórios.
Como resultado,
os plugins não dependem mais de uma biblioteca WebSocket externa desatualizada.

<DashImage src="images/intellij-plugin-websocket-architecture.webp" alt="Diagrama de arquitetura mostrando os plugins de Dart e Flutter do IntelliJ se conectando ao VM Service do Dart SDK e ao Dart Tooling Daemon por meio de WebSockets." />

Mais informações sobre este projeto podem ser encontradas no meu [resumo do projeto (gist)](https://gist.github.com/JavadAsadi/10b0935ae19405a43ecc311e9bdd7921).

## Backend JCA para Android no package:webcrypto {:#android-jca-backend-for-packagewebcrypto}

*Por M. Fazri Nizar*

O `package:webcrypto` atualmente inclui uma biblioteca nativa adicional do BoringSSL nos apps Android.
Durante o GSoC 2026,
explorei o uso das próprias APIs de criptografia do Android
por meio da Java Cryptography Architecture (JCA) e do `package:jni`.
Como o Android já oferece criptografia embutida,
aproveitá-la poderia, com o tempo, reduzir o código nativo extra incluído em cada app.
O primeiro marco foi fazer funcionar a primitiva SHA-256.

Depois que a primeira primitiva foi integrada,
adicionei HMAC e AES,
seguidos de RSA, operações de curvas elípticas, HKDF
e geração de números aleatórios seguros.
Rodar os testes existentes do pacote durante todo o desenvolvimento
permitiu comparar a implementação JCA
com os backends do BoringSSL e do navegador.
Esses testes também revelaram diferenças entre os provedores,
especialmente em relação aos parâmetros do AES-GCM e às chaves privadas RSA
em versões mais antigas do Android.
O PBKDF2 ainda não foi resolvido, porque o Web Crypto aceita bytes brutos de senha,
enquanto a API padrão da JCA aceita caracteres.

O backend JCA implementa a interface existente,
o que significa que a API pública continua totalmente inalterada.
Como resultado, os desenvolvedores poderão se beneficiar de apps menores
sem precisar mudar nenhuma linha do próprio código.

Para saber mais sobre a implementação e o trabalho em andamento, confira meu [relatório do projeto GSoC 2026 no GitHub](https://github.com/mfazrinizar/GSoC-2026-Report).

## Inspecionar memória nativa no Dart DevTools {:#inspect-native-memory-in-dart-devtools}

*Por Nourhan H.*

Ao depurar código Dart que envolve `Pointer<X>`,
o depurador costuma exibir informações pouco úteis e vagas.
Isso obriga os desenvolvedores a depender de instruções de print
em vez de inspecionar as variáveis diretamente.

Por exemplo, dado o código a seguir:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class MyStruct extends Struct {
  @Int32()
  external int a;

  @Double()
  external double b;
}

void main() {
  final pInt16 = malloc<Int16>()..value = -500;
  final ptr = malloc<MyStruct>();

  ptr.ref.a = 42;
  ptr.ref.b = 3.14;

  malloc.free(ptr);
  malloc.free(pInt16);
}
```

Antes, o depurador mostrava:

<DashImage src="images/devtools-pointer-inspection-before.webp" alt="Painel de variáveis do depurador do Dart DevTools antes da correção, exibindo informações de tipo Pointer<Never> pouco úteis para variáveis de ponteiro." />

Além disso, tentar inspecionar um ponteiro para memória inválida
resultava antes em falhas de segmentação,
tornando a inspeção de memória insegura.
Esse problema afetava vários tipos `Pointer<X>`,
incluindo tipos primitivos, structs, unions e outros.

Resolvemos esse problema para tornar a inspeção de memória ao mesmo tempo
segura e amigável para o desenvolvedor.

Por exemplo, considere a inspeção de um contêiner com vários tipos de ponteiro:

```dart
import 'dart:developer';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class MultiPointerContainer {
  final Pointer pInt16;
  final Pointer pInt32;
  final Pointer pDouble;
  final Pointer pNull;
  final Pointer pGarbage;
  final Pointer pBool;

  MultiPointerContainer({
    required this.pInt16,
    required this.pInt32,
    required this.pDouble,
    required this.pNull,
    required this.pGarbage,
    required this.pBool,
  });
}

void main() {
  final pInt16 = calloc()..value = -500;
  final pInt32 = calloc()..value = -100;
  final pDouble = calloc()..value = 1.5;
  final pGarbage = Pointer.fromAddress(0xDEADBEEF);
  final pBool = calloc()..value = true;

  final container = MultiPointerContainer(
    pInt16: pInt16,
    pInt32: pInt32,
    pDouble: pDouble,
    pNull: nullptr,
    pGarbage: pGarbage,
    pBool: pBool,
  );

  debugger();

  calloc.free(pInt16);
  calloc.free(pInt32);
  calloc.free(pDouble);
  calloc.free(pGarbage);
  calloc.free(pBool);
}
```

Agora, o depurador exibe:

<DashImage src="images/devtools-pointer-inspection-after.webp" alt="Painel de variáveis do depurador do Dart DevTools depois da correção, exibindo informações estruturadas do ponteiro, incluindo bytes brutos, endereços e tratamento de erro para memória inválida." />

Leituras de memória inválida e ponteiros `null` agora são tratados de forma totalmente segura.
Integramos APIs de baixo nível do kernel para evitar falhas de segmentação
durante leituras arbitrárias de memória em cinco sistemas operacionais principais:

- **Linux e Android:** `pread64(/proc/self/mem)`
- **Windows:** `ReadProcessMemory`
- **macOS e iOS:** `mach_vm_read_overwrite`

Essa correção melhora bastante a experiência de quem escreve código Dart
e precisa de uma visibilidade clara e confiável
do que acontece por baixo dos panos ao trabalhar com ponteiros.

Para mais informações sobre o projeto, confira o [repositório do projeto GSoC 2026 no GitHub](https://github.com/TheNourhan/Dart-GSoC26).
