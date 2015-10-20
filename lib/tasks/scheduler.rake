require './scripts/plugins'

namespace :plugins do
  desc "This task is called by the Heroku scheduler add-on"
  task :update do
    puts "Updating plugins..."
    Plugins.update
    puts "done."
  end
end
