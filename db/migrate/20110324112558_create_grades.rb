class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.references :role, :user
      t.timestamps
    end
    
    admin_role = Role.find_by_name('admin')
    user = User.create :email => 'admin@example.com', :firstname => 'Admin', :lastname => 'Surname', :password => 'changeme'
    user.confirmed_at, user.lang, user.enabled = Time.now, 'en', true
    user.roles << admin_role
    user.save
    puts "------------------------- Creating user email \'#{user.email}\', password \'changeme\'-------------------------"
  end

  def self.down
    drop_table :grades
  end
end
