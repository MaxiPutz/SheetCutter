#include <iostream>
#include <stdio.h>
#include  <opencv2/opencv.hpp>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void testCVFunc();
extern "C" __attribute__((visibility("default"))) __attribute__((used))
void findContour(char* inPath, char* outPath);
void find_squares(cv::Mat &image, std::vector<std::vector<cv::Point>> &squares);
extern "C" __attribute__((visibility("default"))) __attribute__((used))
void pageDetect (char *inpath, char *outpath);
extern "C" __attribute__((visibility("default"))) __attribute__((used))
void printInOut (char * input, char *output);

std::vector<cv::Point> getCorners(std::vector<cv::Point> square);