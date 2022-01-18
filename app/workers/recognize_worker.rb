# frozen_string_literal: true

class RecognizeWorker
    include Sidekiq::Worker

    def perform(image, model_id)

    end
end
