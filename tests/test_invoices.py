from pathlib import Path

import pytest

from invoices.build import ROOT, all_invoices, build_pdf, totals

# Expected amounts in cents, worked out by hand from the billing rules in README.md.
EXPECTED = {
    "INV-1001": {"subtotal": 54599, "discount": 0, "tax": 4504, "total": 59103},
    "INV-1002": {"subtotal": 62385, "discount": 6239, "tax": 4632, "total": 60778},
    "INV-1003": {"subtotal": 19790, "discount": 0, "tax": 1187, "total": 20977},
    "INV-1004": {"subtotal": 104696, "discount": 15704, "tax": 6452, "total": 95444},
}


def test_every_invoice_has_expected_totals():
    assert all_invoices() == sorted(EXPECTED)


@pytest.mark.parametrize("invoice", sorted(EXPECTED))
def test_totals(invoice):
    got = totals(invoice)
    want = EXPECTED[invoice]
    assert {k: got[k] for k in want} == want


@pytest.mark.parametrize("invoice", sorted(EXPECTED))
def test_pdf_builds(invoice, tmp_path):
    pdf = build_pdf(invoice, tmp_path)
    assert Path(pdf).read_bytes().startswith(b"%PDF")


def test_typst_version_matches_pin():
    import subprocess
    from invoices.build import typst

    pinned = (ROOT / ".typst-version").read_text().strip()
    out = subprocess.run([typst(), "--version"], capture_output=True, text=True, check=True)
    assert out.stdout.split()[1] == pinned
