---
ia-translate: true
title: Publicando pacotes
description: Aprenda como publicar um pacote Dart no pub.dev.
---

O [gerenciador de pacotes pub][pub] não serve apenas para usar pacotes de outras pessoas.
Ele também permite que você compartilhe seus pacotes com o mundo. Se você tem um projeto
útil e quer que outros possam usá-lo, use o
comando `dart pub publish`.

:::note
Para publicar em um local diferente do pub.dev,
ou para impedir a publicação em qualquer lugar, use o campo `publish_to`,
conforme definido no [pubspec][pubspec].
:::

Assista ao vídeo a seguir para uma visão geral da construção e publicação de pacotes.

{% ytEmbed "8V_TLiWszK0", "Como construir um pacote em Dart" %}

## Lembre-se: Publicar é para sempre {:#remember-publishing-is-forever}

Tenha em mente que um pacote publicado dura para sempre.
Assim que você publica seu pacote, os usuários podem depender dele.
Uma vez que eles começam a depender dele, remover o pacote quebraria os deles.
Para evitar isso, a [política do pub.dev][policy]
não permite a não publicação de pacotes, exceto em casos muito raros.

Você sempre pode fazer upload de novas versões do seu pacote,
mas as antigas permanecem disponíveis para os usuários que ainda não podem atualizar.

