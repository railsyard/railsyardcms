class BugfixRemoveDuplicateRoles < ActiveRecord::Migration
  def up
    count = 0
    Grade.find_each do |g|
      duplicates = Grade.where(:user_id => g.user_id, :role_id => g.role_id)
      if duplicates.count > 1
        g.destroy
        count += 1
      end
    end
    puts "Removed #{count} duplicates"
  end

  def down
    # Hey, do you want this nasty bug back?!
  end
end
