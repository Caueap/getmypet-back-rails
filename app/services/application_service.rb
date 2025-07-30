class ApplicationService
  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end
  
  def initialize(*args, **kwargs)
    # Override in subclasses
  end
  
  def call
    raise NotImplementedError, "#{self.class} must implement #call"
  end
  
  private
  
  def success(data = {})
    ServiceResult.new(success: true, data: data)
  end
  
  def failure(error, data = {})
    ServiceResult.new(success: false, error: error, data: data)
  end
end
