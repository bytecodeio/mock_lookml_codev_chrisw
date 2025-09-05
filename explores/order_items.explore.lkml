include: "/views/distribution_center.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/products.view.lkml"
include: "/views/users.view.lkml"
include: "/views/dt_order_ids.view.lkml"
include: "/views/dt_users.view.lkml"
include: "/views/dt_weeks.view.lkml"
include: "/views/dynamic_crossview.view.lkml"


explore: order_items {

  # access_filter: {
  #   field: users.state
  #   user_attribute: chrisw_state
  # }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: dt_order_ids {
    type: inner
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${dt_order_ids.order_id} ;;
  }

  # join: orders_2 {
  #   from: order_items
  #   relationship: one_to_many
  #   type: left_outer
  #   sql_on: ${dt_order_ids.order_id} = ${orders_2.order_id} ;;
  # }

  join: dt_weeks {
    type: left_outer
    relationship: many_to_one
    sql_on: SAFE_CAST(${order_items.created_week_month_start_date} AS STRING) = ${dt_weeks.week};;
  }

  join: dynamic_crossview {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
  }

  join: dt_users {
    type: inner
    relationship: many_to_many
    sql_on: ${order_items.user_id} = ${dt_users.user_id} ;;

  }

}
