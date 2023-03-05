cmake_minimum_required(VERSION 3.10) 
project(api LANGUAGES CXX C)                       

add_library(api
  SHARED
  ./api.cpp
)
set("OpenCV_DIR" $ENV{OpenCV_DIR})
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )
target_link_libraries(api PRIVATE ${OpenCV_LIBS})