class TileCollisions

  class << self

    def resolve( layer, object )
      tile_collision = new(layer, object)
      tile_collision.undo_overlap if tile_collision.hit?
    end

  end

  attr_reader :layer, :object

  def initialize( layer, object )
    @layer = layer
    @object = object
  end

  def to_s
    "Tile: #{ hit } at index: #{ hit_index }"
  end

  def tiles
    @tiles ||= %w( 7 1 3 5 0 2 6 8 ).map { |index| tiles_around[index.to_i] }
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
    hit_index == 0
  end

  def top?
    hit_index == 1
  end

  def left?
    hit_index == 2
  end

  def right?
    hit_index == 3
  end

  def bottom_corners?
    hit_index > 5
  end

  def left_corners?
    hit_index == 4 || hit_index == 6
  end

  def undo_overlap
    object.destination.add_to! overlap_adjustment
  end

  private

  def tiles_around
    object_coordinates = layer.coordinate_for_point object.position

    tiles = (0..8).to_a.map do |i|
      columns = i % 3
      rows = (i / 3).to_i
      coordinates = object_coordinates.to_a.add_to [(columns - 1), (rows - 1)]
      position = layer.point_for_coordinate(coordinates)
      layer.sprite_at position
    end
  end

  def overlap_adjustment
    case hit_index
    when 0 then [0, horizontal_overlap]
    when 1 then [0, -horizontal_overlap]
    when 2 then [vertical_overlap, 0]
    when 3 then [-vertical_overlap, 0]
    else
      if horizontal_overlap > vertical_overlap
        [0, vertical_overlap * (bottom_corners ? 1 : -1)]
      else
        [horizontal_overlap * (left_corners ? 1 : -1), 0]
      end
    end
  end

end
