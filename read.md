### Build docker image
```
sudo docker build -t jupyterlab-sparkml:1.0.0 .
```

### Run docker image into container. 
```
sudo docker run -it --name jupyterlab-sparkml --volume=/home/ubuntu/data:/playground/data -p 8789:8789 --gpus all --rm jupyterlab-sparkml:1.0.0
```