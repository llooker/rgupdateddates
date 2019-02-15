view: raw_data {
  sql_table_name: rob.updateddates ;;

  dimension_group: date {
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
    type: number
    sql: ${TABLE}.Sales ;;
  }


}
