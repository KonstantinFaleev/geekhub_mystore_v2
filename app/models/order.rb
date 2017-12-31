class Order < ApplicationRecord
  enum pay_type: {
      "New" => 0,
      "In processing" => 1,
      "Sent" => 2
  }
end
