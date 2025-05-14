connection: "looker_partner_demo"

include: "/explores/order_items.explore.lkml"
include: "/views/dt_weeks.view.lkml"
include: "/explores/eg_join_seq.explore.lkml"
include: "/explores/embed_demo.explore.lkml"
include: "/explores/linked_filter_demo.explore.lkml"
include: "/explores/liquid_testing.explore.lkml"

datagroup: mock_lookml_codev_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mock_lookml_codev_default_datagroup

# include: "/views/filter_test.view.lkml"
# explore: filter_test {}
explore: dt_weeks {}


datagroup: weekly {
  sql_trigger:
      SELECT MAX(DATE_TRUNC(dt,WEEK)) AS week
      FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', CURRENT_DATE(), INTERVAL 1 DAY)) as DT
  ;;
}

datagroup: daily_6am_datagroup {
  sql_trigger:
    -- updates once per day at a 6AM ET
    -- note the hour (6) in the calculation 60*60*6
    SELECT FLOOR(((TIMESTAMPDIFF(SECOND,CURRENT_TIMESTAMP(),'1970-01-01 00:00:00')) - 60*60*10)/(60*60*24)) ;;
}

datagroup: chris_w_never {
  sql_trigger: SELECT 0 ;;
}

access_grant: limited_access {
  allowed_values: [ "ltd", "all" ]
  user_attribute: chrisw_test_access_level
}

include: "/views/custom_data_2.view.lkml"
