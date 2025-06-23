# Vendor Payment Analysis Report (ABAP)

This ABAP classical report analyzes vendor payment performance from a custom table `ZVEN_PAYMENTS`.

## 📌 Features
- Selection screen to input invoice date range
- Calculates:
  - Average payment delay per vendor
  - Percentage of on-time payments
  - Status classification (`Good`, `Moderate`, `At Risk`)
- Outputs a detailed report

## 📋 Table: ZVEN_PAYMENTS

| Field         | Description           |
|---------------|------------------------|
| VENDOR_ID     | Vendor Code           |
| VENDOR_NAME   | Vendor Name           |
| INVOICE_DATE  | Date of Invoice       |
| DUE_DATE      | Due Date              |
| PAYMENT_DATE  | Actual Payment Date   |
| AMOUNT        | Payment Amount        |
| CURRENCY_KEY  | Currency              |

## 🛠 Technologies Used
- SAP ABAP
- Classical Report
- Custom Transparent Table

## 🖼 Screenshots
See the `/screenshots` folder for report, output, and table design visuals.

## ✍️ Author
Manjusree Devarinti  
Certified SAP ABAP Developer | Aspiring SAP Labs Engineer

## 🚀 Note
Currently exploring CDS Views and RAP model for next-gen SAP development.

---

✅ Ideal for showcasing classical report development and analytical logic in interviews or portfolios.
