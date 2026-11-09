---
ia-translate: true
title: "Evoluindo a PoC do REPL do Dart"
description: "Hackeando com Dart"
publishDate: 2017-04-19
author: BlackHC
image: images/0VisHHMp_ARvFA08w.webp
category: deep-dive
layout: blog
---


<DashImage src="images/0VisHHMp_ARvFA08w.webp" alt="Flutter logo." />


O [REPL do Dart](https://github.com/BlackHC/dart_repl) permite avaliar expressões e instruções Dart em um [shell interativo](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). Já faz um tempo desde [meu primeiro post sobre o REPL do Dart](/blog/a-dart-repl-poc) (você não precisa lê-lo para aproveitar este), e muitos recursos ainda estão faltando. Em particular, imports dinâmicos e suporte a declarações de nível superior seriam muito úteis, então vamos ver como dar suporte a eles.

*Aviso: eu trabalho no Google, mas este post é sobre um projeto pessoal. Não faço parte da equipe do Dart nem tenho relação com ela. Este artigo contém apenas a minha humilde opinião pessoal.*

**Resumo**: o código e as instruções para rodar o REPL do Dart estão em [https://github.com/BlackHC/dart_repl](https://github.com/BlackHC/dart_repl).

<DashImage src="images/0pmcEIyli_y3CLPCi.webp" alt="Deadpool meme with the text 'Lets get this party started'." />


## Hot reload {:#hot-reload}

Para o [Flutter](https://flutter.io/), um recurso novo e legal foi adicionado à VM do Dart: o [**hot reload**](https://github.com/flutter/flutter/wiki/Hot-Reload). Há um vídeo divertido no YouTube, da Dart DevSummit, que explica e mostra o recurso em detalhes:

<YoutubeEmbed id="iPlPk43RbpA" title="Flutter Hot Reload (Dart Developer Summit 2016)" fullwidth="true"/>


O hot reload permite alterar seu código enquanto o programa está rodando. A VM do Dart percebe as mudanças que você fez e tenta aplicá-las mantendo tudo em execução. E, se não conseguir, ela diz por quê. Isso é muito legal! No espírito de hackear o Dart para fazer coisas incríveis, vamos pensar em como podemos usar isso para implementar os novos recursos.

### Por que não conseguimos importar novas bibliotecas na versão atual do REPL? {:#why-cant-we-import-new-libraries-in-the-current-version-of-the-repl}

O REPL usa o serviço de VM do Dart para avaliar expressões. Infelizmente, importar uma biblioteca não é uma expressão em Dart, então não podemos simplesmente avaliá-la nesse contexto. No entanto, podemos alterar o código do sandbox do REPL enquanto ele está rodando para importar uma nova biblioteca, e depois disparar um hot reload para atualizar o REPL. Será que funciona? Funciona, sim \o/

<DashImage src="images/13Zj7w3g1jNI_SXtkvM8-Lg.webp" alt="An animated terminal showing the Dart REPL executing code with runtime imports." caption="Dart REPL with runtime imports" />


Mas espere: outra coisa que não conseguimos fazer avaliando expressões pelo serviço de VM é criar novas classes e funções. Na verdade, nenhuma das declarações de nível superior do Dart pode ser executada avaliando uma expressão, por esse motivo.

## Como podemos permitir declarações de nível superior? {:#how-can-we-allow-top-level-declarations}

Claro, poderíamos usar a mesma ideia descrita acima para também adicionar uma nova classe ou uma função global. No entanto, quem usa o IPython ou algo parecido há algum tempo sabe que você costuma redeclarar a mesma classe ou função com frequência enquanto itera sobre o código. Você executa de novo versões levemente modificadas do mesmo código, várias e várias vezes, enquanto experimenta.

Se simplesmente adicionássemos essas declarações à nossa biblioteca Dart de sandbox, seríamos obrigados a controlar o que foi declarado, quando e onde no arquivo, para atualizar a declaração quando você iterasse sobre ela. Isso exige muita lógica e código esperto. Infelizmente, também quebraria facilmente se uma mudança em uma classe quebrasse a compatibilidade com código antigo ou com outras declarações. Isso impediria o REPL de fazer hot reload e forçaria o usuário a reiniciá-lo :( Isso soa complexo e frágil: não é uma combinação vencedora, eu acho!

<DashImage src="images/0JRC_8ZBdApr8CNWF.webp" alt="Meme text asking, 'Why you have to go and make things so complicated?'" />


### Spike e cadeias {:#spike-chains}

E se, em vez disso, pudéssemos redefinir a mesma declaração de nível superior várias vezes sem que as redeclarações jamais colidissem? Isso é sequer possível em Dart? Pode apostar que é! Mas não dentro da mesma biblioteca :) O Dart permite importar uma biblioteca e depois declarar uma classe, função ou variável global que faz sombra (shadow) em uma declaração existente.

```dart
class MyClass {
  static final value = 1;
}
```

```dart
import ‘a.dart’;

class MyClass {
  static final value = 10;
}
```

Neste exemplo, não haverá reclamações sobre o `MyClass` de `b.dart` fazer sombra à versão de `a.dart`, porque elas existem em bibliotecas diferentes e a declaração local em `b.dart` tem precedência sobre a importada de `a.dart`.

Em geral, sombreamento (shadowing) é o que acontece quando você declara uma variável que oculta outra variável de um escopo externo. Por exemplo:

```dart
float a;

void func() {
  float a;  // This `a` shadows global `a`.
}
```

Podemos usar isso? Para investigar, implementei um spike rápido [aqui](https://github.com/BlackHC/dart_repl/tree/master/spikes/import_spike). Ele não gera nenhum código. Na verdade, é um exemplo bem simples para garantir que o que achamos que vai funcionar realmente funciona. Seria frustrante gastar muito tempo implementando isso com geração de código só para descobrir que nunca poderia ter funcionado! A essência é esta:

```dart
class A {
  int f() => 1;
}
```

```dart
import 'import_1.dart';
export 'import_1.dart';

class A {
  int f() => 2;
}
```

```dart
import 'import_2.dart';

void main() {
  result = new A().f();
  print(result);
}
```

Isso funciona mesmo! Podemos criar uma cadeia de bibliotecas que importam umas às outras (e também exportam umas às outras, porque senão os símbolos não ficam disponíveis em todo lugar). Assim, os usuários podem redefinir símbolos quantas vezes quiserem. Obviamente, isso pode fazer código antigo referenciar símbolos sombreados, o que pode deixar as coisas um pouco confusas, mas pelo menos não vai quebrar. E quem usa o IPython ou algo parecido aprendeu a conviver com isso também. Não pode ser tão ruim assim.

<DashImage src="images/1jjpANyPKXUIge1JcUA3WSQ.webp" alt="A diagram showing how top-level declarations are shadowed across multiple Dart libraries." />


O diagrama acima mostra como funciona: conforme adicionamos novas declarações de nível superior, são criadas novas “células” (bibliotecas Dart) que importam (e exportam) a célula anterior. A célula final é importada na biblioteca de sandbox, usada como ambiente de execução para expressões e instruções Dart comuns. O arquivo do sandbox é editado no lugar e depois recarregado com hot reload.

### Uma visão de fluxo de trabalho {:#a-workflow-vision}

Além disso, se você quiser atualizar o código continuamente sem sombrear nada, isso também é possível: o hot reload já permite esse fluxo de trabalho em programas Dart normais. Você pode fazer o mesmo no REPL. Pode editar sua incrível biblioteca Dart `amazing_dart_library.dart`, importá-la no REPL, experimentar com ela e, enquanto isso, editar o código no seu editor favorito e fazer o REPL recarregar o código quando quiser, chamando `reload()`. O melhor dos dois mundos \o/

## Como podemos implementar isso na prática? {:#how-can-we-implement-this-in-practice}

<DashImage src="images/0lKzRhG-9uyW5eLvq.webp" alt="Philosoraptor meme asking, 'What if this topic is too complex to be represented in a single meme?'" />


Bem, estamos hackeando o Dart aqui, então vamos lá: o hot reload ainda não é suportado pelo [`vm_service_client`](https://pub.dartlang.org/packages/vm_service_client), já que é um recurso muito novo e a [especificação do serviço](https://github.com/dart-lang/sdk/blob/master/runtime/vm/service/service.md) ainda não está totalmente completa. Comecei a escrever [um pull request](https://github.com/dart-lang/vm_service_client/pull/14) para a Natalie (a mantenedora) adicionar esse suporte, mas, como meus colegas sabem, código de qualidade de produção não é a minha praia, principalmente no meu tempo livre (desculpa, Natalie!). Porém, isso não bloqueia nossa aventura de hacking.

O [pub](https://pub.dartlang.org/), o sistema de gerenciamento de pacotes do Dart, não só oferece resolução automática de restrições de versão e um repositório centralizado de pacotes, como também permite [usar pacotes locais ou depender diretamente do GitHub](https://www.dartlang.org/tools/pub/dependencies) . Isso geralmente não é recomendado, porque você perde grande parte do que torna o pub ótimo, mas aqui funciona: simplesmente fiz um fork do `vm_service_client` no meu clone do GitHub e fiz as mudanças necessárias. Você pode encontrar o código em [https://github.com/BlackHC/vm_service_client/tree/reload_sources_poc](https://github.com/BlackHC/vm_service_client/tree/reload_sources_poc). Depois, alterei o `pubspec.yaml` do REPL do Dart para apontar para o meu clone do GitHub em vez da versão oficial:

```yaml
[...]
  vm_service_client:
    git:
      url: git://github.com/BlackHC/vm_service_client.git
      ref: reload_sources_poc
[...]
```

E é isso! Um simples `pub get` no terminal agora atualiza o REPL do Dart para usar a versão com o fork.

Isso torna muito fácil experimentar qualquer coisa: você pode fazer fork de outros pacotes para testar ideias e depender deles com facilidade. E o legal é que posso publicar isso, e quando você baixar o REPL para usar com o pub, ele também vai buscar o código no GitHub. Muito hackeável, e ainda assim compartilhável! (Mesmo que não seja recomendado para pacotes de produção em geral :)

A parte mais interessante da lógica é o gerador de células, que implementa um mecanismo de templates bem simples, alinhado ao que discutimos acima:

```dart
import 'dart:io';

class DartTemplate {
  final String content;

  DartTemplate(this.content);

  void instantiate(String targetPath,
      {String source, String library, String imports}) {
    final instanceSource = content
        .replaceAll('/*{SOURCE}*/', source ?? '')
        .replaceAll('/*{IMPORTS}*/', imports ?? '')
        .replaceAll('/*{LIBRARY}*/', library ?? '');
    new File(targetPath).writeAsStringSync(instanceSource);
    //print('wrote $targetPath:\n$instanceSource');
  }
}

/// Keeps a chain of temporary cell files that import and re-export each other.
/// This allows us to create top-level cells that contains classes and other
/// top-level decls that can shadow each other.
class TopLevelCellChain {
  final DartTemplate cellTemplate;
  final String headName;
  final String basePath;

  int _currentCellIndex = 0;

  TopLevelCellChain(this.cellTemplate, this.headName, this.basePath);

  String get currentCellPath => '$basePath/$currentCellName';
  String get currentCellName => 'cell${_currentCellIndex}.dart';
  String get headPath => '$basePath/$headName';

  void addCell(String source) {
    // Import and export the previous cell.
    final imports = _currentCellIndex > 0
        ? '''
// Import the previous cell and export it to make its symbols available to the
// next cell.
import '$currentCellName';
export '$currentCellName';
'''
        : '';

    _currentCellIndex++;
    cellTemplate.instantiate(currentCellPath, imports: imports, source: source);

    // Update the sandbox.
    refreshSandboxLibrary();
  }

  void refreshSandboxLibrary() {
    var libraryStatement = '''
/// This library name is needed to find the library using reflection.
library sandbox;
''';

    cellTemplate.instantiate(headPath,
        imports: _currentCellIndex > 0 ? 'import \'$currentCellName\';' : '',
        library: libraryStatement);
  }

  void undoCell() {
    if (_currentCellIndex > 0) {
      _currentCellIndex--;
    }
    refreshSandboxLibrary();
  }
}
```

O recurso de hot reload é chamado pelo REPL quando um novo import é necessário:

```dart
Future linkAndExecuteCell(SandboxIsolate sandboxIsolate, String input,
    VMRunnableIsolate runnableIsolate) async {
  sandboxIsolate.cellChain.addCell(input);
  final report = await runnableIsolate.reloadSources();
  if (!report.status) {
    print(report.message);
    // Undo the last cell, so we can try again.
    sandboxIsolate.cellChain.undoCell();
  }
}
```

E é basicamente isso! Você pode dar uma olhada em todas as mudanças no pull request: [https://github.com/BlackHC/dart_repl/pull/2](https://github.com/BlackHC/dart_repl/pull/2).
Admito que o código está um pouco hacky e desorganizado. Também há bastante código de wrapper não relacionado, para passagem de mensagens entre o REPL e o sandbox, no pull request. Isso, infelizmente, ofusca um pouco as mudanças principais. Preciso ver como refatorar tudo isso para deixar mais limpo e organizado… mas às vezes é mais fácil fazer as coisas funcionarem rápido do que escrever o melhor código e os melhores pull requests. Desculpe por isso!

<DashImage src="images/1lR3fQGmW9Bjxtcxy-mJsjg.webp" alt="An animated terminal demonstrating the Dart REPL with top-level declarations." caption="Dart REPL with top-level declarations" />


O código-fonte do REPL do Dart pode ser encontrado em [https://github.com/BlackHC/dart_repl](https://github.com/BlackHC/dart_repl). Além de dar suporte a declarações de nível superior, também adicionei suporte aos comandos embutidos `import`, `loadPackage` e `reload`. (Atenção: `loadPackage` exige os builds de desenvolvimento 1.24 do SDK do Dart, que ainda serão lançados. Sem eles, é um no-op.) Esses comandos embutidos são extensões triviais que usam o hot reload. Por fim, para carregar novos pacotes do seu cache local do pub, estou usando o excelente pacote [`pub_cache`](https://github.com/dart-lang/pub_cache).

Para testar (supondo que você tenha instalado o SDK do Dart), basta rodar:

```
pub global activate dart_repl
pub global run dart_repl
```


Obrigado por chegar até o fim deste artigo! Me conte o que você achou :)

Abraços,
Andreas
