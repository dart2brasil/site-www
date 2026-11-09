---
ia-translate: true
title: "Interop com Objective-C e Swift usando package:ffigen"
shortTitle: Interop com Objective-C e Swift
breadcrumb: Objective-C e Swift
description: >-
  Para usar código Objective-C e Swift no seu programa Dart, use o package:ffigen.
ffigen: "https://pub.dev/packages/ffigen"
example: "https://github.com/dart-lang/native/tree/main/pkgs/ffigen/example/objective_c"
ffigenapi: "https://pub.dev/documentation/ffigen/latest/ffigen"
ffigendoc: "https://github.com/dart-lang/native/blob/main/pkgs/ffigen/doc/README.md"
appledoc: "https://developer.apple.com/documentation"
---

Apps Dart rodando na [plataforma Dart Native][Dart Native platform] (macOS ou iOS)
podem usar `dart:ffi` e o [`package:ffigen`][`package:ffigen`]
para chamar APIs Objective-C e Swift.

O `dart:ffi` permite que o código Dart interaja com APIs C nativas.
Objective-C é baseado em C e compatível com C,
então é possível interagir com APIs Objective-C usando apenas `dart:ffi`.
No entanto, isso exige muito código repetitivo (boilerplate),
então você pode usar o `package:ffigen` para gerar automaticamente
os bindings FFI do Dart para uma determinada API Objective-C.
Para saber mais sobre FFI e sobre interagir diretamente com código C,
consulte o [guia de interop com C][C interop guide].

Você pode gerar headers Objective-C para APIs Swift,
permitindo que o `dart:ffi` e o `package:ffigen` interajam com Swift.

Para mais informações sobre como usar o FFIgen,
consulte o [README do FFIgen][FFIgen README]
e a [documentação adicional][additional documentation].

[Dart Native platform]: /overview#platform
[`package:ffigen`]: {{page.ffigen}}
[C interop guide]: /interop/c-interop
[FFIgen README]: {{page.ffigen}}
[additional documentation]: {{page.ffigendoc}}

## Exemplo em Objective-C {:#objective-c-example}

Este guia mostra passo a passo um [exemplo][an example]
que usa o `package:ffigen` para gerar bindings para
[`AVAudioPlayer`][`AVAudioPlayer`].
Esta API exige pelo menos o macOS SDK 10.7,
então verifique sua versão e atualize o Xcode se necessário:

```console
$ xcodebuild -showsdks
```

Gerar bindings para encapsular uma API Objective-C é parecido com encapsular uma API C.
Aponte o `package:ffigen` para o arquivo de header que descreve a API,
e depois carregue a biblioteca com o `dart:ffi`.

O `package:ffigen` analisa arquivos de header Objective-C
usando o [LLVM][LLVM],
então você precisará instalá-lo primeiro.
Veja [Instalando o LLVM][Installing LLVM]
no README do FFIgen para mais detalhes.

[an example]: {{page.example}}
[`AVAudioPlayer`]: {{page.appledoc}}/avfaudio/avaudioplayer?language=objc
[LLVM]: https://llvm.org/
[Installing LLVM]: {{page.ffigen}}#requirements

### Configurar o FFIgen para Objective-C {:#configure-ffigen-for-objective-c}

Primeiro, adicione o `package:ffigen` como uma dev dependency e os helpers
`package:objective_c` e `package:ffi` como uma dependência comum:

```console
$ dart pub add dev:ffigen objective_c ffi
```

Depois, configure o FFIgen para gerar bindings para o
header Objective-C que contém a API.
Comece criando um script de configuração chamado `ffigen.dart`
na pasta `tool/` do seu pacote,
por exemplo `my_package/tool/ffigen.dart`.

Em `ffigen.dart`, crie um objeto `FfiGenerator`
com suas opções de configuração
e depois chame o método `generate()` dele:

```dart
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
);

Future<void> main() async => await config.generate();
```

