---
ia-translate: true
title: Defina classes e objetos
shortTitle: Classes e objetos
description: >-
  Aprenda sobre programação orientada a objetos em Dart, incluindo
  classes, construtores, getters e enums.
  Crie modelos de dados para argumentos de linha de comando.
layout: learn
---

Este capítulo aborda os fundamentos da
programação orientada a objetos (POO) em Dart.
Explore como criar [classes][classes],
definir construtores e campos,
calcular propriedades com [getters][getters] e
usar [enums][enums] para representar conjuntos fixos de valores.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Defina classes para modelar dados e comportamento
    icon: view_in_ar
  - title: Crie construtores com initializing formals e parâmetros nomeados
    icon: build
  - title: Use getters para calcular propriedades dinamicamente
    icon: functions
  - title: Use enums para representar conjuntos fixos de valores
    icon: format_list_bulleted
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo:

- Complete o Capítulo 4 e tenha um ambiente de desenvolvimento Dart
  funcionando com o projeto `dartpedia`.
- Entenda conceitos básicos de programação,
  como variáveis, funções e controle de fluxo.
- Entenda pacotes e bibliotecas em Dart.

## Classes e objetos em Dart {:#classes-and-objects-in-dart}

Classes reúnem dois componentes principais:

- **Estado (campos)**:
  Os dados que cada objeto guarda,
  como o `name` ou o texto de `help` de uma opção.
- **Comportamento (métodos e getters)**:
  As ações que um objeto pode executar ou as propriedades que ele calcula,
  como formatar uma string de `usage`.

Em vez de controlar strings ou mapas soltos ao longo de uma aplicação,
modelar argumentos de linha de comando como classes garante
segurança de tipos em tempo de compilação,
autocompletar no editor e uma estrutura de dados consistente.

## Tarefas {:#tasks}

Uma interface de linha de comando (CLI) é definida pelos
comandos, opções e argumentos digitados em um terminal.

Esta lição e a próxima constroem um framework capaz de analisar um comando como:

```bash
$ dartpedia help --verbose --command=search
```

Cada parte tem uma função distinta:

- `dartpedia`:
  O **executável**, ou o nome da aplicação.
- `help`:
  Um **comando**, representando uma ação a ser executada.
- `--verbose`:
  Uma **flag** (uma opção booleana sem valor),
  que modifica o comportamento do comando.
- `--command=search`:
  Uma **opção** que aceita um valor (`search`).

Este capítulo constrói os modelos de dados que representam
as opções e os resultados analisados.

### Tarefa 1: Defina o enum OptionType {:#task-1-define-the-optiontype-enum}

Opções de linha de comando se dividem em duas categorias distintas:
flags (que valem `true` ou `false`) e
opções comuns (que aceitam um valor de texto).
Usar um enum garante que o código aceite apenas essas duas categorias válidas.

1.  Crie `command_runner/lib/src/arguments.dart`.

1.  Defina o enum `OptionType`:

    ```dart title="command_runner/lib/src/arguments.dart"
    enum OptionType { flag, option }
    ```

    Esta enumeração define dois membros: `flag` e `option`.
    Enums oferecem segurança de tipos em tempo de compilação,
    garantindo que o código aceite apenas tipos de opção válidos.

### Tarefa 2: Defina a classe Option {:#task-2-define-the-option-class}

Classes em Dart definem blueprints para objetos,
combinando estado (campos) e comportamento (métodos e getters).
A classe `Option` modela opções de linha de comando como
`--verbose` ou `--command=search`.

1.  Comece definindo uma classe `Option` mínima
    com os campos essenciais e um construtor.
    Adicione o código a seguir em `command_runner/lib/src/arguments.dart`,
    abaixo do enum:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option {
      Option(this.name, {required this.type});

      final String name;
      final OptionType type;
    }
    ```

    - **Campos (`final String name;`, `final OptionType type;`)**:
      Variáveis que guardam os dados do objeto.
      Declará-los como `final` garante que não mudem após a criação.
    - **Construtor (`Option(...)`)**:
      Instancia novos objetos `Option`.
      A sintaxe `this.name` é um *initializing formal*, um atalho do Dart
      que atribui o argumento diretamente ao campo da instância
      antes de o corpo do construtor ser executado.
    - **Parâmetros nomeados (`{required this.type}`)**:
      Parâmetros entre chaves `{}` são passados pelo nome
      (por exemplo, `Option('verbose', type: OptionType.flag)`).
      A palavra-chave `required` torna o parâmetro obrigatório.

1.  Agora, expanda a classe `Option` com campos de metadados opcionais
    e um getter `usage`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option {
      Option(
        this.name, {
        required this.type,
        this.help,
        this.abbr,
        this.defaultValue,
        this.valueHelp,
      });

      final String name;
      final OptionType type;
      final String? help;
      final String? abbr;
      final Object? defaultValue;
      final String? valueHelp;

      String get usage {
        if (abbr != null) {
          return '-$abbr,--$name: $help';
        }

        return '--$name: $help';
      }
    }
    ```

    - **Tipos anuláveis (`String?`, `Object?`)**:
      O ponto de interrogação `?` indica que um campo é opcional
      e pode conter `null`.
      Quando quem chama omite `help` ou `abbr`, eles assumem `null`.
    - **Getter (`get usage`)**:
      Um getter calcula um valor sob demanda, quando é acessado,
      formatando a string de ajuda conforme exista ou não uma abreviação.

