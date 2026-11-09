---
ia-translate: true
title: Plugins do analyzer
description: >-
 Plugins do analyzer permitem criar lints, avisos personalizados
 e correções rápidas no IDE para seus projetos Dart
---

:::version-note
O suporte a plugins do analyzer foi adicionado no Dart 3.10.
:::

Plugins do analyzer estendem o [analyzer do Dart][Dart analyzer] para reportar diagnósticos
personalizados (lints e avisos), oferecer correções rápidas
e fornecer assists. Essa funcionalidade está disponível diretamente
no seu IDE e na linha de comando quando você executa
`dart analyze` ou `flutter analyze`.

[Dart analyzer]: /tools/analysis

## Use plugins do analyzer {:#use-analyzer-plugins}

Você pode começar a usar um plugin do analyzer no seu projeto Dart
ativando-o no arquivo `analysis_options.yaml`
na raiz do seu pacote ou workspace.

Você pode pesquisar plugins do analyzer em
[pub.dev]({{site.pub-pkg}}?q=dependency%3Aanalysis_server_plugin).

### Ative um plugin {:#enable-a-plugin}

Para ativar um plugin do analyzer, adicione-o à seção `plugins`
de nível superior do seu arquivo `analysis_options.yaml`. Você pode
adicionar um plugin do [pub.dev][pub.dev] usando uma restrição de versão:

```yaml title="analysis_options.yaml"
plugins:
  my_plugin: ^1.0.0
```

Ou, se você estiver desenvolvendo um plugin localmente,
pode usar um caminho local:

```yaml title="analysis_options.yaml"
plugins:
  my_plugin:
    path: /path/to/my_plugin
```

Depois de fazer alterações na seção `plugins`,
reinicie o Dart Analysis Server para ver os efeitos.

[pub.dev]: {{site.pub}}

### Configure os diagnósticos {:#configure-diagnostics}

Um plugin pode reportar dois tipos de diagnósticos: avisos e lints.
O analyzer os trata de forma diferente por padrão:

* Os avisos definidos por um plugin ficam ativados por
padrão (assim como os avisos padrão do analyzer).

* As regras de lint definidas por um plugin ficam desativadas por padrão
e precisam ser ativadas explicitamente no seu arquivo de opções de análise.

Você pode ativar ou desativar regras de lint específicas na
seção `diagnostics` de um plugin:

```yaml title="analysis_options.yaml"
plugins:
  my_plugin:
    path: /path/to/my_plugin
    diagnostics:
      rule_1: true
      rule_2: true
      rule_3: false
```

No exemplo anterior, `rule_1` e `rule_2` estão ativadas.
`rule_3` está explicitamente desativada, o que é útil para
sobrescrever uma regra que possa estar ativada por um arquivo
incluído via [`include:`][].

[`include:`]: /tools/analysis#including-shared-options

### Suprima diagnósticos {:#suppress-diagnostics}

Você pode suprimir diagnósticos de um plugin usando os mesmos
comentários `ignore` que usaria para [diagnósticos nativos do Dart][built-in Dart diagnostics].
Para direcionar um diagnóstico de um plugin específico,
coloque o nome do plugin seguido de uma barra (`/`) antes do código do diagnóstico.

Por exemplo, para suprimir um diagnóstico com o
código `some_code` de um plugin chamado `some_plugin`,
use um dos formatos a seguir:

Para suprimir em uma única linha:

```dart
// ignore: some_plugin/some_code
```

Para suprimir em um arquivo inteiro:

```dart
// ignore_for_file: some_plugin/some_code
```

[built-in Dart diagnostics]: /tools/analysis#suppressing-diagnostics-for-a-file

## Escreva um plugin do analyzer {:#write-an-analyzer-plugin}

Crie seu próprio plugin do analyzer para adicionar análise estática personalizada,
correções rápidas ou [assists][] à experiência de desenvolvimento em Dart.

[assists]: /resources/glossary#assist

### Configure o pacote do plugin {:#set-up-the-plugin-package}

Um plugin do analyzer é um pacote Dart comum com
dependências e estrutura específicas. A dependência principal
é o [pacote `analysis_server_plugin`][`analysis_server_plugin` package],
que fornece a classe `Plugin` principal.

