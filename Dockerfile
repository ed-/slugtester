FROM progrium/cedarish
MAINTAINER edcranford "ed.cranford@gmail.com"

RUN apt-get update -y -qq
RUN apt-get install -y -qq python-pip libffi-dev
RUN pip install tox==1.6.1

ADD ./tester/ /tmp/tester
ENTRYPOINT ["/tmp/tester/test.sh"]
