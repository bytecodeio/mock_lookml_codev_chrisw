include: "/views/sdt_example_data.view.lkml"
include: "/views/sdt_example.view.lkml"

explore: linked_filter_demo {
  from: sdt_example_data

  join: sdt_example {
    type: inner
    relationship: many_to_many
    sql_on: ${linked_filter_demo.dim} = ${sdt_example.list2} ;;
  }
}
