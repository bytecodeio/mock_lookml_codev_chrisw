view: sdt_example_data {
  derived_table: {
    sql:

        SELECT 'L' AS dim, 100 AS val
        UNION ALL
        SELECT 'M' AS dim, 200 AS val
        UNION ALL
        SELECT 'N' AS dim, 300 AS val
        UNION ALL
        SELECT 'L' AS dim, 250 AS val
        UNION ALL
        SELECT 'M' AS dim, 425 AS val
        UNION ALL
        SELECT 'N' AS dim, 100 AS val
    ;;
  }

  dimension: dim {}
  dimension: val {}
  measure: total_val {
    type: sum
    sql: ${val} ;;
  }
}
