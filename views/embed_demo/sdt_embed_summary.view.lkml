view: sdt_embed_summary {
  derived_table: {
    sql:

    SELECT SAFE_DIVIDE(COUNT(*), COUNT(DISTINCT users.id )) AS average_products_per_user
    FROM `thelook.order_items`  AS embed_demo
    LEFT JOIN `thelook.users`  AS users ON embed_demo.user_id = users.id

    ;;
  }

  dimension: average_products_per_user {
    type: number
  }

}
