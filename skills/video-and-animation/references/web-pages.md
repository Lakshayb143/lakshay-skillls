# Motion in an article or a web page

## First, find out what the page accepts

Read the code that renders the page before choosing a format. Re-read it each
time, because renderers change.

| The renderer | What can go in |
| --- | --- |
| Markdown with raw HTML turned off | Images only: an animated SVG, an animated WebP or a GIF |
| Markdown or HTML with raw HTML allowed | Images, plus `<video>` |
| MDX, or a page built from components | Images, video, and components placed by name |
| A CMS | Whatever its blocks allow |

Also check:

- where media files must live (often a folder per article);
- whether a missing file or missing alt text fails the build;
- how images load (lazy loading, sizes).

Prefer WebP to GIF. A GIF is heavy and has few colours.

If the piece needs something the page can't show yet, such as video or an
interactive figure in an images-only blog, the renderer needs a small change.
Two examples:

- a `::: video` block that becomes
  `<video muted loop playsinline autoplay poster>`, with a reduced-motion rule
  that shows the poster;
- a `::: figure <name>` block mapped to a component.

That's site code: follow the project's rule on who builds it.

## Animated SVG: the lightest figure

Good for diagrams that build up, arrows that travel, steps that light in turn,
and a few words. Make it a single file with:

- **Scaling**: a `viewBox` and no fixed width.
- **A `<title>`** that matches the alt text.
- **The motion**: `<style>` with `@keyframes` and an
  `animation-iteration-count`. Pause at the end of each loop, so the reader can
  read the finished state.
- **Reduced motion**: a `@media (prefers-reduced-motion: reduce)` rule inside
  the SVG that shows the finished state, still.
- **Fonts**: an SVG shown as an image can't fetch fonts or files. Use system
  fonts, convert the words to paths (keeping the words in the alt text), or
  embed a small font subset as a `data:` URI.
- **No JavaScript and no external references.** Inside an `<img>` they don't
  run or load.

Look at it the way the reader will. Put it in a plain local test page as an
`<img>` and take stills from a headless browser at a few moments. Keep it
small: a few KB to a few tens of KB is typical.

## A rendered loop, when the figure is too rich for SVG

Build it in HyperFrames (`hyperframes.md`) at the size it will show, often
1200×675 or 1200×800 for an article. Then export:

```bash
# animated WebP (works anywhere an image does)
ffmpeg -i loop.mp4 -vf "fps=24,scale=1200:-1:flags=lanczos" -c:v libwebp -lossless 0 \
  -q:v 72 -loop 0 -an figure.webp
# muted MP4 + WebM + poster (where the page can play video)
ffmpeg -i loop.mp4 -c:v libx264 -crf 23 -preset slow -pix_fmt yuv420p -movflags +faststart -an figure.mp4
ffmpeg -i loop.mp4 -c:v libvpx-vp9 -crf 34 -b:v 0 -an figure.webm
ffmpeg -sseof -0.3 -i loop.mp4 -frames:v 1 figure-poster.png
```

- **Size**: aim to keep a figure under about 1.5 MB. Cut frames, length or
  size before quality. For scale, one busy 7 s clip came to:
  - about 2.3 MB as WebP at 1200 px wide and 24 fps;
  - about 1.05 MB as WebP at 960 px, 15 fps and quality 65;
  - about 0.23 MB as WebM.
- **The loop seam**: the last frame should lead into the first, or hold on the
  finished state.
- **The poster**: show the finished state, so a reader who sees only the poster
  still gets the point.

## An interactive figure, when the reader should play with it

Use one only when trying it teaches more than watching: dragging a slider,
switching examples, stepping through.

- **The tool**: use the site's own motion library if it has one (for example
  framer-motion's `useReducedMotion()`). Give a still, finished state for
  reduced motion.
- **Self-contained**: no new dependency and no data fetching. It must work from
  the keyboard, and every control needs a label.
- **Who builds it**: design the motion and the words yourself. If someone else
  builds the site's code, hand the component over as a self-contained prompt,
  then check the result by reading the code. The person checks it in their own
  browser.

## In every case

- **The text says it too.** The figure explains, and the article text says the
  same thing in words. A reader who can't see it, or who turned motion off,
  loses nothing.
- **Safety**: no flashing more than three times a second, and no sound.
- **Calm**: no endless fast motion next to the text people are reading. Use
  long holds on the finished state, or play once and stop.
- **The look**: use the site's own palette and type from its design system. A
  figure that shows a screen can follow the screen's theme. A diagram sits on
  the page's own ground.
