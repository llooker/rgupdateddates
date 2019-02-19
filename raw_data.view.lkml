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

  dimension: month {
    hidden: yes
    type: string
    sql: EXTRACT(MONTH FROM ${TABLE}.Date) ;;
  }

  dimension: year {
    hidden: yes
    type: string
    sql: EXTRACT(YEAR FROM ${TABLE}.Date) ;;
  }

  dimension: quarter {
    hidden: yes
    type: string
      sql: EXTRACT(QUARTER FROM ${TABLE}.Date) ;;

  }

  dimension: day {
    hidden: yes
    type: string
    sql: EXTRACT(DAY FROM ${TABLE}.Date) ;;
  }

  dimension: Join_Key_MTD_Derived {
    hidden: yes
    type: string
    sql: ${TABLE}.Date;;
  }

  dimension: Join_Key_QTD_Derived {
    hidden: yes
    type: string
    sql: ${TABLE}.Date;;
  }

  dimension: Join_Key_YTD_Derived {
    hidden: yes
    type: string
    sql: ${TABLE}.Date;;
  }

  dimension: Join_Key_Last_Month_Derived {
    hidden: yes
    type: string
    sql: Concat(cast(${year} as string),cast(${month} as string));;
  }

  dimension: Join_Key_LMTD_Raw {
    hidden: yes
    sql: ${TABLE}.Date;;
  }

  dimension: Join_Key_LQTD_Raw {
    hidden: yes
    type: string
    sql:
    concat(cast(${year} as string),'-',cast(${month} as string), '-', cast(${day} as string));;

  }


  dimension: Join_Key_LQTD_TEST {
    hidden: yes
    type: string
     sql: concat(cast(${year}+1 as string),'-',cast(${month}-9 as string)), '-', cast(${day} as string));;


  }


  dimension: Join_Key_LQ_Raw {
    hidden: yes
    type: string
    sql: concat(cast(${year} as string),cast(${quarter} as string));;

  }

  dimension: Join_Key_LY_Raw {
    hidden: yes
    type: string
    sql: Concat(cast(${year} as string));;

  }

  dimension: Join_Key_LYTD_Raw {
    hidden: yes
    sql: ${TABLE}.Date;;
  }

  dimension: sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.Sales ;;
  }

  measure: sales {
    group_label: "Sales Metrics"
    type: sum
    value_format_name: usd
    sql: ${sales_raw} ;;
  }
}
