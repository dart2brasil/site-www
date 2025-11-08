---
ia-translate: true
title: Null safety não sólida (unsound)
description: >-
  Misturar versões de linguagem permite que você migre para null safety no seu próprio ritmo,
  com alguns dos benefícios do null safety.
---

:::version-note
Dart 3 e versões posteriores não suportam código sem
null safety ou com unsound null safety.
Todo o código deve ser soundly null safe.
Para saber mais, confira a [issue de acompanhamento do Dart 3 sound null safety][Dart 3 sound null safety tracking issue].
:::

Um programa Dart pode conter algumas bibliotecas que
são [null safe][] e algumas que não são.
Esses **programas de versões mistas (mixed-version)**
dependem de **unsound null safety**.

[null safe]: /null-safety
[migrated]: /null-safety#migrate
[Dart 3 sound null safety tracking issue]: {{site.repo.dart.sdk}}/issues/49530

A capacidade de misturar [versões de linguagem][language versions]
libera os mantenedores de pacotes para migrar seu código,
com o conhecimento de que até mesmo usuários legados podem obter novas
correções de bugs e outras melhorias.
No entanto, programas de versões mistas não obtêm todas as vantagens
que null safety pode trazer.

[language versions]: /resources/language/evolution#language-versioning

Esta página descreve as diferenças entre sound e unsound null safety,
com o objetivo de ajudá-lo a decidir quando migrar para null safety.
Após a discussão conceitual, há instruções para migrar incrementalmente,
seguidas de detalhes sobre testes e execução de programas de versões mistas.

:::note
Recomendamos que, se possível, você aguarde até que as dependências migrem
antes de migrar seu pacote.
Para detalhes, consulte o [guia de migração][migration guide].
:::

[migration guide]: /null-safety/migration-guide


## Sound e unsound null safety

Dart fornece sound null safety através de uma combinação de
verificações estáticas e em tempo de execução.
Cada biblioteca Dart que opta por null safety obtém
todas as verificações _estáticas_, com erros de compilação mais rigorosos.
Isso é verdade mesmo em um programa de versões mistas que contém
bibliotecas null-unsafe.
Você começa a obter esses benefícios
assim que começa a migrar parte do seu código para null safety.

No entanto, um programa de versões mistas não pode ter as
garantias de solidez em _tempo de execução_ que um aplicativo totalmente null-safe possui.
É possível que `null` vaze das bibliotecas null-unsafe
para o código null-safe, porque
prevenir isso quebraria o comportamento existente do código não migrado.

Para manter a compatibilidade em tempo de execução com bibliotecas legadas
enquanto oferece solidez para programas completamente null-safe,
as ferramentas Dart suportam dois modos:

* Programas de versões mistas executam com **unsound null safety**.
  É possível que erros de referência `null` ocorram em tempo de execução,
  mas somente porque um tipo `null` ou nullable escapou de
  alguma biblioteca null-unsafe e entrou no código null-safe.

* Quando um programa está totalmente migrado e _todas_ as suas bibliotecas são null safe,
  então ele executa com **sound null safety**, com
  todas as garantias e otimizações de compilador que a solidez permite.

Sound null safety é o que você deseja, se possível.
As ferramentas Dart executam automaticamente seu programa em modo sound se
a biblioteca de ponto de entrada principal do seu programa optou por null safety.
Se você importar uma biblioteca null-unsafe,
as ferramentas imprimem um aviso para informar que
elas só podem executar com unsound null safety.


## Migrando incrementalmente

Como Dart suporta programas de versões mistas,
você pode migrar uma biblioteca (geralmente um arquivo Dart) por vez,
enquanto ainda é capaz de executar seu programa e seus testes.

Recomendamos que você **primeiro migre bibliotecas folha (leaf libraries)**—bibliotecas
que não importam outros arquivos do pacote.
Em seguida, migre bibliotecas que dependem diretamente das bibliotecas folha.
Termine migrando as bibliotecas que têm mais
dependências intra-pacote.

