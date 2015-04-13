module MenuTree

  class Menu
    include Enumerable
    attr_reader :name, :key, :path, :children
    attr_accessor :parent

    delegate :each, :[], :last, :add, :<<, to: :children

    def initialize(opts={})
      @name     = opts.fetch(:name)
      @key      = opts.fetch(:key, '')
      @path     = opts.fetch(:path, '#')
      @children = []
    end

    def to_h
      { name: name, path: path, children: children.map(&:to_h) }
    end

    def have_children?
      children.count > 0
    end

    def include?(menu)
      search_by_menu(menu).present?
    end

    def search_by_menu(menu_to_find)
      search { |menu| menu == menu_to_find }
    end

    def search_by_name(name)
      search { |menu| menu.name == name }
    end

    def search_by_key(key)
      search { |menu| menu.key == key }
    end

    def search_by_path(path)
      route_opts = routes.recognize_path(path)
      options    = route_opts.slice(:controller, :action)

      found_menu = search_controller_action_match(options)
      found_menu = search_controller_match(options.slice(:controller)) unless found_menu
      found_menu
    rescue
      nil
    end

    def search_controller_action_match(opts={})
      controller = opts.fetch(:controller)
      action     = opts.fetch(:action)
      search do |menu|
        menu.controller == controller &&
        menu.action == action
      end
    end

    def search_controller_match(opts={})
      controller = opts.fetch(:controller)
      search { |menu| menu.controller == controller }
    end

    # recursive find
    def search(&block)
      return self if block.call(self)

      result = nil
      each do |child|
        if block.call(child)
          result = child
          break
        else
          result = child.search(&block)
          break if result
        end
      end
      result
    end

    def controller
      @controller ||= routes.recognize_path(self.path)[:controller]
    end

    def action
      @action ||= routes.recognize_path(self.path)[:action]
    end

    def routes
      MenuTree.routes || raise("No Routes")
    end
  end

end