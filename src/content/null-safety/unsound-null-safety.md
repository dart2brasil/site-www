---
title: Unsound null safety
description: >-
  Mixing language versions lets you migrate to null safety at your own pace,
  with some of the benefits of null safety.
---

:::version-note
Dart 3 e versões posteriores não suportam código sem
segurança nula ou com segurança nula não confiável.
Todo o código deve ser totalmente seguro contra nulos.
Para saber mais, confira a [questão de rastreamento de segurança nula completa do Dart 3][Dart 3 sound null safety tracking issue].
:::

Um programa Dart pode conter algumas bibliotecas que
são [seguras contra nulos][null safe] e algumas que não são.
Esses **programas de versão mista**
dependem de **segurança nula não confiável**.

[null safe]: /null-safety
[migrated]: /null-safety#migrate
[Dart 3 sound null safety tracking issue]: {{site.repo.dart.sdk}}/issues/49530

A capacidade de misturar [versões de linguagem][language versions]
libera os mantenedores de pacotes para migrar seu código,
com o conhecimento de que mesmo usuários legados podem obter novas
correções de bugs e outras melhorias.
No entanto, programas de versão mista não obtêm todas as vantagens
que a segurança nula pode trazer.

[language versions]: /resources/language/evolution#language-versioning

Esta página descreve as diferenças entre segurança nula confiável e não confiável,
com o objetivo de ajudá-lo a decidir quando migrar para segurança nula.
Após a discussão conceitual, há instruções para migração incremental,
seguido de detalhes sobre como testar e executar programas de versão mista.

:::note
Recomendamos que, se possível, você espere as dependências migrarem
antes de migrar seu pacote.
Para detalhes, veja o [guia de migração][migration guide].
:::

[migration guide]: /null-safety/migration-guide


## Segurança nula confiável e não confiável {:#sound-and-unsound-null-safety}

Dart fornece segurança nula confiável por meio de uma combinação de
verificações estáticas e de tempo de execução.
Cada biblioteca Dart que adere à segurança nula obtém
todas as verificações _estáticas_, com erros de tempo de compilação mais rigorosos.
Isso é verdade mesmo em um programa de versão mista que contém
bibliotecas não seguras contra nulos.
Você começa a obter esses benefícios
assim que começar a migrar parte do seu código para segurança nula.

No entanto, um programa de versão mista não pode ter as
garantias de solidez de _tempo de execução_ que um aplicativo totalmente seguro contra nulos tem.
É possível que `null` vaze das bibliotecas não seguras contra nulos
para o código seguro contra nulos, porque
impedir isso quebraria o comportamento existente do código não migrado.

Para manter a compatibilidade de tempo de execução com bibliotecas legadas
enquanto oferece solidez para programas completamente seguros contra nulos,
as ferramentas Dart suportam dois modos:

* Programas de versão mista são executados com **segurança nula não confiável**.
  É possível que erros de referência `null` ocorram em tempo de execução,
  mas apenas porque um `null` ou tipo anulável escapou de
  alguma biblioteca não segura contra nulos e entrou no código seguro contra nulos.

* Quando um programa é totalmente migrado e _todas_ as suas bibliotecas são seguras contra nulos,
  então ele é executado com **segurança nula confiável**, com
  todas as garantias e otimizações do compilador que a solidez possibilita.

A segurança nula confiável é o que você deseja, se possível.
As ferramentas Dart executam automaticamente seu programa no modo confiável se
a biblioteca de ponto de entrada principal do seu programa aderiu à segurança nula.
Se você importar uma biblioteca não segura contra nulos,
as ferramentas imprimem um aviso para informá-lo de que
eles só podem ser executados com segurança nula não confiável.


## Migrando incrementalmente {:#migrating-incrementally}

Como o Dart suporta programas de versão mista,
você pode migrar uma biblioteca (geralmente um arquivo Dart) por vez,
enquanto ainda consegue executar seu programa e seus testes.

Recomendamos que você **primeiro migre as bibliotecas folha**—bibliotecas
que não importam outros arquivos do pacote.
Em seguida, migre as bibliotecas que dependem diretamente das bibliotecas folha.
Termine migrando as bibliotecas que têm mais
dependências intra-pacote.

