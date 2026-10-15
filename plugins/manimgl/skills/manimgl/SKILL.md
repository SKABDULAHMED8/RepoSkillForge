---
name: manimgl
description: Expert guidance for 3Blue1Brown's ManimGL (the 3b1b/manim project). Use when creating, modifying, debugging, rendering, or explaining ManimGL scenes, especially requests involving manimgl, manimlib, mathematical animations, Tex/TexText, Mobjects, animations, updaters, Axes, 3D scenes, interactive development, or ManimGL CLI flags. Do not silently substitute Manim Community Edition.
---

# ManimGL skill

You are an expert assistant for **ManimGL**, the animation engine maintained in the `3b1b/manim` repository. Your job is to produce code that matches the user's installed ManimGL version, explain the relevant API precisely, and help the user render and iterate on scenes.

## 1. Identify the engine before writing code

ManimGL and Manim Community Edition are separate projects with different APIs.

For this skill, the expected package/import/CLI are:

- package: `manimgl`
- Python import: `from manimlib import *`
- CLI: `manimgl`
- source repository: `https://github.com/3b1b/manim`

Do **not** silently convert ManimGL code to Community Edition.

If the project instead uses:

```python
from manim import *
```

or commands such as:

```text
manim render ...
```

or APIs such as `MathTex`, `Create`, or Community-specific configuration, explicitly identify it as Manim Community Edition and either keep that API or ask before porting.

## 2. Establish the installed version when compatibility matters

The upstream repository evolves. The core Scene/Mobject/Animation model is stable, but renderer and dependency details can change.

Before relying on a version-specific feature, inspect the local installation:

```bash
manimgl --version
python -c "import manimlib, inspect; print(manimlib.__file__)"
```

When working from a source checkout:

```bash
git rev-parse HEAD
git status --short
```

Prefer the local source and the installed package over memory when there is a conflict.

The current upstream repository contains a GPU/wgpu renderer path. Do not claim that the renderer is identical to an older PyPI release. If a user reports a renderer/dependency mismatch, inspect `setup.cfg`, `requirements.txt`, `manimlib/renderer/`, and `manimlib/window.py`.

## 3. Installation and smoke test

ManimGL requires Python 3.10+ and system dependencies such as FFmpeg, graphics support, and optionally LaTeX; Linux also needs Pango development headers. The exact dependency set is platform/version dependent.

For a source checkout:

```bash
git clone https://github.com/3b1b/manim.git
cd manim
python -m pip install -e .
manimgl example_scenes.py OpeningManimExample
```

For a normal package install:

```bash
python -m pip install manimgl
manimgl
```

Do not tell users to install `manim` when they explicitly want this 3b1b project.

If a fresh environment fails, inspect the actual traceback and installed requirements before inventing a workaround.

## 4. Scene authoring model

A standard scene is:

```python
from manimlib import *

class Demo(Scene):
    def construct(self):
        circle = Circle()
        self.play(ShowCreation(circle))
        self.wait()
```

Use:

- `Scene` for ordinary 2D work.
- `ThreeDScene` for 3D camera/depth workflows.
- `InteractiveScene` when the task explicitly needs interactive manipulation.

Common scene methods include:

```python
self.add(mobject)
self.remove(mobject)
self.clear()
self.play(...)
self.wait(seconds)
self.replace(old, new)
self.bring_to_front(mobject)
self.bring_to_back(mobject)
```

For camera-aware work, `self.frame` is the camera frame in ManimGL.

Keep the scene structured as a storyboard: establish objects, introduce an idea, transform it, pause, then continue.

## 5. Mobjects and layout

Common geometry:

```python
Circle()
Dot()
Line(start, end)
Arrow(start, end)
Vector(direction)
Polygon(...)
Rectangle(width=..., height=...)
Square(side_length=...)
RoundedRectangle(...)
Arc(...)
DashedLine(...)
```

Text and math:

```python
Text("Hello", font_size=48)
Tex(R"x^2 + y^2 = 1")
TexText("Plain text with LaTeX-style typesetting")
```

Use raw Python strings for LaTeX whenever backslashes are present:

```python
Tex(R"\frac{a}{b}")
```

For groups:

```python
group = VGroup(title, equation, graph)
group.arrange(DOWN, buff=0.4)
```

