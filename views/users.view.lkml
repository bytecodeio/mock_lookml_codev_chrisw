view: users {
  sql_table_name: `thelook.users` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;  }

  measure: count {
    type: count
    drill_fields: [id, last_name, order_items.count, events.count]
  }

  measure: total_age {
    type: sum
    sql: ${age} ;;  }


  parameter: ortho_cohort {
    type: unquoted
    allowed_value: {
      label: "All"
      value: "all"
    }
    allowed_value: {
      label: "Hip Fracture"
      value: "hip_fracture"
    }
  }

  dimension: parameter_liquid_check {
    type: string
    sql:
    {% if ortho_cohort._parameter_value == "hip_fracture" %}
    "yes"
    {% else %}
    "none"
    {% endif %} ;;
  }
}
