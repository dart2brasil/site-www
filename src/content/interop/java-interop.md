---
ia-translate: true
title: 'Interoperação Java usando package:jnigen'
description: 'Para usar Java em seu programa Dart, use package:jnigen.'
example: 'https://github.com/HosseinYousefi/jnigen_example/tree/main'
---

Aplicativos Dart para dispositivos móveis, linha de comando e
servidor em execução na [plataforma Dart Native][Dart Native
platform], no Android, Windows, macOS e Linux,
podem usar [`package:jni`][jni-pkg] e [`package:jnigen`][jnigen-pkg]
para chamar APIs Java e Kotlin.

:::note
Esse recurso de interoperação é **experimental** e
está [em desenvolvimento ativo][em desenvolvimento
ativo]({{site.repo.dart.sdk}}/issues/49674).
:::

`package:jni` permite que o código Dart interaja com Java
por meio de [JNI][jnidoc]. No entanto, fazer isso envolve
muito código boilerplate, então você pode usar
`package:jnigen` para gerar automaticamente os bindings
Dart para uma determinada API Java.

Você pode compilar o Kotlin para bytecode Java, permitindo
que `package:jnigen` gere bindings para Kotlin também.

[jni-pkg]: {{site.pub-pkg}}/jni
[jnigen-pkg]: {{site.pub-pkg}}/jnigen
[jnidoc]: https://docs.oracle.com/en/java/javase/17/docs/specs/jni/index.html
[Dart Native platform]: /overview#platform
[em desenvolvimento ativo]:
{{site.repo.dart.sdk}}/issues/49674

## Exemplo simples de Java

Este guia orienta você por [um exemplo][esse é um
exemplo]({{example}}) que usa `package:jnigen`
para gerar bindings para uma classe simples.

### Pré-requisitos

- JDK
- [Maven][Maven]

[Maven]: https://maven.apache.org/
[esse é um exemplo]: {{example}}

### Configurar `jnigen`

Primeiro, adicione `package:jni` como uma dependência e
`package:jnigen` como uma [dependência de
desenvolvimento][dev dependency].

```console
$ dart pub add jni dev:jnigen
```

Em seguida, crie um arquivo de nível superior chamado
`jnigen.yaml`. Este arquivo contém a configuração para
gerar os bindings.

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

`source_path` especifica o caminho do arquivo de origem Java
para o qual você deseja gerar bindings, e `classes` especifica
a classe Java.

`java/dev/dart/Example.java` contém uma classe muito simples,
que possui um método estático público chamado `sum`:

```java
package dev.dart;

public class Example {
  public static int sum(int a, int b) {
    return a + b;
  }
}
```

### Gerar os bindings Dart

Para gerar os bindings Dart, execute `jnigen` e especifique
o arquivo de configuração usando a opção `--config`:

```console
$ dart run jnigen --config jnigen.yaml
```

Neste exemplo, isso gera [lib/example.dart][lib/example.dart]
({{example}}/lib/example.dart), exatamente como você
especificou em `jnigen.yaml`.

Este arquivo contém uma classe chamada `Example`, que possui um
método estático chamado `sum`, exatamente como o arquivo Java.

[lib/example.dart]: {{example}}/lib/example.dart

### Usar os bindings

Agora você está pronto para carregar e interagir com a
biblioteca gerada. O aplicativo de exemplo,
[bin/sum.dart][bin/sum.dart]({{example}}/bin/sum.dart),
obtém dois números como argumentos e imprime sua soma. Usar
o método `Example.sum` é idêntico ao Java.

```dart
// a e b são argumentos inteiros
print(Example.sum(a, b));
```

[bin/sum.dart]: {{example}}/bin/sum.dart

### Executar o exemplo

Antes de executar o exemplo, você deve construir a biblioteca
dinâmica para `jni`. As fontes Java também devem ser
compiladas. Para fazer isso, execute:

```console
$ dart run jni:setup
$ javac java/dev/dart/Example.java
```

Agora você pode executar o exemplo:

```console
$ dart run jnigen_example:sum 17 25
```

Que retorna `42`!

## Mais exemplos

A seguir, alguns exemplos mais abrangentes de uso do
`package:jnigen`:

| **Exemplo**                     | **Descrição**                                                                                                                                 |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| [in_app_java][in_app_java]       | Demonstra como incluir código Java personalizado em um aplicativo Flutter e chamá-lo usando `jnigen`.                                             |
| [pdfbox_plugin][pdfbox_plugin]   | Exemplo de um plugin Flutter que fornece bindings para a biblioteca [Apache PDFBox][Apache PDFBox].                                                 |
| [notification_plugin][notification_plugin] | Exemplo de um plugin Flutter reutilizável com código Java personalizado que usa bibliotecas Android. |

{:.table}

[dev dependency]: /tools/pub/dependencies#dev-dependencies
[in_app_java]:
{{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/in_app_java
[notification_plugin]:
{{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/notification_plugin
[pdfbox_plugin]:
{{site.repo.dart.org}}/native/tree/main/pkgs/jnigen/example/pdfbox_plugin
[Apache PDFBox]: https://pdfbox.apache.org/
