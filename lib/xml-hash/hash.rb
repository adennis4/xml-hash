require "xml/libxml"

class Hash
  def self.from_libxml(text, options={})
    {:default_keep_blanks => false}.merge(options).each do |k,v|
      XML.send("#{k}=", v)
    end

    doc = XML::Parser.string(text).parse
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
            hash_map[node_key] = child.content
          end
        end
      end

    end
  end
end
