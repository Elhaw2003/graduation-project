from __future__ import annotations

import re
import sys
from pathlib import Path

from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer


def _escape(text: str) -> str:
    return (
        text.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\t", "    ")
    )


def md_to_story(md: str):
    styles = getSampleStyleSheet()

    h1 = ParagraphStyle("H1", parent=styles["Heading1"], spaceAfter=10)
    h2 = ParagraphStyle("H2", parent=styles["Heading2"], spaceAfter=8)
    h3 = ParagraphStyle("H3", parent=styles["Heading3"], spaceAfter=6)
    body = ParagraphStyle("Body", parent=styles["BodyText"], leading=14, spaceAfter=6)
    bullet = ParagraphStyle(
        "Bullet",
        parent=styles["BodyText"],
        leftIndent=14,
        bulletIndent=6,
        leading=14,
        spaceAfter=2,
    )
    code = ParagraphStyle(
        "Code",
        parent=styles["BodyText"],
        fontName="Courier",
        fontSize=9,
        leading=11,
        spaceAfter=2,
    )

    story = []
    in_code = False

    for raw_line in md.splitlines():
        line = raw_line.rstrip("\n").rstrip("\r")

        if line.strip().startswith("```"):
            in_code = not in_code
            continue

        if in_code:
            story.append(Paragraph(_escape(line), code))
            continue

        if not line.strip():
            story.append(Spacer(1, 6))
            continue

        if line.startswith("# "):
            story.append(Paragraph(_escape(line[2:].strip()), h1))
            continue
        if line.startswith("## "):
            story.append(Paragraph(_escape(line[3:].strip()), h2))
            continue
        if line.startswith("### "):
            story.append(Paragraph(_escape(line[4:].strip()), h3))
            continue

        m = re.match(r"^\s*[-*]\s+(.*)$", line)
        if m:
            story.append(Paragraph(_escape(m.group(1)), bullet, bulletText="•"))
            continue

        safe = _escape(line)
        safe = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", safe)
        story.append(Paragraph(safe, body))

    return story


def main(argv: list[str]) -> int:
    if len(argv) != 3:
        print("Usage: python md_to_pdf.py <input.md> <output.pdf>")
        return 2

    in_path = Path(argv[1]).resolve()
    out_path = Path(argv[2]).resolve()

    md = in_path.read_text(encoding="utf-8")

    doc = SimpleDocTemplate(
        str(out_path),
        pagesize=A4,
        leftMargin=2 * cm,
        rightMargin=2 * cm,
        topMargin=2 * cm,
        bottomMargin=2 * cm,
        title=in_path.stem,
    )
    doc.build(md_to_story(md))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

