---
name: garden-note
description: Use when adding, organizing, rewriting, or linking notes in the repository's garden/ Zettelkasten. Covers choosing the right garden folder, creating atomic permanent notes, literature/source notes, MOC pages, project notes, and stable note filenames.
---

# Garden Note

Use this skill when the user asks to add a note, save an idea, process a source, create a Zettelkasten note, update a MOC, or organize content inside `garden/`.

## Repository Contract

The garden root is `garden/`. Read `garden/README.md` first if the folder structure or naming convention is unclear.

Current folders:

- `00-inbox/` - quick capture before sorting.
- `10-fleeting/` - rough thoughts and temporary observations.
- `20-literature/` - notes from books, articles, papers, talks, podcasts, videos.
- `30-permanent/` - atomic evergreen notes in the user's own words.
- `40-moc/` - maps of content, indexes, topic hubs, navigation notes.
- `50-sources/` - source cards, bibliographic notes, links, citations.
- `60-projects/` - project-oriented notes that use permanent notes.
- `90-templates/` - reusable note templates.
- `assets/` - images, PDFs, diagrams, attachments.

## File Naming

For atomic notes, use:

```text
YYYYMMDDHHMM-short-title.md
```

Use the current local time when creating the ID. Make the slug short, lowercase, ASCII, and hyphen-separated.

Examples:

```text
202604191530-feedback-loops-in-learning.md
202604191545-rust-release-profile-tradeoffs.md
```

For MOC files, use stable topic names:

```text
garden/40-moc/rust-performance.md
garden/40-moc/ai-agents.md
```

For folder-level tables of contents, keep index files in the garden root, not inside the note folders:

```text
garden/20-literature.md
garden/30-permanent.md
```

Do not create `README.md` files inside `20-literature/` or `30-permanent/` just to list notes. Those folders can contain many note files; the root index keeps navigation separate from note storage.

## Placement Rules

- Raw capture from the user, not yet processed: `00-inbox/`.
- Half-formed thought, question, or observation: `10-fleeting/`.
- Notes tied closely to one source: `20-literature/`.
- Source metadata, citation, abstract, and link: `50-sources/`.
- One durable idea written in the user's own words: `30-permanent/`.
- Topic index or navigation page: `40-moc/`.
- Notes serving a concrete project or deliverable: `60-projects/`.

When unsure, prefer `00-inbox/` for capture or ask one concise question if placement materially changes the output.

## Permanent Note Shape

Permanent notes should be atomic: one note, one idea. Prefer concise prose and explicit links.
Use regular relative Markdown links so notes work in VS Code and GitHub. Do not use Obsidian-style wikilinks.

Use this structure when creating a permanent note:

```markdown
# Title

Коротко: one-sentence summary.

## Смысл

Explain the idea in the user's own words.

## Связи

- [Related note title](../30-permanent/YYYYMMDDHHMM-related-note.md)

## Источники

- Source title URL
```

Do not dump long source excerpts into permanent notes. Convert source content into your own words and link to literature/source notes when useful.

## Literature Note Shape

Use literature notes for source-specific extraction:

```markdown
# Source title

Источник: URL or bibliographic reference

## Ключевые идеи

- ...

## Что забрать в permanent notes

- ...

## Цитаты

- Short quote or pointer only.
```

Respect copyright: keep quotations short and prefer paraphrase.

## MOC Shape

MOC is not a tag. It is a hand-curated map or index for a topic.

```markdown
# Topic

## Основное

- [Note title](../30-permanent/YYYYMMDDHHMM-note-title.md)

## Подтемы

- [Source note title](../20-literature/YYYYMMDDHHMM-source-note.md)

## Вопросы

- ...
```

When adding a permanent note, update an existing relevant MOC if it already exists and the link clearly belongs there. Do not create a new MOC for every note.

## Glossary Rule

Keep a shared glossary at `garden/40-moc/glossary.md`.

When a note introduces terms that an ordinary reader is unlikely to know without domain background, add them to the shared glossary if they are not already there. Typical examples include formal math, architecture, distributed systems, programming-language theory, and other specialized vocabulary.

Do not add obvious everyday words. Prefer short plain-language definitions over textbook-style formalism. When a term came from a specific note, add that note to the glossary's sources section if useful.

## Folder Index Shape

Folder indexes are lightweight tables of contents for large note folders. They live at the garden root and link into their corresponding folders:

```markdown
# Literature Notes

Оглавление заметок из папки [20-literature](20-literature/).

## Topic

- [Note title](20-literature/YYYYMMDDHHMM-note-title.md)
```

```markdown
# Permanent Notes

Оглавление атомарных заметок из папки [30-permanent](30-permanent/).

## Topic

- [Note title](30-permanent/YYYYMMDDHHMM-note-title.md)
```

When adding or renaming a `20-literature/` note, update `garden/20-literature.md` if it exists. When adding or renaming a `30-permanent/` note, update `garden/30-permanent.md` if it exists. Group links by human topic headings; do not force every note into chronological order if a topic grouping is clearer.

## Workflow

1. Identify the note type and destination folder.
2. Check for existing related notes with `rg` to avoid duplicates.
3. Create or update the Markdown file with the smallest useful change.
4. Update `garden/40-moc/glossary.md` when the note introduces specialized terms that should be explained for a general reader.
5. Add links to related notes when obvious.
6. Update the relevant root folder index (`garden/20-literature.md` or `garden/30-permanent.md`) when adding or renaming notes in those folders.
7. Update a relevant MOC only when it improves navigation.
8. Run `git diff --check -- garden .agents` after edits when practical.
