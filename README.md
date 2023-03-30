# Goals

When an app is inactive for 30 minutes, scale the web dyno to configured minimum size.
If the app receives an HTTP request, boost the dyno to configured maximum size.

- Store Pipeline#api_key with [active_record_encryption](https://guides.rubyonrails.org/active_record_encryption.html)
- Add page
  - Edit pipeline page (so users can adjust base / boost size)
- Style
  - /sign_in
  - /sign_up
  - /passwords/new
  - Flash banner to look better against navigation
