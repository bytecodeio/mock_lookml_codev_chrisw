view: users {
  sql_table_name: `thelook.users` ;;
  drill_fields: [id]

  filter: city_list {
    type: string
    suggest_dimension: city
    sql: EXISTS (SELECT id FROM users AS u WHERE users.id = u.id AND {% condition %} city {% endcondition %}) ;;
  }

  dimension: id {
    primary_key: yes
    group_label: "User Info"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    group_label: "User Info"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    group_label: "Location Info"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Location Info"
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
    group_label: "User Info"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: gender {
    group_label: "User Info"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    group_label: "Location Info"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    group_label: "Location Info"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "Location Info"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    group_label: "Location Info"
    type: zipcode
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    group_label: "Location Info"
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: street_address {
    group_label: "Location Info"
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
