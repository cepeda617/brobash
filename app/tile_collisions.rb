class TileCollisions

  attr_reader :layer, :object

  def initialize( layer, object )
    @layer = layer
    @object = object
  end

  def resolve
    # puts self if bottom? || bottom_corners?
    if bottom? || bottom_corners?
      object.on_ground = true
    end
    undo_overlap if hit?
    object.position = object.destination
  end

  def to_s
    # "\nObject: #{ object.position.to_a } with bounding: #{ object.boundingBox.to_a }\nTiles: #{ tile_positions }\nTile: #{ hit.position.to_a } at index: #{ hit_index } and\noverlap: [#{ horizontal_overlap }, #{ vertical_overlap }]\n\n"
    "\nObject: #{ object.position.to_a } with bounding: #{ object.boundingBox.to_a }\nHit: #{ hit.position.to_a } with overlap: #{ overlap_adjustment }\n\n"
  end

  def tiles
    %w( 1 7 3 5 6 8 0 2 ).map { |index| tiles_around[index.to_i] }
  end

  def hit
    tiles.find { |tile| tile and object.overlaps? tile }
  end

  def hit?
    hit
  end

  def hit_index
    tiles.index(hit)
  end

  def overlap
    size = object.overlap_with(hit).size
    [size.width, size.height]
  end

  def horizontal_overlap
    overlap[0]
  end

  def vertical_overlap
    overlap[1]
  end

  def bottom?
    hit? && hit_index == 0
  end

  def top?
    hit? && hit_index == 1
  end

  def left?
    hit? && hit_index == 2
  end

  def right?
    hit? && hit_index == 3
  end

  def bottom_corners?
    hit? && hit_index > 5
  end

  def left_corners?
    hit? && (hit_index == 4 || hit_index == 6)
  end

  def undo_overlap
    object.destination.add_to! overlap_adjustment
  end

  private

  def tiles_around
    object_coordinates = layer.coordinate_for_point object.position
    # puts "\nObject: #{ object_coordinates.to_a }\n"

    tiles = (0..8).to_a.map do |i|
      columns = i % 3
      rows = (i / 3).to_i
      coordinates = object_coordinates.to_a.add_to [(columns - 1), (rows - 1)]
      position = layer.point_for_coordinate(coordinates)
      # puts "Tile coordinates: #{ coordinates }\n\n"
      layer.sprite_at position
    end
  end

  def overlap_adjustment
    case hit_index
    when 0 then [0, vertical_overlap]
    when 1 then [0, -vertical_overlap]
    when 2 then [horizontal_overlap, 0]
    when 3 then [-horizontal_overlap, 0]
    else
      if horizontal_overlap > vertical_overlap
        [0, vertical_overlap * (bottom_corners ? 1 : -1)]
      else
        [horizontal_overlap * (left_corners ? 1 : -1), 0]
      end
    end
  end

  def tile_positions
    tiles.map { |tile| tile and tile.position }
  end

end
