view: order_items {
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  parameter: type {
    type: unquoted
    default_value: "or"
    allowed_value: {
      label: "or"
      value: "or"
    }
    allowed_value: {
      label: "and"
      value: "and"
    }
  }

  filter: product_list {
    type: number
    suggest_dimension: product_id
    # sql: EXISTS (SELECT order_id FROM order_items AS oi WHERE order_items.order_id = oi.order_id AND {% condition %} product_id {% endcondition %}) ;;
    sql:
      {% if type._parameter_value == 'and' %}
      EXISTS (
          SELECT oi.order_id
          FROM order_items AS oi
          INNER JOIN (
            SELECT oi2.order_id, COUNT(DISTINCT oi2.product_id)
            FROM order_items AS oi2
            WHERE 0=0
            AND {% condition %} oi2.product_id {% endcondition %}
            GROUP BY 1
            HAVING COUNT(DISTINCT oi2.product_id) >
            (SELECT COUNT(DISTINCT oi2.product_id)
            FROM order_items AS oi2
            WHERE 0=0
            AND {% condition %} oi2.product_id {% endcondition %}
            ) - 1
          ) as oi3
          ON oi.order_id = oi3.order_id
          WHERE 0=0
          AND order_items.order_id = oi.order_id
          AND {% condition %} oi.product_id {% endcondition %}
          )
       {% elsif type._parameter_value == 'or' %}
      EXISTS (SELECT order_id FROM order_items AS oi WHERE order_items.order_id = oi.order_id AND {% condition %} product_id {% endcondition %})
      {% else %}
      0=0
      {% endif %}
        ;;
  }

  filter: c {
    type: string
    default_value: "@{last_week}"
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;  }

  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: created_week_end_date {
    type: date
    sql: DATE_ADD(DATE(${created_week}),INTERVAL 7 DAY) ;;
    datatype: date
  }

  dimension: created_week_month_end_date {
    type: date
    sql: LAST_DAY(DATE(${created_week}),MONTH) ;;
    datatype: date
  }

  dimension: created_week_month_start_date {
    type: date
    sql: DATE_TRUNC(DATE(${created_week}),MONTH) ;;
    datatype: date
  }

  # dimension: is_week_after_month_end {
  #   type: yesno
  #   sql:
  #   ${created_week_end_date} <= ${created_week_month_end_date}
  #   OR (${created_week_end_date} >= ${created_week_month_end_date}
  #   AND DATE(${created_week}) <= DATE_ADD(${created_week_month_end_date},INTERVAL 7 DAY)
  #   )
  #   ;;
  # }

  dimension: is_week_after_month_end {
    type: yesno
    sql:
      ${created_week_end_date} <= ${created_week_month_end_date}
      OR
      (${created_week_end_date} > ${created_week_month_end_date}
      AND ${created_week_end_date} >= DATE_ADD(${created_week_month_end_date},INTERVAL 7 DAY)
      )
      ;;
  }

  dimension: current_month_end {
    type: date
    sql: LAST_DAY(CURRENT_DATE(),MONTH) ;;
    convert_tz: no
  }

  dimension: current_month_start {
    type: date
    sql: DATE_TRUNC(CURRENT_DATE(),MONTH) ;;
    convert_tz: no
  }

  dimension: is_week_ending_in_current_month {
    type: yesno
    sql: ${created_week_end_date} > ${current_month_start}
          AND ${created_week_end_date} <= ${current_month_end}
          ;;
  }

  measure: actual {
    type: sum
    sql: ${sale_price} ;;
    filters: [is_week_ending_in_current_month: "No"]
  }

  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id
    ]
  }

  measure: products {
    type: count_distinct
    sql: ${product_id} ;;
  }

  measure: median_products {
    type: median
    sql: ${product_id} ;;
  }

  measure: average_products {
    type: average
    sql: ${product_id} ;;
  }

  parameter: user_defined_total_selection {
    type: string
    suggest_dimension: products.name
  }

  measure: user_defined_total {
    type: number
    sql: COUNT(
            CASE WHEN ${products.name} = {% parameter user_defined_total_selection %} THEN
              ${product_id}
            ELSE null
            END
          )
          ;;
  }

## PoP Tests
  filter: base_cohort {
    type: date
  }

  filter: comp_cohort {
    type: date
  }

  dimension: is_base_cohort {
    type: yesno
    sql: ${created_raw} >= {% date_start base_cohort %}
        AND ${created_raw} <= {% date_end base_cohort %}
    ;;
  }

  dimension: is_comp_cohort {
    type: yesno
    sql: ${created_raw} >= {% date_start comp_cohort %}
          AND ${created_raw} <= {% date_end comp_cohort %}
          ;;
  }

  dimension: cohort {
    type: string
    case: {
      when: {
        sql: ${created_raw} >= {% date_start base_cohort %}
              AND ${created_raw} <= {% date_end base_cohort %}
        ;;
        label: "Base"
      }
      when: {
        sql: ${created_raw} >= {% date_start comp_cohort %}
                  AND ${created_raw} <= {% date_end comp_cohort %}
                  ;;
        label: "Comparison"
      }
      else: "None"
    }
  }



