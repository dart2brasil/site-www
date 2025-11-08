---
title: dart pub bump
description: Use dart pub bump to increase the version number of the current package.
ia-translate: true
---

_Bump_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub bump <subcommand> [options]
```

Este comando incrementa o número de versão do pacote atual.
Use um dos subcomandos `breaking`, `major`, `minor`,
ou `patch` de acordo com o tipo de incremento desejado.

Consulte [semver](https://semver.org/spec/v2.0.0-rc.1.html) para orientação sobre o versionamento do seu pacote.
Por exemplo:

```console
$ dart pub bump minor
  Updating version from 1.0.0 to 1.1.0

  Diff:
  - version: 1.0.0
  + version: 1.1.0

  Remember to update `CHANGELOG.md` before publishing.
```

## Opções

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `-n, --dry-run`

Relata o que mudaria para o número de versão em cada subcomando,
e mostra o diff da versão, sem alterar nada.
