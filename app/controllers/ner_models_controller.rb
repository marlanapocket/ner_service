# frozen_string_literal: true

class NerModelsController < ApplicationController
    def index
        render json: NerModel.all, status: :ok
    end

    def tasks

    end

    # curl -F 'files[]=@/home/axel/Images/photo_axel.jpg' -F 'files[]=@/home/axel/Images/poe.png' -F 'model_title=model1' -F 'model_description=this is a great AI model !' -F 'model_language=fr' http://localhost:3000/train
    def train
        training_data = params[:files]
        model_title = params[:model_title]
        model_description = params[:model_description]
        model_language = params[:model_language]
        TrainWorker.perform_async training_data, model_title, model_description, model_language
        render json: { message: 'Training of a new model has begun.', taskId: task.id }, status: :ok
    end

    def status

    end

    def recognize
        task_id = RecognizeWorker.perform_async
        render json: { message: 'The recognition process has started.', taskId: task_id }, status: :ok
    end
end
