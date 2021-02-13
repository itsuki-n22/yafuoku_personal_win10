#encoding: windows-31j

def read_message_files
  hash = {}
  Dir.glob(__dir__ + "/../message/*").each do |file|
    name = file.split("/").last.split(".").first
    hash[ name.to_sym ] = File.open(file).read
  end
  hash
end
