---
ia-translate: true
title: "O que não commitar"
description: >-
  Suas ferramentas de desenvolvimento geram um monte de arquivos.
  Nem todos eles devem ser commitados.
---

Quando você coloca código-fonte Dart em um repositório — usando a
[ferramenta pub](/tools/pub/cmd), [GitHub](https://github.com/),
ou outro sistema de gerenciamento de código-fonte — não inclua a maioria dos arquivos
que seu IDE ou editor de código, a ferramenta pub e outras ferramentas geram.

:::note
Exceto onde indicado, esta página discute apenas repositórios de código-fonte,
_não_ o deploy do aplicativo.
Alguns arquivos que você normalmente não colocaria em um repositório
são úteis ou essenciais quando você faz o deploy de um aplicativo.
:::

## As regras {:#the-rules}

**Não commite** os seguintes arquivos e diretórios
criados pelo pub:

```plaintext
.dart_tool/
build/
pubspec.lock  # Exceto para pacotes de aplicação
```

**Não commite** o diretório de documentação da API
criado por [`dart doc`](/tools/dart-doc):

```plaintext
doc/api/
```

**Não commite** arquivos e diretórios
criados por outros ambientes de desenvolvimento.
Por exemplo, se seu ambiente de desenvolvimento criar
qualquer um dos seguintes arquivos,
considere colocá-los em um arquivo de ignore global:

```plaintext
# IntelliJ {:#intellij}
*.iml
*.ipr
*.iws
.idea/

# Mac {:#mac}
.DS_Store
```

Para mais detalhes, continue lendo.

## Detalhes {:#details}

Como regra geral, commite apenas os arquivos que as pessoas precisam
para usar seu pacote ou repositório de código-fonte.
Incluir arquivos adicionais é desnecessário,
poderia ser contraproducente,
e pode ter implicações de segurança
se você expor detalhes sobre a configuração da sua máquina.
Em muitos repositórios de código-fonte,
a prática comum é não commitar arquivos gerados, de forma alguma.

Para evitar commitar arquivos que são
específicos do seu fluxo de trabalho pessoal ou configuração,
considere usar um arquivo de ignore global
(por exemplo, `.gitignore_global`).

Quando você usa o pub de dentro de um repositório Git,
o pub ignora os mesmos arquivos que o Git ignora.
Por exemplo, se você executar `pub publish` de um repositório Git
que tenha um arquivo `.gitignore` contendo `keys.txt`,
então seu pacote publicado não conterá o arquivo `keys.txt`.

Para mais informações sobre arquivos `.gitignore`,
veja a página de ajuda do GitHub
[Ignorando arquivos.](https://help.github.com/articles/ignoring-files)

### .dart_tool/ {:#dart-tool}

O diretório `.dart_tool/` contém arquivos usados por
várias ferramentas Dart.


### pubspec.lock {:#pubspec-lock}

O arquivo `pubspec.lock` é um caso especial,
semelhante ao `Gemfile.lock` do Ruby.

**Para pacotes regulares**, **não commite** o arquivo `pubspec.lock`.
Regenerar o arquivo `pubspec.lock` permite testar seu pacote
contra as versões compatíveis mais recentes de suas dependências.

**Para pacotes de aplicação**,
recomendamos que você commite o arquivo `pubspec.lock`.
Versionar o arquivo `pubspec.lock`
garante que as mudanças nas dependências transitivas sejam explícitas.
Cada vez que as dependências mudam devido a `dart pub upgrade`
ou uma mudança em `pubspec.yaml`
a diferença ficará aparente no arquivo de lock.