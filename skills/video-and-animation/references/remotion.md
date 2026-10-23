# Remotion

Remotion makes videos out of React components. A component reads
`useCurrentFrame()` and computes how it looks with `interpolate()` and
`spring()`. A `<Composition>` names its size, fps, length and default props.

## When it's worth it over HyperFrames

- **Data that shapes the video**: lists of any length, charts drawn from
  arrays, scenes that appear or not depending on the input, rendered for many
  inputs (one video per customer, per article, per week's numbers). Props come
  in from JSON, and React's logic handles the structure. If only the words or a
  picture change, HyperFrames does it locally with `render --batch`.
- **Live playback in a React page**: the same piece plays in a page, with play,
  pause and scrub, or with props the page sets. `@remotion/player` does that. A
  HyperFrames render can only become a file.
- **Video made by a product**, rendered on a server for each user. That is an
  architecture decision (cost, servers, license), so ask before choosing it.
- **The person asks for Remotion.**

For a single film or clip, HyperFrames needs less setup. Say why Remotion is
better before choosing it.

## License

Remotion is free for an individual, a for-profit company with up to 3
employees, a non-profit, or while evaluating it. Bigger for-profit companies
need a paid company license. Check the current terms at
https://www.remotion.dev/docs/license before relying on this. Note in the
project's README when it depends on the free license, so the limit isn't
forgotten as the company grows.

## Setup

- **The project**: make a separate folder for each one with
  `npx create-video@latest`, or add Remotion to an existing React app.
- **Versions**: pin exact versions. Every `remotion` and `@remotion/*` package
  must be the same version.
- **Remotion's own agent skills**: Remotion publishes them
  (`npx skills add remotion-dev/skills`). Installing them writes third-party
  instructions into the project, so ask first, then read what was installed
  before using it.
- **Fonts**: load them with `@remotion/google-fonts` or a local `staticFile()`
  font. Wait with `delayRender()` and `continueRender()` until they're loaded.
- **Deterministic**: use `random('seed')` from `remotion`, never
  `Math.random()`. Use no timers and no CSS transitions or animations: every
  value comes from the frame.

## Preview, look, render

```bash
npx remotion studio                                      # the person previews and edits here
npx remotion still <CompId> out/frame-60.png --frame=60  # stills to look at
npx remotion render <CompId> out/<name>.mp4 --codec=h264 --crf=16
```

- **Batch renders**: write a small Node script that calls `renderMedia()` from
  `@remotion/renderer` for each input. Keep it local.
- **Remotion Lambda and Cloud Run** are paid cloud services. Use them only with
  a cost estimate and the person's yes.
- **Usage reporting**: the free license needs none. If a company license is
  ever bought, read what its reporting sends before turning it on.

## In a React or Next.js page

- **Embedding**: use `<Player component={…} inputProps={…} durationInFrames={…}
  compositionWidth={…} compositionHeight={…} fps={30} controls loop />` from
  `@remotion/player`.
- **The same component** can then be rendered to MP4 for posts.
- **Reduced motion**: when the reader asks for it, start paused on the final
  frame.
- **Who builds it**: it's a new dependency and site code. If someone else owns
  the site's code, write it up as a self-contained prompt for them.
