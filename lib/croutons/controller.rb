module Croutons
  module Controller
    def self.included(controller)
      controller.helper_method(:breadcrumbs)
      controller.helper_method(:last_breadcrumb)
      controller.helper_method(:breadcrumb_trail)
    end

    def render_to_body(options)
      @_template = options[:template]
      @_prefixes = options[:prefixes]
      super
    end

    private

    def breadcrumbs(objects = {})
      render_to_string(
        partial: 'breadcrumbs/breadcrumbs',
        locals: { breadcrumbs: breadcrumb_trail(objects) },
      )
    end

    def last_breadcrumb
      breadcrumb_trail.last
    end

    def breadcrumb_trail(objects = {})
      @breadcrumb_trail ||= begin
        return [] unless @_template.present?

        template = lookup_context.find_template(@_template, @_prefixes)
        template_identifier = template.virtual_path.gsub('/', '_')
        objects.reverse_merge!(view_assigns)
        objects[:params] = params
        breadcrumb_trail_class.breadcrumbs(template_identifier, objects)
      end
    end

    def breadcrumb_trail_class
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
