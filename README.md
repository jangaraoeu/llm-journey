# LLM Journey

A public log of me learning LLMs, one day at a time. Most days I build something, learn something, sometimes read a paper, and write down what I still remember from the day before.

## The daily loop

| Step | What | Command |
|---|---|---|
| 1. **Recall** | Before looking at yesterday's log, write down everything you remember. Then check yourself. | `lj` → write the *Recall* section → `lj recall` |
| 2. **Build** | Write code. Each experiment gets its own folder. | `lj build tiny-bpe` |
| 3. **Learn** | Concepts, docs, lectures, notes. | *Learn* section |
| 4. **Paper** *(optional)* | A structured paper note, with a short summary in the day log. | `lj paper "Attention Is All You Need"` |
| 5. **Distill** | 3–5 takeaways, plus flashcards for anything worth keeping. | *Takeaways* + *Cards* sections |
| 6. **Review** | Spaced repetition over every card you've written so far. | `lj review` |

## Layout

```
days/2026/2026-10-09.md     one file per day (from templates/day.md)
papers/<slug>.md            paper notes (from templates/paper.md)
builds/<date>-<name>/       code for each experiment
srs/state.json              review schedule (committed, so it follows you between machines)
anki/cards.tsv              generated export for Anki (gitignored)
omarchy/                    Omarchy bar widget + menu integration
bin/lj                      the CLI (Python standard library only)
```

## Flashcards

Write cards anywhere in a day log or paper note, one per line:

```markdown
- What does RoPE rotate? :: The query and key vectors, by an angle proportional to position
- Why scale attention by 1/√d_k? :: To keep dot-product variance near 1 so softmax doesn't saturate
```

- `lj review` is the built-in SM-2 reviewer. Grades: 1 again · 2 hard · 3 good · 4 easy.
- `lj export` writes `anki/cards.tsv`. In Anki, use File → Import (deck *LLM Journey*).
- `lj export --anki` sends new cards straight to a running Anki through the [AnkiConnect](https://ankiweb.net/shared/info/2055492159) add-on.
- `lj cards` lists every card and its due date.

Each card's ID is a hash of its question, so you can fix a typo in the answer without losing its review history.

## Omarchy integration

```bash
./omarchy/install.sh
```

The script:
- links `lj` into `~/.local/bin`
- links `omarchy/plugin` to `~/.config/omarchy/plugins/jangar.llm-journey` and turns on the bar widget
- adds a **Learn** submenu to the Omarchy menu (today, recall, review, papers, repo)

The bar widget shows `󰧑 <streak> · <due cards>`. It's highlighted until today's log has real content.
**Left click** opens today's log, **right click** starts a review, and **middle click** runs recall.
To move it: `omarchy bar move jangar.llm-journey --section left`.

## Status

```bash
lj status        # 🔥 streak 12 · 30 days logged · 5/84 cards due · today ✓
```
