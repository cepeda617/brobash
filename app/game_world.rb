class GameWorld

  attr_accessor :gravity, :objects, :ground

  def initialize
    @gravity = default_gravity
    @objects = []
    @ground = nil
  end

  def <<( object )
    objects << object
    objects.compact
  end

  def update( dt )
    objects.each do |object|
      object.apply_gravity gravity, dt
      object.collisions_with(ground).resolve
    end
  end

  private

  def default_gravity
    [0, -400]
  end

end
