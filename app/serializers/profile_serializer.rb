class ProfileSerializer < ApplicationSerializer
  attributes :id, :email, :admin, :created_at, :updated_at
end
