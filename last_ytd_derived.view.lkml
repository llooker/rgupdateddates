view: last_ytd_derived {
    derived_table: {
      sql: SELECT
           Date,
           Sales,
           SUM(Sales) OVER (ORDER BY Date ASC rows unbounded preceding) as last_ytd_sales_raw
           FROM rob.updateddates
           WHERE

            CASE WHEN
            (EXTRACT(MONTH FROM Date) = EXTRACT(MONTH FROM CURRENT_DATE())
            AND
            EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)))

            THEN EXTRACT(DAY FROM Date) <= EXTRACT(DAY FROM CURRENT_DATE())

            WHEN
            (EXTRACT(MONTH FROM Date) < EXTRACT(MONTH FROM CURRENT_DATE())
            AND
            EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)))

            THEN  EXTRACT(YEAR FROM Date) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))


            END
           GROUP BY Date, Sales
           ;;
      persist_for: "48 hours"
    }

    dimension_group: date {
      #hidden: yes
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

    dimension: Join_Key_Raw {
      sql: DATE_ADD(${TABLE}.Date, INTERVAL 1 YEAR);;
    }


    dimension: last_ytd_sales_raw {
      hidden: yes
      type: number
      sql: ${TABLE}.last_ytd_sales_raw ;;
    }

    measure: last_mtd_total_sales {
      group_label: "Previous Sales Metrics"
      label: "Last YTD Sales"
      type: number
      sql: coalesce(max(${last_ytd_sales_raw}),0) ;;
      value_format_name: usd
    }

  }
