import unittest

import build


class NumberedInstructionsTest(unittest.TestCase):
    def test_numbering_continues_after_figure(self):
        source = """# Title

## Instructions

1. First step
2. Second step

![](fig-02)

3. Third step
4. Fourth step
"""
        page, _ = build.to_html(source, {}, "en")
        self.assertIn('<ol start="3">', page)
        self.assertIn("<li>Third step</li>", page)
        self.assertIn("<figure>", page)

    def test_numbered_code_lines_stay_in_code(self):
        source = """# Title

## Example

```text
3. Sample output
```
"""
        page, _ = build.to_html(source, {}, "en")
        self.assertIn('<pre><code class="language-text">3. Sample output\n</code></pre>', page)
        self.assertNotIn('<ol start="3">', page)


if __name__ == "__main__":
    unittest.main()
