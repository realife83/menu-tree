module MenuTree
  module Configuration
    class << self
      attr_accessor :routes
    end

    def self.menu_tree_path
      if @menu_tree_path.blank?
        @menu_tree_path = Array( Rails.root.join('config', 'initializers', 'menu_tree.rb').to_s )
      else
        @menu_tree_path
      end
    end

    def self.menu_tree_path=(path)
      @menu_tree_path = Array( path )
    end

    def self.configure
      yield self
    end
  end
end