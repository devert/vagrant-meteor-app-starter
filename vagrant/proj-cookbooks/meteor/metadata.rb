# Fork of Matthew Sullivan's meteor_windows recipe. Renamed to just "meteor"
name              "meteor"
maintainer        "Matthew Sullivan"
maintainer_email  "shoebappa@gmail.com"
description       "Installs Meteor and Meteorite for a Vagrant box and mounts symlinks that will work on vagrant windows"
version           "0.0.1"

depends           "apt"
depends           "build-essential"
depends           "nodejs"
depends           "curl"

%w{ debian ubuntu }.each do |os|
  supports os
end

