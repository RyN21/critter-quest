require_relative "../config/settings"
require_relative "entities/fox"
require_relative "maze/maze"
require_relative "maze/cell"


class GameWindow < Gosu::Window

  def initialize
    super Config::WINDOW_WIDTH,
          Config::WINDOW_HEIGHT,
          Config::FULLSCREEN
    self.caption = Config::CAPTION

    @background_color = Config::COLORS[:background]
    @fox              = Fox.new
    @maze             = Maze.new Config::GRID_ROWS, Config::GRID_COLS
  end

  def update
    @fox.update
  end

  def draw
    draw_rect 0,0, Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT, @background_color
    @maze.draw(Config::CELL_SIZE)
    @fox.draw
  end
end
