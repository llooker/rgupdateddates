view: last_qtd_derived {
  derived_table: {
      sql: SELECT
           Date,
           Sales,
           SUM(Sales) OVER (ORDER BY Date ASC rows unbounded preceding) as last_qtd_sales_raw
           FROM rob.updateddates
           WHERE

            CASE WHEN
            (EXTRACT(QUARTER FROM Date) = EXTRACT(QUARTER FROM CURRENT_DATE())
            AND
            EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)))

            THEN EXTRACT(QUARTER FROM Date) <= EXTRACT(QUARTER FROM CURRENT_DATE())

            WHEN
            (EXTRACT(MONTH FROM Date) < EXTRACT(MONTH FROM CURRENT_DATE())
            AND
            EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)))

            THEN  EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))


            END
           GROUP BY Date, Sales
           ;;
      persist_for: "48 hours"
    }

  dimension_group: date {
    #hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Date ;;
  }

  dimension: Join_Key_Raw {
    hidden: yes
    sql: ${TABLE}.Date;;
  }


  dimension: last_qtd_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.last_qtd_sales_raw ;;
  }

  measure: last_qtd_total_sales {
    group_label: "Previous Sales Metrics"
    label: "Last QTD Sales"
    type: number
    sql: coalesce(max(${last_qtd_sales_raw}),0) ;;
    value_format_name: usd
  }

}
