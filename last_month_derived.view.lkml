view: last_month_derived {
  derived_table: {
    sql: SELECT
          EXTRACT(MONTH FROM Date) AS Month,
          EXTRACT(YEAR FROM Date) AS Year,
           SUM(Sales)  as last_month_sales_raw
           FROM rob.updateddates
           GROUP BY Year,Month
           ;;
    persist_for: "48 hours"
  }

dimension: month {
  hidden: yes
  type: number
  sql: ${TABLE}.Month ;;
}

  dimension: year {
    hidden: yes
    type: number
    sql: ${TABLE}.Year ;;
  }


  dimension: Join_Key_Last_Month_Derived {
    hidden: yes
    type: string
    sql: CASE WHEN ${month} = 12 THEN concat(cast(${year}+1 as string),cast(${month}-11 as string))
    WHEN ${month} < 12 THEN concat(cast(${year} as string),cast(${month}+1 as string)) END;;

  }

  dimension: last_month_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.last_month_sales_raw ;;
  }

  measure: last_month_total_sales {
    group_label: "Previous Sales Metrics"
    label: "Last Month Sales"
    type: number
    sql: coalesce(max(${last_month_sales_raw}),0) ;;
    value_format_name: usd
  }

}
