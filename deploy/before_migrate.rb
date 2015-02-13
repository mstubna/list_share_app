# Generate config/secrets.yml
template "#{release_path}/config/secrets.yml" do
  local true
  source "#{release_path}/deploy/templates/secrets.yml.erb"
end
