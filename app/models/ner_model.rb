class NerModel < ApplicationRecord
    has_many_attached :training_pages
    has_one_attached :model
    belongs_to :user, optional: true
end
