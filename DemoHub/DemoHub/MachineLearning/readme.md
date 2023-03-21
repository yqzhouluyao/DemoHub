#  机器学习的Model使用及训练模型



### MachineLearningViewController中使用模型识别物品的步骤：



##### 1、访问设备的相机或照片库以捕捉或选择图像



##### 2、将UIImage转成CIImage 以供机器学习模型 处理



##### 3、从bundle里面懒加载训练机器学习模型， VNCoreMLModel 加载预训练的机器学习模型，该模型将 Core ML 模型作为输入



##### 4、创建执行 对象识别的请求



##### 5、该请求配置为返回 VNClassificationObservation 对象，其中包含有关预测对象类及其相关置信度分数的信息。





### 如何创建一个图像分类的模型？

##### 训练的素材库：

https://wolverine.raywenderlich.com/books/mlt/snacks.zip



##### 这里面有具体的步骤：

https://developer.apple.com/documentation/createml/creating-an-image-classifier-model



