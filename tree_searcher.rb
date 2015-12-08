require_relative 'dom_reader'
require_relative 'node_renderer'

class TreeSearcher

  def initialize(tree)
    @tree = tree
  end

  # Search for and return a collection with all nodes exactly matching the name, text, id, or class
  def search_by(attribute, value)
    @search_by_results = []
    # search_params = get_search_params(attribute, value)
    @search_by_results = get_search_by(attribute, value, @tree)

    if @search_by_results.empty?
      puts "I'm sorry, didn't find anything with #{attribute} equal to #{value}."
    end

    @search_by_results
  end

  private

  def get_search_by(attribute, value, node)
    # If node is match, put it in the results
    if (attribute == :classes || attribute == :text) && node[attribute]
      @search_by_results << node if node[attribute].include?(value)
    else
      @search_by_results << node if node[attribute] == value
    end

    # Look at children
    if node.children.nil? || node.children.empty?
      return @search_by_results
    else
      node.children.each do |child|
        get_search_by(attribute, value, child)
      end
    end

    @search_by_results
  end
end

reader = DOMReader.new
tree = reader.build_tree("test.html")
renderer = NodeRenderer.new(tree)
searcher = TreeSearcher.new(tree)
searcher.search_by(:classes, "sidebar").each { |node| renderer.render(node) }
searcher.search_by(:classes, "bold").each { |node| renderer.render(node) }
searcher.search_by(:tag, "div").each { |node| renderer.render(node) }
searcher.search_by(:text, "div").each { |node| renderer.render(node) }