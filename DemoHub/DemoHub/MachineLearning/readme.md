#  机器学习的Model使用及训练模型



### 使用模型识别物品：

1、首先获取相册、相机的访问权限，选取照片或拍照成功后获取到图片

2、把图片及其方向通过API接口传给Apple 自带的Vision Framework 

3、获取VNCoreMLRequest，根据加载的训练模型，回调请求模型的结果

4、获取模型识别的结果，显示对应的物品名及概率