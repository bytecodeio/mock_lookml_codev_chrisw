view: dt_users {
  derived_table: {
    # persist_for: "20 hour"
    explore_source: order_items {
      column: user_id {field: order_items.user_id}
    }
  }
  dimension: user_id {}
}
