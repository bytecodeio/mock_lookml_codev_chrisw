include: "/views/products.view.lkml"
include: "/views/users.view.lkml"
view: cv_embed_demo {
  measure: total_products {
    type: count
  }
  measure: total_users {
    type: count_distinct
    sql: ${users.id} ;;
  }

  measure: average_products_per_user {
    type: number
    sql: SAFE_DIVIDE(${total_products},${total_users}) ;;
  }
}
