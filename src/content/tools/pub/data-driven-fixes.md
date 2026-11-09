---
ia-translate: true
title: Correções orientadas a dados
description: >-
  Ative o dart fix para migrar código em mudanças incompatíveis de pacotes do pub.
prevpage:
  url: /tools/pub/publishing
  title: Publicando pacotes
nextpage:
  url: /tools/pub/writing-package-pages
  title: Escrevendo páginas de pacote
---

Como mantenedor de um [pacote](/tools/pub/packages),
modificar ou descontinuar APIs públicas pode quebrar o código existente dos seus usuários.
Para ajudar seus usuários a atualizar sem problemas,
você pode fornecer _correções orientadas a dados_ (_data-driven fixes_).

Correções orientadas a dados são regras de migração declarativas
armazenadas diretamente dentro do seu pacote.
Depois que os usuários atualizam para uma versão mais nova do seu pacote,
eles podem aplicar essas migrações com o [`dart fix`][] ou com as correções rápidas da IDE.

## Ativar correções orientadas a dados no seu pacote {:#add-fixes}

Para fornecer migrações automatizadas para o seu pacote,
siga estes passos.

### 1. Adicione um arquivo de dados de correção {:#1-add-a-fix-data-file}

Adicione um arquivo chamado `fix_data.yaml` no diretório `lib/` do seu pacote:

<FileTree>

- my_package/
  - lib/
    - fix_data.yaml
    - my_package.dart
  - pubspec.yaml

</FileTree>

Se você tiver muitas correções,
pode dividi-las em vários arquivos dentro do diretório `lib/fix_data/`.

### 2. Defina transformações de API {:#2-define-api-transforms}

No `fix_data.yaml`, especifique a versão do formato (`version: 1`)
e uma lista `transforms`.
Cada transformação descreve o elemento da API que mudou
e as alterações a serem aplicadas.

Por exemplo, se você renomear `oldMethod()` para `newMethod()` na classe `MyClass`:

```yaml title="lib/fix_data.yaml"
version: 1
transforms:
  - title: 'Rename oldMethod to newMethod'
    date: 2026-09-18
    element:
      uris: ['my_package.dart']
      method: 'oldMethod'
      inClass: 'MyClass'
    changes:
      - kind: 'rename'
        newName: 'newMethod'
```

* **`date`:** uma data no formato `YYYY-MM-DD` indicando
  quando a mudança foi introduzida.
* **`uris`:** uma lista de URIs de bibliotecas que exportam a API,
  relativas ao diretório `lib/`, como `'my_package.dart'`.

:::tip Boa prática: adicione correções quando descontinuar uma API
Adicione transformações no `fix_data.yaml` quando descontinuar uma API pela primeira vez,
antes de removê-la em uma versão posterior com quebra de compatibilidade.
Isso permite que os usuários migrem enquanto o código deles ainda compila.
:::

## Testar suas correções {:#test-your-fixes}

Para garantir que suas regras de migração funcionem como esperado,
configure pares de arquivos de teste e arquivos golden que
contenham o código esperado depois de aplicar as migrações.

### 1. Configure um diretório `test_fixes` {:#1-set-up-a-test_fixes-directory}

Crie um diretório `test_fixes/` na raiz do seu pacote:

<FileTree>

- my_package/
  - lib/
    - fix_data.yaml
  - test_fixes/
    - my_api.dart
    - my_api.dart.expect
  - pubspec.yaml

</FileTree>

* `my_api.dart`: código escrito para a API antiga.
* `my_api.dart.expect`: o código esperado depois de aplicar o `dart fix`.

Por exemplo, emparelhe seus arquivos de teste da seguinte forma:

```dart title="test_fixes/my_api.dart"
import 'package:my_package/my_package.dart';

void main() {
  MyClass().oldMethod();
}
```

```dart title="test_fixes/my_api.dart.expect"
import 'package:my_package/my_package.dart';

void main() {
  MyClass().newMethod();
}
```

### 2. Execute os testes {:#2-run-the-tests}

Na raiz do seu pacote, execute o `dart fix` com `--compare-to-golden`:

```console
$ dart fix test_fixes --compare-to-golden
```

Se a saída corresponder ao seu arquivo `.expect`, o comando termina com o código `0`.
Se houver diferença, ele exibe um diff e termina com um código diferente de zero,
o que o torna ideal para suítes de testes de CI.

## Saiba mais {:#learn-more}

Para saber mais sobre todos os tipos de mudança suportados
(como modificações de parâmetros e declarações substituídas),
condições e templates de código,
veja a [especificação de Data-driven Fixes][spec].

[`dart fix`]: /tools/dart-fix
[spec]: https://github.com/flutter/flutter/blob/master/docs/contributing/Data-driven-Fixes.md
