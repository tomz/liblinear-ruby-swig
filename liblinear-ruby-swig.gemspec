Gem::Specification.new do |s|
  s.name = %q{liblinear-ruby-swig}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Zeng"]
  s.date = %q{2009-05-09}
  s.description = %q{Ruby wrapper of LIBLINEAR using SWIG}
  s.email = %q{tom.z.zeng@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "COPYING", "AUTHORS", "Manifest.txt", "README.txt", "Rakefile", "lib/linear.rb", "lib/linear_cv.rb", "ext/liblinear_wrap.cxx", "ext/linear.cpp", "ext/linear.h", "ext/extconf.rb", "ext/tron.h", "ext/tron.cpp", "ext/blas.h", "ext/blasp.h", "ext/dscal.c", "ext/dnrm2.c", "ext/ddot.c", "ext/daxpy.c"]
#  s.has_rdoc = true
  s.homepage = %q{http://www.tomzconsulting.com}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib","ext"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby wrapper of LIBLINEAR using SWIG}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end
