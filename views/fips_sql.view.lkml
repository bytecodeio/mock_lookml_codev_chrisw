explore: zipcode_test {}
view: zipcode_test {
  derived_table: {
    sql:

      SELECT '51700' AS fips, 104136 AS val, 'ME' AS state
      UNION ALL
      SELECT '51177' AS fips, 62138 AS val, 'ME' AS state
      UNION ALL
      SELECT '06013' AS fips, 31757 AS val, 'ME' AS state
      UNION ALL
      SELECT '08041' AS fips, 30995 AS val, 'GA' AS state
      UNION ALL
      SELECT '39141' AS fips, 30580 AS val, 'MA' AS state
      UNION ALL
      SELECT '31055' AS fips, 29807 AS val, 'NY' AS state

      ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.fips ;;
    map_layer_name: custom_counties
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  measure: val {
    type: number
    sql: SUM(${TABLE}.val) ;;
  }

}
