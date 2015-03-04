Fabricator(:list) do
  title { sequence(:title) { |i| "list title #{i}" } }
  body { sequence(:body) { |i| "list body text #{i}" } }
end

# Fabricates a new list belonging to a new user
Fabricator(:list_for_user, from: :list) do
  user
end
