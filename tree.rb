require 'pry'

Node = Struct.new(:tag, :text, :classes, :id, :children, :parent)

class Tree
  attr_reader :head

  def initialize(first_node = nil)
    @head = first_node
  end

  def add_first_node(tag, text = nil, classes = nil, id = nil)
    @head = Node.new(tag, text, classes, id, [])
    @head
  end

  def add_node_to_children(tag, parent = nil, text = nil, classes = nil, id = nil)
    if @head.nil?
      new_node = add_first_node(tag, text, classes, id)
    else
      new_node = Node.new(tag, text, classes, id, [], parent)
      parent.children << new_node if parent
    end
    new_node
  end

  # # O(n) since must crawl through each item
  # def add_node_at_index(tag, text = nil, index)
  #   counter = 0
  #   current_node = @head
  #   prev_node = nil

  #   # crawl to index to set both prev_node and current_node
  #   while counter < index
  #     prev_node = current_node
  #     current_node = current_node.children
  #     counter += 1
  #   end

  #   # add the new node
  #   new_node = Node.new(tag, text)
  #   prev_node.children = new_node
  #   new_node.children = current_node

  # end

  # No error handling
  # def find_node(index)
  #   counter = 0
  #   current_node = @head

  #   while counter < index
  #     current_node = current_node.children
  #     counter += 1
  #   end

  #   current_node
  # end

  # def get_text(lookup_tag)
  #   counter = 0
  #   size = self.length
  #   current_node = @head

  #   while counter < size
  #     if current_node.tag == lookup_tag
  #       puts "#{lookup_tag}: #{current_node.text}, #{counter} steps"
  #       return current_node.text
  #     else
  #       current_node = current_node.children
  #       counter += 1
  #     end
  #   end

  #   puts "I'm sorry, didn't find '#{lookup_tag}' in the current dictionary. #{counter} steps."
  # end

  # def length
  #   counter = 1
  #   current_node = @head
  #   while current_node != @last
  #     current_node = current_node.children
  #     counter += 1
  #   end
  #   # puts "Length is #{counter}."
  #   counter
  # end
end

# x = Tree.new
# y = x.add_node_to_children('html', nil)
# z = x.add_node_to_children('head', y)
# zz = x.add_node_to_children('body', y)

