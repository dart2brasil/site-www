---
ia-translate: true
title: Migrating to null safety
breadcrumb: Migrating
description: How to move your existing Dart code to the world of null safety.
---

:::version-note
Dart 2.19 é a versão final que suporta a migração para null safety,
incluindo a ferramenta `dart migrate`.
Para migrar seu pacote para null safety,
use o SDK Dart 2.19.6.
Para saber mais,
veja [Dart 3 e null safety](/null-safety#dart-3-and-null-safety).
:::

Esta página descreve como e quando migrar seu código para [null safety][null safety].
Aqui estão os passos básicos para migrar cada pacote que você possui:

1. [**Aguarde**](#step1-wait) que os pacotes
   dos quais você depende sejam migrados.
2. [**Migre**](#step2-migrate) o código do seu pacote,
   preferencialmente usando a ferramenta de migração interativa.
3. [**Analise estaticamente**](#step3-analyze) o código do seu pacote.
4. [**Teste**](#step4-test) para garantir que suas mudanças funcionem.
5. Se o pacote já estiver no pub.dev,
   [**publique**](#step5-publish) a versão null-safe
   como uma versão **pré-lançamento**.

:::tip
Se sua aplicação ou biblioteca for grande, confira
[Migração gradual para null safety em grandes projetos Dart][Migração gradual para null safety em grandes projetos Dart].
:::

:::note
**Migrar um aplicativo é tecnicamente o mesmo que migrar um pacote.**
Antes de migrar um aplicativo,
certifique-se de que todas as suas dependências estejam prontas.
:::

Para ter uma visão informal da experiência de usar a ferramenta de migração,
assista a este vídeo:

<YouTubeEmbed id="eBr5tlumwlg" title="How to migrate Dart packages to null safety"></YouTubeEmbed>

[null safety]: /null-safety
[Gradual null safety migration for large Dart projects]: https://blog.dart.dev/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9


## 1. Aguarde para migrar {:#step1-wait}

We strongly recommend migrating code in order,
with the leaves of the dependency graph being migrated first.
For example, if package C depends on package B, which depends on package A,
then A should be migrated to null safety first, then B, then C.

![Ilustração da sentença C/B/A](/assets/img/null-safety/null-safety-migration-order.png){:width="454px"}<br>

Embora você _possa_ migrar [antes que suas dependências suportem null safety][Null safety unsound] ,
você pode ter que mudar seu código
quando suas dependências migrarem.
Por exemplo, se você prever que uma função receberá um parâmetro anulável, mas
o pacote migrá-lo para ser não anulável,
então passar um argumento anulável se tornará um erro de compilação.

:::note
**Você pode—e deve—migrar seu pacote antes que
pacotes que dependem dele sejam migrados.**
Seu pacote null-safe é utilizável por pacotes e aplicativos que
ainda não usam null safety,
desde que usem Dart 2.12 ou posterior.
Por exemplo, as bibliotecas principais do Dart e do Flutter são null safe,
e ainda são utilizáveis por aplicativos que não migraram para null safety.
:::

Esta seção informa como
verificar e atualizar as dependências do seu pacote,
com a ajuda do comando `dart pub outdated` no modo null-safety.
As instruções assumem que seu código está sob **controle de versão**,
para que você possa desfazer facilmente quaisquer alterações.

<a id="switch-to-the-latest-stable-dart-release"></a>
### Alterne para a versão Dart 2.19.6 {:#switch-to-the-dart-2-19-6-release}

Switch to the **2.19.6 release** of the Dart SDK.
This is included in the Flutter 3.7.12 SDK.

Verifique se você tem Dart 2.19.6:

```console
$ dart --version
Dart SDK version: 2.19.6
```

### Verifique o status da dependência {:#check-dependency-status}

Obtenha o estado de migração das dependências do seu pacote,
usando o seguinte comando:

```console
$ dart pub outdated --mode=null-safety
```

Se a saída disser que todos os pacotes suportam null safety,
então você pode começar a migrar.
Caso contrário, use a coluna **Resolvable** para encontrar
versões null-safe, se elas existirem.

:::note Por que todas as dependências precisam suportar null safety?
Quando todas as dependências diretas de um aplicativo suportam null safety,
você pode _executar o aplicativo_ com null safety *sound*.
Quando todas as dependências de desenvolvimento suportam null safety,
você pode _executar testes_ com null safety *sound*.
Você também pode precisar de dependências de desenvolvimento null-safe por outros motivos,
como geração de código.
:::

Aqui está um exemplo da saída para um pacote simples.
A versão marcada em verde para cada pacote suporta null safety:

![Saída do dart pub outdated](/assets/img/null-safety/pub-outdated-output.png)

A saída mostra que todas as dependências do pacote
têm versões preliminares resolvíveis que suportam null safety.

Se alguma das dependências do seu pacote _ainda não_ suportar null safety,
nós encorajamos você a entrar em contato com o proprietário do pacote.
Você pode encontrar os detalhes de contato na página do pacote em [pub.dev][pub.dev].

[pub.dev]: {{site.pub}}


### Atualizar dependências {:#update-dependencies}

Antes de migrar o código do seu pacote,
atualize suas dependências para versões null-safe:

1. Execute `dart pub upgrade --null-safety` para atualizar para as
   versões mais recentes que suportam null safety.
   **Observação:** Este comando altera seu arquivo `pubspec.yaml`.

2. Execute `dart pub get`.


## 2. Migrar {:#step2-migrate}

Most of the changes that your code needs to be null safe
are easily predictable.
For example, if a variable can be `null`,
[its type needs a `?` suffix][nullable type].
If a named parameter shouldn't be nullable,
mark it [`required`][required]
or give it a [default value][].

Você tem duas opções para migrar:

* [Use a ferramenta de migração][ferramenta de migração],
  que pode fazer a maioria das mudanças facilmente previsíveis para você.
* [Migre seu código manualmente.](#migrating-by-hand)

:::tip
Para obter ajuda adicional ao migrar o código, verifique o
[FAQ de null safety][FAQ de null safety].
:::

[tipo anulável]: /null-safety#creating-variables
[required]: /null-safety/understanding-null-safety#required-named-parameters
[valor padrão]: /language/functions#default-parameters
[ferramenta de migração]: #migration-tool
[FAQ de null safety]: /null-safety/faq


### Usando a ferramenta de migração {:#migration-tool}

A ferramenta de migração pega um pacote de código Dart não null-safe
e o converte para null safety.
Você pode orientar a conversão da ferramenta adicionando
[marcadores de dica][marcadores de dica] ao seu código Dart.

[marcadores de dica]: #hint-markers

Antes de iniciar a ferramenta, certifique-se de que está pronto:

* Use the 2.19.6 release of the Dart SDK.
* Use `dart pub outdated --mode=null-safety` to make sure that
  all dependencies are null safe and up-to-date.

Start the migration tool by running the `dart migrate` command
in the directory that contains the package's `pubspec.yaml` file:

```console
$ dart migrate
```

Se seu pacote estiver pronto para migrar,
a ferramenta produzirá uma linha como a seguinte:

```console
Visualize as sugestões de migração visitando:

  http://127.0.0.1:60278/Users/you/project/mypkg.console-simple?authToken=Xfz0jvpyeMI%3D
```

Visite esse URL em um navegador Chrome
para ver uma interface de usuário interativa
onde você pode orientar o processo de migração:

![Captura de tela da ferramenta de migração](/assets/img/null-safety/migration-tool.png)

Para cada variável e anotação de tipo,
você pode ver qual anulabilidade a ferramenta infere.
Por exemplo, na captura de tela anterior,
a ferramenta infere que a lista `ints` (anteriormente uma lista de `int`)
na linha 1 é anulável e, portanto, deve ser uma lista de `int?`.


#### Entendendo os resultados da migração {:#understanding-migration-results}

Para ver os motivos de cada alteração (ou não alteração),
clique no número da linha no painel **Edições Propostas**.
Os motivos aparecem no painel **Detalhes da Edição**.

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
é compatível com versões anteriores, mas não é ideal:

```dart
var ints = const <int?>[0, null];
var zero = ints[0];
var one = zero! + 1;
var zeroOne = <int?>[zero, one];
```

Ao clicar no link da **linha 3**,
você pode ver os motivos da ferramenta de migração para
adicionar o `!`.
Como você sabe que `zero` não pode ser nulo,
você pode melhorar o resultado da migração.


#### Melhorando os resultados da migração {:#hint-markers}

Quando a análise infere a nulabilidade errada,
você pode substituir as edições propostas inserindo marcadores de dica temporários:

* No painel **Detalhes da Edição** da ferramenta de migração,
  você pode inserir marcadores de dica usando os botões
  **Adicionar dica `/*?*/`** e **Adicionar dica `/*!*/`**.

  Esses botões adicionam comentários ao seu arquivo imediatamente,
  e **não há desfazer**.
  Se você não quiser uma dica que a ferramenta inseriu,
  você pode usar seu editor de código usual para removê-la.

* Você pode usar um editor para adicionar marcadores de dica,
  mesmo enquanto a ferramenta ainda está em execução.
  Como seu código ainda não optou pelo null safety,
  você não pode usar os novos recursos do null safety.
  Você pode, no entanto, fazer mudanças como refatoração
  que não dependem de recursos de null safety.

  Quando terminar de editar seu código,
  clique em **Reexecutar das fontes** para pegar suas mudanças.

A tabela a seguir mostra os marcadores de dica que você pode usar
para alterar as edições propostas da ferramenta de migração.

| Marcador de dica                                | Efeito na ferramenta de migração                                                                           |
|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| <code><em>expressão</em>&nbsp;/*!*/</code> | Adiciona um `!` ao código migrado, convertendo _expressão_ para seu tipo não anulável subjacente.         |
| <code><em>tipo</em> /*!*/</code>            | Marca _tipo_ como não anulável.                                                                           |
| `/*?*/`                                     | Marca o tipo anterior como anulável.                                                                       |
| `/*late*/`                                  | Marca a declaração de variável como `late`, indicando que ela tem inicialização tardia.                   |
| `/*late final*/`                            | Marca a declaração de variável como `late final`, indicando que ela tem inicialização tardia, única. |
| `/*required*/`                              | Marca o parâmetro como `required`.                                                                         |

{:.table .table-striped}

Uma única dica pode ter efeitos cascata em outras partes do código.
No exemplo anterior,
adicionar manualmente um marcador `/*!*/` onde `zero` recebe seu valor (na linha 2)
faz com que a ferramenta de migração infira o tipo de `zero` como `int` em vez de `int?`.
Essa mudança de tipo pode afetar o código que usa `zero` direta ou indiretamente.

```dart
var zero = ints[0]/*!*/;
```

Com a dica acima, a ferramenta de migração altera suas edições propostas,
como os seguintes trechos de código mostram.
A linha 3 não tem mais um `!` depois de `zero`,
e na linha 4, infere-se que `zeroOne` é
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

#### Excluindo arquivos {:#opting-out-files}

Embora recomendemos migrar tudo de uma vez,
às vezes isso não é prático,
especialmente em um aplicativo ou pacote grande.
Para excluir um arquivo ou diretório,
clique em sua caixa de seleção verde.
Mais tarde, quando você aplicar as alterações,
cada arquivo excluído permanecerá inalterado
exceto por um [comentário de versão][comentário de versão] 2.9.

Para obter mais informações sobre migração incremental, consulte
[Null safety *unsound*][Null safety unsound].

Note that only fully migrated apps and packages
are compatible with Dart 3.

[comentário de versão]: /resources/language/evolution#per-library-language-version-selection


#### Aplicando alterações {:#applying-changes}

Quando você gostar de todas as mudanças
que a ferramenta de migração propõe, clique em **Aplicar migração**.
A ferramenta de migração exclui os marcadores de dica e
salva o código migrado.
A ferramenta também atualiza a restrição mínima do SDK no pubspec,
que permite que o pacote entre no null safety.

O próximo passo é [analisar estaticamente seu código](#step3-analyze).
Se for válido, [teste seu código](#step4-test).
Então, se você publicou seu código no pub.dev,
[publique um pré-lançamento null-safe](#step5-publish).


### Migrando manualmente {:#migrating-by-hand}

Se você preferir não usar a ferramenta de migração,
você pode migrar manualmente.

We recommend that you **first migrate leaf libraries**—libraries
that don't import other files from the package.
Then migrate libraries that directly depend on the leaf libraries.
End by migrating the libraries that have the most
intra-package dependencies.

Por exemplo, digamos que você tenha um arquivo `lib/src/util.dart`
que importa outros pacotes (null-safe) e bibliotecas principais,
mas que não tem nenhuma diretiva `import '<caminho_local>'`.
Considere migrar `util.dart` primeiro,
e então migrar arquivos simples que dependem apenas de `util.dart`.
Se alguma biblioteca tiver importações cíclicas
(por exemplo, A importa B que importa C e C importa A),
considere migrar essas bibliotecas juntas.

Para migrar um pacote manualmente, siga estes passos:

1. Edite o arquivo `pubspec.yaml` do pacote,
   definindo a restrição mínima do SDK para pelo menos `2.12.0`:

   ```yaml
   environment:
     sdk: '>=2.12.0 <3.0.0'
   ```

2. Recompile o [arquivo de configuração do pacote][arquivo de configuração do pacote]:

   ```console
   $ dart pub get
   ```

   [arquivo de configuração do pacote]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md

   Executar `dart pub get` com uma restrição de SDK inferior de pelo menos `2.12.0`
   define a versão padrão da linguagem de
   cada biblioteca no pacote para um mínimo de 2.12,
   permitindo que todos entrem no null safety.

3. Abra o pacote em seu IDE. <br>
   É provável que você veja muitos erros de análise.
   Está tudo bem.

4. Migre o código de cada arquivo Dart,
   usando o analisador para identificar erros estáticos. <br>
   Elimine erros estáticos adicionando `?`, `!`, `required` e `late`,
   conforme necessário.

Veja [Null safety *unsound*][Null safety unsound]
para obter mais ajuda sobre como migrar o código manualmente.

[Null safety unsound]: /null-safety/unsound-null-safety


## 3. Analisar {:#step3-analyze}

Atualize seus pacotes
(usando `dart pub get` no seu IDE ou na linha de comando).
Em seguida, use seu IDE ou a linha de comando
para realizar [análise estática][análise estática] em seu código:

```console
$ dart pub get
$ dart analyze     # ou `flutter analyze`
```

[análise estática]: /tools/analysis


## 4. Testar {:#step4-test}

Se seu código passar na análise, execute os testes:

```console
$ dart test       # ou `flutter test`
```

Você pode precisar atualizar os testes que esperam valores nulos.

Se você precisar fazer grandes alterações em seu código,
você pode precisar remigrá-lo.
Se for o caso, reverta as alterações de código antes de usar a ferramenta de migração novamente.


## 5. Publicar {:#step5-publish}

We encourage you to publish packages—possibly as prereleases—as
soon as you migrate:

* [Set the package version to indicate a breaking change.](#package-version)
* [Update the SDK constraints and package dependencies.](#check-your-pubspec)
* [Publish the package](/tools/pub/publishing).
  If you don't consider this version to be a stable release,
  then [publish the package as a prerelease][].
* [Update examples and documentation](#update-examples-and-docs)

[publique o pacote como um pré-lançamento]: /tools/pub/publishing#publishing-prereleases

### Atualizar a versão do pacote {:#package-version}

Atualize a versão do pacote
para indicar uma mudança drástica:

* Se seu pacote já estiver em `1.0.0` ou superior,
  aumente a versão principal.
  Por exemplo, se a versão anterior for `2.3.2`,
  a nova versão é `3.0.0`.

* Se seu pacote ainda não atingiu `1.0.0`,
  _aumente_ a versão secundária _ou_ atualize a versão para `1.0.0`.
  Por exemplo, se a versão anterior for `0.3.2`,
  a nova versão é `0.4.0` ou `1.0.0`.

### Verifique seu pubspec {:#check-your-pubspec}

Before you publish a stable null safety version of a package,
we strongly recommend following these pubspec rules:

* Defina a restrição inferior do SDK do Dart para a versão estável mais baixa
  que você testou (pelo menos `2.12.0`).
* Use versões estáveis de todas as dependências diretas.

### Update examples and docs

If you haven't yet, update all [examples][] and samples
of your package to use a migrated version of your package
and to opt in to null safety.

If you've published any separate documentation or tutorials
for your package, also make sure that they're up to date for
the null-safe release.

[examples]: /tools/pub/package-layout#examples

## Welcome to null safety

Se você chegou até aqui,
você deve ter um pacote Dart totalmente migrado e null-safe.

Se todos os pacotes dos quais você depende também forem migrados,
então seu programa está *sound* com relação a erros de referência nula.
Você deve ver uma saída como esta ao executar ou compilar seu código:

```console
Compilando com null safety sound
```

De toda a equipe Dart, *obrigado* por migrar seu código.
