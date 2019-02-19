view: last_year_derived {
    derived_table: {
      sql: SELECT
          EXTRACT(YEAR FROM Date) AS Year,
           SUM(Sales)  as last_year_sales_raw
           FROM rob.updateddates
           GROUP BY Year
           ;;
      persist_for: "48 hours"
    }

    dimension: year {
      type: number
      sql: ${TABLE}.Year ;;
    }


    dimension: Join_Key_LY_Raw {
      hidden: yes
      type: string
      sql: Concat(cast(${year}-1 as string));;

    }

##concat(cast(${year} as string),cast(${month} as string)) ELSE END;;

    dimension: last_year_sales_raw {
      hidden: yes
      type: number
      sql: ${TABLE}.last_year_sales_raw ;;
    }

    measure: last_year_total_sales {
      group_label: "Previous Sales Metrics"
      label: "Last Year Sales"
      type: number
      sql: coalesce(max(${last_year_sales_raw}),0) ;;
      value_format_name: usd
    }

  }
