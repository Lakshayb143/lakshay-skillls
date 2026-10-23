# HyperFrames

HyperFrames (by HeyGen, Apache-2.0) renders HTML, CSS and GSAP to video, frame
by frame. If its own agent skills are installed (`hyperframes`,
`hyperframes-cli`, `hyperframes-registry`, `media-use`), read them first: they
hold the tool's contract (clips, the paused timeline, what's forbidden). This
file adds the habits that held up over several rounds of real work.

To install its core skills for any agent: `npx hyperframes skills update`.

## Privacy and money: on every call

- **Usage reporting**: prefix every command with
  `DO_NOT_TRACK=1 HYPERFRAMES_NO_TELEMETRY=1`. Running
  `hyperframes telemetry disable` once also turns it off for the machine.
- **Snapshots** always take `--describe false`. Without it, frames are sent to
  an outside AI model to be described.
- **Uploads**: never run `publish`, a cloud render, or anything else that
  uploads a project or frames. Don't send `feedback` reports either.
- **HeyGen's paid services** (avatars, generated video, HeyGen voices) are used
  only with a cost estimate and the person's yes.

## Running it

Pin one version per project. Check the newest with `npm view hyperframes
version`, then:

```bash
HF() { DO_NOT_TRACK=1 HYPERFRAMES_NO_TELEMETRY=1 npx --yes hyperframes@<version> "$@"; }
```

Run it from inside the project folder. A shell function doesn't last between
separate tool calls, so define `HF` in each call that uses it, or write the
command out in full. If an installed HyperFrames plugin ships its own launcher,
its skill says how to call it; either way, keep to the project's version.

## A new project

```bash
HF init <name> --example blank --resolution landscape --non-interactive
```

Then shape it like this:

- **`package.json`**:
  - name the version in every script, e.g. `npx --yes hyperframes@<version> preview`;
  - add scripts for `dev`, `check` and `render` only, and no publish script.
- **Fonts**: each one goes in `assets/fonts/` with its license file, loaded
  through `@font-face`. Don't rely on fonts installed on the machine.
- **Tokens**: colours and type sizes go in `:root`.
- **Git**: ignore the `.hyperframes/` working folder.
- **Size**: 1920×1080 at 30 fps is the default. Make a tall 1080×1920 version
  only once the wide one is approved, unless the request is tall from the
  start.

## The drawing pattern, for procedural scenes

When a scene is drawn (counters, flaps, dials, crowds, paths), writing hundreds
of tweens is fragile. Instead:

- **One function per version.** Each one builds its elements once and returns
  `{ lines, after(), render(s) }`. `render(s)` sets every visible property from
  the scene's own time `s`.
- **One proxy tween per scene** drives it:

  ```js
  tl.fromTo(clock, { s: 0 }, { s: SD, duration: SD, ease: 'none',
            onUpdate: () => v.render(clock.s) }, i * SD);
  ```

- **Small pure helpers** keep `render` readable:
  - `r(s, a, b, ease)`: the eased progress between two times;
  - `mix` and `mixc`: blend numbers and colours;
  - `stepPos(s, times, dur, ease)`: adds up eased steps, for clicks and
    counters;
  - `hash` and `rnd`: a seeded FNV hash, so the "random" is the same on every
    render.
- **Fonts first.** Wait for every weight before building the timeline:
  `Promise.all([document.fonts.load('800 88px <Family>'), …, document.fonts.ready])`.
  Then register `window.__timelines['main'] = tl` and call `tl.seek(0)`.
- **Cache text writes.** Only set `textContent` when the text actually changes.

Plain timeline tweens are still right for simple entrances and words. Use the
pattern when the motion is computed, not choreographed.

## Check, look, render

```bash
HF check --json
HF snapshot --at 0.4,1.6,3.2,6.8 --no-end --describe false --output <dir> --json
HF render --fps 30 --quality delivery --output <out>/<name>.mp4 --quiet
```

- **`check`**: fix every error.
  - Overlaps that are there by design (split-flap halves, roll windows) get
    `data-layout-allow-overlap`.
  - Weigh each warning. "Too large" and "dense track" notes, and words that
    pass too fast to read on purpose, can be fine.
- **Snapshots**: look at every still. The first frame of a batch can come back
  blank. If one does, check that moment in the render before you hunt for a
  bug.
- **After rendering**: `ffprobe` the file (duration, size, fps, codec). Pull a
  few frames with `ffmpeg -ss <t> -frames:v 1` and look at them.
- **Many versions of one template** (only the words or a picture change):
  declare variables in the composition and use the local batch render,
  `HF render --batch rows.json --output "renders/{name}.mp4"`.

## Clips, reel and compare sheet, for variations

Render all the versions as one reel, one scene after another, then cut a clip
for each:

```bash
ffmpeg -v error -y -ss $START -t $LEN -i reel.mp4 -c:v libx264 -crf 16 -preset slow \
  -pix_fmt yuv420p -colorspace bt709 -color_primaries bt709 -color_trc bt709 \
  -movflags +faststart -an version-$i.mp4
```

For the compare sheet, grab each version's end frame (about 0.2 s before its
end), scale each to 960×540 and tile them 2×2:

```bash
ffmpeg -i a.png -i b.png -i c.png -i d.png -filter_complex \
  "[0]scale=960:540[a];[1]scale=960:540[b];[2]scale=960:540[c];[3]scale=960:540[d];\
   [a][b]hstack[t];[c][d]hstack[u];[t][u]vstack" -frames:v 1 compare-sheet.png
```

Put a small "Version N" label in a corner of each version. Use a muted colour
that still passes 4.5:1 contrast on the ground, and measure it: the darkest
"muted" grey in a palette often fails.

## Faults met so far

- **Labels running off the frame edge.** Keep labels inside the 90% safe box,
  or fade them before the edge.
- **A light or glow layer above the content**, which dims the text under it.
  Put lights first in the stacking order.
- **SVG sizes that go negative** for elements below the frame, which throws at
  runtime. Guard the size before setting it.
- **Dimmed cards that turn see-through.** Darken them instead of lowering
  their opacity.
- **Figures that read as a solid wall.** Give them a rim stroke against the
  dark fill, and seats or edges to sit behind.
- **Empty space at the bottom** once the layout settles. Check the still of the
  final frame, not just the motion.
