require 'rubygems'
require 'xml'

input_file = ARGV[0]
output_file = ARGV[1]
root_node = ARGV[2]
document = XML::Document.new
document.root = XML::Node.new(root_node)

def process_hierarchy(root,hierarchy)
	hierarchy.each do |node_name|
		if(/^\d+$/ =~ node_name)
		     node_name = '_'+node_name
		end
		child = node.children.detect{ |child| child.name == node_name}
		if( child == nil)
		   child = XML::Node.new(node_name) if child == nil
		   root << child
		end
		root = child		
	end
	return root
end

def xml_value_of(value)
	XML::Node.new_text(value == nil ? '' : value)
end

File.open(input_file,'r') do |file|
	file.each_line do |line|
		next if line == nil or line.strip.size == 0 or line.strip.start_with?('#')
		key,value = line.split('=')
		node = document.root
		hierarchy = key.split('.')
		node = process_hierarchy(node,hierarchy)
		node << xml_value_of(value)
	end
end

File.open(output_file,'w') do |file|
    file.write(document.to_s)
end
