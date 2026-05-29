{% test positive_values(model, column_name) %}
-- model and column_name are automatically injected by dbt.
-- model = the ref() of the model being tested
-- column_name = whatever column you apply this test to in YAML

select *
from {{ model }}
where {{ column_name }} < 0
-- Returns rows where the column is negative — these are failures

{% endtest %}