# frozen_string_literal: true
require 'open-uri'

class TrainWorker
    include Sidekiq::Worker

    def perform(task_id)
        task = Task.find task_id

        # Create empty ner_model
        ner_model = NerModel.new
        ner_model.title = task.parameters["model_title"]
        ner_model.description = task.parameters["model_description"]
        ner_model.language = task.parameters["model_language"]
        ner_model.transkribus_user_id = task.transkribus_user_id
        ner_model.user = task.user
        ner_model.save

        # Import files into model
        task.status = "Importing training data"
        task.save
        task.parameters["training_data_urls"].each_with_index do |url, idx|
            ner_model.training_pages.attach(io: URI.open(url), filename: "#{idx}.xml")
        end

        # Start training
        task.status = "Training model"
        task.save
        working_dir = "#{Rails.root}/tmp/model_#{ner_model.id}_training"
        FileUtils.mkdir_p "#{working_dir}/training_data"
        ner_model.training_pages.blobs.each do |blob|
            blob.open do |file|
                FileUtils.copy file.path, "#{working_dir}/training_data"
            end
        end

        # ...Execute system script to train model
        sleep 10

        # Attach model data to ner_model
        task.status = "Saving model"
        task.save
        # ner_model.model.attach(io: File.open(""), filename: "model.bin")
        # ner_model.path = ""
        # ner_model.save


        # Save trained model
        task.status = "Finished"
        FileUtils.remove_dir"#{Rails.root}/tmp/model_#{ner_model.id}_training"
        task.save
    end

end
