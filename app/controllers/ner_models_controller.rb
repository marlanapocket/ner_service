# frozen_string_literal: true

class NerModelsController < ApplicationController

    def index
        render json: current_user, status: :ok
    end

    def models
        models = NerModel.where(public: true).or(NerModel.where(user: current_user))
        render json: models, status: :ok
    end

    def tasks
        tasks = Task.where(transkribus_user_id: params[:transkribus_user_id])
        render json: tasks.map{|t| {id: t.id, status: t.status, parameters: t.parameters} }, status: :ok
    end

    def task_status
        # Careful about user the task belongs to !!!
        task = Task.find params[:task_id]
        if task.user == current_user
            render json: {status: task.status, created_at: task.created_at}, status: :ok
        else
            render json: {status: "Forbidden"}, status: :forbidden
        end
    end

    def train
        task = Task.new
        task.status = "Created"
        task.user = current_user
        task.transkribus_user_id = params[:transkribus_user_id]
        task.parameters = {
          type: "training",
          training_data_urls: params[:files_urls],
          model_title: params[:model_title],
          model_description: params[:model_description],
          model_language: params[:model_language]
        }
        task.save
        TrainWorker.perform_async task.id
        render json: { message: 'Training of a new model has begun.', taskId: task.id }, status: :ok
    end

    def recognize
        task = Task.new
        task.status = "Created"
        task.user = current_user
        task.transkribus_user_id = params[:transkribus_user_id]
        task.parameters = {
          type: "recognition",
          pages_urls: params[:files_urls],
          model_id: params[:model_id]
        }
        task.save
        RecognizeWorker.perform_async task.id
        render json: { message: 'The recognition process has started.', taskId: task.id }, status: :ok
    end
end
