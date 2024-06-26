include: "/explores/order_items.explore.lkml"
include: "/views/order_items.view.lkml"
include: "/views/users.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/products.view.lkml"
include: "/views/distribution_center.view.lkml"
include: "/views/embed_demo/dt_user_products.view.lkml"
include: "/views/embed_demo/dt_embed_summary.view.lkml"
include: "/views/embed_demo/cv_embed_demo.view.lkml"
include: "/views/embed_demo/sdt_embed_summary.view.lkml"

explore: embed_demo {
  from: order_items
  access_filter: {
    field: users.id
    user_attribute: chrisw_user_id
  }

  join: users {
    type: left_outer
    sql_on: ${embed_demo.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${embed_demo.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${embed_demo.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    from: distribution_centers
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: dt_user_products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${dt_user_products.id}  ;;
  }

  join: dt_embed_summary {
    type: cross
    relationship: many_to_one
    sql_on: 1=1 ;;
  }

  join: cv_embed_demo {
    type: inner
    relationship: one_to_one
    sql:  ;;
  }

  join: sdt_embed_summary {
    type: cross
    relationship: many_to_one
    sql_on: 1=1 ;;
  }


}
