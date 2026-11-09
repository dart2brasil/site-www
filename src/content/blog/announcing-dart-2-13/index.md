---
ia-translate: true
title: "Anunciando o Dart 2.13"
description: "Nova funcionalidade de linguagem type aliases, Dart FFI melhorado"
publishDate: 2021-05-19
author: mit-mit
image: images/1qMQKtkRNuvBjORjoJrN2bQ.webp
category: releases
layout: blog
---


<DashImage src="images/1qMQKtkRNuvBjORjoJrN2bQ.webp" alt="Dart 2.13 release banner highlighting type aliases, faster FFI, null safety, and Docker support." />


*Por Kevin Moore e Michael Thomsen*

Hoje anunciamos o Dart 2.13, com *type aliases*, atualmente o nosso segundo recurso de linguagem mais pedido. O Dart 2.13 também traz um Dart FFI melhorado e um desempenho melhor, e temos novas Docker Official Images para o Dart. Este post atualiza a funcionalidade de null safety introduzida no 2.12, discute os novos recursos do 2.13, traz novidades empolgantes sobre o suporte do Docker e do Google Cloud para backends em Dart, e antecipa algumas mudanças que você pode esperar nas próximas versões.

## Atualização sobre o null safety {:#null-safety-update}

Lançamos o [sound null safety](https://dart.dev/null-safety) em março, na versão [Dart 2.12](/blog/announcing-dart-2-12). O null safety é a mais recente grande funcionalidade de produtividade do Dart, criada para ajudar você a evitar erros de null, uma classe de bugs que costuma ser difícil de identificar. Com esse lançamento, incentivamos os publicadores de pacotes a começar a migrar os pacotes compartilhados no pub.dev para o null safety.

Ficamos muito satisfeitos em ver como o null safety foi adotado rapidamente! Poucos meses após o lançamento, **93% dos 500 pacotes mais populares do pub.dev já suportam null safety**. Agradecemos sinceramente a todos os desenvolvedores de pacotes por fazerem esse trabalho tão rapidamente e por ajudarem todo o ecossistema a avançar!

Com tantos pacotes suportando null safety, há uma boa chance de você poder começar a migrar suas aplicações para usar null safety. O primeiro passo é usar `dart pub outdated` para verificar as dependências da sua aplicação. Para mais detalhes, veja o [guia de migração para o null safety](https://dart.dev/null-safety/migration-guide#step1-wait). Também mudamos os templates de `dart create` e `flutter create` para que passem a ativar o null safety por padrão em novas aplicações e pacotes.

## Anunciando type aliases {:#announcing-type-aliases}

Type aliases é uma nova funcionalidade da linguagem na versão 2.13. Ela amplia o suporte que já existia, que permitia criar aliases de tipos de função, mas não de outros tipos. Essa funcionalidade muito desejada foi a segunda mais bem [avaliada](https://github.com/dart-lang/language/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) no issue tracker da linguagem.

Usando um type alias, você pode criar um novo nome para qualquer tipo existente, que pode ser usado em qualquer lugar onde o tipo original poderia ser usado. Você não está realmente definindo um novo tipo, apenas introduzindo um alias abreviado. O alias até passa nos testes de igualdade de tipos:

```
typedef Integer = int;

void main() {
  print(int == Integer); // true
}
```


Então, para que você pode usar type aliases? Um uso comum é dar um nome mais curto ou mais descritivo a um tipo, tornando seu código mais legível e fácil de manter.

Um bom exemplo é trabalhar com JSON (obrigado ao usuário do GitHub [Levi-Lesches](https://github.com/Levi-Lesches) por este exemplo). Aqui podemos definir um novo type alias `Json`, que descreve um documento JSON como um mapa de chaves `String` para qualquer valor (usando o tipo `dynamic`). Depois, podemos usar esse type alias `Json` ao definir nosso construtor nomeado `fromJson` e o getter `json`.

```
typedef Json = Map<String, dynamic>;

class User {
  final String name;
  final int age;

  User.fromJson(Json json) :
    name = json['name'],
    age = json['age'];

Json get json => {
    'name': name,
    'age': age,
  };
}
```


Você também pode chamar construtores em um type alias que nomeia uma classe, então o código a seguir é perfeitamente válido:

```
main() {
  var j = Json();
  j['name'] = 'Michael';
}
```


Ao usar type aliases para dar nomes a tipos complexos, você pode facilitar para quem lê entender as invariantes do seu código. Por exemplo, o código a seguir define um type alias para descrever mapas que contêm chaves de tipo genérico `X` e valores do tipo `List&lt;X&gt;`. Ao dar ao tipo um nome com um único parâmetro de tipo, a estrutura regular do mapa fica mais evidente para quem lê o código.

```
typedef MapToList<X> = Map<X, List<X>>;
void main() {
  MapToList<int> m = {};
  m[7] = [7]; // OK
  m[8] = [2, 2, 2]; // OK
  for (var x in m.keys) {
    print('$x --> ${m[x]}');
  }
}

=>

7 --> [7]
8 --> [2, 2, 2]
```


Se você tentar usar tipos que não correspondem, receberá um erro de análise:

```
m[42] = ['The', 'meaning', 'of', 'life'];

=>

The element type 'String' can't be assigned to the list type 'int'.
```


Você pode até usar type aliases ao renomear classes em bibliotecas públicas. Imagine que você tenha uma classe existente `PoorlyNamedClass` em uma biblioteca pública que quer renomear para `BetterNamedClass`. Se você simplesmente renomear a classe, seus clientes da API terão erros de compilação repentinos. Com type aliases, você pode fazer a renomeação, mas depois definir um novo type alias para o nome antigo da classe e adicionar uma anotação `@Deprecated` ao nome antigo. Usos de `PoorlyNamedClass` passarão a gerar um aviso quando usados, mas continuarão compilando e funcionando como antes, dando aos usuários tempo para atualizar o código.

Veja como você pode implementar `BetterNamedClass` e depreciar `PoorlyNamedClass` (em um arquivo chamado `mylibrary.dart`):

```
class BetterNamedClass {...}

@Deprecated('Use BetterNamedClass instead')
typedef PoorlyNamedClass = BetterNamedClass;
```


E aqui está o que acontece quando alguém tenta usar `PoorlyNamedClass`:

```
import 'mylibrary.dart';

void main() {
  PoorlyNamedClass p;
}

=>

'PoorlyNamedClass' is deprecated and shouldn't be used. Use BetterNamedClass instead.
```


A funcionalidade de type aliases está disponível a partir do Dart 2.13. Para ativá-la, defina a restrição mínima de SDK do Dart no seu pubspec para pelo menos 2.13:

```
environment:
  sdk: ">=2.13.0 <3.0.0"
```


Este recurso é compatível com versões anteriores, graças ao [versionamento da linguagem](https://dart.dev/language/versioning). Pacotes com restrições de SDK inferiores a 2.13 podem referenciar com segurança type aliases definidos em pacotes 2.13, mesmo que pacotes anteriores à 2.13 não possam definir os próprios type aliases.

## Mudanças no FFI do Dart 2.13 {:#dart-2-13-ffi-changes}

Também temos alguns novos recursos no Dart FFI, nosso mecanismo de interoperabilidade para chamar código C.

Primeiro, o FFI agora suporta structs que têm arrays inline ([#35763](https://github.com/dart-lang/sdk/issues/35763)). Considere uma struct C com um array inline assim:

```
struct MyStruct {
  uint8_t arr[8];
}
```


Agora você pode encapsulá-la diretamente em Dart, especificando o tipo do elemento com um argumento de tipo para `Array`:

```
class StructInlineArray extends Struct {
  [@Array](http://twitter.com/Array)(8)
  external Array<Uint8> arr;
}
```


Segundo, o FFI agora suporta structs empacotadas ([#38158](https://github.com/dart-lang/sdk/issues/38158)). Normalmente, as structs são organizadas na memória de modo que os membros caiam em limites de endereço que são mais fáceis de acessar para a CPU. Com [structs empacotadas](http://www.catb.org/esr/structure-packing/), parte desse preenchimento (padding) é omitida para reduzir o consumo total de memória, muitas vezes de formas específicas de cada plataforma. Com a nova anotação `@Packed(&lt;alignment&gt;)`, você pode especificar o preenchimento facilmente. Por exemplo, o código a seguir cria uma struct com alinhamento de 4 bytes quando está na memória:

```
[@Packed](http://twitter.com/Packed)(4)
class TASKDIALOGCONFIG extends Struct {
  [@Uint32](http://twitter.com/Uint32)()
  external int cbSize;
  [@IntPtr](http://twitter.com/IntPtr)()
  external int hwndParent;
  [@IntPtr](http://twitter.com/IntPtr)()
  external int hInstance;
  [@Uint32](http://twitter.com/Uint32)()
  external int dwFlags;
  ...
}
```


## Mudanças de desempenho do Dart 2.13 {:#dart-2-13-performance-changes}

Continuamos trabalhando para reduzir o tamanho da aplicação e o consumo de memória do código Dart. Em aplicações Flutter grandes, as estruturas internas que representam os metadados de um programa Dart compilado com AOT podem ocupar um pedaço considerável da memória. A maior parte desses metadados existe para habilitar recursos como hot reload, depuração interativa e formatação de stack traces legíveis por humanos, recursos que nunca são usados em aplicações publicadas. Ao longo do último ano, reestruturamos o runtime nativo do Dart para eliminar o máximo possível dessa sobrecarga. Algumas dessas melhorias se aplicam a todas as aplicações Flutter compiladas em modo release, mas algumas exigem que você abra mão de stack traces legíveis, separando as informações de depuração das aplicações compiladas com AOT pela flag [`--split-debug-info`](https://flutter.dev/docs/perf/app-size#reducing-app-size).

O Dart 2.13 inclui várias mudanças que reduzem significativamente o espaço ocupado pelos metadados do programa quando `--split-debug-info` é usado. Tomando como exemplo o app Flutter Gallery: no Android, o APK de release tem 112,4 MB com informações de depuração e 106,7 MB sem elas (uma redução geral de 5%). Esse APK contém muitos assets. Olhando apenas para os metadados de código dentro do APK, eles caíram de 5,7 MB no Dart 2.12 para apenas 3,7 MB no Dart 2.13 (uma redução de 35%).

Se o tamanho da aplicação e o consumo de memória são importantes para você, considere omitir as informações de depuração usando a flag `--split-debug-info`. Observe que, ao fazer isso, você precisará usar o comando [`symbolize`](https://flutter.dev/docs/deployment/obfuscate#reading-an-obfuscated-stack-trace) para tornar os stack traces legíveis novamente.

## Docker oficial e Dart no Google Cloud {:#official-docker-support-and-dart-on-google-cloud}

O Dart agora está disponível como [Docker Official Images](https://docs.docker.com/docker-hub/official_images/). Embora o Dart já oferecesse imagens Docker há anos, essas [novas imagens do Dart](https://hub.docker.com/_/dart) são testadas e validadas pelo Docker para seguir as melhores práticas. Elas também suportam compilação ahead-of-time (AOT), que pode reduzir drasticamente o tamanho dos contêineres criados e melhorar a velocidade de deploy em ambientes de contêineres, como o [Cloud Run](https://cloud.google.com/run).

Embora o Dart continue focado em permitir que frameworks de aplicação como o Flutter criem experiências bonitas em cada tela, sabemos que por trás da maioria das experiências do usuário há pelo menos um serviço hospedado. Ao facilitar a criação de serviços de backend com Dart, oferecemos uma experiência full stack que permite aos desenvolvedores estender a aplicação para a nuvem usando a mesma linguagem e a mesma lógica de negócio que usam para alimentar os widgets no frontend.

Em geral, usar Dart para backends de aplicações Flutter é uma escolha especialmente boa pela simplicidade e escalabilidade da plataforma serverless gerenciada do Google, o Cloud Run. Isso inclui o scale-to-zero, o que significa que você não paga quando o seu backend não está processando nenhuma requisição. Trabalhamos com a equipe do Google Cloud para oferecer o [Functions Framework for Dart](https://pub.dev/packages/functions_framework), um conjunto de pacotes, ferramentas e exemplos que facilitam escrever funções Dart para deploy, em vez de servidores completos para processar requisições HTTP e CloudEvents.

Confira nossa [documentação do Google Cloud](https://dart.dev/server/google-cloud) para começar.

## Algumas palavras sobre o que vem a seguir {:#a-few-words-about-whats-next}

Já estamos trabalhando em algumas mudanças empolgantes para as próximas versões. Como sempre, você pode usar o [funil de linguagem](https://github.com/dart-lang/language/projects/1) para acompanhar o nosso progresso.

Uma das áreas em que estamos trabalhando é um novo conjunto de lints canônicos para o Dart e o Flutter. Lints são uma forma poderosa de configurar a [análise estática](https://dart.dev/guides/language/analysis-options) do Dart, mas, com centenas de lints possíveis para ligar ou desligar, pode ser difícil decidir o que escolher. Estamos definindo dois conjuntos canônicos de lints que aplicaremos por padrão em projetos Dart e Flutter. Esperamos que isso fique ativado por padrão na próxima versão stable. Se quiser uma prévia, confira os dois pacotes [lints](https://pub.dev/packages/lints) e [flutter_lints](https://pub.dev/packages/flutter_lints).

Por fim, se você faz embedding profundo do runtime da VM do Dart, observe que planejamos depreciar o mecanismo atual para isso. Vamos substituí-lo por um modelo mais rápido e flexível, baseado no Dart FFI (veja a issue de acompanhamento [#45451](https://github.com/dart-lang/sdk/issues/45451)).

## O Dart 2.13 já está disponível {:#dart-2-13-is-available-now}

O Dart 2.13, com type aliases e FFI melhorado, já está disponível nos SDKs [Dart 2.13](https://dart.dev/get-dart) e [Flutter 2.2](https://flutter.dev/docs/get-started/).

Se você estava esperando que suas dependências migrassem para o null safety, talvez queira verificar de novo, usando `dart pub outdated`. Com 93% dos 500 pacotes mais populares já migrados, há uma boa chance de que você já esteja desbloqueado. Também gostaríamos de agradecer aos desenvolvedores que já migraram!

Adoraríamos saber sobre a sua experiência com os novos recursos e mudanças discutidos neste post. Deixe um comentário abaixo ou nos mande um tweet para [@dart_lang](https://twitter.com/dart_lang).
