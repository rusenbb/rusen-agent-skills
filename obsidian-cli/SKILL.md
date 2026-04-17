---
name: obsidian-cli
description: Interact with Obsidian vaults using the Obsidian CLI to read, create, search, and manage notes, tasks, properties, tags, links, templates, and more. Also supports plugin and theme development with commands to reload plugins, run JavaScript, capture errors, take screenshots, and inspect the DOM. Use when the user asks to interact with their Obsidian vault, manage notes, search vault content, perform vault operations from the command line, or develop and debug Obsidian plugins and themes.
---

# Obsidian CLI

Use the `obsidian` CLI to interact with a running Obsidian instance. **Requires Obsidian to be open** — the CLI communicates with the running Electron app via IPC.

Run `obsidian help` to see all available commands. Full docs: https://help.obsidian.md/cli

## Syntax

Non-standard syntax (not POSIX flags). Parameters use `=`, flags are bare words:

```bash
obsidian <command> [param=value ...] [flag ...]
```

**Parameters** take a value with `=`. Quote values with spaces:

```bash
obsidian create name="My Note" content="Hello world"
```

**Flags** are boolean switches with no value:

```bash
obsidian create name="My Note" silent overwrite
```

For multiline content use `\n` for newline and `\t` for tab.

## File targeting

Many commands accept `file` or `path` to target a file. Without either, the active file is used.

- `file=<name>` — resolves like a wikilink (name only, no path or extension needed)
- `path=<path>` — exact path from vault root, e.g. `folder/note.md`

## Vault targeting

Commands target the most recently focused vault by default. Use `vault=<name>` as the **first** parameter to target a specific vault:

```bash
obsidian vault="My Vault" search query="test"
```

## Output formats

Many commands support `format=json` or `format=tsv` for structured output. Use `--copy` on any command to copy output to clipboard. Use `total` on list commands to get a count.

## Command reference

### Read & Write

```bash
obsidian read path=folder/note.md
obsidian create name="New Note" content="# Hello" silent
obsidian create name="New Note" template="Template" silent
obsidian create path=note.md content="replaced" overwrite silent
obsidian append path=note.md content="New line"
obsidian prepend path=note.md content="Top line"
obsidian move path=old/path.md to=new/path.md
obsidian delete path=note.md
```

### Daily notes

```bash
obsidian daily                                   # Open today's daily note (UI)
obsidian daily:read                              # Read daily note content
obsidian daily:append content="- [ ] New task"   # Append to daily note
obsidian daily:prepend content="Morning entry"   # Prepend (after frontmatter)
```

### Properties (frontmatter)

```bash
obsidian property:set name=status value=done path=note.md
obsidian property:set name=status value=done type=text path=note.md
obsidian property:read name=status path=note.md
obsidian property:remove name=priority path=note.md
obsidian properties path=note.md                 # List all (YAML format)
obsidian properties path=note.md format=tsv      # List as TSV (key\tvalue)
```

### Search

```bash
obsidian search query="search term"
obsidian search query="term" path=folder limit=10
obsidian search query="term" format=json matches  # JSON with line numbers
```

### Tags

```bash
obsidian tags all counts                  # All vault tags with counts
obsidian tags all counts sort=count       # Sorted by frequency
obsidian tag name=mytag                   # Files with specific tag
obsidian tag name=mytag total             # Count of files with tag
```

### Tasks

```bash
obsidian tasks all todo                   # All open tasks in vault
obsidian tasks all done                   # All completed tasks
obsidian tasks daily                      # Tasks from daily note
obsidian tasks path=folder/note.md total  # Tasks in specific file
obsidian task ref="path.md:2" toggle      # Toggle task on line 2
obsidian task ref="path.md:2" done        # Mark specific task done
```

### Links & graph analysis

```bash
obsidian backlinks path=note.md
obsidian backlinks path=note.md counts
obsidian links path=note.md
obsidian links path=note.md total
obsidian unresolved                       # Broken/unresolved links
obsidian orphans total                    # Files with no incoming links
obsidian deadends total                   # Files with no outgoing links
obsidian aliases path=note.md
```

### Files & folders

```bash
obsidian file path=note.md                       # File metadata
obsidian files folder=subfolder ext=md total      # List/count files
obsidian folder path=subfolder info=files         # Folder info
obsidian folders total                            # List all folders
obsidian outline path=note.md                     # Heading structure
obsidian wordcount path=note.md words             # Word count
```

