view: raw_data {
  sql_table_name: rob.updateddates ;;

  dimension_group: Finance {
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

  dimension: sales {
    hidden: yes
    type: number
    sql: ${TABLE}.Sales ;;
  }

  measure: total_sales {
    group_label: "Sales Metrics"
    type: sum
    value_format_name: usd
    sql: ${sales} ;;
  }

   measure: month_to_date_sales_raw {
    type: sum
    value_format_name: usd
    sql: ${sales} ;;
    filters: {
      field: raw_data.is_before_mtd
      value: "yes"
    }
   }

  measure: month_to_date_sales {
    direction: "column"
    type: running_total
    sql: ${month_to_date_sales_raw} ;;
    value_format_name: usd
  }

dimension: testdate {
  type: date
  #type: yesno
  sql: EXTRACT(DAY FROM ${TABLE}.Date) < EXTRACT(DAY FROM CURRENT_DATE()) ;;
}

  dimension: testmonth {
    type: date
    #type: yesno
    sql: EXTRACT(MONTH FROM ${TABLE}.Date) < EXTRACT(MONTH FROM CURRENT_DATE()) ;;
  }

  dimension: testyear {
    type: date
    #type: yesno
    sql: EXTRACT(YEAR FROM ${TABLE}.Date) < EXTRACT(YEAR FROM CURRENT_DATE()) ;;
  }

  dimension: is_before_mtd {
  type: yesno
   sql:EXTRACT(DAY FROM ${TABLE}.Date) <= EXTRACT(DAY FROM CURRENT_DATE())
  AND EXTRACT(MONTH FROM ${TABLE}.Date) = EXTRACT(MONTH FROM CURRENT_DATE())
  AND EXTRACT(YEAR FROM ${TABLE}.Date) = EXTRACT(YEAR FROM CURRENT_DATE());;
  }

}
