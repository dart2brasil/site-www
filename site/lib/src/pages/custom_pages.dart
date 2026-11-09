// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as path;

import '../components/common/tags.dart';
import '../markdown/markdown_parser.dart';
import '../models/diagnostic_model.dart';
import '../models/lints.dart';
import '../utils/server_only_utils.dart';
import 'glossary.dart';

/// All pages that should be loaded from memory rather than
/// from content loaded from the file system.
List<MemoryPage> get allMemoryPages => [
  _glossaryPage,
  _allLinterRulesPage,
  _allLinterRulesJson,
  ..._lintMemoryPages,
  ..._diagnosticMemoryPages,
];

/// The `/resources/glossary` page which hosts the [GlossaryIndex].
MemoryPage get _glossaryPage => MemoryPage.builder(
  path: 'resources/glossary.md',
  initialData: {
    'page': <String, Object?>{
      'title': 'Glossário',
      'showBreadcrumbs': false,
      'description':
          'Um glossário de referência para a terminologia '
          'usada em todo o dartbrasil.dev.',
      'showToc': false,
      'bodyClass': 'glossary-page',
    },
  },
  builder: (_) {
    return const GlossaryIndex();
  },
);

/// The date the diagnostic and lint docs were last extracted from the SDK.
/// Should be in `yyyy-mm-dd` format.
const String _diagnosticsLastUpdated = '2025-12-07';

/// The individual diagnostic message pages,
/// rendered at `/tools/diagnostics/<name>`.
List<MemoryPage> get _diagnosticMemoryPages {
  final diagnostics = readAndLoadDiagnostics();

  return [
    for (final diagnostic in diagnostics.where((d) => d.hasDocumentation)) ...[
      MemoryPage.builder(
        path: path.posix.join(
          'tools',
          'diagnostics',
          '${diagnostic.id}.md',
        ),
        initialData: {
          'page': <String, Object?>{
            'title': diagnostic.id,
            'underscore_breaker_titles': true,
            'description':
                'Detalhes sobre o diagnóstico \'${diagnostic.id}\' '
                'produzido pelo analisador do Dart.',
            'bodyClass': 'highlight-diagnostics',
            'sitemap': {
              'lastmod': _diagnosticsLastUpdated,
            },
          },
        },
        builder: (context) {
          return Component.fragment(
            [
              if (diagnostic.fromLint)
                Tags([
                  Tag(
                    'Regra de lint',
                    icon: 'toggle_on',
                    title:
                        'Saiba mais sobre a regra de lint que '
                        'ativa este diagnóstico.',
                    link: '/tools/linter-rules/${diagnostic.id}',
                  ),
                ]),
              DashMarkdown(
                content: [
                  if (diagnostic.previousNames.isNotEmpty)
                    diagnostic.previousNames
                        .map((oldName) => '_(Antes chamado de `$oldName`._)')
                        .join('\n\n'),
                  diagnostic.description,
                  ?diagnostic.documentation,
                ].where((content) => content.isNotEmpty).join('\n\n'),
              ),
            ],
          );
        },
      ),
      for (final previousDiagnosticName in diagnostic.previousNames)
        MemoryPage.builder(
          path: path.posix.join(
            'tools',
            'diagnostics',
            '$previousDiagnosticName.md',
          ),
          initialData: {
            'page': <String, Object?>{
              'title': previousDiagnosticName,
              'underscore_breaker_titles': true,
              'description':
                  'Detalhes sobre o diagnóstico \'$previousDiagnosticName\' '
                  'produzido pelo analisador do Dart.',
              'canonical':
                  'https://dart.dev/tools/diagnostics/${diagnostic.id}',
              'redirectTo': '/tools/diagnostics/${diagnostic.id}',
              'noindex': true,
              'sitemap': false,
            },
          },
          builder: (context) {
            return p([
              const span([.text('Diagnóstico renomeado para: ')]),
              a(href: '/tools/diagnostics/${diagnostic.id}', [
                .text(diagnostic.id),
              ]),
            ]);
          },
        ),
    ],
  ];
}

