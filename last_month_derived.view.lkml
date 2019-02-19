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
  type: number
  sql: ${TABLE}.Month ;;
}

  dimension: year {
    type: number
    sql: ${TABLE}.Year ;;
  }


  dimension: Join_Key_Raw {
    #hidden: yes
    type: string
    sql: CASE WHEN ${month} > 1 THEN concat(cast(${year} as string),cast(${month}-1 as string))
    WHEN ${month} = 1 THEN concat(cast(${year}-1 as string),cast(${month}+11 as string)) END;;

  }

##concat(cast(${year} as string),cast(${month} as string)) ELSE END;;

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
