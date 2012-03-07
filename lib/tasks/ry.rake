namespace :ry do
  
  desc "Drop, recreate, migrate db and populate from seed"
  task :init do  
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
  
  desc "Drop, recreate, migrate db without populate from seed"
  task :clean_init do  
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
  
end
