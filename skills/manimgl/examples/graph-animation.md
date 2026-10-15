# Graph animation

```python
from manimlib import *

class Graph(Scene):
    def construct(self):
        axes = Axes(x_range=(0, 5, 1), y_range=(0, 5, 1),
                    width=7, height=5)
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
