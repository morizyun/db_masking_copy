class Database
  # ------------------------------------------------------------------
  # Constants
  # ------------------------------------------------------------------
  CONFIG_PATH = Rails.root.join('db/config/database.yml').freeze

  # ------------------------------------------------------------------
  # Attributes
  # ------------------------------------------------------------------
  attr_reader :settings

  # ------------------------------------------------------------------
  # Public Class Method
  # ------------------------------------------------------------------
  def self.define_class(environment, table_name)
    class_name = table_name.singularize.camelcase
    eval <<-EOF
      module Sample
        module #{environment.camelcase}
          class #{class_name} < ActiveRecord::Base
            path = Rails.root.join('db/config/database.yml')
            config = YAML.load_file(path)
            establish_connection(config['#{environment}'])
          end
        end
      end
      Sample::#{environment.camelcase}::#{class_name}
    EOF
  end

  def self.get_model(database, table_name)
    Object.const_get "Database::Sample::#{database.singularize.camelcase}::#{table_name.singularize.camelcase}"
  end

  # ------------------------------------------------------------------
  # Public Instance Method
  # ------------------------------------------------------------------
  def initialize
    @settings = YAML.load_file(CONFIG_PATH)
  end

  def setting_in(environment)
    @settings[environment]
  end

  def restore_setting
    file = Rails.root.join('config/database.yml')
    settings = YAML.load_file(file)
    ActiveRecord::Base.establish_connection(settings[Rails.env])
  end

  def generate_models(environment)
    setting = setting_in(environment)
    ar = ActiveRecord::Base.establish_connection(setting)
    tables = ar.connection.tables.each do |table_name|
      self.class.define_class(environment, table_name)
    end
    restore_setting
    return tables
  end

  def copy_schema(from, to)
    dump_schema(from)
    kill_db_connection(to)
    drop_db(to)
    create_db(to)
    apply_schema(from, to)
  end

  # ------------------------------------------------------------------
  # Private Instance Method
  # ------------------------------------------------------------------
  def dump_schema(db_key)
    setting = setting_in(db_key)
    system "cd #{Rails.root} && mkdir db/dump"
    system "pg_dump -f db/dump/schema_#{setting['database']}.sql -v -s #{setting['database']} --format=tar"
  end

  def drop_db(db_key)
    setting = setting_in(db_key)
    system "dropdb #{setting['database']}"
  end

  def create_db(db_key)
    setting = setting_in(db_key)
    system "createdb #{setting['database']}"
  end

  def apply_schema(from, to)
    setting_from = setting_in(from)
    setting_to = setting_in(to)
    system "pg_restore -d #{setting_to['database']} db/dump/schema_#{setting_from['database']}.sql"
  end

  # コネクションの切断
  def kill_db_connection(db_key)
    setting = setting_in(db_key)
    db_name = setting['database']

    # コネクションの切断
    binding.pry
    cmd = %(psql -c "SELECT pid, pg_terminate_backend(pid) as terminated FROM pg_stat_activity WHERE pid <> pg_backend_pid();" -d '#{db_name}')

    # コマンドを実行
    fail($?.inspect) unless system(cmd)
  end
end
