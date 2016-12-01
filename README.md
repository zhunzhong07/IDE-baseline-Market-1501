# Code for IDE baseline on Market Person Re-identification Dataset
=============
This code was used for experiments with IDE for Market dataset.

### Requirements: Caffe

Requirements for `Caffe` and `matcaffe` (see: [Caffe installation instructions](http://caffe.berkeleyvision.org/installation.html))

### Installation (sufficient for the demo)

1. Clone the IDE repository
  ```Shell
  # Make sure to clone with --recursive
  git clone --recursive https://github.com/rbgirshick/py-faster-rcnn.git
  ```

2. Build Caffe and matcaffe
    ```Shell
    cd $IDE_ROOT/caffe
    # Now follow the Caffe installation instructions here:
    #   http://caffe.berkeleyvision.org/installation.html
    make -j8 && make matcaffe
    ```

3. Download pre-computed models and Market-1501 dataset
    ```Shell
    models:
    Market-1501 dataset:
    ```
    
    
### Installation for training and testing IDE model

1. Training
  ```Shell
  # Make sure to clone with --recursive
  cd IDE_ROOT
  For CaffeNet
  ./experiments/market/train_IDE_CaffeNet.sh  
  For ResNet_50
  ./experiments/market/train_IDE_ResNet_50.sh
  ```
  
 2. Testing

   
