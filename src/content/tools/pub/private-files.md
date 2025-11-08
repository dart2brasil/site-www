---
title: What not to commit
description: >-
  Your development tools generate a bunch of files.
  Not all of them should be committed.
ia-translate: true
---

Quando você coloca código-fonte Dart em um repositório—usando a
[ferramenta pub](/tools/pub/cmd), [GitHub](https://github.com/),
ou outro sistema de gerenciamento de código-fonte—não inclua a maioria dos arquivos
que sua IDE ou editor de código, a ferramenta pub e outras ferramentas geram.

:::note
Exceto onde observado, esta página discute apenas repositórios de código-fonte,
_não_ deploy de aplicativos.
Alguns arquivos que você normalmente não colocaria em um repositório
são úteis ou essenciais quando você faz deploy de um aplicativo.
:::

## The rules

**Não faça commit** dos seguintes arquivos e diretórios
criados pelo pub:

```plaintext
.dart_tool/
build/
pubspec.lock  # Except for application packages
```

**Não faça commit** do diretório de documentação da API
criado por [`dart doc`](/tools/dart-doc):

```plaintext
doc/api/
```

**Não faça commit** de arquivos e diretórios
criados por outros ambientes de desenvolvimento.
Por exemplo, se seu ambiente de desenvolvimento cria
qualquer um dos seguintes arquivos,
considere colocá-los em um arquivo ignore global:

```plaintext
# IntelliJ
*.iml
*.ipr
*.iws
.idea/

# Mac
.DS_Store
```

Para mais detalhes, continue lendo.

## Details

Como regra, faça commit apenas dos arquivos que as pessoas precisam
para usar seu pacote ou repositório de código-fonte.
Incluir arquivos adicionais é desnecessário,
pode ser contraproducente,
e pode ter implicações de segurança
se você expor detalhes sobre a configuração da sua máquina.
Em muitos repositórios de código-fonte,
a prática comum é não fazer commit de arquivos gerados, de forma alguma.

Para evitar fazer commit de arquivos que são
específicos do seu fluxo de trabalho pessoal ou configuração,
considere usar um arquivo ignore global
(por exemplo, `.gitignore_global`).

Quando você usa pub de dentro de um repositório Git,
pub ignora os mesmos arquivos que o Git ignora.
Por exemplo, se você executar `pub publish` de um repositório Git
que tem um arquivo `.gitignore` contendo `keys.txt`,
então seu pacote publicado não conterá o arquivo `keys.txt`.

Para mais informações sobre arquivos `.gitignore`,
veja a página de ajuda do GitHub
[Ignoring files.](https://help.github.com/articles/ignoring-files)

### .dart_tool/

O diretório `.dart_tool/` contém arquivos usados por
várias ferramentas Dart.


### pubspec.lock

O arquivo `pubspec.lock` é um caso especial,
similar ao `Gemfile.lock` do Ruby.

**Para pacotes regulares**, **não faça commit** do arquivo `pubspec.lock`.
Regenerar o arquivo `pubspec.lock` permite que você teste seu pacote
contra as versões compatíveis mais recentes de suas dependências.

**Para application packages**,
recomendamos que você faça commit do arquivo `pubspec.lock`.
Versionar o arquivo `pubspec.lock`
garante que mudanças nas dependências transitivas sejam explícitas.
Cada vez que as dependências mudam devido a `dart pub upgrade`
ou uma mudança em `pubspec.yaml`
a diferença será aparente no arquivo lock.
