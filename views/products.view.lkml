view: products {
  sql_table_name: `thelook.products` ;;
  drill_fields: [id]

  parameter: type {
    type: unquoted
    default_value: "or"
    allowed_value: {
      label: "Any"
      value: "or"
    }
    allowed_value: {
      label: "All"
      value: "and"
    }
  }

  filter: brand_list {
    type: string
    suggest_dimension: brand
    # sql: EXISTS (SELECT order_id FROM order_items AS oi WHERE order_items.order_id = oi.order_id AND {% condition %} product_id {% endcondition %}) ;;
    sql:
      {% if type._parameter_value == 'and' %}
      EXISTS (
          SELECT oi.order_id
          FROM ${order_items.SQL_TABLE_NAME} AS oi
          INNER JOIN ${products.SQL_TABLE_NAME} AS p
          ON oi.product_id = p.id
          INNER JOIN (
            SELECT oi2.order_id, COUNT(DISTINCT p2.brand)
            FROM ${products.SQL_TABLE_NAME} AS p2
            INNER JOIN ${order_items.SQL_TABLE_NAME} oi2
            ON p2.id = oi2.product_id
            WHERE 0=0
            AND {% condition %} p2.brand {% endcondition %}
            GROUP BY 1
            HAVING COUNT(DISTINCT p2.brand) >
            (SELECT COUNT(DISTINCT p2.brand)
            FROM ${products.SQL_TABLE_NAME} AS p2
            WHERE 0=0
            AND {% condition %} p2.brand {% endcondition %}
            ) - 1
          ) as oi3
          ON oi.order_id = oi3.order_id
          WHERE 0=0
          AND order_items.order_id = oi.order_id
          AND {% condition %} p.brand {% endcondition %}
          )
       {% elsif type._parameter_value == 'or' %}
      EXISTS (
        SELECT order_id
        FROM ${order_items.SQL_TABLE_NAME} AS oi
        INNER JOIN ${products.SQL_TABLE_NAME} AS p
          ON oi.product_id = p.id
        WHERE order_items.order_id = oi.order_id
        AND {% condition %} p.brand {% endcondition %})
      {% else %}
      0=0
      {% endif %}
        ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;  }

  measure: average_cost {
    type: average
    sql: ${cost} ;;  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      distribution_centers.name,
      distribution_centers.id,
      order_items.count,
      inventory_items.count
    ]
  }

  # filter: choose_category {
  #   type: string
  #   suggest_dimension: category
  #   # sql: EXISTS (SELECT category FROM products WHERE category LIKE '%Pant%') ;;
  #   sql: {% condition %} category {% endcondition %};;
  # }

  filter: prefilter {
    type: string
  }

}
