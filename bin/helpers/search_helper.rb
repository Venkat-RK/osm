helpers do
  def search
    return if params.keys.count < 3
    if is_processing_finished?
      args = get_search_args
      begin
        @result = ObjectStateManager.search_object_state(:args => args)
      rescue => e
        @err_msg = e.message
      end
    else
      @err_msg = "Uploaded file is under processing, Please try after some time."
    end
  end

  def get_search_args
    args = { :object_type => params['object_type'], :object_id => params['object_id'] }
    args.merge!(:from => Time.parse(params[:from]).to_i) if params[:from]
    args.merge!(:to => Time.parse(params[:to]).to_i) if params[:to]
  end

  def get_object_types
    ObjectClassGenerator.get_class_names
  end

  def is_selected(object_type)
    params['object_type'].nil? ? '' : ( params['object_type'] == object_type.to_s ? "Selected" : "" )
  end

  def get_object_id_value
    params['object_id'].nil? ? '' : params['object_id'].to_i
  end

  def get_from_value
    #2016-06-23 00:00
    params['from'].nil? ? '' : Time.parse(params['from']).strftime("%Y-%m-%d %H:%M").to_s.gsub(/\s+/, '')
  end

  def get_to_value
    params['to'].nil? ? '' : Time.parse(params['to']).strftime("%Y-%m-%d %H:%M").to_s.gsub(/\s+/, '')
  end

  def read_search_query
    params.map{|key, value| "#{key}=#{value}"}.join("&")
  end

  def get_search_result
    @search_result ||= @result.nil? ? [] : @result.collect {|obj| obj.to_hash}
  end

  def search_result_count
    get_search_result.count
  end

  def search_error_msg
    @err_msg
  end

  def is_processing_finished?
    stats = Sidekiq::Stats.new
    stats.queues["default"] == 0
  end
end
