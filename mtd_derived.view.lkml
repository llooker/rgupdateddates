view: mtd_derived {
  derived_table: {
  sql: SELECT
           Date,
         Sales,
         SUM(Sales) OVER (PARTITION BY EXTRACT(MONTH FROM Date),EXTRACT(YEAR FROM Date) ORDER BY Date ASC rows unbounded preceding) as mtd_sales_raw
         FROM rob.updateddates

   ;;
   persist_for: "48 hours"
 }

  dimension: Join_Key_MTD_Derived {
    hidden: yes
    sql: ${TABLE}.Date;;
  }


  dimension: mtd_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.mtd_sales_raw ;;
  }

  measure: mtd_total_sales {
    group_label: "Sales Metrics"
    label: "MTD Sales"
    type: number
    sql: coalesce(max(${mtd_sales_raw}),0) ;;
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
