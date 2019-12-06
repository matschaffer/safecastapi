# frozen_string_literal: true

require 'elasticbeanstalk_helper'

def elasticbeanstalk_helper
  ElasticBeanstalkHelper.new('api', 'safecastapi')
end

namespace :elasticbeanstalk do
  desc 'Gets the arn for the platform ARN with the current ruby version'
  task :platform_arn do
    puts elasticbeanstalk_helper.platform_arn
  end

  desc 'Creates a new web & worker environment pair for testing'
  task :create do
    sh(*elasticbeanstalk_helper.create_command('wrk'))
    sh(*elasticbeanstalk_helper.create_command)
  end
end

%i(dev prd).each do |environment_config|
  desc "Deploy to #{environment_config}"
  task "deploy_#{environment_config}" do
    sh(*elasticbeanstalk_helper(environment_config).deploy_command)
  end

  desc "Deploy to #{environment_config}-wrk"
  task "deploy_#{environment_config}_wrk" do
    sh(*elasticbeanstalk_helper(environment_config).deploy_command('wrk'))
  end

  desc "SSH to #{environment_config}"
  task "ssh_#{environment_config}" do
    exec(*elasticbeanstalk_helper(environment_config).ssh_command)
  end

  desc "SSH to #{environment_config}-wrk"
  task "ssh_#{environment_config}_wrk" do
    exec(*elasticbeanstalk_helper(environment_config).ssh_command('wrk'))
  end
end
