# Start xvfb in preparation for cucumber & jasmine
sh -e /etc/init.d/xvfb start

# Create a database.yml for the right database
echo "Setting up database.yml for $DB"
cp "config/database-$DB-example.yml" config/database.yml