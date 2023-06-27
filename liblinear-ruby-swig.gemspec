Gem::Specification.new do |s|
  s.name = %q{liblinear-ruby-swig}
  s.version = "0.2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Zeng"]
  s.date = %q{2010-03-27}
  s.description = %q{Ruby wrapper of LIBLINEAR using SWIG}
  s.email = %q{tom.z.zeng@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "COPYING", "AUTHORS", "Manifest.txt", "README.rdoc", "Rakefile", "lib/linear.rb", "lib/linear_cv.rb", "ext/liblinear_wrap.cxx", "ext/linear.cpp", "ext/linear.h", "ext/extconf.rb", "ext/tron.h", "ext/tron.cpp", "ext/blas.h", "ext/blasp.h", "ext/dscal.c", "ext/dnrm2.c", "ext/ddot.c", "ext/daxpy.c"]
  s.has_rdoc = false
  s.homepage = %q{http://www.tomzconsulting.com}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby wrapper of LIBLINEAR using SWIG}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
