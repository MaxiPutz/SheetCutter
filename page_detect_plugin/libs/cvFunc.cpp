#include "cvFunc.hpp"
#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <string>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y) {
    std::cout << cv::getVersionString();
    return x + y;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void printInOut (char * input, char *output) {
    std::cout << input << output;
}


extern "C" __attribute__((visibility("default"))) __attribute__((used))
void testCVFunc()
{
    std::cout << "deis is a test aufrudf\n";
}

double angle(cv::Point pt1, cv::Point pt2, cv::Point pt0)
{
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    return (dx1 * dx2 + dy1 * dy2) / sqrt((dx1 * dx1 + dy1 * dy1) * (dx2 * dx2 + dy2 * dy2) + 1e-10);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void pageDetect(char * inPath, char * outPath)
{
    cv::Mat inMat = cv::imread(inPath);

    cv::Mat kernel(3, 3, CV_8UC1, cv::Scalar(1));

    cv::Mat mat;
    cv::morphologyEx(inMat, mat, cv::MORPH_CLOSE, kernel, cv::Point(-1, 1), 5);

    cv::cvtColor(mat, mat, cv::COLOR_BGR2GRAY);
    cv::GaussianBlur(mat, mat, cv::Size2d(11, 11), 0);
    cv::Canny(mat, mat, 0, 200);
    cv::dilate(mat, mat, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mat, contours, cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);

    cv::Mat countourImg(mat.size(), CV_8SC3, cv::Scalar(0, 0, 0));

    std::vector<std::vector<cv::Point>> squares;
    std::vector<cv::Point> approx;
    for (size_t i = 0; i < contours.size(); i++)
    {
        // approximate contour with accuracy proportional
        // to the contour perimeter
        approxPolyDP(cv::Mat(contours[i]), approx, arcLength(cv::Mat(contours[i]), true) * 0.02, true);

        // Note: absolute value of an area is used because
        // area may be positive or negative - in accordance with the
        // contour orientation
        if (approx.size() == 4 &&
            fabs(cv::contourArea(cv::Mat(approx))) > 1000 &&
            cv::isContourConvex(cv::Mat(approx)))
        {
            double maxCosine = 0;

            for (int j = 2; j < 5; j++)
            {
                double cosine = fabs(angle(approx[j % 4], approx[j - 2], approx[j - 1]));
                maxCosine = MAX(maxCosine, cosine);
            }

            if (maxCosine < 0.3)
                squares.push_back(approx);
        }
    }

    for (size_t idx = 0; idx < squares.size(); idx++)
    {
        cv::drawContours(countourImg, squares, idx, cv::Scalar(255, 255, 255), 5);
    }

    mat = countourImg;
    std::vector<cv::Point> corners;
    for (size_t idx = 0; idx < squares.size(); idx++)
    {

        auto map = [](std::vector<cv::Point> ele)
        {
            std::vector<cv::Point> res;
            for (size_t i = 0; i < ele.size(); i++)
            {
                res.push_back(ele.at(i));
            }
            return res;
        };

        std::vector<cv::Point> topPoints;
        std::vector<cv::Point> bottomPoints;

        auto temp = map(squares[idx]);
        std::sort(temp.begin(), temp.end(), [](cv::Point ele1, cv::Point ele2)
                  { return (ele1.y) < (ele2.y); });

        topPoints.push_back(temp[0]);
        topPoints.push_back(temp[1]);

        bottomPoints.push_back(temp[2]);
        bottomPoints.push_back(temp[3]);

        std::sort(topPoints.begin(), topPoints.end(), [](cv::Point ele1, cv::Point ele2)
                  { return (ele1.y) < (ele2.y); });

        std::sort(bottomPoints.begin(), bottomPoints.end(), [](cv::Point ele1, cv::Point ele2)
                  { return (ele1.y) < (ele2.y); });

        cv::Point _size[4];
        std::vector<cv::Point> sortedCorner2;
        sortedCorner2.assign(std::begin(_size), std::end(_size));

        sortedCorner2[0] = topPoints[0];
        sortedCorner2[1] = bottomPoints[0];

        sortedCorner2[2] = topPoints[1];
        sortedCorner2[3] = bottomPoints[1];

        auto sortedCorner = topPoints;
        sortedCorner.insert(sortedCorner.begin(), bottomPoints.begin(), bottomPoints.end());

        corners = sortedCorner2;

        sortedCorner = sortedCorner2;

        // sortedCorner = map(squares[idx]);

        for (size_t idy = 0; idy < sortedCorner.size(); idy++)
        {
            auto point = sortedCorner[idy];
            // cv::circle(mat, point, 30, cv::Scalar(0,255,255), -1);

            cv::putText(mat, std::to_string(idy), point, cv::FONT_HERSHEY_DUPLEX, 5, cv::Scalar(255, 255, 0), 2, false);
        }
    }

    auto destinationCorners = [](std::vector<cv::Point> sortedCorners)
    {
        cv::Point2f _size[4];
        std::vector<cv::Point2f> arr;
        arr.assign(std::begin(_size), std::end(_size));

        auto getDist = [](cv::Point a, cv::Point b)
        {
            return std::sqrt(std::pow(a.x - a.y, 2) + std::pow(b.y - b.x, 2));
        };

        double maxWidth = getDist(sortedCorners[0], sortedCorners[1]) > getDist(sortedCorners[2], sortedCorners[3])
                              ? getDist(sortedCorners[0], sortedCorners[1])
                              : getDist(sortedCorners[2], sortedCorners[3]);

        double maxHight = getDist(sortedCorners[0], sortedCorners[2]) > getDist(sortedCorners[1], sortedCorners[3])
                              ? getDist(sortedCorners[0], sortedCorners[2])
                              : getDist(sortedCorners[1], sortedCorners[3]);

        arr[0] = (cv::Point2f(0, 0));
        arr[1] = (cv::Point2f(0, maxHight));
        arr[2] = (cv::Point2f(maxWidth, 0));
        arr[3] = (cv::Point2f(maxWidth, maxHight));

        return arr;
    };

    auto helper = [](std::vector<cv::Point> inP)
    {
        cv::Point2f _size[4];
        std::vector<cv::Point2f> outP;
        outP.assign(std::begin(_size), std::end(_size));

        for (size_t i = 0; i < 4; i++)
        {
            outP[i] = inP[i];
        }
        return outP;
    };

    std::cout << corners << "\n";
    std::cout << destinationCorners(corners) << "\n";

    auto m = cv::getPerspectiveTransform(helper(corners),
                                         destinationCorners(corners));

    auto imgSize = cv::Size(cvRound(destinationCorners(corners)[3].x),
                            cvRound(destinationCorners(corners)[3].y));

    std::cout << imgSize << "\n";

    cv::Mat _img;
    cv::warpPerspective(inMat, _img, m, imgSize);

    for (size_t i = 0; i < corners.size(); i++)
    {
        cv::putText(inMat, std::to_string(i), corners[i], cv::FONT_HERSHEY_PLAIN, 5, cv::Scalar(255, 0, 255), 6);
    }

    // cv::Mat outMat = inMat;
    cv::Mat outMat = _img;

    cv::imwrite(outPath, outMat);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void findContour(char *inPath, char *outPath)
{

    cv::Mat mat = cv::imread(inPath);

    cv::cvtColor(mat, mat, cv::COLOR_BGR2GRAY);
    cv::GaussianBlur(mat, mat, cv::Size2d(3, 3), 0);
    cv::threshold(mat, mat, 0, 255, cv::THRESH_BINARY + cv::THRESH_OTSU);

    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mat, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    cv::Mat contourImage(mat.size(), CV_8UC3, cv::Scalar(0, 0, 0));

    for (size_t idx = 0; idx < contours.size(); idx++)
    {
        cv::drawContours(contourImage, contours, idx, cv::Scalar(255, 255, 255));
    }

    cv::imwrite(outPath, contourImage);
}

void find_squares(cv::Mat &image, std::vector<std::vector<cv::Point>> &squares)
{
    // blur will enhance edge detection
    cv::Mat blurred(image);
    medianBlur(image, blurred, 9);

    cv::Mat gray0(blurred.size(), CV_8U), gray;
    std::vector<std::vector<cv::Point>> contours;

    // find squares in every color plane of the image
    for (int c = 0; c < 3; c++)
    {
        int ch[] = {c, 0};
        mixChannels(&blurred, 1, &gray0, 1, ch, 1);

        // try several threshold levels
        const int threshold_level = 2;
        for (int l = 0; l < threshold_level; l++)
        {
            // Use Canny instead of zero threshold level!
            // Canny helps to catch squares with gradient shading
            if (l == 0)
            {
                Canny(gray0, gray, 10, 20, 3); //

                // Dilate helps to remove potential holes between edge segments
                dilate(gray, gray, cv::Mat(), cv::Point(-1, -1));
            }
            else
            {
                gray = gray0 >= (l + 1) * 255 / threshold_level;
            }

            // Find contours and store them in a list

            findContours(gray, contours, cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);
            // Test contours
            std::vector<cv::Point> approx;
            for (size_t i = 0; i < contours.size(); i++)
            {
                // approximate contour with accuracy proportional
                // to the contour perimeter
                approxPolyDP(cv::Mat(contours[i]), approx, arcLength(cv::Mat(contours[i]), true) * 0.02, true);

                // Note: absolute value of an area is used because
                // area may be positive or negative - in accordance with the
                // contour orientation
                if (approx.size() == 4 &&
                    fabs(cv::contourArea(cv::Mat(approx))) > 1000 &&
                    cv::isContourConvex(cv::Mat(approx)))
                {
                    double maxCosine = 0;

                    for (int j = 2; j < 5; j++)
                    {
                        double cosine = fabs(angle(approx[j % 4], approx[j - 2], approx[j - 1]));
                        maxCosine = MAX(maxCosine, cosine);
                    }

                    if (maxCosine < 0.3)
                        squares.push_back(approx);
                }
            }
        }
    }
}
