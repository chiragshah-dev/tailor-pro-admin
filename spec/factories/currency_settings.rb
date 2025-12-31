FactoryBot.define do
  factory :currency_setting do
    country { "MyString" }
    currency_code { "MyString" }
    amount_limit { "9.99" }
  end
end