[`analysis_server_plugin` package]: {{site.pub-pkg}}/analysis_server_plugin

1. Crie o arquivo `pubspec.yaml`. Por exemplo:

   ```yaml title"pubspec.yaml"
   name: test_analyzer_plugin
   version: 0.0.1
   
   environment:
     sdk: ^3.10.0
   
   dependencies:
     analysis_server_plugin: ^0.3.0
     analyzer_plugin: ^0.13.0
     analyzer: ^8.0.0
   ```

2. Crie o ponto de entrada do plugin. Por exemplo:

   ```dart title="lib/main.dart"
   import 'package:analysis_server_plugin/plugin.dart';
   import 'package:analysis_server_plugin/registry.dart';
   
   final plugin = SimplePlugin();
   
   class SimplePlugin extends Plugin {
     @override
     String get name => 'Simple plugin';
   
     @override
     void register(PluginRegistry registry) {
       // Register diagnostics, quick fixes, and assists.
     }
   }
   ```
   
   O código anterior representa a estrutura básica do
   ponto de entrada do plugin. Certifique-se de ter um arquivo `lib/main.dart`
   no seu pacote, pois ele é o ponto de entrada que o analysis server usa para carregar seu plugin.

Pontos principais:

* Você precisa de uma variável de nível superior chamada `plugin` que
  instancie sua classe. O Dart Analysis Server procura por essa variável.
* Sua classe deve estender `Plugin` de
  `package:analysis_server_plugin/plugin.dart`.
* Sobrescreva o método `register` para adicionar os recursos
  do seu plugin. Esse método serve como o principal ponto de entrada
  para registrar suas regras de análise personalizadas, correções rápidas
  e assists no analyzer.

:::tip
Depois de fazer alterações no seu plugin, reinicie o Dart
Analysis Server para ver os efeitos.
:::

### Implemente os recursos do plugin {:#implement-plugin-features}

Depois de configurar o pacote básico do plugin,
você pode começar a adicionar funcionalidades personalizadas
implementando o método `register`.

Leia os guias a seguir para aprender a implementar
funcionalidades específicas:

* [Escrevendo regras][Writing rules]
* [Escrevendo correções][Writing fixes]
* [Escrevendo assists][Writing assists]
* [Testando regras][Testing rules]

[Writing rules]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server_plugin/doc/writing_rules.md
[Writing fixes]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server_plugin/doc/writing_fixes.md
[Writing assists]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server_plugin/doc/writing_assists.md
[Testing rules]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server_plugin/doc/testing_rules.md

Consulte o Dart Analysis Server para ver muitos exemplos de regras,
correções e assists:

* [Regras do Dart Analysis Server][Dart Analysis Server's rules]
* [Correções do Dart Analysis Server][Dart Analysis Server's fixes]
* [Assists do Dart Analysis Server][Dart Analysis Server's assists]

[Dart Analysis Server's rules]: {{site.repo.dart.sdk}}/tree/main/pkg/linter/lib/src/rules
[Dart Analysis Server's fixes]: {{site.repo.dart.sdk}}/tree/main/pkg/analysis_server/lib/src/services/correction/dart
[Dart Analysis Server's assists]: {{site.repo.dart.sdk}}/tree/main/pkg/analysis_server/lib/src/services/correction/dart

### Depure um plugin {:#debug-a-plugin}

Se o seu plugin não estiver funcionando como esperado,
estas são as formas recomendadas de depurá-lo:

* Sua primeira parada deve ser as [páginas de diagnóstico do analyzer][analyzer diagnostics pages].
  Se o isolate do seu plugin travar, a tela "plugins" exibe
  as informações do erro e o stack trace.
* Instruções `print` não funcionam.
  Os plugins rodam em um isolate separado, e a saída padrão deles
  não está conectada ao seu console.
* A forma mais confiável de rastrear a execução do seu plugin e inspecionar valores
  é escrever em um arquivo de log a partir do código do plugin.


[analyzer diagnostics pages]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/doc/tutorial/instrumentation.md#open-the-analyzer-diagnostics-pages
