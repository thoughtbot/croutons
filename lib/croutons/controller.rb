module Croutons
  module Controller
    def self.included(controller)
      controller.helper_method(:breadcrumbs)
    end

    def render_to_body(options)
      @_template = options[:template]
      @_prefixes = options[:prefixes]
      super
    end

    private

    def breadcrumbs(objects = {})
      template = lookup_context.find_template(@_template, @_prefixes)
      template_identifier = template.virtual_path.gsub('/', '_')
      objects.reverse_merge!(view_assigns)
      objects[:params] = params
      breadcrumbs = breadcrumb_trail.breadcrumbs(template_identifier, objects)
      render_to_string(
        partial: 'breadcrumbs/breadcrumbs',
        locals: { breadcrumbs: breadcrumbs },
      )
    end

    def breadcrumb_trail
      ::BreadcrumbTrail
    rescue NameError
      raise NotImplementedError,
        'Define a `BreadcrumbTrail` class that inherits from '\
        '`Breadcrumbs::BreadcrumbTrail`, or override the '\
        '`breadcrumb_trail` method in your controller so that it '\
        'returns an object that responds to `#breadcrumbs`.'
    end
  end
end
