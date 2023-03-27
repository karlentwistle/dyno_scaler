# Goals

When an app is inactive for 30 minutes, scale the web dyno to configured minimum size.
If the app receives an HTTP request, boost the dyno to configured maximum size.

- When inactive app receives HTTP request BOOST dyno type
  - ReviewApp#request_received should enqueue a formation update if required so boost happens quickly
  - Denormalize boost_size and base_size on ReviewApp instances for joinless queries
- Store Pipeline#api_key with [active_record_encryption](https://guides.rubyonrails.org/active_record_encryption.html)
- Add page
  - Edit pipeline page (so users can adjust base / boost size)
- Style
  - /sign_in
  - /sign_up
  - /passwords/new
  - Flash banner to look better against navigation
  - Authenticated users dropdown box (who is Bonnie Green?)
