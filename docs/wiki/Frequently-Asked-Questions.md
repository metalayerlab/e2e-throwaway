# Frequently Asked Questions

## Which port does it listen on?

8080 by default; change it with `listen.port` (`E2E_THROWAWAY_LISTEN_PORT`). See [In-Depth Configuration](In-Depth-Configuration).

## How do I see which settings are in effect?

Run `e2e-throwaway config`. It lists every setting and where its value came from. See [CLI Reference](CLI-Reference).

## Does it need a config file?

No. A missing file is fine: defaults and `E2E_THROWAWAY_*` variables apply.

## Is there authentication?

No. Put it behind a reverse proxy or on a private network. See [Security](Security).
