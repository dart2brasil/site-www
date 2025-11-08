---
ia-translate: true
title: 'Interoperabilidade Java usando package:jnigen'
shortTitle: Java interop
breadcrumb: Java
description: >-
  Para usar Java no seu programa Dart, use package:jnigen.
example: 'https://github.com/HosseinYousefi/jnigen_example/tree/main'
---

Aplicações Dart mobile, de linha de comando e servidor
executando na [plataforma Dart Native](/overview#platform), no
Android, Windows, macOS, e Linux podem usar [`package:jni`][jni-pkg]
e [`package:jnigen`][jnigen-pkg]
para chamar APIs Java e Kotlin.

:::note
Esta funcionalidade de interop é **experimental**,
e está [em desenvolvimento ativo]({{site.repo.dart.sdk}}/issues/49674).
:::

`package:jni` permite que código Dart interaja
com Java através de [JNI][jnidoc].
No entanto, fazer isso envolve muito código boilerplate,
então você pode usar `package:jnigen` para gerar automaticamente
os bindings Dart para uma determinada API Java.

Você pode compilar Kotlin para bytecode Java, permitindo que `package:jnigen`
gere bindings para Kotlin também.

[jni-pkg]: {{site.pub-pkg}}/jni
[jnigen-pkg]: {{site.pub-pkg}}/jnigen
[jnidoc]: https://docs.oracle.com/en/java/javase/17/docs/specs/jni/index.html

## Exemplo simples de Java

Este guia o orienta através de [um exemplo]({{page.example}})
que usa `package:jnigen` para gerar bindings para uma classe simples.

### Pré-requisitos

- JDK

### Configurar `jnigen`

Primeiro, adicione `package:jni` como uma dependência e
`package:jnigen` como uma [dev dependency][].

```console
$ dart pub add jni dev:jnigen
```

Em seguida, crie um arquivo de nível superior chamado `jnigen.yaml`.
Este arquivo contém a configuração para gerar os bindings.

```yaml
output:
  dart:
    path: lib/example.dart
    structure: single_file

source_path:
  - 'java/'
classes:
  - 'dev.dart.Example'
```

`path` especifica o caminho para os bindings `dart` gerados.

`source_path` especifica o caminho do arquivo fonte Java para o qual
você deseja gerar bindings,
e `classes` especifica a classe Java.

`java/dev/dart/Example.java` contém uma classe muito simples, que
tem um método static público chamado `sum`:

```java
package dev.dart;

public class Example {
  public static int sum(int a, int b) {
    return a + b;
  }
}
```

### Gerar os bindings Dart

Para gerar os bindings Dart, execute `jnigen` e
especifique o arquivo de configuração usando a opção `--config`:

```console
$ dart run jnigen --config jnigen.yaml
```

Neste exemplo, isso gera
[`lib/example.dart`]({{page.example}}/lib/example.dart), exatamente
como você especificou em `jnigen.yaml`.

Este arquivo contém uma classe chamada `Example`,
que tem um método static chamado `sum`,
assim como o arquivo Java.

### Usar os bindings

Agora você está pronto para carregar e interagir com a biblioteca gerada.
A aplicação de exemplo, [`bin/sum.dart`]({{page.example}}/bin/sum.dart), recebe
dois números como argumentos e imprime sua soma.
Usar o método `Example.sum` é idêntico a Java.

```dart
// a and b are integer arguments
print(Example.sum(a, b));
```

### Executar o exemplo

Antes de executar o exemplo,
você deve compilar a biblioteca dinâmica para `jni`.
Os fontes Java também devem ser compilados. Para isso, execute:

```console
$ dart run jni:setup
$ javac java/dev/dart/Example.java
```

Agora você pode executar o exemplo:

```console
$ dart run jnigen_example:sum 17 25
```

Que produz `42`!

## Mais exemplos

A seguir estão alguns exemplos mais abrangentes de uso de `package:jnigen`:

| **Exemplo**             | **Descrição**                                                                                          |
|-------------------------|--------------------------------------------------------------------------------------------------------|
| [in_app_java][]         | Demonstra como incluir código Java customizado em uma aplicação Flutter e chamá-lo usando `jnigen`.   |
| [pdfbox_plugin][]       | Exemplo de um plugin Flutter que fornece bindings para a biblioteca [Apache PDFBox][].                |
| [notification_plugin][] | Exemplo de um plugin Flutter reutilizável com código Java customizado que usa bibliotecas Android.    |

{:.table}

[dev dependency]: /tools/pub/dependencies#dev-dependencies
[in_app_java]: {{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/in_app_java
[notification_plugin]: {{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/notification_plugin
[pdfbox_plugin]: {{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/pdfbox_plugin
[Apache PDFBox]: https://pdfbox.apache.org/