###########################################################################
#
#                             PoP Method 3
#
###########################################################################
  filter: current_date_range {
    type: date
    view_label: "PoP - Method 3"
    label: "1. Current Date Range"
    description: "Select the current date range you are interested in. Make sure any other filter on Event Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
  }

  parameter: compare_to {
    view_label: "PoP - Method 3"
    description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
    label: "2. Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Week"
      value: "Week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "Month"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "Quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "Year"
    }
    default_value: "Period"
  }

  parameter: select_measure {
    view_label: "PoP - Method 3"
    label: "Selected Measure"
    type: unquoted
    default_value: ""

    allowed_value: {
      label: "Total Sales"
      value: "total_sales"
    }

    allowed_value: {
      label: "Average Sales"
      value: "avg_sales"
    }
  }


######################################################################
#
#                         hidden helper dimensions
#
######################################################################
  dimension: days_in_period {
    hidden:  yes
    view_label: "PoP - Method 3"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATE_DIFF( DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %}), DAY) ;;
  }

  dimension: period_2_start {
    hidden:  yes
    view_label: "PoP - Method 3"
    description: "Calculates the start of the previous period"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL ${days_in_period} DAY)
        {% else %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
    convert_tz: no
  }

  dimension: period_2_end {
    hidden:  yes
    view_label: "PoP - Method 3"
    description: "Calculates the end of the previous period"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 DAY)
        {% else %}
        DATE_SUB(DATE_SUB(DATE({% date_end current_date_range %}), INTERVAL 1 DAY), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
    convert_tz: no
  }

  dimension: day_in_period {
    hidden: yes
    view_label: "PoP - Method 3"
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
        THEN DATE_DIFF( DATE({% date_start current_date_range %}), ${created_date}, DAY) + 1
        WHEN ${created_date} between ${period_2_start} and ${period_2_end}
        THEN DATE_DIFF(${period_2_start}, ${created_date}, DAY) + 1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }

  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
            THEN 1
            WHEN ${created_date} between ${period_2_start} and ${period_2_end}
            THEN 2
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }

##############################################################################################
#
#                                  dimensions to plot
#
##############################################################################################

  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the previous periods onto the current period"
    label: "Current Period"
    type: time
    sql: DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL (${day_in_period} - 1) DAY)  ;;
    view_label: "PoP - Method 3"
    timeframes: [
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week_of_year,
      month,
      month_name,
      month_num,
      year]
    convert_tz: no
  }


  dimension: period {
    view_label: "PoP - Method 3"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${created_date} between ${period_2_start} and ${period_2_end}
            THEN 'Last {% parameter compare_to %}'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }

###############################################################################################
#
#                                    filtered measures
#
###############################################################################################

  dimension: period_filtered_measures {
    hidden: yes
    view_label: "PoP - Method 3"
    description: "We just use this for the filtered measures"
    type: string
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${created_raw} {% endcondition %} THEN 'this'
                WHEN ${created_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
            {% else %} NULL {% endif %} ;;
  }

  measure: current_period_sales {
    view_label: "PoP - Method 3"
    type: sum
    sql: ${sale_price};;
    filters: [period_filtered_measures: "this"]
  }

  measure: previous_period_sales {
    view_label: "PoP - Method 3"
    type: sum
    sql: ${sale_price};;
    filters: [period_filtered_measures: "last"]
  }

  measure: sales_pop_change {
    view_label: "PoP - Method 3"
    label: "Total Sales period-over-period % change"
    type: number
    sql: CASE WHEN ${current_period_sales} = 0
            THEN NULL
            ELSE (1.0 * ${current_period_sales} / NULLIF(${previous_period_sales} ,0)) - 1 END ;;
    value_format_name: percent_2
  }

  measure: dynamic_current_period {
    view_label: "PoP - Method 3"
    label: "Selected Measure - Current Period"
    type: sum
    label_from_parameter: select_measure
    sql: {% if select_measure._parameter_value == 'total_sales' %}
        ${sale_price}
        {% elsif select_measure._parameter_value == 'avg_sales' %}
        ${sale_price}
        {% else %}
        NULL
        {% endif %}
        ;;
    filters: [period_filtered_measures: "this"]
  }

  measure: dynamic_current_previous {
    view_label: "PoP - Method 3"
    label: "Selected Measure - Previous Period"
    type: sum
    label_from_parameter: select_measure
    sql: {% if select_measure._parameter_value == 'total_sales' %}
        ${sale_price}
        {% elsif select_measure._parameter_value == 'avg_sales' %}
        ${sale_price}
        {% else %}
        NULL
        {% endif %}
        ;;
    filters: [period_filtered_measures: "last"]
  }


}
