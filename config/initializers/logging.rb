require 'lograge/sql/extension'

Rails.application.configure do
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Logstash.new
    config.lograge.base_controller_class = 'ActionController::API'
    config.lograge.custom_payload do |controller|
        {
            host: controller.request.host,
            ip: controller.request.remote_ip,
            user_id: controller.current_user.try(:id),
            params: controller.params.except(:action, :controller)
        }
    end

    config.lograge_sql.extract_event = Proc.new do |event|
        { name: event.payload[:name], duration: event.duration.to_f.round(2), sql: event.payload[:sql] }
    end
    config.lograge_sql.formatter = Proc.new do |sql_queries|
        sql_queries.to_json
    end

    outputs = [
      { type: :file, path: "#{Rails.root}/log/#{Rails.env}.log" },
      { type: :tcp, port: 5000, host: '127.0.0.1' }
    ]
    outputs << { type: :stdout } if Rails.env == "development"
    Rails.logger = LogStashLogger.new(
      type: :multi_delegator,
      outputs: outputs
    )
end