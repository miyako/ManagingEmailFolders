"""Offline resource/configuration checks; opt in to the existing tool4d runner."""
import json
import os
import re
import subprocess
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEMO = ROOT / "demo/ManagingEmailFolders"
SOURCES = DEMO / "Project/Sources"
NS = {"x": "urn:oasis:names:tc:xliff:document:1.2"}


def resources(language):
    entries = {}
    for path in sorted((DEMO / "Resources" / f"{language}.lproj").glob("*.xlf")):
        root = ET.parse(path).getroot()
        metadata = root.find("x:file", NS)
        if metadata.get("target-language") != language:
            raise AssertionError(f"Incorrect resource language: {path}")
        for unit in root.findall(".//x:trans-unit", NS):
            identifier = unit.attrib["id"]
            if identifier in entries:
                raise AssertionError(f"Duplicate resource ID: {identifier}")
            entries[identifier] = (
                unit.findtext("x:source", namespaces=NS),
                unit.findtext("x:target", namespaces=NS),
            )
    return entries


def literal(text):
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


class DemoLocalisationTests(unittest.TestCase):
    def test_bilingual_sources_and_placeholders(self):
        english, japanese = resources("en"), resources("ja")
        self.assertTrue(english)
        self.assertEqual(english.keys(), japanese.keys())
        for identifier, (source, target) in english.items():
            with self.subTest(identifier=identifier):
                self.assertFalse(identifier.startswith("Common"))
                self.assertEqual(source, target)
                ja_source, ja_target = japanese[identifier]
                self.assertEqual(source, ja_source)
                self.assertTrue(ja_target)
                self.assertEqual(
                    sorted(re.findall(r"\{[^{}]+\}", source)),
                    sorted(re.findall(r"\{[^{}]+\}", ja_target)),
                )
                self.assertNotIn("\n", source)
                self.assertNotIn("\n", ja_target)

    def test_all_references_resolve(self):
        entries = resources("en")
        paths = [SOURCES / "menus.json", SOURCES / "Forms/Form1/form.4DForm"]
        references = set()
        for path in paths:
            references.update(re.findall(r":xliff:([^\"\s]+)", path.read_text()))
        for path in SOURCES.rglob("*.4dm"):
            text = path.read_text()
            self.assertNotRegex(text, r'Get localized string\(')
            references.update(re.findall(r'Get localized string:C991\("([^"]+)"', text))
        references.update({
            "ConfigurationMissing", "ConfigurationInvalid",
            "ConfigurationProviderMissing", "ConfigurationFieldsMissing",
        })
        self.assertFalse({identifier for identifier in references
                          if not identifier.startswith("Common") and identifier not in entries})

    def test_form_and_menu_bindings(self):
        folder = SOURCES / "Forms/Form1"
        form = json.loads((folder / "form.4DForm").read_text())
        self.assertEqual(form["method"], "method.4dm")
        self.assertIn("onLoad", form["events"])
        self.assertEqual(len(form["pages"]), 4)
        for page in form["pages"]:
            for obj in page["objects"].values():
                if "method" in obj:
                    self.assertTrue((folder / obj["method"]).is_file())
        menus = json.loads((SOURCES / "menus.json").read_text())
        for menu in menus["menus"]:
            for item in menu["items"]:
                if "method" in item:
                    self.assertTrue((SOURCES / "Methods" / (item["method"] + ".4dm")).is_file())
        start = (SOURCES / "Methods/__runDemo.4dm").read_text()
        self.assertIn('DIALOG("Form1"; $params; *)', start)
        self.assertNotIn("CLOSE WINDOW", start)

    def test_component_dependencies_are_declared(self):
        manifest = json.loads((SOURCES / "dependencies.json").read_text())
        self.assertIsInstance(manifest["version"], int)
        for name, repository in (("4D NetKit", "4d/4D-NetKit"), ("4D SVG", "4d/4D-SVG")):
            with self.subTest(component=name):
                dependency = manifest["dependencies"][name]
                self.assertEqual(dependency["github"], repository)
                self.assertEqual(dependency["version"], "4d")

    def test_private_configuration_is_not_embedded(self):
        for path in SOURCES.rglob("*.4dm"):
            self.assertNotRegex(path.read_text(), r'\.(?:clientId|clientSecret)\s*:=\s*"',
                                msg=f"Inline credentials in {path.name}")
        sample = json.loads((DEMO / "Resources/oauth.example.json").read_text())
        self.assertTrue(all(value.startswith("YOUR ")
                            for provider in sample.values() for value in provider.values()))

    @unittest.skipUnless(os.environ.get("RUN_DEMO_RUNTIME") == "1", "Runtime checks are opt-in")
    def test_runtime_resources_and_configuration(self):
        expected = {
            language: {identifier: target for identifier, (_, target) in resources(language).items()}
            for language in ("en", "ja")
        }
        cases = [
            ("malformed", "{", "Google", False, "ConfigurationInvalid"),
            ("scalar", "42", "Google", False, "ConfigurationInvalid"),
            ("array", "[]", "Google", False, "ConfigurationInvalid"),
            ("null", "null", "Google", False, "ConfigurationInvalid"),
            ("missing-provider", "{}", "Google", False, "ConfigurationProviderMissing"),
            ("wrong-provider-type", '{"Google":[]}', "Google", False, "ConfigurationProviderMissing"),
            ("missing-client", '{"Google":{}}', "Google", False, "ConfigurationFieldsMissing"),
            ("numeric-client", '{"Google":{"clientId":42}}', "Google", False, "ConfigurationFieldsMissing"),
            ("missing-secret", '{"Google":{"clientId":"test-client"}}', "Google", False, "ConfigurationFieldsMissing"),
            ("blank-client", '{"Microsoft":{"clientId":"   "}}', "Microsoft", False, "ConfigurationFieldsMissing"),
            ("placeholder", '{"Microsoft":{"clientId":"YOUR MICROSOFT CLIENT ID"}}',
             "Microsoft", False, "ConfigurationFieldsMissing"),
            ("valid-google", '{"Google":{"clientId":"test-client","clientSecret":"test-secret"}}',
             "Google", True, ""),
            ("valid-microsoft", '{"Microsoft":{"clientId":"test-client"}}', "Microsoft", True, ""),
        ]
        lines = [
            "var $report; $strings; $actual; $item; $result : Object",
            "var $id; $locale; $previousHandler : Text",
            "var $file : 4D.File",
            "var $cases : Collection",
            "$report:={locales: {}; configuration: []}",
            '$file:=File("/PACKAGE/configuration-test.json")',
            '$result:=LoadOAuthConfiguration("Google"; $file)',
            '$report.configuration.push({name: "missing-file"; success: $result.success; messageId: $result.messageId})',
        ]
        for language in ("en", "ja"):
            lines += [
                f"SET DATABASE LOCALIZATION({literal(language)})",
                f"$strings:=JSON Parse({literal(json.dumps(expected[language], ensure_ascii=False))})",
                "$actual:={}",
                "For each ($id; OB Keys($strings))",
                " $actual[$id]:=Get localized string:C991($id)",
                "End for each",
                f"$report.locales[{literal(language)}]:=$actual",
            ]
        fixtures = [{"name": name, "text": text, "provider": provider}
                    for name, text, provider, _, _ in cases]
        lines += [
            f"$cases:=JSON Parse({literal(json.dumps(fixtures))})",
            "For each ($item; $cases)",
            " $file.setText($item.text)",
            " $previousHandler:=Method called on error",
            " $result:=LoadOAuthConfiguration($item.provider; $file)",
            " $report.configuration.push({name: $item.name; success: $result.success; messageId: $result.messageId; handlerRestored: (Method called on error=$previousHandler)})",
            "End for each",
            'File("/PACKAGE/agent-test.txt").setText(JSON Stringify($report; *))',
            "QUIT 4D",
        ]
        with tempfile.TemporaryDirectory(prefix="demo-resource-test-") as directory:
            method = Path(directory) / "test.4dm"
            method.write_text("\n".join(lines) + "\n")
            command = [sys.executable, str(ROOT / "tools/tool4d.py"), str(DEMO), str(method)]
            for variable in ("NETKIT_COMPONENT", "SVG_COMPONENT"):
                if os.environ.get(variable):
                    command += ["--component", os.environ[variable]]
            run = subprocess.run(command, capture_output=True, text=True, timeout=180)
            self.assertEqual(run.returncode, 0, run.stderr)
            report = json.loads(run.stdout)
        self.assertEqual(report["locales"], expected)
        actual_cases = report["configuration"]
        self.assertEqual(actual_cases[0], {
            "name": "missing-file", "success": False, "messageId": "ConfigurationMissing",
        })
        self.assertEqual(len(actual_cases), len(cases) + 1)
        for actual, (name, _, _, success, message) in zip(actual_cases[1:], cases):
            with self.subTest(case=name):
                self.assertEqual(actual["name"], name)
                self.assertEqual(actual["success"], success)
                self.assertEqual(actual.get("messageId", ""), message)
                self.assertTrue(actual["handlerRestored"])


if __name__ == "__main__":
    unittest.main()
