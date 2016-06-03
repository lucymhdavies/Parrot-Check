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
	# TODO: return an error if there are not exactly two files specified

	# TODO: return an error if the two files are not on whitelisted URLs (i.e. emoji.slack-edge.com or cultofthepartyparrot.com

	file1 = params['file1']
	file2 = params['file2']

	hash1 = Digest::MD5.hexdigest(open(file1).read)
	hash2 = Digest::MD5.hexdigest(open(file2).read)

	if ( hash1 == hash2 )
		status = "SAME"
	else
		status = "DIFFERENT"
	end

	result = {
		:status => status,
		:file1  => {
			:url  => file1,
			:hash => hash
		},
		:file2  => {
			:url  => file2,
			:hash => hash
		},
	}
	JSON.generate( result )
end
