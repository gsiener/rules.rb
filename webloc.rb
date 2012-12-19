require 'xml/libxml'
class Webloc
  attr_accessor :title, :url
  
  def initialize(file)
    @title = File.basename(file, ".webloc")
    doc = XML::Parser.file(file).parse
    @url = doc.find_first("//string").content
  end

end