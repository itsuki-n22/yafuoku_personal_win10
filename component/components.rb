#encoding: windows-31j
require "selenium-webdriver"
require 'date'
require 'time'
require 'csv'
Dir.glob(__dir__ + "/*").each{|f| require_relative f unless f =~ %r{/components.rb} || f =~ %r{.rb.+} }

