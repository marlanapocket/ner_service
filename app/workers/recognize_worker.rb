# frozen_string_literal: true

class RecognizeWorker
    include Sidekiq::Worker

    def perform(task_id)
        task = Task.find task_id

        # Load ner_model
        ner_model = NerModel.find(task.parameters['model_id'])

        # Import files into model
        task.status = "Importing training data"
        task.save
        task.parameters["pages_urls"].each_with_index do |url, idx|
            task.status = "Recognizing page #{idx+1} out of #{task.parameters["pages_urls"].size}"
            task.save
            # tempfile = URI.open(url)
            # Execute system script: python -m script.py tempfile.path, ner_model.path
            # get results
            # save in task
        end

        # Save trained model
        task.status = "Finished"
        task.save

    end
end
