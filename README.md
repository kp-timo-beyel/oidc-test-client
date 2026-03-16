# OIDC Test Client

A browser-based single-page app for testing OIDC/OAuth2 flows against Keycloak — no backend, no dependencies beyond a simple HTTP server.

## Getting started

```bash
./start.sh
```

Opens `http://localhost:8080` in your browser automatically. Requires Python 3.

## How it works

### Configuration

Set the following parameters before starting a login:

| Field | Description |
|---|---|
| **Environment** | Predefined issuer URLs for Staging, Production, Local, or Custom |
| **Client ID** | The Keycloak client ID |
| **Scopes** | OAuth2 scopes (default: `openid profile email`) |
| **ACR Values** | Optional: Authentication Context Class Reference |
| **Login Hint** | Optional: pre-fills the username/email field on the login page |
| **Force login** | Sets `prompt=login` — forces re-authentication, ignores active SSO session |
| **Offline access** | Adds `offline_access` to scopes — refresh token survives SSO session expiry |
| **curl only** | Skips automatic token exchange and shows the equivalent curl command instead |

The redirect URI (`http://localhost:8080`) must be registered as a valid redirect URI in your Keycloak client.

### Authorization Code Flow

1. Click **Start Login →** to build the authorization URL and redirect the browser to Keycloak.
2. After a successful login, Keycloak redirects back to the app with a `code` parameter.
3. The app exchanges the code for tokens via a direct `fetch` call to the token endpoint.
4. Tokens are decoded and displayed in tabs.

> Keycloak clients must be configured as `public` (no client secret) for this flow to work.

### Device Flow (RFC 8628)

Click **Device Flow** to start the device authorization flow:

1. The app calls the `device_authorization_endpoint` and receives a user code and verification URL.
2. A QR code and the URL are displayed — open the URL on any device and enter the code.
3. The app polls the token endpoint in the background until authorization is complete.

### Token view

After a successful login, four tabs are available:

- **Callback** — Raw URL parameters from the redirect
- **Raw Response** — Full token response as JSON
- **Access Token** — Decoded JWT (header + payload) with expiry display
- **ID Token** — Decoded JWT with user attributes
- **Refresh Token** — Raw token string (only with `offline_access`)

The **↻ Refresh Access Token** button exchanges the refresh token for a new token set.

### curl command

When **curl only** is enabled, or after a successful authorization code callback, the equivalent `curl` command for the token exchange is shown and can be copied — useful for API testing and debugging.

## Environments

| Name | Issuer URL |
|---|---|
| Staging | `https://stg.auth.xvtest.net/realms/xvpn` |
| Production | `https://auth.expressvpn.com/realms/xvpn` |
| Local | `http://localhost:8087/realms/xvpn` |
| Custom | Freely configurable |
