module SpritePhysics

  attr_accessor :body

  def dirty
    true
  end

  def body_idle?
    @body and not self.running_actions?
  end

  def position
    body_idle? ? @body.position : super
  end

  def position=( position )
    body_idle? ? @body.position = position : super
  end

  def rotation
    body_idle? ? @body.rotation : super
  end

  def rotation=( rotation )
    body_idle? ? @body.rotation = rotation : super
  end

  def run_action(action)
    callback = Callback.with do 
      @body.position = self.position unless @body.nil?
      @body.angle = self.rotation unless @body.nil?
    end
    sequence = Sequence.with actions: [action, callback]
    super(sequence)

    self.position = @body.position unless @body.nil?
  end

  def nodeToParentTransform
    return super unless body_idle?

    super
    
    position = @body.position
    position = position + anchorPointInPoints if ignoreAnchorPointForPosition
    angle = @body.radian_angle

    x = position.x
    y = position.y
    cosine = Math.cos(angle)
    sine = Math.sin(angle)

    unless anchorPointInPoints == CGPointZero
      x = x + cosine * -anchorPointInPoints.x + -sine * -anchorPointInPoints.y
      y = y + sine * -anchorPointInPoints.x + cosine * -anchorPointInPoints.y        
    end

    rotated_transform = CGAffineTransformMake(cosine, sine, -sine, cosine, x, y)
    CGAffineTransformScale(rotated_transform, self.scaleX, self.scaleY)
  end

end