require 'yaml'
require 'logger'
require 'fileutils'
require 'filewatcher'
require 'tinify'
require 'image_size'
require_relative './image_formatter/image_formatter'

$logger = Logger.new('tmp/log.txt')

def log(message)
  $logger.debug(message)
  puts message
end
