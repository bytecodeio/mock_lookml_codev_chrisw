include: "/views/sdt_example.view.lkml"
view: cv_linked_filter_example {

  # parameter: Slist1 {
  #   allowed_value: {
  #     label: "A"
  #     value: "A"
  #   }
  #   allowed_value: {
  #     label: "B"
  #     value: "B"
  #   }
  # }

  filter: Slist1 {
    suggest_dimension: sdt_example.list1
  }
  filter: Slist2 {
    suggest_dimension: sdt_example.list2
  }


}
