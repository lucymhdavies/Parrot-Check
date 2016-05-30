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


get '/slack_team_info' do
	result = Slack.team_info
	JSON.generate( result )
end

get '/emoji' do
	emoji = Slack.emoji_list
	JSON.generate( emoji )
end


get '/parrots' do
	parrot_files = Dir.entries("/tmp/checkout/parrots/parrots")

	parrot_files = parrot_files.delete_if { |a| a == "." }
	parrot_files = parrot_files.delete_if { |a| a == ".." }
	parrot_files = parrot_files.sort

	parrot_list = {}
	parrot_files.each { |file|
		filename = File.basename(file,File.extname(file))
		parrot_list[filename] = "http://cultofthepartyparrot.com/parrots/" + file
	}

	result = {
		:ok    => true,
		:emoji => parrot_list
	}

	JSON.generate( result )
end

get '/compare' do
	result = [ :status => "UNKNOWN" ]
	JSON.generate( result )
end
