view: ytd_derived {
  derived_table: {
    sql:
        SELECT
         Date,
         EXTRACT(YEAR FROM Date),
         Sales,
         SUM(Sales) OVER (PARTITION BY EXTRACT(YEAR FROM Date) ORDER BY Date ASC rows unbounded preceding) as ytd_sales_raw
         FROM rob.updateddates
         ;;
    persist_for: "48 hours"
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
