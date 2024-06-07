# frozen_string_literal: true

# Reciever of all commands
class LunarCommandReceiver
  DIRECTIONS = %w[N E S W].freeze

  attr_accessor :x, :y, :z, :current_direction, :previous_direction

  def initialize
    @x = 0
    @y = 0
    @z = 0
    @current_direction = 'N'
  end

  def forward_backward(direction)
    second_operator = (direction == 'f' ? '+' : '-')
    coordinate_name, operator = movement_map[@current_direction]
    coordinate = instance_variable_get("@#{coordinate_name}")
    value = eval("#{coordinate} #{operator} #{second_operator} 1", binding, __FILE__, __LINE__)
    instance_variable_set("@#{coordinate_name}", value)
  end

  def left_right(direction)
    current_direction = get_direction(direction)
    update_privious_direction
    @current_direction = current_direction
  end

  def up_down(direction)
    update_privious_direction
    @current_direction = direction.upcase
  end

  def get_direction(direction)
    DIRECTIONS.include?(@current_direction) ? DIRECTIONS[get_index(direction)] : up_and_down_direction(direction)
  end

  def get_index(direction)
    if direction == 'l'
      DIRECTIONS.index(@current_direction) - 1
    else
      index_value = DIRECTIONS.index(@current_direction) + 1
      index_value == 4 ? 0 : index_value
    end
  end

  def up_and_down_direction(cmd)
    movements = direction_hash[@previous_direction]
    left_dir, right_dir = @current_direction == 'U' ? movements : movements.reverse
    cmd == 'l' ? left_dir : right_dir
  end

  def update_privious_direction
    @previous_direction = @current_direction if DIRECTIONS.include?(@current_direction)
  end

  def movement_map
    {
      'N' => ['y', '+'],
      'S' => ['y', '-'],
      'E' => ['x', '+'],
      'W' => ['x', '-'],
      'U' => ['z', '+'],
      'D' => ['z', '-']
    }
  end

  def direction_hash
    {
      'N' => %w[W E],
      'S' => %w[E W],
      'E' => %w[N S],
      'W' => %w[S N]
    }
  end

  def print_output
    puts "Final Position: (#{@x}, #{@y}, #{@z})\nFinal Direction: #{@current_direction}"
  end
end
