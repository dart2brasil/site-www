---
ia-translate: true
title: "Interoperabilidade com Objective-C e Swift usando package:ffigen"
shortTitle: "Objective-C & Swift interop"
breadcrumb: Objective-C & Swift
description: "Para usar código Objective-C e Swift em seu programa Dart, use package:ffigen."
ffigen: "https://pub.dev/packages/ffigen"
example: "https://github.com/dart-lang/native/tree/main/pkgs/ffigen/example/objective_c"
ffigenapi: "https://pub.dev/documentation/ffigen/latest/ffigen"
ffigendoc: "https://github.com/dart-lang/native/blob/main/pkgs/ffigen/doc/README.md"
appledoc: "https://developer.apple.com/documentation"
---

Aplicações Dart executando na [plataforma Dart Native][Dart Native platform] (macOS ou iOS)
podem usar `dart:ffi` e [`package:ffigen`][]
para chamar APIs Objective-C e Swift.

`dart:ffi` permite que código Dart interaja com APIs nativas C.
Objective-C é baseado e compatível com C,
então é possível interagir com APIs Objective-C usando apenas `dart:ffi`.
No entanto, fazer isso requer um código boilerplate significativo,
então você pode usar `package:ffigen` para gerar automaticamente
os bindings Dart FFI para uma determinada API Objective-C.
Para aprender mais sobre FFI e interfaceamento direto com código C,
consulte o [guia de interop com C][C interop guide].

Você pode gerar headers (cabeçalhos) Objective-C para APIs Swift,
permitindo que `dart:ffi` e `package:ffigen` interajam com Swift.

Para mais informações sobre o uso do FFIgen,
consulte o [README do FFIgen][FFIgen README]
e a [documentação adicional][additional documentation].

[Dart Native platform]: /overview#platform
[`package:ffigen`]: {{page.ffigen}}
[C interop guide]: /interop/c-interop
[FFIgen README]: {{page.ffigen}}
[additional documentation]: {{page.ffigendoc}}

## Exemplo Objective-C

Este guia orienta você através de [um exemplo][an example]
que usa `package:ffigen` para gerar bindings para
[`AVAudioPlayer`][].
Esta API requer pelo menos macOS SDK 10.7,
então verifique sua versão e atualize o Xcode se necessário:

```console
$ xcodebuild -showsdks
```

Gerar bindings para envolver uma API Objective-C é semelhante a envolver uma API C.
Direcione `package:ffigen` para o arquivo de header que descreve a API,
e então carregue a biblioteca com `dart:ffi`.

`package:ffigen` analisa arquivos de header Objective-C
usando [LLVM][],
então você precisará instalá-lo primeiro.
Consulte [Installing LLVM][]
no README do FFIgen para mais detalhes.

[an example]: {{page.example}}
[`AVAudioPlayer`]: {{page.appledoc}}/avfaudio/avaudioplayer?language=objc
[LLVM]: https://llvm.org/
[Installing LLVM]: {{page.ffigen}}#installing-llvm

### Configurar FFIgen para Objective-C

Primeiro, adicione `package:ffigen` como uma dependência de desenvolvimento e os helpers
`package:objective_c` e `package:ffi` como uma dependência regular:

```console
$ dart pub add dev:ffigen objective_c ffi
```

Em seguida, configure o FFIgen para gerar bindings para o
header Objective-C contendo a API.
Configure o FFIgen usando YAML ou código Dart; recomendamos Dart para novos projetos.
A configuração YAML será descontinuada em versões futuras do FFIgen.
Comece criando um script `generate_code.dart` em algum lugar do seu pacote.
Recomendamos colocar este arquivo em `my_package/tool`.

O script `generate_code.dart` deve criar um objeto `FfiGenerator`,
que conterá todas as suas opções de configuração,
e então chamar seu método `.generate()`.

```dart
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
);

void main() => config.generate();
```

Primeiro, você dirá ao FFIgen onde encontrar a API para a qual está tentando
gerar bindings.
Para fazer isso, defina a opção `headers.entryPoints`.

Para este exemplo, você carregará `AVAudioPlayer.h`.
Este faz parte do framework `AVFAudio`,
que está localizado na sua instalação do Xcode.
O FFIgen inclui algumas funções auxiliares para localizar esses tipos de APIs,
como `macSdkPath`.
Usar essas funções auxiliares torna seu script de geração de código
mais confiável em diferentes máquinas,
que podem ter diferentes locais de instalação do SDK.

O utilitário `macSdkPath` encontra o macOS SDK executando `xcrun --show-sdk-path --sdk macosx`.
Você pode executar este comando em um terminal para localizar seus macOS SDKs,
ou com `--sdk iphoneos` para encontrar seus iOS SDKs.
Ao gerar bindings para uma API Apple,
explorar esses diretórios é uma ótima maneira de encontrar
os headers corretos para passar ao FFIgen.

