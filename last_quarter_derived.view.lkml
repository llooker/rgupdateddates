view: last_quarter_derived {
    derived_table: {
      sql: SELECT
          EXTRACT(QUARTER FROM Date) AS Quarter,
          EXTRACT(YEAR FROM Date) AS Year,
           SUM(Sales)  as last_quarter_sales_raw
           FROM rob.updateddates
           GROUP BY Year,Quarter
           ;;
      persist_for: "48 hours"
    }

  dimension: Join_Key_LQ_Raw {
    hidden: yes
    type: string
    sql: CASE WHEN ${quarter} < 4 THEN concat(cast(${year} as string),cast(${quarter}+1 as string))
      WHEN ${quarter} = 4 THEN concat(cast(${year}+1 as string),cast(${quarter}-3 as string)) END;;

  }

  dimension: last_quarter_sales_raw {
    hidden: yes
    type: number
    sql: ${TABLE}.last_quarter_sales_raw ;;
  }

  measure: last_quarter_total_sales {
    group_label: "Previous Sales Metrics"
    label: "Last Quarter Sales"
    type: number
    sql: coalesce(max(${last_quarter_sales_raw}),0) ;;
    value_format_name: usd
  }


  dimension: year {
    hidden: yes
    type: number
    sql: ${TABLE}.Year ;;
  }


    dimension: quarter {
      hidden: yes
      type: number
      sql: ${TABLE}.Quarter ;;
    }




  }
