class MapLayer < Joybox::Core::Layer

  include Joybox::TMX

  attr_reader :ground

	def on_enter
    @map = TileMap.new file_name: 'world1-level1.tmx'
    self << @map

    @ground = @map.tile_layers[:ground]

    # center_at [Screen.width/2, Screen.height/2].to_point
  end

  def tiles_surrounding( sprite, layer )
    position = @map.coordinate_for_point(sprite.position)
    # puts ">>> tiles surrounding: #{ [position.x, position.y] }, layer: #{ layer.name }"

    tiles = (0..8).to_a.map do |i|
      columns = i % 3
      rows = (i / 3).to_i

      tile_position = [position[0] + (columns - 1), position[1] + (rows - 1)]
      tile = layer.sprite_at tile_position
      tile_rect = coordinate_to_rect(tile_position)

      {
        tile: tile,
        x: tile_rect.origin.x,
        y: tile_rect.origin.x,
        position: tile_position
      }
    end

    tiles.delete_at(4)
    tiles = tiles.move(2, 6).swap(4, 6).swap(0, 4)
    # puts tiles
    # tiles
  end

  def coordinate_to_rect( coordinate )
    coordinate = coordinate.to_point
    origin = [coordinate.x * @map.tile_size.width, @map.size.height - ((coordinate.y + 1) * @map.tile_size.height)].to_point
    [origin.x, origin.y, @map.tile_size.width, @map.tile_size.height].to_rect
  end

  def collide_with( object )
    sprite = object.sprite
    desired = object.desired_position
    object.on_ground = false

    tiles_surrounding(sprite, @ground).each_with_index do |data, index|
      if tile = data[:tile] and CGRectIntersectsRect(sprite.bounding_box, tile.boundingBox)
        intersection = CGRectIntersection(sprite.bounding_box, tile.boundingBox)

        object.desired_position = case index
        when 0 then object.zero_out and object.land and [desired[0], desired[1] + intersection.size.height]
        when 1 then object.zero_out and [desired[0], desired[1] - intersection.size.height]
        when 2 then [desired[0] + intersection.size.width, desired[1]]
        when 3 then [desired[0] + intersection.size.width, desired[1]]
        else
          if intersection.size.width > intersection.size.height
            object.zero_out
            intersection_height = index > 5 ? (object.on_ground and intersection.size.height) : -intersection.size.height
            [desired[0], desired[1] + intersection_height]
          else
            intersection_width = index == 6 || index == 4 ? intersection.size.width : -intersection.size.width
            [desired[0] + intersection_width, desired[1]]
          end
        end
      end
    end

    object.position = object.desired_position
  end

end
