use_delayed_job = answer(:"delayed-job") { Ask.confirm("Do you want to use delayed jobs?") }
set(:delayed_job, use_delayed_job)