Por exemplo, digamos que você tenha um arquivo `lib/src/util.dart`
que importa outros pacotes (seguros contra nulos) e bibliotecas principais,
mas que não possui nenhuma diretiva `import '<caminho_local>'`.
Considere migrar `util.dart` primeiro,
e então migrar os arquivos que dependem apenas de `util.dart`.
Se alguma biblioteca tiver importações cíclicas
(por exemplo, A importa B que importa C e C importa A),
considere migrar essas bibliotecas juntas.

<a id="using-the-migration-tool" aria-hidden="true"></a>

### Using the migration tool {: #migration-tool}

Você pode migrar incrementalmente usando a
[ferramenta de migração][migration tool].
Para desativar arquivos ou diretórios, clique na caixa de seleção verde.
Na captura de tela a seguir,
todos os arquivos no diretório `bin` estão desativados.

![Captura de tela do visualizador de arquivos na ferramenta de migração](/assets/img/null-safety/migration-tool-incremental.png)

[migration tool]: /null-safety/migration-guide#step2-migrate

Cada arquivo desativado permanecerá inalterado
exceto por um [comentário de versão de linguagem][language version comment] 2.9.
Você pode executar `dart migrate` novamente mais tarde para continuar a migração.
Quaisquer arquivos que já foram migrados apresentam uma caixa de seleção desabilitada:
você não pode desmigrar um arquivo depois que ele foi migrado.

### Migrando manualmente {:#migrating-by-hand}

Se você quiser migrar um pacote incrementalmente manualmente, siga estas etapas:

1. Edite o arquivo `pubspec.yaml` do pacote,
   definindo a restrição mínima do SDK para pelo menos `2.12.0`:

   ```yaml
   environment:
     sdk: '>=2.12.0 <3.0.0'
   ```

2. Regere o [arquivo de configuração do pacote][package configuration file]:

   ```console
   $ dart pub get
   ```

   [package configuration file]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md

   Executar `dart pub get` com uma restrição de SDK inferior de `2.12.0`
   define a versão de linguagem padrão de
   todas as bibliotecas no pacote para 2.12,
   optando por todas na segurança nula.

3. Abra o pacote no seu IDE. <br>
   É provável que você veja muitos erros de análise.
   Está tudo bem.

4. Adicione um [comentário de versão de linguagem][language version comment] na parte superior de
   quaisquer arquivos Dart que você não deseja considerar durante sua migração atual:

   ```dart
   // @dart=2.9
   ```

   Usar a versão de linguagem 2.9 para uma biblioteca que está em um pacote 2.12
   pode reduzir os erros de análise (linhas onduladas vermelhas) provenientes de código não migrado.
   No entanto, **a segurança nula não confiável reduz a
   informação que o analisador pode usar.**
   Por exemplo, o analisador pode presumir que um
   tipo de parâmetro não é anulável,
   mesmo que um arquivo 2.9 possa passar um valor nulo.

5. Migre o código de cada arquivo Dart,
   usando o analisador para identificar erros estáticos. <br>
   Elimine os erros estáticos adicionando `?`, `!`, `required` e `late`,
   conforme necessário.


## Testando ou executando programas de versão mista {:#testing-or-running-mixed-version-programs}

Para testar ou executar código de versão mista,
você precisa desabilitar a segurança nula confiável.
Você pode fazer isso de duas maneiras:

* Desative a segurança nula confiável usando o sinalizador `--no-sound-null-safety`
   para o comando `dart` ou `flutter`:

  ```console
  $ dart --no-sound-null-safety run
  $ flutter run --no-sound-null-safety
  ```

* Como alternativa, defina a versão de linguagem no
  ponto de entrada—o arquivo que contém a função `main()`—para 2.9.
  Em aplicativos Flutter, este arquivo geralmente é nomeado `lib/main.dart`.
  Em aplicativos de linha de comando, este arquivo geralmente é nomeado `bin/<nomeDoPacote>.dart`.
  Você também pode desativar arquivos em `test`,
  porque eles também são pontos de entrada.
  Exemplo:

  ```dart
  // @dart=2.9
  import 'src/my_app.dart';

  void main() {
    //...
  }
  ```

Desativar testes usando qualquer um desses mecanismos pode ser útil
para testes **durante** seu processo de migração incremental,
mas fazer isso significa que você não está testando seu código com
segurança nula total habilitada.
É importante ativar seus testes novamente na segurança nula
quando você terminar a migração incremental de suas bibliotecas.


[language version comment]: /resources/language/evolution#per-library-language-version-selection