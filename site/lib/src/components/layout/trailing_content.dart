// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:universal_web/web.dart' as web;

import '../common/client/feedback.dart';

/// The trailing content of a content documentation page, such as
/// its last updated information, report an issue links, and similar.
class TrailingContent extends StatelessComponent {
  const TrailingContent({super.key, this.repo, this.sdkVersion});

  final String? repo;
  final String? sdkVersion;

  @override
  Component build(BuildContext context) {
    final page = context.page;
    final pageUrl = page.url;
    final pageData = page.data.page;
    final siteData = page.data.site;
    final branch = siteData['branch'] as String? ?? 'main';
    final repoLinks = siteData['repo'] as Map<String, Object?>? ?? {};
    final repoUrl =
        repo ??
        repoLinks['this'] as String? ??
        'https://github.com/dart-lang/site-www';
    final inputPath = pageData['inputPath'] as String?;
    final pageDate = pageData['date'] as String?;

    final currentSdkVersion =
        sdkVersion ?? siteData['sdkVersion'] as String? ?? '';
    final siteUrl = siteData['url'] as String? ?? 'https://dart.dev';

    final fullPageUrl = '$siteUrl$pageUrl';
    final String issueUrl;
    final String? pageSource;

    if (inputPath != null) {
      pageSource = '$repoUrl/blob/$branch/${inputPath.replaceAll('./', '')}';
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&page-url=$fullPageUrl&page-source=$pageSource';
    } else {
      pageSource = null;
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&page-url=$fullPageUrl';
    }

    return div(
      id: 'trailing-content',
      attributes: {'data-nosnippet': 'true'},
      [
        FeedbackComponent(issueUrl: issueUrl),

        p(id: 'page-github-links', [
          span([
            text(
              'Unless stated otherwise, the documentation on '
              'this site reflects Dart $currentSdkVersion. ',
            ),
            if (pageDate != null)
              text(
                'Page last updated on $pageDate. ',
              ),
          ]),
          if (pageSource != null) ...[
            a(
              href: pageSource,
              attributes: {'target': '_blank', 'rel': 'noopener'},
              [text('View source')],
            ),
            span([text(' or ')]),
          ],
          a(
            href: issueUrl,
            attributes: {
              'title': 'Report an issue with this page',
              'target': '_blank',
              'rel': 'noopener',
            },
            [text(pageSource == null ? 'Report an issue' : 'report an issue')],
          ),
          text('.'),
        ]),

        div(classes: 'trailing-translation-feedback', [
          p([
            text(
              'Encontrou essa página sem tradução ou que precisa de correção? ',
            ),
            button(
              id: 'translation-issue-link',
              attributes: {'title': 'Abrir issue no GitHub'},
              events: {
                'click': (event) {
                  // Get current page URL
                  final currentUrl = web.window.location.href;

                  // Create issue title and body
                  final title = Uri.encodeComponent('Problema de tradução');
                  final body = Uri.encodeComponent(
                    '**URL da página:** $currentUrl\n\n'
                    '**Problema encontrado:**\n'
                    '<!-- Descreva o problema de tradução que você encontrou -->\n\n'
                    '- [ ] Página não traduzida\n'
                    '- [ ] Tradução incorreta ou incompleta\n'
                    '- [ ] Erro de português\n'
                    '- [ ] Outro (descrever abaixo)\n\n'
                    '**Descrição:**\n'
                    '<!-- Explique em detalhes o problema encontrado -->\n',
                  );

                  // Open GitHub issue with pre-filled content
                  final issueUrl =
                      'https://github.com/dart2brasil/site-www/issues/new?title=$title&body=$body';
                  web.window.open(issueUrl, '_blank');
                },
              },
              [text('Abra uma issue')],
            ),
            text(
              ' e nos ajude a manter esse site em PT-BR para ajudar pessoas como você.',
            ),
          ]),
        ]),
      ],
    );
  }
}
