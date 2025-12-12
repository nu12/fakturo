#!/usr/bin/env ruby
require 'bunny'
require 'json'
require 'date'

class RegexMatcherServer
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
  end

  def start(queue_name)
    @queue = channel.queue(queue_name)
    @exchange = channel.default_exchange
    subscribe_to_queue
  end

  def stop
    channel.close
    connection.close
  end

  def loop_forever
    # This loop only exists to keep the main thread
    # alive. Many real world apps won't need this.
    loop { sleep 5 }
  end

  private

  attr_reader :channel, :exchange, :queue, :connection

  def subscribe_to_queue
    queue.subscribe do |_delivery_info, properties, payload|
      p "[#{properties.correlation_id}] Start processing..."
      result = regex_matcher(payload)

      exchange.publish(
        result.to_json,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )
      p "[#{properties.correlation_id}] Done"
    end
  end

  def regex_matcher(text)
    result = []
    lines = text.gsub(/ +/, " ").gsub("\r\n", "\n").split("\n")
    lines.each do |line|
      m = /(?<day>\d{2})\W(?<month>\d{2})\W\d{2}\W\d{2}\W(?<description>[\w' ]+).+\D(?<value>\d+.\d{2}|\d+.\d{2}CR)\s*$/.match(line)
      n = /^\s*(?<month>\S{3,})\s(?<day>\d{2})\s+\S{3,}\s\d{2}[\s\W]+(?<description>[\w' ]+).*\D(?<value>\d+,\d{2})/.match(line.force_encoding(Encoding::ISO_8859_1))
      next unless m || n
      if m && m[:day] && m[:month] && m[:description] && m[:value]
        result << {date: "#{Date.today.year}-#{m[:month]}-#{m[:day]}", description: m[:description], value: m[:value].to_f}
      elsif n && n[:day] && n[:month] && n[:description] && n[:value]
        months = {
          "jan" => "01",
          "fév" => "02",
          "mar" => "03",
          "avr" => "04",
          "mai" => "05",
          "jun" => "06",
          "jlt" => "07",
          "aoû" => "08",
          "sep" => "09",
          "oct" => "10",
          "nov" => "11",
          "déc" => "12"
        }
        result << {date: "#{Date.today.year}-#{months[n[:month].force_encoding(Encoding::UTF_8)]}-#{n[:day]}", description: n[:description], value: n[:value].gsub(",", ".").to_f}
      end
    end
    return result
  end
end

begin
  server = RegexMatcherServer.new

  puts 'Server starting, waiting RPC requests...'
  server.start('rpc_queue')
  server.loop_forever
rescue Interrupt => _
  server.stop
end