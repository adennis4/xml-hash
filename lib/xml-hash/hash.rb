require "xml/libxml"
require "ap"

class Hash
  def self.from_libxml(text, options={})
    {:default_keep_blanks => false}.merge(options).each do |k,v|
      XML.send("#{k}=", v)
    end

    doc = XML::Parser.string(text).parse
#    {snakecase(doc.root.name).to_sym => recursively_walk(doc.root)}
    recursively_show(doc.root, hash = {})
    hash
  end

  def self.snakecase(string)
    string.split(/(?=[A-Z])/).map(&:downcase).join("_")
  end

  def self.symbolize(input)
    input.reduce({}) do |collection, hash|
      collection[hash.first.to_sym] = hash.last.is_a?(Hash) ? symbolize(hash.last) : hash.last
      collection
    end
  end

  def self.recursively_show(node, hash_map)
    unless node.comment?
      node_key = snakecase(node.name).to_sym
      hash_map[node_key] = []

      symbolize(node.attributes.to_h).each do |k,v|
        hash_map[node_key] << {k => v}
      end

      node.each_child do |child|
        child_key = snakecase(child.name).to_sym

        unless child.comment?
          if child.element?

            child_hash = {}
            hash_map[node_key] << child_hash
            recursively_show(child, child_hash)

          else

            hash_map[node_key] << {node_key => child.content}

          end
        end
      end

    end
  end

  def self.recursively_walk(node)
    node_key = snakecase(node.name).to_sym
    node_array = []
    node_response = {node_key => []}

    node.each_child do |child|
      response = node_response[node_key]

      if child.comment?
      elsif child.element?
        key = snakecase(child.name).to_sym

        if response[key]
          if response[key].is_a?(Object::Array)
            response[key] << recursively_walk(child)
          else
            response[key] = [response[key]] << recursively_walk(child)
          end
        else
          response[key] = recursively_walk(child)
        end
      else
        if node.attributes.to_h.empty?
          return child.content
        else
          response = {:value => child.content}.merge(symbolize(node.attributes.to_h))
        end
      end
    end

    node_response[node_key].merge!(symbolize(node.attributes.to_h)) unless node.attributes.to_h.empty?

puts "node_response: #{node_response.inspect}"

    node_response[node_key]
  end

  def add_attributes(node, attributes)
    node.merge!(attributes)
  end
end
