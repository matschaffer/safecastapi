desc 'Builds a docker app container'
task build_container: 'assets:precompile' do
  sh 'docker build -t safecast/safecastapi .'
end

desc 'Runs the app container'
task :run_container do
  exec <<-BASH
    docker run \
      --rm \
      -p 3000:3000 \
      -e DATABASE_URL=postgis://matschaffer:UP9pGkBD4fPPqvn@mat-test-1.cvgwlxxke8g1.us-east-1.rds.amazonaws.com/safecast \
      safecast/safecastapi
  BASH
end

