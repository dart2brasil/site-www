---
title: 'Java interop using package:jnigen'
shortTitle: Java interop
breadcrumb: Java
description: >-
  To use Java in your Dart program, use package:jnigen.
example: 'https://github.com/HosseinYousefi/jnigen_example/tree/main'
---

Aplicativos Dart mobile, de linha de comando e servidor
executando na [plataforma Dart Native](/overview#platform), em
Android, Windows, macOS e Linux podem usar [`package:jni`][jni-pkg]
e [`package:jnigen`][jnigen-pkg]
para chamar APIs Java e Kotlin.

:::note
Este recurso de interoperabilidade é **experimental**
e [em desenvolvimento ativo]({{site.repo.dart.sdk}}/issues/49674).
:::

`package:jni` permite que o código Dart interaja
com Java através de [JNI][jnidoc] (Java Native Interface).
No entanto, isso envolve muito código redundante,
portanto, você pode usar `package:jnigen` para gerar automaticamente
as ligações Dart para uma determinada API Java.

Você pode compilar Kotlin para bytecode Java, permitindo que `package:jnigen`
gere ligações para Kotlin também.

[jni-pkg]: {{site.pub-pkg}}/jni
[jnigen-pkg]: {{site.pub-pkg}}/jnigen
[jnidoc]: https://docs.oracle.com/en/java/javase/17/docs/specs/jni/index.html

## Exemplo simples em Java {:#simple-java-example}

This guide walks you through [an example]({{page.example}})
that uses `package:jnigen` to generate bindings for a simple class.

### Pré-requisitos {:#prerequisites}

- JDK

### Configurando `jnigen` {:#configure-jnigen}

Primeiro, adicione `package:jni` como uma dependência e
`package:jnigen` como uma [dependência de desenvolvimento][dev dependency].

```console
$ dart pub add jni dev:jnigen
```

Em seguida, crie um arquivo de nível superior chamado `jnigen.yaml`.
Este arquivo contém a configuração para gerar as ligações.

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

`path` especifica o caminho para as ligações Dart geradas.

`source_path` especifica o caminho do arquivo fonte Java para o qual
você deseja gerar as ligações,
e `classes` especifica a classe Java.

`java/dev/dart/Example.java` contém uma classe muito simples, que
possui um método estático público chamado `sum`:

```java
package dev.dart;

public class Example {
  public static int sum(int a, int b) {
    return a + b;
  }
}
```

### Gerando as ligações Dart {:#generate-the-dart-bindings}

Para gerar as ligações Dart, execute `jnigen` e
especifique o arquivo de configuração usando a opção `--config`:

```console
$ dart run jnigen --config jnigen.yaml
```

In this example, this generates
[`lib/example.dart`]({{page.example}}/lib/example.dart), just
as you specified in `jnigen.yaml`.

Este arquivo contém uma classe chamada `Example`,
que possui um método estático chamado `sum`,
assim como o arquivo Java.

### Usando as ligações {:#use-the-bindings}

Now you're ready to load and interact with the generated library.
The example app, [`bin/sum.dart`]({{page.example}}/bin/sum.dart), gets 
two numbers as arguments and prints their sum. 
Using the `Example.sum` method is identical to Java.

```dart
// a e b são argumentos inteiros
print(Example.sum(a, b));
```

### Executando o exemplo {:#run-the-example}

Antes de executar o exemplo,
você deve construir a biblioteca dinâmica para `jni`.
As fontes Java também devem ser compiladas. Para fazer isso, execute:

```console
$ dart run jni:setup
$ javac java/dev/dart/Example.java
```

Agora você pode executar o exemplo:

```console
$ dart run jnigen_example:sum 17 25
```

Que retorna `42`!

## Mais exemplos {:#more-examples}

Segue alguns exemplos mais abrangentes do uso de `package:jnigen`:

| **Exemplo**             | **Descrição**                                                                                 |
|-------------------------|-------------------------------------------------------------------------------------------------|
| [in_app_java][in_app_java]         | Demonstra como incluir código Java personalizado em um aplicativo Flutter e chamá-lo usando `jnigen`. |
| [pdfbox_plugin][pdfbox_plugin]       | Exemplo de um plugin Flutter que fornece ligações para a biblioteca [Apache PDFBox][Apache PDFBox].            |
| [notification_plugin][notification_plugin] | Exemplo de um plugin Flutter reutilizável com código Java personalizado que usa bibliotecas Android.         |

{:.table}

[dev dependency]: /tools/pub/dependencies#dev-dependencies
[in_app_java]:
{{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/in_app_java
[notification_plugin]:
{{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/notification_plugin
[pdfbox_plugin]:
{{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/pdfbox_plugin
[Apache PDFBox]: https://pdfbox.apache.org/

