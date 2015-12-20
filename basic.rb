def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# Bundle

remove_file 'Gemfile'
copy_file 'templates/Gemfile', 'Gemfile'
run 'bundle install --without production'

# Spring

run 'bundle exec spring binstub --all'

# Formtastic

generate 'formtastic:install'

# Devise

generate 'devise:install'
generate 'devise User'
insert_into_file 'config/environments/development.rb', 
  "\n  config.action_mailer.default_url_options = " +
  "{ host: 'localhost', port: 3000 }", before: "\nend\n"
gsub_file 'app/models/user.rb', ':registerable,', ':registerable, :confirmable,'
filename = Dir['db/migrate/*_create_users.rb'][0]
gsub_file filename, /#\s+(.+:confirm)/, '\1'
gsub_file filename, /#\s+(.+:unconfirm)/, '\1'
insert_into_file 'app/controllers/application_controller.rb', 
  "\n  before_action :authenticate_user!", before: "\nend\n"
directory 'templates/app/views/devise', 'app/views/devise'

# Capistrano

run 'cap install'
filename = 'Capfile'
gsub_file filename, /#\s+(require.+rvm)/, '\1'
gsub_file filename, /#\s+(require.+bundler)/, '\1'
gsub_file filename, /#\s+(require.+assets)/, '\1'
gsub_file filename, /#\s+(require.+migrations)/, '\1'
gsub_file filename, /#\s+(require.+passenger)/, '\1'
filename = 'config/deploy.rb'
gsub_file filename, /#\s+(set.+linked_files)/, '\1'
gsub_file filename, /#\s+(set.+linked_dirs)/, '\1'

# Migrations

rake 'db:migrate'

# Public controller

generate :controller, 'Public'
create_file 'app/views/public/index.html.haml', 'Public#index'
insert_into_file 'app/controllers/public_controller.rb', 
  "\n  skip_before_action :authenticate_user!\n\n" +
  "\n  def index\n  end", before: "\nend\n"

# Helpers
remove_file 'app/helpers/application_helper.rb'
copy_file 'templates/app/helpers/application_helper.rb', 
  'app/helpers/application_helper.rb'

# Layouts

remove_file 'app/views/layouts/application.html.erb'
copy_file 'templates/app/views/layouts/application.html.haml', 
  'app/views/layouts/application.html.haml'
copy_file 'templates/app/views/layouts/mailer.html.erb', 
  'app/views/layouts/mailer.html.erb'
copy_file 'templates/app/views/layouts/mailer.text.erb', 
  'app/views/layouts/mailer.text.erb'

# Routes

remove_file 'config/routes.rb'
copy_file 'templates/config/routes.rb', 'config/routes.rb'

# Assets

remove_file 'app/assets/javascripts/application.js'
copy_file 'templates/app/assets/javascripts/application.js',
  'app/assets/javascripts/application.js'
remove_file 'app/assets/stylesheets/application.css'
copy_file 'templates/app/assets/stylesheets/application.css',
  'app/assets/stylesheets/application.css'
empty_directory 'app/assets/stylesheets/sass-framework'
%w(
  _reset _layout _header _main _footer _formtastic _alerts application
).each do |f|
  get 'https://raw.githubusercontent.com/jarijokinen/sass-framework/' +
    "master/assets/#{f}.scss", "app/assets/stylesheets/sass-framework/#{f}.scss"
end

# Locales

remove_dir 'config/locales'
directory 'templates/config/locales', 'config/locales'

# Remove unnecessary files

remove_file 'lib/templates/erb/scaffold/_form.html.erb'

# Initial commit

git :init
git add: '.'
git commit: '-a -m "Initial commit."'
