explore: custom_data_2 {}
view: custom_data_2 {
  derived_table: {
    sql:
        SELECT 'X' AS id, 1000 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 1000 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 89 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 5 AS val, 68996611 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 3400 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 12 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 13 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'X' AS id, 1500 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'Y' AS id, 6 AS val, 6999000 AS previous_val
        UNION ALL
        SELECT 'Z' AS id, 18 AS val, 11 AS previous_val
    ;;
  }
  dimension: id {}
  dimension: val {}
  dimension: previous_val {}
  measure: delta {
    type: number
    sql: (SAFE_DIVIDE(${val},${previous_val})) ;;
    value_format_name: percent_2
  }

}
