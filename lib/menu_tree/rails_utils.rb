module MenuTree
  module RailsUtils
    def self.reload_menu_if_file_changed
      return unless defined?(Rails)
      return unless Rails.env.development? || Rails.env.test?

      @menu_tree_reloader ||= ActiveSupport::FileUpdateChecker.new( MenuTree.menu_tree_path ) do
        MenuTree.reload!
      end
      @menu_tree_reloader.execute_if_updated
    end

    def self.set_rails_routes_once
      return unless defined?(Rails)

      MenuTree.configure do |config|
        config.routes = Rails.application.routes
      end
    end

    def self.include_routes_helper_once
      return unless defined?(Rails)
      return if @routes_helper_included

      MenuTree::Base.send(:include, Rails.application.routes.url_helpers)
      @routes_helper_included = true
    end
  end
end