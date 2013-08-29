class Array

  def move( index, to_index )
    self.insert(to_index, self.delete_at(index))
    self
  end

  def swap( first_index, second_index )
    first_value, second_value = self.at(first_index), self.at(second_index)
    self.delete_at(first_index)
    self.insert(first_index, second_value)
    self.delete_at(second_index)
    self.insert(second_index, first_value)
    self
  end

  def multiply_by( value )
    self.map { |n| n.to_i * value }
  end

  def add_to( array )
    self.each_with_index.map { |n, i| n + array[i] }
  end

end
