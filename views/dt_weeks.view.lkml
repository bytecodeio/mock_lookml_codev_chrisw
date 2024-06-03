view: dt_weeks {
  derived_table: {
    datagroup_trigger: weekly
    sql:
      SELECT DISTINCT SAFE_CAST(DATE_TRUNC(dt,WEEK) AS STRING) AS week, CURRENT_TIME() AS check_int
      FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', CURRENT_DATE(), INTERVAL 1 DAY)) as DT
      ORDER BY 1 DESC
    ;;
  }

  dimension: week {}

  dimension: check_int {}
}
