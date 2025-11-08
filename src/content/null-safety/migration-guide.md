---
ia-translate: true
title: Migrando para null safety
breadcrumb: Migrando
description: Como mover seu código Dart existente para o mundo de null safety.
---

:::version-note
Dart 2.19 é a versão final que suporta migração para null-safety,
incluindo a ferramenta `dart migrate`.
Para migrar seu pacote para null safety,
use o Dart 2.19.6 SDK.
Para aprender mais,
veja [Dart 3 e null safety](/null-safety#dart-3-and-null-safety).
:::

Esta página descreve como e quando migrar seu código para [null safety][].
Aqui estão os passos básicos para migrar cada pacote que você possui:

1. [**Aguarde**](#step1-wait) que os pacotes
   dos quais você depende migrem.
2. [**Migre**](#step2-migrate) o código do seu pacote,
   preferencialmente usando a ferramenta de migração interativa.
3. [**Analise estaticamente**](#step3-analyze) o código do seu pacote.
4. [**Teste**](#step4-test) para garantir que suas mudanças funcionem.
5. Se o pacote já está no pub.dev,
   [**publique**](#step5-publish) a versão null-safe
   como uma versão **prerelease**.

:::tip
Se seu aplicativo ou biblioteca for grande, confira
[Migração gradual de null safety para grandes projetos Dart][].
:::

:::note
**Migrar um aplicativo é tecnicamente o mesmo que migrar um pacote.**
Antes de migrar um aplicativo,
certifique-se de que todas as suas dependências estão prontas.
:::

Para ter uma visão informal da experiência de usar a ferramenta de migração,
assista este vídeo:

<YouTubeEmbed id="eBr5tlumwlg" title="How to migrate Dart packages to null safety"></YouTubeEmbed>

[null safety]: /null-safety
[Migração gradual de null safety para grandes projetos Dart]: https://blog.dart.dev/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9


## 1. Aguarde para migrar {:#step1-wait}

Recomendamos fortemente migrar código em ordem,
com as folhas do grafo de dependências sendo migradas primeiro.
Por exemplo, se o pacote C depende do pacote B, que depende do pacote A,
então A deve ser migrado para null safety primeiro, depois B, então C.

![Illustration of C/B/A sentence](/assets/img/null-safety/null-safety-migration-order.png){:width="454px"}<br>

Embora você [_possa_ migrar][Unsound null safety]
antes que suas dependências suportem null safety,
você pode ter que alterar seu código quando suas dependências migrarem.
Por exemplo, se você prevê que uma função receberá um parâmetro nullable mas
o pacote o migra para ser non-nullable,
então passar um argumento nullable se torna um erro de compilação.

:::note
**Você pode—e deve—migrar seu pacote antes
que pacotes que dependem dele sejam migrados.**
Seu pacote null-safe é utilizável por pacotes e aplicativos que
ainda não usam null safety,
desde que usem Dart 2.12 ou posterior.
Por exemplo, as bibliotecas principais do Dart e Flutter são null safe,
e ainda são utilizáveis por aplicativos que não migraram para null safety.
:::

Esta seção explica como
verificar e atualizar as dependências do seu pacote,
com a ajuda do comando `dart pub outdated` em modo null-safety.
As instruções assumem que seu código está sob **controle de versão**,
para que você possa desfazer facilmente quaisquer alterações.

<a id="switch-to-the-latest-stable-dart-release"></a>
### Mude para a versão Dart 2.19.6

Mude para a versão **2.19.6** do Dart SDK.
Esta está incluída no Flutter 3.7.12 SDK.

Verifique se você tem o Dart 2.19.6:

```console
$ dart --version
Dart SDK version: 2.19.6
```

### Verifique o status das dependências

Obtenha o estado de migração das dependências do seu pacote,
usando o seguinte comando:

```console
$ dart pub outdated --mode=null-safety
```

Se a saída disser que todos os pacotes suportam null safety,
então você pode começar a migrar.
Caso contrário, use a coluna **Resolvable** para encontrar
versões null-safe, se existirem.

:::note Por que todas as dependências precisam suportar null safety?
Quando todas as dependências diretas de um aplicativo suportam null safety,
você pode _executar o aplicativo_ com sound null safety.
Quando todas as dependências de desenvolvimento suportam null safety,
você pode _executar testes_ com sound null safety.
Você também pode precisar de dependências de desenvolvimento null-safe por outros motivos,
como geração de código.
:::

Aqui está um exemplo da saída para um pacote simples.
A versão marcada com verde para cada pacote suporta null safety:

![Output of dart pub outdated](/assets/img/null-safety/pub-outdated-output.png)

A saída mostra que todas as dependências do pacote
têm pré-versões resolvíveis que suportam null safety.

Se alguma das dependências do seu pacote _ainda não_ suporta null safety,
encorajamos você a entrar em contato com o proprietário do pacote.
Você pode encontrar detalhes de contato na página do pacote em [pub.dev][].

[pub.dev]: {{site.pub}}


### Atualize as dependências

Antes de migrar o código do seu pacote,
atualize suas dependências para versões null-safe:

1. Execute `dart pub upgrade --null-safety` para atualizar para as
   versões mais recentes que suportam null safety.
   **Nota:** Este comando altera seu arquivo `pubspec.yaml`.

2. Execute `dart pub get`.


## 2. Migre {:#step2-migrate}

A maioria das mudanças que seu código precisa para ser null safe
são facilmente previsíveis.
Por exemplo, se uma variável pode ser `null`,
[seu tipo precisa de um sufixo `?`][nullable type].
Se um parâmetro nomeado não deve ser nullable,
marque-o como [`required`][required]
ou dê a ele um [valor padrão][default value].

Você tem duas opções para migrar:

* [Use a ferramenta de migração][migration tool],
  que pode fazer a maioria das mudanças facilmente previsíveis para você.
* [Migre seu código manualmente.](#migrating-by-hand)

:::tip
Para ajuda adicional durante a migração de código, confira o
[FAQ de null safety][null safety FAQ].
:::

[nullable type]: /null-safety#creating-variables
[required]: /null-safety/understanding-null-safety#required-named-parameters
[default value]: /language/functions#default-parameters
[migration tool]: #migration-tool
[null safety FAQ]: /null-safety/faq


### Usando a ferramenta de migração {:#migration-tool}

A ferramenta de migração pega um pacote de código Dart não-null-safe
e o converte para null safety.
Você pode guiar a conversão da ferramenta
adicionando [marcadores de dica][] ao seu código Dart.

[marcadores de dica]: #hint-markers

Antes de iniciar a ferramenta, certifique-se de que está pronto:

* Use a versão 2.19.6 do Dart SDK.
* Use `dart pub outdated --mode=null-safety` para garantir que
  todas as dependências sejam null safe e estejam atualizadas.

Inicie a ferramenta de migração executando o comando `dart migrate`
no diretório que contém o arquivo `pubspec.yaml` do pacote:

```console
$ dart migrate
```

Se seu pacote estiver pronto para migrar,
então a ferramenta produz uma linha como a seguinte:

```console
View the migration suggestions by visiting:

  http://127.0.0.1:60278/Users/you/project/mypkg.console-simple?authToken=Xfz0jvpyeMI%3D
```

Visite essa URL em um navegador Chrome
para ver uma interface interativa
onde você pode guiar o processo de migração:

![Screenshot of migration tool](/assets/img/null-safety/migration-tool.png)

Para cada variável e anotação de tipo,
você pode ver qual nullability a ferramenta infere.
Por exemplo, na captura de tela anterior,
a ferramenta infere que a lista `ints` (anteriormente uma lista de `int`)
na linha 1 é nullable, e portanto deve ser uma lista de `int?`.


#### Entendendo resultados de migração

Para ver os motivos de cada mudança (ou não-mudança),
clique em seu número de linha no painel **Proposed Edits**.
Os motivos aparecem no painel **Edit Details**.

Por exemplo, considere o seguinte código,
de antes do null safety:

```dart
var ints = const <int>[0, null];
var zero = ints[0];
var one = zero + 1;
var zeroOne = <int>[zero, one];
```

A migração padrão quando este código está fora de uma função
(é diferente dentro de uma função)
é retrocompatível, mas não ideal:

```dart
var ints = const <int?>[0, null];
var zero = ints[0];
var one = zero! + 1;
var zeroOne = <int?>[zero, one];
```

Ao clicar no link **linha 3**,
você pode ver os motivos da ferramenta de migração para
adicionar o `!`.
Como você sabe que `zero` não pode ser null,
você pode melhorar o resultado da migração.


#### Melhorando resultados de migração {:#hint-markers}

Quando a análise infere a nullability errada,
você pode substituir suas edições propostas inserindo marcadores de dica temporários:

* No painel **Edit Details** da ferramenta de migração,
  você pode inserir marcadores de dica usando os
  botões **Add `/*?*/` hint** e **Add `/*!*/` hint**.

  Esses botões adicionam comentários ao seu arquivo imediatamente,
  e **não há Desfazer**.
  Se você não quiser uma dica que a ferramenta inseriu,
  você pode usar seu editor de código usual para removê-la.

* Você pode usar um editor para adicionar marcadores de dica,
  mesmo enquanto a ferramenta ainda está em execução.
  Como seu código ainda não optou pelo null safety,
  você não pode usar novos recursos de null-safety.
  Você pode, no entanto, fazer mudanças como refatoração
  que não dependem de recursos de null-safety.

  Quando terminar de editar seu código,
  clique em **Rerun from sources** para pegar suas mudanças.

A tabela a seguir mostra os marcadores de dica que você pode usar
para alterar as edições propostas pela ferramenta de migração.

| Marcador de dica                            | Efeito na ferramenta de migração                                                                    |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------|
| <code><em>expression</em>&nbsp;/*!*/</code> | Adiciona um `!` ao código migrado, convertendo _expression_ para seu tipo subjacente non-nullable. |
| <code><em>type</em> /*!*/</code>            | Marca _type_ como non-nullable.                                                                     |
| `/*?*/`                                     | Marca o tipo anterior como nullable.                                                                |
| `/*late*/`                                  | Marca a declaração de variável como `late`, indicando que ela tem inicialização tardia.            |
| `/*late final*/`                            | Marca a declaração de variável como `late final`, indicando inicialização única e tardia.          |
| `/*required*/`                              | Marca o parâmetro como `required`.                                                                  |

{:.table .table-striped}

Uma única dica pode ter efeitos cascata em outros lugares do código.
No exemplo de antes,
adicionar manualmente um marcador `/*!*/` onde `zero` recebe seu valor (na linha 2)
faz com que a ferramenta de migração infira o tipo de `zero` como `int` em vez de `int?`.
Esta mudança de tipo pode afetar código que usa `zero` direta ou indiretamente.

```dart
var zero = ints[0]/*!*/;
```

Com a dica acima, a ferramenta de migração altera suas edições propostas,
como os trechos de código a seguir mostram.
A linha 3 não tem mais um `!` após `zero`,
e na linha 4 `zeroOne` é inferido como
uma lista de `int`, não `int?`.

<table>
<tr>
<th>Primeira migração</th>
<th>Migração com dica</th>
</tr>
<tr>
  <td>

```dart
var ints = const <int?>[0, null];
var zero = ints[0];
var one = zero! + 1;
var zeroOne = <int?>[zero, one];
```

  </td>
  <td>

```dart
var ints = const <int?>[0, null];
var zero = ints[0]/*!*/;
var one = zero + 1;
var zeroOne = <int>[zero, one];
```

  </td>
</tr>
</table>

#### Optando arquivos para fora

Embora recomendemos migrar tudo de uma vez,
às vezes isso não é prático,
especialmente em um aplicativo ou pacote grande.
Para optar um arquivo ou diretório para fora,
clique em sua caixa de seleção verde.
Mais tarde, quando você aplicar mudanças,
cada arquivo optado para fora ficará inalterado
exceto por um [comentário de versão][version comment] 2.9.

Para mais informações sobre migração incremental, veja
[Unsound null safety][].

Note que apenas aplicativos e pacotes totalmente migrados
são compatíveis com Dart 3.

[version comment]: /resources/language/evolution#per-library-language-version-selection


#### Aplicando mudanças

Quando você gostar de todas as mudanças
que a ferramenta de migração propõe, clique em **Apply migration**.
A ferramenta de migração exclui os marcadores de dica e
salva o código migrado.
A ferramenta também atualiza a restrição mínima do SDK no pubspec,
o que opta o pacote para null safety.

O próximo passo é [analisar estaticamente seu código](#step3-analyze).
Se for válido, então [teste seu código](#step4-test).
Então, se você publicou seu código no pub.dev,
[publique uma prerelease null-safe](#step5-publish).


### Migrando manualmente

Se você preferir não usar a ferramenta de migração,
você pode migrar manualmente.

Recomendamos que você **primeiro migre bibliotecas folha**—bibliotecas
que não importam outros arquivos do pacote.
Então migre bibliotecas que dependem diretamente das bibliotecas folha.
Termine migrando as bibliotecas que têm mais
dependências intra-pacote.

Por exemplo, digamos que você tenha um arquivo `lib/src/util.dart`
que importa outros pacotes (null-safe) e bibliotecas principais,
mas que não tem nenhuma diretiva `import '<local_path>'`.
Considere migrar `util.dart` primeiro,
e então migrar arquivos simples que dependem apenas de `util.dart`.
Se alguma biblioteca tiver importações cíclicas
(por exemplo, A importa B que importa C, e C importa A),
considere migrar essas bibliotecas juntas.

Para migrar um pacote manualmente, siga estes passos:

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

   Executar `dart pub get` com uma restrição mínima do SDK de pelo menos `2.12.0`
   define a versão padrão da linguagem de
   cada biblioteca no pacote para um mínimo de 2.12,
   optando todas elas para null safety.

3. Abra o pacote no seu IDE. <br>
   É provável que você veja muitos erros de análise.
   Tudo bem.

4. Migre o código de cada arquivo Dart,
   usando o analisador para identificar erros estáticos. <br>
   Elimine erros estáticos adicionando `?`, `!`, `required`, e `late`,
   conforme necessário.

Veja [Unsound null safety][]
para mais ajuda sobre migrar código manualmente.

[Unsound null safety]: /null-safety/unsound-null-safety


## 3. Analise {:#step3-analyze}

Atualize seus pacotes
(usando `dart pub get` no seu IDE ou na linha de comando).
Então use seu IDE ou a linha de comando
para realizar [análise estática][static analysis] no seu código:

```console
$ dart pub get
$ dart analyze     # or `flutter analyze`
```

[static analysis]: /tools/analysis


## 4. Teste {:#step4-test}

Se seu código passar na análise, execute os testes:

```console
$ dart test       # or `flutter test`
```

Você pode precisar atualizar testes que esperam valores null.

Se você precisar fazer grandes mudanças no seu código,
então você pode precisar remigrá-lo.
Se sim, reverta suas mudanças de código antes de usar a ferramenta de migração novamente.


## 5. Publique {:#step5-publish}

Encorajamos você a publicar pacotes—possivelmente como pré-versões—assim
que você migrar:

* [Defina a versão do pacote para indicar uma mudança significativa.](#package-version)
* [Atualize as restrições do SDK e dependências do pacote.](#check-your-pubspec)
* [Publique o pacote](/tools/pub/publishing).
  Se você não considera esta versão uma versão estável,
  então [publique o pacote como uma prerelease][].
* [Atualize exemplos e documentação](#update-examples-and-docs)

[publique o pacote como uma prerelease]: /tools/pub/publishing#publishing-prereleases

### Atualize a versão do pacote {:#package-version}

Atualize a versão do pacote
para indicar uma mudança significativa:

* Se seu pacote já está em `1.0.0` ou superior,
  aumente a versão principal.
  Por exemplo, se a versão anterior é `2.3.2`,
  a nova versão é `3.0.0`.

* Se seu pacote ainda não chegou a `1.0.0`,
  _ou_ aumente a versão secundária _ou_ atualize a versão para `1.0.0`.
  Por exemplo, se a versão anterior é `0.3.2`,
  a nova versão é `0.4.0` ou `1.0.0`.

### Verifique seu pubspec

Antes de publicar uma versão estável null safety de um pacote,
recomendamos fortemente seguir estas regras de pubspec:

* Defina a restrição inferior do SDK Dart para a versão estável mais baixa
  que você testou (pelo menos `2.12.0`).
* Use versões estáveis de todas as dependências diretas.

### Atualize exemplos e docs

Se você ainda não fez, atualize todos os [exemplos][examples] e amostras
do seu pacote para usar uma versão migrada do seu pacote
e para optar pelo null safety.

Se você publicou qualquer documentação ou tutoriais separados
para o seu pacote, certifique-se também de que estão atualizados para
a versão null-safe.

[examples]: /tools/pub/package-layout#examples

## Bem-vindo ao null safety

Se você chegou até aqui,
você deve ter um pacote Dart totalmente migrado e null-safe.

Se todos os pacotes dos quais você depende também foram migrados,
então seu programa é sound com respeito a erros de referência null.
Você deve ver uma saída como esta ao executar ou compilar seu código:

```console
Compiling with sound null safety
```

De toda a equipe Dart, *obrigado* por migrar seu código.