Primeiro, você vai dizer ao FFIgen onde encontrar a API para a qual
quer gerar bindings.
Para isso, defina a opção `input.entryPoints`.

Neste exemplo, você vai carregar o `AVAudioPlayer.h`.
Ele faz parte do framework `AVFAudio`,
que fica na sua instalação do Xcode.
O FFIgen inclui algumas funções auxiliares para localizar esses tipos de API,
como `macSdkPath`.
Usar essas funções deixa o script de geração de código
mais confiável em diferentes máquinas,
que podem ter SDKs instalados em locais diferentes.

O utilitário `macSdkPath` encontra o SDK do macOS executando `xcrun --show-sdk-path --sdk macosx`.
Você pode rodar esse comando no terminal para localizar seus SDKs do macOS,
ou com `--sdk iphoneos` para encontrar seus SDKs do iOS.
Ao gerar bindings para uma API da Apple,
explorar esses diretórios é uma ótima forma de encontrar
os headers certos para passar ao FFIgen.

```dart highlightLines=4-10
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  input: Input(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
);

Future<void> main() async => await config.generate();
```

Em seguida, você vai definir o arquivo de saída.
A saída principal do FFIgen é um único arquivo Dart
que contém os bindings para as entradas fornecidas.
Para definir a localização desse arquivo, use a opção `output.dart`.

Às vezes, o FFIgen gera um arquivo `.m`,
que contém código Objective-C necessário para a interop com a API.
O FFIgen gera esse arquivo somente se a API precisar dele
(por exemplo, se você estiver usando blocks ou protocols).
Por padrão, esse arquivo tem o mesmo nome dos bindings Dart,
mas terminando em `.m`.
Você pode mudar a localização dele com a opção `output.objectiveCFile`.
Se o FFIgen produzir esse arquivo, você precisa compilá-lo no seu pacote,
senão você pode receber exceções em tempo de execução relacionadas a símbolos ausentes.
Para este exemplo, o FFIgen não gera um arquivo `.m`.

```dart highlightLines=11-15
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  input: Input(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
  output: Output(
    dart: DartOutput(
      path: Uri.file('avf_audio_bindings.dart'),
    ),
  ),
);

Future<void> main() async => await config.generate();
```

Por fim, diga ao FFIgen quais partes da API de entrada devem ter bindings gerados.
Definir o campo `objectiveC` informa ao FFIgen
para gerar bindings para a linguagem Objective-C
(por padrão, o FFIgen gera bindings em C).

Por padrão, o FFIgen filtra todos os elementos de API de nível superior.
Para gerar bindings para `AVAudioPlayer`,
que é uma interface Objective-C,
adicione um `Visitor` ao campo `visitors` e defina
Por fim, configure o FFIgen para gerar bindings Objective-C
e especifique quais partes da API de entrada incluir.
Por padrão, o FFIgen gera bindings em C
e filtra todos os elementos de API de nível superior.

Para gerar bindings em Objective-C em vez de C,
defina o campo `objectiveC` como `ObjectiveC()`.
Para incluir `AVAudioPlayer`, que é uma interface Objective-C,
adicione um `Visitor` ao campo `visitors` e defina
`node.isIncluded = true` no callback `objCInterface`:

```dart highlightLines=11-20
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  input: Input(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
  objectiveC: const ObjectiveC(),
  visitors: [
    Visitor(
      objCInterface: (node) {
        if (node.name == 'AVAudioPlayer') {
          node.isIncluded = true;
        }
      },
    ),
  ],
  output: Output(
    dart: DartOutput(
      path: Uri.file('avf_audio_bindings.dart'),
    ),
  ),
);

Future<void> main() async => await config.generate();
```

Você também pode usar callbacks de `Visitor` (como `objCMethod`, `objCProtocol`
e `objCCategory`) para filtrar ou renomear interfaces, protocols,
categories ou métodos específicos, definindo `node.isIncluded` ou `node.name`.

Para a lista completa de opções de configuração,
consulte a [documentação da API do FFIgen][FFIgen API documentation].

