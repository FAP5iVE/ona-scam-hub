# Drill: normalise a messy report sheet to 3NF (23 Nov 2026)

Source sheet (all numbers fake):

| report_id | reporter | reporter_phone | number_reported | tags | carrier | carrier_country |
|---|---|---|---|---|---|---|
| 1 | Thoko | 0999000001 | 0888000111 | fake prize, impersonation | Airtel | Malawi |
| 2 | Thoko | 0999000001 | 0888000222 | fake job | Airtel | Malawi |
| 3 | Banda | 0999000002 | 0888000111 | fake prize | Airtel | Malawi |

## Prediction (before building)
Six tables: reporters, carriers, reported_numbers, reports, tags, report_tags.

## Result
- reporters: reporter_id, reporter_name, reporter_phone (UNIQUE reporter_phone)
- reported_numbers: reported_number_id, phone_number (UNIQUE phone_number)
- reports: report_id, reporter_id, reported_number_id
  (UNIQUE reporter_id + reported_number_id: the independence rule, §3.3)
- tags: tag_id, tag_name (UNIQUE)
- report_tags: report_id, tag_id (composite key)
- carrier_prefixes: prefix (UNIQUE), carrier_id
- carriers: carrier_id, carrier_name, carrier_country

## Corrections after review
- carrier was first placed on reported_numbers as carrier_id. That is a stored
  copy of a derived fact (number -> prefix -> carrier) and can drift. Moved to
  carrier_prefixes. Prefix values are examples only and UNVERIFIED.
- 1NF: tags string -> tags + report_tags (one atomic value per cell).
- 2NF: holds automatically while the key is one column (report_id). It matters
  only with a composite key and a column depending on part of it. report_tags
  has no non-key columns, so there is nothing to test.
- 3NF: report_id -> reporter -> reporter_phone is a TRANSITIVE dependency, so
  reporter_phone moves to reporters. carrier_country depends on carrier, so it
  moves to carriers.
- Normalising is not enough: the UNIQUE constraints above stop duplicates
  coming back.

## Open
- Plain UNIQUE (reporter, number) conflicts with "fresh cycle after delist"
  and with retracted reports. Revisit with the status-model note (Week 6).
- Mobile number portability would make "carrier from prefix" wrong. Check later.