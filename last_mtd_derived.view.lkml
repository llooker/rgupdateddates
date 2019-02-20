view: last_mtd_derived {
    derived_table: {
      sql: SELECT
           Date,
         Sales,
         SUM(Sales) OVER (PARTITION BY EXTRACT(MONTH FROM Date),EXTRACT(YEAR FROM Date) ORDER BY Date ASC rows unbounded preceding) as last_mtd_sales_raw
         FROM rob.updateddates
           ;;
      persist_for: "48 hours"
    }

  dimension: Join_Key_LMTD_Raw {
    hidden: yes
    sql: DATE_ADD(${TABLE}.Date, INTERVAL 1 MONTH);;
  }


  dimension: last_mtd_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.last_mtd_sales_raw ;;
  }

  measure: last_mtd_total_sales {
    group_label: "Previous Sales Metrics"
    label: "Last MTD Sales"
    type: number
    sql: coalesce(max(${last_mtd_sales_raw}),0) ;;
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
