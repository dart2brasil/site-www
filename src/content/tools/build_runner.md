---
ia-translate: true
title: build_runner
description: Uma ferramenta para construir, testar e executar código Dart.
---

O pacote [build_runner][] fornece comandos de propósito geral para
gerar arquivos, incluindo testar os arquivos gerados
ou servir tanto arquivos de origem quanto gerados.
Esta página explica como usar o `build_runner`.
Para aprender como usar o build_runner com um pacote específico,
consulte a documentação desse pacote.

:::note
Se você é um desenvolvedor web, use a [ferramenta `webdev`][webdev] para
construir e servir aplicações web.
:::

Os comandos do build_runner funcionam com _builders_—pacotes
que usam o [sistema de build do Dart][build]
para gerar arquivos de saída a partir de arquivos de entrada.
Por exemplo, os pacotes [json_serializable][] e [built_value_generator][]
definem builders que geram código Dart.

Embora o sistema de build do Dart seja uma boa alternativa para
reflection (que tem problemas de desempenho) e
macros (que os compiladores do Dart não suportam),
ele pode fazer mais do que apenas ler e escrever código Dart.
Por exemplo, o pacote [sass_builder][] implementa um builder que
gera arquivos `.css` a partir de arquivos `.scss` e `.sass`.


## Configurando o build_runner

Para usar o build_runner, adicione uma [dev dependency][] em **build_runner**
ao pubspec da sua aplicação:

<?code-excerpt "build_runner_usage/pubspec.yaml" from="dev_dependencies" to="build_test" replace="/args.*/# ···/g"?>
```yaml
dev_dependencies:
  # ···
  build_runner: ^2.8.0
  build_test: ^3.4.0
```

Depender de **build_test** é opcional; faça isso se você for testar seu código.

Como de costume após alterações no `pubspec.yaml`, execute `dart pub get` ou `dart pub upgrade`:

```console
$ dart pub get
```

## Usando comandos integrados

O seguinte é um exemplo de uso do comando **build** do build_runner:

```console
$ # De um diretório que contém um arquivo pubspec.yaml:
$ dart run build_runner build
```

O pacote build_runner inclui os seguintes comandos:

build
: Executa uma construção única.

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


## Mais informações

* Guia do [webdev][] (use se você estiver trabalhando em código específico para web)
* Guia do [build_runner][]
* [pacotes com a dependência `build_runner`][packages with the `build_runner` dependency]
* [pacotes com a dependência `build`][packages with the `build` dependency]

[build]: {{site.repo.dart.org}}/build
[build_runner]: {{site.pub-pkg}}/build_runner
[built_value_generator]: {{site.pub-pkg}}/built_value_generator
[dev dependency]: /tools/pub/dependencies#dev-dependencies
[json_serializable]: {{site.pub-pkg}}/json_serializable
[packages with the `build` dependency]: {{site.pub-pkg}}?q=dependency%3Abuild
[packages with the `build_runner` dependency]: {{site.pub-pkg}}?q=dependency%3Abuild_runner
[sass_builder]: {{site.pub-pkg}}/sass_builder
[tests]: /tools/testing
[webdev]: /tools/webdev
[webdev serve]: /tools/webdev#serve
