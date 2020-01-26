class Node
  include Comparable

  attr_accessor :left_child, :right_child, :data

  def initialize(data = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(other)
    self.data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array[0]) if array.length < 2

    array.sort!.uniq!
    mid = array.length / 2
    root = Node.new(array[mid])
    root.left_child = build_tree(array[0...mid])
    root.right_child = build_tree(array[mid + 1..-1])
    return root
  end

  def insert(value, root = @root)
    raise StandardError.new("Value already exists") if root.data == value
    temp = value > root.data ? root.right_child : root.left_child
    if !temp.left_child && value < temp.data
      temp.left_child = Node.new(value)
    elsif !temp.right_child && value > temp.data
      temp.right_child = Node.new(value)
    else
      insert(value, temp)
    end
  end

  def delete(value, root = @root)
    if root.nil?
      root
    elsif value < root.data
      root.left_child = delete(value, root.left_child)
    elsif value > root.data
      root.right_child = delete(value, root.right_child)
    else
      if root.left_child.nil? && root.right_child.nil?
        root = nil
      elsif root.left_child.nil?
        root = root.right_child
      elsif root.right_child.nil?
        root = root.left_child
      else
        temp = find_min(root.right_child)
        root.data = temp.data
        root.right_child = delete(temp.data, root.right_child)
      end
    end
    root
  end

  def find_min(root = @root)
    current_node = root
    current_node.left_child.nil? ? current_node : find_min(current_node.left_child)
  end

  def find(value, root = @root)
    if value < root.data
      find(value, root.left_child)
    elsif value > root.data
      find(value, root.right_child)
    else
      root
    end
  end

  def level_order(root = @root, &block)
    if root.nil?
      return
    end

    queue = Queue.new
    queue << root

    while !queue.empty?
      current_node = queue.pop
      yield (current_node.data)
      if !current_node.left_child.nil?
        queue << current_node.left_child
      end
      if !current_node.right_child.nil?
        queue << current_node.right_child
      end
    end
  end

  def inorder(root = @root, &block)
    if root.nil?
      return
    end

    inorder(root.left_child, &block)
    yield (root.data)
    inorder(root.right_child, &block)
  end

  def preorder(root = @root, &block)
    if root.nil?
      return
    end

    yield (root.data)
    preorder(root.left_child, &block)
    preorder(root.right_child, &block)
  end

  def postorder(root = @root, &block)
    return if root.nil?

    postorder(root.left_child, &block)
    postorder(root.right_child, &block)
    yield (root.data)
  end

  def depth(node = @root)
    if node.nil?
      return -1
    end

    left_depth = depth(node.left_child)

    right_depth = depth(node.right_child)

    if left_depth > right_depth
      return left_depth + 1
    else
      return right_depth + 1
    end
  end

  def balanced?(node = @root)
    if node.nil?
      return
    end

    left_depth = depth(node.left_child)

    right_depth = depth(node.right_child)

    if (left_depth - right_depth).abs > 1
      false
    else
      true
    end
  end

  def rebalance!
    new_array = []
    self.level_order { |node| new_array << node }

    initialize(new_array)
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })

while !tree.balanced?
  tree = Tree.new(Array.new(15) { rand(1..100) })
  tree.rebalance!
end

puts "Is the Tree Balanced?: #{tree.balanced?}"
puts "\n"

puts "The Tree in Level Order is: "
tree.level_order { |node| print "#{node} -> " }
puts "\n"
puts "The Tree in In Order is: "
tree.inorder { |node| print "#{node} -> " }
puts "\n"
puts "The Tree in Pre Order is: "
tree.preorder { |node| print "#{node} -> " }
puts "\n"
puts "The Tree in Post Order is: "
tree.postorder { |node| print "#{node} -> " }
puts "\n\n"
puts "The Tree Depth is: #{tree.depth}"
puts "\n"
puts "Is the Tree Balanced?: #{tree.balanced?}"

test_array = Array.new(5) { rand(100..200) }

test_array.each { |number| tree.insert(number) }

while tree.balanced?
  test_array.each { |number| tree.delete(number) }
  test_array = Array.new(5) { rand(100..200) }
  test_array.each { |number| tree.insert(number) }
end

puts "\n"
puts "We have added 5 numbers to the array and unbalanced the tree"
puts "Is the Tree Balanced?: #{tree.balanced?}"
puts "\n"
tree.rebalance!
puts "Is the Tree Balanced?: #{tree.balanced?}"
puts "\n"

puts "The Tree in Level Order is: "
tree.level_order { |node| print "#{node} -> " }
puts "\n"
puts "The Tree in In Order is: "
tree.inorder { |node| print "#{node} -> " }
puts "\n"
puts "The Tree in Pre Order is: "
tree.preorder { |node| print "#{node} -> " }
puts "\n"
puts "The Tree in Post Order is: "
tree.postorder { |node| print "#{node} -> " }
puts "\n\n"
puts "The Tree Depth is: #{tree.depth}"
puts "\n"
puts "Is the Tree Balanced?: #{tree.balanced?}"
