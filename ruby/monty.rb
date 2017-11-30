class Monty
  DOORS = [:prize, :goat, :goat]

  def new_doors
    DOORS.shuffle.each_with_index.reduce({}) do |accum, (door, index)|
      accum[index] = door
      accum
    end
  end

  def reveal_goat(doors, choice)
    doors.reject { |index, door| doors[index] == :goat && index != choice }
  end

  def win?(doors, choice)
    doors[choice] == :prize
  end
end
