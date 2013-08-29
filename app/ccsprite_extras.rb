class CCSprite

  def overlaps?( sprite )
    CGRectIntersectsRect(sprite.boundingBox, self.boundingBox)
  end

  def overlap_with( sprite )
    CGRectIntersection(sprite.boundingBox, self.boundingBox)
  end

end
