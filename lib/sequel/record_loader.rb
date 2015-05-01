require 'yaml'
require 'json'

require "sequel/record_loader/version"

module Sequel
  module RecordLoader
    def self.load file=nil
      file = 'db/records.json' if file.nil? and File.exists? 'db/records.json'
      file = 'db/records.yaml' if file.nil? and File.exists? 'db/records.yaml'

      raise "Sequel::RecordLoader - No valid file supplied: #{file}"  unless file and File.exists?(file)
      data = case file.split('.').last
        when 'json'        then JSON.parse(File.read(file))
        when 'yaml', 'yml' then YAML.load(File.read(file))
      end
      raise "Sequel::RecordLoader - Invalid file format: #{file}"  unless data

      data.each do |klass, items|
        klass = klass.split('::').inject(Object) {|o,c| o.const_get c}
        items.each do |item|
          if model = find_record klass, item['where']
            model.update_all item['attributes']
          else
            klass.create item['attributes'].merge(item['where'].is_a?(Hash) ? item['where'] : {})
          end
        end # items.each
      end # data.each
      data.each do |klass, items|
        klass = klass.split('::').inject(Object) {|o,c| o.const_get c}
        items.each do |item|
          model = find_record klass, item['where']
          item['associations'].each do |association, records|
            refl  = model.association_reflection(association.to_sym)
            other = refl[:class_name].split('::').inject(Object) {|o,c| o.const_get c}
            if relf[:cartesian_product_number] == 0
              if m = find_record other, records
                model.send(refl.setter_method, m)
              end
            else
              records.each do |record|
                if m = find_record(k, record) and not model.send(refl.dataset_method)[m[m.primary_key]]
                  model.send(refl.add_method, m)
                end
              end # records.each
            end # if r[:cartesian_product_number] == 0
          end # item['associations'].each
        end # items.each
      end # data.each
    end # self.load

    private

    def self.find_record klass, where
      return case where
        when Hash            then klass[Hash[where.map{ |k,v| [k.to_sym, v] }]]
        when Integer, String then klass[where]
        else raise "Sequel::RecordLoader - Invalid where: #{where}"
      end
    end
  end
end
