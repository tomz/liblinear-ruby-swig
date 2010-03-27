#!/usr/bin/env ruby
require 'rubygems'
require 'linear'
Liblinear::info_on = 1

solvers = [ L2R_LR, L2R_L2LOSS_SVC_DUAL, L2R_L2LOSS_SVC, L2R_L1LOSS_SVC_DUAL, MCSVM_CS, L1R_L2LOSS_SVC, L1R_LR ]
snames= [ 'L2R_LR', 'L2R_L2LOSS_SVC_DUAL', 'L2R_L2LOSS_SVC', 'L2R_L1LOSS_SVC_DUAL', 'MCSVM_CS', 'L1R_L2LOSS_SVC', 'L1R_LR' ]

data_file = "../heart_scale"
labels,samples = read_file(data_file)

pa = LParameter.new
pa.C = 1
pa.solver_type = L2R_L2LOSS_SVC_DUAL
pa.eps= 0.1
pa.nr_weight = 0
#pa.weight_label = []
#pa.weight = []
bias = 1

#sp = LProblem.new(labels,samples,bias)
#m = LModel.new(sp, pa)
m = LModel.new("#{data_file}.model")

ec = 0
labels.each_index { |i|
  if pa.solver_type == L2R_LR and not m.probability.nil?
    pred, probs = m.predict_probability(samples[i])
#    puts "Got #{pred} and #{probs.join(',')} for sample: [#{samples[i].inspect}]  Label: #{labels[i]}  Pred: #{pred}"
  else
    pred = m.predict(samples[i])
#    puts "Got #{pred} for sample: [#{samples[i].inspect}]  Label: #{labels[i]}"
  end
  ec += 1 if labels[i] != pred
}
puts "Solver #{snames[pa.solver_type]} made #{ec} errors, success rate: #{(samples.size-ec).to_f/samples.size.to_f * 100}%"

