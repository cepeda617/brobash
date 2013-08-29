class Player

  def initialize( options = {} )
    @options = options
  end

  def character
    @character ||= CharacterSprite.with_name options[:character], position: options[:position]
  end

  private

  attr_reader :options

end
