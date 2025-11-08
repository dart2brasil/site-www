---
title: Automated publishing of packages to pub.dev
shortTitle: Automated publishing
description: Publish Dart packages to pub.dev directly from GitHub Actions.
ia-translate: true
---

Você pode automatizar a publicação a partir de:
* [GitHub Actions](https://github.com/features/actions),
* [Google Cloud Build][9] ou,
* Qualquer outro lugar usando uma [GCP service account][2].

As seções a seguir explicam como a publicação automatizada é configurada e
como você pode personalizar os fluxos de publicação de acordo com suas preferências.

Ao configurar a publicação automatizada, você não precisa criar um
segredo de longa duração que seja copiado para seu ambiente de deploy automatizado.
Em vez disso, a autenticação depende de tokens temporários OpenID-Connect assinados pelo
GitHub Actions (veja [OIDC for GitHub Actions][1]) ou Google Cloud IAM.

Você pode usar _exported service account keys_ para ambientes de deployment
onde um serviço de identidade não está presente.
Tais exported service account keys são segredos de longa duração, eles podem ser mais fáceis
de usar em alguns ambientes, mas também representam um risco maior se vazarem acidentalmente.

:::note
Hoje, você só pode automatizar a publicação de pacotes existentes.
Para criar um novo pacote, você deve publicar a primeira versão usando
`dart pub publish`.
:::

## Publishing packages using GitHub Actions

Você pode configurar a publicação automatizada usando GitHub Actions. Isso envolve:

* Habilitar a publicação automatizada no pub.dev, especificando:

  * O repositório GitHub e,
  * Um _tag-pattern_ que deve corresponder para permitir a publicação.

* Criar um _workflow_ do GitHub Actions para publicar no pub.dev.
* Fazer push de uma _git tag_ para a versão a ser publicada.

As seções a seguir descrevem como completar estas etapas.

:::note
Pub.dev só permite publicação automatizada do GitHub Actions quando o
_workflow_ é disparado ao fazer push de uma git tag para o GitHub.
Pub.dev rejeita publicações do GitHub Actions disparadas sem uma tag.
Isso garante que novas versões não possam ser publicadas por eventos que nunca
deveriam acionar publicações.
:::

### Configuring automated publishing from GitHub Actions on pub.dev

Para habilitar a publicação automatizada do GitHub Actions para `pub.dev`, você deve ser:

* Um _uploader_ no pacote, ou,
* Um _admin_ do publisher (se o pacote pertencer a um publisher).

Se você tiver permissão suficiente, pode habilitar a publicação automatizada:

1. Navegando até a aba **Admin** (`pub.dev/packages/<package>/admin`).
1. Localize a seção **Automated publishing**.
1. Clique em **Enable publishing from GitHub Actions**, isso solicitará que você
   especifique:

   * Um repository (`<organization>/<repository>`, exemplo: `dart-lang/pana`),
   * Um _tag-pattern_ (uma string contendo `{% raw %}{{version}}{% endraw %}`).

O _repository_ é o `<organization>/<repository>` no GitHub.
Por exemplo, se seu repositório é
`https://github.com/dart-lang/pana` você deve especificar `dart-lang/pana` no
campo repository.

O _tag pattern_ é uma string que deve conter `{% raw %}{{version}}{% endraw %}`.
Apenas GitHub Actions disparadas por um push de uma tag que corresponde a este
_tag pattern_ terão permissão para publicar seu pacote.

![Configuration of publishing from GitHub Actions on pub.dev](/assets/img/tools/pub/pub-dev-gh-setup.png)

**Example:** um _tag pattern_ como `v{% raw %}{{version}}{% endraw %}` permite
que GitHub Actions (disparado por `git tag v1.2.3 && git push v1.2.3`) publique
a versão `1.2.3` do seu pacote. Assim, também é importante que a chave `version` no
`pubspec.yaml` corresponda a este número de versão.

Se seu repositório contém múltiplos pacotes, dê a cada um um
_tag-pattern_ separado. Considere usar um _tag-pattern_ como
`my_package_name-v{% raw %}{{version}}{% endraw %}` para um pacote
chamado `my_package_name`.

### Configuring a GitHub Action workflow for publishing to pub.dev

Quando a publicação automatizada do GitHub Actions está habilitada no pub.dev,
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

Certifique-se de que o padrão em `on.push.tags` corresponde ao _tag pattern_
especificado no pub.dev. Caso contrário, o workflow do GitHub Action não funcionará.
Se estiver publicando múltiplos pacotes do mesmo repositório,
use um _tag pattern_ por pacote como
`my_package_name-v{% raw %}{{version}}{% endraw %}` e
crie um arquivo de workflow separado para cada pacote.

O arquivo de workflow acima usa
`dart-lang/setup-dart/.github/workflows/publish.yml` para publicar o pacote.
Este é um [reusable workflow][3] que permite que o time Dart mantenha
a lógica de publicação e permite que o pub.dev saiba como o pacote foi publicado.
Usar este _reusable workflow_ é fortemente encorajado.

Se você precisar de código gerado em seu pacote, então é preferível fazer commit deste
código gerado em seu repositório.
Isso simplifica verificar que os arquivos publicados no pub.dev correspondem
aos arquivos do seu repositório. Se fazer commit de código gerado ou artefatos construídos em
seu repositório não for razoável, você pode criar um workflow customizado seguindo
as seguintes linhas:

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
[GitHub-signed OIDC token][1] temporário, o token é criado e configurado no
passo `dart-lang/setup-dart`.
Para publicar no pub.dev, passos subsequentes podem executar `dart pub publish --force`.

:::note
Neste ponto, qualquer pessoa com acesso push ao seu repositório pode publicar novas versões
do pacote. Considere usar [tag protection rules][sec-gh-tag-protection] ou
[GitHub deployment Environments][sec-gh-environment] para limitar quem pode publicar.
:::

[sec-gh-tag-protection]: #hardening-security-with-tag-protection-rules-on-github
[sec-gh-environment]: #hardening-security-with-github-deployment-environments

### Triggering automated publishing from GitHub Actions

Depois de configurar a publicação automatizada no `pub.dev` e criar um
workflow do GitHub Actions, você pode publicar uma nova versão do seu pacote.
Para publicar, faça push de uma _git tag_ correspondente ao _tag pattern_ configurado.

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

Uma vez feito o push, revise os logs do workflow em
`https://github.com/<organization>/<repository>/actions`.

Se a Action não foi disparada, verifique se o padrão configurado em
`.github/workflows/publish.yml` corresponde à _git tag_ que foi feita o push.
Se a Action falhou, os logs podem conter pistas sobre o motivo da falha.

Uma vez publicado, você pode ver o evento de publicação no `audit-log` em
`pub.dev`.
A entrada no `audit-log` deve conter um link para a execução do GitHub Action que
publicou a versão do pacote.

![Audit log after publishing from GitHub Actions](/assets/img/tools/pub/audit-log-pub-gh.png)

Se você não gosta de usar a CLI `git` para criar tags, você pode criar _releases_
no GitHub a partir de `https://github.com/<organization>/<repository>/releases/new`.
Para saber mais, consulte [managing releases in a repository][4] do GitHub.

### Hardening security with tag protection rules on GitHub

Configurar a publicação automatizada do GitHub Actions permite que qualquer pessoa que possa fazer push
de uma tag para seu repositório dispare a publicação no pub.dev.
Você pode restringir quem pode fazer push de tags para seu repositório usando
[tag protection rules][5] no GitHub.

Ao limitar quem pode criar tags correspondentes ao seu _tag pattern_, você pode limitar quem
pode publicar o pacote.

Atualmente, as [tag protection rules][5] carecem de flexibilidade. Você pode querer
restringir quem pode disparar a publicação usando GitHub Deployment Environments,
conforme descrito na próxima seção.

### Hardening security with GitHub Deployment Environments

Ao configurar a publicação automatizada do GitHub Actions no pub.dev, você pode
exigir um [GitHub Actions environment][6].
Para exigir um _GitHub Actions environment_ para publicação você deve:

1. Navegar até a aba **Admin** (`pub.dev/packages/<package>/admin`).
1. Localizar a seção **Automated publishing**.
1. Clicar em **Require GitHub Actions environment**.
1. Especificar um nome de **Environment**, (`pub.dev` é tipicamente um bom nome)

![Configure pub.dev to require a GitHub deployment environment](/assets/img/tools/pub/pub-dev-gh-env-setup.png)

Quando um environment é exigido no pub.dev, GitHub Actions não será capaz de
publicar a menos que tenha `environment: pub.dev`. Assim, você deve:

1. [Criar um _environment_][8] com o mesmo nome no GitHub
   (tipicamente `pub.dev`)
1. Alterar seu arquivo de workflow `.github/workflows/publish.yml` para especificar
   `environment: pub.dev`, da seguinte forma:

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
      id-token: write # Required for authentication using OIDC
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    with:
      # Specify the github actions deployment environment
      environment: pub.dev
      # working-directory: path/to/package/within/repository
```

O _environment_ é refletido no [GitHub-signed OIDC token][1] temporário
usado para autenticação com pub.dev. Assim, um usuário com permissão para fazer push no
seu repositório não pode contornar as [environment protection rules][7] modificando
o arquivo de workflow.

Nas configurações do repositório GitHub, você pode usar [environment protection rules][7] para
configurar _required reviewers_. Se você configurar esta opção, o GitHub impede
que actions com o environment sejam executadas até que um dos
_required reviewers_ tenha aprovado a execução.

![GitHub Action waiting for deployment review](/assets/img/tools/pub/gh-pending-review.png)

## Publishing from Google Cloud Build

Você pode configurar a publicação automatizada do [Google Cloud Build][9]. Isso
envolve:

* Registrar um Google Cloud Project (ou usar um projeto existente),
* Criar uma [service account][10] para publicar no pub.dev,
* Habilitar a publicação automatizada na aba admin do pacote no pub.dev,
  especificando o email da service account criada para publicação.
* Conceder à service account padrão do Cloud Build permissão para personificar a
  service account criada para publicação.
* Criar um arquivo `cloudbuild.yaml` que obtém um `id_token` OIDC temporário
  e usa-o para publicar no pub.dev
* Configurar um trigger do Cloud Build, para executar os passos em `cloudbuild.yaml`
  em seu projeto no Google Cloud Build.

As seções a seguir descrevem como completar estas etapas.

:::note
Quando você habilita a publicação automatizada de uma _service account_ você deve cuidadosamente
revisar quem tem a capacidade de personificar esta service account, seja
chamando através de APIs, exportando service account keys, ou através de mudanças
de permissão IAM no projeto cloud.
Para saber mais, consulte [managing service account impersonation][11].
:::

### Creating a service account for publishing

Para publicar no pub.dev você irá criar uma _service account_ que receberá
permissão para publicar seu pacote no pub.dev. Você então irá
conceder permissão ao Cloud Build para personificar esta service account.

1. [Criar um cloud project][12], se você não tem um projeto existente.
1. Criar uma _service account_ da seguinte forma:

    ```console
    $ gcloud iam service-accounts create pub-dev \
      --description='Service account to be impersonated when publishing to pub.dev' \
      --display-name='pub-dev'
    ```

    Isso cria uma service account chamada
    `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

1. Conceder permissão à service account para publicar seu pacote.

   Para completar este passo, você deve ter permissão de _uploader_ no pacote ou
   ser um _admin_ do publisher que possui o pacote.

   a. Navegar até a aba **Admin** (`pub.dev/packages/<package>/admin`).
   a. Clicar em **Enable publishing with Google Cloud Service account**.
   a. Digitar o email da service account no campo **Service account email**.
      Você criou esta conta no passo anterior:
      `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`

![Configuration that allows service account to publish on pub.dev](/assets/img/tools/pub/pub-dev-gcb-config.png)

Com este procedimento completo, qualquer pessoa que pode personificar a service account pode
publicar novas versões do pacote. Certifique-se de revisar quem tem permissões para
personificar a service account e alterar permissões no projeto cloud conforme
necessário.

:::note
A _service account_ deve ser criada no mesmo cloud project onde você
pretende executar o Cloud Build. Se você precisar personificar através de cloud projects,
consulte [enabling service account impersonation across projects][27].
:::

### Granting Cloud Build permission to publish

Para publicar a partir do Cloud Build você deve dar à
[default Cloud Build service account][13] permissão para personificar
a service account criada para publicação na seção anterior.

1. Habilitar a [IAM Service Account Credentials API][14] no cloud project.
   Tentativas de personificar uma service account falharão sem esta API.

   ```console
   # Enable IAM Service Account Credentials API
   $ gcloud services enable iamcredentials.googleapis.com
   ```

1. Encontrar o project number.

   ```console
   # The PROJECT_NUMBER can be obtained as follows:
   $ gcloud projects describe $PROJECT_ID --format='value(projectNumber)'
   ```

1. Conceder a permissão para personificar a publishing service account.

   ```console
   # Grant default cloud
   $ gcloud iam service-accounts add-iam-policy-binding \
     pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
     --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
   ```

### Writing a Cloud Build configuration file

Para publicar a partir do Cloud Build, você deve especificar passos para o Cloud Build:

* Personificar a service account para obter um token OIDC temporário.
* Fornecer o token OIDC temporário para `dart pub` usar ao publicar.
* Chamar `dart pub publish` para publicar o pacote.

Os passos para o Google Cloud Build são fornecidos em um arquivo `cloudbuild.yaml`, veja
[build configuration file schema][15] para documentação completa do formato.

Para publicar no pub.dev a partir do Google Cloud Build, um arquivo `cloudbuild.yaml` como
o seguinte funcionará:

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
a service account especificada. Este `id_token` é assinado pelo Google, com uma
assinatura que expira dentro de 1 hora. O parâmetro _audiences_ informa ao pub.dev
que ele é o destinatário pretendido do token. A opção `--include-email`
é necessária para o pub.dev reconhecer a service account.

Uma vez criado o `id_token`, ele é escrito em um arquivo que reside em um
_volume_; este mecanismo é usado para [passar dados entre passos][16].
Não armazene o token em `/workspace`. Já que `/workspace` é onde o
repositório do qual você deseja publicar é feito o checkout.
Não usar `/workspace` para armazenar o token reduz o risco de você
acidentalmente incluí-lo no seu pacote ao publicar.

### Creating a Cloud Build trigger

Com as service accounts configuradas e um arquivo `cloudbuild.yaml` no repositório
você pode criar um _Cloud Build Trigger_ usando o dashboard [console.cloud.google.com][28].
Para criar um build trigger, você precisa conectar a um _source repository_
e especificar quais eventos devem disparar um build. Você pode usar [GitHub][18],
[Cloud Source Repository][19], ou uma das [outras opções][20].
Para aprender como configurar um _Cloud Build Trigger_, consulte
[creating and managing build triggers][21].

Para usar o `cloudbuild.yaml` do passo anterior, configure o
tipo _Cloud Build Trigger_ como "Cloud Build Configuration" localizado no
repositório no arquivo `/cloudbuild.yaml`.
**Não** especifique uma _service account_ para o build ser disparado.
Em vez disso, você vai querer usar a service account padrão para Cloud Build.

![Configuration for trigger](/assets/img/tools/pub/gcb-trigger-configuration.png)

:::note
Você pode configurar o trigger do Cloud Build para executar sob uma
_service account_ customizada. Se você quiser fazer isso, crie uma nova service
account para este propósito. Permita que esta service account personifique
a conta `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`, que pode
publicar no pub.dev.

A configuração da _service account_ `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`
permitiu que a service account padrão do Cloud Build,
`$PROJECT_NUMBER@cloudbuild.gserviceaccount.com`, personifique a
service account `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.
Se usar uma service account customizada para o Cloud Build, você precisará mudar
isso.

Para saber mais sobre service accounts customizadas para executar Cloud Builds,
consulte [Configuring user-specified service accounts][22].
:::

Ao configurar seu trigger do Cloud Build, considere quem pode disparar o
build. _Porque disparar um build pode publicar uma nova versão do seu pacote_.
Considere permitir apenas builds manuais ou use
[Cloud Build approvals][17] para restringir builds conforme descrito na próxima seção.

### Hardening security with Cloud Build Approvals

Ao configurar um trigger do Cloud Build, você pode selecionar
**require approval before build executes**. Se um trigger do Cloud Build
requer aprovação, ele não será executado quando disparado. Em vez disso, esperará pela
aprovação.
Isso pode ser usado para limitar quem pode publicar novas versões do seu pacote.

![Enabling approvals in configuration of the Cloud Build trigger](/assets/img/tools/pub/gcb-approval-checkbox.png)

Apenas um usuário com a role **Cloud Build Approver** pode dar aprovação.
Ao dar uma aprovação, o aprovador pode especificar uma URL e comentário.

![Cloud Build run waiting for approval to run](/assets/img/tools/pub/gcp-waiting-for-approval.png)

Você também pode configurar notificações para aprovações pendentes.
Para saber mais, consulte [gate build on approval][17].

## Publish from anywhere using a Service Account

Para permitir publicação automatizada fora do GitHub Actions, você pode
autenticar usando service accounts de forma similar ao _Cloud Build_.

Isso geralmente envolve:

* [Criar uma service account para publicação][create-svc],
* Personificar a publishing service account de uma das duas formas:
  * Workload Identity Federation
  * Exported Service Account Keys

A seção para _Cloud Build_ descreveu como
[criar uma service account para publicação][create-svc].
Isso deve fornecer uma service account, como
`pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

[create-svc]: #creating-a-service-account-for-publishing

### Publish using Workload Identity Federation

Ao executar em um serviço cloud que suporta OIDC ou SAML,
você pode personificar uma GCP service account usando
[Workload Identity Federation][23]. Isso permite que você
aproveite os serviços de identidade do seu provedor cloud.

Por exemplo, se estiver fazendo deploy no EC2, você pode
[configurar workload identity federation com AWS][24], permitindo
que tokens temporários AWS do serviço de metadados EC2 personifiquem uma
service account.
Para aprender como configurar estes fluxos, consulte
[workload identity federation][25].

### Publish using Exported Service Account Keys

Ao executar em um sistema customizado sem serviços de identidade, você
pode exportar service account keys. Exported service account keys permitem que você
se autentique como a referida _service account_.
Para saber mais, consulte como
[criar e gerenciar service account keys][26].

#### Export service account keys

1. Criar exported service account keys para uma service account existente.

    ```console
    $ gcloud iam service-accounts keys create key-file.json \
      --iam-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com
    ```

1. Salvar o arquivo `key-file.json` para uso posterior.

:::warning
Trate o `key-file.json` como uma senha.
Qualquer pessoa que ganhar acesso a ele pode se autenticar como a service account
e publicar seu pacote.
:::

#### Publish packages using exported service account keys

Para publicar um pacote usando exported service account keys:

1. Configurar gcloud para autenticar usando `key-file.json` (criado no passo anterior)

    ```console
    $ gcloud auth activate-service-account --key-file=key-file.json
    ```

1. Criar um token temporário para pub.dev e passá-lo para
   `dart pub token add https://pub.dev`.
   Para personificar service account, inclua a opção `--include-email`.

    ```console
    $ gcloud auth print-identity-token \
      --audiences=https://pub.dev \
      | dart pub token add https://pub.dev
    ```

1. Publicar usando o token temporário.
   Adicione a opção `--force` para pular o prompt `yes/no`.

    ```console
    $ dart pub publish --force
    ```

:::note
Considere usar [Workload Identity Federation][23], se possível. Isso
evita segredos de longa duração. Confiar no Workload Identity Federation
permite que você use segredos de curta duração que seu provedor cloud assina.
Segredos de curta duração reduzem muito os riscos de segurança se vazarem acidentalmente
em logs ou formas similares.
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

