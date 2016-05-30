# Hosts Manager

:smile: A tiny portable hosts manager written in ruby.

## Getting Started

1. Fork this repo
2. Change this line

  ```ruby
  HOSTS_CONFIG = {
    # Host: MIT
    mit: { 'web.mit.edu' => '104.85.68.60' }
  }
  ```

3. Execute

  ```bash
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/<you-or-your-organisation>/hostsmanager/master/hostsmanager.rb)" enable mit
  ```

## Test

Force IP of [perdu.com]()
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/JulienBreux/hostsmanager/master/hostsmanager.rb)" enable perdu
```

Disable force IP of [perdu.com]()

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/JulienBreux/hostsmanager/master/hostsmanager.rb)" disable perdu
```

## Philosophy
  
Just used to override DNS and play with a server.

### Why execute from repos?

Because the code and the world are changing!