Para pacotes publicados que perderam a relevância ou carecem de manutenção,
[marque-os como descontinuados](#discontinue).

## Prepare seu pacote para publicação {:#prepare-your-package-for-publication}

Ao publicar um pacote, siga as convenções encontradas no
[formato pubspec][pubspec] e na estrutura de [layout do pacote][pkg-layout].
Para simplificar o uso do seu pacote, o Dart exige essas convenções.
Essas convenções contêm algumas exceções observadas nos guias vinculados.
Quando invocado, o `pub` aponta quais mudanças você pode fazer para que seu pacote
funcione melhor dentro do ecossistema Dart.

Além dessas convenções, você deve seguir estes requisitos:

* Inclua um arquivo `LICENSE` em seu pacote.
  Recomendamos a [licença BSD de 3 cláusulas][BSD 3-clause license],
  que as equipes Dart e Flutter normalmente usam.
  No entanto, você pode usar qualquer licença apropriada para o seu pacote.

* Verifique se você tem o direito legal de redistribuir qualquer coisa que
  você envie como parte do seu pacote.

* Mantenha o tamanho do pacote menor que 100 MB após a compressão gzip.
  Se for muito grande, considere dividi-lo em vários pacotes,
  usando um arquivo `.pubignore` para remover conteúdo desnecessário,
  ou reduzindo o número de recursos ou exemplos incluídos.

* Faça com que seu pacote dependa apenas de dependências hospedadas
  do servidor de pacotes pub padrão e dependências do SDK
  (`sdk: flutter`).
  Essas restrições garantem que as dependências de seus pacotes
  possam ser encontradas e acessadas no futuro.

* Possua uma [Conta do Google][Google Account]. O Pub usa uma conta do Google
  para gerenciar permissões de envio de pacotes.
  Sua Conta do Google pode ser associada a um endereço do Gmail ou qualquer outro endereço de e-mail.

### Preencha sua página web do pub.dev {:#populate-your-pub-dev-web-page}

O Pub usa o conteúdo de alguns arquivos para criar uma página para o seu
pacote em `pub.dev/packages/<seu_pacote>`.
Os seguintes arquivos afetam o conteúdo da página da web do seu pacote.

**`README.md`**
  : Este arquivo contém o conteúdo principal apresentado na
  página da web do seu pacote.
  O conteúdo do arquivo deve ser marcado usando [Markdown][Markdown].
  Para aprender como escrever um ótimo README (leia-me), consulte
  [Escrevendo páginas de pacotes](/tools/pub/writing-package-pages).

**`CHANGELOG.md`**
  : Se encontrado, este arquivo preenche sua própria aba na página da web do seu pacote.
  Os desenvolvedores podem ler suas mudanças diretamente do pub.dev.
  O conteúdo do arquivo deve ser marcado usando [Markdown][Markdown].

**`pubspec.yaml`**
  : Este arquivo preenche detalhes sobre seu pacote
  no lado direito da página da web do seu pacote.
  O conteúdo do arquivo deve seguir as convenções YAML.
  Esses detalhes incluem descrição, página inicial e similares.

### Vantagens de usar um editor verificado {:#verified-publisher}

Você pode publicar pacotes usando um editor verificado (recomendado)
ou uma Conta do Google independente.
Usar um editor verificado tem as seguintes vantagens:

* Os consumidores do seu pacote sabem que o domínio do editor foi verificado.
* Você pode evitar que o pub.dev exiba seu endereço de e-mail pessoal.
  Em vez disso, o pub.dev exibe o domínio do editor e o endereço de contato.
* O site pub.dev exibe um selo de editor verificado
  <img src="/assets/img/verified-publisher.svg" class="text-icon" alt="logotipo de editor verificado do pub.dev">
  ao lado do nome do seu pacote nas páginas de pesquisa e nas páginas de pacotes individuais.

### Crie um editor verificado {:#create-verified-publisher}

Para criar um [editor verificado][create-verified-publisher], siga estas etapas:

1. Vá para [pub.dev]({{site.pub}}).

1. Faça login no pub.dev usando uma Conta do Google.

1. No menu do usuário no canto superior direito, selecione **Criar Editor**.

1. Digite o nome de domínio que você deseja associar ao seu editor
   (por exemplo, `dartbrasil.dev`).

1. Clique em **Criar Editor**.

1. Na caixa de diálogo de confirmação, selecione **OK**.

1. Se solicitado, conclua o fluxo de verificação.
   Isso abre o [Google Search Console][google-search].

   * Ao adicionar registros DNS,
     algumas horas podem se passar antes que o Search Console reflita as mudanças.
   * Quando o fluxo de verificação estiver concluído, volte para a etapa 4.

:::tip
Recomendamos fortemente que você convide outros membros da sua
organização para serem membros do editor verificado.
Isso ajuda a garantir que sua organização retenha o acesso ao
editor quando você não estiver disponível.
:::

## Publique seu pacote {:#publish-your-package}

Use o comando [`dart pub publish`][`dart pub publish`] para publicar seu pacote
pela primeira vez ou para atualizá-lo para uma nova versão.

### Quais arquivos são publicados? {:#what-files-are-published}

O pacote publicado inclui **todos os arquivos** no diretório raiz do pacote,
com as seguintes exceções:

* Quaisquer arquivos ou diretórios _ocultos_.
  Estes têm nomes que começam com ponto (`.`).
* Arquivos e diretórios listados para serem ignorados em um
  arquivo `.pubignore` ou `.gitignore`

Para usar regras de ignorar diferentes para `git` e `dart pub publish`,
crie um arquivo `.pubignore` para substituir o
arquivo `.gitignore` em um determinado diretório.
Se um diretório contiver um arquivo `.pubignore` e um arquivo `.gitignore`,
então `dart pub publish` _ignora_ o arquivo `.gitignore` desse diretório.
Os arquivos `.pubignore` seguem o mesmo formato que o
[arquivo `.gitignore`][git-ignore-format].

Para evitar a publicação de arquivos indesejados, siga estas práticas:

* Exclua todos os arquivos que você não deseja incluir ou adicione-os
  a um arquivo `.pubignore` ou `.gitignore`.
* Ao fazer o upload do seu pacote,
  examine a lista de arquivos que
  `dart pub publish --dry-run` mostra que irá publicar.
  Cancele o upload se algum arquivo indesejado aparecer nessa lista.

:::note
A maioria dos pacotes não precisa de um arquivo `.pubignore`.
Para saber mais sobre cenários úteis para isso,
consulte esta [resposta do StackOverflow][pubignore-when].
:::

### Teste a publicação do seu pacote {:#test-publishing-your-package}

Para testar como o `dart pub publish` irá funcionar, você pode executar uma simulação:

```console
$ dart pub publish --dry-run
```

Com este comando, o `dart pub` executa as seguintes tarefas:

1. Verifica se o seu pacote segue o [formato pubspec][pubspec] e as
   [convenções de layout do pacote][pkg-layout].

1. Mostra todos os arquivos que ele pretende publicar.

O exemplo a seguir mostra o teste de publicação de um pacote chamado `transmogrify`:

```plaintext
Publicando transmogrify 1.0.0
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

Pacote tem 0 avisos.
```

### Publique no pub.dev {:#publish-to-pub-dev}

Para publicar seu pacote quando ele estiver pronto, remova o argumento `--dry-run`:

```console
$ dart pub publish
```

Com este comando, o `dart pub` executa as seguintes tarefas:

1. Verifica se o seu pacote segue o [formato pubspec][pubspec] e as
   [convenções de layout do pacote][pkg-layout].

1. Valida que `git status` está limpo. Alerta se
   arquivos que são rastreados no git têm mudanças não confirmadas.

1. Mostra todos os arquivos que ele pretende publicar.

1. Envia seu pacote para [pub.dev]({{site.pub}}).

:::note
O comando pub não suporta a publicação direta de um novo pacote em um
editor verificado. Como uma solução alternativa temporária, publique novos pacotes em uma Conta do Google,
e então [transfira o pacote para um editor](#transferring-a-package-to-a-verified-publisher).

Depois que um pacote for transferido para um editor,
você pode atualizar o pacote usando `dart pub publish`.
:::

Depois que seu pacote for enviado com sucesso para o pub.dev, qualquer usuário do pub poderá
baixá-lo ou depender dele em seus projetos.

Por exemplo, se você acabou de publicar a versão 1.0.0 do seu pacote `transmogrify`,
então outro desenvolvedor Dart pode adicioná-lo como uma dependência em seu `pubspec.yaml`:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

### Detectar plataformas suportadas {:#detect-supported-platforms}

O [site pub.dev]({{site.pub}}) detecta quais plataformas um pacote suporta,
exibindo essas plataformas na página do pacote.
Os usuários do pub.dev podem filtrar as pesquisas por plataforma.

Para alterar a lista gerada de plataformas suportadas,
[especifique as plataformas suportadas][especifique as plataformas suportadas] no arquivo `pubspec.yaml`.

[especifique as plataformas suportadas]: /tools/pub/pubspec#platforms

### Automatize a publicação {:#automate-publishing}

Depois de publicar a primeira versão de um pacote,
você pode configurar a publicação automatizada
por meio do GitHub Actions ou de contas de serviço do Google Cloud.
Para saber mais sobre publicação automatizada, consulte
[Publicação automatizada de pacotes no pub.dev](/tools/pub/automated-publishing).

### Publique versões de pré-lançamento {:#publishing-prereleases}

Enquanto você trabalha em um pacote, considere publicá-lo como um pré-lançamento.
Pré-lançamentos podem ser úteis quando:

* Você está desenvolvendo ativamente a próxima versão principal do pacote.
* Você quer beta testers para o próximo release candidate do pacote.
* O pacote depende de uma versão instável do Dart ou Flutter SDK.

Conforme descrito em [versionamento semântico][semver],
para fazer um pré-lançamento de uma versão, acrescente um sufixo à versão.
Por exemplo, para fazer um pré-lançamento da versão `2.0.0`,
você pode usar a versão `2.0.0-dev.1`.
Mais tarde, quando você lançar a versão `2.0.0`, ela terá precedência sobre todos os
pré-lançamentos `2.0.0-XXX`.

Como o pub prefere lançamentos estáveis quando disponíveis, os usuários de um pacote de pré-lançamento
podem precisar alterar suas restrições de dependência.
Por exemplo, se um usuário quiser testar pré-lançamentos da versão `2.1.0`, então
em vez de `^2.0.0` ou `^2.1.0`, eles podem especificar `^2.1.0-dev.1`.

:::note
Embora o `pub` prefira lançamentos estáveis da mesma forma que prefere versões mais recentes,
o solucionador de versão não tenta todas as soluções e pode escolher um pré-lançamento,
mesmo quando existe uma resolução que não usa pré-lançamentos.
Embora isso raramente aconteça na prática.
:::

Quando você publica um pré-lançamento no pub.dev,
a página do pacote exibe links para o pré-lançamento e o lançamento estável.
O pré-lançamento não afeta a pontuação da análise, não aparece nos resultados da pesquisa,
ou substitui o `README.md` e a documentação do pacote.

### Publique versões de visualização {:#publish-preview-versions}

As visualizações podem ser úteis quando _todas_ as seguintes condições forem verdadeiras:

* A próxima versão estável do pacote está completa.
* Essa versão do pacote depende de uma API ou recurso no Dart SDK que
  ainda não foi lançado em uma versão estável do Dart SDK.
* Você sabe que a API ou recurso do qual o pacote depende é
  API-estável e não mudará antes de atingir o SDK estável.

Como exemplo, considere uma nova versão do `package:args` que tem
uma versão finalizada `2.0.0`.
Ela depende de um recurso no Dart `3.0.0-417.1.beta`.
No entanto, a versão estável do Dart SDK `3.0.0` ainda não foi lançada.
O arquivo `pubspec.yaml` pode ser assim:

```yaml title="pubspec.yaml"
name: args
version: 2.0.0

environment:
  sdk: '^3.0.0-417.1.beta'
```

Quando você publica este pacote no pub.dev, ele é marcado como uma versão de visualização (preview).
A captura de tela a seguir ilustra isso.
Ela lista a versão estável como `1.6.0` e a versão de visualização como `2.0.0`.

![Ilustração de uma versão de visualização](/assets/img/tools/pub/preview-version.png){:width="600px"}<br>

Quando o Dart lança a versão estável `3.0.0`,
o pub.dev atualiza a listagem do pacote para exibir
`2.0.0` como a versão mais recente (estável) do pacote.

Se todas as condições no início desta seção forem verdadeiras,
ignore o seguinte aviso de `dart pub publish`:

   _"Pacotes com uma restrição de SDK em um pré-lançamento do Dart SDK devem
   eles mesmos serem publicados como uma versão de pré-lançamento. Se este pacote precisar do Dart
   versão 3.0.0-0, considere publicar o pacote como um pré-lançamento
   em vez disso."_

## Gerenciar permissões de publicação {:#manage-publishing-permissions}

### Localize o editor do pacote {:#locate-the-package-publisher}

Se um pacote tiver um editor verificado,
a página pub.dev desse pacote exibirá o domínio do editor.

Para pacotes publicados sem um editor,
o pub.dev não divulga o editor por motivos de privacidade.
O campo **Editor** exibe "uploader não verificado".

### Gerenciar uploaders de pacote {:#uploaders}

Quem publica a primeira versão de um pacote torna-se
a primeira e _única_ pessoa autorizada a enviar versões adicionais
desse pacote.

Para permitir ou não que outras pessoas enviem versões, você pode:

* Gerenciar uploaders autorizados na página de administração do pacote:
  `https://pub.dev/packages/<pacote>/admin`.
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
_Você não pode reverter este processo._ Depois de transferir um pacote para um editor,
você não pode transferi-lo de volta para uma conta individual.
:::

Para transferir um pacote para um editor verificado:

1. Faça login no [pub.dev]({{site.pub}}) com uma Conta do Google que esteja listada como
   um uploader do pacote.

1. Vá para a página de detalhes do pacote (por exemplo,
   `{{site.pub-pkg}}/http`).

1. Selecione a aba **Admin**.

1. Digite o nome do editor e clique em **Transferir para o Editor**.

## Gerencie seu pacote {:#manage-your-package}

### Retratar uma versão do pacote {:#retract}

Para impedir que novos consumidores de pacotes adotem uma versão publicada
do seu pacote em um período de sete dias,
você pode retirar essa versão do pacote em até sete dias após a publicação.
A versão retirada pode ser restaurada novamente em até sete dias após a retirada.

_Retração não é exclusão._
Uma versão de pacote retirada aparece na listagem de versões
do pacote no pub.dev na seção **Versões Retiradas**.
A visualização detalhada dessa versão do pacote exibe um selo **RETIRADO**.

Antes de retirar um pacote, considere publicar uma nova versão.
Retirar um pacote pode ter um impacto negativo nos usuários do pacote.

Se você publicar uma nova versão com
uma _restrição de dependência faltando_
ou uma _restrição de dependência relaxada_,
então retirar a versão do pacote pode ser a única solução.
Publicar uma versão mais recente do seu pacote não impedirá a versão
solver de escolher a versão antiga.
Essa versão pode ser a única versão que o pub pode escolher.
Retirar uma versão de pacote com restrições de dependência incorretas
força os usuários a atualizar outras dependências ou obter um conflito de dependência.

No entanto, se seu pacote contiver um pequeno bug,
você pode não precisar retirar a versão.
Publique uma versão mais recente com o bug corrigido e uma
descrição do bug corrigido em `CHANGELOG.md`.
Isso ajuda os usuários a entender o que aconteceu.
Publicar uma versão mais recente é menos prejudicial para os usuários do pacote.

:::version-note
A retração de pacotes foi introduzida no Dart 2.15.
Em SDKs pré-2.15, o solucionador de versão do pub ignora o status retirado.
:::

#### Como usar uma versão retirada de um pacote {:#how-to-use-a-retracted-version-of-a-package}

Se um pacote depender de uma versão de pacote que mais tarde for retirada,
ele ainda pode usar essa versão, desde que essa versão esteja no
arquivo `pubspec.lock` do pacote dependente.
Para depender de uma versão específica que já foi retirada,
o pacote dependente deve fixar a versão na
seção `dependency_overrides` do arquivo `pubspec.yaml`.

#### Como migrar de uma versão de pacote retirada {:#how-to-migrate-away-from-a-retracted-package-version}

Quando um pacote depende de uma versão de pacote retirada,
você tem opções de como migrar dessa versão, dependendo
de outras versões disponíveis.

#### Atualizar para uma versão mais recente {:#upgrade-to-a-newer-version}

Na maioria dos casos, uma versão mais recente foi publicada para
substituir a versão retirada.
Nesse caso, execute `dart pub upgrade <pacote>`.

#### Fazer downgrade para a versão não retirada mais recente {:#downgrade-to-the-newest-non-retracted-version}

Se nenhuma versão mais recente estiver disponível, considere fazer downgrade
para a versão não retirada mais recente.
Você pode fazer isso de uma das duas maneiras.

1. Use os comandos da [ferramenta pub](/tools/pub/cmd):

   1. Execute `dart pub downgrade <pacote>` para
      obter a versão mais baixa do pacote especificado que
      corresponde às restrições no arquivo `pubspec.yaml`.

   1. Execute `dart pub upgrade <pacote>` para obter a
      versão mais recente compatível e não retirada disponível.

1. Edite o arquivo `pubspec.lock` em seu IDE preferido:

   1. Exclua a entrada inteira do pacote para o pacote
      com a versão retirada.

   1. Execute `dart pub get` para obter a
      versão mais recente compatível e não retirada disponível.

Embora você possa excluir o arquivo `pubspec.lock` e executar `dart pub get`,
isso não é recomendado.
Pode resultar em alterações de versão para outras dependências.

#### Atualizar ou fazer downgrade para uma versão fora da restrição de versão especificada {:#upgrade-or-downgrade-to-a-version-outside-the-specified-version-constraint}

Se não houver uma versão alternativa disponível que satisfaça o
restrição de versão atual, edite a restrição de versão
no arquivo `pubspec.yaml` e execute `dart pub upgrade`.

#### Como retirar ou restaurar uma versão de pacote {:#how-to-retract-or-restore-a-package-version}

Para retirar ou restaurar uma versão de pacote,
primeiro faça login no pub.dev usando uma Conta do Google
que seja um uploader ou um administrador de [editor verificado][verified publisher] para o pacote.
Em seguida, vá para a aba **Admin** do pacote,
onde você pode retirar ou restaurar versões de pacotes recentes.

### Descontinuar um pacote {:#discontinue}

Embora os pacotes permaneçam publicados, você pode sinalizar para
desenvolvedores que um pacote não recebe manutenção ativa.
Isso exige que você marque o pacote como **descontinuado**.

Depois de descontinuar um pacote, o pacote:

* Permanecerá publicado no pub.dev.
* Permanecerá visível no pub.dev.
* Exibirá um selo **DESCONTINUADO** claro.
* Não aparecerá nos resultados de pesquisa do pub.dev.

Para marcar um pacote como descontinuado:

1. Faça login no pub.dev usando uma Conta do Google com uploader ou
   permissões de [editor verificado][verified publisher] para o pacote.

1. Navegue até a aba **Admin** do pacote.

1. Para descontinuar um pacote, selecione **Marcar como "descontinuado"**.

Você também pode recomendar um pacote de substituição.

1. No campo em **Substituição sugerida**,
   digite o nome de outro pacote.

1. Clique em **Atualizar "Substituição Sugerida"**.

Se você mudar de ideia, você pode remover a marca de descontinuado a qualquer momento.

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