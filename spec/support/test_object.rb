class TestObject
  
  attr_reader :count
  
  def initialize()
    @count = 0
  end
  
  def simple_method
    ['A', 'B', 'C']
  end
  
  def method_with_side_effects
    @count += 1
  end
  
  def broke_method
    raise StandardError.new('errorz')
  end
  
end
