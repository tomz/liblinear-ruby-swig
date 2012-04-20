require 'liblinear'
include Liblinear

def _int_array(seq)
  size = seq.size
  array = new_int(size)
  i = 0
  for item in seq
    int_setitem(array,i,item)
    i = i + 1
  end
  return array
end

def _double_array(seq)
  size = seq.size
  array = new_double(size)
  i = 0
  for item in seq
    double_setitem(array,i,item)
    i = i + 1
  end
  return array
end

def _free_int_array(x)
  if !x.nil? # and !x.empty?
    delete_int(x)
  end
end

def _free_double_array(x)
  if !x.nil? # and !x.empty?
    delete_double(x)
  end
end

def _int_array_to_list(x,n)
  list = []
   (0..n-1).each {|i| list << int_getitem(x,i) }
  return list
end

def _double_array_to_list(x,n)
  list = []
   (0..n-1).each {|i| list << double_getitem(x,i) }
  return list
end    

class LParameter
  attr_accessor :param
  
  def initialize(*args)
    @param = Liblinear::Parameter.new
    @param.solver_type = L2R_LR
    @param.C = 1
    @param.eps = 0.01
    @param.nr_weight = 0
    @param.weight_label = _int_array([])
    @param.weight = _double_array([])
    
    args[0].each {|k,v| 
      self.send("#{k}=",v)
    } if !args[0].nil?
  end
  
  def method_missing(m, *args)
    #print m.to_s
    #puts args.inspect
    if m.to_s == 'weight_label='
      @weight_label_len = args[0].size
      pargs = _int_array(args[0])
      _free_int_array(@param.weight_label)
    elsif m.to_s == 'weight='
      @weight_len = args[0].size
      pargs = _double_array(args[0])
      _free_double_array(@param.weight)
    else
      pargs = args[0]
    end
    
    if m.to_s.index('=')
      @param.send("#{m}",pargs)
    else
      @param.send("#{m}")
    end
    
  end
  
  def inspect
    "LParameter: solver_type=#{@param.solver_type} C=#{@param.C} eps=#{@param.eps}"
  end
  
  def destroy
    _free_int_array(@param.weight_label)
    _free_double_array(@param.weight)
    delete_parameter(@param)
    @param = nil
  end
end

def _convert_to_feature_node_array(x, maxlen, bias=-1)
  # convert a sequence or mapping to an feature_node array
  
  # Find non zero elements
  iter_range = []
  if x.class == Hash
    x.each {|k, v|
      # all zeros kept due to the precomputed kernel; no good solution yet
      iter_range << k #if v != 0
    }
  elsif x.class == Array
    x.each_index {|j| 
      iter_range << j #if x[j] != 0
    }
  else
    raise TypeError,"data must be a hash or an array"
  end
  
  iter_range.sort!
  if bias >=0
    data = feature_node_array(iter_range.size+2)
    #puts "bias element (#{iter_range.size},#{bias})"
    feature_node_array_set(data,iter_range.size,maxlen+1,bias)
    feature_node_array_set(data,iter_range.size+1,-1,0)
  else
    data = feature_node_array(iter_range.size+1)
    feature_node_array_set(data,iter_range.size,-1,0)
  end
  
  j = 0
  for k in iter_range
    #puts "element #{j}= (#{k},#{x[k]})"
    feature_node_array_set(data,j,k,x[k])
    j = j + 1
  end
  return data
end


class LProblem
  attr_accessor :prob, :maxlen, :size
  
  def initialize(y,x,bias)
#    assert_equal(y.size, x.size)
    @prob = prob = Liblinear::Problem.new 
    @size = size = y.size
    
    @y_array = y_array = new_int(size)
    for i in (0..size-1)
      int_setitem(@y_array,i,y[i])
    end
    
    @x_matrix = x_matrix = feature_node_matrix(size)
    @data = []
    @maxlen = 0  #max number of features
    len_array=[]

    for i in (0..size-1)
      data = _convert_to_feature_node_array(x[i], @maxlen, bias)
      @data << data
      feature_node_matrix_set(x_matrix,i,data)

      if x[i].class == Hash
        if x[i].size > 0
          @maxlen = [@maxlen,x[i].keys.max].max          
        end
      else
        @maxlen = [@maxlen,x[i].size].max
      end
      len_array << x[i].size      
    end

    if bias >= 0
      set_bias_index(x_matrix, size, @maxlen, _int_array(len_array))
    end
    
    prob.y = y_array
    prob.x = x_matrix
    prob.bias = bias
    prob.l = size
    prob.n = @maxlen
    if bias >= 0
      prob.n += 1
    end
  end
  
  def inspect
    "LProblem: size = #{size} n=#{prob.n} bias=#{prob.bias} maxlen=#{@maxlen}"
  end
  
  def destroy
    delete_problem(@prob)
    delete_int(@y_array)
    for i in (0..size-1)
      feature_node_array_destroy(@data[i])
    end
    feature_node_matrix_destroy(@x_matrix)
  end
