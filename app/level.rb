class Level

  BODIES = {
    arena: {
      edge: [[64, 95], [416, 95], [434, 87], [46, 87]]
    }
  }

  def self.world
    @world ||= World.new gravity: [0, -25]
  end

  def self.new_character_body
    world.new_body position: Screen.center, type: Body::Dynamic, fixed_rotation: true do
      polygon_fixture box: [16, 16], restitution: 0
    end
  end

  def self.body_from_vertices( vertices )
    body = world.new_body position: [0, 0], type: Body::Static
    vertices.each_with_index do |v, i|
      end_point = (i == vertices.size - 1) ? vertices[0] : vertices[i + 1]
      body.edge_fixture start_point: v, end_point: end_point
    end
  end

  def self.arena( layer )
    level = new name: 'arena'
    layer << level.background
    level.bodies.each do |type, vertices|
      Level.body_from_vertices vertices if type == :edge
    end

    level
  end

  attr_reader :name

  def initialize( options = {} )
    @name = options[:name]
  end

  def background
    backdrop = Sprite.new file_name: "#{ name }.png", position: Screen.center
    backdrop.zOrder = -10
    backdrop
  end

  def bodies
    BODIES[name.to_sym]
  end

end
