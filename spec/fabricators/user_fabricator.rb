Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password { |attrs| attrs[:email] }
end

Fabricator(:user_with_lists, from: :user) do
  lists(count: 10)
end
