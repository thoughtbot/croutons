module Croutons
  class Breadcrumb
    attr_reader :label, :url, :link_attributes

    def initialize(label, url = nil, link_attributes = {})
      self.label = label
      self.url = url
      self.link_attributes = link_attributes
    end

    def labelize
      self.url = nil
    end

    def link?
      url.present?
    end

    def ==(other)
      label == other.label && url == other.url
    end

    private

    attr_writer :label, :url, :link_attributes
  end
end
