---
title: Publishing packages
breadcrumb: Publishing
description: Learn how to publish a Dart package to pub.dev.
ia-translate: true
---

[O gerenciador de pacotes pub][pub] não é apenas para usar pacotes de outras pessoas.
Ele também permite que você compartilhe seus pacotes com o mundo. Se você tem um
projeto útil e deseja que outros possam usá-lo, use o comando `dart pub publish`.

:::note
Para publicar em um local diferente do pub.dev,
ou para evitar publicação em qualquer lugar, use o campo `publish_to`,
conforme definido no [pubspec][].
:::

Assista ao seguinte vídeo para uma visão geral sobre como criar e publicar pacotes.

<YouTubeEmbed id="8V_TLiWszK0" title="How to build a package in Dart"></YouTubeEmbed>

## Lembre-se: publicar é para sempre

Tenha em mente que um pacote publicado dura para sempre.
Assim que você publicar seu pacote, os usuários podem depender dele.
Uma vez que eles começam a depender dele, remover o pacote quebraria os deles.
Para evitar isso, a [política do pub.dev][policy]
não permite cancelar a publicação de pacotes, exceto em muito poucos casos.

Você sempre pode fazer upload de novas versões do seu pacote,
mas as antigas permanecem disponíveis para usuários que ainda não podem atualizar.

