class Player

  def initialize( options = {} )
    @options = options
  end

  def character
    @character ||= CharacterSprite.with_name options[:character], position: options[:position]
  end

  def update( dt )
    character.update dt
  end

  private

  attr_reader :options

end
