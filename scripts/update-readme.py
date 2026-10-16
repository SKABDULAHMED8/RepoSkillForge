import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "registry" / "skills.json"
README = ROOT / "README.md"

START = "<!-- BEGIN GENERATED SKILLS -->"
END = "<!-- END GENERATED SKILLS -->"

with REGISTRY.open("r", encoding="utf-8") as f:
    data = json.load(f)

skills = data.get("skills", [])

rows = [
    "| Skill | Purpose | Upstream |",
    "|---|---|---|",
]

for skill in skills:
    skill_id = skill["id"]
    name = skill["name"]
    description = skill.get("description", "").replace("|", "\\|")
    path = skill["path"]
    source = skill.get("source", "")

    source_name = source.rstrip("/").split("/")[-1] or source

    rows.append(
        f"| **[{name}]({path}/)** (`{skill_id}`) | "
        f"{description} | "
        f"[{source_name}]({source}) |"
    )

generated = START + "\n" + "\n".join(rows) + "\n" + END

text = README.read_text(encoding="utf-8")

start = text.find(START)
end = text.find(END)

if start == -1 or end == -1:
    raise SystemExit(
        "README.md does not contain generated skill markers."
    )

end += len(END)

updated = text[:start] + generated + text[end:]

README.write_text(updated, encoding="utf-8", newline="\n")

print("README.md skill catalogue updated from registry/skills.json")
