# Claude Code

Single profile at `~/.claude`, using the default `CLAUDE_CONFIG_DIR`. Restore
steps are in [SETUP.md](../SETUP.md) Phase 7.

Only the parts of `~/.claude` that are *configuration* live here. The rest of
that directory is runtime state — `sessions/`, `daemon/`, `telemetry/`,
`history.jsonl`, `backups/`, `shell-snapshots/`, `file-history/`, `jobs/` — and
is deliberately excluded. None of it is worth restoring and some of it holds
session keys.

## What's here

| Path | Installs to |
|---|---|
| `settings.json` | `~/.claude/settings.json` |
| `memory/<slug>/` | `~/.claude/projects/<slug>/memory/` |

### settings.json

Model, theme, and the two enabled plugins. Copy it straight across:

```
$ cp ~/dotfiles/claude/settings.json ~/.claude/settings.json
```

### memory

Per-project memories, 13 files across 3 projects. The directory slug is the
project's absolute path with `/` replaced by `-`, so these only resolve if the
projects sit at the same paths on the new machine.

```
$ for d in ~/dotfiles/claude/memory/*/; do
    slug=$(basename "$d")
    mkdir -p ~/.claude/projects/"$slug"/memory
    cp "$d"*.md ~/.claude/projects/"$slug"/memory/
  done
```

⚠️ Note the nesting: it's `projects/<slug>/memory/`, **not** `memory/<slug>/`.
The old `~/scripts` snapshot flattened it the other way, which is why the
restore isn't a plain `cp -R`.

## What's not here, and why

### Skills — separate repo

`~/.claude/skills` is its own git repo, so it is not vendored here:

```
$ git clone git@github.com:nandanjp/claude-skills.git ~/.claude/skills
```

11 skills: `backend`, `canvas-design`, `fullstack`, `grill-with-docs`,
`prototype`, `scaffold`, `skill-creator`, `tdd`, `teach`, `theme-factory`,
`zoom-out`.

`teach` and `zoom-out` both carry `disable-model-invocation: true`, which makes
them user-triggered only — you type `/teach`, Claude never reaches for it on its
own. That's intentional.

⚠️ The `~/scripts` snapshot carried an **uncommitted** edit deleting that flag
from `teach`. It was reviewed on 2026-09-12 and deliberately not carried over —
it had never been committed or pushed, and keeping the flag matches `zoom-out`.
Recorded here so the diff doesn't get rediscovered and "fixed" later. To change
your mind, delete the one line from `teach/SKILL.md` and commit it upstream.

### Plugins — reinstall, don't copy

`installed_plugins.json` points at cache directories under
`~/.claude/plugins/cache/` that aren't in any repo, so copying it produces
dangling paths. Reinstall from the marketplace instead:

```
$ claude plugin marketplace add anthropics/claude-plugins-official
$ claude plugin install gopls-lsp@claude-plugins-official
$ claude plugin install frontend-design@claude-plugins-official
```

`settings.json` already lists both under `enabledPlugins`, so they come up
enabled once installed.

## Keeping it current

These files are copied, not symlinked — editing `~/.claude/settings.json` does
not update the repo. To sync back:

```
$ cd ~/dotfiles
$ cp ~/.claude/settings.json claude/settings.json
$ for d in ~/.claude/projects/*/; do
    slug=$(basename "$d")
    [ -n "$(ls -A "$d/memory" 2>/dev/null)" ] || continue
    mkdir -p "claude/memory/$slug" && cp "$d"memory/*.md "claude/memory/$slug/"
  done
```
