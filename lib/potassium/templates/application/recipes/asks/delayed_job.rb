use_delayed_job = Ask.confirm "Do you want to use delayed jobs?"
set(:delayed_job, use_delayed_job)
