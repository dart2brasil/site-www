---
ia-translate: true
title: Glossário de termos de pacotes
description: Um glossário de termos relacionados à ferramenta de gerenciamento de pacotes do Dart, pub.
---

Os seguintes termos são usados na documentação para
[gerenciamento de pacotes][] e
a [ferramenta pub][].

[gerenciamento de pacotes]: /tools/pub/packages
[ferramenta pub]: /tools/pub/cmd

## Pacote de aplicativo {:#application-package}

Um pacote que contém um programa ou aplicativo, com um [ponto de entrada principal][].
Destinado a ser executado diretamente, seja na linha de comando ou em um navegador.

Pacotes de aplicativos podem ter [dependências][] em outros pacotes,
mas nunca são dependidos eles mesmos.
Ao contrário dos [pacotes][] regulares, eles não se destinam a ser compartilhados.

Pacotes de aplicativos devem verificar seus [lockfiles][] no controle de versão,
para que todos que trabalham no aplicativo e em todos os locais onde o
aplicativo é implantado tenham um conjunto consistente de dependências. Como suas
dependências são restringidas pelo lockfile, pacotes de aplicativos geralmente
especificam `any` para suas [restrições de versão][] de dependências.

[ponto de entrada principal]: #entrypoint
[dependências]: #dependency
[pacotes]: #package
[lockfiles]: #lockfile
[restrições de versão]: #version-constraint

## Hashes de conteúdo {:#content-hashes}

O repositório pub.dev mantém um hash sha256 de cada versão de pacote que hospeda.
Clientes Pub podem usar este hash para validar a integridade dos pacotes baixados,
e proteger contra alterações no repositório.

Quando `dart pub get` baixa um pacote,
ele calcula o hash do arquivo baixado.
O hash de cada dependência hospedada é armazenado com a
[resolução][] no [lockfile][].

O cliente pub usa este hash de conteúdo
para verificar se a execução de `dart pub get` novamente usando o mesmo lockfile,
potencialmente em um computador diferente, usa exatamente os mesmos pacotes.

Se o hash bloqueado não corresponder ao que está atualmente no cache pub,
pub baixa o arquivo novamente. Se ainda não corresponder, o lockfile
atualiza e um aviso é impresso. Por exemplo:

```plaintext
$ dart pub get
Resolvendo dependências...
[!A versão em cache de foo-1.0.0 tem hash incorreto - baixando novamente.!]
 ~ foo 1.0.0 (era 1.0.0)
[!O hash de conteúdo existente do pubspec.lock não corresponde ao conteúdo de:!]
 * foo-1.0.0 de "pub.dev"
Isso indica um de:
 * O conteúdo foi alterado no servidor desde que você criou o pubspec.lock.
 * O pubspec.lock foi corrompido.
 
[!Os hashes de conteúdo em pubspec.lock foram atualizados.!]

Para mais informações, veja:
https://dartbrasil.dev/go/content-hashes

Alterada 1 dependência!
```

O hash de conteúdo atualizado aparecerá no seu diff de controle de versão,
e deve deixá-lo desconfiado.

Para fazer uma discrepância se tornar um erro em vez de um aviso, use
[`dart pub get --enforce-lockfile`][]. Isso fará com que a resolução falhe
se não conseguir encontrar arquivos de pacote com os mesmos hashes, sem atualizar o lockfile.

```plaintext
$ dart pub get [!--enforce-lockfile!]
Resolvendo dependências...
A versão em cache de foo-1.0.0 tem hash incorreto - baixando novamente.
~ foo 1.0.0 (era 1.0.0)
O hash de conteúdo existente do pubspec.lock não corresponde ao conteúdo de:
 * foo-1.0.0 de "pub.dev"

Isso indica um de:
 * O conteúdo foi alterado no servidor desde que você criou o pubspec.lock.
 * O pubspec.lock foi corrompido.

Para mais informações, veja:
https://dartbrasil.dev/go/content-hashes
[!Mudaria 1 dependência.!]
[!Não é possível satisfazer `pubspec.yaml` usando `pubspec.lock`.!]

Para atualizar `pubspec.lock` execute `dart pub get` sem
`--enforce-lockfile`.
```

[resolução]: /tools/pub/cmd/pub-get
[lockfile]: #lockfile
[`dart pub get --enforce-lockfile`]: /tools/pub/cmd/pub-get#enforce-lockfile

## Dependência {:#dependency}

Outro pacote do qual seu pacote depende. Se seu pacote quiser importar
código de algum outro pacote, esse pacote deve ser uma dependência. Dependências
são especificadas no [pubspec][] do seu pacote e descritas em
[Dependências de pacote][].

Para ver as dependências usadas por um pacote, use [`pub deps`][].

[pubspec]: /tools/pub/pubspec
[Dependências de pacote]: /tools/pub/dependencies
[`pub deps`]: /tools/pub/cmd/pub-deps

