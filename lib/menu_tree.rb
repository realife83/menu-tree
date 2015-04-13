require_relative 'menu_tree/base'
require_relative 'menu_tree/menu'
require_relative 'menu_tree/rails_utils'
require_relative 'menu_tree/configuration'
require_relative 'menu_tree/version'
require 'forwardable'

module MenuTree
  class << self
    extend Forwardable
    def_delegators Configuration, :menu_tree_path, :routes, :configure
  end

  @@menu_trees = {}
  @@menu_tree_blocks = {}

  def self.set(name, &block)
    @@menu_tree_blocks[name] = block
  end

  def self.get(name)
    # initialize 끝난 후가 아니라, routes가 load된 이후에 block을 실행해야 하기 때문에
    # get을 부를 때 block을 실행
    RailsUtils.reload_menu_if_file_changed
    RailsUtils.set_rails_routes_once
    RailsUtils.include_routes_helper_once
    @@menu_trees[name] ||= Base.set( @@menu_tree_blocks[name] )
  end

  def self.reload!
    @@menu_trees = {}
    @@menu_tree_blocks = {}
    menu_tree_path.each { |file| load file }
  end
end
