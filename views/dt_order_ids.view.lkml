# If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"

view: dt_order_ids {
  derived_table: {
    explore_source: order_items {
      bind_all_filters: yes
      column: order_id {}
    }
  }
  dimension: order_id {
    description: ""
    type: number
  }
}
