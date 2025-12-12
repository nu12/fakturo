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
      matched = match_a(line) || match_b(line)
      next unless matched
      result << matched
    end
    return result
  end

  def match_a(line)
    m = /(?<day>\d{2})\W(?<month>\d{2})\W\d{2}\W\d{2}\W(?<description>[\w' ]+).+\D(?<value>\d+.\d{2}|\d+.\d{2}CR)\s*$/.match(line)
    return {date: "#{Date.today.year}-#{m[:month]}-#{m[:day]}", description: m[:description], value: m[:value].to_f} if m && m[:day] && m[:month] && m[:description] && m[:value]
    return nil
  end
  def match_b(line)
    month_matrix = {
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
    m = /^\s*(?<month>\S{3,})\s(?<day>\d{2})\s+\S{3,}\s\d{2}[\s\W]+(?<description>[\w' ]+).*\D(?<value>\d+,\d{2})/.match(line.force_encoding(Encoding::ISO_8859_1))
    return {date: "#{Date.today.year}-#{month_matrix[m[:month].force_encoding(Encoding::UTF_8)]}-#{m[:day]}", description: m[:description], value: m[:value].gsub(",", ".").to_f} if m && m[:day] && m[:month] && m[:description] && m[:value]
    return nil
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