namespace :db do
  
  desc "Load system data fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
  task :load_system_data => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    ( ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob( File.join(RAILS_ROOT, 'db', 'system_data', '*.{yml,csv}') ) ).each do |fixture_file|
      name = File.basename(fixture_file, '.*')
      Fixtures.create_fixtures("db/system_data", name)
      puts("Loaded #{name}")
    end
  end
  
  # taken from: http://weblog.masukomi.org/2006/11/14/improved-extract_fixtures
  desc "Create YAML test fixtures from data in an existing database.  " +
  " Defaults to development database.  Set RAILS_ENV to override. " +
  "\nSet OUTPUT_DIR to specify an output directory. Defaults to test/fixtures. " +
  "\nSet TABLES (a coma separated list of table names) to specify which tables to extract. " +
  "Leaving it blank will extract all tables."

  task :extract_fixtures => :environment do
    sql  = "SELECT * FROM %s"
    skip_tables = ["schema_info"]
    ActiveRecord::Base.establish_connection
    if (not ENV['TABLES'])
      tables = ActiveRecord::Base.connection.tables - skip_tables
    else
      tables = ENV['TABLES'].split(/, */)
    end
    if (not ENV['OUTPUT_DIR'])
      output_dir="#{RAILS_ROOT}/test/fixtures"
    else
      output_dir = ENV['OUTPUT_DIR'].sub(/\/$/, '')
    end
    (tables).each do |table_name|
      i = "000"
      File.open("#{output_dir}/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        file.write data.inject({}) { |hash, record|
          hash["#{table_name}_#{i.succ!}"] = record
          hash
        }.to_yaml
      puts "wrote #{table_name} to #{output_dir}/"
      end
    end
  end

end
