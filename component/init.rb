#encoding: windows-31j

require "fileutils"
require_relative "account_info"

def init
  account = account_info[:account]
  FileUtils.mkdir(__dir__ + "/../tmp") rescue nil
  FileUtils.mkdir(__dir__ + "/../data") rescue nil
  FileUtils.mkdir(__dir__ + "/../sale") rescue nil
  FileUtils.mkdir(__dir__ + "/../sent") rescue nil
  FileUtils.touch(__dir__ + "/../sale/#{account}_sale.csv")
  FileUtils.touch(__dir__ + "/../data/comment_#{account}.csv")
  FileUtils.touch(__dir__ + "/../data/new_order_#{account}.csv")
  FileUtils.touch(__dir__ + "/../data/prepare_#{account}.csv")
  FileUtils.touch(__dir__ + "/../data/untreat_#{account}.txt")
end
