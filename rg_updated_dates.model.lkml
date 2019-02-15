connection: "bigquery"

# include all the views
include: "*.view"

datagroup: rg_dates_example_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: rg_dates_example_default_datagroup

explore: raw_data {}


# explore: dates {
#   join: derived_table {
#     view_label: "Dates"
#     relationship: one_to_one
#     sql_on: ${dates.Join_Key} = ${derived_table.Join_Key} ;;
#   }
# }
