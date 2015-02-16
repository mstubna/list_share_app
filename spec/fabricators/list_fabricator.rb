Fabricator(:list) do
  title { sequence(:title) { |i| "list title #{i}" } }
  body { sequence(:body) { |i| "list body text #{i}" } }
  user
end
