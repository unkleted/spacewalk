#!/bin/bash

# satwho requires it
LANG=C

tempfile=$(mktemp /tmp/$(basename $0).XXXXXX)

trap cleanup EXIT

cleanup() {
  exitcode=$?
  test -f "$tempfile" && rm -f "$tempfile"
  exit $exitcode
}

if [ "$(satwho | wc -l)" = "0" ]; then
  curl --silent https://localhost/rhn/newlogin/CreateFirstUser.do --insecure -D - >$tempfile

  cookie=$(egrep -o 'JSESSIONID=[^ ]+' $tempfile)
  csrf=$(egrep csrf_token $tempfile | egrep -o 'value=[^ ]+' | egrep -o '[0-9]+')

    curl --noproxy '*' \
      --cookie "$cookie" \
      --insecure \
      --data "csrf_token=-${csrf}&submitted=true&orgName=DefaultOrganization&login=administrator&desiredpassword=Passw0rd&desiredpasswordConfirm=Passw0rd&email=root%40localhost&prefix=Mr.&firstNames=Administrator&lastName=Spacewalk&" \
      https://localhost/rhn/newlogin/CreateFirstUser.do


  if [ "$(satwho | wc -l)" = "0" ]; then
    echo "Error: user creation failed" >&2
  fi
else
  echo "Error: There is already a user. Check with satwho. No user created." >&2
  exit 1
fi