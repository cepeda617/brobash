class MapLayer < Joybox::Core::Layer

  include Joybox::TMX

  attr_reader :map, :ground

	def on_enter
    @map = TileMap.new file_name: 'world1-level1.tmx'
    self << @map

    @ground = @map.tile_layers[:ground]
  end

end