[FFIgen API documentation]: {{page.ffigenapi}}

### Gerar os bindings Objective-C {:#generate-the-objective-c-bindings}

Para gerar os bindings,
vá até o diretório `example` e execute o script:

```console
$ dart run tool/ffigen.dart
```

Isso deve gerar um arquivo `avf_audio_bindings.dart` grande,
parecido com [este][this one].
A classe principal de interesse é `AVAudioPlayer`.

Você pode notar outras classes no arquivo
com um comentário indicando que são stubs.
O FFIgen gera bindings de stub para todas as dependências transitivas
das APIs incluídas diretamente.
Para gerar bindings completos para esses stubs,
defina `node.isIncluded = true` para eles no seu visitor.

[this one]: {{page.example}}/avf_audio_bindings.dart

### Usar os bindings Objective-C {:#use-the-objective-c-bindings}

Agora você está pronto para carregar e interagir com a biblioteca gerada.
O app de exemplo, [play_audio.dart][play_audio.dart],
carrega e toca arquivos de áudio passados como argumentos de linha de comando.
O primeiro passo é carregar a [dylib][dylib]
e instanciar a biblioteca nativa `AVFAudio`:

```dart
import 'dart:ffi';

import 'package:objective_c/objective_c.dart';

import 'avf_audio_bindings.dart';

const _dylibPath =
    '/System/Library/Frameworks/AVFAudio.framework/Versions/Current/AVFAudio';

void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);
}
```

Como este exemplo carrega uma biblioteca do sistema,
o caminho da dylib aponta para a dylib interna do framework.
Você também pode carregar sua própria `.dylib`,
ou, se a biblioteca estiver linkada estaticamente no seu app (o que costuma acontecer no iOS),
não precisa carregar nada.

O exemplo toca cada um dos arquivos de áudio
especificados como argumentos de linha de comando, um por vez.
Para cada argumento,
primeiro você precisa converter a `String` do Dart para um `NSString` do Objective-C.
O wrapper `NSString` gerado tem um construtor prático
que faz essa conversão,
e um método `toDartString()` que a converte de volta para uma `String` do Dart.

```dart highlightLines=4-7
void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);

  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');
  }
}
```

O player de áudio espera um `NSURL`, então, em seguida,
use o método [`fileURLWithPath:`][`fileURLWithPath:`] para converter o `NSString` em um `NSURL`.

```dart highlightLines=8
void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);

  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');

    final fileUrl = NSURL.fileURLWithPath(fileStr);
  }
}
```

Agora você pode construir o `AVAudioPlayer`.
Construir um objeto Objective-C tem duas etapas.
`alloc` aloca a memória para o objeto,
mas não o inicializa.
Métodos cujos nomes começam com `init*` fazem a inicialização.
Algumas interfaces também oferecem métodos `new*`, que fazem essas duas etapas de uma vez.

Para inicializar o `AVAudioPlayer`,
use o método [`initWithContentsOfURL:error:`][`initWithContentsOfURL:error:`]:

```dart highlightLines=9-13
void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);

  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');

    final fileUrl = NSURL.fileURLWithPath(fileStr);
    final player = AVAudioPlayer.alloc().initWithContentsOfURL(fileUrl);
    if (player == null) {
      print('Failed to load audio.');
      continue;
    }
  }
}
```

Este objeto `AVAudioPlayer` do Dart é um wrapper em torno de um
ponteiro para o objeto `AVAudioPlayer*` do Objective-C subjacente.

O Objective-C usa contagem de referências para gerenciamento de memória
(por meio de retain, release e outras funções),
mas, no lado do Dart, o gerenciamento de memória é feito automaticamente.
O objeto wrapper do Dart mantém uma referência ao objeto Objective-C,
e, quando o objeto Dart é coletado pelo garbage collector,
a referência é liberada automaticamente.

