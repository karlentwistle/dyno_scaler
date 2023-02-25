# Goals

When an app is inactive for 30 minutes, scale the web dyno to configured minimum size.
If the app receives an HTTP request, boost the dyno to configured maximum size.

# TODO

- Setup a new pipeline to monitor
  - Pipeline uuid
  - Heroku api key
- Add a process which automatically adds logdrain to each app in pipeline pointing towards self
  - [`POST /apps/{app_id_or_name}/log-drains`](https://devcenter.heroku.com/articles/platform-api-reference#log-drain-create)
- Configure a simple logs endpoint to start receiving logs from pipelines dynos
  - When an app receives a HTTP request update Dyno last_active_at
- Add simple dashboard to show apps in pipeline that are active / inactive (no request for 30 mins)
- Configure scale from / to
  - Allow (web) BASE dyno type to be configured (Off, Eco, Basic, Standard-1X, Standard-2X, Performance-M)
  - Allow (web) BOOST dyno type to be configured (Basic, Standard-1X, Standard-2X, Performance-M, Performance-L)
- When inactive app receives HTTP request BOOST dyno type
  - [`PATCH /apps/{app_id_or_name}/formation`](https://devcenter.heroku.com/articles/platform-api-reference#formation-batch-update)
- When active app stops receiving HTTP requests restore to BASE
  - [`PATCH /apps/{app_id_or_name}/formation`](https://devcenter.heroku.com/articles/platform-api-reference#formation-batch-update)
