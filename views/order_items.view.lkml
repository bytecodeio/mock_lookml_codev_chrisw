view: order_items {
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

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
