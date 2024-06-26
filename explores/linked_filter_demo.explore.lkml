include: "/views/sdt_example_data.view.lkml"
include: "/views/sdt_example.view.lkml"
include: "/views/cv_linked_filter_example.view.lkml"

explore: linked_filter_demo {
  from: sdt_example_data
  # join: cv_linked_filter_example {
  #   type: inner
  #   relationship: one_to_one
  #   sql:  ;;
  # }

  join: sdt_example {
    type: inner
    relationship: many_to_many
    sql: ${linked_filter_demo.dim} = ${sdt_example.list2} ;;
  }
}