```dart highlightLines=4-10
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  headers: Headers(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
);

void main() => config.generate();
```

Em seguida, você definirá o arquivo de saída.
A saída principal do FFIgen é um único arquivo Dart
contendo bindings para as entradas fornecidas.
A localização deste arquivo é definida pela opção `output.dartFile`.

O FFIgen às vezes gera um arquivo `.m`,
contendo código Objective-C necessário para interop com a API.
O FFIgen gera este arquivo apenas se a API exigir
(por exemplo, se você estiver usando blocks ou protocols).
Por padrão, este arquivo tem o mesmo nome que os bindings Dart,
mas com `.m` no final do nome do arquivo.
Você pode alterar sua localização com a opção `output.objectiveCFile`.
Se o FFIgen produzir este arquivo, você deve compilá-lo no seu pacote,
caso contrário, você pode obter exceções em tempo de execução relacionadas a símbolos ausentes.
Para este exemplo, o FFIgen não gera um arquivo `.m`.

```dart highlightLines=11-13
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  headers: Headers(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
  output: Output(
    dartFile: Uri.file('avf_audio_bindings.dart'),
  ),
);

void main() => config.generate();
```

Finalmente, diga ao FFIgen quais partes da API de entrada gerar bindings.
Por padrão, o FFIgen filtra todos os bindings.
Neste caso, para gerar bindings para `AVAudioPlayer`,
que é uma interface Objective-C,
você precisa definir o campo `objectiveC.interfaces`.

Definir o campo `objectiveC` diz ao FFIgen
para gerar bindings para a linguagem Objective-C.
Por padrão, o FFIgen gera bindings C.

```dart highlightLines=11-13
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  headers: Headers(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
  objectiveC: ObjectiveC(
    interfaces: Interfaces.includeSet({'AVAudioPlayer'}),
  ),
  output: Output(
    dartFile: Uri.file('lib/avf_audio_bindings.dart'),
  ),
);

void main() => config.generate();
```

Você pode usar `includeMember` para filtrar métodos específicos da classe,
e `rename` ou `renameMember` para renomear as classes ou métodos incluídos.
Existem opções semelhantes para protocols e categories.

Para uma lista completa de opções de configuração,
confira a [documentação da API do FFIgen][FFIgen API documentation].

[FFIgen API documentation]: {{page.ffigenapi}}

### Gerar os bindings Objective-C

Para gerar os bindings,
navegue até o diretório `example` e execute o script:

```console
$ dart run tool/generate_code.dart
```

Isso deve gerar um grande arquivo `avf_audio_bindings.dart`,
semelhante a [este][this one].
A classe principal de interesse é `AVAudioPlayer`.

Você pode notar outras classes no arquivo
com um comentário indicando que são um stub.
O FFIgen gera bindings stub para todas as dependências transitivas
das APIs diretamente incluídas.
Para gerar bindings completos para esses stubs,
adicione-os aos includes na sua configuração.
Este comportamento de stubbing pode ser alterado
com as opções `includeTransitive`.

[this one]: {{page.example}}/avf_audio_bindings.dart

### Usar os bindings Objective-C

Agora você está pronto para carregar e interagir com a biblioteca gerada.
O aplicativo de exemplo, [play_audio.dart][],
carrega e reproduz arquivos de áudio passados como argumentos de linha de comando.
O primeiro passo é carregar o [dylib][]
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
o caminho do dylib aponta para o dylib interno do framework.
Você também pode carregar seu próprio arquivo `.dylib`,
ou se a biblioteca estiver estaticamente vinculada ao seu aplicativo (frequentemente o caso no iOS)
você não precisa carregar nada.

O exemplo reproduz cada um dos arquivos de áudio
especificados como argumentos de linha de comando um por um.
Para cada argumento,
você primeiro precisa converter a `String` Dart para uma `NSString` Objective-C.
O wrapper `NSString` gerado tem um construtor conveniente
que lida com essa conversão,
e um método `toDartString()` que o converte de volta para uma `String` Dart.

```dart highlightLines=4-7
void main(List<String> args) async {
  DynamicLibrary.open(_dylibPath);

  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');
  }
}
```

O player de áudio espera uma `NSURL`, então a seguir,
use o método [`fileURLWithPath:`][] para converter a `NSString` em uma `NSURL`.

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

Agora, você pode construir o `AVAudioPlayer`.
A construção de um objeto Objective-C tem duas etapas.
`alloc` aloca a memória para o objeto,
mas não a inicializa.
Métodos com nomes que começam com `init*` fazem a inicialização.
Algumas interfaces também fornecem métodos `new*` que fazem ambas as etapas.

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

