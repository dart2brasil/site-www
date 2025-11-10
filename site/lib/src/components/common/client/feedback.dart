// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import '../../../analytics/analytics.dart';
import '../button.dart';

/// Provides the user options to provide feedback on the specified page.
@client
final class FeedbackComponent extends StatefulComponent {
  const FeedbackComponent({required this.issueUrl});

  final String issueUrl;

  @override
  State<FeedbackComponent> createState() => _FeedbackComponentState();
}

final class _FeedbackComponentState extends State<FeedbackComponent> {
  _FeedbackState feedback = _FeedbackState.none;

  void _provideFeedback({required bool helpful}) {
    if (!kIsWeb) return;

    setState(
      () => feedback = helpful
          ? _FeedbackState.helpful
          : _FeedbackState.unhelpful,
    );
    analytics.sendFeedback(helpful);
  }

  @override
  Component build(BuildContext context) {
    return div(id: 'page-feedback', [
      div(classes: 'feedback', [
        div([Component.text(feedback.introduction)]),
        ...switch (feedback) {
          _FeedbackState.none => [
            div(classes: 'feedback-buttons', [
              Button(
                icon: 'thumb_up',
                title: 'Sim, esta página foi útil.',
                onClick: () => _provideFeedback(helpful: true),
              ),
              Button(
                icon: 'thumb_down',
                title: 'Não, esta página não foi útil ou tinha um problema',
                onClick: () => _provideFeedback(helpful: false),
              ),
            ]),
          ],
          _FeedbackState.helpful => [
            Button(
              content: 'Fornecer detalhes',
              icon: 'feedback',
              title: 'Forneça feedback detalhado.',
              href: component.issueUrl,
              attributes: {'target': '_blank', 'rel': 'noopener'},
            ),
          ],
          _FeedbackState.unhelpful => [
            Button(
              content: 'Fornecer detalhes',
              icon: 'bug_report',
              title: 'Forneça feedback ou relatar um problema.',
              href: component.issueUrl,
              attributes: {'target': '_blank', 'rel': 'noopener'},
            ),
          ],
        },
      ]),
    ]);
  }
}

enum _FeedbackState {
  none('O conteúdo desta página foi útil?'),
  helpful('Obrigado pelo seu feedback!'),
  unhelpful(
    'Obrigado pelo seu feedback! '
    'Por favor, nos informe como podemos melhorar.',
  );

  const _FeedbackState(this.introduction);

  final String introduction;
}
