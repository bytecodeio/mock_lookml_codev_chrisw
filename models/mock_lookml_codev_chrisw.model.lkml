connection: "looker_partner_demo"

include: "/explores/order_items.explore.lkml"

datagroup: mock_lookml_codev_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mock_lookml_codev_default_datagroup
