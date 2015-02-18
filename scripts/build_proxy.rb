#!/usr/bin/env ruby

require 'yaml'

# Read in proxy options
begin
  proxy_options = YAML.load_file '/vagrant/proxy.yml'
rescue Psych::SyntaxError
  abort 'Syntax error in proxy.yml, please check and try again'
rescue Errno::ENOENT
  abort 'Please copy proxy.yml.example to proxy.yml and modify it for your needs'
end

# Set static variable
OUTPUT_FILE = '/usr/share/nginx/html/proxy.pac'
PROXY       = '192.168.50.100:3128'

PROXY_DIRECT = %q|return "DIRECT";|
PROXY_PROXY  = %Q|return "PROXY #{PROXY}";|
PROXY_MATCH  = %q|shExpMatch(host,"%%HOST%%")|

# Build proxy and direct lines
proxies = %w(direct proxy).map do |type|
  (proxy_options[type]||[]).map { |host| PROXY_MATCH.gsub(/%%HOST%%/, host) }.join('||')
end

# Create the PAC file
begin
  File.open(OUTPUT_FILE, 'w') do |file|
    file.puts "// This file was auto-generated by #{$0} at #{Time.now}"
    file.puts 'function FindProxyForURL(url, host) {'

    file.printf "if (%s) %s\n", proxies[0], PROXY_DIRECT unless proxies[0].empty?
    file.printf "if (%s) %s\n", proxies[1], PROXY_PROXY  unless proxies[1].empty?

    file.puts proxy_options['default'] =~ /proxy/i ? PROXY_PROXY : PROXY_DIRECT
    file.puts '};'
  end
rescue Errno::ENOENT
  abort "Unable to open #{OUTPUT_FILE}"
end

puts 'proxy.pac created successfully'
