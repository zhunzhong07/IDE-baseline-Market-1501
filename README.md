# Code for IDE baseline on Market-1501
=============
This code was used for experiments with ID-discriminative Embedding (IDE) for Market-1501 dataset.

If you find this code useful in your research, please consider citing:

    @article{zheng2016person,
    title={Person Re-identification: Past, Present and Future},
    author={Zheng, Liang and Yang, Yi and Hauptmann, Alexander G},
    journal={arXiv preprint arXiv:1610.02984},
    year={2016}
    }
    
    @inproceedings{zheng2015scalable,
    title={Scalable Person Re-identification: A Benchmark},
    author={Zheng, Liang and Shen, Liyue and Tian, Lu and Wang, Shengjin and Wang, Jingdong and Tian, Qi},
    booktitle={Computer Vision, IEEE International Conference on},
    year={2015}
    }


### Requirements: Caffe

Requirements for `Caffe` and `matcaffe` (see: [Caffe installation instructions](http://caffe.berkeleyvision.org/installation.html))

### Installation
1. Clone the IDE repository
  ```Shell
  # Make sure to clone with --recursive
  git clone --recursive https://github.com/zhunzhong07/IDE-baseline-Market-1501
  ```

2. Build Caffe and matcaffe
    ```Shell
    cd $IDE_ROOT/caffe
    # Now follow the Caffe installation instructions here:
    # http://caffe.berkeleyvision.org/installation.html
    make -j8 && make matcaffe
    ```

3. Download pre-computed models and Market-1501 dataset
  ```Shell
  Please download the pre-trained imagenet models and put it in the "data/imagenet_models" folder.
  Please download Market-1501 dataset and unzip it in the "market_evaluation/dataset" folder. 
  ```
  
  [Imagenet models](https://pan.baidu.com/s/1o7YZT8Y).
  
  [Market-1501](https://pan.baidu.com/s/1ntIi2Op)

### Training and testing IDE model

1. Training 
  ```Shell
  cd $IDE_ROOT
  # train IDE on CaffeNet
  ./experiments/market/train_IDE_CaffeNet.sh  
  # train IDE ResNet_50
  ./experiments/market/train_IDE_ResNet_50.sh
  # The IDE models are saved under: "out/market_train"
  ```
  
2. Feature Extraction
     ```Shell
    cd $IDE_ROOT/market_evaluation
    Run Matlab: extract_feature.m
    # The IDE features are saved under: "market_evaluation/feat"
    ```

3. Evaluation
     ```Shell
    Run Matlab: baseline_evaluation_IDE.m
    ```

### Results
You can download our pre-trained IDE models and IDE features, and put them in the "out_put/market_train"  and "market_evaluation/feat" folder, respectively. [IDE models](https://pan.baidu.com/s/1gfE5EAf) [IDE features](https://pan.baidu.com/s/1bI3yqU)

Using the models and features above, you can reproduce the results as follows:

-----------------    IDE  | IDE+XQDA | IDE+KISSME | 

CaffeNet   |Rank@1|59.53% |  62.00%  |  61.02% 

CaffeNet   | mAP  |32.85% |  37.55%  |  36.72%
           
ResNet_50  |Rank@1|75.62% |  76.01%  |  77.52%

ResNet_50  | mAP  |50.68% |  52.98%  |  53.88%
           

### Contact us

If you have any questions about this code, please do not hesitate to contact us.

[Zhun Zhong](http://zhunzhong.site)

[Liang Zheng](http://liangzheng.com.cn)
   