end

class LModel
  attr_accessor :model, :probability
  
  def initialize(arg1,arg2=nil)
    if arg2 == nil
      # create model from file
      filename = arg1
      @model = load_model(filename)
    else
      # create model from problem and parameter
      prob,param = arg1,arg2
      @prob = prob
      msg = check_parameter(prob.prob,param.param)
      raise "ValueError", msg if msg
      @model = Liblinear::train(prob.prob,param.param)
    end
    #setup some classwide variables
    @nr_class = Liblinear::get_nr_class(@model)
    #create labels(classes)
    intarr = new_int(@nr_class)
    Liblinear::get_labels(@model,intarr)
    @labels = _int_array_to_list(intarr, @nr_class)
    delete_int(intarr)
  end
  
  def predict(x)
    data = _convert_to_feature_node_array(x, @model.nr_feature, @model.bias)
    ret = Liblinear::predict(@model,data)
    feature_node_array_destroy(data)
    return ret
  end
  
  
  def get_nr_class
    return @nr_class
  end
  
  def get_labels
    return @labels
  end
  
  def predict_values_raw(x)
    #convert x into feature_node, allocate a double array for return
    n = (@nr_class*(@nr_class-1)/2).floor
    data = _convert_to_feature_node_array(x, @model.nr_feature, @model.bias)
    dblarr = new_double(n)
    Liblinear::predict_values(@model, data, dblarr)
    ret = _double_array_to_list(dblarr, n)
    delete_double(dblarr)
    feature_node_array_destroy(data)
    return ret
  end
  
  def predict_values(x)
    v=predict_values_raw(x)
    #puts v.inspect
    if false
      #if @svm_type == NU_SVR or @svm_type == EPSILON_SVR or @svm_type == ONE_CLASS
      return v[0]
    else #self.svm_type == C_SVC or self.svm_type == NU_SVC
      count = 0
      
      # create a width x height array
      width = @labels.size
      height = @labels.size
      d = Array.new(width)
      d.map! { Array.new(height) }
      
      for i in (0..@labels.size-1)
        for j in (i+1..@labels.size-1)
          d[@labels[i]][@labels[j]] = v[count]
          d[@labels[j]][@labels[i]] = -v[count]
          count += 1
        end
      end
      return  d
    end
  end
  
  def predict_probability(x)
#    if not @probability
#      raise TypeError, "model does not support probabiliy estimates"
#    end
    
    #convert x into feature_node, alloc a double array to receive probabilities
    data = _convert_to_feature_node_array(x, @model.nr_feature, @model.bias)
    dblarr = new_double(@nr_class)
    pred = Liblinear::predict_probability(@model, data, dblarr)
    pv = _double_array_to_list(dblarr, @nr_class)
    delete_double(dblarr)
    feature_node_array_destroy(data)
    p = {}
    for i in (0..@labels.size-1)
      p[@labels[i]] = pv[i]
    end
    return pred, p
  end
  
  # def get_svr_probability
  #   #leave the Error checking to svm.cpp code
  #   ret = Liblinear::get_svr_probability(@model)
  #   if ret == 0
  #     raise TypeError, "not a regression model or probability information not available"
  #   end
  #   return ret
  # end
  
  # def get_svr_pdf
  #   #get_svr_probability will handle error checking
  #   sigma = get_svr_probability()
  #   return Proc.new{|z| exp(-z.abs/sigma)/(2*sigma)}  # TODO: verify this works
  # end
  
  def save(filename)
    save_model(filename,@model)
  end
  
  def destroy
    destroy_model(@model)
  end
end

def cross_validation(prob, param, fold)
  target = new_int(prob.size)
  Liblinear::cross_validation(prob.prob, param.param, fold, target)
  ret = _int_array_to_list(target, prob.size)
  delete_int(target)
  return ret
end

def read_file filename
  labels = []
  samples = []
  max_index = 0

  f = File.open(filename)
  f.each do |line|
    elems = line.split
    sample = {}
    for e in elems[1..-1]
       points = e.split(":")
       sample[points[0].to_i] = points[1].to_f
       if points[0].to_i < max_index
          max_index = points[0].to_i
       end
    end
    labels << elems[0].to_i
    samples << sample
  #print elems[0].to_i
  #print " - "
  #puts sample.inspect
  end
  puts "#{filename}: #{samples.size} samples loaded."
  return labels,samples
end

