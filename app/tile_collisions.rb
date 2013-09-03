class TileCollisions

  attr_reader :layer, :object

  def initialize( layer, object )
    @layer = layer
    @object = object
  end

  def resolve
    object.on_ground = true if landing?
    object.velocity = [object.velocity.first, 0] if stop_velocity?
    undo_overlap if hit?
    object.update_position
  end

  def undo_overlap
    object.destination.add_to! overlap_adjustment
  end

  def to_s
    "\nObject: #{ object.position.to_a } with bounding: #{ object.boundingBox.to_a }\nHit: #{ hit.position.to_a } with overlap: #{ overlap_adjustment }\n\n"
  end

  def hit
    tiles.find { |tile| tile and object.overlaps? tile } if tiles
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
    hit? && hit_index == 7
  end

  def top?
    hit? && hit_index == 1
  end

  def left?
    hit? && hit_index == 3
  end

  def right?
    hit? && hit_index == 5
  end

  def top_corners?
    hit? && (hit_index == 0 || hit_index == 2)
  end

  def bottom_corners?
    hit? && (hit_index == 6 || hit_index == 8)
  end

  def left_corners?
    hit? && (hit_index == 0 || hit_index == 6)
  end

  def stop_velocity?
    bottom? || bottom_corners? || top? || top_corners?
  end

  def landing?
    bottom? || bottom_corners?
  end

  private

  def tiles
    tiles = (0..8).to_a.map do |i|
      columns = i % 3
      rows = (i / 3).to_i
      column_row_matrix = [(columns - 1) * -32, (rows -1) * -32]
      layer.sprite_at object.position.to_a.add_to column_row_matrix
    end
  end

  def overlap_adjustment
    if bottom?
      [0, vertical_overlap]
    elsif top?
      [0, -vertical_overlap]
    elsif left?
      [horizontal_overlap, 0]
    elsif right?
      [-horizontal_overlap, 0]
    else
      if horizontal_overlap > vertical_overlap
        [0, vertical_overlap * (bottom_corners? ? 1 : -1)]
      else
        [horizontal_overlap * (left_corners? ? 1 : -1), 0]
      end
    end
  end

  def tile_positions
    tiles.map { |tile| tile and tile.position }
  end

end
