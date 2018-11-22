FROM ruby:2.5.0

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update -qq
RUN apt-get install -fqq
RUN apt-get install -yqq build-essential net-tools apt-utils \
                         xvfb tzdata locales sudo \
                         bzip2 ca-certificates \
                         libpq-dev ntp wget git unzip zip curl \
                         libcurl4-openssl-dev libffi-dev nodejs \
                         libfontconfig libfreetype6 xfonts-cyrillic \
                         xfonts-scalable fonts-liberation fonts-ipafont-gothic \
                         fonts-wqy-zenhei fonts-tlwg-loma-otf libxi6 libgconf-2-4 \
                         xfonts-100dpi xfonts-75dpi xfonts-scalable

RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

RUN service ntp stop
RUN apt-get install -yqq fake-hwclock
RUN ntpd -gq &
RUN service ntp start

ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0
ENV START_XVFB true
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
  && apt-get update -qq \
  && apt-get -yqq install google-chrome-stable

RUN CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
  && wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ \
  && unzip ~/chromedriver_linux64.zip -d ~/ \
  && rm ~/chromedriver_linux64.zip \
  && mv -f ~/chromedriver /usr/bin/chromedriver \
  && chown $USER:$USER /usr/bin/chromedriver \
  && chmod 0755 /usr/bin/chromedriver

RUN mkdir -p /google_urlify
WORKDIR /google_urlify

COPY . ./

EXPOSE 8008

RUN bundle install
CMD ["ruby", "/google_urlify/server.rb", "-p", "8008"]
