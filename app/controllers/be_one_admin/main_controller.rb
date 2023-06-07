module BeOneAdmin
  class MainController < ::BeOneAdmin::ApplicationController
    def index
      @block_stats = BeOneAdmin::Stat.blocks
    end
  end
end
