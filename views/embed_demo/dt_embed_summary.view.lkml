view: dt_embed_summary {
  derived_table: {
    explore_source: embed_demo {
      column: average_products_per_user { field: cv_embed_demo.average_products_per_user }
    }
  }
  dimension: average_products_per_user {
    description: ""
    type: number
  }
}