### Tarefa 3: Defina a classe ArgResults {:#task-3-define-the-argresults-class}

A classe `ArgResults` armazena o resultado da análise da entrada
de linha de comando.
Ela associa cada `Option` ao valor informado pelo usuário.

1.  Adicione `ArgResults` ao final de `command_runner/lib/src/arguments.dart`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class ArgResults {
      String? command;
      String? commandArg;
      Map<Option, Object?> options = {};

      // Returns true if the flag exists and is true.
      bool flag(String name) {
        for (var option in options.keys.where(
          (option) => option.type == OptionType.flag,
        )) {
          if (option.name == name) {
            return options[option] as bool;
          }
        }
        return false;
      }

      bool hasOption(String name) {
        return options.keys.any((option) => option.name == name);
      }

      ({Option option, Object? input}) getOption(String name) {
        var mapEntry = options.entries.firstWhere(
          (entry) => entry.key.name == name || entry.key.abbr == name,
        );

        return (option: mapEntry.key, input: mapEntry.value);
      }
    }
    ```

    Destaques do código anterior:

    - **Mapa `options` (`Map<Option, Object?>`)**:
      Associa cada instância de `Option` à sua entrada analisada.
    - **Método `where()` em `flag()`**:
      Filtra as chaves do mapa para inspecionar apenas flags booleanas
      (`option.type == OptionType.flag`),
      ignorando opções que recebem argumentos de texto.
    - **Cast de tipo (`as bool`)**:
      Informa ao verificador de tipos que o valor deve ser tratado como `bool`,
      porque flags sempre armazenam valores booleanos.
    - **Tipo de retorno de record (`({Option option, Object? input})`)**:
      Retorna um record leve e nomeado, que agrupa a `Option`
      e o seu valor, sem precisar declarar uma classe separada.

    A classe `ArgResults` serve como contrato de dados para a saída analisada.
    O Capítulo 6 conecta essa classe ao `CommandRunner` completo.

### Tarefa 4: Exporte os argumentos do pacote {:#task-4-export-arguments-from-the-package}

Exporte `arguments.dart` a partir do ponto de entrada do pacote,
para que outros pacotes possam importar `Option` e `ArgResults`.

1.  Abra `command_runner/lib/command_runner.dart`.

1.  Exporte `arguments.dart` junto com `command_runner_base.dart`:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for command-line parsing and execution.
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    ```

    Esta instrução `export` torna as declarações de `arguments.dart`
    acessíveis a qualquer pacote que importe
    `package:command_runner/command_runner.dart`.

### Tarefa 5: Teste as classes em cli.dart {:#task-5-test-the-classes-in-clidart}

Verifique se `Option` é instanciada e calcula corretamente a string `usage`.

1.  Abra `cli/bin/cli.dart`.

1.  Substitua o conteúdo do arquivo pelo código de teste a seguir:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    void main() {
      final verboseOption = Option(
        'verbose',
        type: OptionType.flag,
        abbr: 'v',
        help: 'Display extra logging information.',
      );

      print('Defined option: ${verboseOption.name}');
      print('Usage: ${verboseOption.usage}');
    }
    ```

    Este código chama o construtor de `Option` para criar uma instância
    e depois imprime o campo `name` e o getter `usage` calculado.

1.  Execute a aplicação a partir do diretório `cli`:

    ```bash
    dart run bin/cli.dart
    ```

    O console mostra:

    ```bash
    Defined option: verbose
    Usage: -v,--verbose: Display extra logging information.
    ```

    Isso confirma que a classe `Option` e o getter funcionam como esperado.

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Um resumo dos conceitos e do código introduzidos nesta lição.
completed: true
items:
  - title: Definiu classes para modelar dados e comportamento
    icon: view_in_ar
    details: >-
      Criou as classes `Option` e `ArgResults` para estruturar os argumentos
      de linha de comando e a saída analisada.
  - title: Criou construtores com initializing formals e parâmetros nomeados
    icon: build
    details: >-
      Usou a sintaxe `this.fieldName` para inicialização automática de campos
      e definiu parâmetros nomeados opcionais e obrigatórios com `{}` e `required`.
  - title: Usou getters para calcular propriedades dinamicamente
    icon: functions
    details: >-
      Implementou o getter `usage` para formatar o texto de ajuda da opção
      sob demanda, sem armazenar estado de string duplicado.
  - title: Usou enums para representar conjuntos fixos de valores
    icon: format_list_bulleted
    details: >-
      Definiu o enum `OptionType` para representar os tipos de opção válidos
      (`flag` e `option`), garantindo segurança em tempo de compilação.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Check your understanding" id="object-oriented" />

## Próxima lição {:#next-lesson}

O próximo capítulo aborda como compartilhar comportamento entre classes
usando herança e classes abstratas.
Defina uma classe base abstrata `CliElement` e
construa a arquitetura `Command` e `CommandRunner`.

[classes]: /language/classes
[getters]: /resources/glossary#getter
[enums]: /language/enums
