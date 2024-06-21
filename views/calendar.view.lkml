view: calendar {
  view_label: "Calendar"
  derived_table: {
    sql: SELECT
            date,
         FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', CURRENT_DATE(), INTERVAL 1 DAY)) AS date
         ORDER BY date   ;;
  }

  dimension_group: cal {
    label: "Calendar"
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
    datatype: date
    convert_tz: no
  }

}
