task :default => ["sync_files","make_gem"]

EXT = "lib/liblinear?.#{RbConfig::CONFIG["DLEXT"]}"

task :make_gem => EXT

file EXT => ["ext/extconf.rb", "ext/liblinear_wrap.cxx", "ext/linear.cpp", "ext/linear.h", "ext/tron.h", "ext/tron.cpp", "ext/blas.h", "ext/blasp.h", "ext/dscal.c", "ext/dnrm2.c", "ext/ddot.c", "ext/daxpy.c"] do
  Dir.chdir "ext" do
    ruby "extconf.rb"
    sh "make"
    cp "liblinear.bundle","../lib/"
  end
end

task :clean do
  Dir.chdir "ext" do
    sh "make clean"
  end
end

task :sync_files do
  cp "liblinear-1.8/linear.h","ext/"
  cp "liblinear-1.8/linear.cpp","ext/"
  cp "liblinear-1.8/tron.h","ext/"
  cp "liblinear-1.8/tron.cpp","ext/"
  cp "liblinear-1.8/ruby/liblinear_wrap.cxx","ext/"
  cp "liblinear-1.8/blas/blas.h","ext/"
  cp "liblinear-1.8/blas/blasp.h","ext/"
  cp "liblinear-1.8/blas/dscal.c","ext/"
  cp "liblinear-1.8/blas/dnrm2.c","ext/"
  cp "liblinear-1.8/blas/ddot.c","ext/"
  cp "liblinear-1.8/blas/daxpy.c","ext/"
  cp "liblinear-1.8/ruby/linear.rb","lib/"
  cp "liblinear-1.8/ruby/linear_cv.rb","lib/"
end

task :test do
  puts "done"
end
