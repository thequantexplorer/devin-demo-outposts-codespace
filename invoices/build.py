"""Build invoice PDFs and read their totals with the Typst compiler."""

import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE = "invoices/template.typ"
DATA_DIR = ROOT / "invoices" / "data"


def typst():
    path = shutil.which("typst")
    if path is None:
        raise RuntimeError(
            "typst is not installed on this machine. It is installed in this "
            "repo's Codespace (see .devcontainer/setup.sh)."
        )
    return path


def _data_input(invoice):
    return f"data=/invoices/data/{invoice}.json"


def totals(invoice):
    """Return the totals the template computes for one invoice, in cents."""
    out = subprocess.run(
        [typst(), "query", "--root", str(ROOT), TEMPLATE, "<totals>",
         "--field", "value", "--one", "--input", _data_input(invoice)],
        cwd=ROOT, capture_output=True, text=True, check=True,
    )
    return json.loads(out.stdout)


def build_pdf(invoice, out_dir):
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    pdf = out_dir / f"{invoice}.pdf"
    subprocess.run(
        [typst(), "compile", "--root", str(ROOT), TEMPLATE, str(pdf),
         "--input", _data_input(invoice)],
        cwd=ROOT, capture_output=True, text=True, check=True,
    )
    return pdf


def all_invoices():
    return sorted(p.stem for p in DATA_DIR.glob("*.json"))


def main(argv):
    out_dir = ROOT / "out"
    for invoice in argv or all_invoices():
        pdf = build_pdf(invoice, out_dir)
        t = totals(invoice)
        print(f"{invoice}: total {t['total'] / 100:.2f} -> {pdf.relative_to(ROOT)}")


if __name__ == "__main__":
    main(sys.argv[1:])
