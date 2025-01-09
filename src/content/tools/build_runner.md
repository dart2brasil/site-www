---
ia-translate: true
title: build_runner
description: Uma ferramenta para construir, testar e executar código Dart.
---

O pacote [build_runner][] fornece comandos de propósito geral para
gerar arquivos, incluindo testar os arquivos gerados
ou servir arquivos de origem e gerados.
Esta página explica como usar `build_runner`.
Para aprender como usar build_runner com um pacote específico,
consulte a documentação desse pacote.

:::note
Se você é um desenvolvedor web, use a ferramenta [`webdev`][webdev] para
construir e servir aplicativos web.
:::

Os comandos build_runner funcionam com _builders_ (construtores)—pacotes
que usam o [sistema de build do Dart][build]
para gerar arquivos de saída a partir de arquivos de entrada.
Por exemplo, os pacotes [json_serializable][] e [built_value_generator][]
definem builders (construtores) que geram código Dart.

Embora o sistema de build do Dart seja uma boa alternativa para
reflexão (que tem problemas de desempenho) e
macros (que os compiladores do Dart não suportam),
ele pode fazer mais do que apenas ler e escrever código Dart.
Por exemplo, o pacote [sass_builder][] implementa um builder (construtor) que
gera arquivos `.css` a partir de arquivos `.scss` e `.sass`.


## Configurando build_runner {:#setting-up-build-runner}

Para usar build_runner, adicione uma [dependência de desenvolvimento][] em **build_runner**
no pubspec do seu aplicativo:

<?code-excerpt "build_runner_usage/pubspec.yaml" from="dev_dependencies" to="build_test" replace="/args.*/# ···/g"?>
```yaml
dev_dependencies:
  # ···
  build_runner: ^2.4.13
  build_test: ^2.2.2
```

Depender de **build_test** é opcional; faça isso se você for testar seu código.

Como de costume após mudanças no `pubspec.yaml`, execute `dart pub get` ou `dart pub upgrade`:

```console
$ dart pub get
```

## Usando comandos internos {:#using-built-in-commands}

O seguinte é um exemplo de uso do comando **build** do build_runner:

```console
$ # De um diretório que contém um arquivo pubspec.yaml:
$ dart run build_runner build
```

O pacote build_runner inclui os seguintes comandos:

build
: Executa um build único.

serve
: Executa um servidor de desenvolvimento.
  Em vez de usar este comando diretamente,
  você pode usar [`webdev serve`,][webdev serve]
  que tem um comportamento padrão conveniente.

test
: Executa [testes.][tests]

watch
: Inicia um servidor de build que observa edições em arquivos de entrada.
  Responde a mudanças executando rebuilds incrementais.


## Mais informações {:#more-information}

Se você estiver trabalhando em código específico para a web,
consulte a [página do webdev.][webdev]

Para detalhes sobre como usar build_runner, consulte o seguinte:

- Documentação para pacotes que exigem que você use build_runner.
  Esses pacotes geralmente têm uma dependência
  [em build][] ou [em build_runner.][]
- Documentação do Build_runner:
  - [Começando com build_runner][]
  - [FAQ do Build][]

[build]: {{site.repo.dart.org}}/build
[FAQ do Build]: {{site.repo.dart.org}}/build/blob/master/docs/faq.md
[build_runner]: {{site.pub-pkg}}/build_runner
[built_value_generator]: {{site.pub-pkg}}/built_value_generator
[dependência de desenvolvimento]: /tools/pub/dependencies#dev-dependencies
[Começando com build_runner]: {{site.repo.dart.org}}/build/blob/master/docs/getting_started.md
[json_serializable]: {{site.pub-pkg}}/json_serializable
[em build]: {{site.pub-pkg}}?q=dependency%3Abuild
[em build_runner.]: {{site.pub-pkg}}?q=dependency%3Abuild_runner
[sass_builder]: {{site.pub-pkg}}/sass_builder
[tests]: /tools/testing
[webdev]: /tools/webdev
[webdev serve]: /tools/webdev#serve
