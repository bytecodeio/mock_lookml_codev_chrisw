explore: custom_data {}
view: custom_data {
  derived_table: {
    sql:
        SELECT 'A' AS id, 1000 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'B' AS id, 1000 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'C' AS id, 89 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'D' AS id, 50 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'E' AS id, 3400 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'F' AS id, 12 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'G' AS id, 13 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'H' AS id, 1500 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'I' AS id, 66 AS val, 11 AS previous_val
        UNION ALL
        SELECT 'J' AS id, 18 AS val, 11 AS previous_val
    ;;
  }
  dimension: id {}
  dimension: val {}
  dimension: previous_val {}
  measure: delta {
    type: number
    sql: 1 - SAFE_DIVIDE(${val},${previous_val}) ;;
    value_format_name: percent_2
  }

}