/// The individual linter rules pages, rendered to `/tools/linter-rules/<name>`.
List<MemoryPage> get _lintMemoryPages {
  final lintRules = readAndLoadLints();

  return [
    for (final lint in lintRules)
      for (final lintId in {lint.id, lint.id.toLowerCase()})
        MemoryPage.builder(
          path: path.posix.join(
            'tools',
            'linter-rules',
            '$lintId.md',
          ),
          initialData: {
            'page': <String, Object?>{
              'title': lint.name,
              'underscore_breaker_titles': true,
              'description': 'Saiba mais sobre a regra de lint ${lint.name}.',
              'bodyClass': 'highlight-diagnostics',
              // If this lint has a version not fully lower case,
              // specify that version as the canonical destination.
              if (lintId != lint.id)
                'canonical': 'https://dart.dev/tools/linter-rules/${lint.id}',
              if (lint.state == 'removed') ...const {
                'noindex': true,
                'sitemap': false,
              } else
                'sitemap': {
                  'lastmod': _diagnosticsLastUpdated,
                },
            },
          },
          builder: (context) {
            final incompatibleLintsText = StringBuffer();
            if (lint.incompatibleLints.isNotEmpty) {
              incompatibleLintsText.writeln('## Regras incompatíveis\n');
              incompatibleLintsText.writeln(
                'O lint `${lint.id}` é incompatível com '
                'as seguintes regras:',
              );
              incompatibleLintsText.writeln();
              for (final incompatibleLint in lint.incompatibleLints) {
                incompatibleLintsText.writeln(
                  '- [`$incompatibleLint`](/tools/linter-rules/$incompatibleLint)',
                );
              }
            }

            final releasedInVersion = lint.releasedInVersion;
            final unreleasedLint =
                lint.sinceDartSdk == 'Unreleased' ||
                lint.sinceDartSdk.contains('-wip') ||
                releasedInVersion == null ||
                releasedInVersion > runningDartVersion;

            return Component.fragment(
              [
                Tags([
                  if (unreleasedLint)
                    const Tag(
                      'Não lançado',
                      icon: 'pending',
                      color: TagColor.orange,
                      title: 'Lint ainda não lançado ou em desenvolvimento.',
                    )
                  else if (lint.state == 'experimental')
                    const Tag(
                      'Experimental',
                      icon: 'science',
                      color: TagColor.orange,
                      title: 'Lint experimental.',
                    )
                  else if (lint.state == 'deprecated')
                    const Tag(
                      'Descontinuado',
                      icon: 'report',
                      color: TagColor.orange,
                      title: 'Lint descontinuado.',
                    )
                  else if (lint.state == 'removed')
                    const Tag(
                      'Removido',
                      icon: 'error',
                      color: TagColor.red,
                      title: 'Lint removido.',
                    )
                  else
                    const Tag(
                      'Estável',
                      icon: 'verified_user',
                      color: TagColor.green,
                      title: 'Lint estável.',
                    ),

                  if (lint.lintSets.contains('core'))
                    const Tag(
                      'Core',
                      icon: 'circles',
                      title: 'Lint incluído no conjunto core de regras.',
                    )
                  else if (lint.lintSets.contains('recommended'))
                    const Tag(
                      'Recomendado',
                      icon: 'thumb_up',
                      title:
                          'Lint incluído no conjunto recommended de regras.',
                    )
                  else if (lint.lintSets.contains('flutter'))
                    const Tag(
                      'Flutter',
                      icon: 'flutter',
                      title: 'Lint incluído no conjunto de regras do Flutter.',
                    ),

                  if (lint.fixStatus == 'hasFix')
                    const Tag(
                      'Correção disponível',
                      icon: 'build',
                      title:
                          'Lint tem uma ou mais correções rápidas '
                          '(quick fixes) disponíveis.',
                    ),
                  if (lint.sinceDartSdk != '2.0')
                    Tag(
                      'Lançado no Dart ${lint.sinceDartSdk}',
                      icon: 'merge_type',
                      color: TagColor.grey,
                      title: unreleasedLint
                          ? 'Este lint ficará '
                                'disponível no Dart ${lint.sinceDartSdk}'
                          : 'Este lint ficou disponível '
                                'originalmente no Dart ${lint.sinceDartSdk}.',
                    ),
                ]),
                DashMarkdown(
                  content:
                      '''
${lint.description}

## Detalhes

${lint.docs}

$incompatibleLintsText
''',
                ),
                DashMarkdown(
                  content:
                      '''
<a id="usage" aria-hidden="true"></a>
## Ativar

Para ativar a regra `${lint.id}`, adicione `${lint.id}` em
**linter > rules** no seu arquivo [`analysis_options.yaml`](/tools/analysis):

```yaml title="analysis_options.yaml"
linter:
  rules:
    - ${lint.id}
```

Se você usa a sintaxe de mapa YAML para configurar as regras de lint,
adicione `${lint.id}: true` em **linter > rules**:

```yaml title="analysis_options.yaml"
linter:
  rules:
    ${lint.id}: true
```
''',
                ),
              ],
            );
          },
        ),
  ];
}

final List<LintDetails> linterRulesToShow = readAndLoadLints()
    .where(
      (lint) =>
          lint.sinceDartSdk != 'Unreleased' &&
          !lint.sinceDartSdk.contains('wip') &&
          lint.state != 'removed' &&
          lint.state != 'internal',
    )
    .sortedBy((lint) => lint.name)
    .toList(growable: false);

/// The `/tools/linter-rules/all` page that includes an example
/// `analysis_options.yaml` file that enables all linter rules
/// that are available in the current stable release.
MemoryPage get _allLinterRulesPage {
  final allLinterRulesListAsString = linterRulesToShow
      .map((lint) => '    - ${lint.id}')
      .join('\n');

  return MemoryPage(
    path: 'tools/linter-rules/all.md',
    initialData: const {
      'page': <String, Object?>{
        'title': 'Todas as regras de lint',
        'description':
            'Configuração gerada automaticamente que '
            'ativa todas as regras de lint.',
        'sitemap': {
          'lastmod': _diagnosticsLastUpdated,
        },
      },
    },
    content:
        '''
A seguir está uma lista gerada automaticamente de todas as regras de lint
disponíveis no Dart SDK a partir da versão `{{site.sdkVersion}}`.
Adicione-as ao seu arquivo
[`analysis_options.yaml`](/tools/analysis)
e ajuste como achar melhor.

```yaml title="analysis_options.yaml"
linter:
  rules:
$allLinterRulesListAsString
```
''',
  );
}

/// A JSON rendered version of [_allLinterRulesPage].
MemoryPage get _allLinterRulesJson => MemoryPage(
  path: 'tools/linter-rules/all.json',
  keepSuffix: true,
  initialData: const {
    'page': <String, Object?>{
      'title': 'Todas as regras de lint do Dart em formato JSON',
      'description':
          'Todas as regras de lint lançadas suportadas pelo '
          'analisador do Dart, em formato JSON.',
      'sitemap': false,
    },
  },
  content:
      const JsonEncoder.withIndent(
        '  ',
      ).convert([
        for (final lint in linterRulesToShow)
          {
            'id': lint.id,
          },
      ]),
);
