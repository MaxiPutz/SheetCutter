#FROM ubuntu:18.04
FROM ubuntu

RUN apt-get update && \
    apt-get install -y wget  && \
    apt-get install -y  gnupg dirmngr

RUN apt-get install apt-transport-https && \
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /usr/share/keyrings/dart.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list

RUN apt update && \
    apt install dart


RUN apt install -y g++ cmake make git libgtk2.0-dev pkg-config 

RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip

RUN apt-get install unzip
RUN unzip opencv.zip && \
    mv opencv-4.x opencv

RUN mkdir -p build && cd build && \
    cmake ../opencv && \
    make -j4 && \
    make install

RUN ls /usr/local/include/opencv4

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled  and required system
# libraries and configuration files stored in  from the build stage.


# Start server.

COPY ./public /public
COPY ./lib/isolate/libmylib.so /lib/isolate/libmylib.so

EXPOSE 8080
CMD ["/app/bin/server"]
