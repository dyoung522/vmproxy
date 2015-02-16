
# Vagrant VPN Proxy

This will create a small vagrant machine running a caching proxy server and  the openconnect VPN client. The goal is to proxy web traffic over a VPN connection (e.g. to connect to private corporate websites while on a public network).

## Sounds good! How do I get this thing up and running?

1. Install [Vagrant](http://www.vagrantup.com) and [VirtualBox](http://www.virtualbox.org), as we depend on these.

1. Clone the repo

  ```sh
  $ git clone https://github.com/dyoung522/vmproxy
  $ cd vmproxy
  ```

1. Prep the VPN configuration file; `.env`

  ```sh
  $ cp env.sample .env
  $ chmod 0600 .env
  ```

1. Modify the `.env` file as appropriate. It should be self-explanatory, but make sure you have at least the top three variables set:

  ```sh
  export VPN_URL='https://your.vpn.url'
  export VPN_USER='your-username'
  export VPN_PASS='your-password'
  # The rest are optional
  export VPN_TIMEOUT=60
  export VPN_LOGFILE='vpn.log'
  ```

1. Copy `proxy.yml.example` to `proxy.yml` and modify it appropriately, here's the basic syntax:

  ```yaml
  # a list of hosts we should always proxy for
  proxy:
    - '*.proxied-domain.com'
    - 'always-proxy-me.example.com'

  # an optional list of hosts we should never proxy for, use this to override hosts in proxied domains
  direct:
    - 'never-proxy-me.proxied-domain.com'

  # What should we default to, 'proxy' or 'direct'? if unset, the default is 'direct'
  default: direct
  ```
  
1. Launch the VM

  ```sh
  vagrant up
  ```
  
1. That's it, your proxy server is now up and running at `192.168.50.100:3128`. In case something goes wrong, you can check `logs/vpn.log` for additional information.

## Great! Now, how do I use it?

There are two ways:

1. You can redirect web-traffic to your proxy server via a browser plugin:

  Most modern browsers have plugins/extensions available online for this very purpose, so find one you like. 
Personally, I like [Proxy SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif) 
for chrome, but you can use whatever works for you.

  Configure it to point your Proxy Server running at `192.168.50.100:3128`

2. Configure autoproxy by either pointing your browser proxy or system network configuration at `http://192.168.50.100/proxy.pac`.

  Under OS X, you can do this in `System Preferences -> Network -> [network adaptor] -> Advanced -> Proxies -> Automatic Proxy Configuration`

That's it!

### What you should know...

- The VPN client logs to `log/vpn.log` (by default), so check for problems there first.
- The VPN client will attempt to reconnect after 60 seconds *(or whatever you've set `$VPN_TIMEOUT` to be)* of being disconnected... forever
- To stop the proxy altogether, run `vagrant halt`
- To restart it, run `vagrant up`

#### Known Issues

- If you encounter a CHEF error regarding "shared folders" while starting the VM, you'll need to
  remove the vagrant synced_folders file...

  ```sh
  rm .vagrant/machines/default/virtualbox/synced_folders
  ```
  
- Sometimes the OpenConnect VPN client loses it's ability to obtain a valid
  certificate and gets stuck. If you see errors in your vpn.log along those lines,
  run `vagrant reload` and that typically clears it up.

- If you find more, please [submit an issue](https://github.com/dyoung522/vmproxy/issues/new)
 
## I want to help make this faster/stronger/better!

That's great, any positive contributions are welcome!

1. [Fork it](https://github.com/dyoung522/vmproxy/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
