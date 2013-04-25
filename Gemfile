source :rubygems

gem "middleman", "~>3.0.12"
gem "haml-sprockets", git: 'git://github.com/steel/haml-sprockets.git'
gem "compass-normalize"

group :production, :staging do
  gem 'rb-inotify', "~>0.9", :require => false
end

group :test, :development do
  gem 'rb-fsevent', :require => false
end
