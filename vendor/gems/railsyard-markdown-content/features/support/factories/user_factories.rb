Factory.define :role do |role|
  
end

Factory.define :user do |user|
  user.email 'admin@example.com'
  user.firstname 'Admin'
  user.lastname 'Surname'
  user.password 'changeme'
  user.password_confirmation 'changeme'
  user.enabled true
  user.confirmed_at Time.new
end