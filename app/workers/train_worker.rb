# frozen_string_literal: true

class TrainWorker
    include Sidekiq::Worker

    def perform(training_data, model_title, model_description, model_language)
        task = Task.create! type: 'train', status: 'started'
    end
end