Por exemplo, digamos que você tenha um arquivo `lib/src/util.dart`
que importa outros pacotes (null-safe) e bibliotecas principais,
mas que não possui nenhuma diretiva `import '<local_path>'`.
Considere migrar `util.dart` primeiro,
e então migrar arquivos que dependem apenas de `util.dart`.
Se alguma biblioteca tiver importações cíclicas
(por exemplo, A importa B que importa C, e C importa A),
considere migrar essas bibliotecas juntas.

<a id="using-the-migration-tool" aria-hidden="true"></a>

### Usando a ferramenta de migração {: #migration-tool}

Você pode migrar incrementalmente usando a
[ferramenta de migração][migration tool].
Para desativar arquivos ou diretórios, clique na caixa de seleção verde.
Na captura de tela a seguir,
todos os arquivos no diretório `bin` estão desativados.

![Screenshot of file viewer in migration tool](/assets/img/null-safety/migration-tool-incremental.png)

[migration tool]: /null-safety/migration-guide#step2-migrate

Cada arquivo desativado permanecerá inalterado
exceto por um [comentário de versão de linguagem][language version comment] 2.9.
Você pode executar `dart migrate` novamente mais tarde para continuar a migração.
Quaisquer arquivos que já foram migrados apresentam uma caixa de seleção desabilitada:
você não pode reverter a migração de um arquivo uma vez que ele tenha sido migrado.

### Migrando manualmente

Se você quiser migrar incrementalmente um pacote manualmente, siga estas etapas:

1. Edite o arquivo `pubspec.yaml` do pacote,
   definindo a restrição mínima do SDK para pelo menos `2.12.0`:

   ```yaml
   environment:
     sdk: '>=2.12.0 <3.0.0'
   ```

2. Regenere o [arquivo de configuração do pacote][package configuration file]:

   ```console
   $ dart pub get
   ```

   [package configuration file]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md

   Executar `dart pub get` com uma restrição mínima de SDK de `2.12.0`
   define a versão de linguagem padrão de
   cada biblioteca no pacote para 2.12,
   optando todas elas por null safety.

3. Abra o pacote em sua IDE. <br>
   Você provavelmente verá muitos erros de análise.
   Tudo bem.

4. Adicione um [comentário de versão de linguagem][language version comment] no topo de
   quaisquer arquivos Dart que você não queira considerar durante sua migração atual:

   ```dart
   // @dart=2.9
   ```

   Usar a versão de linguagem 2.9 para uma biblioteca que está em um pacote 2.12
   pode reduzir erros de análise (rabiscos vermelhos) vindos de código não migrado.
   No entanto, **unsound null safety reduz a
   informação que o analisador pode usar.**
   Por exemplo, o analisador pode assumir que um
   tipo de parâmetro é non-nullable,
   mesmo que um arquivo 2.9 possa passar um valor null.

5. Migre o código de cada arquivo Dart,
   usando o analisador para identificar erros estáticos. <br>
   Elimine erros estáticos adicionando `?`, `!`, `required` e `late`,
   conforme necessário.


## Testando ou executando programas de versões mistas

Para testar ou executar código de versões mistas,
você precisa desabilitar sound null safety.
Você pode fazer isso de duas maneiras:

* Desabilite sound null safety usando a flag `--no-sound-null-safety`
  para o comando `dart` ou `flutter`:

  ```console
  $ dart --no-sound-null-safety run
  $ flutter run --no-sound-null-safety
  ```

* Alternativamente, defina a versão de linguagem no
  ponto de entrada—o arquivo que contém a função `main()`—para 2.9.
  Em aplicativos Flutter, este arquivo é frequentemente chamado `lib/main.dart`.
  Em aplicativos de linha de comando, este arquivo é frequentemente chamado `bin/<packageName>.dart`.
  Você também pode desativar arquivos sob `test`,
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
para testar **durante** seu processo de migração incremental,
mas fazer isso significa que você não está testando seu código com
null safety completo habilitado.
É importante reativar seus testes para null safety
quando você terminar a migração incremental de suas bibliotecas.


[language version comment]: /resources/language/evolution#per-library-language-version-selection
