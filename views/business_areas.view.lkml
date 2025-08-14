explore: business_areas {}
view: business_areas {
  derived_table: {
    sql:

      SELECT 1 AS business_area, 50000 AS items
      UNION ALL
      SELECT 1 AS business_area, 150000 AS items
      UNION ALL
      SELECT 2 AS business_area, 250000 AS items
      UNION ALL
      SELECT 2 AS business_area, 350000 AS items
      UNION ALL
      SELECT 3 AS business_area, 450000 AS items
      UNION ALL
      SELECT 3 AS business_area, 550000 AS items
      UNION ALL
      SELECT 4 AS business_area, 650000 AS items
      UNION ALL
      SELECT 4 AS business_area, 750000 AS items
      UNION ALL
      SELECT 5 AS business_area, 850000 AS items
      UNION ALL
      SELECT 5 AS business_area, 950000 AS items


      ;;
  }

  dimension: business_area {
    type: string
    sql: ${TABLE}.business_area ;;
    map_layer_name: business_areas
  }

  dimension: items {
    type: number
    sql: ${TABLE}.items ;;
  }

  measure: total_items {
    type: sum
    sql: ${items} ;;
  }

}
