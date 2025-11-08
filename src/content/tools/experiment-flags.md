---
title: Experiment flags
description: Using experiment flags with Dart tools.
ia-translate: true
---

O Dart SDK frequentemente contém recursos experimentais,
que você pode experimentar passando flags para as ferramentas Dart.

:::warning
Não use experimentos para código de produção.
Experimentos podem ter mudanças incompatíveis ou ser removidos
sem aviso prévio.
:::


## Usando experiment flags com ferramentas de linha de comando

Para usar um experimento com [ferramentas de linha de comando](/tools/sdk) do Dart SDK,
passe a flag correspondente para a ferramenta.

Por exemplo, para habilitar os experimentos
`super-mixins` e `no-slow-checks`,
adicione essas flags ao comando `dart`:

```console
$ dart run --enable-experiment=super-mixins,no-slow-checks bin/main.dart
```

Ou ao comando `flutter`:

```console
$ flutter run --enable-experiment=super-mixins,no-slow-checks
```

## Usando experiment flags com o analisador Dart (linha de comando e IDE)

Para habilitar experimentos que afetam a análise,
use a chave `enable-experiment` no [arquivo de opções de análise][analysis options file].
Aqui está um exemplo de habilitação dos experimentos
`super-mixins` e `no-slow-checks` em `analysis_options.yaml`:

```yaml title="analysis_options.yaml"
analyzer:
  enable-experiment:
    - super-mixins
    - no-slow-checks
```

[analysis options file]: /tools/analysis#the-analysis-options-file


## Usando experiment flags com IDEs

Para habilitar experimentos relacionados à execução ou depuração de aplicativos em IDEs,
edite a configuração de lançamento.

### Visual Studio Code

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

Para mais informações, consulte a documentação sobre
[configurações de lançamento do VS Code.][VSC instructions]

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations


### Android Studio

Em `VMOptions`, adicione as flags desejadas.
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


## Mais informações

* Para uma lista completa de experimentos,
  veja o arquivo [`experimental_features.yaml`.][] do Dart SDK
* Para informações sobre procedimentos e expectativas para experiment flags,
  veja a documentação do
  [processo para mudanças que estão por trás de flags experimentais.][flags]

[`experimental_features.yaml`.]: {{site.repo.dart.sdk}}/blob/main/tools/experimental_features.yaml
[flags]: {{site.repo.dart.sdk}}/blob/main/docs/process/experimental-flags.md

