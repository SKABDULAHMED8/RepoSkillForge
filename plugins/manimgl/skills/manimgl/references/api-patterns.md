# ManimGL API patterns

## Scene

```python
from manimlib import *

class Demo(Scene):
    def construct(self):
        ...
```

## Add and animate

```python
circle = Circle()
self.add(circle)
self.play(circle.animate.shift(RIGHT))
self.wait()
```

## LaTeX

```python
eq = Tex(R"\int_0^1 x^2\,dx = \frac13")
self.play(Write(eq))
```

## Groups

```python
group = VGroup(title, equation, graph)
group.arrange(DOWN, buff=0.4)
```

## Graph coordinates

```python
point = axes.c2p(x, y)
```

## Updater

```python
tracker = ValueTracker(0)
dot.add_updater(lambda m: m.move_to(axes.c2p(tracker.get_value(), 0)))
self.add(dot)
self.play(tracker.animate.set_value(5))
```

## Camera

```python
self.play(self.frame.animate.scale(0.75).move_to(target))
```

## 3D

```python
class Demo(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        self.add(sphere)
        self.play(self.frame.animate.reorient(20, 60))
```
