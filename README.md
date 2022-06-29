# README

## Bug report

Navigating to a route prefixed with `#{Rails.application.config.action_cable.mount_path}-` 404s.

I discovered this in a Rails 6 application and confirmed the behavior exists on the latest version. It's possible this is expected and I couldn't find that documentation but the behavior is odd enough that I believe this is a bug.

I tried to provide as much info as possible and have provided a reproduction repo and reproduction instructions. If I can provide anything else, let me know!

If this is a bug, I would be happy to take a stab at fixing it if someone can give me a nudge in the right direction.

### Steps to reproduce

1. Generate new rails app (`rails new test-app && cd test-app`) or use the one [here](#).
2. `bin/rails g controller Test index`
3. Add these routes to your `config/routes.rb`:
    ```rb
    get "/cable-hyphenated-slug", to: "test#index"
    get "/cable_underscored_slug", to: "test#index"
    ```
4. Add the following tests to `TestControllerTest`
    ```rb
      # Fails
      test "route prefixed with 'cable-' should get index" do
        get cable_hyphenated_slug_path
        assert response.ok?
      end

      # Succeeds
      test "route prefixed with 'cable_' should get index" do
        get cable_underscored_slug_path
        assert response.ok?
      end
    ```
5. Run the tests to witness the issue
6. To view in the browser, start the Rails server with `rails s`
  1. `http://localhost:3000/cable_underscored_slug` should render the index template
  2. **`http://localhost:3000/cable-hypenated-slug` will 404**


### Expected behavior

In the example above, `/cable-hypenated-slug` should be routed to `test#index` like `/cable_underscored_slug` is.

### Actual behavior

Navigating to a route that is prefixed with `#{Rails.application.config.action_cable.mount_path}-` 404s but navigating to a route that is prefixed with `#{Rails.application.config.action_cable.mount_path}_` works.

The same is true regardless of the mount path.

```rb
config.action_cable.mount_path = "/dev/cable"

# http://localhost:3000/dev/cable-hyphenated-slug -> 404
# http://localhost:3000/dev/cable_underscored_slug -> 201
```

According to the logs, it looks like Rails tries to split the path on the first hyphen and then try to GET it as a WebSocket request:

```log
2022-06-29 04:04:44 -0700 HTTP parse error, malformed request: #<Puma::HttpParserError: Invalid HTTP format, parsing fails. Are you trying to open an SSL connection to a non-SSL Puma?>
Started GET "/cable-hyphenated-slug" for ::1 at 2022-06-29 04:04:47 -0700
Started GET "/cable/-hyphenated-slug"[non-WebSocket] for ::1 at 2022-06-29 04:04:47 -0700
Failed to upgrade to WebSocket (REQUEST_METHOD: GET, HTTP_CONNECTION: keep-alive, HTTP_UPGRADE: )
Finished "/cable/-hyphenated-slug"[non-WebSocket] for ::1 at 2022-06-29 04:04:47 -0700
Started GET "/cable-hyphenated-slug" for ::1 at 2022-06-29 04:04:47 -0700
Started GET "/cable/-hyphenated-slug"[non-WebSocket] for ::1 at 2022-06-29 04:04:47 -0700
Failed to upgrade to WebSocket (REQUEST_METHOD: GET, HTTP_CONNECTION: keep-alive, HTTP_UPGRADE: )
Finished "/cable/-hyphenated-slug"[non-WebSocket] for ::1 at 2022-06-29 04:04:47 -0700
```

The easy solution is to not prefix any routes with `cable-` but I am working in an app where users can set their own slugs for pages and the only solution I can come up with is add that prefix to a blocklist.

### System configuration

**Rails version**:

- 7.0.3
- 6.1.5.1

**Ruby version**:

- 2.7.5
- 2.7.6
