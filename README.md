
# Vagrant VPN Proxy

This will create a small vagrant machine running a caching proxy server and  the openconnect VPN client. The goal is to proxy web traffic over a VPN connection (e.g. to connect to private corporate websites while on a public network).

## Sounds good! How do I get this thing up and running?

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

1. Launch the VM

  ```sh
  vagrant up
  ```
  
1. That's it, your proxy server is now up and running at `192.168.50.100`. In case something goes wrong, you can check `logs/vpn.log` for additional information.

## Great! Now, how do I use it?

You'll need something to redirect web-traffic to your proxy server.

Most modern browsers have plugins/extensions available online for this very purpose, so find one you like. Personally, I like [Proxy SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif) for chrome, but you can use whatever works for you.

Configure it to point your Proxy Server running at `192.168.50.100:3128`

That's it!

### You should know...

- The VPN client will attempt to reconnect after 60 seconds *(or whatever you've set `$VPN_TIMEOUT` to be)* of being disconnected... forever
- To stop the proxy altogether, run `vagrant suspend`
- To restart it, run `vagrant up`
- To change the Proxy IP address from `192.168.50.100`, you'll need to modify the `Vagrantfile` and restart the VM with `vagrant reload`
