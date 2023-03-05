#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#include <cstring>
#include <iostream>
#include <opencv2/opencv.hpp>
#include <math.h>
#include <stdio.h>


double angle(cv::Point pt1, cv::Point pt2, cv::Point pt0)
{
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    
    return (dx1 * dx2 + dy1 * dy2) / sqrt((dx1 * dx1 + dy1 * dy1) * (dx2 * dx2 + dy2 * dy2) + 1e-10);

}


cv::Mat getPerspective(cv::Mat inMat, cv::Mat outMat, std::vector<cv::Point> corners) {

    auto destinationCorners = [](std::vector<cv::Point> sortedCorners)
    {
        std::vector<cv::Point2f> arr;

        auto getDist = [](cv::Point a, cv::Point b)
        {
            return cv::norm(a - b);
        };

        double maxWidth = getDist(sortedCorners[0], sortedCorners[1]) > getDist(sortedCorners[2], sortedCorners[3])
                              ? getDist(sortedCorners[0], sortedCorners[1])
                              : getDist(sortedCorners[2], sortedCorners[3]);

        double maxHight = getDist(sortedCorners[0], sortedCorners[2]) > getDist(sortedCorners[1], sortedCorners[3])
                              ? getDist(sortedCorners[0], sortedCorners[2])
                              : getDist(sortedCorners[1], sortedCorners[3]);


        
        arr.push_back(cv::Point2f(0, 0));
        arr.push_back(cv::Point2f(maxWidth, 0));
        arr.push_back(cv::Point2f(0, maxHight));
        arr.push_back(cv::Point2f(maxWidth, maxHight));

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


    auto m = cv::getPerspectiveTransform(helper(corners),
                                         destinationCorners(corners));

    std::cout << corners.size() << std::endl;
    destinationCorners(corners);
    auto imgSize = cv::Size(cvRound(destinationCorners(corners)[3].x),
                            cvRound(destinationCorners(corners)[3].y));
    
    cv::warpPerspective(inMat, outMat, m, imgSize);
    return outMat;
}

std::vector<cv::Point> sortPoint(std::vector<cv::Point> inPoints){
    auto map = [](std::vector<cv::Point> ele)
        {
            std::vector<cv::Point> res;
            for (size_t i = 0; i < ele.size(); i++)
            {
                res.push_back(ele.at(i));
            }
            return res;
        };


    std::vector<cv::Point> topP;
    std::vector<cv::Point> bottomP;


    auto temp = map(inPoints);
    std::cout << temp <<std::endl;
    std::sort(temp.begin(), temp.end(), [](cv::Point ele1, cv::Point ele2){ return ele1.y<ele2.y;});

    std::cout << temp <<std::endl;
    
   
    topP.push_back(temp[0]);
    topP.push_back(temp[1]);

    bottomP.push_back(temp[2]);
    bottomP.push_back(temp[3]);

    std::sort(topP.begin(), topP.end(), [](cv::Point ele1, cv::Point ele2){return ele1.x < ele2.x;});
    std::sort(bottomP.begin(), bottomP.end(), [](cv::Point ele1, cv::Point ele2){return ele1.x < ele2.x;});
    

    topP.push_back(bottomP[0]);
    topP.push_back(bottomP[1]);


    angle(topP[0],topP[1],topP[2]);
    return topP;
}



EXPORT
void p1(char * inPath, char * outPath)
{
    cv::Mat inMat = cv::imread(inPath);



    cv::Mat mat;
    cv::Mat kernel(3, 3, CV_8UC1, cv::Scalar(1));

    cv::morphologyEx(inMat, mat, cv::MORPH_CLOSE, kernel, cv::Point(-1, 1), 5);

    cv::cvtColor(mat, mat, cv::COLOR_BGR2GRAY);
    cv::GaussianBlur(mat, mat, cv::Size2d(11, 11), 0);
    cv::Canny(mat, mat, 0, 200);
    cv::dilate(mat, mat, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

    
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mat, contours, cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);

    std::sort(contours.begin(), contours.end(), 
    [] (std::vector<cv::Point> ele1, std::vector<cv::Point> ele2){
        return ele1.size() > ele2.size() ? true : false;

    });

  
    cv::drawContours(inMat, contours, 0, cv::Scalar(0, 255, 255), 30);
    
    std::vector<cv::Point> corners;

   
    for (size_t i = 0; i < contours.size(); i++){
        cv::approxPolyDP(contours[i], 
        corners, 
        arcLength(cv::Mat(contours[i]), true) * 0.02, 
        true);    

        std::cout << corners.size() << std::endl;
        if (corners.size() == 4) break;
    }
    
    
    corners = sortPoint(corners);


    for (size_t i = 0; i < corners.size(); i++)
    {
        auto s = std::to_string(i);
        cv::circle(inMat, corners[i], 60, cv::Scalar(0,255,0), 5);
        cv::putText(inMat, s,corners[i], cv::FONT_HERSHEY_PLAIN, 5, cv::Scalar(255,255,0), 5);
    }
    

    inMat = getPerspective(inMat, inMat, corners);
    

    cv::imwrite(outPath, inMat);
}

// --------------------------------------------------------------

EXPORT
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
        approxPolyDP(cv::Mat(contours[i]), approx, arcLength(cv::Mat(contours[i]), true) * 0.02, true);
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

    cv::imwrite(outPath, countourImg);
}


extern "C" __attribute__((visibility("default"))) __attribute__((used))
void cvCorner(char *inPath, char *outPath, int tlx, int tly, int trx, int _try, int blx, int bly, int brx, int bry)
{
    cv::Mat inMat = cv::imread(inPath);

    std::vector<cv::Point> corners;

    corners.push_back(cv::Point(tlx, tly));
    corners.push_back(cv::Point(trx, _try));                                                                                          
    corners.push_back(cv::Point(blx, bly));                                                                                           
    corners.push_back(cv::Point(brx, bry));                                                                                           
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      
    cv::Mat outMat = getPerspective(inMat, inMat, corners);                                                                          
    cv::imwrite(outPath, outMat);                                                                                                     
}  