Em seguida, consulte a duração do arquivo de áudio,
que você vai precisar depois para esperar o áudio terminar.
A [`duration`][`duration`] é uma `@property(readonly)`.
Propriedades Objective-C são traduzidas em getters e setters
no objeto wrapper gerado do Dart.
Como `duration` é `readonly`, só o getter é gerado.

`NSTimeInterval` é um alias de tipo para `double`,
então você pode usar imediatamente o método `.ceil()` do Dart
para arredondar para o próximo segundo:

```dart highlightLines=15-16
void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);

  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');

    final fileUrl = NSURL.fileURLWithPath(fileStr);
    final player = AVAudioPlayer.alloc().initWithContentsOfURL(fileUrl);
    if (player == null) {
      print('Failed to load audio.');
      continue;
    }

    final durationSeconds = player.duration.ceil();
    print('$durationSeconds sec');
  }
}
```

Por fim, você pode usar o método [`play`][`play`] para tocar o áudio,
depois verificar o status e esperar a duração do arquivo de áudio:

```dart highlightLines=18-24
void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);

  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');

    final fileUrl = NSURL.fileURLWithPath(fileStr);
    final player = AVAudioPlayer.alloc().initWithContentsOfURL(fileUrl);
    if (player == null) {
      print('Failed to load audio.');
      continue;
    }

    final durationSeconds = player.duration.ceil();
    print('$durationSeconds sec');

    final status = player.play();
    if (status) {
      print('Playing...');
      await Future<void>.delayed(Duration(seconds: durationSeconds));
    } else {
      print('Failed to play audio.');
    }
  }
}
```

[play_audio.dart]: {{page.example}}/play_audio.dart
[dylib]: {{page.appledoc}}/avfaudio?language=objc
[`fileURLWithPath:`]: {{page.appledoc}}/foundation/nsurl/1410828-fileurlwithpath?language=objc

### Limitações de callbacks e multithreading {:#callbacks-and-multithreading-limitations}

Multithreading adiciona complexidade à interop entre Objective-C e Dart.
Isso decorre das diferenças entre isolates do Dart e threads do sistema operacional,
e de como as APIs da Apple lidam com concorrência:

1. Isolates do Dart não são a mesma coisa que threads.
   Isolates rodam em threads, mas não
   têm garantia de rodar em nenhuma thread específica,
   e a VM pode mudar em qual thread um isolate está
   rodando sem aviso.
   Existe uma [solicitação de recurso aberta][open feature request] para permitir que isolates
   sejam fixados em threads específicas.
2. Embora o FFIgen suporte a conversão de
   funções Dart em blocks do Objective-C,
   a maioria das APIs da Apple não garante
   em qual thread um callback vai rodar.
3. A maioria das APIs que envolvem interação com a UI
   só pode ser chamada na thread principal,
   também chamada de thread da plataforma no Flutter.
4. Muitas APIs da Apple são [não thread-safe][not thread safe].

Os dois primeiros pontos significam que um block criado em um isolate
pode ser invocado em uma thread que roda outro isolate,
ou em nenhum isolate.
Dependendo do tipo de block que você está usando,
isso pode fazer seu app travar.
Quando um block é criado, o isolate em que ele foi criado é o dono dele.
Blocks criados com `FooBlock.fromFunction`
devem ser invocados na thread do isolate dono,
senão vão travar.
Blocks criados com `FooBlock.listener` ou `FooBlock.blocking`
podem ser invocados com segurança de qualquer thread,
e a função que eles encapsulam vai ser invocada (eventualmente)
dentro do isolate dono,
embora esses construtores sejam suportados apenas para blocks que retornam `void`.
Se houver demanda dos usuários, `FooBlock.blocking` pode
passar a suportar valores de retorno não-`void` no futuro.

