module RailsViewAnnotator
  def self.augment_partial_renderer klass
    render = klass.instance_method :render
    klass.send(:define_method, :render) do |*args|
      inner = render.bind(self).call(*args)
      short_identifier = Pathname.new(identifier).relative_path_from Rails.root
      "<!-- begin: #{short_identifier} -->#{inner}<!-- end: #{short_identifier} -->".html_safe
    end
    klass.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def identifier
      (@template = find_partial) ? @template.identifier : @path
    end
  end
end