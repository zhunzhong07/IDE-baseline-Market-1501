# Code for IDE baseline on Market-1501
=============
This code was used for experiments with ID-discriminative Embedding (IDE) for Market-1501 dataset.

Thanks Liboyue, give us suggestions for improvement.

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
  
- [Pre-trained imagenet models](https://pan.baidu.com/s/1o7YZT8Y)
  
- [Market-1501](https://pan.baidu.com/s/1ntIi2Op)


### Training and testing IDE model

1. Training 
  ```Shell
  cd $IDE_ROOT
  # train IDE on CaffeNet
  ./experiments/market/train_IDE_CaffeNet.sh  
  # train IDE ResNet_50
  ./experiments/market/train_IDE_ResNet_50.sh
  # The IDE models are saved under: "out/market_train"
  # If you encounter this problem: bash: ./experiments/market/train_IDE_CaffeNet.sh: Permission denied
  # Please execute: chmod 777 -R experiments/
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
You can download our pre-trained IDE models and IDE features, and put them in the "out_put/market_train"  and "market_evaluation/feat" folder, respectively. 

- [IDE models](https://pan.baidu.com/s/1gfE5EAf) 

- [IDE features](https://pan.baidu.com/s/1bI3yqU)


Using the models and features above, you can reproduce the results as follows:

|Methods |   Rank@1 | mAP|
| --------   | -----  | ----  |
|IDE_CaffeNet + Euclidean  | 59.53% | 32.85%|
|IDE_CaffeNet + XQDA       | 62.00% | 37.55%|
|IDE_CaffeNet + KISSME     | 61.02% | 36.72%|
|IDE_ResNet_50 + Euclidean | 75.62% | 50.68%|
|IDE_ResNet_50 + XQDA      | 76.01% | 52.98%|
|IDE_ResNet_50 + KISSME    | 77.52% | 53.88%|

If you add a dropout = 0.5 layer after pool5, you will get a better performance for ResNet_50:

|Methods |   Rank@1 | mAP|
| --------   | -----  | ----  |
|IDE_ResNet_50 + dropout(0.5) + Euclidean | 78.92% | 55.03%|
|IDE_ResNet_50 + dropout(0.5) + XQDA      | 77.35% | 56.01%|
|IDE_ResNet_50 + dropout(0.5) + KISSME    | 78.80% | 56.13%|


### Contact us

If you have any questions about this code, please do not hesitate to contact us.

[Zhun Zhong](http://zhunzhong.site)

[Liang Zheng](http://liangzheng.com.cn)
   
### Related Repos
Furthermore, you may check the following codes.
1. [re-ranking](https://github.com/zhunzhong07/person-re-ranking)
2. [2stream Network for reID](https://github.com/layumi/2016_person_re-ID)
3. [Person re-ID with GAN](https://github.com/layumi/Person-reID_GAN)
4. [Pedestrian Alignment Network](https://github.com/layumi/Pedestrian_Alignment)
5. [Random-Erasing](https://github.com/zhunzhong07/Random-Erasing)
