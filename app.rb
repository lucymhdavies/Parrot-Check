################################################################################
# Helpers
################################################################################

Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file }


################################################################################
# Routes
################################################################################

get '/' do
	erb :index
end


get '/emoji' do
	emoji = Slack.emoji_list
	JSON.generate( emoji )
end


get '/parrots' do
	parrots = Dir.entries("/tmp/checkout/parrots/parrots")

	parrots = parrots.delete_if { |a| a == "." }
	parrots = parrots.delete_if { |a| a == ".." }
	parrots = parrots.sort

	JSON.generate( parrots )
end
