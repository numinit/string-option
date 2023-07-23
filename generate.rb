#!/usr/bin/env ruby

require 'shellwords'

# Should match: https://github.com/NixOS/nixpkgs/blob/master/lib/ascii-table.nix
ascii = "\t\n\r !\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

# These are safe to use in a Git branch name or a flake URL.
safe = /[A-Za-z0-9_]/

def create_branch! name, char
  system %w[git checkout a03b0fac73d04f91272e11c71c082b3501afca73].shelljoin
  system ['git', 'branch', '-D', name].shelljoin
  system ['git', 'tag', '-d', name].shelljoin
  system ['git', 'branch', name].shelljoin
  system ['git', 'checkout', name].shelljoin

  # Same in Nix and Ruby for this charset.
  File.write 'flake.nix', <<EOF
{ outputs = { ... }: { value = #{char.inspect}; }; }
EOF

  system %w[git add flake.nix].shelljoin

  msg = "Add branch '#{name}'"
  if name != char
    msg << " (#{char.inspect})"
  end
  system ['git', 'commit', '-m', msg].shelljoin
  system ['git', 'tag', '-m', msg, name].shelljoin
  system %w[git checkout master].shelljoin
end

if ARGV.first == '--create-branches'
  ascii.each_char do |char|
    if char =~ safe
      create_branch! char, char
    end

    create_branch! '%d' % char.ord, char
    create_branch! "0x#{'%02x' % char.ord}", char
  end
end

puts '|Character|Plain|Decimal|Hex|'
puts '|:--------|:----|:------|:--|'
ascii.each_char do |char|
  puts "|`#{char.inspect.gsub('`', '\`')}`|#{char =~ safe ? "`github:numinit/string-option/#{char}`" : ''}|#{'`github:numinit/string-option/%d`' % char.ord}|#{'`github:numinit/string-option/0x%02x`' % char.ord}|"
end
