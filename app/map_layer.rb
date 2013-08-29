class MapLayer < Joybox::Core::Layer

  include Joybox::TMX

  attr_reader :map, :ground

	def on_enter
    @map = TileMap.new file_name: 'world1-level1.tmx'
    self << @map

    @ground = @map.tile_layers[:ground]
  end







  def surrounding_tiles( sprite, layer )
    sprite_coordinates = layer.coordinate_for_point(sprite.position)
    # puts ">>> tiles surrounding: #{ [sprite_coordinates.x, sprite_coordinates.y] }, layer: #{ layer.name }"

    tiles = (0..8).to_a.map do |i|
      columns = i % 3
      rows = (i / 3).to_i

      tile_coordinate = [sprite_coordinates.x + (columns - 1), sprite_coordinates.y + (rows - 1)]
      tile_position = layer.point_for_coordinate(tile_coordinate)
      tile = layer.sprite_at tile_position
      # tile_rect = coordinate_to_rect(tile_position)

      # {
      #   tile: tile,
      #   x: tile_coordinate[0],
      #   y: tile_coordinate[1],
      #   position: tile_position
      # }
      # puts ">>> tile index: #{ i } coordinate: #{ tile_coordinate[0] }, #{ tile_coordinate[1] }"
    end

    # Reorder by collision priority
    %w( 7 1 3 5 0 2 6 8 ).map { |index| tiles[index.to_i] }
  end

  def coordinate_to_rect( coordinate )
    origin = [coordinate.x * @map.tile_size.width, @map.size.height - ((coordinate.y + 1) * @map.tile_size.height)].to_point
    [origin.x, origin.y, @map.tile_size.width, @map.tile_size.height].to_rect
  end

  def collide_with( object )
    sprite = object.sprite
    object.on_ground = false
    surrounding_tiles(sprite, @ground).each_with_index do |tile, index|
      resolve_tile_collision(object, tile, index)
    end
    object.position = object.desired_position
  end

  def resolve_tile_collision( object, tile, index )
    if !@collision && tile && tile.intersects?(object.sprite)
      intersection = tile.intersection_with(object.sprite)

      object.desired_position =
      case index
      when 0 then bottom_collision(object, intersection)
      when 1 then top_collision(object, intersection)
      when 2 then left_collision(object, intersection)
      when 3 then right_collision(object, intersection)
      else
        if intersection.size.width > intersection.size.height
          if index > 5
            object.land
            resolution_height = intersection.size.height
          else
            object.fall
            resolution_height = -intersection.size.height
          end

          [object.desired_position.x, object.desired_position.y + resolution_height].to_point
        else
          resolution_width = (index == 6 || index == 4) ? intersection.size.width : -intersection.size.width
          [object.desired_position.x + resolution_width, object.desired_position.y].to_point
        end
      end
    end
  end

  def bottom_collision( object, intersection )
    object.land
    [object.desired_position.x, object.desired_position.y + intersection.size.height].to_point
  end

  def top_collision( object, intersection )
    object.fall
    [object.desired_position.x, object.desired_position.y - intersection.size.height].to_point
  end

  def left_collision( object, intersection )
    [object.desired_position.x + intersection.size.width, object.desired_position.y].to_point
  end

  def right_collision( object, intersection )
    [object.desired_position.x + intersection.size.width, object.desired_position.y].to_point
  end

end
