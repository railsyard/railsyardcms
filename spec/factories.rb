FactoryGirl.define do

  factory :page do
    title "foo"
    sequence :pretty_url do |i|
      "foo-#{i}"
    end
    lang "en"
  end

  factory :user do
    firstname "Bart"
    lastname  "Simpson"
    password  "password"
    sequence :email do |i|
      "email-#{i}@example.org"
    end
  end

  factory :grade do
  end

  factory :role do
  end

  factory :article_writer, :parent => :user do
    after_create do |user|
      role = Factory.create(:role, :name => 'article_writer')
      user.roles << role
    end
  end

end
