---
name: video-and-animation
description: Pick the right way to make a video or an animation for the task at hand, then make it - HyperFrames, Remotion, an animated SVG, a looping clip in an article, or an interactive figure on a web page. Use this whenever someone wants to make, animate, render or explain something in motion - a film or a scene, a social clip, a title card, kinetic type, an explainer, a motion graphic, a GIF or loop, an animated diagram in a blog post, a concept explained with animation, or a choice between Remotion and HyperFrames - even if they don't name a tool. Not for hover effects, page transitions or other interface motion.
license: MIT
---

# Video and animation

The tool follows the task. Work out where the piece will be seen and what the
viewer can do with it, pick the lightest way that does that well, say the pick
and the reason in a line or two, then build it. The person may redirect you, so
don't put effort you can't reuse into anything before they've seen the pick.

## 0. Read the project's own rules first

Before you write a word or pick a colour, look for the project's rules and
follow them over this skill:

- agent instructions (`AGENTS.md`, `CLAUDE.md` or similar);
- a design system (`DESIGN.md`, tokens, a theme file);
- brand, messaging or motion guides;
- a tracker or notes from earlier rounds of the same work.

Names vary, so search for them. They decide the words, the look, what may be
shown, who builds what and what may cost money. Most mistakes in this kind of
work come from breaking one of those rules, not from the motion.

## 1. Where will it be seen?

- **As a video file**: posted to a social platform, put in a film, or sent to
  someone. The output is an MP4, maybe with a tall version as well.
- **Inside a web page**: a blog article, a landing page or docs. The output is
  a file the page shows, or code the page runs.
- **Inside an app's interface**: hover states, page transitions, loading, small
  motion on buttons. That's frontend work, not this skill.

## 2. Pick the way

| The task | Use | Why it fits |
| --- | --- | --- |
| A rendered video: film scenes, social clips, title cards, kinetic type, explainers, charts drawn in code | **HyperFrames** (`references/hyperframes.md`) | Plain HTML, CSS and GSAP with no build step. It renders frame by frame, so every render comes out the same. It has a registry of ready-made blocks. Runs locally with Node and ffmpeg. Apache-2.0. |
| The same animation must also play live in a React page, with play and scrub; or the data changes the video's structure (lists of any length, charts drawn from arrays) and it's rendered many times | **Remotion** (`references/remotion.md`) | React components with props and real logic. `@remotion/player` puts the same piece in a page. Check the license: it's free for individuals and small companies only. A plain text swap across a few videos stays in HyperFrames (`render --batch`). |
| A simple article figure: a diagram that builds, arrows, a few shapes and words, a short calm loop | **An animated SVG file** (`references/web-pages.md`) | Works anywhere the page accepts an image. A few KB, sharp at any size, no player. |
| A richer article figure: many elements, texture, something that looks like video | **A HyperFrames render, exported as an animated WebP**, or as a muted MP4 or WebM loop if the page can play video | Every frame is designed once, then becomes a file. |
| A figure the reader plays with: drag, step through, switch examples | **A component in the site**, using its own motion library, or a Remotion Player if it's also a video | Only code can respond to the reader. Usually a site change. |
| A presenter, avatar, voiceover, stock footage, music or sound effects | HyperFrames' media skill if it's installed, within the money rules below | Many of those sources are paid or cloud services. |

Other tools, only when they clearly fit:

- **Manim**: maths and geometry worked through step by step. It's a Python
  library, and formulas need LaTeX.
- **Motion Canvas**: code walkthroughs timed to a voiceover. HyperFrames covers
  most of this.
- **Lottie or Rive**: only when someone hands over a Lottie JSON or a Rive file.
  Don't write Lottie by hand; HyperFrames can play a Lottie file.
- **A screen recording**: when seeing the real product work is the point. Check
  first whether the project would rather draw its screens.

Tie-breakers:

- **Default**: a rendered video with no reason to pick Remotion is made in
  HyperFrames. It needs no React project.
- **Remotion**: pick it for a concrete reason from the table, and name the
  reason.
- **In a page**: the lightest thing that works wins. CSS or SVG before
  JavaScript, a file before a component, and no new dependency unless it earns
  its place.
