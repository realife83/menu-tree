module MenuTree

  class Base
    def self.set(block)
      new.set(block)
    end

    def initialize
      @current_menu = @root_menu = Menu.new(name: 'root', path: '/')
    end

    def set(block)
      instance_eval(&block)
      @root_menu
    end

    def menu(name, opts={})
      to = opts.fetch(:to, '#')
      menu = Menu.new(name: name, path: to, key: opts[:key])
      @current_menu << menu
      menu.parent = @current_menu

      if block_given?
        parent_menu = @current_menu
        @current_menu = menu        ## one depth in
        yield
        @current_menu = parent_menu ## one depth out
      end
    end
  end

end