Prefer relational layout over hard-coded coordinates:

```python
label.next_to(graph, UP)
title.to_edge(UP)
group.arrange(RIGHT, buff=0.5)
```

Then constrain the complete group:

```python
group.set_max_width(FRAME_WIDTH - 1)
```

Useful placement methods include `shift`, `move_to`, `next_to`, `to_edge`, `to_corner`, `align_to`, `center`, `set_x`, `set_y`, and `replace`.

## 6. Styling

Typical style methods:

```python
mob.set_color(BLUE)
mob.set_fill(BLUE, opacity=0.5)
mob.set_stroke(WHITE, width=2)
mob.set_opacity(0.8)
mob.set_z_index(2)
```

For text over busy graphics:

```python
label.set_backstroke(width=5)
```

Use the built-in color constants when practical. Hex colors are also acceptable where supported.

Do not make every object visually loud. Establish a visual hierarchy: title/caption, primary mathematical object, secondary annotations.

## 7. Animation API

The preferred method-style animation pattern is `.animate`:

```python
self.play(circle.animate.shift(2 * RIGHT).scale(0.5), run_time=2)
```

Common animation families include:

- appearance: `ShowCreation`, `Write`, `FadeIn`, `GrowFromCenter`, `Uncreate`
- disappearance: `FadeOut`
- morphing: `Transform`, `ReplacementTransform`, `TransformFromCopy`
- matching: `TransformMatchingShapes`, `TransformMatchingStrings`, `TransformMatchingTex`
- motion: `MoveToTarget`, `MoveAlongPath`, `Rotate`
- emphasis: `Indicate`, `Flash`, `FlashAround`, `CircleIndicate`, `ApplyWave`, `WiggleOutThenIn`
- composition: `AnimationGroup`, `Succession`, `LaggedStart`, `LaggedStartMap`

Examples:

```python
self.play(Write(eq))
self.play(eq.animate.scale(1.2).set_color(YELLOW))
self.play(FadeOut(eq))
```

Important semantic distinction:

```python
Transform(a, b)
```

makes `a` visually become `b`, while:

```python
ReplacementTransform(a, b)
```

is normally the right choice when `b` should replace `a` as the working object.

Avoid the obsolete pattern:

```python
self.play(mob.shift, RIGHT)
```

Use:

```python
self.play(mob.animate.shift(RIGHT))
```

## 8. Mathematical text and LaTeX

Use `Tex` for mathematical notation:

```python
eq = Tex(R"e^{i\pi} + 1 = 0")
```

Split expressions into parts when you need targeted transforms:

```python
eq = Tex(R"A^2", "+", R"B^2")
```

For reliable indexing of a specific expression, use `isolate` when needed:

```python
eq = Tex(R"x^2 + y^2 = z^2", isolate=[R"x^2", R"y^2"])
```

If LaTeX fails:

1. read the actual LaTeX error;
2. check escaping/raw strings;
3. check whether the required LaTeX distribution/packages are installed;
4. clear the ManimGL cache if templates/packages changed;
5. rerender a minimal expression.

Do not diagnose a LaTeX problem as a Manim problem without checking the compiler output.

## 9. Coordinates and graphs

Use ManimGL coordinate systems rather than manually converting graph coordinates:

```python
axes = Axes(
    x_range=(0, 5, 1),
    y_range=(0, 5, 1),
    width=7,
    height=5,
)

graph = axes.get_graph(lambda x: 0.2 * x**2 + 1)
```

Place points with:

```python
axes.c2p(x, y)
```

Typical coordinate systems include `Axes`, `NumberPlane`, `NumberLine`, `ComplexPlane`, and `ThreeDAxes`.

For a Riemann-sum style scene, build the graph from the axes and obtain rectangles/area from the axes API instead of approximating screen coordinates.

## 10. Updaters and dynamic animation

For values that change over time:

```python
tracker = ValueTracker(0)
dot = Dot()

dot.add_updater(
    lambda m: m.move_to(axes.c2p(tracker.get_value(), 0))
)

self.add(dot)
self.play(tracker.animate.set_value(5), run_time=3)
```

Useful patterns include:

```python
always_redraw(...)
always(...)
f_always(...)
```

Time-based updater:

```python
mob.add_updater(lambda m, dt: m.rotate(dt))
```

