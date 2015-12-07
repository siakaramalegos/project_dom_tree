require_relative 'tree'
require 'pry'

class DOMReader
  attr_reader :head

  def build_tree(file)
    file_string = minimize(file)
    tree_builder(file_string)
  end

  private

  def minimize(file)
    file_string = ''
    File.readlines(file).each do |line|
      file_string += line.strip
    end
    file_string
  end

  # TODO: skip if tag is doctype declaration
  # Go through file string grabbing each tag and building a node for it, then grab sub-tags and building a node for them (DFS-like), cleaning up on way back up.
  def tree_builder(file_string)
    # Put the root node on the stack.
    tag = parse_tag(file_string)
    start_node = Node.new(tag[:tag], nil, tag[:classes], tag[:id], [])
    @head = start_node
    stack = [ start_node ]

    # process remaining content
    @tag_content = remove_tag(file_string)
    add_leaves(stack)
  end

  def add_leaves(stack)
    loop do
      current_node = stack.pop

      # Build children of current node
      loop do
        next_content_type = get_next_type(@tag_content)
        # binding.pry
        case next_content_type
        when 'text'
          text = @tag_content.match(/(.*?)</).captures[0]
          child_node = Node.new(nil, text, nil, nil, nil, current_node)
          current_node.children << child_node

          # No children to build, but need to change tag content to remove leading text
          @tag_content = remove_leading_text(@tag_content)
        when 'close tag'
          @tag_content = remove_tag(@tag_content)
          break
        when 'open tag'
          tag = parse_tag(@tag_content)
          child_node = Node.new(tag[:tag], nil, tag[:classes], tag[:id], [], current_node)
          current_node.children << child_node

          # Put child on the stack and recursively build descendants
          stack << child_node
          @tag_content = remove_tag(@tag_content)
          add_leaves(stack)
        end
      end

      break if stack.empty?
    end
  end

  def remove_leading_text(tag_content)
    '<' + tag_content.match(/<(.*?)$/).captures[0]
  end

  def remove_tag(tag_content)
    tag_content.match(/>(.*?)$/).captures[0]
  end

  def get_next_type(tag_content)
    if tag_content[0..1].match(/<\//)
      'close tag'
    elsif tag_content[0].match(/</)
      'open tag'
    else
      'text'
    end
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
tree = reader.build_tree("test.html")
binding.pry
puts reader.head