### Bases (database views)

```bash
obsidian bases                                           # List .base files
obsidian base:query path=views/dashboard.base format=json
obsidian base:query path=file.base view=ViewName format=json
obsidian base:views
```

### Templates

```bash
obsidian templates total                          # List available templates
obsidian template:read name=project               # Read template source
obsidian template:read name=project resolve       # Render with variables
```

### History & versioning

```bash
obsidian history path=note.md
obsidian history:list
obsidian history:read path=note.md version=1
obsidian diff path=note.md
```

### Sync

```bash
obsidian sync:status
obsidian sync:history path=note.md total
obsidian sync:deleted total
obsidian sync:read path=note.md version=1
```

### Vault & system

```bash
obsidian vault                            # Current vault info
obsidian vault info=name                  # Specific vault info
obsidian vaults total                     # List all vaults
obsidian version                          # CLI/app version
obsidian help                             # All available commands
obsidian reload                           # Reload vault
obsidian restart                          # Restart Obsidian
```

### Bookmarks, tabs, recents

```bash
obsidian bookmarks total
obsidian recents total
obsidian tabs ids
obsidian random:read folder=subfolder
```

### Hotkeys & commands

```bash
obsidian commands filter=workspace:       # List/filter command IDs
obsidian command id="daily-notes"         # Execute command by ID
obsidian hotkeys total
```

### Plugins & themes

```bash
obsidian plugins                          # List installed plugins
obsidian plugins:enabled                  # List enabled plugins
obsidian plugin:reload id=my-plugin       # Reload a plugin
obsidian plugin:enable id=my-plugin
obsidian plugin:disable id=my-plugin
obsidian themes
obsidian theme
obsidian snippets
obsidian snippets:enabled
```

### Developer / debugging

```bash
obsidian eval code="app.vault.getFiles().length"
obsidian dev:errors
obsidian dev:console
obsidian dev:console level=error
obsidian dev:screenshot path=screenshot.png
obsidian dev:dom selector=".workspace-leaf" text
obsidian dev:css selector=".workspace-leaf" prop=background-color
obsidian dev:mobile on
```

## Critical gotchas

These are confirmed issues as of Obsidian 1.12.1 (Feb 2026). They cause silent failures:

### Always specify explicit scope

Many commands (`tasks`, `tags`, `properties`) default to the "active file" in the GUI. When called from a terminal with no file open, they silently return empty results with exit code 0. **Always provide explicit scope:**

- `tasks all todo` not `tasks todo`
- `tags all counts` not `tags counts`
- Always provide `path=` or `file=` when targeting specific files

### `create` opens the GUI by default

Always add the `silent` flag for scripted use:

```bash
obsidian create name="Note" content="text" silent
```

### `create` does not auto-create directories

Parent folders must exist. Use `mkdir -p` first if needed.

### Exit code 0 on errors

The CLI returns exit code 0 even on errors. Cannot rely on `$?`. Parse stdout for `"Error:"` strings instead.

### `properties format=json` returns YAML, not JSON

Despite accepting the parameter, `format=json` for `properties` returns YAML-like output. Use `format=tsv` for machine-parseable output.

### `vault=` must be the first parameter

`vault="Name"` must come immediately after the command name.

### Multiline content in shell variables fails silently

Use `\n` within the content string rather than actual newlines.

### Multibyte characters (CJK, emoji) can hang

Commands with 3-byte+ UTF-8 characters may hang indefinitely. Wrap with `timeout`:

```bash
timeout 5 obsidian create path=note.md content="text with emoji"
```

### `move` path interpretation

May treat the final path segment as a folder name. Verify results after move operations.

## Plugin development workflow

```bash
# Edit plugin code, then reload
obsidian plugin:reload id=my-plugin

# Check for errors
obsidian dev:errors

# Screenshot for visual testing
obsidian dev:screenshot path=test-result.png

# Inspect app state
obsidian eval code="app.plugins.enabledPlugins"
```

## Fallback when CLI is unavailable

When Obsidian is not running, use standard file tools for plain-text operations on vault files directly. The CLI is specifically valuable for index-powered operations (search, backlinks, tags, tasks, properties, bases) that leverage Obsidian's internal database.
