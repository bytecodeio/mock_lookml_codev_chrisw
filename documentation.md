# Looker Development Best Practices

[Data Structure & Explore Design](#data-structure--explore-design)

[Access Filters](#access-filters)

[Persistence Strategy (Database + dbt vs. PDTs)](#persistence-strategy-database--dbt-vs-pdts)

[PDTs](#pdts)

[Aggregate Awareness](#aggregate-awareness)

[Dashboard Design](#dashboard-design)

## Data Structure & Explore Design
* Use star/snowflake schemas that include the most granular level fact table with foreign keys to conformed dimension tables.
* Joining dimensional views with `many_to_one` relationships from the most granular table is typically most performant.
* Use `left_outer` joins to avoid dropping fact table records unless you intend to drop records with no matches.
* Define each explore in a separate `.lookml` file.
* Always define a relationship for each join.
* Always specify the primary key for each view to ensure Looker handles fanouts correctly.
* Reference `${date_raw}` when joining on date fields.

## Access Filters
* Access filters must be used in conjunction with user attributes.
* Access filters are explore specific — the parameter must be applied to each explore that needs to be restricted.
* Every user, including admins, accessing an explore with an access filter must have a value for the referenced user attribute.
* Admins (or other users) can access all values with specific advanced filter values.

## Persistence Strategy (Database + dbt vs. PDTs)
* Choosing to use dbt with Looker depends on factors like your team's size, technical expertise, and existing data infrastructure. Although Looker can accomplish most tasks by itself, dbt adds value by separating the transformation and semantic layers of your data. Below is where each tool is most effective:
  * dbt can help maintain DRY code by centralizing data transformations.
  * Looker makes data more accessible and user-friendly by centralizing the semantic layer.
  * dbt can improve performance by enabling Looker to query optimized tables instead of re-running complex logic.
  * Looker PDTs can help optimize performance of specific, resource-intensive queries as well as transformations and aggregations that are only needed for particular use cases.

## PDTs
* Use PDTs to improve performance for frequently used and consistently slow queries.
* Using datagroups for your persistence strategy is typically more efficient than a simpler time-based strategy like `persist_for`.
* Use optimization strategies like indexes and cluster keys to optimize query performance.
* Use incremental PDTs for large tables that frequently receive new data but rarely have existing records updated.

## Aggregate Awareness
* Dashboards with high runtimes, slow or heavily queried explores, and frequently used fields are common scenarios that benefit from aggregate awareness.
* Aggregate tables must contain all dimensions and measures required to answer a user's query including dimensions used in filters.
* Use existing dimensions and measures from the base view to maintain consistency across granular and aggregate levels.

## Dashboard Design
* Every dashboard tile runs a separate query -- limit the number of tiles to fewer than 15 on a single dashboard.
* Avoid adding too much detail to dashboards and instead utilize drill-downs to allow for additional context.
* Design dashboards that provide clear insights for a specific purpose.
* Use visualizations properly.
  * Relationships: bubble charts or heatmaps.
  * Comparisons between categories: column or bar charts.
  * Comparisons over time: line charts.
  * Distributions: box plots, histograms, or scatter plots.
  * Compositions: area or stacked column charts.
* Use the "Inverted Pyramid" layout where the most important items are on top, followed by the next most important, and ending with any granular details last.
