# Goals

When an app is inactive for 30 minutes, scale the web dyno to configured minimum size.
If the app receives an HTTP request, boost the dyno to configured maximum size.

# TODO

- Configure scale from / to
  - Allow (web) BASE dyno type to be configured (Off, Eco, Basic, Standard-1X, Standard-2X, Performance-M)
  - Allow (web) BOOST dyno type to be configured (Basic, Standard-1X, Standard-2X, Performance-M, Performance-L)
- When inactive app receives HTTP request BOOST dyno type
  - [`PATCH /apps/{app_id_or_name}/formation`](https://devcenter.heroku.com/articles/platform-api-reference#formation-batch-update)
- When active app stops receiving HTTP requests restore to BASE
  - [`PATCH /apps/{app_id_or_name}/formation`](https://devcenter.heroku.com/articles/platform-api-reference#formation-batch-update)
- Store Pipeline#api_key with [active_record_encryption](https://guides.rubyonrails.org/active_record_encryption.html)
- Style
  - /sign_in
  - /sign_up
  - /passwords/new
  - Flash banner to look better against navigation
  - Authenticated users dropdown box (who is Bonnie Green?)
