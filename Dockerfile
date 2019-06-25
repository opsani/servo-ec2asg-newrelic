FROM python:3.6-slim

WORKDIR /servo

# Install dependencies
RUN pip3 install requests PyYAML python-dateutil boto3 && \
	apt-get update && apt-get install -y --no-install-recommends \
    python3-boto \
    python3-botocore

# Change /usr/bin/python3 => /usr/local/bin/python3, since the first is older,
# so that import of boto3 works
RUN rm -f /usr/bin/python3 && \
	ln -s /usr/local/bin/python3 /usr/bin/python3

# Install servo:  ec2asg adjust (with its own adjust.py base class) and
# newrelic measure (which uses the servo base measure.py)
# Note:  will eventually require the EC2WIN driver and .NET encoder
ADD https://raw.githubusercontent.com/opsani/servo-ec2asg/master/adjust \
    https://raw.githubusercontent.com/opsani/servo-ec2asg/master/adjust.py \
    https://raw.githubusercontent.com/opsani/servo-newrelic/master/measure \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo/master/servo \
    /servo/

RUN chmod a+rwx /servo/adjust /servo/measure /servo/servo
RUN chmod a+rw /servo/measure.py /servo/adjust.py

ENV PYTHONUNBUFFERED=1

ENTRYPOINT [ "python3", "servo" ]