## Ponto de entrada {:#entrypoint}

No contexto geral do Dart, um _ponto de entrada_ é
uma biblioteca Dart que é invocada diretamente por uma implementação Dart. Quando você
referencia uma biblioteca Dart em uma tag `<script>` ou a passa como um argumento de linha de comando
para a VM Dart autônoma, essa biblioteca é o ponto de entrada. Em outras
palavras, geralmente é o arquivo `.dart` que contém `main()`.

No contexto do pub, um _pacote de ponto de entrada_ ou _pacote raiz_ é a raiz
de um gráfico de dependência. Geralmente será um aplicativo. Quando você executa seu aplicativo,
é o pacote de ponto de entrada. Todos os outros pacotes dos quais ele depende não serão um
ponto de entrada nesse contexto.

Um pacote pode ser um ponto de entrada em alguns contextos e não em outros. Digamos que seu
aplicativo use um pacote `A`. Quando você executa seu aplicativo, `A` não é o pacote de ponto de entrada.
No entanto, se você for para `A` e executar seus testes, nesse
contexto, *é* o ponto de entrada, já que seu aplicativo não está envolvido.

## Diretório de ponto de entrada {:#entrypoint-directory}

Um diretório dentro do seu pacote que pode conter
[pontos de entrada Dart](#entrypoint).

Pub tem uma lista desses diretórios: `benchmark`, `bin`, `example`,
`test`, `tool` e `web` (e `lib`, para [aplicativos Flutter][]).
Quaisquer subdiretórios desses (exceto `bin`) também podem conter pontos de entrada.

[aplicativos Flutter]: {{site.flutter-docs}}/packages-and-plugins/developing-packages

## Dependência imediata {:#immediate-dependency}

Uma [dependência](#dependency) que seu pacote usa diretamente. As
dependências que você lista no seu pubspec são as dependências imediatas do seu pacote.
Todas as outras dependências são [dependências transitivas](#transitive-dependency).

## Biblioteca {:#library}

Uma biblioteca é uma única unidade de compilação, composta por um único arquivo primário e qualquer
número opcional de [partes][]. As bibliotecas têm seu próprio escopo privado.

[partes]: /resources/glossary#part-file-arquivo-de-parte

## Lockfile {:#lockfile}

Um arquivo chamado `pubspec.lock` que especifica as versões concretas e outras
informações de identificação para cada dependência imediata e transitiva que um pacote
depende.

Ao contrário do pubspec, que lista apenas as dependências imediatas e permite intervalos de versão,
o lockfile fixa de forma abrangente todo o gráfico de dependência em
versões específicas de pacotes. Um lockfile garante que você pode recriar a
configuração exata de pacotes usada por um aplicativo.

O lockfile é gerado automaticamente para você pelo pub quando você executa
[`pub get`](/tools/pub/cmd/pub-get), [`pub upgrade`](/tools/pub/cmd/pub-upgrade) ou
[`pub downgrade`](/tools/pub/cmd/pub-downgrade).
O Pub inclui um [hash de conteúdo][] para cada pacote
para verificar durante resoluções futuras.

Se seu pacote for um [pacote de aplicativo][], você normalmente verificará isso no
controle de versão. Para pacotes regulares, você geralmente não fará isso.

[hash de conteúdo]: #content-hashes

<a id="library-package"></a>

## Pacote {:#package}

Uma coleção de [bibliotecas] em um diretório,
com um [pubspec.yaml] na raiz desse diretório.

Pacotes podem ter [dependências](#dependency) em outros pacotes
*e* podem ser dependências eles mesmos.
O diretório `/lib` de um pacote contém as
[bibliotecas públicas][] que outros pacotes podem importar e usar.
Eles também podem incluir scripts a serem executados diretamente.
Um pacote que não se destina a depender de outros pacotes é um
[pacote de aplicativo][].
Pacotes compartilhados são [publicados][] no pub.dev,
mas você também pode ter pacotes não publicados.

Não verifique o [lockfile][] de um pacote no controle de versão,
já que as bibliotecas devem suportar uma variedade de versões de dependência. A
[restrições de versão][] das
[dependências imediatas][] de um pacote devem ser o mais amplas possível, enquanto ainda
garantindo que as dependências sejam compatíveis com as versões que foram
testadas.

Como [versionamento semântico](https://semver.org/spec/v2.0.0-rc.1.html) requer
que as bibliotecas incrementem seus números de versão principal para qualquer retrocompatibilidade
alterações incompatíveis, os pacotes geralmente exigirão que as versões de suas dependências
sejam maiores ou iguais às versões que foram testadas e menores
que a próxima versão principal. Portanto, se sua biblioteca dependesse do (fictício)
pacote `transmogrify` e você o testou na versão 1.2.1, sua versão
restrição seria [`^1.2.1`][].

[bibliotecas]: #library
[pubspec.yaml]: /tools/pub/pubspec
[bibliotecas públicas]: /tools/pub/package-layout#public-libraries
[pacote de aplicativo]: #application-package
[publicados]: /tools/pub/publishing
[lockfile]: #lockfile
[restrições de versão]: #version-constraint
[dependências imediatas]: #immediate-dependency
[`^1.2.1`]: /tools/pub/dependencies#caret-syntax

## Restrição SDK {:#sdk-constraint}

As versões declaradas do próprio SDK Dart que um pacote declara que
suporta. Uma restrição de SDK é especificada usando um normal
[sintaxe de restrição de versão](#version-constraint), mas em uma _environment_ especial
seção [no pubspec](/tools/pub/pubspec#sdk-constraints).

## Fonte {:#source}

Um tipo de lugar de onde o pub pode obter pacotes. Uma fonte não é um lugar específico
como o site pub.dev ou algum URL Git específico. Cada fonte descreve um geral
procedimento para acessar um pacote de alguma forma. Por exemplo, _git_ é uma fonte.
A fonte git sabe como baixar pacotes dado um URL Git. Vários
[fontes suportadas](/tools/pub/dependencies#dependency-sources) estão disponíveis.

## Cache do sistema {:#system-cache}

Quando o pub obtém um pacote remoto,
ele o baixa para um único diretório _cache do sistema_ mantido pelo
pub. No Mac e Linux, este diretório usa `~/.pub-cache` por padrão.
No Windows, o diretório usa `%LOCALAPPDATA%\Pub\Cache` por padrão,
embora sua localização exata possa variar dependendo da versão do Windows.
Você pode especificar um local diferente usando a
variável de ambiente [PUB_CACHE](/tools/pub/environment-variables).

Uma vez que os pacotes estão no cache do sistema,
o pub cria um arquivo `package_config.json` que mapeia cada pacote
usado pelo seu aplicativo para o pacote correspondente no cache.

Você só precisa baixar uma determinada versão de um pacote uma vez
e pode reutilizá-la em quantos pacotes quiser.
Se você especificar o sinalizador `--offline` para usar pacotes em cache,
você pode excluir e regenerar seus arquivos `package_config.json`
sem ter que acessar a rede.


## Dependência transitiva {:#transitive-dependency}

Uma dependência que seu pacote usa indiretamente porque uma de suas dependências
requer isso. Se seu pacote depende de A, que por sua vez depende de B que
depende de C, então A é uma [dependência imediata](#immediate-dependency) e B
e C são transitivas.


## Uploader (Responsável por upload) {:#uploader}

Alguém que tem permissões administrativas para um pacote.
Um responsável por upload de pacote pode fazer upload de novas versões do pacote,
e eles também podem
[adicionar e remover outros uploaders](/tools/pub/publishing#uploaders)
para esse pacote.

Se um pacote tiver um editor verificado,
então todos os membros do editor podem fazer upload do pacote.


## Editor verificado {:#verified-publisher}

Um ou mais usuários que possuem um conjunto de pacotes.
Cada editor verificado é identificado por um nome de domínio verificado, como
**dartbrasil.dev**.
Para obter informações gerais sobre editores verificados,
veja a [página de editores verificados][].
Para obter detalhes sobre como criar um editor verificado
e transferir pacotes para ele,
veja a documentação para [publicação de pacotes][].

[página de editores verificados]: /tools/pub/verified-publishers
[publicação de pacotes]: /tools/pub/publishing#verified-publisher

## Restrição de versão {:#version-constraint}

Uma restrição colocada em cada [dependência](#dependency) de um pacote que
especifica com quais versões dessa dependência o pacote deve funcionar
com. Isso pode ser uma única versão (`0.3.0`) ou um intervalo de versões (`^1.2.1`).
Embora `any` também seja permitido, por razões de desempenho não o recomendamos.

Para mais informações, veja
[Restrições de versão](/tools/pub/dependencies#version-constraints).

[Pacotes](#package) sempre devem especificar restrições de versão
para todas as suas dependências. [Pacotes de aplicativos](#application-package),
por outro lado, geralmente devem permitir qualquer versão de suas dependências,
já que eles usam o [lockfile](#lockfile) para gerenciar suas versões de dependência.

Para mais informações, veja
[Filosofia de versionamento do Pub](/tools/pub/versioning).

## Workspace (Espaço de trabalho) {:#workspace}

Uma coleção de pacotes que são desenvolvidos em conjunto com uma
resolução compartilhada de suas restrições de dependência.
Útil para desenvolver em um monorepo.

Os pacotes têm um `pubspec.lock` e `.dart_tool/package_config.json` compartilhados.

Para saber mais sobre como configurar e desenvolver em um workspace,
confira [Workspaces do Pub](/tools/pub/workspaces).