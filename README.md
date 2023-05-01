# SheetCutter
Sheet Cutter is a Flutter app that allows you to edit images natively using the C++ OpenCV Library. The app is available online and on Linux, and includes its own web server for easy sharing of edited files over a hotspot.
- ![output](https://user-images.githubusercontent.com/48091139/235527158-8db5cca7-0040-4910-a65f-38d40921772c.gif)
![output2](https://user-images.githubusercontent.com/48091139/235528923-f4d8eaf9-5834-4630-adc5-2526b50b4855.gif)



# Features
- Upload images to the app's UI and edit them using OpenCV Library.
- Run the app on Linux and the apps server first tests on (IOS).
- Use the app's web server to share edited files over a hotspot.
- Enjoy a consistent UI across all platforms, thanks to Flutter.

# Getting Started
To get started with Sheet Cutter, simply visit our website and start using the app right away! Alternatively, you can run the app on Linux by following these steps:
## Method 1: Run on Linux
1. Clone the repository to your local machine.
2.Install Flutter and the OpenCV Library.
3. Run the app using the Flutter command-line interface.
## Method 2: Run on Docker
Clone the repository to your local machine.

1. Install Docker.

2. Build the Docker image using the following command:
```
docker build -t sheet-cutter .
```
4.
```
docker run -p 8080:8080 sheet-cutter
```
This will start the Sheet Cutter web server on port 8080 of your local machine.
# Demo
You can see a demo of Sheet Cutter on our website at https://server-ooxa7yxd6a-lm.a.run.app/#/.

# Licnse
Sheet Cutter is licensed under the MIT License. Feel free to use and modify the app as you see fit.

