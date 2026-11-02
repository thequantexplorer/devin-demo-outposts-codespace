# acme-invoices

Invoice PDFs for Acme Field Supply. Each invoice is a JSON file in `invoices/data/`. The template `invoices/template.typ` turns it into a PDF with [Typst](https://typst.app), a document compiler.

Typst is not installed on Devin's own machines. It is installed in this repo's GitHub Codespace (see `.devcontainer/setup.sh`), so the tests only run there.

## Billing rules

All amounts are whole cents.

1. Line amount = quantity × unit price.
2. Subtotal = sum of the line amounts.
3. Discount = `discount_pct` percent of the subtotal, rounded to the nearest cent (halves round up).
4. Tax = `tax_rate_bp` basis points (825 = 8.25%) of the subtotal **after** the discount, rounded to the nearest cent (halves round up).
5. Total = subtotal − discount + tax.

## Commands

Run these in the Codespace terminal.

```sh
python -m pytest                 # run the tests
python -m invoices.build         # build every invoice PDF into out/
bash scripts/machine-info.sh     # show which machine you are on
bash scripts/start-worker.sh     # serve Devin sessions from this Codespace
```

## Known issue

Two invoices with a discount have the wrong tax and total:

```text
$ python -m pytest
..F.F.....                                                               [100%]
FAILED tests/test_invoices.py::test_totals[INV-1002] - AssertionError: assert...
FAILED tests/test_invoices.py::test_totals[INV-1004] - AssertionError: assert...
2 failed, 8 passed in 0.18s
```

On a machine without Typst, the tests stop before they start:

```text
$ python -m pytest
Exit: typst is not installed on this machine. These tests run in this repo's Codespace, where .devcontainer/setup.sh installs it.
```

---

This repo is a starter for a Devin demo. See [DEVIN_DEMO.md](DEVIN_DEMO.md) for setup and the prompt.
