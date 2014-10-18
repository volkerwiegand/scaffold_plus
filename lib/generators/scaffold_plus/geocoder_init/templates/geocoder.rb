Geocoder.configure(
  # geocoding options
  :lookup       => :google,
  :language     => :<%= options.language %>,
  :timeout      => <%= options.timeout %>,
  # :cache        => Redis.new,
  # :cache_prefix => 'geocoder:',

  # calculation options
  :units        => :<%= options.units %>,
  :distances    => :spherical
)
