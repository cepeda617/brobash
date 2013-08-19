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

end