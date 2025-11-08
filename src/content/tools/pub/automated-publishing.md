---
title: Automated publishing of packages to pub.dev
shortTitle: Automated publishing
description: Publish Dart packages to pub.dev directly from GitHub Actions.
---

Você pode automatizar a publicação a partir de:
* [GitHub Actions](https://github.com/features/actions),
* [Google Cloud Build][9] ou,
* Qualquer outro lugar usando uma [conta de serviço GCP][2].

As seções a seguir explicam como a publicação automatizada é configurada e
como você pode personalizar os fluxos de publicação de acordo com suas preferências.

Ao configurar a publicação automatizada, você não precisa criar um
segredo de longa duração que é copiado para seu ambiente de implantação automatizada.
Em vez disso, a autenticação se baseia em tokens OpenID-Connect temporários assinados pelo
GitHub Actions (Consulte [OIDC para GitHub Actions][1]) ou pelo Google Cloud IAM.

Você pode usar _chaves de contas de serviço exportadas_ para ambientes de
implantação onde um serviço de identidade não está presente.
Tais chaves de contas de serviço exportadas são segredos de longa duração, podem ser mais
fáceis de usar em alguns ambientes, mas também representam um risco maior se forem acidentalmente vazadas.

:::note
Hoje, você só pode automatizar a publicação de pacotes existentes.
Para criar um novo pacote, você deve publicar a primeira versão usando
`dart pub publish`.
:::

## Publicando pacotes usando o GitHub Actions {:#publishing-packages-using-github-actions}

Você pode configurar a publicação automatizada usando o GitHub Actions. Isso envolve:

* Habilitar a publicação automatizada no pub.dev, especificando:

  * O repositório GitHub e,
  * Um _padrão de tag_ que deve corresponder para permitir a publicação.

* Criar um _workflow_ do GitHub Actions para publicar no pub.dev.
* Enviar uma _tag git_ para a versão a ser publicada.

As seções a seguir descrevem como completar estas etapas.

:::note
O Pub.dev só permite a publicação automatizada do GitHub Actions quando o
_workflow_ é acionado ao enviar uma tag git para o GitHub.
O Pub.dev rejeita a publicação do GitHub Actions acionada sem uma tag.
Isso garante que novas versões não possam ser publicadas por eventos que
nunca deveriam acionar a publicação.
:::

### Configurando a publicação automatizada do GitHub Actions no pub.dev {:#configuring-automated-publishing-from-github-actions-on-pub-dev}

Para habilitar a publicação automatizada do GitHub Actions para `pub.dev`, você deve ser:

* Um _uploader_ no pacote ou,
* Um _admin_ do publisher (se o pacote pertencer a um publisher).

Se você tiver permissão suficiente, pode habilitar a publicação automatizada por:

1. Navegar para a aba **Admin** (`pub.dev/packages/<package>/admin`).
1. Encontrar a seção **Publicação automatizada** (Automated publishing).
1. Clicar em **Habilitar publicação do GitHub Actions** (Enable publishing
   from GitHub Actions), isso solicita que você especifique:

   * Um repositório (`<organização>/<repositório>`, exemplo: `dart-lang/pana`),
   * Um _padrão de tag_ (uma string contendo `{% raw %}{{version}}{% endraw %}`).

O _repositório_ é `<organização>/<repositório>` no GitHub. Por exemplo, se
seu repositório for `https://github.com/dart-lang/pana`, você deve
especificar `dart-lang/pana`
no campo do repositório.

O _padrão de tag_ é uma string que deve conter `{% raw %}{{version}}{% endraw %}`.
Somente o GitHub Actions acionado por um push de uma tag que corresponda a
esse _padrão de tag_ poderá publicar seu pacote.

![Configuração da publicação do GitHub Actions no pub.dev](/assets/img/tools/pub/pub-dev-gh-setup.png)

**Exemplo:** um _padrão de tag_ como `v{% raw %}{{version}}{% endraw %}`
permite que o GitHub Actions (acionado por `git tag v1.2.3 && git push v1.2.3`)
publique a versão `1.2.3` do seu pacote. Assim, também é importante que a
chave `version` em `pubspec.yaml` corresponda a este número de versão.

Se seu repositório contiver vários pacotes, dê a cada um um _padrão de tag_
separado. Considere usar um _padrão de tag_ como
`meu_pacote_nome-v{% raw %}{{version}}{% endraw %}` para um pacote chamado
`meu_pacote_nome` (my_package_name).

### Configurando um workflow do GitHub Action para publicar no pub.dev {:#configuring-a-github-action-workflow-for-publishing-to-pub-dev}

Quando a publicação automatizada do GitHub Actions está habilitada no pub.dev,
você pode criar um workflow do GitHub Actions para publicação. Isso é feito
criando um arquivo `.github/workflows/publish.yml` da seguinte forma:

```yaml
# .github/workflows/publish.yml {:#github-workflows-publish-yml}
name: Publicar no pub.dev

on:
  push:
    tags:
    # deve estar alinhado com o padrão de tag configurado no pub.dev,
      # geralmente apenas substitua {% raw %}{{version}}{% endraw %} por [0-9]+.[0-9]+.[0-9]+
    - 'v[0-9]+.[0-9]+.[0-9]+' # padrão de tag no pub.dev: 'v{% raw %}{{version}}{% endraw %}'
    # Se você preferir tags como '1.2.3', sem o prefixo 'v', use:
    # - '[0-9]+.[0-9]+.[0-9]+' # padrão de tag no pub.dev: '{% raw %}{{version}}{% endraw %}'
    # Se seu repositório contiver vários pacotes, considere um padrão como:
    # - 'meu_pacote_nome-v[0-9]+.[0-9]+.[0-9]+'

# Publicar usando o workflow reutilizável de dart-lang. {:#publish-using-the-reusable-workflow-from-dart-lang}
jobs:
  publish:
    permissions:
      id-token: write # Necessário para autenticação usando OIDC
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    # with:
    #   working-directory: caminho/para/pacote/dentro/do/repositorio
```

Certifique-se de corresponder o padrão em `on.push.tags` com o _padrão de
tag_ especificado no pub.dev. Caso contrário, o workflow do GitHub Action não
funcionará. Se estiver publicando vários pacotes do
mesmo repositório, use um
_padrão de tag_ por pacote como `meu_pacote_nome-v{% raw %}{{version}}{% endraw %}`
e crie um arquivo de workflow separado para cada pacote.

O arquivo de workflow acima usa
`dart-lang/setup-dart/.github/workflows/publish.yml` para publicar o
pacote. Este é um [workflow reutilizável][3] que permite que a equipe Dart
mantenha a lógica de publicação e permite que o pub.dev saiba como o pacote foi
publicado. O uso deste _workflow reutilizável_ é fortemente incentivado.

Se você precisar de código gerado em seu pacote, é preferível verificar este
código gerado em seu repositório. Isso simplifica a verificação de que os
arquivos publicados no pub.dev correspondem aos arquivos do seu repositório.
Se verificar artefatos gerados ou construídos em seu repositório não for
razoável, você pode criar um workflow personalizado nos seguintes moldes:

```yaml
# .github/workflows/publish.yml {:#github-workflows-publish-yml}
name: Publicar no pub.dev

on:
  push:
    tags:
    - 'v[0-9]+.[0-9]+.[0-9]+' # padrão de tag no pub.dev: 'v{% raw %}{{version}}{% endraw %}'

# Publicar usando workflow personalizado {:#publish-using-custom-workflow}
jobs:
  publish:
    permissions:
      id-token: write # Necessário para autenticação usando OIDC
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
      - name: Instalar dependências
        run: dart pub get
      # Aqui você pode inserir as etapas personalizadas que você precisa
      # - run: dart tool/generate-code.dart
      - name: Publicar
        run: dart pub publish --force
```

O workflow autentica-se no `pub.dev` usando um
[token OIDC assinado pelo GitHub][1] temporário, o token é criado e
configurado na etapa `dart-lang/setup-dart`. Para publicar no pub.dev, as
etapas subsequentes podem executar `dart pub publish --force`.

:::note
Neste ponto, qualquer pessoa com acesso push ao seu repositório pode publicar
novas versões do pacote. Considere usar [regras de proteção de tag][sec-gh-tag-protection]
ou [ambientes de implantação do GitHub][sec-gh-environment] para limitar quem pode publicar.
:::

[sec-gh-tag-protection]: #hardening-security-with-tag-protection-rules-on-github
[sec-gh-environment]: #hardening-security-with-github-deployment-environments

### Acionando a publicação automatizada do GitHub Actions {:#triggering-automated-publishing-from-github-actions}

Depois de configurar a publicação automatizada no `pub.dev` e criar um
workflow do GitHub Actions, você pode publicar uma nova versão do seu pacote.
Para publicar, envie uma _tag git_ correspondente ao _padrão de tag_ configurado.

```console
$ cat pubspec.yaml
```

```yaml
package: meu_pacote_nome
version: 1.2.3            # deve corresponder ao número de versão usado na tag git
environment:
  sdk: ^2.19.0
```

```console
$ git tag v1.2.3          # assumindo que meu padrão de tag é: 'v{% raw %}{{version}}{% endraw %}'
$ git push origin v1.2.3  # aciona a ação que publica meu pacote.
```

Depois de enviado, revise os logs do workflow em
`https://github.com/<organização>/<repositório>/actions`.

Se a Ação não foi acionada, verifique se o padrão configurado em
`.github/workflows/publish.yml` corresponde à _tag git_ enviada. Se a Ação
falhou, os logs podem conter pistas sobre o motivo da falha.

Uma vez publicado, você pode ver o evento de publicação no `audit-log` em
`pub.dev`. A entrada `audit-log` deve conter um link para a execução do
GitHub Action que publicou
a versão do pacote.

![Log de auditoria após a publicação do GitHub Actions](/assets/img/tools/pub/audit-log-pub-gh.png)

Se você não gosta de usar o CLI `git` para criar tags, você pode criar
_releases_ no GitHub de `https://github.com/<organização>/<repositório>/releases/new`.
Para saber mais, confira [gerenciando releases em um repositório][4] do GitHub.

### Reforçando a segurança com regras de proteção de tag no GitHub {:#hardening-security-with-tag-protection-rules-on-github}

A configuração da publicação automatizada do GitHub Actions permite que
qualquer pessoa que possa enviar uma tag para o seu repositório acione a
publicação no pub.dev. Você pode restringir quem pode enviar tags para o seu
repositório usando [regras de proteção de tag][5] no GitHub.

Ao limitar quem pode criar tags que correspondem ao seu _padrão de tag_, você
pode limitar quem pode publicar o pacote.

Neste momento, as [regras de proteção de tag][5] carecem de flexibilidade.
Você pode querer restringir quem pode acionar a publicação usando os
Ambientes de Implantação do GitHub, conforme descrito na próxima seção.

### Reforçando a segurança com Ambientes de Implantação do GitHub {:#hardening-security-with-github-deployment-environments}

Ao configurar a publicação automatizada do GitHub Actions no pub.dev, você
pode exigir um [ambiente do GitHub Actions][6]. Para exigir um _ambiente do
GitHub Actions_ para publicação, você deve:

1. Navegar para a aba **Admin** (`pub.dev/packages/<package>/admin`).
1. Encontrar a seção **Publicação automatizada** (Automated publishing).
1. Clicar em **Requerer ambiente do GitHub Actions** (Require GitHub Actions environment).
1. Especificar um nome de **Ambiente**, (`pub.dev` é normalmente um bom nome)

![Configurar pub.dev para exigir um ambiente de implantação do GitHub](/assets/img/tools/pub/pub-dev-gh-env-setup.png)

Quando um ambiente é exigido no pub.dev, o GitHub Actions não poderá
publicar a menos que tenha `environment: pub.dev`. Assim, você deve:

1. [Criar um _ambiente_][8] com o mesmo nome no GitHub
  (normalmente `pub.dev`)
1. Alterar seu arquivo de workflow `.github/workflows/publish.yml` para
   especificar `environment: pub.dev`, como segue:

```yaml
# .github/workflows/publish.yml {:#github-workflows-publish-yml}
name: Publicar no pub.dev

on:
  push:
    tags:
    - 'v[0-9]+.[0-9]+.[0-9]+' # para tags como: 'v1.2.3'

jobs:
  publish:
    permissions:
      id-token: write # Necessário para autenticação usando OIDC
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    with:
      # Especificar o ambiente de implantação do github actions
      environment: pub.dev
      # working-directory: caminho/para/pacote/dentro/do/repositorio
```

O _ambiente_ é refletido no [token OIDC assinado pelo GitHub][1] temporário
usado para autenticação com pub.dev. Assim, um usuário com permissão para
enviar para o seu repositório não pode contornar as [regras de proteção de
ambiente][7] modificando o arquivo de workflow.

Nas configurações do repositório do GitHub, você pode usar [regras de proteção
de ambiente][7] para configurar _revisores obrigatórios_. Se você configurar
esta opção, o GitHub impede que as ações com o ambiente sejam executadas até
que um dos _revisores obrigatórios_ tenha aprovado a execução.

![GitHub Action aguardando revisão de implantação](/assets/img/tools/pub/gh-pending-review.png)

## Publicando a partir do Google Cloud Build {:#publishing-from-google-cloud-build}

Você pode configurar a publicação automatizada a partir do [Google Cloud
Build][9]. Isso envolve:

* Registrar um Projeto Google Cloud (ou usar um projeto existente),
* Criar uma [conta de serviço][10] para publicação no pub.dev,
* Habilitar a publicação automatizada na aba de admin para o pacote no
  pub.dev, especificando o e-mail da conta de serviço criada para publicação.
* Conceder à conta de serviço padrão do Cloud Build permissão para se passar
  pela conta de serviço criada para publicação.
* Criar um arquivo `cloudbuild.yaml` que obtém um `id_token` OIDC temporário
  e o usa para publicação no pub.dev
* Configurar um gatilho do Cloud Build, para executar as etapas em
  `cloudbuild.yaml` em seu projeto no Google Cloud Build.

As seções a seguir descrevem como completar estas etapas.

:::note
Quando você habilita a publicação automatizada de uma _conta de serviço_,
você deve revisar cuidadosamente quem tem a capacidade de se passar por
essa conta de serviço, seja chamando por meio de APIs, exportando chaves de
contas de serviço ou alterando a permissão IAM no projeto na nuvem.
Para saber mais, confira [gerenciando a representação da conta de serviço][11].
:::

### Criando uma conta de serviço para publicação {:#creating-a-service-account-for-publishing}

Para publicar no pub.dev, você criará uma _conta de serviço_ que recebe
permissão para publicar seu pacote no pub.dev. Em seguida, você concederá
permissão ao Cloud Build para se passar por esta conta de serviço.

1. [Criar um projeto na nuvem][12], se você não tiver um projeto existente.
1. Criar uma _conta de serviço_ da seguinte forma:

    ```console
    $ gcloud iam service-accounts create pub-dev \
      --description='Conta de serviço para ser representada ao publicar no pub.dev' \
      --display-name='pub-dev'
    ```

    Isso cria uma conta de serviço chamada
    `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

1. Conceda à conta de serviço permissão para publicar seu pacote.

   Para completar esta etapa, você deve ter permissão de _uploader_ no pacote
   ou ser um _admin_ do publisher que possui o pacote.

   a. Navegue até a aba **Admin** (`pub.dev/packages/<package>/admin`).
   a. Clique em **Habilitar publicação com a conta de serviço do Google Cloud** (Enable publishing with Google Cloud Service account).
   a. Digite o e-mail da conta de serviço no campo **E-mail da conta de
      serviço** (Service account email). Você criou esta conta na etapa
      anterior: `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`

![Configuração que permite que a conta de serviço publique no pub.dev](/assets/img/tools/pub/pub-dev-gcb-config.png)

Com este procedimento completo, qualquer pessoa que possa se passar pela
conta de serviço pode publicar novas versões do pacote. Certifique-se de
revisar quem tem permissões para se passar pela conta de serviço e alterar as
permissões no projeto na nuvem conforme necessário.

:::note
A _conta de serviço_ deve ser criada no mesmo projeto na nuvem onde você
pretende executar o Cloud Build. Se você precisar se passar por outros
projetos na nuvem, consulte [habilitando a representação de conta de serviço em projetos][27].
:::

### Concedendo permissão de publicação ao Cloud Build {:#granting-cloud-build-permission-to-publish}

Para publicar a partir do Cloud Build, você deve conceder à
[conta de serviço padrão do Cloud Build][13] permissão para se passar pela
conta de serviço criada para publicação na seção anterior.

1. Habilite a [API IAM Service Account Credentials][14] no projeto na nuvem.
   As tentativas de se passar por uma conta de serviço falharão sem esta API.

   ```console
   # Habilitar a API IAM Service Account Credentials
   $ gcloud services enable iamcredentials.googleapis.com
   ```

1. Encontre o número do projeto.

   ```console
   # O PROJECT_NUMBER pode ser obtido da seguinte forma:
   $ gcloud projects describe $PROJECT_ID --format='value(projectNumber)'
   ```

1. Conceda a permissão para se passar pela conta de serviço de publicação.

   ```console
   # Conceder cloud padrão
   $ gcloud iam service-accounts add-iam-policy-binding \
     pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
     --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
   ```

### Escrevendo um arquivo de configuração do Cloud Build {:#writing-a-cloud-build-configuration-file}

Para publicar a partir do Cloud Build, você deve especificar etapas para o Cloud Build:

* Se passar pela conta de serviço para obter um token OIDC temporário.
* Fornecer o token OIDC temporário para `dart pub` para uso durante a
  publicação.
* Chamar `dart pub publish` para publicar o pacote.

As etapas para o Google Cloud Build são fornecidas em um arquivo
`cloudbuild.yaml`, consulte [esquema do arquivo de configuração de build][15]
para obter documentação completa do formato.

Para publicação no pub.dev a partir do Google Cloud Build, um arquivo
`cloudbuild.yaml` como segue servirá:

```yaml
# cloudbuild.yaml {:#cloudbuild-yaml}
steps:
- id: Criar token temporário
  name: gcr.io/cloud-builders/gcloud
  volumes:
  - name: segredos-temporarios
    path: /secrets
  script: |
    gcloud auth print-identity-token \
      --impersonate-service-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
      --audiences=https://pub.dev \
      --include-email > /secrets/temporary-pub-token.txt
  env:
  - PROJECT_ID=$PROJECT_ID
- id: Publicar no pub.dev
  name: dart
  volumes:
  - name: segredos-temporarios
    path: /secrets
  script: | 
    cat /secrets/temporary-pub-token.txt | dart pub token add https://pub.dev
    dart pub publish --force
```

O `gcloud auth print-identity-token` cria um `id_token` OIDC representando
a conta de serviço especificada. Este `id_token` é assinado pelo Google, com
uma assinatura que expira dentro de 1 hora. O parâmetro _audiences_ permite
que o pub.dev saiba que ele é o destinatário pretendido do token. A opção
`--include-email` é necessária para que o pub.dev reconheça a conta de serviço.

Uma vez que o `id_token` é criado, ele é gravado em um arquivo que reside
em um _volume_; este mecanismo é usado para [passar dados entre etapas][16].
Não armazene o token em `/workspace`. Uma vez que `/workspace` é onde o
repositório do qual você deseja publicar é verificado. Não usar `/workspace`
para armazenar o token reduz o risco de você o incluir acidentalmente em seu
pacote ao publicar.

### Criando um gatilho do Cloud Build {:#creating-a-cloud-build-trigger}

Com as contas de serviço configuradas e um arquivo `cloudbuild.yaml` no
repositório, você pode criar um _Gatilho do Cloud Build_ usando o painel
[console.cloud.google.com][28]. Para criar um gatilho de build, você precisa
se conectar a um _repositório de origem_ e especificar quais eventos devem
acionar um build. Você pode usar [GitHub][18], [Cloud Source Repository][19]
ou uma das [outras opções][20]. Para saber como configurar um _Gatilho do
Cloud Build_, confira [criando e gerenciando gatilhos de build][21].

Para usar o `cloudbuild.yaml` da etapa anterior, configure o tipo _Gatilho do
Cloud Build_ como "Configuração do Cloud Build" localizado no repositório no
arquivo `/cloudbuild.yaml`. **Não** especifique uma _conta de serviço_ para o
build ser acionado. Em vez disso, você vai querer usar a conta de serviço
padrão para o Cloud Build.

![Configuração para gatilho](/assets/img/tools/pub/gcb-trigger-configuration.png)

:::note
Você pode configurar o gatilho do Cloud Build para ser executado em uma
_conta de serviço_ personalizada. Se você quiser fazer isso, crie uma nova
conta de serviço para esta finalidade. Permita que esta conta de serviço se
passe pela conta `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`, que pode
publicar no pub.dev.

A configuração da _conta de serviço_ `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`
permitiu que a conta de serviço padrão do Cloud Build,
`$PROJECT_NUMBER@cloudbuild.gserviceaccount.com`, se passasse pela conta de
serviço `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`. Se você estiver
usando uma conta de serviço personalizada para o Cloud Build, você precisará
alterar isso.

Para saber mais sobre contas de serviço personalizadas para executar
Cloud Builds, consulte [Configurando contas de serviço especificadas pelo usuário][22].
:::

Ao configurar seu gatilho do Cloud Build, considere quem pode acionar o
build. _Porque acionar um build pode publicar uma nova versão do seu pacote_.
Considere permitir apenas builds manuais ou usar [aprovações do Cloud Build][17]
para controlar os builds, conforme descrito na próxima seção.

### Reforçando a segurança com aprovações do Cloud Build {:#hardening-security-with-cloud-build-approvals}

Ao configurar um gatilho do Cloud Build, você pode selecionar **exigir
aprovação antes que o build seja executado** (require approval before build
executes). Se um gatilho do Cloud Build exigir aprovação, ele não será
executado quando acionado. Em vez disso, ele esperará pela aprovação. Isso
pode ser usado para limitar quem pode publicar novas versões do seu pacote.

![Habilitando aprovações na configuração do gatilho do Cloud Build](/assets/img/tools/pub/gcb-approval-checkbox.png)

Apenas um usuário com a função **Aprovador do Cloud Build** (Cloud Build
Approver) pode dar aprovação. Ao dar uma aprovação, o aprovador pode especificar um URL e um comentário.

![Execução do Cloud Build aguardando aprovação para execução](/assets/img/tools/pub/gcp-waiting-for-approval.png)

Você também pode configurar notificações para aprovações pendentes. Para
saber mais, confira [controlar build com aprovação][17].

## Publicar de qualquer lugar usando uma Conta de Serviço {:#publish-from-anywhere-using-a-service-account}

Para permitir a publicação automatizada fora do GitHub Actions, você pode se
autenticar usando contas de serviço de maneira semelhante ao _Cloud Build_.

Isso geralmente envolve:

* [Criar uma conta de serviço para publicação][create-svc],
* Representar a conta de serviço de publicação de uma das duas maneiras:
  * Workload Identity Federation
  * Chaves de conta de serviço exportadas

A seção para _Cloud Build_ descreveu como
[criar uma conta de serviço para publicação][create-svc].
Isso deve fornecer uma conta de serviço, como
`pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

[create-svc]: #creating-a-service-account-for-publishing

### Publicar usando Workload Identity Federation {:#publish-using-workload-identity-federation}

Ao executar em um serviço em nuvem que oferece suporte a OIDC ou SAML, você
pode se passar por uma conta de serviço GCP usando [Workload Identity
Federation][23]. Isso permite que você aproveite os serviços de identidade
do seu provedor de nuvem.

Por exemplo, se você estiver implantando no EC2, você pode [configurar
workload identity federation com AWS][24], permitindo que tokens AWS
temporários do serviço de metadados EC2 se passem por
uma conta de serviço.
Para saber como configurar esses fluxos, consulte [workload identity
federation][25].

### Publicar usando chaves de conta de serviço exportadas {:#publish-using-exported-service-account-keys}

Ao executar em um sistema personalizado sem serviços de identidade, você
pode exportar chaves de contas de serviço. As chaves de contas de serviço
exportadas permitem que você se autentique como a referida _conta de serviço_.
Para saber mais, confira como [criar e gerenciar chaves de contas de
serviço][26].

#### Exportar chaves de conta de serviço {:#export-service-account-keys}

1. Criar chaves de contas de serviço exportadas para uma conta de serviço existente.

    ```console
    $ gcloud iam service-accounts keys create key-file.json \
      --iam-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com
    ```

1. Salvar o arquivo `key-file.json` para uso posterior.

:::warning
Trate o `key-file.json` como uma senha. Qualquer pessoa que tenha acesso a
ele pode se autenticar como a conta de serviço
e publicar seu pacote.
:::

#### Publicar pacotes usando chaves de conta de serviço exportadas {:#publish-packages-using-exported-service-account-keys}

Para publicar um pacote usando chaves de contas de serviço exportadas:

1. Configurar o gcloud para autenticar usando `key-file.json` (criado na etapa anterior)

    ```console
    $ gcloud auth activate-service-account --key-file=key-file.json
    ```

1. Criar um token temporário para pub.dev e passá-lo para
   `dart pub token add https://pub.dev`. Para se passar pela conta de
   serviço, inclua a opção `--include-email`.

    ```console
    $ gcloud auth print-identity-token \
      --audiences=https://pub.dev \
      | dart pub token add https://pub.dev
    ```

1. Publicar usando o token temporário. Adicione a opção `--force` para
   ignorar o prompt `yes/no`.

    ```console
    $ dart pub publish --force
    ```

:::note
Considere usar [Workload Identity Federation][23], se possível. Isso evita
segredos de longa duração. Confiar no Workload Identity Federation permite
que você use segredos de curta duração que seu provedor de nuvem assina.
Segredos de curta duração reduzem muito os riscos de segurança se forem
acidentalmente vazados em logs ou de maneiras semelhantes.
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
