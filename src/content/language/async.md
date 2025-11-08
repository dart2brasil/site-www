---
ia-translate: true
title: Programação assíncrona
description: Informações sobre como escrever código assíncrono em Dart.
shortTitle: Programação async
prevpage:
  url: /language/concurrency
  title: Concurrency
nextpage:
  url: /language/isolates
  title: Isolates
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

As bibliotecas Dart são repletas de funções que
retornam objetos [`Future`][] ou [`Stream`][].
Essas funções são _assíncronas_:
elas retornam após configurar
uma operação possivelmente demorada
(como I/O),
sem aguardar a conclusão dessa operação.

As keywords `async` e `await` suportam programação assíncrona,
permitindo que você escreva código assíncrono que
se parece com código síncrono.


## Lidando com Futures

Quando você precisa do resultado de um Future concluído,
você tem duas opções:

* Use `async` e `await`, conforme descrito aqui e no
  [tutorial de programação assíncrona](/libraries/async/async-await).
* Use a API Future, conforme descrito na
  [documentação `dart:async`](/libraries/dart-async#future).

O código que usa `async` e `await` é assíncrono,
mas parece muito com código síncrono.
Por exemplo, aqui está algum código que usa `await`
para aguardar o resultado de uma função assíncrona:

<?code-excerpt "misc/lib/language_tour/async.dart (await-look-up-version)"?>
```dart
await lookUpVersion();
```

Para usar `await`, o código deve estar em uma função `async`—uma
função marcada como `async`:

<?code-excerpt "misc/lib/language_tour/async.dart (checkVersion)" replace="/async|await/[!$&!]/g"?>
```dart
Future<void> checkVersion() [!async!] {
  var version = [!await!] lookUpVersion();
  // Do something with version
}
```

:::note
Embora uma função `async` possa realizar operações demoradas,
ela não aguarda essas operações.
Em vez disso, a função `async` executa apenas
até encontrar sua primeira expressão `await`.
Em seguida, ela retorna um objeto `Future`,
retomando a execução apenas após a conclusão da expressão `await`.
:::

Use `try`, `catch` e `finally` para lidar com erros e limpeza
em código que usa `await`:

<?code-excerpt "misc/lib/language_tour/async.dart (try-catch)"?>
```dart
try {
  version = await lookUpVersion();
} catch (e) {
  // React to inability to look up the version
}
```

Você pode usar `await` várias vezes em uma função `async`.
Por exemplo, o código a seguir aguarda três vezes
pelos resultados de funções:

<?code-excerpt "misc/lib/language_tour/async.dart (repeated-await)"?>
```dart
var entrypoint = await findEntryPoint();
var exitCode = await runExecutable(entrypoint, args);
await flushThenExit(exitCode);
```

Em <code>await <em>expression</em></code>,
o valor de <code><em>expression</em></code> geralmente é um Future;
se não for, então o valor é automaticamente encapsulado em um Future.
Este objeto Future indica uma promessa de retornar um objeto.
O valor de <code>await <em>expression</em></code> é esse objeto retornado.
A expressão await faz a execução pausar até que esse objeto esteja disponível.

**Se você receber um erro de compilação ao usar `await`,
certifique-se de que `await` está em uma função `async`.**
Por exemplo, para usar `await` na função `main()` do seu aplicativo,
o corpo de `main()` deve ser marcado como `async`:

<?code-excerpt "misc/lib/language_tour/async.dart (main)" replace="/async|await/[!$&!]/g"?>
```dart
void main() [!async!] {
  checkVersion();
  print('In main: version is ${[!await!] lookUpVersion()}');
}
```

:::note
O exemplo anterior usa uma função `async` (`checkVersion()`)
sem aguardar um resultado—uma prática que pode causar problemas
se o código assume que a função terminou de executar.
Para evitar esse problema,
use a [regra do linter unawaited_futures][unawaited_futures linter rule].
:::

Para uma introdução interativa ao uso de futures, `async` e `await`,
veja o [tutorial de programação assíncrona](/libraries/async/async-await).


## Declarando funções async

Uma função `async` é uma função cujo corpo é marcado com
o modificador `async`.

Adicionar a keyword `async` a uma função faz com que ela retorne um Future.
Por exemplo, considere esta função síncrona,
que retorna uma String:

<?code-excerpt "misc/lib/language_tour/async.dart (sync-look-up-version)"?>
```dart
String lookUpVersion() => '1.0.0';
```

Se você mudá-la para ser uma função `async`—por exemplo,
porque uma implementação futura será demorada—o
valor retornado é um Future:

<?code-excerpt "misc/lib/language_tour/async.dart (async-look-up-version)"?>
```dart
Future<String> lookUpVersion() async => '1.0.0';
```

Observe que o corpo da função não precisa usar a API Future.
Dart cria o objeto Future se necessário.
Se sua função não retorna um valor útil,
torne seu tipo de retorno `Future<void>`.

Para uma introdução interativa ao uso de futures, `async` e `await`,
veja o [tutorial de programação assíncrona](/libraries/async/async-await).

{% comment %}
TODO #1117: Where else should we cover generalized void?
{% endcomment %}


## Lidando com Streams

Quando você precisa obter valores de um Stream,
você tem duas opções:

* Use `async` e um _loop for assíncrono_ (`await for`).
* Use a API Stream, conforme descrito na
  [documentação `dart:async`](/libraries/dart-async#stream).

:::note
Antes de usar `await for`, certifique-se de que isso torna o código mais claro e que você
realmente deseja aguardar todos os resultados do stream. Por exemplo, você
geralmente **não** deve usar `await for` para listeners de eventos de UI, porque frameworks de UI
enviam fluxos infinitos de eventos.
:::

Um loop for assíncrono tem a seguinte forma:

<?code-excerpt "misc/lib/language_tour/async.dart (await-for)"?>
```dart
await for (varOrType identifier in expression) {
  // Executes each time the stream emits a value.
}
```

O valor de <code><em>expression</em></code> deve ter tipo Stream.
A execução procede da seguinte forma:

1. Aguarde até que o stream emita um valor.
2. Execute o corpo do loop for,
   com a variável definida para esse valor emitido.
3. Repita 1 e 2 até que o stream seja fechado.

Para parar de escutar o stream,
você pode usar uma instrução `break` ou `return`,
que sai do loop for
e cancela a inscrição no stream.

**Se você receber um erro de compilação ao implementar um loop for assíncrono,
certifique-se de que o `await for` está em uma função `async`.**
Por exemplo, para usar um loop for assíncrono na função `main()` do seu aplicativo,
o corpo de `main()` deve ser marcado como `async`:

<?code-excerpt "misc/lib/language_tour/async.dart (number-thinker)" replace="/async|await for/[!$&!]/g"?>
```dart
void main() [!async!] {
  // ...
  [!await for!] (final request in requestServer) {
    handleRequest(request);
  }
  // ...
}
```

Para mais informações sobre o suporte de programação assíncrona do Dart,
consulte a documentação da biblioteca [`dart:async`](/libraries/dart-async).

[`Future`]: {{site.dart-api}}/dart-async/Future-class.html
[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html
[unawaited_futures linter rule]: /tools/linter-rules/unawaited_futures
