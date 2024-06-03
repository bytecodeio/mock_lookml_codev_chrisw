view: dynamic_crossview {

# dynamic dimension 01 {

  parameter: dd_s_01 {
    group_label: "1. Dynamic Parameters"
    label: "Primary Dimension"
    type: unquoted
    default_value: "None"

    allowed_value: {
      label: "None"
      value: "none"
    }

    allowed_value: {
      label: "User Selects Dimension 1"
      value: "dimension_1"
    }

    allowed_value: {
      label: "User Selects Dimension 2"
      value: "dimension_2"
    }

  }

  dimension: dd_d_01 {
    group_label: "1. Dynamic"
    label: "Primary Dimension"
    type: string
    label_from_parameter: dd_s_01
    sql: {% if dd_s_01._parameter_value == 'dimension_1' %}
        ${users.state}
        {% elsif dd_s_01._parameter_value == 'dimension_2' %}
        ${users.gender}
        {% else %}
        '-'
        {% endif %}
        ;;
    order_by_field: dd_sort_01
  }

  dimension: dd_sort_01 {
    group_label: "1. Dynamic"
    type: number
    sql:
      {% if dd_s_01._parameter_value == 'dimension_1' %}
      ${dd_d_01}
      {% elsif dd_s_01._parameter_value == 'dimension_2' %}
      CASE WHEN ${dd_d_01} = 'January' THEN 1
        WHEN ${dd_d_01} = 'February' THEN 2
        WHEN ${dd_d_01} = 'March' THEN 3
        WHEN ${dd_d_01} = 'April' THEN 4
        WHEN ${dd_d_01} = 'May' THEN 5
        WHEN ${dd_d_01} = 'June' THEN 6
        WHEN ${dd_d_01} = 'July' THEN 7
        WHEN ${dd_d_01} = 'August' THEN 8
        WHEN ${dd_d_01} = 'September' THEN 9
        WHEN ${dd_d_01} = 'October' THEN 10
        WHEN ${dd_d_01} = 'November' THEN 11
        WHEN ${dd_d_01} = 'December' THEN 12
      END
      {% else %}
      concat(${dd_d_01},"")
      {% endif %}
      ;;
  }

# }

# dynamic measure 01 {

  parameter: dm_s_01 {
    group_label: "1. Dynamic Parameters"
    label: "Primary Measure"
    type: unquoted
    default_value: "None"

    allowed_value: {
      label: "None"
      value: "none"
    }

    allowed_value: {
      label: "User Selects Measure 1"
      value: "measure_1"
    }

    allowed_value: {
      label: "User Selects Measure 2"
      value: "measure_2"
    }
  }

  measure: dm_d_01 {
    group_label: "1. Dynamic"
    label: "Primary Measure"
    value_format_name: "decimal_0"
    type: number
    label_from_parameter: dm_s_01
    sql: {% if dm_s_01._parameter_value == 'measure_1' %}
        ${users.count}
        {% elsif dm_s_01._parameter_value == 'measure_2' %}
        ${users.average_age}
        {% else %}
        0
        {% endif %}
        ;;
  }

# }

# dynamic dimension 02 {

  parameter: dd_s_02 {
    group_label: "1. Dynamic Parameters"
    label: "Secondary Dimension"
    type: unquoted
    default_value: "None"

    allowed_value: {
      label: "None"
      value: "none"
    }

    allowed_value: {
      label: "User Selects Dimension 1"
      value: "dimension_1"
    }

    allowed_value: {
      label: "User Selects Dimension 2"
      value: "dimension_2"
    }

  }

  dimension: dd_d_02 {
    group_label: "1. Dynamic"
    label: "Secondary Dimension"
    type: string
    label_from_parameter: dd_s_02
    sql: {% if dd_s_02._parameter_value == 'dimension_1' %}
        ${products.category}
        {% elsif dd_s_02._parameter_value == 'dimension_2' %}
        ${products.brand}
        {% else %}
        '-'
        {% endif %}
        ;;
    order_by_field: dd_sort_02
  }

  dimension: dd_sort_02 {
    group_label: "1. Dynamic"
    type: number
    sql:
      {% if dd_s_02._parameter_value == 'dimension_1' %}
      ${dd_d_02}
      {% elsif dd_s_02._parameter_value == 'dimension_2' %}
      CASE WHEN ${dd_d_02} = 'January' THEN 1
        WHEN ${dd_d_02} = 'February' THEN 2
        WHEN ${dd_d_02} = 'March' THEN 3
        WHEN ${dd_d_02} = 'April' THEN 4
        WHEN ${dd_d_02} = 'May' THEN 5
        WHEN ${dd_d_02} = 'June' THEN 6
        WHEN ${dd_d_02} = 'July' THEN 7
        WHEN ${dd_d_02} = 'August' THEN 8
        WHEN ${dd_d_02} = 'September' THEN 9
        WHEN ${dd_d_02} = 'October' THEN 10
        WHEN ${dd_d_02} = 'November' THEN 11
        WHEN ${dd_d_02} = 'December' THEN 12
      END
      {% else %}
      concat(${dd_d_02},"")
      {% endif %}
      ;;
  }

# }

# dynamic measure 02 {

  parameter: dm_s_02 {
    group_label: "1. Dynamic Parameters"
    label: "Secondary Measure"
    type: unquoted
    default_value: "None"

    allowed_value: {
      label: "None"
      value: "none"
    }

    allowed_value: {
      label: "User Selects Measure 1"
      value: "measure_1"
    }

    allowed_value: {
      label: "User Selects Measure 2"
      value: "measure_2"
    }
  }

  measure: dm_d_02 {
    group_label: "1. Dynamic"
    label: "Secondary Measure"
    type: number
    label_from_parameter: dm_s_02
    sql: {% if dm_s_02._parameter_value == 'measure_1' %}
        ${products.count}
        {% elsif dm_s_02._parameter_value == 'measure_2' %}
        ${products.count}
        {% else %}
        0
        {% endif %}
        ;;
  }

# }

# dynamic dimension 03 {

  parameter: dd_s_03 {
    group_label: "1. Dynamic Parameters"
    label: "Tertiary Dimension"
    type: unquoted
    default_value: "None"

    allowed_value: {
      label: "None"
      value: "none"
    }

    allowed_value: {
      label: "User Selects Dimension 1"
      value: "dimension_1"
    }

    allowed_value: {
      label: "User Selects Dimension 2"
      value: "dimension_2"
    }

  }

  dimension: dd_d_03 {
    group_label: "1. Dynamic"
    label: "Tertiary Dimension"
    type: string
    label_from_parameter: dd_s_03
    sql: {% if dd_s_03._parameter_value == 'dimension_1' %}
        ${order_items.created_year}
        {% elsif dd_s_03._parameter_value == 'dimension_2' %}
        ${order_items.created_month}
        {% else %}
        '-'
        {% endif %}
        ;;
    order_by_field: dd_sort_03
  }

  dimension: dd_sort_03 {
    group_label: "1. Dynamic"
    type: number
    sql:
      {% if dd_s_03._parameter_value == 'dimension_1' %}
      ${dd_d_03}
      {% elsif dd_s_03._parameter_value == 'dimension_2' %}
      CASE WHEN ${dd_d_03} = 'January' THEN 1
        WHEN ${dd_d_03} = 'February' THEN 2
        WHEN ${dd_d_03} = 'March' THEN 3
        WHEN ${dd_d_03} = 'April' THEN 4
        WHEN ${dd_d_03} = 'May' THEN 5
        WHEN ${dd_d_03} = 'June' THEN 6
        WHEN ${dd_d_03} = 'July' THEN 7
        WHEN ${dd_d_03} = 'August' THEN 8
        WHEN ${dd_d_03} = 'September' THEN 9
        WHEN ${dd_d_03} = 'October' THEN 10
        WHEN ${dd_d_03} = 'November' THEN 11
        WHEN ${dd_d_03} = 'December' THEN 12
      END
      {% else %}
      concat(${dd_d_03},"")
      {% endif %}
      ;;
  }

# }

# dynamic measure 03 {

  parameter: dm_s_03 {
    group_label: "1. Dynamic Parameters"
    label: "Tertiary Measure"
    type: unquoted
    default_value: "None"

    allowed_value: {
      label: "None"
      value: "none"
    }

    allowed_value: {
      label: "User Selects Measure 1"
      value: "measure_1"
    }

    allowed_value: {
      label: "User Selects Measure 2"
      value: "measure_2"
    }
  }

  measure: dm_d_03 {
    group_label: "1. Dynamic"
    label: "Tertiary Measure"
    type: number
    label_from_parameter: dm_s_03
    sql: {% if dm_s_03._parameter_value == 'measure_1' %}
        ${order_items.median_products}
        {% elsif dm_s_03._parameter_value == 'measure_2' %}
        ${order_items.average_products}
        {% else %}
        0
        {% endif %}
        ;;
  }

# }


}
