class ServiceResult
  attr_reader :data, :error
  
  def initialize(success:, data: {}, error: nil)
    @success = success
    @data = data
    @error = error
  end
  
  def success?
    @success
  end
  
  def failure?
    !@success
  end
  
  def error_message
    case @error
    when String
      @error
    when Array
      @error.join(', ')
    when Hash
      @error.values.flatten.join(', ')
    else
      @error&.to_s
    end
  end
end