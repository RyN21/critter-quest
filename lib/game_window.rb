require_relative "../config/settings"
require_relative "entities/fox"
require_relative "entities/mermaid"
require_relative "maze/maze"
require_relative "maze/cell"
require_relative "entities/coin"
require_relative "entities/bubble_rainbow"


class GameWindow < Gosu::Window

  def initialize
    super Config::WINDOW_WIDTH,
          Config::WINDOW_HEIGHT,
          Config::FULLSCREEN
    self.caption = Config::CAPTION
    Gosu.enable_undocumented_retrofication

    @background_color   = Config::COLORS[:background]
    @background_image   = Gosu::Image.new("assets/images/background_ocean.jpg")
    @maze               = MazeSidewinder.new(Config::GRID_ROWS, Config::GRID_COLS)
    @mermaid            = Mermaid.new(@maze) # 0 for first row mermaid
    @bubble_rainbows    = Array.new

    @level_up_sound     = Gosu::Sample.new("assets/sounds/level_up.mp3")

    # @red_coins_anim     = Gosu::Image.load_tiles("assets/images/coins/red_coin.png", 25, 25)
    # @gold_coins_anim    = Gosu::Image.load_tiles("assets/images/coins/red_coin.png", 25, 25 )
    # @silver_coins_anim  = Gosu::Image.load_tiles("assets/images/coins/red_coin.png", 25, 25)
    add_bubbles_to_maze
  end

  def update
    # @fox.update
    @bubble_rainbows.each do |bubble|
      bubble.update
    end
    @mermaid.update
    @mermaid.collects_bubbles(@bubble_rainbows)
    reset_maze if all_bubbles_collected?
  end

  def draw
    # draw_rect 0,0, Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT, @background_color
    @background_image.draw 0, 0, 0, 0.20, 0.20

    @maze.draw(Config::CELL_SIZE)
    @mermaid.draw
    @bubble_rainbows.each(&:draw)
  end

  def add_bubbles_to_maze
    path_tiles = []
    path_tiles = @maze.grid.flatten.select(&:tile_path)
    number_of_bubbles = path_tiles.size / 3
    path_tiles.shift # Makes sure coin isnt loaded at start path where fox is
    path_tiles.sample(number_of_bubbles).each do |tile|
      x = tile.col * Config::CELL_SIZE + Config::CELL_SIZE / 2
      y = tile.row * Config::CELL_SIZE + Config::CELL_SIZE / 2
      @bubble_rainbows << BubbleRainbow.new(x, y)
    end
  end

  def all_bubbles_collected?
    @bubble_rainbows.empty?
  end

  def reset_maze
    @level_up_sound.play
    @maze    = MazeSidewinder.new(Config::GRID_ROWS, Config::GRID_COLS)
    @mermaid = Mermaid.new(@maze) # 0 for first row mermaid

    add_bubbles_to_maze
    @mermaid.place_on_path
  end
end


# GAME FEATURES TO ADD
#
# accidentally runs into something she shouldn't
# something scart pops up
# if she runs into something the bubbles reset or something similar
