view: dt_user_products {
  derived_table: {
    explore_source: embed_demo {
      column: id { field: users.id }
      column: products {}
    }
  }
  dimension: id {
    primary_key: yes
    description: ""
    type: number
  }
  dimension: products {
    description: ""
    type: number
  }

  measure: total_products {
    type: sum
    sql: ${products} ;;
  }

  measure: total_users {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: average_products {
    type: number
    sql: SAFE_DIVIDE(${total_products},${total_users}) ;;
  }

}
