$LOAD_PATH << ARGV[0]

require 'lib/color'
require 'lib/const'
require 'lib/package'

pkg = Package.load_package("#{ARGV[0]}/#{ARGV[1]}.rb")


