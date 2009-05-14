#!/usr/bin/env ruby
require 'rubygems'
require 'linear'
require 'pp'

Liblinear::info_on = 1

# a three-class problem
labels = [0, 1, 1, 1]
#samples = [[0, 0], [0, 1], [1, 0], [1, 1]]
samples = [{1=>0, 2=>0}, {1=>0, 2=>1}, {1=>1, 2=>0}, {1=>1, 2=>1}]
bias = 1
problem = LProblem.new(labels, samples, bias)
size = samples.size

solvers = [ L2_LR, L2LOSS_SVM_DUAL, L2LOSS_SVM, L1LOSS_SVM_DUAL, MCSVM_CS ]
snames= [ 'L2_LR', 'L2LOSS_SVM_DUAL', 'L2LOSS_SVM', 'L1LOSS_SVM_DUAL', 'MCSVM_CS' ]

param = LParameter.new('C' => 1,'nr_weight' => 2,'weight_label' => [1,0],'weight' => [10,1])
for k in solvers
	param.solver_type = k
	model = LModel.new(problem,param)
    model.save(snames[k]+".model")
	errors = 0
	for i in (0..size-1)
		prediction = model.predict(samples[i])
		probability = model.predict_probability(samples[i])
		if (labels[i] != prediction)
			errors = errors + 1
        end
    end
	puts "##########################################"
	puts " solver #{snames[k]}: error rate = #{errors} / #{size}"
	puts "##########################################"
end

param = LParameter.new('solver_type' => L2_LR, 'C'=>10)
model = LModel.new(problem, param)
puts "##########################################"
puts " Decision values of predicting #{samples[0].inspect}"
puts "##########################################"

puts "Numer of Classes:" + model.get_nr_class().to_s
d = model.predict_values(samples[0])
#puts d.inspect
for i in model.get_labels
	for j in model.get_labels
		if j>i
			puts "{#{i}, #{j}} = #{d[i][j]}"
    end
  end
end

param = LParameter.new('solver_type' => L2_LR, 'C'=>10)#, 'probability' => 1)
model = LModel.new(problem, param)
pred_label, pred_probability = model.predict_probability(samples[1])
puts "##########################################"
puts " Probability estimate of predicting #{samples[1].inspect}"
puts "##########################################"
puts "predicted class: #{pred_label}"
for i in model.get_labels
	puts "prob(label=#{i}) = #{pred_probability[i]}"
end

