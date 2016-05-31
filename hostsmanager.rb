# (c) 2016 - Julien BREUX <julien.breux@gmail.com>
#
# HOW TO USE?
#
# $ sudo /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/JulienBreux/hostsmanager/master/hostsmanager.rb)" enable perdu
# $ sudo /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/JulienBreux/hostsmanager/master/hostsmanager.rb)" disable perdu
#

################################################ SETTINGS
FILENAME     = '/etc/hosts'
HOSTS_CONFIG = {
  # Host: perdu
  perdu: {
    'perdu.com'     => '208.97.177.124',
    'www.perdu.com' => '208.97.177.124'
  }
}
################################################ SETTINGS

class BlockManager
  def initialize(filename, hosts)
    @filename = filename
    @hosts = hosts

    load
  end

  def execute(action, host)
    allowed_actions = ['enable', 'disable']

    if allowed_actions.include?(action) && !host.empty?
      send(action, host)
    elsif host.empty?
      abort("Host '#{host}' not found.")
    else
      abort("Action '#{action}' not found.")
    end
  end

  def enable(name)
    line_action(name, __method__) do |line, in_block|
      line = line.partition('# ').last if in_block && line =~ /^#/
      line
    end
  end

  def disable(name)
    line_action(name, __method__) do |line, in_block|
      line = "# #{line}" if in_block && line !~ /^#/
      line
    end
  end

  def line_action(name, desc)
    add_host name unless exists_host? name

    in_block = false
    lines = []
    @lines.each_with_index do |line, index|
      in_block = false if line =~ /^# < #{name.upcase}/
      line = yield(line, in_block)
      in_block = true if line =~ /^# > #{name.upcase}/

      lines << line
    end

    @lines = lines
    save

    puts "#{desc.capitalize} '#{name}' host to '#{@filename}'."
  end

  def add_host(name)
    check_host(name)

    puts "Add '#{name}' host to '#{@filename}'."

    lines = ["# > #{name.upcase}\n"]
    @hosts[name.to_sym].each do |host, ip|
      lines << "#{ip} #{host}\n"
    end
    lines << "# < #{name.upcase}\n"

    append(lines)
    save
  end

  # TODO: Refactor with .line_action
  def remove_host(name)
    puts "Remove '#{name}' host from '#{@filename}'."

    remove = false
    lines = []
    @lines.each_with_index do |line, index|
      remove = true if line =~ /^# > #{name.upcase}/
      lines << line unless remove
      remove = false if line =~ /^# < #{name.upcase}/
    end

    @lines = lines
    save
  end

  def check_host(name)
    abort("Host '#{name}' config not found.") unless @hosts.include?(name.to_sym)
  end

  def exists_host?(name)
    token = "# > #{name.upcase}"

    @lines.each { |line| return true if line =~ /^#{token}/ }

    return false
  end

  def append(content)
    @lines << content
  end

  def load
    @lines = File.readlines(@filename)
  end

  def save
    File.write(@filename, @lines.join)
  end
end

ACTION = ARGV[0].nil? ? '' : ARGV[0]
HOST   = ARGV[1].nil? ? '' : ARGV[1]

BlockManager
  .new(FILENAME, HOSTS_CONFIG)
  .execute(ACTION, HOST)