O terceiro ponto significa que chamar diretamente algumas APIs da Apple
usando os bindings Dart gerados pode não ser thread-safe.
Isso pode travar seu app ou causar outro comportamento imprevisível.
Em versões recentes do Flutter, o isolate principal roda na thread da plataforma,
então isso não é um problema ao invocar essas APIs presas a threads
a partir do isolate principal.
Se você precisar invocar essas APIs a partir de outros isolates,
ou precisar dar suporte a versões mais antigas do Flutter,
pode usar a função [`runOnPlatformThread`][`runOnPlatformThread`].
Para mais informações, consulte a [documentação de dispatch do Objective-C][Objective-C dispatch documentation].

Sobre o último ponto,
embora isolates do Dart possam trocar de thread,
eles só rodam em uma thread por vez.
A API com a qual você interage não precisa ser thread-safe,
desde que não tenha restrições sobre
de qual thread é chamada.

Você pode interagir com segurança com código Objective-C
desde que tenha em mente essas limitações.

[`runOnPlatformThread`]: {{site.flutter-api}}/flutter/dart-ui/runOnPlatformThread.html

## Exemplo em Swift {:#swift-example}

Este [exemplo][swift_example] demonstra como
tornar uma classe Swift compatível com Objective-C,
gerar um header wrapper e invocá-la a partir de código Dart.

O processo abaixo é manual.
Existe um projeto experimental para automatizar esses
passos chamado [Swiftgen][Swiftgen].

[Swiftgen]: {{site.pub-pkg}}/swiftgen

### Gerar o header wrapper do Objective-C {:#generating-the-objective-c-wrapper-header}

APIs Swift podem ser tornadas compatíveis com Objective-C
usando a anotação `@objc`.
Certifique-se de tornar `public` quaisquer classes ou métodos que você quer
usar, e fazer suas classes estenderem `NSObject`.

```swift
import Foundation

@objc public class SwiftClass: NSObject {
  @objc public func sayHello() -> String {
    return "Hello from Swift!";
  }

  @objc public var someField = 123;
}
```

Para interagir com uma biblioteca de terceiros que você não pode modificar,
pode ser necessário escrever uma classe wrapper compatível com Objective-C
que exponha os métodos que você quer usar.

Para mais informações sobre a interoperabilidade entre Objective-C e Swift,
consulte a [documentação do Swift][Swift documentation].

Depois que você tornar sua classe compatível,
pode gerar um header wrapper do Objective-C.
Você pode fazer isso pelo Xcode,
ou usando o compilador de linha de comando do Swift, `swiftc`.
Este exemplo usa a linha de comando:

```console
$ swiftc -c swift_api.swift             \
    -module-name swift_module           \
    -emit-objc-header-path swift_api.h  \
    -emit-library -o libswiftapi.dylib
```

Esse comando compila o arquivo Swift, `swift_api.swift`,
e gera um header wrapper, `swift_api.h`.
Ele também gera a dylib que você vai carregar depois,
`libswiftapi.dylib`.

Você pode verificar se o header foi gerado corretamente abrindo-o
e conferindo se as interfaces são as que você espera.
Perto do final do arquivo,
você deve ver algo como o seguinte:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
- (NSString * _Nonnull)sayHello SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic) NSInteger someField;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
```

Se a interface estiver faltando, ou não tiver todos os seus métodos,
certifique-se de que todos estão anotados com `@objc` e `public`.

### Configurar o FFIgen para Swift {:#configuring-ffigen-for-swift}

O FFIgen analisa o header wrapper gerado do Objective-C, `swift_api.h`.
Crie um script de configuração em `tool/ffigen.dart` que configura
Para gerar bindings a partir do header wrapper do Objective-C (`swift_api.h`),
crie um script `tool/ffigen.dart` que faça o seguinte:

- Habilita o suporte a Objective-C com `ObjectiveC()`.
- Define o entry point como `swift_api.h`.
- Inclui `SwiftClass` e define o nome do módulo dela em um visitor `objCInterface`.

```dart
import 'dart:io';

import 'package:ffigen/ffigen.dart';

