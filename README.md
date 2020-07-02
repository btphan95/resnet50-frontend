![alt text](https://github.com/btphan95/resnet-is-awesome/blob/master/assets/preview.png?raw=true)

[<img src="https://img.shields.io/badge/live-demo-blueviolet?style=for-the-badge&logo=appveyor?">](http://resnet.surge.sh)


A web app demoing ResNet50, built using the [Flutter](https://flutter.dev/) UI toolkit.

ResNet50 is a deep learning model trained on the ImageNet dataset. This model is [imported from TensorFlow / Keras](https://keras.io/api/applications/resnet/#resnet50-function). 

The model is served over a [Flask](https://flask.palletsprojects.com/en/1.1.x/) web server and then powered by a stateless [Docker container](https://www.docker.com/resources/what-container) on [Google Cloud Run](https://cloud.google.com/run).

To see how this is implemented, see my repo [resnet-flask](https://github.com/btphan95/resnet-flask) for the backend infrastructure.

Feedback is greatly appreciated!

A huge thanks to [Felix Blaschke](https://github.com/felixblaschke) for the Particle background and [Rodolfo Hernandez](https://github.com/rjcalifornia) for the image upload concept via Flutter.
