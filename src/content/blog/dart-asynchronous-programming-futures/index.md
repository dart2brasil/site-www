---
ia-translate: true
title: "Programação assíncrona em Dart: Futures"
description: "Uma das APIs mais básicas que o Dart tem para programação assíncrona são os futures, objetos do tipo Future. Na maior parte, os futures do Dart são…"
publishDate: 2019-09-18
author: kwalrath
image: images/1UD63BMoIBmzoA6jo3LjCCg.webp
category: deep-dive
layout: blog
---


<DashImage src="images/1G4044qvxp8yBjmGVHVLEyw.webp" alt="Código Dart armazena o resultado de http.get('http://example.com') em myFuture." caption="Muitas APIs assíncronas do Dart retornam futures." />


Uma das APIs mais básicas que o Dart tem para programação assíncrona são os *futures —* objetos do tipo [`Future`](https://api.dartlang.org/stable/dart-async/Future-class.html). Na maior parte, os futures do Dart são muito parecidos com as APIs de *future* ou *promise* encontradas em outras linguagens.

Este artigo discute os conceitos por trás dos futures do Dart e mostra como usar a API `Future`. Ele também fala sobre o widget `FutureBuilder` do Flutter, que ajuda a atualizar uma UI do Flutter de forma assíncrona, com base no estado de um future.

Graças a recursos da linguagem Dart, como [async-await](https://dart.dev/codelabs/async-await), você talvez nunca precise usar a API `Future` diretamente. Mas é quase certo que você vai encontrar futures no seu código Dart. E você pode querer *criar* futures ou *ler* código que usa a API `Future`.
> Este artigo é o segundo baseado na série de vídeos *Flutter in Focus* chamada *Asynchronous Programming in Dart*. O primeiro artigo, [Isolates e event loops](/blog/dart-asynchronous-programming-isolates-and-event-loops), tratou dos fundamentos do suporte do Dart a trabalho em segundo plano.
> Se você prefere aprender assistindo ou ouvindo, tudo o que este artigo cobre está no vídeo a seguir*.*

<YoutubeEmbed id="OTS-ap9_aXc" title="Dart Futures - Flutter in Focus" fullwidth="true"/>


Você pode pensar nos futures como pequenas caixas de presente com dados. Alguém entrega uma dessas caixas para você, e ela começa fechada. Um pouco depois, a caixa se abre, e dentro dela há um valor ou um erro.

Então, um future pode estar em um de 3 estados:

1. **Incompleto:** a caixa de presente está fechada*.*

1. **Concluído com um valor:** a caixa está aberta, e o seu presente (dados) está pronto.

1. **Concluído com um erro:** a caixa está aberta, mas algo deu errado.

A maior parte do código que você verá a seguir gira em torno de lidar com esses três estados. Você recebe um future e precisa decidir o que fazer até a caixa abrir, o que fazer quando ela abrir com um valor e o que fazer se houver um erro. Você vai ver muito esse padrão 1–2–3.

<DashImage src="images/1UD63BMoIBmzoA6jo3LjCCg.webp" alt="Fluxograma com Incompleto ramificando para Concluído com dados e Concluído com erro." caption="Os 3 estados de um future" />


Você pode se lembrar do event loop (ilustrado abaixo) do nosso [artigo sobre o event loop do Dart](/blog/dart-asynchronous-programming-isolates-and-event-loops). Uma coisa boa de saber sobre os futures é que eles são, na prática, apenas uma API criada para facilitar o uso do event loop.

<DashImage src="images/0xlxALlxjazVifRep.webp" alt="Eventos na fila avançando em direção a uma engrenagem com setas circulares representando o event loop do Dart." caption="O event loop do Dart processa um evento por vez." />


O código Dart que você escreve é executado por uma única thread. Durante todo o tempo em que o seu app está rodando, essa pequena thread fica dando voltas sem parar, pegando eventos da fila de eventos e processando-os.

Digamos que você tenha um código para um botão de download (implementado abaixo como um `RaisedButton`). O usuário toca, e o seu botão começa a baixar uma imagem.

```dart
RaisedButton(
  onPressed: () {
    final myFuture = http.get('https://my.image.url');
    myFuture.then((resp) {
      setImage(resp);
    });
  },
  child: Text('Click me!'),
)
```

Primeiro, ocorre o evento de toque. O event loop recebe o evento e chama o seu handler de toque (que você definiu usando o parâmetro `onPressed` do construtor de `RaisedButton`). O seu handler usa a biblioteca http para fazer uma requisição (`http.get()`) e recebe um future em troca (`myFuture`).

Então agora você tem a sua caixinha, `myFuture`. Ela começa fechada. Para registrar um callback para quando ela abrir, você usa `then()`.

Depois de ter a sua caixa de presente, você espera. Talvez outros eventos cheguem, o usuário faça outras coisas, e a sua caixinha simplesmente fica ali enquanto o event loop continua girando.

Eventualmente, os dados da imagem são baixados, e a biblioteca http diz: “Ótimo! Eu tenho este future bem aqui.” Ela coloca os dados na caixa e a abre, o que dispara o seu callback.

Agora, aquele pedacinho de código que você passou para `then()` é executado, e ele exibe a imagem.

Durante todo esse processo, o seu código nunca precisou tocar diretamente no event loop. Não importava o que mais estava acontecendo, nem quais outros eventos chegavam. Tudo o que você precisava fazer era obter o future da biblioteca http e, depois, dizer o que fazer quando o future fosse concluído.

Em código real, você também cuidaria dos erros. Vamos mostrar como fazer isso um pouco mais adiante.

Vamos dar uma olhada mais de perto na API `Future`, parte da qual você acabou de ver em uso.

Ok, primeira pergunta: como você obtém uma instância de `Future`? Na maioria das vezes, você não cria futures diretamente. Isso porque muitas das tarefas comuns de programação assíncrona já têm bibliotecas que geram futures para você.

Por exemplo, a comunicação de rede retorna um future:

```
final myFuture = http.get('http://example.com');
```


Acessar as preferências compartilhadas também retorna um future:

```
final myFuture = SharedPreferences.getInstance();
```


Mas você também pode usar construtores de `Future` para criar futures.

## Construtores de Future {:#future-constructors}

O construtor mais simples é o [`Future()`](https://api.dartlang.org/stable/dart-async/Future/Future.html), que recebe uma função e retorna um future que corresponde ao tipo de retorno da função. Depois, a função é executada de forma assíncrona, e o future é concluído com o valor de retorno da função. Aqui está um exemplo de uso de `Future()`:

```dart
void main() {
  final myFuture = Future(() {
    return 12;
  });
}
```

Vamos adicionar alguns comandos print para deixar a parte assíncrona clara:

```dart
void main() {
  final myFuture = Future(() {
    print('Creating the future.'); // Prints second.
    return 12;
  });
  print('Done with main().'); // Prints first.
}
```

Se você executar esse código no DartPad ([dartpad.dev](https://dartpad.dev)), toda a função `main` termina antes da função passada para o construtor `Future()`. Isso acontece porque o construtor `Future()` apenas retorna, no início, um future incompleto. Ele diz: “Aqui está esta caixa. Segure-a por enquanto, e depois eu vou executar a sua função e colocar alguns dados dentro dela para você.” Esta é a saída do código anterior:

```
Done with main().
Creating the future.
```


Outro construtor, [`Future.value()`](https://api.dartlang.org/stable/dart-async/Future/Future.value.html), é útil quando você já conhece o valor do future. Esse construtor é útil quando você está criando serviços que usam cache. Às vezes você já tem o valor de que precisa, então pode colocá-lo ali diretamente:

```
final myFuture = Future.value(12);
```


O construtor `Future.value()` tem um equivalente para concluir com um erro. Ele se chama [`Future.error()`](https://api.dartlang.org/stable/dart-async/Future/Future.error.html), funciona essencialmente da mesma forma, mas recebe um objeto de erro e um stacktrace opcional:

```
final myFuture = Future.error(ArgumentError.notNull('input'));
```


O construtor de future mais prático é provavelmente o [`Future.delayed()`](https://api.dartlang.org/stable/dart-async/Future/Future.delayed.html). Ele funciona como o `Future()`, exceto que espera um tempo especificado antes de executar a função e concluir o future.

Uma forma de usar `Future.delayed()` é ao criar serviços de rede simulados para testes. Se você precisa garantir que o seu spinner de carregamento seja exibido corretamente, um future com atraso é um ótimo aliado.

```dart
final myFuture = Future.delayed(
  const Duration(seconds: 5),
  () => 12,
);
```

## Usando futures {:#using-futures}

Agora que você sabe de onde vêm os futures, vamos falar sobre como usá-los. Como mencionamos antes, usar um future é principalmente lidar com os três estados em que ele pode estar: incompleto, concluído com um valor ou concluído com um erro.

O código a seguir usa `Future.delayed()` para criar um future que é concluído após 3 segundos com o valor 100.

```dart
void main() {
  Future.delayed(
    const Duration(seconds: 3),
    () => 100,
  );
  print('Waiting for a value...');
}
```

Quando esse código é executado, `main()` roda de cima para baixo, criando o future e imprimindo “Waiting for a value…”. Durante todo esse tempo, o future está incompleto. Ele só será concluído daqui a 3 segundos.

Para *usar* o valor concluído, você pode usar o [`then()`](https://api.dartlang.org/stable/dart-async/Future/then.html). Esse é um método de instância de cada future, que você pode usar para registrar um callback para quando o future for concluído com um valor. Você passa uma função que recebe um único parâmetro do mesmo tipo do future. Assim que o future for concluído com um valor, a sua função é chamada com esse valor.

```dart
void main() {
  Future.delayed(
    const Duration(seconds: 3),
    () => 100,
  ).then((value) {
    print('The value is $value.'); // Prints later, after 3 seconds.
  });
  print('Waiting for a value...'); // Prints first.
}
```

Esta é a saída do código anterior:

```
Waiting for a value... *(3 seconds pass until callback executes)*
The value is 100.
```


Além de executar o seu código, o `then()` retorna um future próprio, que corresponde ao valor de retorno da função que você passou. Então, se você precisar fazer algumas chamadas assíncronas, pode encadeá-las, mesmo que tenham tipos de retorno diferentes.

```dart
_fetchNameForId(12)
    .then((name) => _fetchCountForName(name))
    .then((count) => print('The count is $count.'));
```

Voltando ao nosso primeiro exemplo: o que acontece se esse future inicial não for concluído com um valor, e sim com um erro? O método `then()` espera um valor. Você precisa de uma forma de registrar outro callback para o caso de erro.

A resposta é usar o [`catchError()`](https://api.dartlang.org/stable/dart-async/Future/catchError.html). Ele funciona como o `then()`, exceto que recebe um erro em vez de um valor, e é executado se o future for concluído com um erro. Assim como o `then()`, o método `catchError()` retorna um future próprio, então você pode montar uma cadeia inteira de métodos `then()` e `catchError()` que esperam uns pelos outros.
> **Observação:** você não precisa chamar `then()` ou `catchError()` se usar o recurso de linguagem async-await. Em vez disso, você espera (await) o valor concluído e usa try-catch-finally para tratar erros. Para detalhes, veja a seção [suporte a assincronia](https://dart.dev/guides/language/language-tour#asynchrony-support) do tour pela linguagem Dart.

Aqui está um exemplo de uso de `catchError()` para tratar o caso em que um future é concluído com um erro:

```dart
void main() {
  Future.delayed(
    Duration(seconds: 3),
    () => throw 'Error!', // Complete with an error.
  ).then((value) {
    print(value);
  }).catchError((err) {
    print('Caught $err'); // Handle the error.
  });
  print('Waiting for a value...');
}
```

Você pode até passar para o `catchError()` uma função de teste, para verificar o erro antes de invocar o callback. Assim, você pode ter várias funções `catchError()`, cada uma verificando um tipo diferente de erro. Aqui está um exemplo de como especificar uma função de teste, usando o parâmetro opcional `test` do `catchError()`:

```dart
void main() {
  Future.delayed(
    Duration(seconds: 3),
    () => throw 'Error!',
  ).then((value) {
    print(value);
  }).catchError((err) {
    print('Caught $err');
  }, test: (err) { // Optional test parameter.
    return err is String;
  });
  print('Waiting for a value...');
}
```

Agora que você chegou até aqui, espero que possa perceber como os três estados de um future costumam se refletir na estrutura do código. Há três blocos no exemplo anterior:

1. O primeiro bloco cria um future incompleto.

1. Depois, há uma função a ser chamada se o future for concluído com um valor.

1. Em seguida, há outra função a ser chamada se o future for concluído com um erro.

Há mais um método que você pode querer usar: o [`whenComplete()`](https://api.dartlang.org/stable/dart-async/Future/whenComplete.html). Você pode usá-lo para executar uma função quando o future for concluído, não importa se com um valor ou com um erro.

É meio como o bloco *finally* de um try-catch-finally. Há código executado se tudo der certo, código para um erro e código que roda independentemente do que aconteça.

## Usando futures no Flutter {:#using-futures-in-flutter}

Então, é assim que você cria futures, e um pouco sobre como usar os valores deles. Agora vamos falar sobre como colocá-los para trabalhar no Flutter.

Digamos que você tenha um serviço de rede que vai retornar alguns dados JSON, e você quer exibir esses dados. Você poderia criar um [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) que cria o future, verifica se foi concluído ou se houve erro, chama `setState()` e, de modo geral, faz toda a ligação manualmente.

Ou você pode usar o [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html). É um widget que vem com o SDK do Flutter. Você passa para ele um future e uma função builder, e ele reconstrói automaticamente os seus filhos quando o future for concluído.

O widget `FutureBuilder` funciona chamando a sua função builder, que recebe um context e um snapshot do estado atual do future.

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder.
    return FutureBuilder<String>(
      future: _fetchNetworkData(),
      builder: (context, snapshot) {},
    );
  }
}
```

Você pode verificar o snapshot para ver se o future foi concluído com um erro:

```dart
    return FutureBuilder<String>(
      future: _fetchNetworkData(5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Future completed with an error.
          return Text(
            'There was an error',
          );
        }
        throw UnimplementedError("Case not handled yet");
      },
    );
```

Caso contrário, você pode verificar a propriedade `hasData` para ver se ele foi concluído com um valor:

```dart
    return FutureBuilder<String>(
      future: _fetchNetworkData(5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Future completed with an error.
          return Text(
            'There was an error',
          );
        } else if (snapshot.hasData) {
          // Future completed with a value.
          return Text(
            json.decode(snapshot.data)['field'],
          );
        }
        throw UnimplementedError("Case not handled yet");
      },
    );
```

Se nem `hasError` nem `hasData` forem verdadeiros, você sabe que ainda está esperando, e pode exibir algo para esse caso também.

```dart
    return FutureBuilder<String>(
      future: _fetchNetworkData(5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Future completed with an error.
          return Text(
            'There was an error',
          );
        } else if (snapshot.hasData) {
          // Future completed with a value.
          return Text(
            json.decode(snapshot.data)['field'],
          );
        } else {
          // Uncompleted.
          return Text(
            'No value yet!',
          );
        }
      },
    );
```

Mesmo no código Flutter, dá para ver como esses três estados continuam aparecendo: incompleto, concluído com valor e concluído com erro.

## Resumo {:#summary}

Este artigo falou sobre o que os futures representam e como você pode usar as APIs `Future` e `FutureBuilder` para criar futures e usar os valores concluídos.

Se você quiser aprender mais sobre o uso de futures, com a opção de exemplos executáveis e exercícios interativos para testar o seu entendimento, confira o codelab de programação assíncrona sobre [futures, async e await](https://dart.dev/codelabs/async-await).

Ou siga para o próximo vídeo da série *Asynchronous Programming in Dart*. Ele fala sobre *streams*, que são muito parecidos com os futures, pois também podem fornecer valores ou erros. Mas, enquanto os futures entregam apenas um resultado e param, os streams continuam sem parar.

<YoutubeEmbed id="nQBpOIHE4eE" title="Dart Streams - Flutter in Focus" fullwidth="true"/>


*Muito obrigado a Andrew Brogdon, que criou o vídeo no qual este artigo é baseado.*
