view: dt_weeks {
  derived_table: {
    sql:
      SELECT SAFE_CAST(DATE_TRUNC(dt,WEEK) AS STRING) AS week
      FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', CURRENT_DATE(), INTERVAL 1 WEEK)) as DT
      ORDER BY 1 DESC
    ;;
  }
}