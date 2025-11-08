---
title: Troubleshooting pub
description: Common gotchas you might run into when using pub.
ia-translate: true
---

## Obtendo um erro "403" ao publicar um pacote {:#pub-publish-403}

Você recebe o seguinte erro ao executar `pub publish`:

```plaintext
HTTP error 403: Forbidden
...
You aren't an uploader for package '<foo>'
```

Este problema pode ocorrer se uma de suas contas recebeu permissão para
publicar um pacote, mas o cliente pub registra você com outra conta.

Você pode redefinir o processo de autenticação do pub
excluindo o arquivo de credenciais do pub:

#### Linux {:#pub-credentials-linux}

Se `$XDG_CONFIG_HOME` estiver definido:

```console
$ rm $XDG_CONFIG_HOME/dart/pub-credentials.json
```

Caso contrário:

```console
$ rm $HOME/.config/dart/pub-credentials.json
```

#### macOS {:#pub-credentials-mac}

```console
$ rm $HOME/Library/Application Support/dart/pub-credentials.json
```

#### Windows {:#pub-credentials-windows}

Se você estiver usando o Command Prompt:

```cmd
$ del "%APPDATA%\dart\pub-credentials.json"
```

Se você estiver usando o PowerShell:

```ps
$ Remove-Item -Path "%APPDATA%\dart\pub-credentials.json"
```

:::version-note
No Dart 2.14 ou anterior,
você deve excluir o arquivo `credentials.json`
encontrado na pasta [`PUB_CACHE`][].
:::

[`PUB_CACHE`]: /tools/pub/environment-variables

## Obtendo um erro "UnauthorizedAccess" ao publicar um pacote {:#pub-publish-unauthorized}

Você recebe o seguinte erro ao executar `pub publish`:

```plaintext
UnauthorizedAccess: Unauthorized user: <username> is not allowed to upload versions to package '<foo>'.
```

Você verá esta mensagem se não estiver na lista de pessoas
autorizadas a publicar novas versões de um pacote.
Veja [Uploaders](/tools/pub/publishing#uploaders).

## Pub build falha com erro HttpException {:#pub-get-fails}

Você recebe um erro HttpException semelhante ao seguinte ao
executar `pub build`:

```plaintext
Pub build failed, [1] IsolateSpawnException: 'HttpException: Connection closed while receiving data,
...
library handler failed
...
```

Isso pode acontecer como resultado de alguns softwares antivírus, como o
pacote de segurança para internet AVG 2013. Verifique o manual do seu pacote
de segurança para ver como desabilitar temporariamente
este recurso. Por exemplo, veja
[How to Disable AVG Components](https://support.avg.com/SupportArticleView?urlName=How-to-disable-AVG).

## Pub get falha atrás de um firewall corporativo {:#pub-get-fails-from-behind-a-corporate-firewall}

Da linha de comando, o pub respeita as variáveis de ambiente
`http_proxy` e `https_proxy`.
Você pode definir a variável de ambiente do servidor proxy da seguinte forma.

No Linux/macOS:

```console
$ export https_proxy=hostname:port
```

No Windows Command Prompt:

```cmd
$ set https_proxy=hostname:port
```

No Windows PowerShell:

```ps
$ $Env:https_proxy="hostname:port"
```

Se o proxy requer credenciais, você pode defini-las da seguinte forma.

No Linux/macOS:

```console
$ export https_proxy=username:password@hostname:port
```

No Windows Command Prompt:

```cmd
$ set https_proxy=username:password@hostname:port
```

No Windows PowerShell:

```ps
$ $Env:https_proxy="username:password@hostname:port"
```

## Localhost inacessível após o login

Quando você executa `dart pub publish` em um contêiner ou em uma sessão SSH,
o `localhost` no qual `dart pub` está escutando pode ser diferente do
`localhost` que está acessível no seu navegador.
Embora você possa fazer login usando o navegador,
o navegador então reclama que `http://localhost:<port>?code=...`
não está acessível.

Tente esta solução alternativa, que usa a linha de comando para concluir o login:

1. Em uma janela de terminal, execute `dart pub publish`.
2. Na janela do navegador que aparece, faça login. <br>
   O navegador é redirecionado para uma _nova URL localhost_
   (`http://localhost:<port>?code=...`)
   mas reclama que a URL não está acessível.
3. Copie a _nova URL localhost_ do navegador.
4. Em outra janela de terminal no mesmo contêiner ou no mesmo host
   onde `dart pub publish` foi chamado, use o comando `curl` para
   concluir o login usando a _nova URL localhost_:

   ```console
   $ curl 'http://localhost:<port>?code=...'
   ```

## Obtendo um erro de socket ao tentar encontrar um pacote {:#pub-get-socket-error}

O seguinte erro pode ocorrer se
você não tiver acesso à internet, seu provedor de internet estiver bloqueando `pub.dev`,
ou um software de segurança estiver bloqueando o acesso à internet do `dart`.

```plaintext
Got socket error trying to find package ... at https://pub.dev.
pub get failed (server unavailable) -- attempting retry 1 in 1 second...
```

Verifique sua conexão com a internet e
confirme que você não tem um firewall ou outro software de segurança
que bloqueia o acesso à internet do `dart`.

<details>
 <summary>
   <b>Instruções detalhadas para o Kaspersky Internet Security</b>
  </summary>

   Quando você desativa a proteção do _Kaspersky Internet Security_
   na barra de menu,
   o filtro de aplicativo VPN `sysextctrld`
   ainda é executado em segundo plano.
   Este filtro causa uma falha ao conectar ao `pub.dev`.
   Para resolver este problema,
   adicione tanto `https://pub.dev` quanto `https://pub.dartlang.org`
   à zona confiável:

   1. Abra o Kaspersky Internet Security.
   2. Clique no ícone **Privacy**.
   3. Na seção **Block website tracking**, clique no botão **Preferences**.
   4. Na barra de ícones superior, selecione **Threats**.
   5. Em **Threats**, clique em **Trusted Zone**.
   6. Selecione a aba **Trusted web addresses**.
   7. Clique no botão **+** e adicione a URL `https://pub.dev`.
   8. Clique em **OK**.
   9. Repita os dois passos anteriores para `https://pub.dartlang.org`

</details>