Para pacotes publicados que perderam relevância ou carecem de manutenção,
[marque-os como descontinuados](#discontinue).

## Prepare seu pacote para publicação

Ao publicar um pacote, siga as convenções encontradas no
formato do [pubspec][pubspec] e na estrutura de [layout do pacote][pkg-layout].
Para simplificar o uso do seu pacote, o Dart requer essas convenções.
Essas convenções contêm algumas exceções observadas nos guias vinculados.
Quando invocado, `pub` indica quais mudanças você pode fazer para que seu pacote
funcione melhor dentro do ecossistema Dart.

Além dessas convenções, você deve seguir estes requisitos:

* Inclua um arquivo `LICENSE` no seu pacote.
  Recomendamos a [licença BSD de 3 cláusulas][BSD 3-clause license],
  que as equipes Dart e Flutter normalmente usam.
  No entanto, você pode usar qualquer licença apropriada para o seu pacote.

* Verifique se você tem o direito legal de redistribuir tudo o que
  você faz upload como parte do seu pacote.

* Mantenha o tamanho do pacote menor que 100 MB após compressão gzip.
  Se for muito grande, considere dividi-lo em vários pacotes,
  usar um arquivo `.pubignore` para remover conteúdo desnecessário,
  ou reduzir o número de recursos ou exemplos incluídos.

* Faça seu pacote depender apenas de dependências hospedadas
  do servidor de pacotes pub padrão e dependências SDK
  (`sdk: flutter`).
  Essas restrições garantem que as dependências dos seus pacotes
  possam ser encontradas e acessadas no futuro.

* Tenha uma [Conta Google][Google Account]. O Pub usa uma conta Google para gerenciar
  permissões de upload de pacotes. Sua Conta Google pode ser associada a
  um endereço do Gmail ou qualquer outro endereço de e-mail.

### Preencha sua página web no pub.dev

O Pub usa o conteúdo de alguns arquivos para criar uma página para seu
pacote em `pub.dev/packages/<your_package>`.
Os seguintes arquivos afetam o conteúdo da página web do seu pacote.

**`README.md`**
  : Este arquivo contém o conteúdo principal destacado na
  página web do seu pacote.
  O conteúdo do arquivo deve ser marcado usando [Markdown][].
  Para aprender como escrever um ótimo README, veja
  [Writing package pages](/tools/pub/writing-package-pages).

**`CHANGELOG.md`**
  : Se encontrado, este arquivo preenche sua própria aba na página web do seu pacote.
  Os desenvolvedores podem ler suas mudanças diretamente do pub.dev.
  O conteúdo do arquivo deve ser marcado usando [Markdown][].

**`pubspec.yaml`**
  : Este arquivo preenche detalhes sobre seu pacote
  no lado direito da página web do seu pacote.
  O conteúdo do arquivo deve seguir as convenções YAML.
  Esses detalhes incluem descrição, homepage e afins.

### Vantagens de usar um editor verificado {:#verified-publisher}

Você pode publicar pacotes usando um editor verificado (recomendado)
ou uma Conta Google independente.
Usar um editor verificado tem as seguintes vantagens:

* Os consumidores do seu pacote sabem que o domínio do editor foi verificado.
* Você pode evitar que o pub.dev exiba seu endereço de e-mail pessoal.
  Em vez disso, o pub.dev exibe o domínio do editor e o endereço de contato.
* O site pub.dev exibe um distintivo de editor verificado
  <img src="/assets/img/verified-publisher.svg" class="text-icon" alt="pub.dev verified publisher logo">
  ao lado do nome do seu pacote nas páginas de pesquisa e páginas de pacotes individuais.

### Criar um editor verificado {:#create-verified-publisher}

Para criar um [editor verificado][create-verified-publisher], siga estas etapas:

1. Vá para [pub.dev]({{site.pub}}).

1. Faça login no pub.dev usando uma Conta Google.

1. No menu do usuário no canto superior direito, selecione **Create Publisher**.

1. Digite o nome do domínio que deseja associar ao seu editor
   (por exemplo, `dart.dev`).

1. Clique em **Create Publisher**.

1. Na caixa de diálogo de confirmação, selecione **OK**.

1. Se solicitado, complete o fluxo de verificação.
   Isso abre o [Google Search Console][google-search].

   * Ao adicionar registros DNS,
     algumas horas podem passar antes que o Search Console reflita as mudanças.
   * Quando o fluxo de verificação estiver completo, retorne à etapa 4.

:::tip
Recomendamos fortemente que você convide outros membros da sua
organização para serem membros do editor verificado.
Isso ajuda a garantir que sua organização mantenha o acesso ao
editor quando você não estiver disponível.
:::

## Publique seu pacote

Use o comando [`dart pub publish`][] para publicar seu pacote
pela primeira vez ou para atualizá-lo para uma nova versão.

### Quais arquivos são publicados?

O pacote publicado inclui **todos os arquivos** no diretório raiz do pacote,
com as seguintes exceções:

* Quaisquer arquivos ou diretórios _ocultos_.
  Estes têm nomes que começam com ponto (`.`).
* Arquivos e diretórios listados para serem ignorados em um
  arquivo `.pubignore` ou `.gitignore`

Para usar regras de ignorar diferentes para `git` e `dart pub publish`,
crie um arquivo `.pubignore` para sobrescrever o
arquivo `.gitignore` em um determinado diretório.
Se um diretório contiver um arquivo `.pubignore` e um arquivo `.gitignore`,
então `dart pub publish` _ignora_ o arquivo `.gitignore` daquele diretório.
Os arquivos `.pubignore` seguem o mesmo formato que o
[arquivo `.gitignore`][git-ignore-format].

Para evitar publicar arquivos indesejados, siga estas práticas:

* Exclua quaisquer arquivos que você não queira incluir ou adicione-os
  a um arquivo `.pubignore` ou `.gitignore`.
* Ao fazer upload do seu pacote,
  examine a lista de arquivos que
  `dart pub publish --dry-run` mostra que irá publicar.
  Cancele o upload se algum arquivo indesejado aparecer nessa lista.

:::note
A maioria dos pacotes não precisa de um arquivo `.pubignore`.
Para saber mais sobre cenários úteis para isso,
consulte esta [resposta do StackOverflow][pubignore-when].
:::

### Testar a publicação do seu pacote

Para testar como `dart pub publish` funcionará, você pode fazer um teste:

```console
$ dart pub publish --dry-run
```

Com este comando, `dart pub` executa as seguintes tarefas:

1. Verifica se seu pacote segue o [formato pubspec][pubspec] e
   as [convenções de layout de pacote][pkg-layout].

1. Mostra todos os arquivos que pretende publicar.

O seguinte exemplo mostra a publicação de teste de um pacote chamado `transmogrify`:

```plaintext
Publishing transmogrify 1.0.0
    .gitignore
    CHANGELOG.md
    README.md
    lib
        transmogrify.dart
        src
            transmogrifier.dart
            transmogrification.dart
    pubspec.yaml
    test
        transmogrify_test.dart

Package has 0 warnings.
```

### Publicar no pub.dev

Para publicar seu pacote quando estiver pronto, remova o argumento `--dry-run`:

```console
$ dart pub publish
```

Com este comando, `dart pub` executa as seguintes tarefas:

1. Verifica se seu pacote segue o [formato pubspec][pubspec] e
   as [convenções de layout de pacote][pkg-layout].

1. Valida se `git status` está limpo. Avisa se
   arquivos que são rastreados no git têm mudanças não confirmadas.

1. Mostra todos os arquivos que pretende publicar.

1. Faz upload do seu pacote para [pub.dev]({{site.pub}}).

:::note
O comando pub não suporta publicação direta de um novo pacote para um
editor verificado. Como solução temporária, publique novos pacotes para uma Conta Google,
e então [transfira o pacote para um editor](#transferring-a-package-to-a-verified-publisher).

Uma vez que um pacote tenha sido transferido para um editor,
você pode atualizar o pacote usando `dart pub publish`.
:::

Depois que seu pacote for enviado com sucesso para o pub.dev, qualquer usuário do pub pode
baixá-lo ou depender dele em seus projetos.

Por exemplo, se você acabou de publicar a versão 1.0.0 do seu pacote `transmogrify`,
então outro desenvolvedor Dart pode adicioná-lo como uma dependência em seu `pubspec.yaml`:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

### Detectar plataformas suportadas

O [site pub.dev]({{site.pub}}) detecta quais plataformas um pacote suporta,
exibindo essas plataformas na página do pacote.
Os usuários do pub.dev podem filtrar pesquisas por plataforma.

Para alterar a lista gerada de plataformas suportadas,
[especifique as plataformas suportadas][specify supported platforms] no arquivo `pubspec.yaml`.

[specify supported platforms]: /tools/pub/pubspec#platforms

### Automatizar publicação

Uma vez que você tenha publicado a primeira versão de um pacote,
você pode configurar publicação automatizada
através de GitHub Actions ou contas de serviço do Google Cloud.
Para saber mais sobre publicação automatizada, consulte
[Automated publishing of packages to pub.dev](/tools/pub/automated-publishing).

### Publicar versões de pré-lançamento {:#publishing-prereleases}

Ao trabalhar em um pacote, considere publicá-lo como um pré-lançamento.
Pré-lançamentos podem ser úteis quando:

* Você está desenvolvendo ativamente a próxima versão principal do pacote.
* Você quer beta testers para o próximo candidato a lançamento do pacote.
* O pacote depende de uma versão instável do Dart ou Flutter SDK.

Conforme descrito no [versionamento semântico][semver],
para fazer um pré-lançamento de uma versão, anexe um sufixo à versão.
Por exemplo, para fazer um pré-lançamento da versão `2.0.0`,
você pode usar a versão `2.0.0-dev.1`.
Mais tarde, quando você lançar a versão `2.0.0`, ela terá precedência sobre todos
os pré-lançamentos `2.0.0-XXX`.

Como o pub prefere lançamentos estáveis quando disponíveis, os usuários de um pacote de pré-lançamento
podem precisar alterar suas restrições de dependência.
Por exemplo, se um usuário quiser testar pré-lançamentos da versão `2.1.0`, então
em vez de `^2.0.0` ou `^2.1.0` eles podem especificar `^2.1.0-dev.1`.

:::note
Embora `pub` prefira lançamentos estáveis da mesma forma que prefere versões mais recentes,
o resolvedor de versões não tenta todas as soluções e pode escolher um pré-lançamento,
mesmo quando existe uma resolução que não usa pré-lançamentos.
Embora isso raramente aconteça na prática.
:::

Quando você publica um pré-lançamento no pub.dev,
a página do pacote exibe links para o pré-lançamento e o lançamento estável.
O pré-lançamento não afeta a pontuação de análise, aparece nos resultados de pesquisa,
ou substitui o `README.md` e a documentação do pacote.

### Publicar versões de visualização

Visualizações podem ser úteis quando _todas_ as seguintes condições são verdadeiras:

* A próxima versão estável do pacote está completa.
* Essa versão do pacote depende de uma API ou recurso no Dart SDK que
  ainda não foi lançada em uma versão estável do Dart SDK.
* Você sabe que a API ou recurso do qual o pacote depende é
  API-estável e não mudará antes de chegar ao SDK estável.

Como exemplo, considere uma nova versão do `package:args` que tem
uma versão finalizada `2.0.0`.
Ela depende de um recurso no Dart `3.0.0-417.1.beta`.
No entanto, a versão estável do Dart SDK `3.0.0` ainda não foi lançada.
O arquivo `pubspec.yaml` pode se parecer com isto:

```yaml title="pubspec.yaml"
name: args
version: 2.0.0

environment:
  sdk: '^3.0.0-417.1.beta'
```

Quando você publica este pacote no pub.dev, ele é marcado como uma versão de visualização.
A seguinte captura de tela ilustra isso.
Ela lista a versão estável como `1.6.0` e a versão de visualização como `2.0.0`.

![Illustration of a preview version](/assets/img/tools/pub/preview-version.png){:width="600px"}

Quando o Dart lançar a versão estável do `3.0.0`,
o pub.dev atualiza a listagem do pacote para exibir
`2.0.0` como a versão mais recente (estável) do pacote.

Se todas as condições no início desta seção forem verdadeiras,
ignore o seguinte aviso de `dart pub publish`:

   _"Packages with an SDK constraint on a pre-release of the Dart SDK should
   themselves be published as a pre-release version. If this package needs Dart
   version 3.0.0-0, consider publishing the package as a pre-release
   instead."_

## Gerenciar permissões de publicação

### Localizar o editor do pacote

Se um pacote tem um editor verificado,
a página pub.dev desse pacote exibe o domínio do editor.

Para pacotes publicados sem um editor,
o pub.dev não divulga o editor por razões de privacidade.
O campo **Publisher** exibe "unverified uploader".

### Gerenciar uploaders de pacotes {:#uploaders}

Quem publica a primeira versão de um pacote torna-se
a primeira e _única_ pessoa autorizada a fazer upload de
versões adicionais desse pacote.

Para permitir ou impedir que outras pessoas façam upload de versões, você pode:

* Gerenciar uploaders autorizados na página de administração do pacote:
  `https://pub.dev/packages/<package>/admin`.
* Transferir o pacote para um [editor verificado][verified publisher];
  todos os membros de um editor estão autorizados a fazer upload.

:::tip
Convide outros membros da sua equipe para se tornarem uploaders do pacote.
Isso garante que sua equipe possa acessar o pacote quando você não estiver disponível.
:::

### Transferir um pacote para um editor verificado {:#transferring-a-package-to-a-verified-publisher}

Para transferir um pacote para um editor verificado,
você deve ser um [uploader](#uploaders) do pacote
e um administrador do editor verificado.

:::important
_Você não pode reverter este processo._ Uma vez que você transfira um pacote para um editor,
você não pode transferi-lo de volta para uma conta individual.
:::

Para transferir um pacote para um editor verificado:

1. Faça login no [pub.dev]({{site.pub}}) com uma Conta Google que está listada como
   uploader do pacote.

1. Vá para a página de detalhes do pacote (por exemplo,
   `{{site.pub-pkg}}/http`).

1. Selecione a aba **Admin**.

1. Digite o nome do editor e clique em **Transfer to Publisher**.

## Gerenciar seu pacote

### Retratar uma versão de pacote {:#retract}

Para evitar que novos consumidores de pacotes adotem uma versão publicada
do seu pacote dentro de uma janela de sete dias,
você pode retratar essa versão do pacote dentro de sete dias da publicação.
A versão retraída pode ser restaurada novamente dentro de sete dias da retração.

_Retração não é exclusão._
Uma versão de pacote retraída aparece na listagem de versões
do pacote no pub.dev na seção **Retracted versions**.
A visualização detalhada dessa versão do pacote exibe um distintivo **RETRACTED**.

Antes de retratar um pacote, considere publicar uma nova versão em vez disso.
Retratar um pacote pode ter um impacto negativo nos usuários do pacote.

Se você publicar uma nova versão com uma
_restrição de dependência ausente_
ou uma _restrição de dependência relaxada_,
então retratar a versão do pacote pode ser a única solução.
Publicar uma versão mais recente do seu pacote não impedirá que o resolvedor
de versões escolha a versão antiga.
Essa versão pode ser a única versão que o pub pode escolher.
Retratar uma versão de pacote com restrições de dependência incorretas
força os usuários a atualizar outras dependências ou obter um conflito de dependências.

No entanto, se seu pacote contiver um bug menor,
você pode não precisar retratar a versão.
Publique uma versão mais recente com o bug corrigido e uma
descrição do bug corrigido no `CHANGELOG.md`.
Isso ajuda os usuários a entender o que aconteceu.
Publicar uma versão mais recente é menos disruptivo para os usuários de pacotes.

:::version-note
A retração de pacotes foi introduzida no Dart 2.15.
Em SDKs anteriores ao 2.15, o resolvedor de versões do pub ignora o status retraído.
:::

#### Como usar uma versão retraída de um pacote

Se um pacote depende de uma versão de pacote que posteriormente é retraída,
ele ainda pode usar essa versão, desde que essa versão esteja no
arquivo `pubspec.lock` do pacote dependente.
Para depender de uma versão específica que já foi retraída,
o pacote dependente deve fixar a versão na
seção `dependency_overrides` do arquivo `pubspec.yaml`.

#### Como migrar de uma versão de pacote retraída

Quando um pacote depende de uma versão de pacote retraída,
você tem opções sobre como migrar dessa versão dependendo
de outras versões disponíveis.

#### Atualizar para uma versão mais recente

Na maioria dos casos, uma versão mais recente foi publicada para
substituir a versão retraída.
Neste caso, execute `dart pub upgrade <package>`.

#### Fazer downgrade para a versão mais recente não retraída

Se nenhuma versão mais recente estiver disponível, considere fazer downgrade
para a versão mais recente não retraída.
Você pode fazer isso de duas maneiras.

1. Use comandos da [ferramenta pub](/tools/pub/cmd):

   1. Execute `dart pub downgrade <package>` para
      obter a versão mais baixa do pacote especificado que
      corresponde às restrições no arquivo `pubspec.yaml`.

   1. Execute `dart pub upgrade <package>` para obter a
      versão compatível mais recente e não retraída disponível.

1. Edite o arquivo `pubspec.lock` no seu IDE preferido:

   1. Exclua a entrada inteira do pacote para o pacote
      com a versão retraída.

   1. Execute `dart pub get` para obter a
      versão compatível mais recente e não retraída disponível.

Embora você possa excluir o arquivo `pubspec.lock` e executar `dart pub get`,
isso não é recomendado.
Pode resultar em mudanças de versão para outras dependências.

#### Atualizar ou fazer downgrade para uma versão fora da restrição de versão especificada

Se não houver versão alternativa disponível que satisfaça a
restrição de versão atual, edite a restrição de versão
no arquivo `pubspec.yaml` e execute `dart pub upgrade`.

#### Como retratar ou restaurar uma versão de pacote

Para retratar ou restaurar uma versão de pacote,
primeiro faça login no pub.dev usando uma Conta Google
que seja um uploader ou um administrador de [editor verificado][verified publisher] do pacote.
Em seguida, vá para a aba **Admin** do pacote,
onde você pode retratar ou restaurar versões recentes do pacote.

### Descontinuar um pacote {:#discontinue}

Embora os pacotes permaneçam publicados, você pode sinalizar aos
desenvolvedores que um pacote não recebe manutenção ativa.
Isso requer que você marque o pacote como **descontinuado**.

Uma vez que você descontinue um pacote, o pacote irá:

* Permanecer publicado no pub.dev.
* Permanecer visível no pub.dev.
* Exibir um distintivo claro **DISCONTINUED**.
* Não aparecer nos resultados de pesquisa do pub.dev.

Para marcar um pacote como descontinuado:

1. Faça login no pub.dev usando uma Conta Google com permissões de uploader ou
   [editor verificado][verified publisher] para o pacote.

1. Navegue até a aba **Admin** do pacote.

1. Para descontinuar um pacote, selecione **Mark "discontinued"**.

Você também pode recomendar um pacote substituto.

1. No campo em **Suggested replacement**,
   digite o nome de outro pacote.

1. Clique em **Update "Suggested Replacement"**.

Se você mudar de ideia, pode remover a marca de descontinuado a qualquer momento.

[create-verified-publisher]: {{site.pub}}/create-publisher
[BSD 3-clause license]: https://opensource.org/licenses/BSD-3-Clause
[Google Account]: https://support.google.com/accounts/answer/27441
[Markdown]: {{site.pub-pkg}}/markdown
[pkg-layout]: /tools/pub/package-layout
[policy]: {{site.pub}}/policy
[pub]: /tools/pub/packages
[`dart pub publish`]: /tools/pub/cmd/pub-lish
[pubspec]: /tools/pub/pubspec
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
[verified publisher]: /tools/pub/verified-publishers
[git-ignore-format]: https://git-scm.com/docs/gitignore#_pattern_format
[pubignore-when]: https://stackoverflow.com/a/69767697
[google-search]: https://search.google.com/search-console/about
