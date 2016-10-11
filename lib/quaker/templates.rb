require 'quaker/tag_matcher'
require 'deep_merge'

module Quaker
  class Templates
    def apply services
      templates = services.select {|name, v| template?(name)}
      services
        .reject {|name, v| template?(name)}
        .inject({}) {|acc, (name, spec)|
          acc.update(name => extend_with_matching_templates(spec, templates))
        }
    end

    def extend_with_matching_templates service, templates
      templates
        .select {|name, spec| Quaker::TagMatcher::match(service["tags"], spec["tags"])}
        .inject(service) {|svc, (_, spec)|
          filtered_template_content = spec
            .select{|name, spec| name != 'tags' }
          svc.deep_merge(filtered_template_content)
        }
    end

    def template?(k)
      !!(k =~ /_template$/)
    end
  end
end
