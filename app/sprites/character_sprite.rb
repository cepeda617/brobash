class CharacterSprite  < ActionSprite

  class << self
    def with_name( name, *args, &block )
      instance = allocate
      instance.send(:initialize, *args, &block)
      instance.name = name
      instance
    end
  end

  attr_accessor :name

  # def name
  #   @name ||= self.properties[:name]
  # end

  def idle_animation
    @idle_animtion ||= animate_action '%s-character-idle' % name
  end

  def walk_animation
    @walk_animation ||= animate_action '%s-character-walk' % name
  end

  def attack_animtion
    @attack_animation ||= animate_action '%s-character-attack' % name, repeat: false, speed: 18
  end

end