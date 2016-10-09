module Quaker
  class TagFilter
    def dependencies services_map, name
      spec = services_map[name]
      depends_on = spec["depends_on"] || []
      links = (spec["links"] || []).map{|l| l.split(':')[0]}
      deps = links + depends_on
      deps + deps.map{|d| dependencies(services_map, d)}.flatten
    end

    def is_tagged_service spec, tags_list
      svc_tags = spec.delete("tags") || []

      # Skip service if no common tags
      common = svc_tags & tags_list
      common && !common.empty?
    end

    def filter services_map, tags_list
      return services_map if !tags_list || tags_list.empty?

      services_map.inject({}){|acc, (name, spec)|
        if is_tagged_service(spec, tags_list)
          acc[name] = spec

          dependencies(services_map, name)
            .inject(acc){|acc, d| acc.update(d => services_map[d])}
        end

        acc
      }
    end
  end
end
