# Goals

When an app is inactive for 30 minutes, scale the web dyno to configured minimum size.
If the app receives an HTTP request, boost the dyno to configured maximum size.

# TODO

- Store Pipeline#api_key with [active_record_encryption](https://guides.rubyonrails.org/active_record_encryption.html)
- Add page
  - Cost savings page (so users can see how much money they've saved with dyno scaler)
  - New organisation page after a new user registers via oauth
- Style
  - /passwords/new
  - Flash banner to look better against navigation
