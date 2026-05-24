# Brisbane Rides — repo notes for Claude

Static HTML/CSS site (no build step). Files in the repo root: `index.html`,
`fundamentals.html`, `weekender.html`, `day-trips.html`, `bucket-list.html`,
`style.css`. Keep it that way — no frameworks, no build pipeline.

## Workflow

### Cache-bust style.css before opening or finalising a PR

Browsers cache `style.css` aggressively. Every PR that ships CSS changes
must end with a cache-bust commit. As the **last** commit on the branch
before opening (or merging) a PR:

```bash
bash scripts/cache-bust.sh
git add -- *.html
git commit -m "Cache-bust style.css with PR head SHA"
git push
```

The script rewrites every `<link href="style.css?v=...">` in the HTML
files to use `git rev-parse --short HEAD` (i.e. the SHA of the latest
commit at the time the script runs — the commit *before* the bump
commit, since the bump commit's own SHA is unknowable in advance). The
SHA mismatch is fine: what matters is that the URL changes whenever the
CSS does, so browsers re-fetch.

The script is idempotent — re-running with the same HEAD produces no
diff.

### Always open a PR after pushing

When the user asks for changes, the workflow is: edit → commit → push →
**open a PR**. Don't stop at "pushed". If a PR for the branch already
exists and is open, new commits roll into it automatically; if the
previous PR is merged or closed, open a new one.
