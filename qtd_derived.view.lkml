view: qtd_derived {
  derived_table: {
    sql: SELECT
         Date,
         Sales,
         SUM(Sales) OVER (ORDER BY Date ASC rows unbounded preceding) as qtd_sales_raw
         FROM rob.updateddates
         WHERE
        EXTRACT(QUARTER FROM Date) = EXTRACT(QUARTER FROM CURRENT_DATE())
         AND EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM CURRENT_DATE())
         GROUP BY Date, Sales
         ;;
    persist_for: "48 hours"
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

}
