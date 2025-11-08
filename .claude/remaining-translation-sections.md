# Remaining Translation Sections - 311 Files

This file organizes the remaining 311 untranslated documentation files into 5 manageable sections for systematic translation.

**Total: 311 files across 5 sections**

---

## **SECTION 1: Core Documentation & Get Started (~45 files)**

```
Translate Section 1: Core Documentation & Get Started Tutorial to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~45 files):

Core Pages (4 files):
1. src/content/overview.md
2. src/content/terms.md
3. src/content/community/index.md
4. src/content/community/code-of-conduct.md

Get Dart (2 files):
5. src/content/get-dart/index.md
6. src/content/get-dart/archive/index.md

Get Started Tutorial (13 files):
7. src/content/get-started/index.md
8. src/content/get-started/hello-world.md
9. src/content/get-started/packages-libs.md
10. src/content/get-started/object-oriented.md
11. src/content/get-started/advanced-oop.md
12. src/content/get-started/data-and-json.md
13. src/content/get-started/async.md
14. src/content/get-started/error-handling.md
15. src/content/get-started/http.md
16. src/content/get-started/logging.md
17. src/content/get-started/testing.md
18. src/content/get-started/add-commands.md
19. src/content/get-started/command-runner-polish.md

Resources (16 files):
20. src/content/resources/index.md
21. src/content/resources/faq.md
22. src/content/resources/books.md
23. src/content/resources/videos.md
24. src/content/resources/dart-cheatsheet.md
25. src/content/resources/dart-team-packages.md
26. src/content/resources/google-apis.md
27. src/content/resources/useful-packages.md
28. src/content/resources/whats-new.md
29. src/content/resources/breaking-changes.md
30. src/content/resources/coming-from/js-to-dart.md
31. src/content/resources/coming-from/swift-to-dart.md
32. src/content/resources/language/index.md
33. src/content/resources/language/evolution.md
34. src/content/resources/language/number-representation.md
35. src/content/resources/language/spec/index.md

Tools (4 files):
36. src/content/tools/dart2js.md
37. src/content/tools/dartdevc.md
38. src/content/tools/doc-comments/references.md
39. src/content/tools/linter-rules/index.md

Null Safety (4 files):
40. src/content/null-safety/index.md
41. src/content/null-safety/migration-guide.md
42. src/content/null-safety/faq.md
43. src/content/null-safety/unsound-null-safety.md

Server (4 files):
44. src/content/server/index.md
45. src/content/server/libraries.md
46. src/content/server/google-cloud.md
47. src/content/server/c-interop-native-extensions.md

DISCOVERY COMMAND:
```bash
find src/content/community src/content/get-dart src/content/get-started src/content/resources src/content/tools src/content/null-safety src/content/server -maxdepth 3 -name "*.md" -type f -exec grep -L "ia-translate: true" {} \; 2>/dev/null | grep -v diagnostics
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to YAML frontmatter
- Translate `title` and `description` to PT-BR
- Translate all prose to natural Brazilian Portuguese
- Keep in English: Dart, SDK, Flutter, packages, technical terms, keywords, type names
- Preserve: code blocks, YAML, JSON, commands, URLs, links

COMMIT STRATEGY:
Batch commit: "translate: Section 1 - Core Documentation & Get Started (~45 files) to PT-BR"

AFTER COMPLETION:
- Mark section 1 as complete
- Push changes

PRIORITY: CRITICAL - These are the most important user-facing docs
```

---

## **SECTION 2: Interop & Web (~14 files)**

```
Translate Section 2: Interop & Web Documentation to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~14 files):

Interop (11 files):
1. src/content/interop/index.md
2. src/content/interop/c-interop.md
3. src/content/interop/java-interop.md
4. src/content/interop/objective-c-interop.md
5. src/content/interop/js-interop/index.md
6. src/content/interop/js-interop/start.md
7. src/content/interop/js-interop/usage.md
8. src/content/interop/js-interop/js-types.md
9. src/content/interop/js-interop/tutorials.md
10. src/content/interop/js-interop/mock.md
11. src/content/interop/js-interop/past-js-interop.md

Web (3 files):
12. src/content/web/index.md
13. src/content/web/libraries.md
14. src/content/web/debugging.md

DISCOVERY COMMAND:
```bash
find src/content/interop src/content/web -name "*.md" -type f -exec grep -L "ia-translate: true" {} \; 2>/dev/null
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to YAML frontmatter
- Translate `title` and `description` to PT-BR
- Translate explanations to natural PT-BR
- Keep in English: FFI, C, Java, JavaScript, Objective-C, JNI, @JS, @staticInterop, dart:ffi, dart:js_interop, dart:html, WebAssembly, DOM, type names, API names
- Preserve: code blocks, C/Java/JS/HTML/CSS code, annotations, native types

COMMIT STRATEGY:
Batch commit: "translate: Section 2 - Interop & Web (~14 files) to PT-BR"

AFTER COMPLETION:
- Mark section 2 as complete
- Push changes

PRIORITY: MEDIUM
```

---

## **SECTION 3: Diagnostics - High Volume Prefixes (~100 files)**

