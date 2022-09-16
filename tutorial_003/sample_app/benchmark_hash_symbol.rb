require 'benchmark/ips'

Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 5, :warmup => 2)

  key_int_hash = {
    1 => "value1",
    2 => "value2",
    3 => "value3",
    4 => "value4",
    5 => "value5"
  }
  # Typical mode, runs the block as many times as it can
  x.report("int hash") { key_int_hash[3] }

  key_string_hash = {
    "first" => "value1",
    "second" => "value2",
    "third" => "value3",
    "fourth" => "value4",
    "fifth" => "value5"
  }
  # Typical mode, runs the block as many times as it can
  x.report("string hash") { key_string_hash["third"] }

  key_symbol_hash = {
    first: "value1",
    second: "value2",
    third: "value3",
    fourth: "value4",
    fifth: "value5"
  }
  # Typical mode, runs the block as many times as it can
  x.report("symbol hash") { key_string_hash[:third] }

  # To reduce overhead, the number of iterations is passed in
  # and the block must run the code the specific number of times.
  # Used for when the workload is very small and any overhead
  # introduces incorrectable errors.
#   x.report("addition2") do |times|
#     i = 0
#     while i < times
#       1 + 2
#       i += 1
#     end
#   end

  # To reduce overhead even more, grafts the code given into
  # the loop that performs the iterations internally to reduce
  # overhead. Typically not needed, use the |times| form instead.
  #x.report("addition3", "1 + 2")

  # Really long labels should be formatted correctly
  #x.report("addition-test-long-label") { 1 + 2 }

  # Compare the iterations per second of the various reports!
  x.compare!
end