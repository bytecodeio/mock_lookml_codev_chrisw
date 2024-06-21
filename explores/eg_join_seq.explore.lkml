include: "/views/calendar.view.lkml"

explore: eg_join_seq {
  from: calendar

  # join: c {
  #   view_label: "C"
  #   from: calendar
  #   type: left_outer
  #   relationship: one_to_one
  #   sql_on: ${eg_join_seq.cal_date} = ${c.cal_date} ;;
  # }

  join: a {
    view_label: "A"
    from: calendar
    type: left_outer
    relationship: one_to_one
    sql_on: ${eg_join_seq.cal_date} = ${a.cal_date} ;;
  }

  join: b {
    view_label: "B"
    from: calendar
    type: inner
    relationship: one_to_one
    sql_on: ${eg_join_seq.cal_date} = ${b.cal_date} ;;
  }

  join: c {
    view_label: "C"
    from: calendar
    type: left_outer
    relationship: one_to_one
    sql_on: ${eg_join_seq.cal_date} = ${c.cal_date} ;;
  }

  fields: [eg_join_seq.cal_date,a.cal_date,b.cal_date,c.cal_date]

}
