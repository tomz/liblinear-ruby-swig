#!/usr/bin/ruby1.8
require 'rubygems'
require 'linear'
Liblinear::info_on = 1

puts "TEST of the Ruby LIBLINEAR bindings"
puts "------------------------------------"
pa = LParameter.new
pa.C = 1
pa.solver_type = L2R_LR
pa.eps= 0.1
pa.nr_weight = 0
#pa.weight_label = []
#pa.weight = []
bias = 1

labels_m = [1, 2, 1, 2, 3]
labels_2 = [1, 1, -1, -1, 1]
samples = [
           {1=>0,2=>0.1,3=>0.2,4=>0,5=>0},
           {1=>0,2=>0.1,3=>0.3,4=>-1.2,5=>0},
           {1=>0.4,2=>0,3=>0,4=>0,5=>0},
           {1=>0,2=>0.1,3=>0,4=>1.4,5=>0.5},
           {1=>-0.1,2=>-0.2,3=>0.1,4=>1.1,5=>0.1}
          ]
solvers = [ L2R_LR, L2R_L2LOSS_SVC_DUAL, L2R_L2LOSS_SVC, L2R_L1LOSS_SVC_DUAL, MCSVM_CS, L1R_L2LOSS_SVC, L1R_LR ]
snames= [ 'L2R_LR', 'L2R_L2LOSS_SVC_DUAL', 'L2R_L2LOSS_SVC', 'L2R_L1LOSS_SVC_DUAL', 'MCSVM_CS', 'L1R_L2LOSS_SVC', 'L1R_LR' ]
#solvers = [ L2_LR ]
#snames= [ 'L2_LR' ]
#solvers = [  L2LOSS_SVM_DUAL, L1LOSS_SVM_DUAL, MCSVM_CS ]
#snames= [ 'L2LOSS_SVM_DUAL', 'L1LOSS_SVM_DUAL', 'MCSVM_CS' ]
solvers.each_index { |j|

  if solvers[j] == MCSVM_CS
    labels = labels_m
  else
    labels = labels_2
  end
  sp = LProblem.new(labels,samples,bias)
  pa.solver_type = solvers[j]
  m = LModel.new(sp, pa)
#  m = LModel.new("../heart_scale.model")
  m.save(snames[j]+".model")
  ec = 0
  labels.each_index { |i|
    if pa.solver_type == L2R_LR and not m.probability.nil?
      pred, probs = m.predict_probability(samples[i])
      puts "Got #{pred} and #{probs.join(',')} for sample: [#{samples[i]}]  Label: #{labels[i]}  Pred: #{pred} Kernel: #{snames[j]}"
    else
      pred = m.predict(samples[i])
      puts "Got #{pred} for sample: [#{samples[i]}]  Label: #{labels[i]}  Kernel: #{snames[j]}"
    end
    ec += 1 if labels[i] != pred
  }
  puts "Kernel #{snames[j]} made #{ec} errors"
}
