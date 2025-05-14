explore: custom_data {}
view: custom_data {
  derived_table: {
    sql:
        SELECT 'A' AS id, 1000 AS val, 11 AS previous_val, '2025-04-24' AS d
        UNION ALL
        SELECT 'B' AS id, 1000 AS val, 11 AS previous_val, '2025-04-25' AS d
        UNION ALL
        SELECT 'C' AS id, 89 AS val, 11 AS previous_val, '2025-04-26' AS d
        UNION ALL
        SELECT 'D' AS id, 5 AS val, 68996611 AS previous_val, '2025-04-27' AS d
        UNION ALL
        SELECT 'E' AS id, 3400 AS val, 11 AS previous_val, '2025-04-28' AS d
        UNION ALL
        SELECT 'F' AS id, 12 AS val, 11 AS previous_val, '2025-04-29' AS d
        UNION ALL
        SELECT 'G' AS id, 13 AS val, 11 AS previous_val, '2025-04-30' AS d
        UNION ALL
        SELECT 'H' AS id, 1500 AS val, 11 AS previous_val, '2025-05-02' AS d
        UNION ALL
        SELECT 'I' AS id, 6 AS val, 6999000 AS previous_val, '2025-05-01' AS d
        UNION ALL
        SELECT 'J' AS id, 18 AS val, 11 AS previous_val, '2025-05-05' AS d
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
  dimension: d {
    type: date
  }

}