Este objeto `AVAudioPlayer` Dart é um wrapper em torno de um
ponteiro de objeto `AVAudioPlayer*` Objective-C subjacente.

Objective-C usa contagem de referência para gerenciamento de memória
(através de retain, release e outras funções),
mas no lado Dart o gerenciamento de memória é tratado automaticamente.
O objeto wrapper Dart mantém uma referência ao objeto Objective-C,
e quando o objeto Dart é coletado pelo garbage collector,
a referência é automaticamente liberada.

Em seguida, procure a duração do arquivo de áudio,
que você precisará mais tarde para esperar que o áudio termine.
O [`duration`][`duration`] é um `@property(readonly)`.
Propriedades Objective-C são traduzidas em getters e setters
no objeto wrapper Dart gerado.
Como `duration` é `readonly`, apenas o getter é gerado.

`NSTimeInterval` é um alias de tipo para `double`,
então você pode usar imediatamente o método Dart `.ceil()`
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

Finalmente, você pode usar o método [`play`][`play`] para reproduzir o áudio,
então verifique o status e espere pela duração do arquivo de áudio:

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

### Callbacks e limitações de multithreading

Multithreading introduz complexidade ao interop entre Objective-C e Dart.
Isso decorre das diferenças entre isolates Dart e threads do SO,
e como as APIs da Apple lidam com concorrência:

1. Isolates Dart não são a mesma coisa que threads.
   Isolates executam em threads, mas não têm
   garantia de executar em nenhuma thread específica,
   e a VM pode mudar em qual thread um isolate está
   executando sem aviso.
   Há uma [solicitação de funcionalidade aberta][open feature request] para permitir que isolates sejam
   fixados a threads específicas.
2. Embora o FFIgen suporte converter
   funções Dart em blocks Objective-C,
   a maioria das APIs Apple não faz nenhuma garantia sobre
   em qual thread um callback será executado.
3. A maioria das APIs que envolvem interação com UI
   só podem ser chamadas na thread principal,
   também chamada de platform thread no Flutter.
4. Muitas APIs Apple [não são thread safe][not thread safe].

Os dois primeiros pontos significam que um block criado em um isolate
pode ser invocado em uma thread executando um isolate diferente,
ou nenhum isolate.
Dependendo do tipo de block que você está usando,
isso pode fazer com que seu aplicativo falhe.
Quando um block é criado, o isolate em que foi criado é seu proprietário.
Blocks criados usando `FooBlock.fromFunction`
devem ser invocados na thread do isolate proprietário,
caso contrário eles irão falhar.
Blocks criados usando `FooBlock.listener` ou `FooBlock.blocking`
podem ser invocados com segurança de qualquer thread,
e a função que eles encapsulam será (eventualmente) invocada
dentro do isolate proprietário,
embora esses construtores sejam suportados apenas para blocks que retornam `void`.
Se houver demanda do usuário para isso, `FooBlock.blocking` pode
adicionar suporte para valores de retorno não-`void` no futuro.

O terceiro ponto significa que chamar diretamente algumas APIs Apple
usando os bindings Dart gerados pode ser thread unsafe.
Isso pode fazer com que seu aplicativo falhe ou cause outro comportamento imprevisível.
Em versões recentes do Flutter, o isolate principal executa na platform thread,
então isso não é um problema ao invocar essas APIs bloqueadas por thread
do isolate principal.
Se você precisar invocar essas APIs de outros isolates,
ou se precisar suportar versões mais antigas do Flutter,
você pode usar a função [`runOnPlatformThread`][].
Para mais informações, consulte a [documentação de dispatch Objective-C][Objective-C dispatch documentation].

Com relação ao último ponto,
embora os isolates Dart possam trocar de threads,
eles só executam em uma thread por vez.
A API com a qual você interage não precisa ser thread safe,
desde que não tenha restrições sobre
de qual thread é chamada.

Você pode interagir com segurança com código Objective-C
desde que mantenha essas limitações em mente.

[`runOnPlatformThread`]: {{site.flutter-api}}/flutter/dart-ui/runOnPlatformThread.html

## Exemplo Swift {:#swift-example}

Este [exemplo][swift_example] demonstra como
tornar uma classe Swift compatível com Objective-C,
gerar um header wrapper e invocá-lo a partir do código Dart.

O processo abaixo é manual.
Há um projeto experimental para automatizar essas etapas
chamado [Swiftgen][].

[Swiftgen]: {{site.pub-pkg}}/swiftgen

### Gerar o header wrapper Objective-C

