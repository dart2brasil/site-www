---
ia-translate: true
title: dart pub bump
description: Use dart pub bump para aumentar o número da versão do pacote atual.
---

_Bump_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub bump <subcomando> [opções]
```

Este comando incrementa o número da versão do pacote atual.
Use um dos subcomandos `breaking` (quebra), `major` (principal), `minor` (secundário)
ou `patch` (correção) de acordo com o tipo de incremento desejado.

Consulte o [semver](https://semver.org/spec/v2.0.0-rc.1.html) (versionamento semântico) para orientação sobre como versionar seu pacote.
Por exemplo:

```console
$ dart pub bump minor
  Atualizando a versão de 1.0.0 para 1.1.0
  
  Diff:
  - version: 1.0.0
  + version: 1.1.0
  
  Lembre-se de atualizar `CHANGELOG.md` antes de publicar.
```

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `-n, --dry-run` {:#n-dry-run}

Relata o que mudaria para o número da versão sob cada subcomando,
e mostra a diferença da versão, sem alterar nada.