require_relative 'tree'
require 'pry'

class DOMReader

  def build_tree(file)
    file_string = minimize(file)
    file_string
  end

  private

  def minimize(file)
    file_string = ''
    File.readlines(file).each do |line|
      file_string += line.strip
    end
    file_string
  end
end

reader = DOMReader.new
tree = reader.build_tree("test.html")
puts tree