As APIs Swift podem ser tornadas compatíveis com Objective-C,
usando a anotação `@objc`.
Certifique-se de tornar quaisquer classes ou métodos que você deseja usar
`public`, e que suas classes estendam `NSObject`.

```swift
import Foundation

@objc public class SwiftClass: NSObject {
  @objc public func sayHello() -> String {
    return "Olá do Swift!";
  }

  @objc public var someField = 123;
}
```

Para interagir com uma biblioteca de terceiros que você não pode modificar,
você pode precisar escrever uma classe wrapper compatível com Objective-C
que exponha os métodos que você deseja usar.

Para obter mais informações sobre a interoperabilidade Objective-C / Swift,
consulte a [documentação Swift][Swift documentation].

Depois de tornar sua classe compatível,
você pode gerar um header wrapper Objective-C.
Você pode fazer isso usando o Xcode,
ou usando o compilador de linha de comando Swift, `swiftc`.
Este exemplo usa a linha de comando:

```console
$ swiftc -c swift_api.swift             \
    -module-name swift_module           \
    -emit-objc-header-path swift_api.h  \
    -emit-library -o libswiftapi.dylib
```

Este comando compila o arquivo Swift, `swift_api.swift`,
e gera um header wrapper, `swift_api.h`.
Ele também gera o dylib que você vai carregar mais tarde,
`libswiftapi.dylib`.

Você pode verificar se o header foi gerado corretamente abrindo-o
e verificando se as interfaces são o que você espera.
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

Se a interface estiver ausente ou não tiver todos os seus métodos,
certifique-se de que todos estejam anotados com `@objc` e `public`.

### Configurar FFIgen para Swift

O FFIgen vê apenas o header wrapper Objective-C, `swift_api.h`.
Então a maior parte dessa configuração parece semelhante
ao exemplo Objective-C,
incluindo definir a linguagem como `objc`.

```yaml
ffigen:
  name: SwiftLibrary
  description: Bindings para swift_api.
  language: objc
  output: 'swift_api_bindings.dart'
  exclude-all-by-default: true
  objc-interfaces:
    include:
      - 'SwiftClass'
    module:
      'SwiftClass': 'swift_module'
  headers:
    entry-points:
      - 'swift_api.h'
```

Como antes, defina a linguagem para `objc`,
e o ponto de entrada para o header;
exclua tudo por padrão,
e inclua explicitamente a interface que você está vinculando.

Uma diferença chave de configuração para APIs Swift encapsuladas
é a opção `objc-interfaces` -> `module`.
Quando `swiftc` compila a biblioteca,
ele dá à interface Objective-C um prefixo de módulo.
Internamente, `SwiftClass` é registrado como
`swift_module.SwiftClass`.
Você precisa dizer ao `ffigen` sobre este prefixo,
para que ele carregue a classe correta do dylib.

Nem toda classe recebe este prefixo.
Por exemplo, `NSString` e `NSObject`
não receberão um prefixo de módulo,
porque são classes internas.
É por isso que a opção `module` mapeia
do nome da classe para o prefixo do módulo.
Você também pode usar expressões regulares para corresponder
vários nomes de classe de uma vez.

O prefixo do módulo é o que você passou para
`swiftc` na flag `-module-name`.
Neste exemplo, é `swift_module`.
Se você não definir explicitamente esta flag,
ele assume como padrão o nome do arquivo Swift.

Se você não tiver certeza de qual é o nome do módulo,
você também pode verificar o header Objective-C gerado.
Acima de `@interface`, você encontrará uma macro `SWIFT_CLASS`:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
```

A string dentro da macro contém o nome do módulo e o nome da classe:
`"_TtC12`***`swift_module`***`10`***`SwiftClass`***`"`.

O Swift pode até mesmo desmascarar este nome para nós:

```console
$ echo "_TtC12swift_module10SwiftClass" | swift demangle
```

Isso produz `swift_module.SwiftClass`.

### Gerar os bindings Swift

Como antes, para gerar os bindings,
navegue até o diretório de exemplo e execute o FFIgen:

```console
$ dart run ffigen
```

Isso gera `swift_api_bindings.dart`.

### Usar os bindings Swift

A interação com esses bindings é exatamente a mesma
que para uma biblioteca Objective-C normal:

```dart
import 'dart:ffi';
import 'swift_api_bindings.dart';

void main() {
  final lib = SwiftLibrary(DynamicLibrary.open('libswiftapi.dylib'));
  final object = SwiftClass.new1(lib);
  print(object.sayHello());
  print('field = ${object.someField}');
  object.someField = 456;
  print('field = ${object.someField}');
}
```

Observe que o nome do módulo não é mencionado
na API Dart gerada.
Ele é usado apenas internamente
para carregar a classe do dylib.

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