- **Post and article**: when the same piece is needed in both, build it once in
  HyperFrames and export both.
- **Ask**: if two ways are close and the difference matters to the person
  (money, a new dependency, a change to site code), ask. Put the recommended
  option first, and say in plain words what each one does.

## 3. Make it

1. **The idea and the words first.** Write down, in one sentence, the one
   thing the motion has to make someone understand.
   - Every word on screen comes from somewhere: approved copy, the product's
     own labels, or the person. Don't invent claims, numbers, results or
     quotes. If new wording is needed, propose it and get a yes.
   - In an intro or an explainer, the first few seconds say who it's for, the
     problem, and what it does. Use plain words the audience uses, not the
     builder's terms.
2. **Variations, when a look is being chosen.** Build 3 or 4 truly different
   ideas, not one idea in four colours. Sets that have worked combine:
   - a typographic object;
   - a scene;
   - a physical object;
   - a journey.

   Put them in one project, one scene each. Deliver a clip for each version, a
   reel of all of them, and a compare sheet of their end frames. Show the built
   thing, never a written brief: people judge what they can see.
3. **Build it deterministic.** The same time always gives the same frame: use
   seeded randomness, and no clocks or timers. Wait for fonts before building.
4. **Look at it.** Take stills at the key moments, using a headless browser,
   and look at them. Fix what's wrong, look again, then render and check a few
   frames from the finished file. Common faults:
   - text clipped at the frame edge;
   - layers covering each other;
   - low contrast on small type;
   - an end state that doesn't hold.
5. **Deliver and record.**
   - **Where**: put the files in the project's output folder, under the
     round's name.
   - **The hand-over**: give the paths, one line per version, what's known to
     be unfinished, and what the person decides next.
   - **Records**: if the project keeps a tracker, note the round there.
   - **Git**: if the project uses git, commit by path, and don't push unless
     asked.
6. **Never publish.** Don't post, upload, schedule or send anything, and don't
   use any tool's publish or share command. A person does that by hand.

If the project says another agent or person builds its site or product code,
don't edit that code yourself. Write them a self-contained prompt for the code
the piece needs (a new block in the blog's renderer, an interactive
component), then check what comes back.

## Taste, when the project has no look of its own

- **Quiet and premium**: few words, big type, generous space, and one accent
  colour on a calm ground.
- **No decoration for its own sake**: no glow, lens flares or decorative
  gradients. Brand graphics are used sparingly and sit behind the content.
- **Calm motion**: eased entrances that settle, one idea at a time, and the
  finished state held long enough to read.
- **Drawn, not photographed**: draw interfaces, diagrams and charts in code
  rather than using screenshots or stock photos. They stay sharp and editable,
  and no one's real data ends up in them.
- **Logos**: never let an image model draw a logo; use the real file. Don't
  show other companies' logos without the right to.
- **Examples**: example outputs carry the label "Example".

## On a web page

- **Reduced motion**: when the reader asks for reduced motion, show the
  finished state, still.
- **No flashing** more than three times a second.
- **Alt text** that says what the animation shows. The text around the figure
  says it too.
- **Calm loops** that are short.
- **No sound.**
- **Small files.** Details are in `references/web-pages.md`.

## Privacy and money

- **Usage reporting**: turn it off wherever a tool allows it.
- **Outside services**: don't send frames, footage or project files to them,
  including AI "describe" features, unless the person asked.
- **Uploads**: never use a publish, share, cloud-render or upload command.
- **Paid services** need a cost estimate and the person's yes first. That
  covers cloud rendering, paid models, stock libraries and voice.
- **Keys**: read them from the environment. Never print, log or commit them.

## Files

- `references/hyperframes.md`: running HyperFrames privately, the project
  shape, a pattern for drawn scenes, rendering, clips and compare sheets, and
  the faults met so far. If HyperFrames' own skills are installed, read them as
  well; they hold the tool's contract.
- `references/remotion.md`: when Remotion is worth it, the license, setup,
  rendering, and embedding it in a React page.
- `references/web-pages.md`: motion in an article or a page. What the page
  accepts, animated SVG, WebP and video exports with real sizes, and
  interactive figures.
