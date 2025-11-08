---
ia-translate: true
title: dart pub token
description: "Gerenciar tokens de autenticação para repositórios de pacotes."
---

O subcomando `dart pub token` gerencia um armazenamento de tokens.
Ao [publicar](pub-lish) pacotes e [recuperar](pub-get) dependências,
o comando `dart pub` usa tokens para autenticar em servidores de terceiros.

Ele armazena esses tokens em um [diretório de configuração em todo o usuário][config-dir].
O subcomando `dart pub token` possui três subcomandos:
[`add`][], [`list`][] e [`remove`][].

O comando `dart pub` considera os termos _credencial_, _token_, _segredo_ e
_token secreto_ como intercambiáveis.

[`add`]: #add-a-new-credential
[`list`]: #return-a-list-of-credentials
[`remove`]: #remove-one-or-more-credentials

## Caso de uso para credenciais {:#use-case-for-credentials}

Considere um cenário em que você tenha uma [dependência](/tools/pub/dependencies)
hospedada em um repositório privado.
Quando você usa o comando `dart pub get`, ele _pode_ retornar um prompt
para fornecer credenciais:

```console
$ dart pub get
Resolvendo dependências...
https://some-package-repo.com/my-org/my-repo repositório de pacotes solicitou autenticação!
Você pode fornecer credenciais usando:
    dart pub token add https://some-package-repo.com/my-org/my-repo
```

Alguns, mas não todos, os servidores também retornam uma mensagem com instruções sobre
como você pode obter um token.

## Adicionar uma nova credencial {:#add-a-new-credential}

Para criar uma nova credencial,
use o comando `dart pub token add`.

### Adicionar uma credencial para a sessão atual {:#add-a-credential-for-the-current-session}

No prompt, digite a credencial na linha de comando (`stdin`).

```console
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Digite o token secreto: <Digite o token no stdin>
Solicitações para "https://some-package-repo.com/my-org/my-repo" agora serão
autenticadas usando o token secreto.
```

:::note
Para manter o token fora do histórico do shell,
o comando `dart pub token` recebe a entrada em `stdin` em vez de
como uma opção de linha de comando.
:::

### Adicionar uma credencial para todas as sessões {:#add-a-credential-for-all-sessions}

Para usar o mesmo token para todas as sessões de terminal e em scripts,
armazene o token em uma variável de ambiente.

1. Armazene seu token em uma variável de ambiente.

   Certifique-se de ocultar o token do histórico do seu shell.
   Para explorar uma forma de fazer isso, consulte [esta postagem no Medium][zsh-post].

2. Para habilitar quaisquer variáveis de ambiente que você adicionar,
   reinicie todos os consoles abertos.

3. Para usar uma variável de ambiente como token,
   use o comando `dart pub token add`:

   ```console
   $ dart pub token add <hosted-url> --env-var <TOKEN_VAR>
   ```

   Este comando lê o token armazenado em `$TOKEN_VAR`
   e então o usa para autenticar com a `hosted-url`
   que hospeda o pacote desejado.
   Ele deve imprimir a seguinte resposta no terminal.

   ```console
   $ dart pub token add https://other-package-repo.com/ --env-var TOKEN_VAR
   Solicitações para "https://other-package-repo.com/" agora serão autenticadas usando o token secreto armazenado na variável de ambiente "TOKEN_VAR".
   ```

A maioria dos ambientes de CI pode injetar tokens em uma variável de ambiente.
Para saber como, consulte a documentação para [GitHub Actions][] ou
[GitLab][] como exemplos.

[GitHub Actions]: https://docs.github.com/actions/security-guides/encrypted-secrets#using-encrypted-secrets-in-a-workflow
[GitLab]: https://docs.gitlab.com/ee/ci/secrets/
[zsh-post]: https://medium.com/@prasincs/hiding-secret-keys-from-shell-history-part-1-5875eb5556cc

## Retornar uma lista de credenciais {:#return-a-list-of-credentials}

Para ver uma lista de todas as credenciais ativas, use o comando `dart pub token list`:

```console
$ dart pub token list
Você tem tokens secretos para 2 repositórios de pacotes:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

## Remover uma ou mais credenciais {:#remove-one-or-more-credentials}

Para remover um único token, use o comando `dart pub token remove`:

```console
$ dart pub token remove https://other-package-repo.com
Token secreto removido para o repositório de pacotes: https://other-package-repo.com
```

Para remover todos os tokens, use o comando anterior com a opção `remove --all`:

```console
$ dart pub token remove --all
pub-tokens.json foi excluído.
1 tokens secretos removidos.
```

{% render 'pub-problems.md' %}

[config-dir]: {{site.repo.dart.org}}/cli_util/blob/71ba36e2554f7b7717f3f12b5ddd33751a4e3ddd/lib/cli_util.dart#L88-L118