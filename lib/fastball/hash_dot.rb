module Fastball

  # A utility class to allow referencing nested hash values as chained method calls.
  #
  # == Example
  #
  #     !!!
  #     ruby> h = Fastball::HashDot.new contact: { name: 'Jordan', state: 'Texas' }
  #     ruby> h.contact.name
  #      => "Jordan"
  #     ruby> h.contact.state
  #      => "Texas"
  #
  class HashDot

    def initialize(hash={})
      @hash = {}
      @missing_items = []

      hash.map do |k, v|
        @hash[k.to_s] = if v.kind_of?(Hash)
          self.class.new v
        else
          @hash[k.to_s] = v
        end
      end
    end

    def missing_items
      @missing_items
    end

    private

    def method_missing(method_name, *args, &block)
      return @hash[method_name.to_s] if @hash.include?(method_name.to_s)

      @missing_items << method_name.to_s unless @missing_items.include?(method_name.to_s)
      return nil
    end

    def respond_to_missing?(method_name, include_private=false)
      @hash.key?(method_name.to_s) || super
    end

  end
end
