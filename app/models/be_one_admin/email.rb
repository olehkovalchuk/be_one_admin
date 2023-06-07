module BeOneAdmin
  class Email < ApplicationRecord
    multilang :subject, :text
  end
end

