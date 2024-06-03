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
    sql: ${sale_price} ;;  }

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

}
