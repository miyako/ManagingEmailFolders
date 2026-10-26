import contextlib
import io
import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import tool4d


class Tool4DExitTests(unittest.TestCase):
    def run_compile(self, *, returncode=0, output='{"success": true}'):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory) / "Project"
            project.mkdir()
            (project / "Test.4DProject").write_text("{}")

            def run(command, **kwargs):
                project_path = Path(next(arg.split("=", 1)[1] for arg in command if arg.startswith("--project=")))
                if output is not None:
                    (project_path.parent.parent / "agent-test.txt").write_text(output)
                return subprocess.CompletedProcess(command, returncode, "", "")

            with patch("sys.argv", ["tool4d.py", directory, "--compile"]), \
                    patch.object(tool4d, "find_tool4d", return_value="tool4d"), \
                    patch.object(tool4d.subprocess, "run", side_effect=run), \
                    contextlib.redirect_stdout(io.StringIO()) as stdout, \
                    contextlib.redirect_stderr(io.StringIO()):
                tool4d.main()
                return stdout.getvalue()

    def test_successful_compile(self):
        self.assertTrue(json.loads(self.run_compile())["success"])

    def test_nonzero_exit_rejected_even_with_success_artifact(self):
        with self.assertRaisesRegex(SystemExit, "status 1"):
            self.run_compile(returncode=1)

    def test_compiler_failure_rejected_even_with_zero_exit(self):
        with self.assertRaisesRegex(SystemExit, "compilation failed"):
            self.run_compile(output='{"success": false, "errors": []}')

    def test_missing_artifact_rejected(self):
        with self.assertRaisesRegex(SystemExit, "no agent-test.txt"):
            self.run_compile(output=None)

    def test_empty_artifact_rejected(self):
        with self.assertRaisesRegex(SystemExit, "empty agent-test.txt"):
            self.run_compile(output="")


if __name__ == "__main__":
    unittest.main()
