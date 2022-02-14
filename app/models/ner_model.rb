class NerModel < ApplicationRecord
    has_many_attached :training_pages
    belongs_to :user, optional: true
end
