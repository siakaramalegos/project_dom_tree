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

  def build_file(file_name)
    @lines = []
    html_lines = get_html_lines(@tree, 0)

    File.open(file_name, 'w') do |file|
      file.write html_lines.join("\n")
    end

    puts "Saved successfully!"
  end

  private

  def get_html_lines(node, depth)
    @lines << parse_node(node, depth)
    if node.children.nil? || node.children.empty?
      return @lines
    else
      node.children.each do |child|
        get_html_lines(child, depth + 1)
      end
      @lines << "#{' ' * 2 * depth}</#{node.tag}>"
    end
    @lines
  end

  def parse_node(node, depth)
    spaces = ' ' * 2 * depth
    if node.text
      spaces + node.text
    else
      buffer = ''

      if node.classes
        classes = " class='#{node.classes.join(' ')}'"
        buffer = ' ' if node.id
      else
        classes = ''
      end

      node.id ? id = " id='#{node.id}'" : id = ''

      "#{spaces}<#{node.tag}#{id}#{buffer}#{classes}>"
    end
  end

  def get_size_by_type(node)
    if node.children.nil? || node.children.empty?
      return @type_counts
    else
      node.children.each do |child|
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
renderer.build_file("build.html")