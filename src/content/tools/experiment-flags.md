---
ia-translate: true
title: Flags de experimento
description: Usando flags de experimento com ferramentas Dart.
---

O SDK Dart frequentemente contém funcionalidades experimentais,
que você pode experimentar passando flags para as ferramentas Dart.

:::warning
Não use experimentos para código de produção.
Experimentos podem ter mudanças que quebram o código ou serem removidos
sem aviso prévio.
:::


## Usando flags de experimento com ferramentas de linha de comando {:#using-experiment-flags-with-command-line-tools}

Para usar um experimento com as [ferramentas de linha de comando](/tools/sdk) do SDK Dart,
passe a flag correspondente para a ferramenta.
Por exemplo, para habilitar os experimentos
`super-mixins` e `no-slow-checks`,
adicione essas flags ao comando `dart`:

```console
$ dart run --enable-experiment=super-mixins,no-slow-checks bin/main.dart
```


## Usando flags de experimento com o analisador Dart (linha de comando e IDE) {:#using-experiment-flags-with-the-dart-analyzer-command-line-and-ide}

Para habilitar experimentos que afetam a análise,
use a chave `enable-experiment` no [arquivo de opções de análise][].
Aqui está um exemplo de como habilitar os experimentos
`super-mixins` e `no-slow-checks` em `analysis_options.yaml`:

```yaml title="analysis_options.yaml"
analyzer:
  enable-experiment:
    - super-mixins
    - no-slow-checks
```

[arquivo de opções de análise]: /tools/analysis#the-analysis-options-file


## Usando flags de experimento com IDEs {:#using-experiment-flags-with-ides}

Para habilitar experimentos relacionados à execução ou depuração de aplicativos em IDEs,
edite a configuração de lançamento.

### Visual Studio Code {:#visual-studio-code}

Em `launch.json` sob `configurations`,
adicione uma nova chave `toolArgs` contendo as flags desejadas.
Exemplo:

```json title="launch.json"
 "configurations": [
        {
            "name": "Dart",
            "program": "bin/main.dart",
            "request": "launch",
            "type": "dart",
            "toolArgs": [
                "--enable-experiment=super-mixins,no-slow-checks",
            ],
        }
    ]
```

Para mais informações, consulte a documentação para
[configurações de lançamento do VS Code.][VSC instructions]

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations


### Android Studio {:#android-studio}

Em `VMOptions` adicione as flags desejadas.
Exemplo:

```xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="Run main" type="DartCommandLineRunConfigurationType" factoryName="Dart Command Line Application">
    <option name="VMOptions" value="--enable-experiment=non-nullable" />
    <option name="filePath" value="$PROJECT_DIR$/bin/main.dart" />
    <method v="2" />
  </configuration>
</component>
```

Para mais informações, consulte as instruções para
[configurações de execução/depuração do Android Studio.][AS instructions]

[AS instructions]: {{site.android-dev}}/studio/run/rundebugconfig


## Mais informações {:#more-information}

* Para uma lista completa de experimentos,
  veja o arquivo do SDK Dart [`experimental_features.yaml`.][]
* Para obter informações sobre procedimentos e expectativas para flags de experimento,
  veja a documentação do
  [processo para mudanças que estão por trás de flags experimentais.][flags]

[`experimental_features.yaml`.]: {{site.repo.dart.sdk}}/blob/main/tools/experimental_features.yaml
[flags]: {{site.repo.dart.sdk}}/blob/main/docs/process/experimental-flags.md
