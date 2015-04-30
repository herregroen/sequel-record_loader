require 'yaml'
require 'json'

require "sequel/record_loader/version"

module Sequel
  module RecordLoader
    def self.load file=nil
      file = 'db/records.json' if file.nil? and File.exists? 'db/records.json'
      file = 'db/records.yaml' if file.nil? and File.exists? 'db/records.yaml'

      throw "Sequel::RecordLoader - No valid file supplied: #{file}"  unless file and File.exists?(file)
      data = case file.split('.').last
        when 'json'        then JSON.parse(File.read(file))
        when 'yaml', 'yml' then YAML.load(File.read(file))
      end
      throw "Sequel::RecordLoader - Invalid file format: #{file}"  unless data

      data.each do |klass, items|
        klass = klass.split('::').inject(Object) {|o,c| o.const_get c}
        items.each do |item|
          if model = klass[item['where']]
            model.update_all item['attributes']
          else
            klass.create item['attributes'].merge(item['where'].is_a?(Hash) ? item['where'] : {})
          end
        end
      end
    end
  end
end
