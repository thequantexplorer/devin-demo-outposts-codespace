// Invoice template. Build it with `python -m invoices.build`, which passes the
// invoice JSON path as `--input data=/invoices/data/<number>.json`.
#let inv = json(sys.inputs.at("data", default: "/invoices/data/INV-1001.json"))

#let money(cents) = {
  let dollars = calc.quo(cents, 100)
  let rest = calc.rem(cents, 100)
  "$" + str(dollars) + "." + (if rest < 10 { "0" } else { "" }) + str(rest)
}

// All amounts are whole cents (integers), so the totals are exact.
#let line-total(line) = line.qty * line.unit_cents
#let subtotal = inv.lines.map(line-total).sum()
#let tax = calc.quo(subtotal * inv.tax_rate_bp + 5000, 10000)
#let discount = calc.quo(subtotal * inv.discount_pct + 50, 100)
#let total = subtotal - discount + tax

#metadata((
  number: inv.number,
  subtotal: subtotal,
  discount: discount,
  tax: tax,
  total: total,
)) <totals>

#set page(paper: "us-letter", margin: 2cm)
#set text(size: 10pt)

#grid(columns: (1fr, auto),
  [#text(size: 18pt, weight: "bold")[Acme Field Supply] \ 1 Trailhead Road, Bend, OR],
  align(right)[#text(size: 14pt, weight: "bold")[Invoice #inv.number] \ #inv.date],
)

#v(1em)
*Bill to:* #inv.customer
#v(1em)

#table(
  columns: (auto, 1fr, auto, auto, auto),
  align: (left, left, right, right, right),
  [*SKU*], [*Item*], [*Qty*], [*Unit*], [*Amount*],
  ..inv.lines.map(l => (l.sku, l.description, str(l.qty), money(l.unit_cents), money(line-total(l)))).flatten(),
)

#align(right, table(
  columns: (auto, auto),
  stroke: none,
  align: (left, right),
  [Subtotal], money(subtotal),
  [Discount (#inv.discount_pct%)], [-#money(discount)],
  [Tax (#(inv.tax_rate_bp / 100)%)], money(tax),
  [*Total*], [*#money(total)*],
))
