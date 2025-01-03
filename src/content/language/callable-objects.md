---
ia-translate: true
title: Objetos Chamáveis
description: Aprenda como criar e usar objetos chamáveis em Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
toc: false
prevpage:
  url: /language/extension-types
  title: Tipos de extensão
nextpage:
  url: /language/class-modifiers
  title: Modificadores de classe
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>

Para permitir que uma instância de sua classe Dart seja chamada como uma função,
implemente o método `call()`.

O método `call()` permite que uma instância de qualquer classe que o defina emule uma função.
Este método oferece a mesma funcionalidade que [funções][] normais,
como parâmetros e tipos de retorno.

No exemplo a seguir, a classe `WannabeFunction` define uma função `call()`
que recebe três strings e as concatena, separando cada uma com um espaço,
e adicionando uma exclamação. Clique em **Executar** para executar o código.

<?code-excerpt "misc/lib/language_tour/callable_objects.dart"?>
```dartpad
class WannabeFunction {
  String call(String a, String b, String c) => '$a $b $c!';
}

var wf = WannabeFunction();
var out = wf('Oi', 'aí,', 'pessoal');

void main() => print(out);
```

[functions]: /language/functions
