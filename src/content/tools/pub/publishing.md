---
ia-translate: true
title: Publicando pacotes
breadcrumb: Publicação
description: Aprenda a publicar um pacote Dart no pub.dev.
---

[O gerenciador de pacotes pub][pub] não serve apenas para usar pacotes de outras pessoas.
Ele também permite que você compartilhe seus pacotes com o mundo. Se você tem um
projeto útil e quer que outras pessoas possam usá-lo, use o comando `dart pub publish`.

:::note
Para publicar em um local diferente do pub.dev,
ou para impedir a publicação em qualquer lugar, use o campo `publish_to`,
como definido no [pubspec][].
:::

Assista ao vídeo a seguir para ver uma visão geral de como criar e publicar pacotes.

<YouTubeEmbed id="8V_TLiWszK0" title="How to build a package in Dart"></YouTubeEmbed>

## Lembre-se: publicar é para sempre {:#remember-publishing-is-forever}

Tenha em mente que um pacote publicado dura para sempre.
Assim que você publicar seu pacote, os usuários podem depender dele.
Quando eles começam a depender dele, remover o pacote quebraria o código deles.
Para evitar isso, a [política do pub.dev][policy]
não permite despublicar pacotes, exceto em raríssimos casos.

Você sempre pode enviar novas versões do seu pacote,
mas as antigas continuam disponíveis para usuários que ainda não podem atualizar.

