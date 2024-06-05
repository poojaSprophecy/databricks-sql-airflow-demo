from ashishk3s_airflow_demo_databricks_sql_project_dmeo_job2.utils import *

def Model_0():
    from airflow.operators.bash import BashOperator
    import os
    import zipfile
    import tempfile

    return BashOperator(
        task_id = "Model_0",
        bash_command = " && ".join(
          ["{} && cd $tmpDir/{}".format(
             (
               "set -euxo pipefail && tmpDir=`mktemp -d` && git clone "
               + "--depth 1 {} --branch {} $tmpDir".format(
                 "https://github.com/poojaSprophecy/databricks-sql-airflow-demo",
                 "__PROJECT_FULL_RELEASE_TAG_PLACEHOLDER__"
               )
             ),
             ""
           ),            "dbt seed --profile run_profile_pooja",  "dbt test --profile run_profile_pooja"]
        ),
        env = {"DBT_DATABRICKS_INVOCATION_ENV" : "prophecy", "DBT_PROFILES_DIR" : "/home/airflow/gcs/data"},
        append_env = True,
    )
