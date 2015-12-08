require_relative 'dom_reader'

class NodeRenderer

  def initialize(tree)
    @tree = tree
  end

  def render(node = @tree)
    puts "-----------------------------------"
    puts "    Statistics for Tree or Node"
    puts "-----------------------------------"
    if node.tag
      node.classes ? classes = node.classes.join(' ') : classes = 'none'
      node.id ? id = node.id : id = 'none'
      puts "Tag: #{node.tag}, Classes: #{classes}, ID: #{id}"

      # Total nodes and types in sub-tree
      @type_counts = {tag: 0, text: 0}
      @type_counts = get_size_by_type(node)

      puts "Total Nodes: #{@type_counts[:tag] + @type_counts[:text]}"
      puts "  Tags: #{@type_counts[:tag]}"
      puts "  Text: #{@type_counts[:text]}"
    else
      puts "Text: #{node.text}"
    end
  end

  def get_size_by_type(node)
    current_node = node
    if current_node.children.nil? || current_node.children.empty?
      return @type_counts
    else
      current_node.children.each do |child|
        if child.tag
          @type_counts[:tag] += 1
        else
          @type_counts[:text] += 1
        end
        get_size_by_type(child)
      end
    end

    @type_counts
  end
end

reader = DOMReader.new
tree = reader.build_tree("test.html")
renderer = NodeRenderer.new(tree)
renderer.render()