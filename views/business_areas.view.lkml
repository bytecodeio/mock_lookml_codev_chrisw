explore: business_areas {}
view: business_areas {
  derived_table: {
    sql:

      SELECT 1 AS business_area, 104136 AS val
      UNION ALL
      SELECT 2 AS business_area, 62138 AS val
      UNION ALL
      SELECT 1 AS business_area, 31757 AS val
      UNION ALL
      SELECT 2 AS business_area, 30995 AS val
      UNION ALL
      SELECT 2 AS business_area, 30580 AS val
      UNION ALL
      SELECT 3 AS business_area, 29807 AS val

      ;;
  }

  dimension: business_area {
    type: string
    sql: ${TABLE}.business_area ;;
    map_layer_name: business_areas
  }

  dimension: value {
    type: number
    sql: ${TABLE}.val ;;
  }

  measure: totals {
    type: sum
    sql: ${value} ;;
  }

}
