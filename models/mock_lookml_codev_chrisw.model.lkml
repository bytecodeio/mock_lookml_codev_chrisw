connection: "looker_partner_demo"

include: "/views/distribution_center.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/products.view.lkml"
include: "/views/users.view.lkml"

include: "/explores/order_items.explore.lkml"

datagroup: mock_lookml_codev_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mock_lookml_codev_default_datagroup
