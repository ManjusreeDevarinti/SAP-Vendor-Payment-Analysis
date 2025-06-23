REPORT ZVENDOR_PAYMENT_REPORT.
TABLES: ZVEN_PAYMENTS.

TYPES: BEGIN OF ty_vendor,
  vendor_id      TYPE zven_payments-vendor_id,
  vendor_name    TYPE zven_payments-vendor_name,
  total_payments TYPE i,
  total_delay    TYPE i,
  on_time_count  TYPE i,
  avg_delay      TYPE p DECIMALS 1,
  on_time_pct    TYPE p DECIMALS 1,
  status         TYPE char20,
END OF ty_vendor.

DATA: it_data    TYPE TABLE OF zven_payments,
      wa_data    TYPE zven_payments,
      it_report  TYPE TABLE OF ty_vendor,
      wa_report  TYPE ty_vendor.

DATA: lt_vendors TYPE SORTED TABLE OF zven_payments-vendor_id
                 WITH UNIQUE KEY table_line.

DATA: v_from TYPE sy-datum,
      v_to   TYPE sy-datum.

SELECTION-SCREEN BEGIN OF BLOCK blk1 WITH FRAME TITLE text-001.
PARAMETERS: p_from TYPE sy-datum OBLIGATORY,
            p_to   TYPE sy-datum OBLIGATORY.
SELECTION-SCREEN END OF BLOCK blk1.

START-OF-SELECTION.

SELECT * FROM zven_payments INTO TABLE it_data
  WHERE invoice_date BETWEEN p_from AND p_to.

IF sy-subrc <> 0.
  WRITE: / 'No records found for the selected period.'.
  EXIT.
ENDIF.

LOOP AT it_data INTO wa_data.
  INSERT wa_data-vendor_id INTO TABLE lt_vendors.
ENDLOOP.

LOOP AT lt_vendors INTO DATA(lv_vendor).
  CLEAR: wa_report.
  DATA: lv_total_delay TYPE i VALUE 0,
        lv_on_time     TYPE i VALUE 0,
        lv_total       TYPE i VALUE 0.

  LOOP AT it_data INTO wa_data WHERE vendor_id = lv_vendor.
    DATA(lv_delay) = wa_data-payment_date - wa_data-due_date.
    IF lv_delay < 0.
      lv_delay = 0.
    ENDIF.

    lv_total_delay = lv_total_delay + lv_delay.
    lv_total = lv_total + 1.

    IF lv_delay = 0.
      lv_on_time = lv_on_time + 1.
    ENDIF.

    wa_report-vendor_id = wa_data-vendor_id.
    wa_report-vendor_name = wa_data-vendor_name.
  ENDLOOP.

  IF lv_total > 0.
    wa_report-total_payments = lv_total.
    wa_report-total_delay = lv_total_delay.
    wa_report-avg_delay = lv_total_delay / lv_total.
    wa_report-on_time_count = lv_on_time.
    wa_report-on_time_pct = ( lv_on_time * 100 ) / lv_total.

    IF wa_report-avg_delay <= 2 AND wa_report-on_time_pct >= 75.
      wa_report-status = 'Good'.
    ELSEIF wa_report-avg_delay <= 5 AND wa_report-on_time_pct >= 50.
      wa_report-status = 'Moderate'.
    ELSE.
      wa_report-status = 'At Risk'.
    ENDIF.

    APPEND wa_report TO it_report.
  ENDIF.
ENDLOOP.

ULINE.
WRITE: / 'Vendor', 15 'Name', 45 'Payments', 55 'Avg Delay', 65 'On-Time %', 75 'Status'.
ULINE.

LOOP AT it_report INTO wa_report.
  WRITE: / wa_report-vendor_id,
           15 wa_report-vendor_name,
           45 wa_report-total_payments,
           55 wa_report-avg_delay,
           65 wa_report-on_time_pct,
           75 wa_report-status.
ENDLOOP.