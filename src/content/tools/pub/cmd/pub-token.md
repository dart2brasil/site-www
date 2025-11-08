---
title: dart pub token
description: Gerenciar tokens de autenticação para repositórios de pacotes.
ia-translate: true
---

O subcomando `dart pub token` gerencia um armazenamento de tokens.
Ao [publicar](pub-lish) pacotes e [recuperar](pub-get) dependências,
o comando `dart pub` usa tokens para autenticar com servidores de terceiros.

Ele armazena esses tokens em um [diretório de configuração em nível de usuário][config-dir].
O subcomando `dart pub token` tem três subcomandos:
[`add`][], [`list`][] e [`remove`][].

O comando `dart pub` considera os termos _credencial_, _token_, _segredo_,
e _token secreto_ como intercambiáveis.

[`add`]: #adicionar-uma-nova-credencial
[`list`]: #retornar-uma-lista-de-credenciais
[`remove`]: #remover-uma-ou-mais-credenciais

## Caso de uso para credenciais

Considere um cenário quando você tem uma [dependência](/tools/pub/dependencies)
hospedada em um repositório privado.
Quando você usa o comando `dart pub get`, ele _pode_ retornar um aviso
para fornecer credenciais:

```console
$ dart pub get
Resolving dependencies...
https://some-package-repo.com/my-org/my-repo package repository requested authentication!
You can provide credentials using:
    dart pub token add https://some-package-repo.com/my-org/my-repo
```

Alguns, mas não todos os servidores, também retornam uma mensagem com instruções sobre
como você pode obter um token.

## Adicionar uma nova credencial

Para criar uma nova credencial,
use o comando `dart pub token add`.

### Adicionar uma credencial para a sessão atual

No aviso, digite a credencial na linha de comando (`stdin`).

```console
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
 Requests to "https://some-package-repo.com/my-org/my-repo" will now be
 authenticated using the secret token.
```

:::note
Para manter o token fora do histórico do shell,
o comando `dart pub token` recebe entrada em `stdin` em vez de
como uma opção de linha de comando.
:::

### Adicionar uma credencial para todas as sessões

Para usar o mesmo token em qualquer e todas as sessões de terminal e em scripts,
armazene o token em uma variável de ambiente.

1. Armazene seu token em uma variável de ambiente.

   Certifique-se de ocultar o token do histórico do seu shell.
   Para explorar uma maneira de fazer isso, consulte [este post no Medium][zsh-post].

1. Para ativar qualquer variável de ambiente que você adicione,
   reinicie qualquer console aberto.

1. Para usar uma variável de ambiente como um token,
   use o comando `dart pub token add`:

   ```console
   $ dart pub token add <hosted-url> --env-var <TOKEN_VAR>
   ```

   Este comando lê o token armazenado em `$TOKEN_VAR`
   e o usa para autenticar com `hosted-url`
   que hospeda o pacote desejado.
   Ele deve imprimir a seguinte resposta no terminal.

   ```console
   $ dart pub token add https://other-package-repo.com/ --env-var TOKEN_VAR
   Requests to "https://other-package-repo.com/" will now be authenticated using the secret token stored in the environment variable "TOKEN_VAR".
   ```

A maioria dos ambientes de CI pode injetar tokens em uma variável de ambiente.
Para saber como, consulte a documentação de [GitHub Actions][] ou
[GitLab][] como exemplos.

[GitHub Actions]: https://docs.github.com/actions/security-guides/encrypted-secrets#using-encrypted-secrets-in-a-workflow
[GitLab]: https://docs.gitlab.com/ee/ci/secrets/
[zsh-post]: https://medium.com/@prasincs/hiding-secret-keys-from-shell-history-part-1-5875eb5556cc

## Retornar uma lista de credenciais

Para ver uma lista de todas as credenciais ativas, use o comando `dart pub token list`:

```console
$ dart pub token list
You have secret tokens for 2 package repositories:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

## Remover uma ou mais credenciais

Para remover um único token, use o comando `dart pub token remove`:

```console
$ dart pub token remove https://other-package-repo.com
Removed secret token for package repository: https://other-package-repo.com
```

Para remover todos os tokens, use o comando anterior com a opção `remove --all`:

```console
$ dart pub token remove --all
pub-tokens.json is deleted.
Removed 1 secret tokens.
```

{% render 'pub-problems.md' %}

[config-dir]: {{site.repo.dart.org}}/cli_util/blob/71ba36e2554f7b7717f3f12b5ddd33751a4e3ddd/lib/cli_util.dart#L88-L118
