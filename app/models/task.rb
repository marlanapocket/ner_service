class Task < ApplicationRecord
    belongs_to :user, optional: true # remove optional
end
