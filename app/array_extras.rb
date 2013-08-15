class Array

  def move( index, to_index )
    insert(to_index, delete_at(index))
  end

  def swap( first_index, second_index )
    first_value, second_value = at(first_index), at(second_index)
    delete_at(first_index)
    insert(first_index, second_value)
    delete_at(second_index)
    insert(second_index, first_value)
  end

end