FROM java:8 
MAINTAINER Forest Keepers

ENV DETECT_LATEST_RELEASE_VERSION 5.3.2
ENV DETECT_VERSION_KEY 5.3.2

ENV SRC_PATH /code

RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

# Remove running detect
RUN head -n -1 /app/detect.sh > temp.txt ; mv temp.txt /app/detect.sh
RUN echo "get_detect" >> /app/detect.sh 
RUN chmod +x /app/detect.sh

RUN /app/detect.sh 

RUN head -n -1 /app/detect.sh > temp.txt ; mv temp.txt /app/detect.sh
RUN echo "run" >> /app/detect.sh 
RUN chmod +x /app/detect.sh

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true --detect.source.path="${SRC_PATH}"
