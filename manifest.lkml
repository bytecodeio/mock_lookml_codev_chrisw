project_name: "mock_lookml_codev_chrisw"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }

constant: last_week {
  value: "
  {% assign last_year = 'now' | date: '%Y' | minus: 1 %}
  {% if 1 == 1 %}
  {{ last_year }}
  {% endif %}
  "
}


constant: current_week {
  value: " (SELECT SAFE_CAST(MAX(DATE_TRUNC(dt,WEEK)) AS STRING)
  FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', CURRENT_DATE(), INTERVAL 1 DAY)) as DT)"
}


visualization: {
  id: "custom_viz_1"
  label: "Custom Viz 1 - CW"
  file: "custom/visualizations/bundle.js"
}
