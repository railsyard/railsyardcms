# Start xvfb in preparation for cucumber & jasmine
sh -e /etc/init.d/xvfb start

# Create a database.yml for the right database
echo "Setting up database.yml for $DB"
cp config/database-example.yml config/database.yml
if [ "$DB" = "postgres" ]; then
  sed -i 's/*mysql/*postgres/' config/database.yml
fi