Updaters execute while the scene is updating, including during `wait`.

Before a transform, clear an updater if it will fight the transform:

```python
mob.clear_updaters()
```

## 11. Numbers and trackers

Common objects:

```python
ValueTracker(0)
Integer(0)
DecimalNumber(3.14, num_decimal_places=2)
Matrix(...)
```

Animate a tracker:

```python
tracker = ValueTracker(0)
self.play(tracker.animate.set_value(10), run_time=2)
```

For counters, use the number-specific animation available in the installed version rather than manually rebuilding text every frame.

## 12. 3D scenes

Use `ThreeDScene` for actual 3D camera/depth work:

```python
from manimlib import *

class SphereDemo(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        self.add(sphere)
        self.play(self.frame.animate.reorient(20, 60))
        self.wait()
```

Common 3D mobjects include `Sphere`, `Torus`, `Cylinder`, `Cone`, `Cube`, `Prism`, `Line3D`, `Surface`, and `ParametricSurface`.

For labels that should remain attached to the screen rather than the 3D world, use the appropriate fixed-in-frame behavior:

```python
title.fix_in_frame()
```

Do not use a plain `Scene` for a task that depends on depth testing and 3D camera behavior.

## 13. Camera

ManimGL exposes:

```python
self.frame
self.camera
```

Typical camera-frame operations:

```python
self.play(self.frame.animate.scale(0.7))
self.play(self.frame.animate.move_to(point))
```

For 3D:

```python
self.play(self.frame.animate.reorient(theta, phi))
```

For an explanatory animation, camera movement should support the mathematical argument, not merely decorate it.

## 14. CLI workflow

Typical commands:

```bash
manimgl scene.py Demo
manimgl scene.py Demo -w
manimgl scene.py Demo -s -w
manimgl scene.py Demo -so
```

Useful flags commonly include:

- `-w`: write output
- `-o`: write and open
- `-s`: skip to the final frame
- `-so`: save/show the final frame
- `-n`: start or restrict rendering to animation indices
- `-f`: fullscreen preview
- `-a`: render all scenes in a file
- `-i`: GIF output
- `-t`: transparent output where supported
- `-l`, `-m`, `--hd`, `--uhd`: quality presets
- `-r`: explicit resolution
- `--fps`: frame rate
- `--file_name`: output filename
- `--video_dir`: output directory
- `--clear-cache`: clear cached text/LaTeX resources
- `--config_file`: use a specific config

Always verify flags against the user's installed CLI with:

```bash
manimgl --help
```

because CLI options can change between releases.

For fast iteration, render a low-quality draft first, inspect a still frame, then render the final quality.

## 15. Configuration

ManimGL supports configuration through its default configuration and a local `custom_config.yml`.

When debugging configuration, inspect the actual files in the installed checkout rather than assuming Community Edition configuration keys.

Useful configuration areas include camera resolution/FPS, output directories, asset directories, fonts, and LaTeX templates.

Never tell a user to paste Community Edition `config` dictionaries into ManimGL unless the installed source explicitly supports them.

## 16. Interactive development

ManimGL supports interactive development through scene embedding and CLI/source-line entry.

Inside a scene, when interactive development is appropriate:

```python
self.embed()
```

For a CLI-driven interactive workflow, inspect:

```bash
manimgl --help
```

before relying on a particular `-e`/interactive option.

Interactive development is useful for discovering layout values and camera framing. Once the scene is understood, move stable values back into deterministic source code.

## 17. Rendering and debugging workflow

Use this loop:

1. Confirm the engine and installed version.
2. Create the smallest scene that demonstrates the requested behavior.
3. Render a draft at low quality.
4. Inspect the output frame/video.
5. Fix geometry, timing, LaTeX, or dependency issues.
6. Render the final quality.
7. Keep the scene reproducible.

For a still-frame check:

```bash
manimgl scene.py Demo -s -w -l
```

If the scene is large, use `-n` to iterate on a later animation rather than repeatedly watching the entire animation.

When a render fails, classify the error before changing code:

- import/package error -> environment/version/dependency
- LaTeX compiler error -> TeX setup or expression
- missing asset -> path/configuration
- OpenGL/wgpu/window error -> graphics/backend/environment
- Python exception -> scene/API/code
- clipping/overlap -> layout/camera/frame sizing
- wrong visual state -> animation semantics/updaters

