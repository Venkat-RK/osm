helpers do
  def upload
    record if input_validated?
  end

  def accepted_file_formats
    [".csv"]
  end

  def input_validated?
    if params['file'].nil?
      @err_msg = "Choose file to upload."
    elsif !accepted_file_formats.include? File.extname(input_file_name)
      @err_msg = "Invalid file type, accepted formats are : #{accepted_file_formats}"
    elsif  tmp_file_size > 1000.00
      @err_msg = "File size should be less than 1 GB"
    end
    @err_msg.nil?
  end

  def record
    copy_to_target_file
    OsmWorker.perform_async(target_file_path)
    @success_msg = "Successfully uploaded file for processing."
  end


  def target_file_path
    taget_file_dir + input_file_name
  end

  def copy_to_target_file
    File.delete(target_file_path) if File.exist?(target_file_path)
    FileUtils.mv(tmp_file_path, target_file_path)
  end

  def taget_file_dir
    "#{File.dirname(__FILE__)}/../input/"
  end

  def input_file_name
    params['file'][:filename]
  end

  def tmp_file_path
    params['file'][:tempfile].path
  end

  def tmp_file_size
    (File.size(tmp_file_path).to_f / 1024000).round(2)
  end

  def err_msg
    @err_msg.nil? ? '' : @err_msg
  end

  def success_msg
    @success_msg.nil? ? '' : @success_msg
  end
end