Future<void> main() async {
  final packageRoot = Platform.script.resolve('../');
  final generator = FfiGenerator(
    output: Output(
      dart: DartOutput(path: packageRoot.resolve('swift_api_bindings.dart')),
    ),
    objectiveC: const ObjectiveC(),
    input: Input(
      entryPoints: [packageRoot.resolve('swift_api.h')],
    ),
    visitors: [
      Visitor(
        objCInterface: (node) {
          if (node.name == 'SwiftClass') {
            node.isIncluded = true;
            node.module = 'swift_module';
          }
        },
      ),
    ],
  );
  await generator.generate();
}
```

Essa configuração habilita o suporte a Objective-C com `ObjectiveC()`,
define o entry point como `swift_api.h`
e inclui explicitamente `SwiftClass`
dentro de um visitor `objCInterface`.

Um requisito de configuração essencial para APIs Swift encapsuladas
é definir a propriedade `node.module` no nó AST `ObjCInterface`.
Quando o `swiftc` compila a biblioteca,
ele dá à interface Objective-C um prefixo de módulo.
Internamente, `SwiftClass` é registrada como
`swift_module.SwiftClass`.
Você precisa informar ao `ffigen` sobre esse prefixo
usando `node.module`,
para que ele carregue a classe correta da dylib.

Nem toda classe recebe esse prefixo.
Por exemplo, `NSString` e `NSObject`
não recebem um prefixo de módulo,
porque são classes internas.
No seu visitor `objCInterface`,
defina `node.module` apenas nas classes do seu módulo Swift.

O prefixo de módulo é o que você passou para
o `swiftc` na flag `-module-name`.
Neste exemplo, é `swift_module`.
Se você não definir essa flag explicitamente,
ele assume o nome do arquivo Swift.

Se você não tiver certeza do nome do módulo,
também pode conferir o header Objective-C gerado.
Acima do `@interface`, você vai encontrar a macro `SWIFT_CLASS`:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
```

A string dentro da macro contém o nome do módulo e o nome da classe:
`"_TtC12`***`swift_module`***`10`***`SwiftClass`***`"`.

O próprio Swift consegue desfazer essa codificação (demangle) do nome para nós:

```console
$ echo "_TtC12swift_module10SwiftClass" | swift demangle
```

Isso imprime `swift_module.SwiftClass`.

### Gerar os bindings do Swift {:#generating-the-swift-bindings}

Para gerar os bindings,
vá até o diretório de exemplo e execute o seu script de configuração:

```console
$ dart run tool/ffigen.dart
```

Isso gera `swift_api_bindings.dart`.

### Usar os bindings do Swift {:#using-the-swift-bindings}

Carregue a biblioteca dinâmica e chame os bindings Swift gerados a partir do Dart:

```dart
import 'dart:ffi';

import 'package:objective_c/objective_c.dart';

import 'swift_api_bindings.dart';

void main() {
  DynamicLibrary.open('libswiftapi.dylib');
  final object = SwiftClass();
  print(object.sayHello().toDartString());
  print('field = ${object.someField}');
  object.someField = 456;
  print('field = ${object.someField}');
}
```

Observe que o nome do módulo não aparece
na API Dart gerada.
Ele só é usado internamente
para carregar a classe da dylib.

Agora você pode executar o exemplo usando:

```console
$ dart run example.dart
```

[`initWithContentsOfURL:error:`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387281-initwithcontentsofurl?language=objc
[`duration`]: {{page.appledoc}}/avfaudio/avaudioplayer/1388395-duration?language=objc
[`play`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387388-play?language=objc
[Swift documentation]: {{page.appledoc}}/swift/importing-swift-into-objective-c
[open feature request]: {{site.repo.dart.sdk}}/issues/46943
[`package:cupertino_http`]: {{site.repo.dart.org}}/http/blob/master/pkgs/cupertino_http/src/CUPHTTPClientDelegate.m
[not thread safe]: {{site.apple-dev}}/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html
[Objective-C dispatch documentation]: {{page.appledoc}}/dispatch?language=objc
[swift_example]: {{site.repo.dart.org}}/native/tree/main/pkgs/ffigen/example/swift
