---
ia-translate: true
title: "Solução de problemas do pub"
description: "Problemas comuns que você pode encontrar ao usar o pub."
---

## Recebendo um erro "403" ao publicar um pacote {:#pub-publish-403}

Você recebe o seguinte erro ao executar `pub publish`:

```plaintext
Erro HTTP 403: Proibido
...
Você não é um uploader (responsável pelo envio) para o pacote '<foo>'
```

Esse problema pode ocorrer se uma de suas contas recebeu permissão para
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

Se você estiver usando o Prompt de Comando:

```cmd
$ del "%APPDATA%\dart\pub-credentials.json"
```

Se você estiver usando o PowerShell:

```ps
$ Remove-Item -Path "%APPDATA%\dart\pub-credentials.json"
```

:::version-note
No Dart 2.14 ou anterior,
você deve, em vez disso, excluir o arquivo `credentials.json`
encontrado na pasta [`PUB_CACHE`][].
:::

[`PUB_CACHE`]: /tools/pub/environment-variables

## Recebendo um erro "UnauthorizedAccess" ao publicar um pacote {:#pub-publish-unauthorized}

Você recebe o seguinte erro ao executar `pub publish`:

```plaintext
UnauthorizedAccess: Usuário não autorizado: <nome de usuário> não tem permissão para enviar versões para o pacote '<foo>'.
```

Você verá esta mensagem se não estiver na lista de pessoas
autorizadas a publicar novas versões de um pacote.
Veja [Uploaders](/tools/pub/publishing#uploaders) (Responsáveis pelo envio).

## O Pub build falha com erro HttpException {:#pub-get-fails}

Você recebe um erro HttpException semelhante ao seguinte ao
executar `pub build`:

```plaintext
Pub build falhou, [1] IsolateSpawnException: 'HttpException: Conexão fechada ao receber dados,
...
manipulador da biblioteca falhou
...
```

Isso pode acontecer como resultado de algum software antivírus, como o
AVG 2013 Internet security suite. Consulte o manual do seu pacote de segurança
para ver como desabilitar temporariamente
esse recurso. Por exemplo, veja
[How to Disable AVG Components](https://support.avg.com/SupportArticleView?urlName=How-to-disable-AVG) (Como desabilitar componentes AVG).

## Pub get falha por trás de um firewall corporativo {:#pub-get-fails-from-behind-a-corporate-firewall}

Na linha de comando, o pub respeita as variáveis de ambiente `http_proxy` e `https_proxy`.
Você pode definir a variável de ambiente do servidor
proxy da seguinte forma.

No Linux/macOS:

```console
$ export https_proxy=hostname:port
```

No Prompt de Comando do Windows:

```cmd
$ set https_proxy=hostname:port
```

No Windows PowerShell:

```ps
$ $Env:https_proxy="hostname:port"
```

Se o proxy exigir credenciais, você pode defini-las da seguinte forma.

No Linux/macOS:

```console
$ export https_proxy=username:password@hostname:port
```

No Prompt de Comando do Windows:

```cmd
$ set https_proxy=username:password@hostname:port
```

No Windows PowerShell:

```ps
$ $Env:https_proxy="username:password@hostname:port"
```

## Localhost inacessível após o login {:#localhost-unreachable-after-sign-in}

Quando você executa `dart pub publish` em um container (recipiente) ou por meio de uma sessão SSH,
o `localhost` que o `dart pub` está monitorando pode ser diferente do
`localhost` que está acessível em seu navegador.
Embora você possa fazer login usando o navegador,
o navegador reclama que `http://localhost:<port>?code=...`
não está acessível.

Tente esta solução alternativa, que usa a linha de comando para concluir o login:

1. Em uma janela de terminal, execute `dart pub publish`.
2. Na janela do navegador que aparece, faça login. <br>
   O navegador é redirecionado para um _nova URL localhost_
   (`http://localhost:<port>?code=...`)
   mas reclama que a URL não está acessível.
3. Copie a _nova URL localhost_ do navegador.
4. Em outra janela de terminal no mesmo container ou no mesmo host
   onde `dart pub publish` foi chamado, use o comando `curl` para
   concluir o login usando a _nova URL localhost_:

   ```console
   $ curl 'http://localhost:<port>?code=...'
   ```

## Recebendo um erro de socket ao tentar encontrar um pacote {:#pub-get-socket-error}

O seguinte erro pode ocorrer se
você não tiver acesso à internet, seu ISP (provedor de serviços de internet) estiver bloqueando o `pub.dev`,
ou um software de segurança estiver bloqueando o acesso à internet do `dart`.

```plaintext
Obteve erro de socket ao tentar encontrar o pacote ... em https://pub.dev.
pub get falhou (servidor indisponível) -- tentando novamente 1 em 1 segundo...
```

Verifique sua conexão com a internet e
verifique se você não tem um firewall ou outro software de segurança
que bloqueie o acesso à internet do `dart`.

<details>
 <summary>
   <b>Instruções detalhadas para Kaspersky Internet Security</b>
  </summary>

   Quando você desativa a proteção _Kaspersky Internet Security_
   na barra de menus,
   o filtro de aplicativo VPN `sysextctrld`
   ainda é executado em segundo plano.
   Este filtro causa uma falha na conexão com `pub.dev`.
   Para resolver este problema,
   adicione `https://pub.dev` e `https://pub.dartlang.org`
   à zona confiável:

   1. Abra o Kaspersky Internet Security.
   2. Clique no ícone **Privacidade**.
   3. Na seção **Bloquear rastreamento de sites**, clique no botão **Preferências**.
   4. Na barra de ícones superior, selecione **Ameaças**.
   5. Em **Ameaças**, clique em **Zona confiável**.
   6. Selecione a guia **Endereços da web confiáveis**.
   7. Clique no botão **+** e adicione a URL `https://pub.dev`.
   8. Clique em **OK**.
   9. Repita as duas etapas anteriores para `https://pub.dartlang.org`

</details>