Para pacotes publicados que perderam relevância ou não recebem manutenção,
[marque-os como descontinuados](#discontinue).

## Prepare seu pacote para publicação {:#prepare-your-package-for-publication}

Ao publicar um pacote, siga as convenções encontradas no
formato do [pubspec][pubspec] e na estrutura do [layout do pacote][pkg-layout].
Para simplificar o uso do seu pacote, o Dart exige essas convenções.
Elas têm algumas exceções, indicadas nos guias vinculados.
Quando executado, o `pub` aponta quais mudanças você pode fazer para que seu pacote
funcione melhor dentro do ecossistema Dart.

Além dessas convenções, você deve seguir estes requisitos:

* Inclua um arquivo `LICENSE` no seu pacote.
  Recomendamos a [licença BSD 3-clause][BSD 3-clause license],
  que as equipes Dart e Flutter normalmente usam.
  No entanto, você pode usar qualquer licença adequada ao seu pacote.

* Verifique se você tem o direito legal de redistribuir tudo o que enviar como parte do seu pacote.

* Mantenha o tamanho do pacote dentro dos limites. Recomendamos menos de
  100 MB após a compressão gzip e menos de 256 MB descompactado.

  Se o seu pacote for grande demais, considere dividi-lo em vários pacotes,
  usar um arquivo `.pubignore` para remover conteúdo desnecessário ou reduzir a
  quantidade de recursos ou exemplos incluídos.

* Faça com que seu pacote dependa apenas de dependências hospedadas
  no servidor de pacotes padrão do pub e de dependências do SDK
  (`sdk: flutter`).
  Essas restrições garantem que as dependências dos seus pacotes
  possam ser encontradas e acessadas no futuro.

* Tenha uma [Conta Google][Google Account]. O pub usa uma conta Google para gerenciar
  as permissões de envio de pacotes. Sua Conta Google pode estar associada a
  um endereço Gmail ou a qualquer outro endereço de e-mail.

### Preencha sua página no pub.dev {:#populate-your-pub-dev-web-page}

O pub usa o conteúdo de alguns arquivos para criar uma página para o seu
pacote em `pub.dev/packages/<seu_pacote>`.
Os arquivos a seguir afetam o conteúdo da página web do seu pacote.

**`README.md`**
  : Este arquivo contém o conteúdo principal exibido na
  página web do seu pacote.
  O conteúdo do arquivo deve ser marcado usando [Markdown][].
  Para aprender a escrever um bom README, consulte
  [Escrevendo páginas de pacotes](/tools/pub/writing-package-pages).

**`CHANGELOG.md`**
  : Se encontrado, este arquivo preenche sua própria aba na página web do seu pacote.
  Os desenvolvedores podem ler suas mudanças diretamente no pub.dev.
  O conteúdo do arquivo deve ser marcado usando [Markdown][].

**`pubspec.yaml`**
  : Este arquivo preenche os detalhes do seu pacote
  no lado direito da página web do pacote.
  O conteúdo do arquivo deve seguir as convenções do YAML.
  Esses detalhes incluem descrição, homepage e similares.

### Vantagens de usar um publisher verificado {:#verified-publisher}

Você pode publicar pacotes usando um publisher verificado (recomendado)
ou uma Conta Google independente.
Usar um publisher verificado tem as seguintes vantagens:

* Os consumidores do seu pacote sabem que o domínio do publisher foi verificado.
* Você evita que o pub.dev exiba seu endereço de e-mail pessoal.
  Em vez disso, o pub.dev exibe o domínio do publisher e o endereço de contato.
* O site pub.dev exibe um selo de publisher verificado
  <img src="/assets/img/verified-publisher.svg" class="text-icon" alt="pub.dev verified publisher logo">
  ao lado do nome do seu pacote nas páginas de busca e nas páginas individuais dos pacotes.

### Crie um publisher verificado {:#create-verified-publisher}

Para criar um [publisher verificado][create-verified-publisher], siga estes passos:

1. Acesse o [pub.dev]({{site.pub}}).

1. Faça login no pub.dev usando uma Conta Google.

1. No menu do usuário, no canto superior direito, selecione **Create Publisher**.

1. Digite o nome de domínio que você quer associar ao seu publisher
   (por exemplo, `dart.dev`).

1. Clique em **Create Publisher**.

1. Na caixa de confirmação, selecione **OK**.

1. Se solicitado, conclua o fluxo de verificação.
   Isso abre o [Google Search Console][google-search].

   * Ao adicionar registros DNS,
     podem passar algumas horas até que o Search Console reflita as mudanças.
   * Quando o fluxo de verificação for concluído, volte para o passo 4.

:::tip
Recomendamos fortemente que você convide outros membros da
sua organização para serem membros do publisher verificado.
Isso ajuda a garantir que sua organização continue com acesso ao
publisher quando você não estiver disponível.
:::

## Publique seu pacote {:#publish-your-package}

Use o comando [`dart pub publish`][] para publicar seu pacote
pela primeira vez ou para atualizá-lo para uma nova versão.

### Quais arquivos são publicados? {:#what-files-are-published}

O pacote publicado inclui **todos os arquivos** dentro do diretório raiz do pacote,
com as seguintes exceções:

* Quaisquer arquivos ou diretórios _ocultos_.
  Eles têm nomes que começam com ponto (`.`).
* Arquivos e diretórios listados para serem ignorados em um
  arquivo `.pubignore` ou `.gitignore`

Para usar regras de ignorar diferentes para `git` e `dart pub publish`,
crie um arquivo `.pubignore` para sobrescrever o
arquivo `.gitignore` em um determinado diretório.
Se um diretório contém um arquivo `.pubignore` e um arquivo `.gitignore`,
então `dart pub publish` _ignora_ o arquivo `.gitignore` desse diretório.
Os arquivos `.pubignore` seguem o mesmo formato do
[arquivo `.gitignore`][git-ignore-format].

Para evitar publicar arquivos indesejados, siga estas práticas:

* Apague os arquivos que você não quer incluir ou adicione-os
  a um arquivo `.pubignore` ou `.gitignore`.
* Ao enviar seu pacote,
  examine a lista de arquivos que
  `dart pub publish --dry-run` mostra que serão publicados.
  Cancele o envio se algum arquivo indesejado aparecer nessa lista.

:::note
A maioria dos pacotes não precisa de um arquivo `.pubignore`.
Para saber mais sobre cenários úteis para isso,
consulte esta [resposta no StackOverflow][pubignore-when].
:::

### Teste a publicação do seu pacote {:#test-publishing-your-package}

Para testar como o `dart pub publish` vai funcionar, você pode fazer uma simulação (dry run):

```console
$ dart pub publish --dry-run
```

Com esse comando, o `dart pub` executa as seguintes tarefas:

1. Verifica se o seu pacote segue o [formato do pubspec][pubspec] e as
   [convenções de layout do pacote][pkg-layout].

1. Mostra todos os arquivos que pretende publicar.

O exemplo a seguir mostra o teste de publicação de um pacote chamado `transmogrify`:

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

### Publique no pub.dev {:#publish-to-pub-dev}

Para publicar seu pacote quando ele estiver pronto, remova o argumento `--dry-run`:

```console
$ dart pub publish
```

Com esse comando, o `dart pub` executa as seguintes tarefas:

1. Verifica se o seu pacote segue o [formato do pubspec][pubspec] e as
   [convenções de layout do pacote][pkg-layout].

1. Valida se o `git status` está limpo. Emite um aviso se
   arquivos rastreados pelo git tiverem alterações não commitadas.

1. Mostra todos os arquivos que pretende publicar.

1. Envia seu pacote para o [pub.dev]({{site.pub}}).

:::note
O comando pub não oferece suporte à publicação direta de um novo pacote em um
publisher verificado. Como solução temporária, publique os novos pacotes em uma Conta Google
e depois [transfira o pacote para um publisher](#transferring-a-package-to-a-verified-publisher).

Quando um pacote tiver sido transferido para um publisher,
você poderá atualizá-lo usando `dart pub publish`.
:::

Depois que o seu pacote for enviado com sucesso para o pub.dev, qualquer usuário do pub pode
baixá-lo ou depender dele nos seus projetos.

Por exemplo, se você acabou de publicar a versão 1.0.0 do seu pacote `transmogrify`,
outro desenvolvedor Dart pode adicioná-lo como dependência no `pubspec.yaml` dele:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

### Detecte as plataformas suportadas {:#detect-supported-platforms}

O [site pub.dev]({{site.pub}}) detecta quais plataformas um pacote suporta
e exibe essas plataformas na página do pacote.
Os usuários do pub.dev podem filtrar buscas por plataforma.

Para alterar a lista gerada de plataformas suportadas,
[especifique as plataformas suportadas][specify supported platforms] no arquivo `pubspec.yaml`.

[specify supported platforms]: /tools/pub/pubspec#platforms

### Automatize a publicação {:#automate-publishing}

Depois de publicar a primeira versão de um pacote,
você pode configurar a publicação automatizada
por meio do GitHub Actions ou de contas de serviço do Google Cloud.
Para saber mais sobre a publicação automatizada, consulte
[Publicação automatizada de pacotes no pub.dev](/tools/pub/automated-publishing).

### Publique versões prévias (prerelease) {:#publishing-prereleases}

Enquanto trabalha em um pacote, considere publicá-lo como prerelease.
Prereleases podem ser úteis quando:

* Você está desenvolvendo ativamente a próxima versão principal do pacote.
* Você quer testadores beta para o próximo release candidate do pacote.
* O pacote depende de uma versão instável do SDK do Dart ou do Flutter.

Como descrito no [versionamento semântico][semver],
para criar uma prerelease de uma versão, adicione um sufixo à versão.
Por exemplo, para criar uma prerelease da versão `2.0.0`,
você pode usar a versão `2.0.0-dev.1`.
Depois, quando você lançar a versão `2.0.0`, ela terá precedência sobre todas as
prereleases `2.0.0-XXX`.

Como o pub prefere releases estáveis quando disponíveis, os usuários de um pacote em prerelease
podem precisar alterar as restrições de dependência.
Por exemplo, se um usuário quer testar prereleases da versão `2.1.0`, então,
em vez de `^2.0.0` ou `^2.1.0`, ele pode especificar `^2.1.0-dev.1`.

:::note
Embora o `pub` prefira releases estáveis da mesma forma que prefere versões mais novas,
o resolvedor de versões não tenta todas as soluções e pode escolher uma prerelease,
mesmo quando existe uma resolução que não usa prereleases.
Isso raramente acontece na prática.
:::

Quando você publica uma prerelease no pub.dev,
a página do pacote exibe links para a prerelease e para a release estável.
A prerelease não afeta a pontuação de análise, não aparece nos resultados de busca
nem substitui o `README.md` e a documentação do pacote.

### Publique versões de preview {:#publish-preview-versions}

Previews podem ser úteis quando _todas_ as condições a seguir são verdadeiras:

* A próxima versão estável do pacote está concluída.
* Essa versão do pacote depende de uma API ou recurso do Dart SDK que
  ainda não foi lançado em uma versão estável do Dart SDK.
* Você sabe que a API ou o recurso do qual o pacote depende é
  estável em termos de API e não vai mudar antes de chegar ao SDK estável.

Como exemplo, considere uma nova versão do `package:args` que tem
uma versão finalizada `2.0.0`.
Ela depende de um recurso do Dart `3.0.0-417.1.beta`.
No entanto, a versão estável do Dart SDK `3.0.0` ainda não foi lançada.
O arquivo `pubspec.yaml` pode ficar assim:

```yaml title="pubspec.yaml"
name: args
version: 2.0.0

environment:
  sdk: '^3.0.0-417.1.beta'
```

Quando você publica esse pacote no pub.dev, ele é marcado como uma versão de preview.
A captura de tela a seguir ilustra isso.
Ela lista a versão estável como `1.6.0` e a versão de preview como `2.0.0`.

![Ilustração de uma versão de preview](/assets/img/tools/pub/preview-version.png){:width="600px"}

Quando o Dart lançar a versão estável `3.0.0`,
o pub.dev atualiza a listagem do pacote para exibir
`2.0.0` como a versão (estável) mais recente do pacote.

Se todas as condições no início desta seção forem verdadeiras,
ignore o seguinte aviso do `dart pub publish`:

   _"Packages with an SDK constraint on a pre-release of the Dart SDK should
   themselves be published as a pre-release version. If this package needs Dart
   version 3.0.0-0, consider publishing the package as a pre-release
   instead."_

## Gerencie as permissões de publicação {:#manage-publishing-permissions}

### Encontre o publisher do pacote {:#locate-the-package-publisher}

Se um pacote tem um publisher verificado,
a página do pacote no pub.dev exibe o domínio do publisher.

Para pacotes publicados sem um publisher,
o pub.dev não divulga o publisher por motivos de privacidade.
O campo **Publisher** exibe "unverified uploader".

### Gerencie os uploaders do pacote {:#uploaders}

Quem publica a primeira versão de um pacote se torna
a primeira e _única_ pessoa autorizada a enviar versões adicionais
desse pacote.

Para permitir ou proibir que outras pessoas enviem versões, faça uma das seguintes ações:

* Gerencie os uploaders autorizados na página de administração do pacote:
  `https://pub.dev/packages/<package>/admin`.
* Transfira o pacote para um [publisher verificado][verified publisher];
  todos os membros de um publisher estão autorizados a enviar.

:::tip
Convide outros membros da sua equipe para se tornarem uploaders do pacote.
Isso garante que sua equipe tenha acesso ao pacote quando você não estiver disponível.
:::

### Transfira um pacote para um publisher verificado {:#transferring-a-package-to-a-verified-publisher}

Para transferir um pacote para um publisher verificado,
você precisa ser um [uploader](#uploaders) do pacote
e um administrador do publisher verificado.

:::important
_Você não pode reverter este processo._ Depois que você transferir um pacote para um publisher,
não é possível transferi-lo de volta para uma conta individual.
:::

Para transferir um pacote para um publisher verificado:

1. Faça login no [pub.dev]({{site.pub}}) com uma Conta Google que esteja listada como
   uploader do pacote.

1. Acesse a página de detalhes do pacote (por exemplo,
   `{{site.pub-pkg}}/http`).

1. Selecione a aba **Admin**.

1. Digite o nome do publisher e clique em **Transfer to Publisher**.

## Gerencie seu pacote {:#manage-your-package}

### Retraia uma versão do pacote {:#retract}

Para impedir que novos consumidores do pacote adotem uma versão publicada
do seu pacote dentro de uma janela de sete dias,
você pode retrair essa versão do pacote em até sete dias após a publicação.
A versão retraída pode ser restaurada novamente em até sete dias após a retração.

_Retração não é exclusão._
Uma versão retraída do pacote aparece na listagem de versões do pacote
no pub.dev, na seção **Retracted versions**.
A visualização detalhada dessa versão do pacote exibe um selo **RETRACTED**.

Antes de retrair um pacote, considere publicar uma nova versão.
Retrair um pacote pode ter um impacto negativo para os usuários do pacote.

Se você publicar uma nova versão com
uma _restrição de dependência ausente_
ou uma _restrição de dependência frouxa_,
então retrair a versão do pacote pode ser a única solução.
Publicar uma versão mais nova do seu pacote não impede que o
resolvedor de versões escolha a versão antiga.
Essa pode ser a única versão que o pub consegue escolher.
Retrair uma versão do pacote com restrições de dependência incorretas
força os usuários a atualizar outras dependências ou a enfrentar um conflito de dependência.

No entanto, se o seu pacote tiver um bug pequeno,
talvez você não precise retrair a versão.
Publique uma versão mais nova com o bug corrigido e uma
descrição da correção no `CHANGELOG.md`.
Isso ajuda os usuários a entender o que aconteceu.
Publicar uma versão mais nova é menos disruptivo para os usuários do pacote.

:::version-note
A retração de pacotes foi introduzida no Dart 2.15.
Em SDKs anteriores à 2.15, o resolvedor de versões do pub ignora o status de retraído.
:::

#### Como usar uma versão retraída de um pacote {:#how-to-use-a-retracted-version-of-a-package}

Se um pacote depende de uma versão de pacote que depois foi retraída,
ele ainda pode usar essa versão enquanto ela estiver no
arquivo `pubspec.lock` do pacote dependente.
Para depender de uma versão específica que já foi retraída,
o pacote dependente deve fixar a versão na
seção `dependency_overrides` do arquivo `pubspec.yaml`.

#### Como migrar para longe de uma versão retraída do pacote {:#how-to-migrate-away-from-a-retracted-package-version}

Quando um pacote depende de uma versão retraída,
você tem opções para migrar dessa versão, dependendo
das outras versões disponíveis.

#### Atualize para uma versão mais nova {:#upgrade-to-a-newer-version}

Na maioria dos casos, uma versão mais nova foi publicada para
substituir a versão retraída.
Nesse caso, execute `dart pub upgrade <package>`.

#### Faça downgrade para a versão mais nova não retraída {:#downgrade-to-the-newest-non-retracted-version}

Se nenhuma versão mais nova estiver disponível, considere fazer downgrade
para a versão mais nova não retraída.
Você pode fazer isso de duas formas.

1. Use os comandos da [ferramenta pub](/tools/pub/cmd):

   1. Execute `dart pub downgrade <package>` para
      obter a versão mais baixa do pacote especificado que
      corresponda às restrições do arquivo `pubspec.yaml`.

   1. Execute `dart pub upgrade <package>` para obter a
      versão mais nova compatível e não retraída disponível.

1. Edite o arquivo `pubspec.lock` na sua IDE preferida:

   1. Apague a entrada inteira do pacote com a
      versão retraída.

   1. Execute `dart pub get` para obter a
      versão mais nova compatível e não retraída disponível.

Embora você pudesse apagar o arquivo `pubspec.lock` e executar `dart pub get`,
isso não é recomendado.
Pode resultar em mudanças de versão em outras dependências.

#### Atualize ou faça downgrade para uma versão fora da restrição de versão especificada {:#upgrade-or-downgrade-to-a-version-outside-the-specified-version-constraint}

Se não houver uma versão alternativa disponível que satisfaça a
restrição de versão atual, edite a restrição de versão no
arquivo `pubspec.yaml` e execute `dart pub upgrade`.

#### Como retrair ou restaurar uma versão do pacote {:#how-to-retract-or-restore-a-package-version}

Para retrair ou restaurar uma versão do pacote,
primeiro faça login no pub.dev usando uma Conta Google
que seja um uploader ou um administrador de [publisher verificado][verified publisher] do pacote.
Depois, acesse a aba **Admin** do pacote,
onde você pode retrair ou restaurar versões recentes do pacote.

### Descontinue um pacote {:#discontinue}

Embora os pacotes permaneçam publicados, você pode sinalizar aos
desenvolvedores que um pacote não recebe manutenção ativa.
Para isso, você precisa marcar o pacote como **descontinuado**.

Depois que você descontinua um pacote, ele vai:

* Continuar publicado no pub.dev.
* Continuar visível no pub.dev.
* Exibir um selo claro **DISCONTINUED**.
* Não aparecer nos resultados de busca do pub.dev.

Para marcar um pacote como descontinuado:

1. Faça login no pub.dev usando uma Conta Google com permissões de uploader ou de
   [publisher verificado][verified publisher] para o pacote.

1. Acesse a aba **Admin** do pacote.

1. Para descontinuar um pacote, selecione **Mark "discontinued"**.

Você também pode recomendar um pacote substituto.

1. No campo em **Suggested replacement**,
   digite o nome de outro pacote.

1. Clique em **Update "Suggested Replacement"**.

Se mudar de ideia, você pode remover a marca de descontinuado a qualquer momento.

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
