view: ytd_derived {
  derived_table: {
    sql: SELECT
         Date,
         Sales,
         SUM(Sales) OVER (ORDER BY Date ASC rows unbounded preceding) as ytd_sales_raw
         FROM rob.updateddates
         WHERE
         EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM CURRENT_DATE())
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

 dimension: Join_Key_YTD_Derived {
  hidden: yes
  type: string
  sql: ${TABLE}.Date;;
}


  dimension: ytd_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.ytd_sales_raw ;;
  }

  measure: ytd_total_sales {
    group_label: "Sales Metrics"
    label: "YTD Sales"
    type: number
    sql: coalesce(max(${ytd_sales_raw}),0) ;;
    value_format_name: usd
  }

}
