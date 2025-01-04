---
ia-translate: true
title: webdev
description: Ferramentas de linha de comando para desenvolvimento web Dart.
---

Esta página explica como usar `webdev` para compilar seu aplicativo e
`build_runner` para testar seu aplicativo.

## Configuração {:#setup}

Siga estas instruções para começar a usar `webdev`.

Antes de usar `webdev`, adicione as dependências dos pacotes [build_runner][] e
[build_web_compilers][] ao seu aplicativo. O pacote `build_runner`
adiciona funcionalidades de script ao `webdev`.

```console
$ dart pub add build_runner build_web_compilers --dev
```

### Instalando e atualizando o webdev {:#installing-and-updating-webdev}

Use `dart pub` para instalar `webdev` para [todos os usuários][].

```console
$ dart pub global activate webdev
```

Use o mesmo comando para atualizar o `webdev`.
Atualize o `webdev` quando você atualizar seu SDK Dart ou quando os comandos `webdev` falharem de uma forma que você não consegue explicar.

[all users]: /tools/pub/cmd/pub-global


### Dependendo dos pacotes build_* {:#depending-on-build-packages}

Para usar `webdev`, você deve estar no diretório raiz de um pacote que
depende dos pacotes **build_runner** e **build_web_compilers**.
Se você estiver testando o aplicativo, ele também deve depender de **build_test**.

Para depender desses pacotes, adicione as seguintes [dev_dependencies][] ao
arquivo `pubspec.yaml` do seu aplicativo:

```yaml
  dev_dependencies:
    # ···
    build_runner: ^2.4.13
    build_test: ^2.2.2
    build_web_compilers: ^4.0.11
```

Como de costume após as alterações no `pubspec.yaml`, execute `dart pub get` ou
`dart pub upgrade`:

```console
$ dart pub get
```

## Usando comandos de pacotes Dart para compilar e testar {:#using-commands-from-dart-packages-to-compile-and-test}

Esta ferramenta pode compilar de duas maneiras: uma que facilita a depuração
(`serve`) e uma que resulta em código pequeno e rápido (`build`).

O compilador de desenvolvimento suporta atualizações incrementais e produz
[Asynchronous Module Definition (AMD) modules](https://github.com/amdjs/amdjs-api/blob/master/AMD.md#amd) (Módulos de Definição Assíncrona de Módulos).
Com [`webdev serve`](#serve), você pode editar seus arquivos Dart, atualizar no
Chrome e ver suas edições em pouco tempo. Essa velocidade vem da
compilação de módulos atualizados, e não de todos os pacotes que seu aplicativo requer.

A primeira compilação leva mais tempo, pois compila todo o aplicativo.
Enquanto o comando [`serve`](#serve) está em execução, as compilações
sucessivas devem compilar mais rapidamente.

O compilador de produção gera um único arquivo JavaScript minificado.

Esta seção descreve como usar os seguintes comandos:

[webdev serve](#serve)
: Executa um servidor de desenvolvimento que constrói continuamente um aplicativo JavaScript.

[webdev build](#build)
: Constrói uma versão implantável de um aplicativo JavaScript.

[build_runner test](#test)
: Executa testes.

Você pode personalizar sua compilação usando arquivos de configuração de build.
Para saber mais sobre arquivos de configuração de build, consulte o
pacote [build_web_compilers][].

### webdev serve {:#serve}

Para servir uma versão de desenvolvimento do seu aplicativo web, execute o seguinte
comando.

```plaintext
$ webdev serve [--debug | --release] [ [<diretório>[:<porta>]] ... ]
```

Este comando inicia um servidor de desenvolvimento que serve seu aplicativo e
monitora as alterações no código-fonte. Por padrão, este comando serve o
aplicativo em [localhost:8080](localhost:8080):

```console
$ webdev serve
```

A primeira execução de `webdev serve` compila lentamente. Após a primeira compilação, ele armazena em cache
os assets (recursos) no disco. Isso faz com que as compilações posteriores sejam mais rápidas.

:::note
O compilador de desenvolvimento suporta **apenas o Chrome.**
Para visualizar seu aplicativo em outro navegador,
use o compilador de produção.
O compilador de produção suporta as duas versões mais recentes de Chrome,
Edge, Firefox e Safari.
:::

Para habilitar o [Dart DevTools][], adicione a flag `--debug`:

```console
$ webdev serve --debug  # habilita o Dart DevTools
```

Para usar o compilador de produção em vez do compilador de desenvolvimento, adicione a flag `--release`:

```console
$ webdev serve --release  # usa o compilador de produção
```

Você pode especificar diferentes configurações de diretório-porta.

Por exemplo, o comando a seguir altera a porta de teste do
padrão (8081) para 8083:

```console
$ webdev serve web test:8083 # App: 8080; testes: 8083
```

### webdev build {:#build}

Use o seguinte comando para construir seu aplicativo:

```plaintext
$ webdev build [--no-release] --output [<diretório>:]<diretório>
```

Por padrão, o comando `build` usa o compilador JavaScript de produção para criar uma versão de produção do seu aplicativo. Adicione `--no-release` para compilar com o compilador JavaScript de desenvolvimento. Use a opção `--output` para controlar onde o Dart compila as pastas de nível superior do projeto e grava sua saída.

O comando a seguir mostra como compilar a pasta de nível superior
`web` do projeto no diretório `build`. Este comando usa o
compilador JavaScript de produção por padrão.

```console
$ webdev build --output web:build
```


### build_runner test {:#test}

Use o comando `build_runner test` para executar os testes de componente do seu aplicativo:

```console
$ dart run build_runner test [opções do build_runner] -- -p <plataforma> [opções de teste]
```

:::tip
Se o comando falhar ao carregar o arquivo de teste,
certifique-se de que o `pubspec` do seu aplicativo tenha uma `dev_dependency` em `build_test`.
:::

Por exemplo, veja como executar todos os testes da plataforma Chrome:

```console
$ dart run build_runner test -- -p chrome
```

Para ver todas as opções disponíveis do build_runner, use a opção `--help` ou `-h`:

```console
$ dart run build_runner test -h
```

O Dart passa os argumentos após o argumento vazio `--` diretamente para o
executor do [pacote test][]. Para ver todas as opções de linha de comando para o
executor do pacote test, use este comando:

```console
$ dart test -h
```

## Mais informações {:#more-information}

Para obter uma lista completa de opções `webdev`, execute `webdev --help` ou consulte o
[pacote webdev][webdev].

Consulte também as seguintes páginas:

* [build_runner:][build_runner]
  Apresenta o build_runner e seus comandos embutidos,
  e aponta para mais informações.
* [build_web_compilers:][build_web_compilers]
  Tem informações sobre como configurar builds,
  com um exemplo de uso de `dart2js_args` para especificar
  [opções do compilador](/tools/dart-compile#js).

[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[Dart DevTools]: /tools/dart-devtools
[dev_dependencies]: /tools/pub/dependencies#dev-dependencies
[test package]: {{site.pub-pkg}}/test
[webdev]: {{site.pub-pkg}}/webdev