module Puppet::Parser::Functions
  newfunction(:find_index, :type => :rvalue) do |args|
    raise ArgumentError, 'Wrong number of arguments' if args.length != 2
    raise ArgumentError, 'Argument 0 must be an array' if args[0].class != Array
    raise ArgumentError, 'Argument 1 must be a string' if args[1].class != String

    element_position = args[0].find_index(args[1])
  end
end
