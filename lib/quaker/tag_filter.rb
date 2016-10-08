class TagFilter
  def dependencies services_map, name
    spec = services_map[name]
    deps = (spec["depends_on"] || []) + (spec["links"] || []).map{|l| l.split(':')[0]}
    deps + deps.map{|d| dependencies(services_map, d)}.flatten
  end

  def filter services_map, tags_list
    return services_map if !tags_list || tags_list.empty?

    services_map.inject({}){|acc, (name, spec)|
      puts "#{name} => #{spec}"
      svc_tags = spec["tags"] || []
      spec.delete("tags")
      common = svc_tags & tags_list
      if common && !common.empty?
        acc[name] = spec

        deps = dependencies(services_map, name) || []
        deps
          .select {|d| !acc.has_key?(d)}
          .each{|d| acc[d] = services_map[d]}
      end

      acc
    }
  end
end
