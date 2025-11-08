# Section Translation Prompt Template

Use this prompt to start translating a new section from the Tools Translation Plan.

---

## Prompt Template

```
I'm ready to translate Section [NUMBER]: [SECTION NAME] from the Tools Translation Plan.

According to .claude/tools-translation-plan.md, this section includes:
- [LIST KEY FILES OR AREAS]
- Priority: [High/Medium/Low]
- Estimated files: [NUMBER]

Please translate all files in this section systematically:

1. Use the Dart documentation translator agent (.claude/agents/dart-docs-translator.md)
2. For each file:
   - Add `ia-translate: true` to frontmatter
   - Translate title and description fields
   - Translate all prose content to natural PT-BR
   - Keep ALL technical terms in English (Dart, SDK, pub, packages, etc.)
   - Preserve ALL code blocks, links, and formatting
   - Commit with clear message: "translate: [file-path] to PT-BR"

3. After completing the section:
   - Update TRANSLATION_PROGRESS.md
   - Update .claude/tools-translation-plan.md progress
   - Commit and push all changes

Work through the files systematically. Let me know when the section is complete!
```

---

## Example Usage for Section 1

```
I'm ready to translate Section 1: Core Pub Documentation from the Tools Translation Plan.

According to .claude/tools-translation-plan.md, this section includes:
- Core pub documentation files (packages.md, dependencies.md, pubspec.md, etc.)
- Priority: Critical
- Estimated files: 12

Please translate all 12 files in this section systematically:

1. Use the Dart documentation translator agent (.claude/agents/dart-docs-translator.md)
2. For each file:
   - Add `ia-translate: true` to frontmatter
   - Translate title and description fields
   - Translate all prose content to natural PT-BR
   - Keep ALL technical terms in English (Dart, SDK, pub, packages, pubspec, dependencies, etc.)
   - Preserve ALL code blocks, links, and formatting
   - Commit with clear message: "translate: tools/pub/[filename] to PT-BR"

3. After completing the section:
   - Update TRANSLATION_PROGRESS.md
   - Update .claude/tools-translation-plan.md progress
   - Commit and push all changes

Work through the files systematically. Let me know when the section is complete!
```

---

## Quick Start Commands

### Start Section 1 (Core Pub Documentation)
```
Start translating Section 1: Core Pub Documentation (12 files, high priority)
```

### Start Section 2 (Pub Commands)
```
Start translating Section 2: Pub Commands (15 files, high priority)
```

### Start Section 3 (Pub Advanced Topics)
```
Start translating Section 3: Pub Advanced Topics (4 files, medium priority)
```

### Start Section 5 (Web & Server Tools)
```
Start translating Section 5: Web & Server Documentation (15-20 files, medium-high priority)
```

### Start Section 6 (Diagnostic Errors A-C)
```
Start translating Section 6: Diagnostic Errors A-C (100-150 files, low-medium priority)
```

---

## Progress Tracking Template

After completing each section, update the plan with:

```markdown
### Completed Sections:
- ✅ **Section 4:** Top-Level Tools (15/15 files) - 100% COMPLETE!
- ✅ **Section 1:** Core Pub Documentation (12/12 files) - 100% COMPLETE!

### In Progress:
- ⏳ **Section 2:** Pub Commands (5/15 files - 33%)

### Completion Stats:
- Files translated this session: [NUMBER]
- Total files translated: [NUMBER]
- Sections completed: [NUMBER]/10
```

---

## Tips for Efficient Translation

1. **Batch similar files**: Group files by type (commands, concepts, errors)
2. **Use parallel tasks**: Launch multiple translation agents for independent files
3. **Commit frequently**: Commit after each file or small batch
4. **Track progress**: Update tracking documents every 5-10 files
5. **Take breaks**: Large sections (100+ files) benefit from breaks between batches
6. **Quality over speed**: Ensure translations are accurate and natural

---

## File Count Estimates

Based on current analysis:
- **Section 1:** 12 files
- **Section 2:** ~10-12 files (some already done)
- **Section 3:** ~2-3 files (some already done)
- **Section 4:** ✅ Complete!
- **Section 5:** 15-20 files
- **Sections 6-10:** 400-500 diagnostic error files total

**Total remaining:** ~440-550 files
