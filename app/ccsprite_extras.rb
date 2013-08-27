class CCSprite

  def intersects?( sprite )
    CGRectIntersectsRect(sprite.boundingBox, self.boundingBox)
  end

  def intersection_with( sprite )
    CGRectIntersection(sprite.boundingBox, self.boundingBox)
  end

end
