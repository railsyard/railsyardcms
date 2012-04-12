namespace :ry do

  desc "Drop, recreate, migrate db and populate from seed"
  task :init do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc "Load example pages into db"
  task :example => [:environment] do
    load Rails.root.join( 'db/example.rb' )
  end

end