```
Translate Section 3: Diagnostic Errors - High Volume Prefixes to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~100 files):
Find all untranslated files matching high-volume patterns:
- unnecessary_* (39 files)
- non_* (16 files)
- sdk_* (12 files)
- field_* (11 files)
- redirect_* (7 files)
- undefined_* (6 files)
- nullable_* (5 files)
- must_* (5 files)
- inference_* (5 files)
- ffi_* (5 files)
- expected_* (5 files)
- enum_* (5 files)

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics \( \
  -name "unnecessary_*.md" -o \
  -name "non_*.md" -o \
  -name "sdk_*.md" -o \
  -name "field_*.md" -o \
  -name "redirect_*.md" -o \
  -name "undefined_*.md" -o \
  -name "nullable_*.md" -o \
  -name "must_*.md" -o \
  -name "inference_*.md" -o \
  -name "ffi_*.md" -o \
  -name "expected_*.md" -o \
  -name "enum_*.md" \
\) -exec grep -L "ia-translate: true" {} \; 2>/dev/null
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error code) in English
- Translate error explanations to natural PT-BR
- Keep in English: all error codes, keywords, type names, lint rules, FFI terms
- Preserve: code blocks, error messages, syntax

COMMIT STRATEGY:
Batch commit: "translate: Section 3 - Diagnostic Errors High Volume Prefixes (~100 files) to PT-BR"

AFTER COMPLETION:
- Mark section 3 as complete
- Push changes

PRIORITY: LOW
```

---

## **SECTION 4: Diagnostics - Medium Volume Prefixes (✅ COMPLETED - 61 files)**

```
✅ COMPLETED - Translate Section 4: Diagnostic Errors - Medium Volume Prefixes to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~75 files):
Find all untranslated files matching medium-volume patterns:
- sort_* (4 files)
- extra_* (4 files)
- conflicting_* (4 files)
- workspace_* (3 files)
- prefix_* (3 files)
- path_* (3 files)
- invocation_* (3 files)
- instance_* (3 files)
- inconsistent_* (3 files)
- implicit_* (3 files)
- doc_* (3 files)
- constant_* (3 files)
- case_* (3 files)
- unreachable_* (2 files)
- unqualified_* (2 files)
- text_* (2 files)
- subtype_* (2 files)
- sized_* (2 files)
- And other 2-3 file prefixes

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics \( \
  -name "sort_*.md" -o \
  -name "extra_*.md" -o \
  -name "conflicting_*.md" -o \
  -name "workspace_*.md" -o \
  -name "prefix_*.md" -o \
  -name "path_*.md" -o \
  -name "invocation_*.md" -o \
  -name "instance_*.md" -o \
  -name "inconsistent_*.md" -o \
  -name "implicit_*.md" -o \
  -name "doc_*.md" -o \
  -name "constant_*.md" -o \
  -name "case_*.md" -o \
  -name "unreachable_*.md" -o \
  -name "unqualified_*.md" -o \
  -name "text_*.md" -o \
  -name "subtype_*.md" -o \
  -name "sized_*.md" \
\) -exec grep -L "ia-translate: true" {} \; 2>/dev/null
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error code) in English
- Translate error explanations to natural PT-BR
- Keep in English: all error codes, keywords, type names, dartdoc syntax
- Preserve: code blocks, error messages, syntax

COMMIT STRATEGY:
Batch commit: "translate: Section 4 - Diagnostic Errors Medium Volume Prefixes (~75 files) to PT-BR"

AFTER COMPLETION:
- Mark section 4 as complete
- Push changes

PRIORITY: LOW
```

---

## **SECTION 5: Diagnostics - All Remaining Files (~75 files)**

```
Translate Section 5: Diagnostic Errors - All Remaining to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~75 files):
Find ALL remaining untranslated diagnostic files that weren't covered in sections 3-4

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "*.md" -exec grep -L "ia-translate: true" {} \; 2>/dev/null
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error code) in English
- Translate error explanations to natural PT-BR
- Keep in English: all error codes, keywords, type names, Dart syntax
- Preserve: code blocks, error messages, syntax

COMMIT STRATEGY:
Batch commit: "translate: Section 5 - Diagnostic Errors ALL REMAINING (~75 files) to PT-BR"

AFTER COMPLETION:
- Mark section 5 as COMPLETE
- Push all changes
- CELEBRATE! 🎉 ALL 311 files translated!

PRIORITY: LOW (but final!)
```

---

## Summary Table

| Section | Description | Est. Files | Priority | Status |
|---------|-------------|------------|----------|--------|
| 1 | Core Docs, Get Started, Resources, Tools, Null Safety, Server | ~61 | CRITICAL | ⬜ |
| 2 | Interop & Web | ~14 | MEDIUM | ⬜ |
| 3 | Diagnostics - High Volume Prefixes | ~100 | LOW | ⬜ |
| 4 | Diagnostics - Medium Volume Prefixes | 61 | LOW | ✅ DONE |
| 5 | Diagnostics - All Remaining | ~61 | LOW | ⬜ |
| **TOTAL** | **All Files** | **~311** | **Mixed** | **1/5** |

---

## Usage Instructions

For each section:
1. Copy the section prompt from above
2. Execute the discovery command to find exact files
3. Translate all files following the dart-docs-translator agent guidelines
4. Commit with the specified batch commit message
5. Push changes
6. Mark section as complete
7. Move to next section

**Recommended order: Section 1 (critical), Section 2 (medium), then Sections 3-5 (low priority diagnostics)**
