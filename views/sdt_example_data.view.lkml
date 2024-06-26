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
        UNION ALL
        SELECT 'Z' AS dim, 120 AS val
        UNION ALL
        SELECT 'Y' AS dim, 1000 AS val
    ;;
  }

  dimension: pk {
    type: string
    primary_key: yes
    sql: GENERATE_UUID() ;;
  }

  dimension: dim {
    type: string
  }
  dimension: val {}
  measure: total_val {
    type: sum
    sql: ${val} ;;
  }
}
