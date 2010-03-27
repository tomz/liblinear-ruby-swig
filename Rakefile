require 'rubygems'
gem 'hoe', '>=1.8.3','<= 1.12.2'
require 'hoe'


task :default => ["sync_files","make_gem"] 

EXT = "ext/liblinear?.#{Hoe::DLEXT}"

Hoe.new('liblinear-ruby-swig', '0.2.0') do |p|
  p.author = 'Tom Zeng'
  p.email = 'tom.z.zeng@gmail.com'
  p.url = 'http://www.tomzconsulting.com'
  p.summary = 'Ruby wrapper of LIBLINEAR using SWIG'
  p.description = 'Ruby wrapper of LIBLINEAR using SWIG'
  
  p.spec_extras[:extensions] = "ext/extconf.rb"
  p.clean_globs << EXT << "ext/*.o" << "ext/Makefile"
end

task :make_gem => EXT

file EXT => ["ext/extconf.rb", "ext/liblinear_wrap.cxx", "ext/linear.cpp", "ext/linear.h", "ext/tron.h", "ext/tron.cpp", "ext/blas.h", "ext/blasp.h", "ext/dscal.c", "ext/dnrm2.c", "ext/ddot.c", "ext/daxpy.c"] do
  Dir.chdir "ext" do
    ruby "extconf.rb"
    sh "make"
  end
end

task :sync_files do
  cp "liblinear-1.51/linear.h","ext/"
  cp "liblinear-1.51/linear.cpp","ext/"
  cp "liblinear-1.51/tron.h","ext/"
  cp "liblinear-1.51/tron.cpp","ext/"
  cp "liblinear-1.51/ruby/liblinear_wrap.cxx","ext/"
  cp "liblinear-1.51/blas/blas.h","ext/"
  cp "liblinear-1.51/blas/blasp.h","ext/"
  cp "liblinear-1.51/blas/dscal.c","ext/"
  cp "liblinear-1.51/blas/dnrm2.c","ext/"
  cp "liblinear-1.51/blas/ddot.c","ext/"
  cp "liblinear-1.51/blas/daxpy.c","ext/"
  cp "liblinear-1.51/ruby/linear.rb","lib/"
  cp "liblinear-1.51/ruby/linear_cv.rb","lib/"
end

task :test do
  puts "done"
end
