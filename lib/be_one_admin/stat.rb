module BeOneAdmin
  module Stat
    module_function
    def blocks
      h = {
        icon: 'globe',
        color: 'teal',
        title: "TODAY'S VISITS",
        value: '7,842,900',
        percent: 81.5,
        description: 'Better than last week (76.3%)'
      }
      [OpenStruct.new(h)]
    end
  end
end
