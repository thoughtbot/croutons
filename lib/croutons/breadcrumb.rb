module Croutons
  class Breadcrumb
    attr_reader :label, :url

    def initialize(label, url = nil)
      self.label = label
      self.url = url
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

    attr_writer :label, :url
  end
end
