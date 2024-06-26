view: sdt_example {
  derived_table: {
    sql:

      SELECT 'A' AS list1, 'X' AS list2
      UNION ALL
      SELECT 'A' AS list1, 'Y' AS list2
      UNION ALL
      SELECT 'A' AS list1, 'Z' AS list2
      UNION ALL
      SELECT 'B' AS list1, 'L' AS list2
      UNION ALL
      SELECT 'B' AS list1, 'M' AS list2
      UNION ALL
      SELECT 'B' AS list1, 'N' AS list2
    ;;
  }

  dimension: list1 {
    type: string
  }

  dimension: list2 {
    type: string
  }

}
