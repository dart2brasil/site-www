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
              'Exceto quando indicado de outra forma, a documentação neste site '
              'reflete Dart $currentSdkVersion. ',
            ),
            if (pageDate != null)
              text(
                'Página atualizada em $pageDate. ',
              ),
          ]),
          if (pageSource != null) ...[
            a(
              href: pageSource,
              attributes: {'target': '_blank', 'rel': 'noopener'},
              [text('Ver código-fonte')],
            ),
            span([text(' ou ')]),
          ],
          a(
            href: issueUrl,
            attributes: {
              'title': 'Reportar um problema nesta página',
              'target': '_blank',
              'rel': 'noopener',
            },
            [text(pageSource == null ? 'Reportar um problema' : 'reportar um problema')],
          ),
          text('.'),
        ]),

        div(classes: 'trailing-translation-feedback', [
          p([
            text(
              'Encontrou essa página sem tradução ou que precisa de correção? ',
            ),
            a(
              id: 'translation-issue-link',
              href: 'javascript:void(0)',
              attributes: {'title': 'Abrir issue no GitHub'},
              events: {
                'click': (event) {
                  event.preventDefault();
                  // Get current page URL
                  final currentUrl = web.window.location.href;

                  // Open GitHub issue with pre-filled content using template
                  final issueUrl =
                      '$repoUrl/issues/new?template=2_translation_issue.yml&page-url=$currentUrl';
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
