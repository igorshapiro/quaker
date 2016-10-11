require 'quaker/tag_matcher'
require 'quaker/errors'

module Quaker
  class DependencyResolveError < StandardError
  end

  class TagFilter
    def dependencies services_map, name
      spec = services_map[name]
      raise MissingServiceError, name unless spec

      depends_on = spec["depends_on"] || []
      links = (spec["links"] || []).map{|l| l.split(':')[0]}
      deps = links + depends_on
      begin
        deps + deps.map{|d| dependencies(services_map, d)}.flatten
      rescue MissingServiceError => ex
        msg = "Error resolving dependency #{ex.message} " +
          "for service #{name}"
        raise DependencyResolveError, msg
      end
    end

    def is_tagged_service spec, tags_list
      svc_tags = spec.delete('tags') || []
      TagMatcher.match svc_tags, tags_list
    end

    def filter services_map, tags_list
      return services_map if !tags_list || tags_list.empty?

      services_map.inject({}){|acc, (name, spec)|
        if is_tagged_service(spec, tags_list)
          acc[name] = spec

          dependencies(services_map, name)
            .inject(acc){|_acc, d| _acc.update(d => services_map[d])}
        end

        acc
      }
    end
  end
end
