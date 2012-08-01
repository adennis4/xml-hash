require "xml/libxml"

class Hash
  def self.from_libxml(text, options={})
    {:default_keep_blanks => false}.merge(options).each do |k,v|
      XML.send("#{k}=", v)
    end

    doc = XML::Parser.string(text).parse
    {snakecase(doc.root.name).to_sym => recursively_walk(doc.root)}
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

  def self.recursively_walk(node)
    response = {}

    node.each_child do |child|
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

    response
  end
end