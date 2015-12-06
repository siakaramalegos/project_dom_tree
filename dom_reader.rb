require_relative 'tree'
require 'pry'

class DOMReader
  attr_reader :head

  def build_tree(file)
    file_string = minimize(file)
    tree = tree_builder(file_string)
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

  def get_next_tag(file_string, index)

  end

  # go through file string grabbing each tag and building a node for it, then grab sub-tags and building a node for them (DFS-like), cleaning up on way back up.
  # Put the root node on the stack.

  # TODO: skip if tag is doctype declaration
  def tree_builder(file_string)
    # Get initial tag info
    tag = parse_tag(file_string)
    closing_tag = "</#{tag[:tag]}>"
    tag_content = get_tag_content(tag, closing_tag, file_string)

    # TODO: get text content

    # Node = Struct.new(:tag, :text, :classes, :id, :children, :parent)
    start_node = Node.new(tag[:tag], nil, tag[:classes], tag[:id], [])
    @head = start_node
    stack = [ start_node ]

    # process innards of tag (add to stack) recursively
    add_leaves(stack, tag_content)
  end

  def add_leaves(stack, tag_content)
    loop do
      # stop when tag_content nil or no sub-tags
      break if tag_content.nil?

      current_node = stack.pop

      # child loop
      loop do
        # Get children
        tag = parse_tag(tag_content)
        break if tag.nil?

        closing_tag = "</#{tag[:tag]}>"
        # TODO: allow for embedded duplicate tags
        new_tag_content = get_tag_content(tag, closing_tag, tag_content)
        # TODO: get text content
        child_node = Node.new(tag[:tag], nil, tag[:classes], tag[:id], [], current_node)
        current_node.children << child_node

        # Put child on the stack and recursively build descendants
        stack << child_node
        add_leaves(stack, new_tag_content)

        # Process next piece of content string, if any left
        end_location = tag_content.index(closing_tag) + closing_tag.length
        if end_location < tag_content.length
          tag_content = tag_content[end_location..-1]
        else
          break
        end
      end

      break if stack.empty?
    end
    #   if [current_node.x, current_node.y] == end_coords
    #     return output_results(current_node, count, 'DFS', render_output)
    #   else
    #     edges = @edge_list.edge_list.select{|pair| pair[0] == current_node}
    #     edges.each do |edge|
    #       neighbor = edge[1]

    #       neighbor.distance = current_node.distance + 1
    #       neighbor.predecessor = current_node
    #       stack << neighbor
    #     end
    #   end

  end

  # Provides content between the open and close tag which becomes new string for recursively building tree
  def get_tag_content(tag, closing_tag, content_string)
    if match = (/>(.*?)#{Regexp.quote(closing_tag)}/).match(content_string)
      tag_content = get_captures(match)
    end
    tag_content ? tag_content : nil
  end

  def parse_tag(tag_string)
    tag = {}

    # Grab just the first tag
    if match = (/<(.*?)>/).match(tag_string)
      first_tag = get_captures(match)

      return nil if first_tag.nil?

      unless first_tag.include?(' ')
        tag[:tag] = first_tag
      else
        tag[:tag] = first_tag.split(' ').first

        if match = (/class='(.*?)'|class="(.*?)"/).match(first_tag)
          tag[:classes] = get_captures(match).split(' ')
        end
        if match = (/id='(.*?)'|id="(.*?)"/).match(first_tag)
          tag[:id] = get_captures(match)
        end
        if match = (/name='(.*?)'|name="(.*?)"/).match(first_tag)
          tag[:name] = get_captures(match)
        end
      end
    else
      return nil
    end

    tag
  end

  def get_captures(matches)
    matches.captures.select{ |match| match != nil }[0]
  end

end

reader = DOMReader.new
tree = reader.build_tree("test_basic.html")
binding.pry
puts reader.head
puts tree

# tag = parse_tag("<p class='foo bar' id='baz' name='fozzie'>")
