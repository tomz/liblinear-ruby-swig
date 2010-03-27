#!/usr/bin/env ruby

require 'linear_cv'

Liblinear::info_on = 0

param = LParameter.new
param.C = 1
param.solver_type = L2LOSS_SVM_DUAL
param.eps= 0.1
param.nr_weight = 0
bias = 1

labels,samples = read_file("../heart_scale")
do_cross_validation(samples, labels, param, 10)

#labels,samples = read_file("../data/multiclass/vowel.scale")
#do_cross_validation(samples, labels, param, 10)

#labels,samples = read_file("../data/multiclass/segment.scale")
#do_cross_validation(samples, labels, param, 10)

#labels,samples = read_file("../data/multiclass/shuttle.scale")
#do_cross_validation(samples, labels, param, 10)
