#!/bin/sh

exec 2>&1
set -e

CLONEDIR=/usr/local/src/html
PROMPT1="Username for 'https://github.com':"
PROMPT2="Password for 'https://.+@github.com':"

if [ ! -e ${CLONEDIR} ]; then
  mkdir -p ${CLONEDIR}
fi

if [ -e ${CLONEDIR}/${GITHUB_BRANCH} ]; then
  cd ${CLONEDIR}/${GITHUB_BRANCH}
  expect -c "
  set timeout -1
  spawn git pull
  expect \"${PROMPT1}\"
  send -- \"${GITHUB_USERNAME}\n\"
  expect -re \"${PROMPT2}\"
  send -- \"${GITHUB_ACCESS_TOKEN}\n\"
  expect { \"done\" { interact } }
  "
else
  expect -c "
  set timeout -1
  spawn git clone --branch ${GITHUB_BRANCH} ${GITHUB_REPOSITORY} ${CLONEDIR}/${GITHUB_BRANCH}
  expect \"${PROMPT1}\"
  send -- \"${GITHUB_USERNAME}\n\"
  expect -re \"${PROMPT2}\"
  send -- \"${GITHUB_ACCESS_TOKEN}\n\"
  expect { \"done\" { interact } }
  "
fi

if [ -n ${HUGO} ] && [ -x /usr/local/bin/hugo ]; then
  /usr/local/bin/hugo -s ${CLONEDIR}/${GITHUB_BRANCH}
fi

cd ${CLONEDIR}/${GITHUB_BRANCH}/${GITHUB_PUBLISHDIR}
rsync -rlOtcv --delete ./ /usr/share/nginx/html

exit 0
