---
ia-translate: true
title: Publicação automatizada de pacotes no pub.dev
shortTitle: Publicação automatizada
description: Publique pacotes Dart no pub.dev diretamente pelo GitHub Actions.
---

Você pode automatizar a publicação a partir de:
* [GitHub Actions](https://github.com/features/actions),
* [Google Cloud Build][9] ou,
* De qualquer outro lugar, usando uma [service account do GCP][2].

As seções a seguir explicam como a publicação automatizada é configurada e
como você pode personalizar os fluxos de publicação de acordo com as suas preferências.

Ao configurar a publicação automatizada, você não precisa criar um segredo de longa duração
que seja copiado para o seu ambiente de deploy automatizado.
Em vez disso, a autenticação depende de tokens OpenID Connect temporários, assinados por
GitHub Actions (veja [OIDC para GitHub Actions][1]) ou pelo Google Cloud IAM.

Você pode usar _chaves exportadas de service account_ em ambientes de deploy
onde não há um serviço de identidade disponível.
Essas chaves exportadas são segredos de longa duração; elas podem ser mais fáceis
de usar em alguns ambientes, mas representam um risco maior caso vazem acidentalmente.

:::note
Hoje, você só pode automatizar a publicação de pacotes que já existem.
Para criar um novo pacote, você precisa publicar a primeira versão usando
`dart pub publish`.
:::

## Publicando pacotes usando GitHub Actions {:#publishing-packages-using-github-actions}

Você pode configurar a publicação automatizada usando GitHub Actions. Isso envolve:

* Habilitar a publicação automatizada no pub.dev, especificando:

  * O repositório do GitHub e,
  * Um _tag-pattern_ que deve corresponder para permitir a publicação.

* Criar um _workflow_ do GitHub Actions para publicar no pub.dev.
* Enviar uma _git tag_ para a versão que será publicada.

As seções a seguir descrevem como concluir essas etapas.

:::note
O pub.dev só permite a publicação automatizada a partir do GitHub Actions quando o
_workflow_ é acionado pelo envio de uma git tag para o GitHub.
O pub.dev rejeita publicações feitas a partir de GitHub Actions acionadas sem uma tag.
Isso garante que novas versões não possam ser publicadas por eventos que nunca
deveriam acionar uma publicação.
:::

### Configurando a publicação automatizada a partir do GitHub Actions no pub.dev {:#configuring-automated-publishing-from-github-actions-on-pubdev}

Para habilitar a publicação automatizada do GitHub Actions para o `pub.dev`, você precisa ser:

* Um _uploader_ do pacote, ou,
* Um _admin_ do publisher (se o pacote pertencer a um publisher).

Se você tiver permissão suficiente, pode habilitar a publicação automatizada da seguinte forma:

1. Acesse a aba **Admin** (`pub.dev/packages/<package>/admin`).
1. Encontre a seção **Automated publishing**.
1. Clique em **Enable publishing from GitHub Actions**. Isso solicita que você
   especifique:

   * Um repositório (`<organization>/<repository>`, exemplo: `dart-lang/pana`),
   * Um _tag-pattern_ (uma string que contém `{% raw %}{{version}}{% endraw %}`).

O _repositório_ é o `<organization>/<repository>` no GitHub.
Por exemplo, se o seu repositório for
`https://github.com/dart-lang/pana`, você deve especificar `dart-lang/pana` no
campo de repositório.

O _tag pattern_ é uma string que deve conter `{% raw %}{{version}}{% endraw %}`.
Somente GitHub Actions acionadas por um push de uma tag que corresponda a este
_tag pattern_ poderão publicar o seu pacote.

![Configuração de publicação a partir do GitHub Actions no pub.dev](/assets/img/tools/pub/pub-dev-gh-setup.png)

**Exemplo:** um _tag pattern_ como `v{% raw %}{{version}}{% endraw %}` permite que
GitHub Actions (acionadas por `git tag v1.2.3 && git push v1.2.3`) publiquem a
versão `1.2.3` do seu pacote. Por isso, também é importante que a chave `version` no
`pubspec.yaml` corresponda a este número de versão.

Se o seu repositório contiver vários pacotes, dê a cada um um
_tag-pattern_ separado. Considere usar um _tag-pattern_ como
`my_package_name-v{% raw %}{{version}}{% endraw %}` para um pacote
chamado `my_package_name`.

### Configurando um workflow do GitHub Action para publicar no pub.dev {:#configuring-a-github-action-workflow-for-publishing-to-pubdev}

Quando a publicação automatizada a partir do GitHub Actions está habilitada no pub.dev,
você pode criar um workflow do GitHub Actions para publicação. Isso é feito
criando um arquivo `.github/workflows/publish.yml` da seguinte forma:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    # must align with the tag-pattern configured on pub.dev, often just replace
      # {% raw %}{{version}}{% endraw %} with [0-9]+.[0-9]+.[0-9]+
    - 'v[0-9]+.[0-9]+.[0-9]+' # tag-pattern on pub.dev: 'v{% raw %}{{version}}{% endraw %}'
    # If you prefer tags like '1.2.3', without the 'v' prefix, then use:
    # - '[0-9]+.[0-9]+.[0-9]+' # tag-pattern on pub.dev: '{% raw %}{{version}}{% endraw %}'
    # If your repository contains multiple packages consider a pattern like:
    # - 'my_package_name-v[0-9]+.[0-9]+.[0-9]+'

# Publish using the reusable workflow from dart-lang.
jobs:
  publish:
    permissions:
      id-token: write # Required for authentication using OIDC
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    # with:
    #   working-directory: path/to/package/within/repository
```

Certifique-se de que o padrão em `on.push.tags` corresponda ao _tag pattern_
especificado no pub.dev. Caso contrário, o workflow do GitHub Action não funcionará.
Se você publicar vários pacotes a partir do mesmo repositório,
use um _tag pattern_ por pacote, como
`my_package_name-v{% raw %}{{version}}{% endraw %}`, e
crie um arquivo de workflow separado para cada pacote.

O arquivo de workflow acima usa
`dart-lang/setup-dart/.github/workflows/publish.yml` para publicar o pacote.
Trata-se de um [workflow reutilizável][3] que permite que a equipe do Dart mantenha
a lógica de publicação e que o pub.dev saiba como o pacote foi publicado.
Recomenda-se fortemente usar este _workflow reutilizável_.

Se o seu pacote precisar de código gerado, é preferível versionar esse
código gerado no seu repositório.
Isso simplifica a verificação de que os arquivos publicados no pub.dev correspondem
aos arquivos do seu repositório. Se versionar código gerado ou artefatos compilados
no repositório não for viável, você pode criar um workflow personalizado, seguindo
este modelo:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    - 'v[0-9]+.[0-9]+.[0-9]+' # tag pattern on pub.dev: 'v{% raw %}{{version}{% endraw %}'

# Publish using custom workflow
jobs:
  publish:
    permissions:
      id-token: write # Required for authentication using OIDC
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
      - name: Install dependencies
        run: dart pub get
      # Here you can insert custom steps you need
      # - run: dart tool/generate-code.dart
      - name: Publish
        run: dart pub publish --force
```

O workflow se autentica no `pub.dev` usando um
[token OIDC assinado pelo GitHub][1] temporário. O token é criado e configurado no
passo `dart-lang/setup-dart`.
Para publicar no pub.dev, os passos seguintes podem executar `dart pub publish --force`.

:::note
Neste ponto, qualquer pessoa com acesso de push ao seu repositório pode publicar novas versões
do pacote. Considere usar [regras de proteção de tags][sec-gh-tag-protection] ou
[ambientes de deploy do GitHub][sec-gh-environment] para limitar quem pode publicar.
:::

[sec-gh-tag-protection]: #hardening-security-with-tag-protection-rules-on-github
[sec-gh-environment]: #hardening-security-with-github-deployment-environments

### Acionando a publicação automatizada pelo GitHub Actions {:#triggering-automated-publishing-from-github-actions}

Depois de configurar a publicação automatizada no `pub.dev` e criar um
workflow do GitHub Actions, você pode publicar uma nova versão do seu pacote.
Para publicar, envie uma _git tag_ que corresponda ao _tag pattern_ configurado.

```console
$ cat pubspec.yaml
```

```yaml
package: my_package_name
version: 1.2.3            # must match the version number used in the git tag
environment:
  sdk: ^2.19.0
```

```console
$ git tag v1.2.3          # assuming my tag pattern is: 'v{% raw %}{{version}}{% endraw %}'
$ git push origin v1.2.3  # triggers the action that publishes my package.
```

Depois do envio, revise os logs do workflow em
`https://github.com/<organization>/<repository>/actions`.

Se a Action não tiver sido acionada, verifique se o padrão configurado em
`.github/workflows/publish.yml` corresponde à _git tag_ enviada.
Se a Action falhou, os logs podem conter pistas sobre o motivo da falha.

Depois de publicado, você pode ver o evento de publicação no `audit-log` do
`pub.dev`.
A entrada do `audit-log` deve conter um link para a execução do GitHub Action que
publicou a versão do pacote.

![Audit log após a publicação a partir do GitHub Actions](/assets/img/tools/pub/audit-log-pub-gh.png)

Se você não gosta de usar a CLI do `git` para criar tags, pode criar _releases_
no GitHub em `https://github.com/<organization>/<repository>/releases/new`.
Para saber mais, veja [gerenciando releases em um repositório][4] no GitHub.

### Reforçando a segurança com regras de proteção de tags no GitHub {:#hardening-security-with-tag-protection-rules-on-github}

Configurar a publicação automatizada a partir do GitHub Actions permite que qualquer pessoa que
consiga enviar uma tag para o seu repositório acione a publicação no pub.dev.
Você pode restringir quem pode enviar tags para o seu repositório usando
[regras de proteção de tags][5] no GitHub.

Ao limitar quem pode criar tags que correspondam ao seu _tag pattern_, você limita
quem pode publicar o pacote.

No momento, as [regras de proteção de tags][5] são pouco flexíveis. Você pode querer
restringir quem pode acionar a publicação usando ambientes de deploy do GitHub,
como descrito na próxima seção.

### Reforçando a segurança com ambientes de deploy do GitHub {:#hardening-security-with-github-deployment-environments}

Ao configurar a publicação automatizada a partir do GitHub Actions no pub.dev, você pode
exigir um [ambiente do GitHub Actions][6].
Para exigir um _ambiente do GitHub Actions_ para a publicação, você precisa:

1. Acessar a aba **Admin** (`pub.dev/packages/<package>/admin`).
1. Encontrar a seção **Automated publishing**.
1. Clicar em **Require GitHub Actions environment**.
1. Especificar um nome de **Environment** (`pub.dev` costuma ser um bom nome).

![Configure o pub.dev para exigir um ambiente de deploy do GitHub](/assets/img/tools/pub/pub-dev-gh-env-setup.png)

Quando um ambiente é exigido no pub.dev, o GitHub Actions não consegue
publicar a menos que tenha `environment: pub.dev`. Por isso, você precisa:

1. [Criar um _ambiente_][8] com o mesmo nome no GitHub
   (normalmente `pub.dev`).
1. Alterar o seu arquivo de workflow `.github/workflows/publish.yml` para especificar
   `environment: pub.dev`, conforme o exemplo a seguir:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    - 'v[0-9]+.[0-9]+.[0-9]+' # for tags like: 'v1.2.3'

jobs:
  publish:
    permissions:
      id-token: write # Required for authentication using OIDC.
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    with:
      # Specify the GitHub Action deployment environment.
      environment: pub.dev
      # working-directory: path/to/package/within/repository
```

O _ambiente_ é refletido no token OIDC temporário [assinado pelo GitHub][1]
usado para a autenticação no pub.dev. Assim, um usuário com permissão para enviar código para o
seu repositório não consegue contornar as [regras de proteção de ambientes][7] modificando
o arquivo de workflow.

Nas configurações do repositório no GitHub, você pode usar as [regras de proteção de ambientes][7] para
configurar _revisores obrigatórios_. Se você configurar essa opção, o GitHub impede que
as ações do ambiente sejam executadas até que um dos
_revisores obrigatórios_ aprove a execução.

![GitHub Action aguardando revisão de deploy](/assets/img/tools/pub/gh-pending-review.png)

## Publicando a partir do Google Cloud Build {:#publishing-from-google-cloud-build}

Você pode configurar a publicação automatizada a partir do [Google Cloud Build][9]. Isso
envolve:

* Registrar um projeto do Google Cloud (ou usar um projeto existente),
* Criar uma [service account][10] para publicar no pub.dev,
* Habilitar a publicação automatizada na aba admin do pacote no pub.dev,
  especificando o e-mail da service account criada para a publicação.
* Conceder à service account padrão do Cloud Build a permissão de personificar a
  service account criada para a publicação.
* Criar um arquivo `cloudbuild.yaml` que obtém um `id_token` OIDC temporário
  e o usa para publicar no pub.dev.
* Configurar um gatilho (trigger) do Cloud Build, para executar os passos do `cloudbuild.yaml`
  no seu projeto no Google Cloud Build.

As seções a seguir descrevem como concluir essas etapas.

:::note
Quando você habilita a publicação automatizada a partir de uma _service account_, é preciso revisar
cuidadosamente quem tem a capacidade de personificar essa service account, seja
chamando as APIs, exportando chaves da service account ou alterando as
permissões de IAM no projeto de nuvem.
Para saber mais, veja [gerenciando a personificação de service accounts][11].
:::

### Criando uma service account para publicação {:#creating-a-service-account-for-publishing}

Para publicar no pub.dev, você vai criar uma _service account_ que recebe permissão para publicar o seu
pacote no pub.dev. Depois, você vai conceder ao Cloud Build a permissão para personificar
essa service account.

1. [Crie um projeto de nuvem][12], caso você não tenha um projeto existente.
1. Crie uma _service account_ da seguinte forma:

    ```console
    $ gcloud iam service-accounts create pub-dev \
      --description='Service account to be impersonated when publishing to pub.dev' \
      --display-name='pub-dev'
    ```

    Isso cria uma service account chamada
    `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

1. Conceda à service account a permissão para publicar o seu pacote.

   Para concluir esta etapa, você precisa ter a permissão de _uploader_ no pacote ou
   ser um _admin_ do publisher que é dono do pacote.

   a. Acesse a aba **Admin** (`pub.dev/packages/<package>/admin`).
   a. Clique em **Enable publishing with Google Cloud Service account**.
   a. Digite o e-mail da service account no campo **Service account email**.
      Você criou esta conta na etapa anterior:
      `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`

![Configuração que permite que a service account publique no pub.dev](/assets/img/tools/pub/pub-dev-gcb-config.png)

Concluído este procedimento, qualquer pessoa que consiga personificar a service account pode
publicar novas versões do pacote. Certifique-se de revisar quem tem permissão para
personificar a service account e de alterar as permissões no projeto de nuvem
conforme necessário.

:::note
A _service account_ precisa ser criada no mesmo projeto de nuvem em que você pretende
executar o Cloud Build. Se precisar personificar entre projetos diferentes,
consulte [habilitando a personificação de service accounts entre projetos][27].
:::

### Concedendo ao Cloud Build permissão para publicar {:#granting-cloud-build-permission-to-publish}

Para publicar a partir do Cloud Build, você precisa dar à
[service account padrão do Cloud Build][13] a permissão para personificar
a service account criada para a publicação na seção anterior.

1. Habilite a [API IAM Service Account Credentials][14] no projeto de nuvem.
   Tentativas de personificar uma service account falharão sem essa API.

   ```console
   # Enable IAM Service Account Credentials API
   $ gcloud services enable iamcredentials.googleapis.com
   ```

1. Encontre o número do projeto.

   ```console
   # The PROJECT_NUMBER can be obtained as follows:
   $ gcloud projects describe $PROJECT_ID --format='value(projectNumber)'
   ```

1. Conceda a permissão para personificar a service account de publicação.

   ```console
   # Grant default cloud
   $ gcloud iam service-accounts add-iam-policy-binding \
     pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
     --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
   ```

### Escrevendo um arquivo de configuração do Cloud Build {:#writing-a-cloud-build-configuration-file}

Para publicar a partir do Cloud Build, você precisa especificar os passos para que o Cloud Build:

* Personifique a service account para obter um token OIDC temporário.
* Forneça o token OIDC temporário ao `dart pub` para uso na publicação.
* Execute `dart pub publish` para publicar o pacote.

Os passos para o Google Cloud Build são fornecidos em um arquivo `cloudbuild.yaml`; veja
[o schema do arquivo de configuração de build][15] para a documentação completa do formato.

Para publicar no pub.dev a partir do Google Cloud Build, um arquivo `cloudbuild.yaml` como
o seguinte é suficiente:

```yaml
# cloudbuild.yaml
steps:
- id: Create temporary token
  name: gcr.io/cloud-builders/gcloud
  volumes:
  - name: temporary-secrets
    path: /secrets
  script: |
    gcloud auth print-identity-token \
      --impersonate-service-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
      --audiences=https://pub.dev \
      --include-email > /secrets/temporary-pub-token.txt
  env:
  - PROJECT_ID=$PROJECT_ID
- id: Publish to pub.dev
  name: dart
  volumes:
  - name: temporary-secrets
    path: /secrets
  script: | 
    cat /secrets/temporary-pub-token.txt | dart pub token add https://pub.dev
    dart pub publish --force
```

O `gcloud auth print-identity-token` cria um `id_token` OIDC personificando
a service account especificada. Esse `id_token` é assinado pelo Google, com uma
assinatura que expira em até 1 hora. O parâmetro _audiences_ informa ao pub.dev
que ele é o destinatário pretendido do token. A opção `--include-email`
é necessária para que o pub.dev reconheça a service account.

Depois que o `id_token` é criado, ele é gravado em um arquivo que fica em um
_volume_; esse mecanismo é usado para [passar dados entre os passos][16].
Não armazene o token em `/workspace`, pois é nesse diretório que o
repositório do qual você quer publicar é feito checkout.
Não usar `/workspace` para guardar o token reduz o risco de você incluí-lo
acidentalmente no pacote ao publicar.

### Criando um gatilho (trigger) do Cloud Build {:#creating-a-cloud-build-trigger}

Com as service accounts configuradas e um arquivo `cloudbuild.yaml` no repositório,
você pode criar um _Cloud Build Trigger_ pelo painel em [console.cloud.google.com][28].
Para criar um gatilho de build, você precisa conectar a um _repositório de código_
e especificar quais eventos devem acionar um build. Você pode usar o [GitHub][18],
o [Cloud Source Repository][19] ou uma das [outras opções][20].
Para aprender a configurar um _Cloud Build Trigger_, veja
[criando e gerenciando gatilhos de build][21].

Para usar o `cloudbuild.yaml` do passo anterior, configure o tipo do
_Cloud Build Trigger_ como "Cloud Build Configuration", localizado no
repositório, no arquivo `/cloudbuild.yaml`.
**Não** especifique uma _service account_ para o build que será acionado.
Em vez disso, use a service account padrão do Cloud Build.

![Configuração do gatilho](/assets/img/tools/pub/gcb-trigger-configuration.png)

:::note
Você pode configurar o gatilho do Cloud Build para ser executado com uma
_service account_ personalizada. Se quiser fazer isso, crie uma nova service
account para essa finalidade. Permita que essa service account personifique a
conta `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`, que pode
publicar no pub.dev.

A configuração da _service account_ `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`
permitiu que a service account padrão do Cloud Build,
`$PROJECT_NUMBER@cloudbuild.gserviceaccount.com`, personificasse a
service account `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.
Se você usar uma service account personalizada para o Cloud Build, será preciso alterar
isso.

Para saber mais sobre service accounts personalizadas para executar builds do Cloud Build,
veja [configurando service accounts especificadas pelo usuário][22].
:::

Ao configurar o gatilho do Cloud Build, considere quem pode acioná-lo.
_Porque acionar um build pode publicar uma nova versão do seu pacote_.
Considere permitir apenas builds manuais ou usar as
[aprovações do Cloud Build][17] para controlar os builds, conforme descrito na próxima seção.

### Reforçando a segurança com aprovações do Cloud Build {:#hardening-security-with-cloud-build-approvals}

Ao configurar um gatilho do Cloud Build, você pode selecionar
**require approval before build executes**. Se um gatilho do Cloud Build
exigir aprovação, ele não será executado quando acionado. Em vez disso, ele aguardará
a aprovação.
Isso pode ser usado para limitar quem pode publicar novas versões do seu pacote.

![Habilitando aprovações na configuração do gatilho do Cloud Build](/assets/img/tools/pub/gcb-approval-checkbox.png)

Somente um usuário com o papel **Cloud Build Approver** pode conceder a aprovação.
Ao aprovar, o aprovador pode especificar uma URL e um comentário.

![Execução do Cloud Build aguardando aprovação para ser executada](/assets/img/tools/pub/gcp-waiting-for-approval.png)

Você também pode configurar notificações para aprovações pendentes.
Para saber mais, veja [controlando o build com aprovação][17].

## Publique de qualquer lugar usando uma Service Account {:#publish-from-anywhere-using-a-service-account}

Para permitir a publicação automatizada fora do GitHub Actions, você pode
se autenticar usando service accounts de forma semelhante ao _Cloud Build_.

Isso normalmente envolve:

* [Criar uma service account para publicação][create-svc],
* Personificar a service account de publicação de uma de duas formas:
  * Workload Identity Federation
  * Chaves exportadas de service account

A seção do _Cloud Build_ descreveu como
[criar uma service account para publicação][create-svc].
Isso deve fornecer uma service account, como
`pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

[create-svc]: #creating-a-service-account-for-publishing

### Publique usando Workload Identity Federation {:#publish-using-workload-identity-federation}

Quando você executa em um serviço de nuvem que suporta OIDC ou SAML,
pode personificar uma service account do GCP usando
[Workload Identity Federation][23]. Isso permite que você
aproveite os serviços de identidade do seu provedor de nuvem.

Por exemplo, se você fizer o deploy na EC2, pode
[configurar a workload identity federation com a AWS][24], permitindo que
tokens temporários da AWS obtidos pelo serviço de metadados da EC2 personifiquem uma
service account.
Para aprender a configurar esses fluxos, veja
[workload identity federation][25].

### Publique usando chaves exportadas de service account {:#publish-using-exported-service-account-keys}

Quando você executa em um sistema próprio sem serviços de identidade, pode
exportar chaves de service account. As chaves exportadas permitem que você se autentique
como essa _service account_.
Para saber mais, veja como
[criar e gerenciar chaves de service account][26].

#### Exporte as chaves de service account {:#export-service-account-keys}

1. Crie chaves exportadas para uma service account existente.

    ```console
    $ gcloud iam service-accounts keys create key-file.json \
      --iam-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com
    ```

1. Salve o arquivo `key-file.json` para uso posterior.

:::warning
Trate o `key-file.json` como uma senha.
Qualquer pessoa que tiver acesso a ele pode se autenticar como a service account
e publicar o seu pacote.
:::

#### Publique pacotes usando chaves exportadas de service account {:#publish-packages-using-exported-service-account-keys}

Para publicar um pacote usando chaves exportadas de service account:

1. Configure o gcloud para se autenticar usando o `key-file.json` (criado na etapa anterior)

    ```console
    $ gcloud auth activate-service-account --key-file=key-file.json
    ```

1. Crie um token temporário para o pub.dev e passe-o para
   `dart pub token add https://pub.dev`.
   Para personificar a service account, inclua a opção `--include-email`.

    ```console
    $ gcloud auth print-identity-token \
      --audiences=https://pub.dev \
      | dart pub token add https://pub.dev
    ```

1. Publique usando o token temporário.
   Adicione a opção `--force` para pular a confirmação `yes/no`.

    ```console
    $ dart pub publish --force
    ```

:::note
Considere usar a [Workload Identity Federation][23], se possível. Isso
evita segredos de longa duração. Depender da Workload Identity Federation
permite que você use segredos de curta duração, assinados pelo seu provedor de nuvem.
Segredos de curta duração reduzem muito os riscos de segurança caso vazem acidentalmente
em logs ou de formas semelhantes.
:::

[1]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
[2]: https://cloud.google.com/iam/docs/service-accounts
[3]: https://docs.github.com/en/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow
[4]: https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository
[5]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/configuring-tag-protection-rules
[6]: https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment
[7]: https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules
[8]: https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment
[9]: https://cloud.google.com/build
[10]: https://cloud.google.com/iam/docs/service-accounts
[11]: https://cloud.google.com/iam/docs/impersonating-service-accounts
[12]: https://cloud.google.com/resource-manager/docs/creating-managing-projects
[13]: https://cloud.google.com/build/docs/cloud-build-service-account
[14]: https://console.cloud.google.com/apis/api/iamcredentials.googleapis.com
[15]: https://cloud.google.com/build/docs/build-config-file-schema
[16]: https://cloud.google.com/build/docs/configuring-builds/pass-data-between-steps
[17]: https://cloud.google.com/build/docs/securing-builds/gate-builds-on-approval
[18]: https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github
[19]: https://cloud.google.com/source-repositories/docs/create-code-repository
[20]: https://cloud.google.com/build/docs/triggers
[21]: https://cloud.google.com/build/docs/automating-builds/create-manage-triggers
[22]: https://cloud.google.com/build/docs/securing-builds/configure-user-specified-service-accounts
[23]: https://cloud.google.com/iam/docs/workload-identity-federation
[24]: https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds
[25]: https://cloud.google.com/iam/docs/how-to#workload-identity-federation
[26]: https://cloud.google.com/iam/docs/creating-managing-service-account-keys
[27]: https://cloud.google.com/iam/docs/impersonating-service-accounts#enabling-cross-project
[28]: https://console.cloud.google.com/cloud-build/triggers
