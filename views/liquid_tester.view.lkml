view: liquid_tester {
  derived_table: {
    sql:
      SELECT "" AS liquid_testing
    ;;
  }

  dimension: liquid_testing {
    type: string
    sql: ${TABLE}.liquid_testing ;;
    html:

        {% assign myvariable = 'tomato' %}
        {{ myvariable | upcase }}

    ;;
  }
}
