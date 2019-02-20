view: qtd_derived {
  derived_table: {
    sql:
           SELECT
           Date,
           Sales,
           SUM(Sales) OVER (PARTITION BY DATE_TRUNC(date, quarter) ORDER BY Date ASC rows unbounded preceding) as qtd_sales_raw
           FROM rob.updateddates
          ;;
    persist_for: "48 hours"
  }

  dimension: Join_Key_QTD_Derived {
    hidden: yes
    type: string
    sql: ${TABLE}.Date;;
  }


  dimension: qtd_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.qtd_sales_raw ;;
  }

  measure: qtd_total_sales {
    group_label: "Sales Metrics"
    label: "QTD Sales"
    type: number
    sql: coalesce(max(${qtd_sales_raw}),0) ;;
    value_format_name: usd
  }


  dimension_group: date {
    hidden: yes
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


}
