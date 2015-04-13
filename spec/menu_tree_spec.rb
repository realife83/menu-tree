require 'rails_helper'

describe MenuTree do
  let(:menu_tree) do
    MenuTree.set(:menu_tree) do
      menu "AAA", to: "AAA_path"
      menu "BBB" do
        menu "bbb" do
          menu "123"
        end
      end
    end
    MenuTree.get(:menu_tree)
  end

  it 'should add menus', focus: true do
    expect( menu_tree.map(&:to_h) ).to eq [
      { name: "AAA", path: "AAA_path", children: [] },
      { name: "BBB", path: "#",
        children: [
          { name: "bbb", path: '#',
            children: [
              { name: "123", path: '#', children: [] }
            ]
          }
        ]
      },
    ]
  end

  it 'can iterate through menues' do
    expect( menu_tree.map(&:name) ).to eq ["AAA", "BBB"]

    expect( menu_tree.first.name ).to eq "AAA"
    expect( menu_tree.first.path ).to eq "AAA_path"

    expect( menu_tree[1].name ).to eq "BBB"
    expect( menu_tree[1][0].name ).to eq "bbb"
    expect( menu_tree[1].map(&:name) ).to eq ['bbb']
    expect( menu_tree[1][1000] ).to be_nil
  end

  it 'can find a menu' do
    menu_bbb = menu_tree.search { |menu| menu.name == "bbb" }
    expect( menu_bbb.name ).to eq 'bbb'
    expect( menu_bbb ).to eq( menu_tree.search_by_name('bbb') )
    expect( menu_tree.search_by_name('xxxx') ).to be_nil
  end

  it 'can find deeply nested menu' do
    menu_123 = menu_tree.search { |menu| menu.name == "123" }
    expect( menu_123.name ).to eq '123'
  end

  it 'should check self in search process' do
    a_menu = menu_tree.search_by_name("AAA")
    expect( a_menu ).to include(a_menu)
  end

  it 'can check a child menu' do
    menu_AAA = menu_tree.search_by_name('AAA')
    menu_BBB = menu_tree.search_by_name('BBB')
    menu_bbb = menu_tree.search_by_name('bbb')

    expect( menu_BBB ).to include(menu_bbb)
    expect( menu_AAA ).not_to include(menu_bbb)
  end

  it 'can set menus in rails initialize process' do
    # Rails.root/config/initializers/menu_tree.rb에서 rails_main_menu 메뉴 정의
    rails_menu = MenuTree.get(:rails_main_menu)
    expect( rails_menu.map(&:to_h) ).to eq([
      {:name=>"Posts", :path=>"/posts", :children=>[]}
    ])
  end

  it 'can be detect menu_tree.rb and reload menu in development or test env' do
    expect { modify_menu_tree_file }.to change {
      MenuTree.get(:rails_main_menu).first.name
    }.from("Posts").to("PPPostsss")
  end

  after(:all) do
    rollback_changed_file
  end

  def modify_menu_tree_file
    menu_tree_file = File.expand_path(File.dirname(__FILE__) + "/dummy/config/initializers/menu_tree.rb")
    File.open( menu_tree_file, 'w' ) do |f|
      content = <<-FIN
        MenuTree.set(:rails_main_menu) do
          menu "PPPostsss", to: posts_path
        end
      FIN
      f.write content
    end
  end

  def rollback_changed_file
    menu_tree_file = File.expand_path(File.dirname(__FILE__) + "/dummy/config/initializers/menu_tree.rb")
    File.open( menu_tree_file, 'w' ) do |f|
      content = <<-FIN
        MenuTree.set(:rails_main_menu) do
          menu "Posts", to: posts_path
        end
      FIN
      f.write content
    end
  end

end