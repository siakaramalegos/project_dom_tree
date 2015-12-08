require_relative 'dom_reader'
require_relative 'node_renderer'

class TreeSearcher

  def initialize(tree)
    @tree = tree
  end

  # Search for and return a collection with all nodes exactly matching the name, text, id, or class
  def search_by(attribute, value)
    @search_results = []
    # search_params = get_search_params(attribute, value)
    @search_results = get_search_by(attribute, value, @tree)

    if @search_results.empty?
      puts "I'm sorry, didn't find anything with #{attribute} equal to #{value}."
    end

    @search_results
  end

  def search_descendants(node, attribute, value)
    @search_results = []
    @search_results = get_search_by(attribute, value, node)
    if @search_results.empty?
      puts "I'm sorry, didn't find anything with #{attribute} equal to #{value}."
    end
    @search_results
  end

  def search_ancestors(node, attribute, value)
    @search_results = []
    @search_results = get_ancestor_search(attribute, value, node)
    if @search_results.empty?
      puts "I'm sorry, didn't find anything with #{attribute} equal to #{value}."
    end
    @search_results
  end

  private

  def get_ancestor_search(attribute, value, node)
    # If node is match, put it in the results
    if node[attribute]
      if attribute == :classes || attribute == :text
        @search_results << node if node[attribute].include?(value)
      else
        @search_results << node if node[attribute] == value
      end
    end

    # Look at parent
    if node.parent.nil?
      return @search_results
    else
      get_ancestor_search(attribute, value, node.parent)
    end

    @search_results
  end

  def get_search_by(attribute, value, node)
    # If node is match, put it in the results
    if node[attribute]
      if attribute == :classes || attribute == :text
        @search_results << node if node[attribute].include?(value)
      else
        @search_results << node if node[attribute] == value
      end
    end

    # Look at children
    if node.children.nil? || node.children.empty?
      return @search_results
    else
      node.children.each do |child|
        get_search_by(attribute, value, child)
      end
    end

    @search_results
  end
end

reader = DOMReader.new
tree = reader.build_tree("test.html")
renderer = NodeRenderer.new(tree)
searcher = TreeSearcher.new(tree)
# searcher.search_by(:classes, "sidebar").each { |node| renderer.render(node) }
# searcher.search_by(:tag, "div").each { |node| renderer.render(node) }
# searcher.search_by(:text, "div").each { |node| renderer.render(node) }
my_node = searcher.search_by(:id, "main-area")
my_node.each { |node| renderer.render(node) }
# descendants = searcher.search_descendants(my_node[0], :tag, "li")
# descendants.each { |node| renderer.render(node) }
searcher.search_ancestors(my_node[0], :tag, "body").each { |node| renderer.render(node) }
