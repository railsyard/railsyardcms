FactoryGirl.define do

  factory :page do
    title "foo"
    sequence :pretty_url do |i|
      "foo-#{i}"
    end
    lang "en"
  end

end
