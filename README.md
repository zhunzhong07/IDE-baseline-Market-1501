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

### Installation (sufficient for the demo)

1. Clone the IDE repository
  ```Shell
  # Make sure to clone with --recursive
  git clone --recursive https://github.com/zhunzhong07/Market-IDE-baseline.git
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
    1. Please download the pre-trained imagenet models and put it in the "data/imagenet_models" folder.
    2. Please download Market-1501 dataset and unzip it in the "market_evaluation/dataset" folder.
    3. Please download the pre-trained IDE models and put it in the "out_put/market_train" folder.
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
  
2. Feature Extraction
     ```Shell
    Run Matlab: extract_feat_CaffeNet.m  or extract_feat_ResNet_50.m
    ```

3. Evaluation
     ```Shell
    Run Matlab: baseline_evaluation_ide_CaffeNet.m  or baseline_evaluation_ide_ResNet_50.m
    ```
    
    
### Results
You can reproduce the results as follows:

-----------------    IDE  | IDE+XQDA | IDE+KISSME | 

CaffeNet   |Rank@1|59.53% |  62.00%  |  61.02% 

CaffeNet   | mAP  |32.85% |  37.55%  |  36.72%
           
ResNet_50  |Rank@1|75.62% |  76.01%  |  77.52%

ResNet_50  | mAP  |50.68% |  52.98%  |  53.88%
           

### Contact us

If you have any questions about this code, please do not hesitate to contact us.

[Zhun Zhong](http://zhunzhong.site)

[Liang Zheng](http://liangzheng.com.cn)
   
