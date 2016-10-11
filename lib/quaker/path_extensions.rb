module Quaker
  class PathExtensions
    def expand_path volumes_desc, build_path
      parts = volumes_desc.split(':')
      parts[0].gsub!(/^\~/, build_path)
      parts.join(':')
    end

    def expand_service_volumes spec
      build_path = spec['build']
      return unless build_path

      volumes = spec['volumes']
      return unless volumes

      spec['volumes'] = volumes.map{|v| expand_path(v, build_path) }
    end

    def expand services
      services.each {|_name, spec| expand_service_volumes(spec) }
    end
  end
end
