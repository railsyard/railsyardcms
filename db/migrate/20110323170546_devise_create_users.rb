class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.column :email, :string
      t.column :firstname, :string
      t.column :lastname, :string
      
      # Devise fields
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both

      # t.encryptable
      # t.token_authenticatable
      
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    
  end

  def self.down
    drop_table :users
  end
end
