view: last_qtd_derived {
  derived_table: {
      sql:

      SELECT
           Date,
           Sales,
           SUM(Sales) OVER (PARTITION BY DATE_TRUNC(date, quarter) ORDER BY Date ASC rows unbounded preceding) as last_qtd_sales_raw
           FROM rob.updateddates

           ;;
      persist_for: "48 hours"
    }

  dimension: Join_Key_LQTD_Raw {
    hidden: yes
    type: string
    sql:

    CASE WHEN ${month} = 10 OR ${month} = 11 OR ${month} = 12
    THEN
    concat(cast(${year}+1 as string),'-',cast(${month}-9 as string), '-', cast(${day} as string))
    ELSE
    concat(cast(${year} as string),'-',cast(${month}+3 as string), '-', cast(${day} as string))
    END
  ;;

    }

  measure: last_qtd_total_sales {
    group_label: "Previous Sales Metrics"
    label: "Last QTD Sales"
    type: number
    sql: coalesce(max(${last_qtd_sales_raw}),0) ;;
    value_format_name: usd
  }


  dimension: last_qtd_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.last_qtd_sales_raw ;;
  }




  dimension: year {
    hidden: yes
    type: number
    sql: EXTRACT(YEAR FROM ${TABLE}.Date) ;;
  }


  dimension: quarter {
    hidden: yes
    type: number
    sql: EXTRACT(QUARTER FROM ${TABLE}.Date) ;;
  }

  dimension: month {
    hidden: yes
    type: number
    sql: EXTRACT(MONTH FROM ${TABLE}.Date) ;;
  }

  dimension: day {
    hidden: yes
    type: number
    sql: EXTRACT(DAY FROM ${TABLE}.Date) ;;
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