## 18. AI scene-generation workflow

When the user asks for an animation from a natural-language concept:

### First design the storyboard

Identify:

- the mathematical idea;
- the objects that represent it;
- what appears first;
- what transforms into what;
- camera movement;
- narration/beat pauses;
- final takeaway.

### Then implement

Prefer small reusable helpers:

```python
def make_label(text):
    return Text(text, font_size=36)
```

Use groups and relational positioning rather than arbitrary coordinates.

### Then render

Start with:

```bash
manimgl scene.py SceneName -w -l
```

Only after visual correctness is established, increase resolution/quality.

### Then diagnose visually

Look for:

- text clipping;
- overlapping labels;
- off-screen objects;
- transforms between incompatible structures;
- stale objects left behind;
- updater conflicts;
- camera framing;
- excessive animation speed.

## 19. Common mistakes to prevent

### Wrong package

Bad:

```bash
pip install manim
```

when the user requested 3b1b ManimGL.

Correct:

```bash
pip install manimgl
```

or install the requested `3b1b/manim` checkout.

### Wrong import

ManimGL:

```python
from manimlib import *
```

Community Edition:

```python
from manim import *
```

Never mix them casually.

### Wrong animation name

Do not replace ManimGL `ShowCreation` with Community Edition `Create` unless the user explicitly asks for a port.

### LaTeX escaping

Prefer:

```python
Tex(R"\frac{a}{b}")
```

over a normal Python string containing unescaped backslashes.

### Transform semantics

Choose `Transform` versus `ReplacementTransform` based on whether the destination object should become the active replacement.

### Coordinate confusion

For graph scenes, use `axes.c2p(...)`, not raw pixel-like coordinates.

### Updater conflict

An updater can keep modifying an object while a transform is trying to modify it. Clear or redesign the updater when necessary.

### Configuration confusion

Do not import Community Edition configuration conventions into ManimGL.

## 20. Source-of-truth rule

When exact API behavior is uncertain, inspect the installed source.

Useful files in the upstream repository include:

- `example_scenes.py`
- `manimlib/scene/scene.py`
- `manimlib/mobject/mobject.py`
- `manimlib/animation/`
- `manimlib/mobject/`
- `manimlib/camera/`
- `manimlib/config.py`
- `manimlib/default_config.yml`
- `manimlib/renderer/`

Use source inspection to resolve version-specific uncertainty instead of inventing an API.

## 21. Response behavior

When writing ManimGL code:

- give complete runnable snippets where practical;
- include the exact render command;
- state assumptions about version/environment;
- do not silently switch to Manim Community;
- avoid claiming an API exists unless it is supported by the user's version or verified in source;
- keep examples visually purposeful;
- prefer deterministic, maintainable scenes over clever one-liners.

When the user asks to create a complete animation, produce the scene file first, then explain how to render and inspect it.

## 22. Compact cookbook

### Equation transformation

```python
from manimlib import *

class EquationDemo(Scene):
    def construct(self):
        eq1 = Tex(R"x^2 - 5x + 6 = 0").scale(1.4)
        self.play(Write(eq1))
        self.wait()

        eq2 = Tex(R"(x-2)(x-3)=0").scale(1.4)
        self.play(TransformMatchingShapes(eq1, eq2))
        self.wait()
```

### Moving point on a graph

```python
from manimlib import *

class GraphDemo(Scene):
    def construct(self):
        axes = Axes(
            x_range=(0, 5, 1),
            y_range=(0, 5, 1),
            width=7,
            height=5,
        )
        graph = axes.get_graph(lambda x: 0.2 * x**2 + 1)

        tracker = ValueTracker(1)
        dot = Dot()

        dot.add_updater(
            lambda m: m.move_to(
                axes.c2p(tracker.get_value(),
                         0.2 * tracker.get_value()**2 + 1)
            )
        )

        self.play(Write(axes), ShowCreation(graph))
        self.add(dot)
        self.play(tracker.animate.set_value(4), run_time=3)
        self.wait()
```

### 3D object

```python
from manimlib import *

class ThreeDDemo(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        self.add(sphere)
        self.play(self.frame.animate.reorient(20, 60), run_time=2)
        self.wait()
```
